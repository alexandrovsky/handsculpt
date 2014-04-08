using UnityEngine;
using System.Collections;
using Leap;

public class NavigationHandTool : HandTool {

	// Use this for initialization

	bool invertedScaling = false;
//	bool continuousRotation = true;
	float sensitivity = 0.25f;
	float rotationSpeed = 0.5f;
	float scaleSpeed = 1.0f;
	Camera mainCamera;
	Camera handCamera;

	public override void Start () {
		name = "navi";
		workingHandIdx = 1;
		mainCamera = Camera.main;
		handCamera = GameObject.Find("HandCamera").GetComponent<Camera>();
		base.Start();
	}

	public override void CostumGUI(){

		GUILayout.BeginVertical();{
			GUILayout.TextField("Rotation speed: " + rotationSpeed);
			rotationSpeed = GUILayout.HorizontalSlider(rotationSpeed, 0.01f, 2.0f);
		}GUILayout.EndVertical();

		GUILayout.BeginVertical();{
			GUILayout.TextField("Scale speed: " + scaleSpeed);
			scaleSpeed = GUILayout.HorizontalSlider(scaleSpeed, 0.01f, 5.0f);
		}GUILayout.EndVertical();

		GUILayout.BeginVertical();{
			GUILayout.TextField("sensitivity: " + sensitivity);
			sensitivity = GUILayout.HorizontalSlider(sensitivity, 0.01f, 1.0f);
		}GUILayout.EndVertical();
		GUILayout.TextField("grab strength: " + hand.GrabStrength);
	}
	
	// Update is called once per frame
	public override void Update () {
		base.Update();
		

		if(!hand.IsValid){
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
//		if(Mathf.Abs(posZ) < sensitivity){
//			return false; // --- OUT --->
//		}
//		dir = posZ > 0.0f ? 1.0f : -1.0f;

		mainCamera.fieldOfView += posZ * scaleSpeed * Time.deltaTime;
		handCamera.fieldOfView = mainCamera.fieldOfView;
//		mainCamera.transform.position += mainCamera.transform.forward * dir * scaleSpeed * Time.deltaTime;
		return true;
	}

	bool rotate(){
		float x = hand.PalmNormal.x;
		float z = hand.PalmNormal.z;
		float max = 1.0f;
		float angle = 100.0f;
		
		if(Mathf.Abs( Mathf.Abs(x) - Mathf.Abs(z) ) < sensitivity ){
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
