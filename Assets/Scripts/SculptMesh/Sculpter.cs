using UnityEngine;
using System.Collections.Generic;

namespace Sculpt{
	public enum Tool{
		BRUSH,
		DRAG,
		SMOOTH
	}
	public class Sculpter : MonoBehaviour {

		public static Color CLEAR = new Color(0.5f,0.5f,0.5f,0.9f);
		public static Color SELECTED = (CLEAR + Color.yellow) * 0.5f;
		public static Color ACTIVATED = (CLEAR + Color.red) * 0.5f;

		public bool isEnabled;

		public float radius = 1.0f;
		public float intensity = 0.5f;




		public List<int> iVertsSelected = new List<int>();
		public List<int> iTrisSelected = new List<int>();
		List<int> pickedVertices = new List<int>();

		Topology topo;

		public Tool tool;
		Ray ray = new Ray();
		public Vector3 dragDir = Vector3.zero;
		Vector3 dragInitPos;
		Vector3 center;
		SculptMesh sculptMesh;

		public bool activated;

		Camera mainCamera;

		Vector3 gizmoPos = Vector3.zero;
		float gizmoRadius = 1.0f;

		float d2Min = 0.0f; //uniform refinement of mesh (min edge length)
		float d2Max = 0.0f; //uniform refinement of mesh (max edge length)
		float d2Thickness = 0.5f; //distance between 2 vertices before split/merge
		float d2Move = 0.0f; //max displacement of vertices per step
		float detailSubdivision = 0.75f; //maximal edge length before we subdivide it
		float detailDecimation = 0.1f; //minimal edge length before we collapse it (dependent of detailSubdivision_)



		void OnDrawGizmos(){
//			Gizmos.color = Color.green;
//			Gizmos.DrawLine(ray.origin, ray.origin + ray.direction * 100);

//			Gizmos.DrawWireSphere(gizmoPos, gizmoRadius);


		}

		// Use this for initialization
		void Start () {
			sculptMesh = GetComponent<SculptMesh>();
			tool = Tool.DRAG;
			Debug.Log("sculpter");
			mainCamera = Camera.main;

			topo = new Topology(sculptMesh);
		}

		/** Set adaptive parameters */
	 	void setAdaptiveParameters(float radiusSquared)
		{
			this.d2Max = radiusSquared * (1.1f - this.detailSubdivision) * 0.2f;
			this.d2Min = this.d2Max / 4.2025f;
			this.d2Move = this.d2Min * 0.2375f;
			this.d2Thickness = (4.0f * this.d2Move + this.d2Max / 3.0f) * 1.1f;
		}

		void rotate(){
			bool rotate = false;
			float angle = 5;
			float rotationSpeed = 10;
			Vector3 axis = mainCamera.transform.up;
			if(Input.GetKey(KeyCode.LeftArrow)){
				rotate = true;
			}
			if(Input.GetKey(KeyCode.RightArrow)){
				rotate = true;
				angle = -angle;
			}
			
			if(Input.GetKey(KeyCode.UpArrow)){
				rotate = true;
				axis = mainCamera.transform.right;
			}
			if(Input.GetKey(KeyCode.DownArrow)){
				rotate = true;
				axis = mainCamera.transform.right;
				angle = -angle;
			}
			if(rotate){
				mainCamera.transform.RotateAround(sculptMesh.transform.position, axis, rotationSpeed * angle * Time.deltaTime);
			}
		}


		public void clear(){
			for(int i = 0; i < sculptMesh.colorArray.Length; i++){
				sculptMesh.colorArray[i] = CLEAR;
			}

		}

		void Update () {
		
			if(!isEnabled)return; //  >---OUT--->


			clear();

			// handle input

			Vector3 mousePos = Input.mousePosition;


			if(Input.GetMouseButtonDown(0)){
				Debug.Log("DRAG started");
				this.dragInitPos = mousePos;
			}

			if(Input.GetMouseButtonUp(0)){
				Debug.Log("DRAG ended");
			}
			
			if(Input.GetMouseButton(0) ){
				this.activated = true;
			}else{
				this.activated = false;
			}

//			if( Input.GetKeyDown(KeyCode.D) )
//			{
//				sculptMesh.drawDebug = !sculptMesh.drawDebug;
//			}

			if( Input.GetKeyDown(KeyCode.Plus) )
			{
				radius += 0.05f;
			}
			if( Input.GetKeyDown(KeyCode.Minus) )
			{
				radius -= 0.05f;
				if(radius < 0) radius = 0.05f;
			}

			rotate();
//			


			this.ray = mainCamera.ScreenPointToRay(mousePos);

			bool dragging = false;
			if(this.tool == Tool.DRAG && activated){
				dragging = true;
//				Debug.Log("dragging");
			}



			center = sculptMesh.intersectionPoint;
			sculptMesh.intersectRayMesh(ray);
			float r = this.radius; // * (mainCamera.fieldOfView/180.0f); // scale the radius depending on "distance"
			pickedVertices = sculptMesh.pickVerticesInSphere(r);

			Debug.Log("picked verticec" + pickedVertices.Count);
			if(pickedVertices.Count > 0){
				gizmoPos = sculptMesh.intersectionPoint;
				gizmoRadius = radius;
			}else{
				gizmoPos = ray.origin + ray.direction;
				gizmoRadius = radius * radius / mainCamera.transform.position.magnitude;
			}

//			if(!dragging){
//				sculptMesh.intersectRayMesh(ray);
//				float r = this.radius; // * (mainCamera.fieldOfView/180.0f); // scale the radius depending on "distance"
//				pickedVertices = sculptMesh.pickVerticesInSphere(r);
//
//			}else{
//				updateDragDir();
//				center = sculptMesh.intersectionPoint;
//			}
//				this.radius = 1.0f;




//			Debug.DrawLine(mainCamera.transform.position, mouseWorldPos, Color.cyan);
//			Debug.DrawLine(center, center + dragDir, Color.cyan);

			sculpt(mainCamera.transform.forward, pickedVertices, 
			       center, sculptMesh.worldRadiusSqr, intensity,this.tool);

			sculptMesh.updateMesh(this.iTrisSelected, this.iVertsSelected, !dragging);

			sculptMesh.pushMeshData();
		}


