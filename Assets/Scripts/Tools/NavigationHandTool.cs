using UnityEngine;
using System.Collections;
using Leap;

public class NavigationHandTool : HandTool {

	// Use this for initialization

	bool invertedScaling = false;
//	bool continuousRotation = true;
	float scaleSensitivity = 0.25f;
	float rotationSensitivity = 0.25f;
	float rotationSpeed = 0.75f;
	float scaleSpeed = 2.5f;

	Camera handCamera;

	public override void Start () {
		name = "navi";
		workingHandIdx = 1;

		handCamera = GameObject.Find("HandCamera").GetComponent<Camera>();
		base.Start();
	}


//	void OnDrawGizmos(){
//		
//		Gizmos.color = Color.green;
//
//		Leap.InteractionBox iBox = LeapInput.Frame.InteractionBox;
//		Vector3 center = iBox.Center.ToUnityTranslated();
//		Leap.Vector size = new Leap.Vector(iBox.Width, iBox.Height, iBox.Depth);
//		Gizmos.DrawWireCube(center, size.ToUnityTranslated() );
//		Gizmos.DrawWireSphere(center, 0.2f);
//		Gizmos.DrawWireSphere(hand.PalmPosition.ToUnityTranslated(), 0.2f);
//		Gizmos.DrawLine(hand.PalmPosition.ToUnityTranslated(), center);
//
//	}

	public override void CostumGUI(){


		GUILayout.BeginVertical();{
			GUILayout.TextField("Rotation sensitivity: " + rotationSensitivity);
			rotationSensitivity = GUILayout.HorizontalSlider(rotationSensitivity, 0.01f, 1.0f);
		}GUILayout.EndVertical();

		GUILayout.BeginVertical();{
			GUILayout.TextField("Rotation speed: " + rotationSpeed);
			rotationSpeed = GUILayout.HorizontalSlider(rotationSpeed, 0.01f, 2.0f);
		}GUILayout.EndVertical();

		GUILayout.BeginVertical();{
			GUILayout.TextField("Scale speed: " + scaleSpeed);
			scaleSpeed = GUILayout.HorizontalSlider(scaleSpeed, 0.01f, 5.0f);
		}GUILayout.EndVertical();

		GUILayout.BeginVertical();{
			GUILayout.TextField("Scale sensitivity: " + scaleSensitivity);
			scaleSensitivity = GUILayout.HorizontalSlider(scaleSensitivity, 0.01f, 1.0f);
		}GUILayout.EndVertical();
		invertedScaling = GUILayout.Toggle(invertedScaling, "invert scaling");
		GUILayout.TextField("grab strength: " + hand.GrabStrength);
	}
	
	// Update is called once per frame
	public override void Update () {
		base.Update();
//		Debug.Log("hand: " + hand.PalmPosition.ToUnityTranslated() );

		if(!hand.IsValid){
//			Debug.Log("hand: invalid" + hand.PalmPosition.ToUnityTranslated() );
			return; // --- out here --->
		}

		if( hand.GrabStrength > 0.5f  ){
			mode = HandTool.HandToolMode.Disabled;
		}else{
			mode = HandTool.HandToolMode.Enabled;
		}



//		mode = HandTool.HandToolMode.Enabled;
		
		if(HandTool.HandToolMode.SwitchedEnabled == mode){
			
			// do something here....

		}else if(HandTool.HandToolMode.Enabled == mode){

			// rotation:
			if(!rotate() ){
				// scale:
				scale();
			}

			// move the children back
//			Transform[] allChildren = GetComponentsInChildren<Transform>();
//			foreach (Transform child in allChildren) {
//				child.position -= transform.forward * transform.position.magnitude;
//			}

		}
	}


	bool scale(){

		float posZ = hand.PalmPosition.ToUnityScaled().z;
//		float dir = 0.0f;
		if(Mathf.Abs(posZ) < scaleSensitivity){
			return false; // --- OUT --->
		}
//		dir = posZ > 0.0f ? 1.0f : -1.0f;

		float inv = invertedScaling? -1.0f:1.0f;
		mainCamera.fieldOfView += posZ * scaleSpeed * Time.deltaTime * inv;
		handCamera.fieldOfView = mainCamera.fieldOfView;
//		mainCamera.transform.position += mainCamera.transform.forward * dir * scaleSpeed * Time.deltaTime;
		return true;
	}

	bool rotate(){
		float x = hand.PalmNormal.x;
		float z = hand.PalmNormal.z;
		float max = 1.0f;
		float angle = 100.0f;
		
		if(Mathf.Abs( Mathf.Abs(x) - Mathf.Abs(z) ) < rotationSensitivity ){
			return false; // --- OUT --->
		}
		
		Vector3 axis = mainCamera.transform.right; // Vector3.zero;
		if(Mathf.Abs(x) < Mathf.Abs(z) ){
			axis = mainCamera.transform.right;
			max = z;
		}else{
			axis = mainCamera.transform.up;
			max = x;
		}
		//dynamic:
		angle *= -max;
		
		//static:
		//					if(max > 0.0f){
		//						angle *= -1.0f;
		//					}
		
		mainCamera.transform.RotateAround(target.transform.position, axis, rotationSpeed * angle * Time.deltaTime);
		return true;
	}

} // class
