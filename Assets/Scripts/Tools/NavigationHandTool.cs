using UnityEngine;
using System.Collections;
using Leap;

public class NavigationHandTool : HandTool {

	public enum NavigationMode{
		Grab,
		Direct
	};

	// Use this for initialization

	bool invertedScaling = false;
//	bool continuousRotation = true;
	float scaleSensitivity = 0.25f;
	float rotationSensitivity = 0.25f;
	float rotationSpeed = 0.75f;
	float scaleSpeed = 2.5f;

	Camera handCamera;

	Vector3 initHandNormal = Vector3.zero;


	NavigationMode navigationMode;

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


		int naviMode = (int)navigationMode;
		string[] names = System.Enum.GetNames( typeof(NavigationMode) );
		naviMode = GUILayout.Toolbar(naviMode, names );
		navigationMode = (NavigationMode)naviMode;
		GUILayout.TextField("NavigationMode: " + navigationMode);


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

	Vector3 initHandPosition = Vector3.zero;

	public override void Update () {
		base.Update();
//		Debug.Log("hand: " + hand.PalmPosition.ToUnityTranslated() );

		if(!hand.IsValid){
//			Debug.Log("hand: invalid" + hand.PalmPosition.ToUnityTranslated() );
			return; // --- out here --->
		}


		switch(navigationMode){
		case NavigationMode.Direct: // uses the open hand
			if( hand.GrabStrength > 0.5f  ){ // open hand activates ....
				mode = HandTool.HandToolMode.Disabled;
			}else{
				mode = HandTool.HandToolMode.Enabled;
			}
			break;
		case NavigationMode.Grab: // uses closed hand

			if( hand.GrabStrength < 0.5f  ){ // close hand activates ....
				
				mode = HandTool.HandToolMode.Disabled;
			}else{
				mode = HandTool.HandToolMode.Enabled;
			}
			break;
		}


	


//		mode = HandTool.HandToolMode.Enabled;
		
		if(HandTool.HandToolMode.SwitchedEnabled == mode){
			
			// do something here....

			initHandNormal = palm.transform.up;
			initHandPosition = palm.transform.position;

		}else if(HandTool.HandToolMode.Enabled == mode){

			// rotation:

			switch(navigationMode){
			case NavigationMode.Direct:
				rotateDirect();
				break;
			case NavigationMode.Grab:
				rotateGrab();
				break;
			}

//			rotateGrab();
//			rotateDirect();

		

			//-----------

//			if(!rotate() ){
//				// scale:
//				//scale();
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

	// Arcball technique (Shoemake 1992)
	void rotateGrab(){
		Vector3 palmPos = palm.transform.position;

		Quaternion rotation = Quaternion.FromToRotation(initHandPosition, palmPos);


		Vector3 axis = Vector3.zero; // = Vector3.Cross(a, b);
		float angle; // = Vector3.Angle(a, b);
		//Debug.Log("angle:" + angle);
		rotation.ToAngleAxis(out angle, out axis);

//		Debug.DrawLine(palmPos, palmPos + axis, Color.green);

		mainCamera.transform.RotateAround(target.transform.position, axis, rotationSpeed * -angle * Time.deltaTime);

	}
	void rotateDirect(){
		Vector3 forward = hand.Direction.ToUnity();
		Vector3 up = hand.PalmNormal.ToUnity(); up.y += -1; // make hand normal look up
		Vector3 right = Vector3.Cross(forward, up);

		Vector3 pointOnPlaneXY = new Vector3(right.x, right.y, 0.0f).normalized;
		Vector3 pointOnPlaneXZ = new Vector3(forward.x, 0.0f, forward.z).normalized;
		Vector3 pointOnPlaneYZ = new Vector3(0.0f, -up.y, up.z).normalized;

		Quaternion rotXY = Quaternion.identity;
		Quaternion rotXZ = Quaternion.identity; 
		Quaternion rotYZ = Quaternion.identity;


		float angleXY = Vector3.Angle(Vector3.right, pointOnPlaneXY);
		float angleXZ = Vector3.Angle(Vector3.forward, pointOnPlaneXZ);
		float angleYZ = Vector3.Angle(Vector3.up, pointOnPlaneYZ);


		Debug.Log("angleXZ: " + angleXZ + " angleYZ: " + angleYZ + " angleXY: " + angleXY);
		float minAngle = 45.0f * rotationSensitivity;

		if(angleXY > minAngle && angleXY > angleXZ && angleXY > angleYZ){
			rotXY = Quaternion.FromToRotation(Vector3.right, pointOnPlaneXY);
		}else if(angleXZ > minAngle && angleXZ > angleYZ && angleXZ > angleXY){
			rotXZ = Quaternion.FromToRotation(Vector3.forward, pointOnPlaneXZ);
		}else if(angleYZ > minAngle && angleYZ > angleXZ && angleYZ > angleXY){
			rotYZ = Quaternion.FromToRotation(Vector3.up, pointOnPlaneYZ);
		} 

		Quaternion rot = rotXY * rotXZ * rotYZ;
		
		Vector3 axis = Vector3.zero;
		float angle = 0.0f;
		
		
		rot.ToAngleAxis(out angle, out axis);

		axis = mainCamera.transform.TransformDirection(axis);

		mainCamera.transform.RotateAround(target.transform.position, axis, rotationSpeed * angle * Time.deltaTime);

		// world
		
		Debug.DrawLine(Vector3.zero, mainCamera.transform.TransformDirection(Vector3.forward) * 2, Color.blue);
		Debug.DrawLine(Vector3.zero, mainCamera.transform.TransformDirection(Vector3.up) * 2, Color.green);
		Debug.DrawLine(Vector3.zero, mainCamera.transform.TransformDirection(Vector3.right) * 2, Color.red);


		// points on plane:
		Debug.DrawLine(Vector3.zero, mainCamera.transform.TransformDirection(pointOnPlaneXY) * 2, Color.blue);
		Debug.DrawLine(Vector3.zero, mainCamera.transform.TransformDirection(pointOnPlaneXZ) * 2, Color.green);
		Debug.DrawLine(Vector3.zero, mainCamera.transform.TransformDirection(pointOnPlaneYZ) * 2, Color.red);


		Debug.DrawLine(Vector3.zero, axis * 2, Color.yellow);
	}





} // class