		public void updateDragDir(){

			Vector3 ip = sculptMesh.intersectionPoint;
			Vector3 proj = MathHelper.ProjectPointOnLine(ray.origin, ray.direction, ip);
			this.dragDir = proj - ip;

			if(dragDir.magnitude < 0.2f){
				this.dragDir = Vector3.zero;
			}
			Debug.DrawLine(ip, proj, Color.green );
//			Debug.Log("drag dir:" + dragDir);

		}

		public void sculpt(Vector3 eyeDir, List<int> pickedVertices, Vector3 center, float radius, float intensity, Sculpt.Tool tool){

			long vertexSculptMask = Vertex.SculptMask;

			List<int> iVertsInRadius = new List<int>();
			List<int> iVertsInFront = new List<int>();



			this.iVertsSelected = pickedVertices;
			this.iTrisSelected = sculptMesh.getTrianglesFromVertices(iVertsSelected);
			int nbVertsSelected = pickedVertices.Count;



//			// topology here....
//			if(activated){
//				setAdaptiveParameters(radius*radius);
//				topo.center = sculptMesh.intersectionPoint;
//				Debug.DrawLine(mainCamera.transform.position,topo.center);
//				topo.Subdivision(iTrisSelected, d2Max);
//			}



			for(int i = 0; i < nbVertsSelected; i++){
				int idx = iVertsSelected[i];


				if(sculptMesh.vertices[idx].sculptFlag == vertexSculptMask){
					iVertsInRadius.Add(idx);

//					Vector3 v = transform.TransformPoint(sculptMesh.vertexArray[idx]);
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
					drag(center, this.dragDir, iVertsInFront, radius);
					break;
				case Tool.SMOOTH:
					smooth(iVertsInFront, intensity);
					break;
				}
			}

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

				if(this.activated)
				{
					Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
					Vector3 delta = v - center;
					
					float distanceToPlane = (v.x - aCenter.x) * aNormal.x + (v.y - aCenter.y) * aNormal.y + (v.z - aCenter.z) * aNormal.z;
					float dist = delta.magnitude/radius;
					float fallOff = dist * dist;
					
					fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
					fallOff = fallOff * (distanceToPlane * deformIntensityFlatten - deformIntensityBrush);

					v -= aNormal * fallOff * Time.deltaTime * 10;

					sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
					sculptMesh.colorArray[v_idx] = ACTIVATED;
				}else{
					sculptMesh.colorArray[v_idx] = Color.Lerp(SELECTED, ACTIVATED, intensity); // (SELECTED*(1-intensity) + ACTIVATED*intensity);
				}


			}
		}

		public void drag(Vector3 center, Vector3 dragDirection, List<int> iVerts,  float radius){
			int nbVerts = iVerts.Count;
			for(int i = 0; i < nbVerts; i++){
				int v_idx = iVerts[i];


				if(this.activated)
				{
					Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
					Vector3 delta = v - center;


					float dist = delta.magnitude/radius;
					float fallOff = dist * dist;
					
					fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;


					v += dragDirection * fallOff * Time.deltaTime;
					Debug.DrawLine(v, v + dragDirection * fallOff, Color.blue);

					sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
					sculptMesh.colorArray[v_idx] = ACTIVATED;
				}else{
					sculptMesh.colorArray[v_idx] = SELECTED;
				}



			}
			
		}

		/** Smooth a group of vertices. New position is given by simple averaging
		 *  used the laplasian algorithm from:
		 * http://wiki.unity3d.com/index.php?title=MeshSmoother
		 */
		public void smooth(List<int>iVerts, float intensity){
			int nbVerts = iVerts.Count;

			for (var i = 0; i < nbVerts; ++i){

				int v_idx = iVerts[i];
				if(this.activated)
				{
					Vector3 n = Vector3.zero;
					Vertex vertex = sculptMesh.vertices[v_idx];

					Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);

					if(vertex.ringVertices.Count > 0){
						for(int j = 0; j < vertex.ringVertices.Count; j++){
							Vector3 ringV = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[vertex.ringVertices[j]]); 
							n += ringV;
						}
						n *= 1.0f/vertex.ringVertices.Count;
						
						Vector3 d = (n - v) * intensity;
						v += d;
						
					}else{
						Debug.Log("vertex has no ring");
					}


					sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
					sculptMesh.colorArray[v_idx] = ACTIVATED;
				}else{
					sculptMesh.colorArray[v_idx] = Color.Lerp(SELECTED, ACTIVATED, intensity);
				}

			}

		}



		

	}
}
