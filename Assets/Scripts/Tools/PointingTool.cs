using UnityEngine;
using System.Collections;
using Leap;


public class PointingTool : ManipulationHandTool {


	const float POINTING_Z_OFFSET  = 1.0f;

	bool invert = false;


	public override void Start () {
		Debug.Log("pointig device started");
		name = "pointing";
		workingHandIdx = 0;
		base.Start();
		mode = HandTool.HandToolMode.Enabled;
		sculpter.tool = Sculpt.Tool.BRUSH;

	}



	public override void CostumGUI(){
		invert = GUILayout.Toggle(invert, "invert");
	}


	public override void Update () 
	{
		sculpter.clear();
		base.Update();

		if( ! hand.IsValid 
		   || HandTool.HandToolMode.Disabled == mode)
		{
			return; // --- OUT --->
		}


		Leap.Vector tipPos = hand.Fingers.Frontmost.StabilizedTipPosition;
		ray = CalculateRay(tipPos);


//		int fIdx = controller.IndexForFingerId(hand.Fingers.Frontmost.Id);
//		GameObject finger = controller.m_fingers[fIdx];
//		ray = new Ray(palm.transform.position, finger.transform.position);
//		Debug.DrawLine(palm.transform.position, finger.transform.position);

		if(tipPos.z + POINTING_Z_OFFSET < 0.0f ){
			sculpter.activated = true;
		}else{
			sculpter.activated = false;
		}

		sculptMesh.intersectRayMesh(ray);
		float radius = sculpter.radius; // * (camera.fieldOfView/180.0f); // scale the radius depending on "distance"

		this.iVertsSelected = sculptMesh.pickVerticesInSphere(radius);
		Vector3 center = sculptMesh.intersectionPoint;

		if(iVertsSelected.Count > 0){
			gizmoPos = sculptMesh.intersectionPoint;
			gizmoRadius = radius;
		}else{
			gizmoPos = ray.origin + ray.direction;
			gizmoRadius = radius * radius / mainCamera.transform.position.magnitude;
		}
		
		float intensity = sculpter.intensity;

		if(invert){
			intensity *= -1;
		}
		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
		                center, radius, intensity, sculpter.tool);
		
		sculptMesh.updateMesh(this.iTrisSelected, this.iVertsSelected, true);
		
		sculptMesh.pushMeshData();

		//----------------------

		//--- use the first finger as pointer:



//		GameObject primaryHand = GameObject.Find(LeapUnityBridge.PRIMARY_HAND);
//		GameObject finger = findFirstFingerOnHand(primaryHand);
//
//		if(finger == null){
//			return;
//		}
//		fingerPos = finger.transform.position;
//		direction = new Vector3(fingerPos.x, fingerPos.y, 0.0f);// use only the x,y coordinate
//
//		ray = Camera.main.ScreenPointToRay( Camera.main.WorldToScreenPoint(direction) );

//		Leap.Vector tipPos = hand.Fingers.Frontmost.StabilizedTipPosition;
//		ray = CalculateRay(tipPos);
//
//
//		float rayDistance = Vector3.Distance( Camera.main.transform.position, target.transform.position);
//		Debug.DrawLine(ray.origin, ray.origin + ray.direction * rayDistance, Color.cyan);
//
//
//
//		if( Physics.Raycast(ray, out hit,rayDistance) ){
//
//			Debug.DrawLine(ray.origin, hit.point, Color.yellow);
//
////			float activation_distance = fingerPos.z + POINTING_Z_OFFSET;
//			float activation_distance = tipPos.ToUnityTranslated().z + POINTING_Z_OFFSET;
//			//Debug.Log("pointing activation_distance: " + activation_distance);
//			// set the right mode:
//			if(activation_distance < MinActivationDistance){
//				mode = HandTool.HandToolMode.Manipulate;
//				SelectVertices(ray, octree.root);
//			}else{
//				mode = HandTool.HandToolMode.Select;
//				SelectVertices(ray, octree.root);
//				ManipulateVertices(hit, radius);
//			}
//		}
	}


//	public GameObject findFirstFingerOnHand(GameObject handObject){
//		Transform[] ts = handObject.transform.GetComponentsInChildren<Transform>();
//		foreach (Transform t in ts) {
//			if( t.gameObject.name.StartsWith("Finger") ){
//				return t.gameObject;
//			}
//		}
//		return null;
//	}
	
}
