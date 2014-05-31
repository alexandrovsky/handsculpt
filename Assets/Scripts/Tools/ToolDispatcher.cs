
using UnityEngine;
using System.Collections.Generic;
using Sculpt;
using Leap;

public class ToolDispatcher : MonoBehaviour {

	//public Vector3 center = Vector3.zero;


	public MenuBehavior.ButtonAction currentLeftTool = MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB;
	public MenuBehavior.ButtonAction currentRightTool = MenuBehavior.ButtonAction.TOOL_PAINT;

	HandController handController;
	GameObject target;

	SculptMesh sculptMesh;
	Camera mainCamera;
	Camera handCamera;

	void Start () {
		handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
		target = GameObject.Find("Target");
		sculptMesh = target.GetComponent<SculptMesh>();
		mainCamera = (GameObject.Find("Main Camera") as GameObject).GetComponent(typeof(Camera)) as Camera;
		handCamera = (GameObject.Find("Hand Camera") as GameObject).GetComponent(typeof(Camera)) as Camera;

		SetToolForHand(currentLeftTool, handController.leftHand);
		SetToolForHand(currentRightTool, handController.rightHand);

	}
	
	// Update is called once per frame
	private void setCamerasFiewOfView(float fow){
		mainCamera.fieldOfView = fow;
		handCamera.fieldOfView = fow;
	}
	private void updateHandTool(SkeletalHand hand){

		if(hand.isHandValid() ){
			switch(hand.tool){
			case MenuBehavior.ButtonAction.TOOL_PAINT:
				UpdateBrushTool(hand);
				break;
			case MenuBehavior.ButtonAction.TOOL_PAINT_ASSISTENT:
				UpdateBrushSecondaryTool(hand );
				break;
			case MenuBehavior.ButtonAction.TOOL_SMOOTH:
				UpdateSmoothTool(hand);
				break;
			case MenuBehavior.ButtonAction.TOOL_GRAB:
				UpdateGrabTool(hand);
				break;
			case MenuBehavior.ButtonAction.TOOL_NAVIGATION_DIRECT:
				UpdateNavigationDirectTool(hand);
				break;
			case MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB:
				UpdateNavigationGrabTool(hand );
				break;
			default: break;
			}
		}else{
			handController.leftHand.pickedVertices.Clear();
		}
	}
	
	void Update () {


		handController.leftHand.tool = currentLeftTool;
		handController.rightHand.tool = currentRightTool;

		updateHandTool(handController.leftHand);
		updateHandTool(handController.rightHand);



		List<int> iTrisSelected = new List<int>();
		iTrisSelected.AddRange( sculptMesh.getTrianglesFromVertices(handController.leftHand.pickedVertices) );
		iTrisSelected.AddRange( sculptMesh.getTrianglesFromVertices(handController.rightHand.pickedVertices) );
		sculptMesh.updateMesh(iTrisSelected, true);
		sculptMesh.pushMeshData();
	}


	public void UpdateBrushTool(SkeletalHand hand){


		SkeletalFinger finger = hand.GetFingerWithType(Leap.Finger.FingerType.TYPE_INDEX) as SkeletalFinger;
		hand.pickingCenter = finger.bones[3].transform.position;
		hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);
		hand.brushIntensity = -0.75f;




		//---
		Vector3 aNormal = sculptMesh.areaNormal(hand.pickedVertices).normalized;
		Vector3 aCenter = sculptMesh.areaCenter(hand.pickedVertices);

		//Debug.DrawLine(aCenter, aCenter + aNormal);

		float deformIntensityBrush = hand.brushIntensity * hand.pickingRadius * 0.1f;
		float deformIntensityFlatten = hand.brushIntensity * 0.3f;
		
		int nbVerts = hand.pickedVertices.Count;
		for(int i = 0; i < nbVerts; i++){

			int v_idx = hand.pickedVertices[i];

			Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
			Vector3 delta = v - hand.pickingCenter;


			//float distanceToPlane = MathHelper.SignedDistancePlanePoint(v, aCenter, aNormal);
			float distanceToPlane = (v.x - aCenter.x) * aNormal.x + (v.y - aCenter.y) * aNormal.y + (v.z - aCenter.z) * aNormal.z;
			float dist = delta.magnitude/hand.pickingRadius;
			float fallOff = dist * dist;
			
			fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
			fallOff = fallOff * (distanceToPlane * deformIntensityFlatten - deformIntensityBrush);

			v -= aNormal * fallOff * 0.5f;

			
			sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
		}

