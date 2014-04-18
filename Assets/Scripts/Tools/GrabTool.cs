
using UnityEngine;
using System.Collections.Generic;
using Leap;
using Sculpt;




public class GrabTool : ManipulationHandTool 
{	
	float radius;
	Vector3 grabInitPos = Vector3.zero;
	Dictionary<int, float> selectedVertices;
	public override void Start () {
		name = "grab";
		workingHandIdx = 0;
		base.Start();
		mode = HandTool.HandToolMode.Enabled;
		sculpter.tool = Sculpt.Tool.DRAG;
		selectedVertices = new Dictionary<int, float>();
	}


	public override void CostumGUI(){

	}

	public  void ManipulateVertices(Bounds toolBounds, Transform transform){
//		foreach(int v_idx in selectedVertices.Keys ){
//			float distance = selectedVertices[v_idx];
//			Vector3 vertex = transform.TransformPoint(vertices[v_idx]);
////			Vector3 vertex  = vertices[v_idx];
////			Vector3 localPalmPos = transform.InverseTransformPoint(palmPosition);
////			Vector3 localLastPalmPos = transform.InverseTransformPoint(lastPalmPosition);
//
////			Vector3 tmp = target.transform.localToWorldMatrix *  vertices[v_idx];
////			Vector3 vertex =  tmp + target.transform.position;
//
//			Vector3 moveDelta = (palmPosition -lastPalmPosition);
////			Vector3 moveDelta = (localPalmPos -localLastPalmPos);
//
//			float force = 1.0f - ( Mathf.Clamp01( distance / radius ) );
//
//			Vector3 direction = moveDelta * force * strength;
//			vertex += direction;
//			Debug.DrawLine(vertex, vertex+(direction* 4), Color.cyan, 0.2f);
////			Debug.DrawLine(vertex, palmPosition, Color.cyan);
//
//			// update octree:
//			Node containerNode = octree.taggedVertices[v_idx];
//			if( !containerNode.bounds.Contains(vertex) ){
//
//				containerNode.bounds.Encapsulate(vertex);
//
////				containerNode.parent.bounds.Encapsulate(containerNode.bounds);
//				Node parent = containerNode.parent;
//				while(parent.parent != parent.parent){
//					parent.parent.bounds.Encapsulate(parent.bounds);
//					parent = parent.parent;
//				}
//				octree.root.bounds.Encapsulate(parent.bounds);
//			} 
//
//
//
//			colors[v_idx] = ManipulationColor();
//
//			// transform vertex back
////			tmp = vertex - target.transform.position;
////			vertices[v_idx] = target.transform.worldToLocalMatrix * tmp;
//
//			vertices[v_idx] = transform.InverseTransformPoint(vertex);
////			vertices[v_idx] = vertex;
//
//		}
//		PushMeshData();
	}

	public void ManipulateVertices(float radius){
		foreach(int v_idx in selectedVertices.Keys ){
			float dist = selectedVertices[v_idx];

			Vector3 vertex =  target.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);

			Vector3 dragDirection = (palm.transform.position -lastPalmPosition);


			float fallOff = dist * dist;
			fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
			vertex += dragDirection * fallOff;

//			Debug.DrawLine(vertex, vertex+dragDirection);

			sculptMesh.colorArray[v_idx] = Sculpter.ACTIVATED;

			sculptMesh.vertexArray[v_idx] = target.transform.InverseTransformPoint(vertex);
		}

	}

	public override void Update () 
	{

		sculpter.clearColors();
		base.Update();
		
		if( !hand.IsValid || HandTool.HandToolMode.Disabled == mode)
		{
			selectedVertices.Clear();
			iVertsSelected.Clear();
			return; // --- OUT --->
		}


		if(hand.GrabStrength > 0.8 ){
			mode = HandToolMode.Manipulate;
			sculpter.activated = true;

			ray = new Ray(grabInitPos, palm.transform.position);
			sculpter.dragDir = ray.direction;
//			ray = new Ray(sculptMesh.intersectionPoint, palm.transform.position - lastPalmPosition);
			Debug.DrawLine(ray.origin, ray.origin + ray.direction, Color.blue);
			ManipulateVertices(radius);
		}else{

			mode = HandToolMode.Select;
			sculpter.activated = false;
			grabInitPos = palm.transform.position;
			Vector3 screenPoint = mainCamera.WorldToScreenPoint(palm.transform.position);
			ray = mainCamera.ScreenPointToRay(screenPoint);



//			if( target.renderer.bounds.Contains(palm.transform.position) ){
//				ray = new Ray(palm.transform.position, palm.transform.up);
//			}else{
//				ray = new Ray(palm.transform.position, -palm.transform.up);
//			}
			Debug.DrawRay(ray.origin, ray.direction, Color.red);


			sculptMesh.intersectRayMesh(ray);
			
			this.radius = sculpter.radius * hand.SphereRadius * Leap.UnityVectorExtension.ScaleFactor; // * (camera.fieldOfView/180.0f); // scale the radius depending on "distance"
			
			this.iVertsSelected = sculptMesh.pickVerticesInSphere(radius);
			selectedVertices.Clear();
			for(int i = 0; i < iVertsSelected.Count; i++){
				int v_idx = iVertsSelected[i];
				Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
				Vector3 delta = v - sculptMesh.intersectionPoint;
				
				float dist = delta.magnitude/radius;
				selectedVertices.Add(v_idx, dist);

				sculptMesh.colorArray[ iVertsSelected[i] ] = Sculpter.SELECTED;


			}
		}


//		Vector3 center = sculptMesh.intersectionPoint;
//		float intensity = sculpter.intensity;
//		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
//		                center, this.radius, intensity, sculpter.tool);
		
		sculptMesh.updateMesh(this.iTrisSelected, this.iVertsSelected, !sculpter.activated);
		
		sculptMesh.pushMeshData();


//		lastPalmPosition = palmPosition;
//		palmPosition = palm.transform.position;
////		palmPosition = palm.transform.renderer.bounds.extents * radius;
//
//
////		palmPosition = hand.PalmPosition.ToUnityTranslated();
//		//update radius:
////		radius = hand.SphereRadius * Leap.UnityVectorExtension.ScaleFactor;
//
//		toolBounds.extents = palm.transform.renderer.bounds.extents * radius;
//
//
////		if(fingerCount == 0) // hand is closed, manipulation here
//		if(hand.GrabStrength > 0.8f)
//		{ 
//			mode = HandToolMode.Manipulate;
//			// calculate hand hit
//			ManipulateVertices(toolBounds, target.transform);
////			ManipulateVertices(handhit, radius);
//			return; // ---- out --->
//		}
//
//
//
//		ray = new Ray(octree.root.bounds.center,  palm.transform.position);
//		SelectVertices(ray, octree.root);

	}

	public override void OnDestroy(){
		base.OnDestroy();
	}
}
