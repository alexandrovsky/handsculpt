
using UnityEngine;
using System.Collections.Generic;
using Leap;





public class GrabTool : ManipulationHandTool 
{	

//	Vector3 palmNormal = Vector3.zero;
	Vector3 palmPosition = Vector3.zero;
	Vector3 lastPalmPosition = Vector3.zero;
	float TIME_OUT_MAX_TIME  = 2.0f;
	float clearTimeOut = 2.0f;



	
	public override void Start () {
		name = "grab";
		workingHandIdx = 0;
		base.Start();
		mode = HandTool.HandToolMode.Enabled;
		radius = 1.0f;
		strength = 1.0f;
		clearTimeOut = TIME_OUT_MAX_TIME;
	}


	public override void CostumGUI(){

	}

	public override void ManipulateVertices(Bounds toolBounds, Transform transform){
		foreach(int v_idx in selectedVertices.Keys ){
			float distance = selectedVertices[v_idx];
			Vector3 vertex = transform.TransformPoint(vertices[v_idx]);
//			Vector3 vertex  = vertices[v_idx];
//			Vector3 localPalmPos = transform.InverseTransformPoint(palmPosition);
//			Vector3 localLastPalmPos = transform.InverseTransformPoint(lastPalmPosition);

//			Vector3 tmp = target.transform.localToWorldMatrix *  vertices[v_idx];
//			Vector3 vertex =  tmp + target.transform.position;

			Vector3 moveDelta = (palmPosition -lastPalmPosition);
//			Vector3 moveDelta = (localPalmPos -localLastPalmPos);

			float force = 1.0f - ( Mathf.Clamp01( distance / radius ) );

			Vector3 direction = moveDelta * force * strength;
			vertex += direction;
			Debug.DrawLine(vertex, vertex+(direction* 4), Color.cyan, 0.2f);
//			Debug.DrawLine(vertex, palmPosition, Color.cyan);

			// update octree:
			Node containerNode = octree.taggedVertices[v_idx];
			if( !containerNode.bounds.Contains(vertex) ){

				containerNode.bounds.Encapsulate(vertex);

//				containerNode.parent.bounds.Encapsulate(containerNode.bounds);
				Node parent = containerNode.parent;
				while(parent.parent != parent.parent){
					parent.parent.bounds.Encapsulate(parent.bounds);
					parent = parent.parent;
				}
				octree.root.bounds.Encapsulate(parent.bounds);
			} 



			colors[v_idx] = ManipulationColor();

			// transform vertex back
//			tmp = vertex - target.transform.position;
//			vertices[v_idx] = target.transform.worldToLocalMatrix * tmp;

			vertices[v_idx] = transform.InverseTransformPoint(vertex);
//			vertices[v_idx] = vertex;

		}
		PushMeshData();
	}

//	public void ManipulateVertices(RaycastHit hit, float radius){
//		foreach(int v_idx in selectedVertices.Keys ){
//			float distance = selectedVertices[v_idx];
//			Vector3 tmp = target.transform.localToWorldMatrix *  vertices[v_idx];
//			Vector3 vertex =  tmp + target.transform.position;
//
//			Vector3 moveDelta = (palmPosition -lastPalmPosition);
//
//
//			float force = 1.0f - ( Mathf.Clamp01( distance / radius ) );
//
//			Vector3 direction = moveDelta * force * strength;
//			vertex += direction;
//
//			colors[v_idx] = ManipulationColor();
//
//			// transform vertex back
//			tmp = vertex - target.transform.position;
//			vertices[v_idx] = target.transform.worldToLocalMatrix * tmp;
//		}
//		PushMeshData();
//	}

	public override void Update () 
	{

		Ray ray;
		if(Input.GetMouseButtonDown(0))
		{	
			ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			if(Physics.Raycast(ray, out handhit) ){
//				SelectVertices(handhit, radius);
//				Debug.DrawLine(ray.origin, ray.direction*100, Color.red, 2000.0f,false);
			}
		}


		base.Update();
		

		if(!hand.IsValid){
			return; // --- OUT --->
		}

		if(HandTool.HandToolMode.Disabled == mode){
			return;
		}
		// ---- out --->


		lastPalmPosition = palmPosition;
		palmPosition = palm.transform.position;
//		palmPosition = palm.transform.renderer.bounds.extents * radius;


//		palmPosition = hand.PalmPosition.ToUnityTranslated();
		//update radius:
//		radius = hand.SphereRadius * Leap.UnityVectorExtension.ScaleFactor;

		toolBounds.extents = palm.transform.renderer.bounds.extents * radius;


//		if(fingerCount == 0) // hand is closed, manipulation here
		if(hand.GrabStrength > 0.8f)
		{ 
			mode = HandToolMode.Manipulate;
			// calculate hand hit
			ManipulateVertices(toolBounds, target.transform);
//			ManipulateVertices(handhit, radius);
			return; // ---- out --->
		}



		ray = new Ray(octree.root.bounds.center,  palm.transform.position);
		SelectVertices(ray, octree.root);


//		if(Physics.Raycast(ray, out handhit) 
//		   && handhit.collider.tag  == "Touchable"
////		   && handhit.distance <= MinActivationDistance
////		   && palm.transform.position.magnitude < MinActivationDistance
//		   )
//		{
//
//
////			if(fingerCount >= 3) { // hand is open
//			if(hand.GrabStrength < 0.2f){
//				mode = HandToolMode.Select;
////				SelectVertices(handhit, radius);
//
//			}
//		}else{
//			if(clearTimeOut > 0.0f){
//				clearTimeOut -= Time.deltaTime;
//			}else {
//				clearTimeOut = TIME_OUT_MAX_TIME;
//				ClearSelection();
//			}
//		}
	}

	public override void OnDestroy(){
		base.OnDestroy();
	}
}
