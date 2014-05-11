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

	Vector3 initHandNormal = Vector3.zero;

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

	Vector3 initHandPosition = Vector3.zero;

	public override void Update () {
		base.Update();
//		Debug.Log("hand: " + hand.PalmPosition.ToUnityTranslated() );

		if(!hand.IsValid){
//			Debug.Log("hand: invalid" + hand.PalmPosition.ToUnityTranslated() );
			return; // --- out here --->
		}

		if( hand.GrabStrength > 0.5f  ){ // open hand activates ....
//		if( hand.GrabStrength < 0.5f  ){ // close hand activates ....

			mode = HandTool.HandToolMode.Disabled;
		}else{
			mode = HandTool.HandToolMode.Enabled;
		}

	


//		mode = HandTool.HandToolMode.Enabled;
		
		if(HandTool.HandToolMode.SwitchedEnabled == mode){
			
			// do something here....

			initHandNormal = palm.transform.up;
			initHandPosition = palm.transform.position;

		}else if(HandTool.HandToolMode.Enabled == mode){

			// rotation:
//			rotateGrab();
			rotateDirect();

		

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
		float minAngle = 10.0f;

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
		
		Debug.DrawLine(Vector3.zero, Vector3.forward * 2, Color.blue);
		Debug.DrawLine(Vector3.zero, Vector3.up * 2, Color.green);
		Debug.DrawLine(Vector3.zero, Vector3.right * 2, Color.red);


		// points on plane:
		Debug.DrawLine(Vector3.zero, pointOnPlaneXY * 2, Color.blue);
		Debug.DrawLine(Vector3.zero, pointOnPlaneXZ * 2, Color.green);
		Debug.DrawLine(Vector3.zero, pointOnPlaneYZ * 2, Color.red);


		Debug.DrawLine(Vector3.zero, axis * 2, Color.yellow);


	}
	void rotateDirectOld(){
		Vector3 pos = palm.transform.position;

		Vector3 forward = mainCamera.transform.TransformDirection( hand.Direction.ToUnity() );
		Vector3 up = mainCamera.transform.TransformDirection( hand.PalmNormal.ToUnity() ); // palm.transform.up;
		up.y += -1;
		Vector3 right = Vector3.Cross(forward, up);
		Vector3 transformedInitHandNormal = mainCamera.transform.TransformDirection(initHandNormal);

		Vector3 camFwd = mainCamera.transform.forward;
		Vector3 camUp = mainCamera.transform.up;
		Vector3 camRight = Vector3.Cross(camFwd, camUp);

		Vector3 pointOnPlaneXZ = new Vector3(forward.x, camFwd.y, forward.z).normalized;
		Vector3 pointOnPlaneYZ = new Vector3(camFwd.x, -up.y, up.z).normalized;
		Vector3 pointOnPlaneXY = new Vector3(-right.x, right.y, camRight.z).normalized;





		Quaternion rotXZ = Quaternion.identity; 
		Quaternion rotYZ = Quaternion.identity;
		Quaternion rotXY = Quaternion.identity;

		float angleXZ = Vector3.Angle(camFwd, pointOnPlaneXZ);
		float angleYZ = Vector3.Angle(camUp, pointOnPlaneYZ);
		float angleXY = Vector3.Angle(camRight, pointOnPlaneXY);

		Debug.Log("angleXZ: " + angleXZ + " angleYZ: " + angleYZ + " angleXY: " + angleXY);
		float minAngle = 10.0f;
//		if(angleXZ > minAngle && angleXZ > angleYZ && angleXZ > angleXY){
//			rotXZ = Quaternion.FromToRotation(camFwd, pointOnPlaneXZ);
//		}else if(angleYZ > minAngle && angleYZ > angleXZ && angleYZ > angleXY){
//			rotYZ = Quaternion.FromToRotation(camUp, pointOnPlaneYZ);
//		}else if(angleXY > minAngle && angleXY > angleXZ && angleXY > angleYZ){
			rotXY = Quaternion.FromToRotation(camRight, pointOnPlaneXY);
//		}


		Quaternion rot = rotXY * rotXZ * rotYZ;

		Vector3 axis = Vector3.zero;
		float angle = 0.0f;


		rot.ToAngleAxis(out angle, out axis);

		mainCamera.transform.RotateAround(target.transform.position, axis, rotationSpeed * angle * Time.deltaTime);


//		float angleX = Vector3.Angle(camUp, pointOnPlaneYZ);
//		float signX = (Vector3.Dot(camFwd, pointOnPlaneYZ) > 0.0f) ? 1.0f : -1.0f;
//		
//		float angleY = 90.0f - Vector3.Angle(camRight, pointOnPlaneXZ);
		
//		float angleZ = 90.0f - Vector3.Angle(camUp, pointOnPlaneXY);

//		if( Mathf.Abs(angleX) > Mathf.Abs(angleY)  && Mathf.Abs(angleX) > Mathf.Abs(angleZ)){
//			// rotate on x axis:
//			mainCamera.transform.RotateAround(target.transform.position, camRight, rotationSpeed * signX * angleX * Time.deltaTime);
//		}else if(Mathf.Abs(angleY) > Mathf.Abs(angleX)  && Mathf.Abs(angleY) > Mathf.Abs(angleZ)){
//			// rotate on y axis:
//			mainCamera.transform.RotateAround(target.transform.position, camUp, rotationSpeed * angleY * Time.deltaTime);
//		}else if(Mathf.Abs(angleZ) > Mathf.Abs(angleX)  && Mathf.Abs(angleZ) > Mathf.Abs(angleY)){
//			// rotate on z axis:
//			mainCamera.transform.RotateAround(target.transform.position, camFwd, rotationSpeed * angleZ * Time.deltaTime);
//		}






		// hand
//			Debug.DrawLine(pos, pos + forward,Color.blue);
//			Debug.DrawLine(pos, pos + up,Color.green);
//			Debug.DrawLine(pos, pos + right,Color.red);
//
		// cam

		Debug.DrawLine(pos, pos + camFwd*2,Color.blue);
		Debug.DrawLine(pos, pos + camUp*2,Color.green);
		Debug.DrawLine(pos, pos + camRight*2,Color.red);

		// points on plane:

		Debug.DrawLine(pos, pos + pointOnPlaneXZ*2,Color.green);
		Debug.DrawLine(pos, pos + pointOnPlaneYZ*2,Color.red);
		Debug.DrawLine(pos, pos + pointOnPlaneXY*2,Color.blue);
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
