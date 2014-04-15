using UnityEngine;
using System.Collections.Generic;

namespace Sculpt{
	public enum Tool{
		BRUSH,
		DRAG,
		SMOOTH
	}
	public class Sculpter : MonoBehaviour {

		public static Color CLEAR = Color.white;
		public static Color SELECTED = Color.yellow;

		float radius = 1.0f;

		float detailSubdivision = 0.75f; //maximal edge length before we subdivide it
		float detailDecimation = 0.1f; //minimal edge length before we collapse it (dependent of detailSubdivision)

		float d2Min = 0.0f; 			// uniform refinement of mesh (min edge length)
		float d2Max = 0.0f; 			// uniform refinement of mesh (max edge length)
		float d2Thickness = 0.5f; 	// distance between 2 vertices before split/merge
		float d2Move = 0.0f; 		// max displacement of vertices per step

		List<int> iVertsSelected = new List<int>();
		List<int> iTrisSelected = new List<int>();
			

		public Tool tool;
		Ray ray = new Ray();
		SculptMesh sculptMesh;

		Camera camera;

		void OnDrawGizmos(){
			Gizmos.color = Color.green;
			Gizmos.DrawLine(ray.origin, ray.origin + ray.direction * 100);

		}

		// Use this for initialization
		void Start () {
			sculptMesh = GetComponent<SculptMesh>();
			tool = Tool.BRUSH;
			Debug.Log("sculpter");
			camera = Camera.main;
		}
		
		// Update is called once per frame
		void Update () {
		
			for(int i = 0; i < sculptMesh.colorArray.Length; i++){
				sculptMesh.colorArray[i] = CLEAR;
			}

			if( Input.GetKeyDown(KeyCode.H) )
			{
				sculptMesh.drawDebug = !sculptMesh.drawDebug;
			}

			if( Input.GetKeyDown(KeyCode.Plus) )
			{
				radius += 0.05f;
			}
			if( Input.GetKeyDown(KeyCode.Minus) )
			{
				radius -= 0.05f;
				if(radius < 0) radius = 0.05f;
			}

			bool rotate = false;
			float angle = 5;
			float rotationSpeed = 10;
			Vector3 axis = camera.transform.up;
			if(Input.GetKey(KeyCode.LeftArrow)){
				rotate = true;
			}
			if(Input.GetKey(KeyCode.RightArrow)){
				rotate = true;
				angle = -angle;
			}

			if(Input.GetKey(KeyCode.UpArrow)){
				rotate = true;
				axis = camera.transform.right;
			}
			if(Input.GetKey(KeyCode.DownArrow)){
				rotate = true;
				axis = camera.transform.right;
				angle = -angle;
			}


			if(rotate){
				camera.transform.RotateAround(sculptMesh.transform.position, axis, rotationSpeed * angle * Time.deltaTime);
			}

//			if(Input.GetMouseButtonDown(0))
			{

				Vector3 mousePos = Input.mousePosition;
				ray = camera.ScreenPointToRay(mousePos);
				sculptMesh.intersectRayMesh(ray);
//				this.radius = 1.0f;


				List<int> pickedVertices = sculptMesh.pickVerticesInSphere(this.radius);
				Vector3 center = sculptMesh.intersectionPoint;
				float intensity = 1.0f;
//				if(Input.GetMouseButton(0) )
				{
					sculpt(camera.transform.forward, pickedVertices, 
				       sculptMesh.intersectionPoint, sculptMesh.worldRadiusSqr, intensity,this.tool);
				}
			}
			sculptMesh.pushMeshData();
		}

		public void setAdaptiveParameters(float radiusSquared)
		{
			this.d2Max = radiusSquared * (1.1f - this.detailSubdivision) * 0.2f;
			this.d2Min = this.d2Max / 4.2025f;
			this.d2Move = this.d2Min * 0.2375f;
			this.d2Thickness = (4.0f * this.d2Move + this.d2Max / 3.0f) * 1.1f;
		}
		
		
		public void sculpt(Vector3 eyeDir, List<int> pickedVertices, Vector3 center, float radius, float intensity, Sculpt.Tool tool){

			long vertexSculptMask = Vertex.SculptMask;

			List<int> iVertsInRadius = new List<int>();
			List<int> iVertsInFront = new List<int>();



			this.iVertsSelected = pickedVertices;
			this.iTrisSelected = sculptMesh.getTrianglesFromVertices(iVertsSelected);
			int nbVertsSelected = pickedVertices.Count;

//			setAdaptiveParameters(radius);

			// topology here....


			for(int i = 0; i < nbVertsSelected; i++){
				int idx = iVertsSelected[i];


				if(sculptMesh.vertices[idx].sculptFlag == vertexSculptMask){
					iVertsInRadius.Add(idx);



					Vector3 v = transform.TransformPoint(sculptMesh.vertexArray[idx]);
					Vector3 n = transform.TransformPoint(sculptMesh.normalArray[idx]);
					if(Vector3.Dot(eyeDir, n) <= 0.0f ){
						iVertsInFront.Add(idx);
//						Debug.DrawLine(sculptMesh.intersectionPoint, v, Color.red);
					}else{
//						Debug.DrawLine(sculptMesh.intersectionPoint, v, Color.cyan);
					} 
				}
			}

			if(iVertsInFront.Count > 0){
				switch(tool){
				case Tool.BRUSH:
					brush(center, iVertsInRadius, iVertsInFront, radius, intensity);
					break;
				case Tool.DRAG:
					break;
				case Tool.SMOOTH:
					break;
				}
			}
			sculptMesh.updateMesh(iTrisSelected, iVertsSelected);
		}

		/** Brush stroke, move vertices along a direction computed by their averaging normals */
		public void brush(Vector3 center, List<int> iVertsInRadius, List<int> iVertsFront, float radius, float intensity){
			Vector3 aNormal = sculptMesh.areaNormal(iVertsFront);
			Vector3 aCenter = sculptMesh.areaCenter(iVertsFront);
//			Debug.DrawLine(sculptMesh.intersectionPoint, aCenter, Color.cyan);

			float deformIntensityBrush = intensity * radius * 0.1f;
			float deformIntensityFlatten = intensity * 0.3f;

			int nbVerts = iVertsFront.Count;
			for(int i = 0; i < nbVerts; i++){
				int v_idx = iVertsFront[i];
				Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
				Vector3 delta = v - center;

				float distanceToPlane = (v.x - aCenter.x) * aNormal.x + (v.y - aCenter.y) * aNormal.y + (v.z - aCenter.z) * aNormal.z;
				float dist = delta.magnitude/radius;
				float fallOff = dist * dist;

				fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
				fallOff = fallOff * (distanceToPlane * deformIntensityFlatten - deformIntensityBrush);

				if(Input.GetMouseButton(0) ){
					v -= aNormal * fallOff;
				}

				sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
				sculptMesh.colorArray[v_idx] = SELECTED;
			}

		}



	}
}