		//---

		ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, hand.brushIntensity, true, hand.IsLeftHand() );

	}

	public void UpdateBrushSecondaryTool(SkeletalHand hand){
		// update the radius of the other hand:
		float pinch = 1 - hand.GetPinchStrength();
		if(hand.IsLeftHand() ){
			handController.rightHand.pickingRadius = pinch * pinch;
		}else{
			handController.leftHand.pickingRadius = pinch * pinch;
		}
	}



	public void UpdateSmoothTool(SkeletalHand hand){



		Vector3 palmPos = hand.GetPalmCenter();
		float sphereRadius = hand.GetSphereRadiusSmoothed() / 100.0f;
		hand.pickingRadius = 2.0f * sphereRadius * sphereRadius;
		bool activated = false;


		//Debug.Log("palm velocity" + speed + " dist: " + distance  + "intensity" + hand.brushIntensity);
		Vector3 palmNormal = hand.GetPalmNormal();
		Ray ray = new Ray(palmPos, palmNormal);

		if(sculptMesh.intersectRayMesh(ray) ){
			Triangle t = sculptMesh.triangles[sculptMesh.pickedTriangle];
			if(Vector3.Dot(t.normal, ray.direction) <= 0.0f){
				hand.pickingCenter = sculptMesh.intersectionPoint;


				float distanceFromHit = Vector3.Distance(palmPos, hand.pickingCenter);
				Debug.Log("distance from hit " + distanceFromHit);
				if( distanceFromHit < hand.pickingRadius){
					activated = true;
					hand.brushIntensity = 1.0f;
					hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);

				}else{
					distanceFromHit = hand.pickingRadius;
					activated = false;
					hand.brushIntensity = 0.0f;
					hand.pickedVertices.Clear();
				}
				

				
				int nbVerts = hand.pickedVertices.Count;
				if(activated){
					for(int i = 0; i < nbVerts; i++){
						int v_idx = hand.pickedVertices[i];
						Vector3 n = Vector3.zero;
						Vertex vertex = sculptMesh.vertices[v_idx];
						
						Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
						
						if(vertex.ringVertices.Count > 0){
							for(int j = 0; j < vertex.ringVertices.Count; j++){
								Vector3 ringV = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[vertex.ringVertices[j]]); 
								n += ringV;
							}
							n *= 1.0f/vertex.ringVertices.Count;
							
							Vector3 d = (n - v) * hand.brushIntensity;
							v += d;
							
						}
						sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
					}
				}
			}
		}

		ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, hand.brushIntensity, activated, hand.IsLeftHand() );
		
	}

	public void UpdateGrabTool(SkeletalHand hand){

		if(!hand.isHandValid() ){
			hand.pickedVertices.Clear();

			return; // --- OUT --->
		}


		hand.pickingCenter = hand.GetPalmCenter();

		hand.pickingRadius = 1.5f;// 3.0f * sphereRadius * sphereRadius;
		if( hand.GetGrabStrength() > 0.8f ){
			// manipulate....

			List<int> iVerts = hand.pickedVertices;


			for(int i = 0; i< iVerts.Count; i++  ){
				int v_idx = iVerts[i];

				
				Vector3 vertex =  target.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
				hand.dragRay.direction = hand.pickingCenter - hand.dragRay.origin;

				float dist = MathHelper.DistanceToLine(hand.dragRay, vertex) / hand.pickingRadius;


				Vector3 dragDirection = hand.pickingCenter - hand.GetLastPalmCenter();
				
				
				float fallOff = dist * dist;
				fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
				vertex += dragDirection * fallOff;



//				Debug.DrawRay(hand.dragRay.origin, hand.dragRay.direction, Color.green);
//				Debug.DrawRay(vertex, hand.dragRay.direction * dragDistance * fallOff);


				sculptMesh.vertexArray[v_idx] = target.transform.InverseTransformPoint(vertex);
			}

		}else{

			hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);
			hand.dragRay.origin = sculptMesh.areaCenter(hand.pickedVertices);
			ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, 1.0f, true, hand.IsLeftHand() );
		}
	}

	Leap.Frame directNavigationEnterFrame = Leap.Frame.Invalid;
	bool directNavigationActivated = false;
	public void UpdateNavigationDirectTool(SkeletalHand hand){

		if( hand.GetGrabStrength() > 0.5f  ){
			directNavigationActivated = false;

			return; //open hand activates ....

		}

		if(!directNavigationActivated){
			directNavigationEnterFrame = handController.GetFrame(0);
			directNavigationActivated = true;
		}



		Vector3 axis = Vector3.zero;
		float angle = 0.0f;
		hand.GetPalmRotation().ToAngleAxis(out angle, out axis);

		Leap.Hand leap_hand = hand.GetLeapHand();

		Leap.Vector leapAxis = leap_hand.RotationAxis(directNavigationEnterFrame);
		angle = leap_hand.RotationAngle(directNavigationEnterFrame) * Mathf.Rad2Deg;
		axis = leapAxis.ToUnity();

		axis = mainCamera.transform.TransformDirection(axis);
		mainCamera.transform.RotateAround(target.transform.position, axis, -angle * Time.deltaTime);

	}


	Vector3 initHandPosition = Vector3.zero;
	bool grabNavigationActivated = false;
	//Leap.Frame grabNavigationEnterFrame = Leap.Frame.Invalid;
	public void UpdateNavigationGrabTool(SkeletalHand hand){

//		float fow = mainCamera.fieldOfView;
		if( hand.GetGrabStrength() < 0.5f  ){

			grabNavigationActivated = false;
			//grabNavigationEnterFrame = Leap.Frame.Invalid;
			return; // close hand activates ....

		}

		if(!grabNavigationActivated){
			initHandPosition = hand.GetLastPalmCenter();
			//grabNavigationEnterFrame =  handController.GetFrame(0);
			grabNavigationActivated = true;
		}

		if(grabNavigationActivated){
			Vector3 palmPos = hand.GetPalmCenter();
			
			Quaternion rotation = Quaternion.FromToRotation(initHandPosition, palmPos);
			float rotationSpeed = 0.5f;
			
			Vector3 axis = Vector3.zero; // = Vector3.Cross(a, b);
			float angle; // = Vector3.Angle(a, b);
			//Debug.Log("angle:" + angle);
			rotation.ToAngleAxis(out angle, out axis);
			
			//		Debug.DrawLine(palmPos, palmPos + axis, Color.green);
			
			mainCamera.transform.RotateAround(target.transform.position, axis, rotationSpeed * -angle);
			
			
			//--- scaling:

//			float delta = initHandPosition.z - palmPos.z;
//			const float MAX_OFFSET = 100;
//			const float MIN_OFFSET = 30;
//			float offset = fow + delta * 10 * Time.deltaTime;
//			//if(offset > MAX_OFFSET) offset = fow;
//			//else if(offset < MAX_OFFSET) offset = fow;
//
//			setCamerasFiewOfView(offset);
//			Debug.DrawLine(initHandPosition, palmPos, Color.red);
			
		}

	}

	public void SetToolForHand(MenuBehavior.ButtonAction tool, SkeletalHand hand){
		hand.tool = tool;
		if(hand.IsLeftHand()){
			currentLeftTool = tool;
		}else{
			currentRightTool = tool;
		}
	}

	public SkeletalHand OtherHand(SkeletalHand hand){
		if(hand.IsLeftHand()){
			return handController.rightHand;
		}
		return handController.leftHand;
	}

	public void ColorizeSelectedVertices(Vector3 center, float radius, float intensity, bool flag, bool isLeft){
		Vector4 brushPos = new Vector4(center.x, 
		                               center.y, 
		                               center.z,
		                               1.0f);
		if(isLeft){
			target.renderer.material.SetVector("_Brush1Pos", brushPos);
			target.renderer.material.SetFloat("_Brush1Radius", radius);
			target.renderer.material.SetFloat("_Brush1ActivationState", intensity);
			target.renderer.material.SetInt("_Brush1ActivationFlag", flag ? 1 : 0);
		}else{
			target.renderer.material.SetVector("_Brush2Pos", brushPos);
			target.renderer.material.SetFloat("_Brush2Radius", radius);
			target.renderer.material.SetFloat("_Brush2ActivationState", intensity);
			target.renderer.material.SetInt("_Brush2ActivationFlag", flag ? 1 : 0);
		}
		
		//Debug.Log("flag:" + flag);
		
		//		target.renderer.material.SetColor("_BrushColorSelectedLow", Sculpter.SELECTED_LOW);
		//		target.renderer.material.SetColor("_BrushColorSelectedHigh", Sculpter.SELECTED_HIGH);
		//		target.renderer.material.SetColor("_BrushDirtyColor", Sculpter.ACTIVATED);
		
	}

}
