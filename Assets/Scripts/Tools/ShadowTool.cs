using UnityEngine;
using System.Collections.Generic;
using Leap;
public class ShadowTool : ManipulationHandTool 
{	


	public float MinActivationVelocity = 100.0f;
	GameObject gizmo;
	public override void Start () {
		name = "shadow";
		workingHandIdx = 0;
		base.Start();
		mode = HandTool.HandToolMode.Enabled;

		gizmo = GameObject.CreatePrimitive(PrimitiveType.Sphere);
		gizmo.transform.localScale = new Vector3(0.2f,0.2f,0.2f);

		//deactivatePalm();
	}
	
	public override void CostumGUI(){
		GUILayout.TextField( "num selected vertices: " + selectedVertices.Count);
		GUILayout.TextField( "recursion counter: " + debugRecursionCount);
		GUILayout.TextField( "min distance: " + minDistance);
	}


	public override void ManipulateVertices(Bounds toolBounds, Transform transform)
	{

		foreach(int v_idx in selectedVertices.Keys ){
			// float distance = selectedVertices[v_idx];
			Vector3 vertex = transform.TransformPoint( vertices[v_idx] );

//			vertex += palm.transform.up * 0.2f * Time.deltaTime;
//
//			Node containerNode = octree.taggedVertices[v_idx];
//			if(! containerNode.bounds.Contains(vertex) ){
//
//				containerNode.bounds.Encapsulate(vertex);
//
////				containerNode.parent.bounds.Encapsulate(containerNode.bounds);
//				Node parent = containerNode.parent;
//				while(parent != parent.parent){
//					parent.parent.bounds.Encapsulate(parent.bounds);
//					parent = parent.parent;
//				}
//				octree.root.bounds.Encapsulate(parent.bounds);
//			} 

//			// -- begin manipulation vertex:
//			// flatten:
//			float distanceFromHitPlane = MathHelper.SignedDistancePlanePoint(hit.normal.normalized, hit.point, vertex);
//			
//			
//			Vector3 direction = hit.normal.normalized * distanceFromHitPlane - hit.normal.normalized * maxDistanceFromHit;
//			vertex -= direction * strength * Time.deltaTime;
			
			//			Debug.DrawLine(vertex,vertex + direction, Color.cyan);
			
			// ---- end manipulation vertex
			colors[v_idx] = ManipulationColor();
			vertices[v_idx] = transform.InverseTransformPoint(vertex);
		}
		PushMeshData();

	}


	public  void ManipulateVertices(RaycastHit hit, float radius){
		foreach(int v_idx in selectedVertices.Keys ){
			// float distance = selectedVertices[v_idx];
			Vector3 vertex = hit.transform.TransformPoint( vertices[v_idx] );

			// -- begin manipulation vertex:
			// flatten:
			float distanceFromHitPlane = MathHelper.SignedDistancePlanePoint(hit.normal.normalized, hit.point, vertex);


			Vector3 direction = hit.normal.normalized * distanceFromHitPlane - hit.normal.normalized * maxDistanceFromHit;
			vertex -= direction * strength * Time.deltaTime;

//			Debug.DrawLine(vertex,vertex + direction, Color.cyan);

			// ---- end manipulation vertex
			colors[v_idx] = ManipulationColor();
			vertices[v_idx] = hit.transform.InverseTransformPoint(vertex);
		}
		PushMeshData();
	}


	public override void Update ()
	{
		base.Update();

		if( ! hand.IsValid 
		   || HandTool.HandToolMode.Disabled == mode)
		{
			return; // --- OUT --->
		}



		toolBounds.extents = palm.transform.renderer.bounds.extents * radius;



//		ray = new Ray(octree.root.bounds.center,  palm.transform.position); // marc fragen
//		ray = new Ray(palm.transform.position, -palm.transform.up);


		Vector3 screenPoint = Camera.main.WorldToScreenPoint(palm.transform.position);
//		ray = Camera.main.ScreenPointToRay(screenPoint);


		ray = new Ray(octree.root.bounds.center,  palm.transform.position); // marc fragen

		Debug.DrawLine(ray.origin, ray.direction * 10, Color.green);

		SelectVertices(ray, octree.root);
//
//		if(palm.transform.position.magnitude < MinActivationDistance){
//			ManipulateVertices(toolBounds, target.transform);
//		}



	}





	public override void OnDestroy(){
		activatePalm();
		base.OnDestroy();
	}
}
