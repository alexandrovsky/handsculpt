using UnityEngine;
using System.Collections;
using Leap;


public class PointingTool : ManipulationHandTool {


	float POINTING_Z_OFFSET  = 1.0f;

	Vector3 fingerPos = Vector3.zero;


	Vector3 direction = Vector3.zero;

	bool invert = false;


	public override void Start () {
		Debug.Log("pointig device started");
		name = "pointing";
		workingHandIdx = 0;
		base.Start();
		mode = HandTool.HandToolMode.Enabled;
		radius = 1.0f;

	}



	public override void CostumGUI(){
		invert = GUILayout.Toggle(invert, "invert");
	}


	public override void ManipulateVertices(Bounds toolBounds, Transform transform){

	}

	public  void ManipulateVertices(RaycastHit hit, float radius){
		foreach(int v_idx in selectedVertices.Keys ){
			float distance = selectedVertices[v_idx];

//			float force = 1.0f -(distance/radius);
			float force = 1.0f - ( Mathf.Clamp01( distance / radius ) );

			Vector3 vertex = hit.transform.TransformPoint( vertices[v_idx] );
			
			// -- begin manipulation vertex:
			// press:

			Vector3 direction = hit.normal.normalized;
			float inverted = invert ? -1.0f : 1.0f;
			vertex += inverted * direction * force * strength * Time.deltaTime;
			
			Debug.DrawLine(vertex,vertex + direction, Color.cyan);
			
			// ---- end manipulation vertex
			colors[v_idx] = ManipulationColor();
			vertices[v_idx] = hit.transform.InverseTransformPoint(vertex);
		}
		PushMeshData();
	}

	public override void Update () 
	{if(Input.GetMouseButtonDown(0))
		{	
			ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			if(Physics.Raycast(ray, out hit) ){
//				Debug.DrawRay(ray.origin, ray.direction, Color.green, 5.0f);
//				SelectVertices(hit, radius);
				SelectVertices(ray, octree.root);
			}
			
		}

		base.Update();

		if(!hand.IsValid){
			return; // --- OUT --->
		}

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

		Leap.Vector tipPos = hand.Fingers.Frontmost.StabilizedTipPosition;
		ray = CalculateRay(tipPos);


		float rayDistance = Vector3.Distance( Camera.main.transform.position, target.transform.position);
		Debug.DrawLine(ray.origin, ray.origin + ray.direction * rayDistance, Color.cyan);

//		Vector3 origin = Camera.main.transform.position;
//		Debug.DrawLine(origin, direction, Color.green);

		if( Physics.Raycast(ray, out hit,rayDistance) ){

			Debug.DrawLine(ray.origin, hit.point, Color.yellow);
			//Debug.Log("pointing tool hit");
			//applyTool(hit);

//			float activation_distance = fingerPos.z + POINTING_Z_OFFSET;
			float activation_distance = tipPos.ToUnityTranslated().z + POINTING_Z_OFFSET;
			//Debug.Log("pointing activation_distance: " + activation_distance);
			// set the right mode:
			if(activation_distance < MinActivationDistance){
				mode = HandTool.HandToolMode.Manipulate;
				SelectVertices(ray, octree.root);
			}else{
				mode = HandTool.HandToolMode.Select;
				SelectVertices(ray, octree.root);
				ManipulateVertices(hit, radius);
			}
		}
	}


	public GameObject findFirstFingerOnHand(GameObject handObject){
		Transform[] ts = handObject.transform.GetComponentsInChildren<Transform>();
		foreach (Transform t in ts) {
			if( t.gameObject.name.StartsWith("Finger") ){
				return t.gameObject;
			}
		}
		return null;
	}
	
}
