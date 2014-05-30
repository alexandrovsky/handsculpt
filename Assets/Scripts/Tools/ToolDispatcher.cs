
using UnityEngine;
using System.Collections.Generic;
using Sculpt;

public class ToolDispatcher : MonoBehaviour {

	//public Vector3 center = Vector3.zero;


	public Sculpt.Tool currentLeftTool = Tool.TWO_HAND_NAVIGATION;
	public Sculpt.Tool currentRightTool = Tool.TWO_HAND_NAVIGATION;
	public bool isTwoHandTool = false;

	HandController handController;
	GameObject target;

	SculptMesh sculptMesh;
	Camera mainCamera;


	void Start () {
		handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
		target = GameObject.Find("Target");
		sculptMesh = target.GetComponent<SculptMesh>();
		mainCamera = Camera.main;
	}
	
	// Update is called once per frame
	void Update () {




		if(!isTwoHandTool){
			if(handController.leftHand.isHandValid() ){

				switch(currentLeftTool){
				case Tool.BRUSH:
					UpdateBrushTool(handController.leftHand, true);
					break;
				case Tool.BRUSH_SECONDARY:
					UpdateBrushSecondaryTool(handController.leftHand, true);
					break;
				case Tool.SMOOTH:
					UpdateSmoothTool(handController.leftHand, true);
					break;
				case Tool.DRAG:
					UpdateDragTool(handController.leftHand, true);
					break;
				default: break;
				}
			}else{
				handController.leftHand.pickedVertices.Clear();
			}
			
			if(handController.rightHand.isHandValid() ){
				switch(currentRightTool){
				case Tool.BRUSH:
					UpdateBrushTool(handController.rightHand, false);
					break;
				case Tool.BRUSH_SECONDARY:
					UpdateBrushSecondaryTool(handController.rightHand, false);
					break;
				case Tool.SMOOTH:
					UpdateSmoothTool(handController.rightHand, false);
					break;
				case Tool.DRAG:
					UpdateDragTool(handController.rightHand, false);
					break;
				default: break;
				}
			}else{
				handController.rightHand.pickedVertices.Clear();
			}
		}else{ // TwoHandTools here...

			if(handController.leftHand.GetLeapHand() != null && handController.rightHand.GetLeapHand() != null){
				switch(currentLeftTool){
				case Tool.TWO_HAND_NAVIGATION:
					UpdateTwoHandNavigationTool(handController.leftHand, handController.rightHand);
					break;
				}
			}
		}

		List<int> iTrisSelected = new List<int>();
		iTrisSelected.AddRange( sculptMesh.getTrianglesFromVertices(handController.leftHand.pickedVertices) );
		iTrisSelected.AddRange( sculptMesh.getTrianglesFromVertices(handController.rightHand.pickedVertices) );
		sculptMesh.updateMesh(iTrisSelected, true);
		sculptMesh.pushMeshData();
	}

	Vector3 initLeftPos = Vector3.zero;
	Vector3 initRightPos = Vector3.zero;
	Vector3 centerPoint = Vector3.zero;
	Vector3 initCameraPosition = Vector3.zero;
	bool isNavigating = false;
	public void UpdateTwoHandNavigationTool(SkeletalHand leftHand, SkeletalHand rightHand){

		Vector3 leftPalmPos = leftHand.GetPalmCenter();
		Vector3 leftPalmNormal = leftHand.GetPalmNormal();

		Vector3 rightPalmPos = rightHand.GetPalmCenter();
		Vector3 rightPalmNormal = rightHand.GetPalmNormal();



		float angle = Vector3.Angle(leftPalmNormal, rightPalmNormal);
		//Debug.Log("angle between hands: " + angle);

		if(angle > 130){

			Debug.DrawLine(leftPalmPos, leftPalmPos + leftPalmNormal, Color.green);
			Debug.DrawLine(rightPalmPos, rightPalmPos + rightPalmNormal, Color.green);


			if(!isNavigating){

				initLeftPos = leftPalmPos;
				initRightPos = rightPalmPos;
				centerPoint = (leftPalmPos + rightPalmPos) * 0.5f;
				initCameraPosition = mainCamera.transform.position;
				isNavigating = true;
			}

//			Debug.DrawLine(centerPoint, initLeftPos, Color.red);
//			Debug.DrawLine(centerPoint, initRightPos, Color.red);

			Vector3 currentCenterPoint = (leftPalmPos + rightPalmPos) * 0.5f;

//			Debug.DrawLine(currentCenterPoint, leftPalmPos, Color.blue);
//			Debug.DrawLine(currentCenterPoint, rightPalmPos, Color.blue);

			//Debug.DrawLine(Vector3.zero, centerPoint, Color.magenta);
			Debug.DrawLine(centerPoint, currentCenterPoint, Color.yellow);
			float dist = Vector3.Distance(centerPoint, currentCenterPoint);

			Vector3 direction = currentCenterPoint - centerPoint;
			Debug.DrawLine(mainCamera.transform.position, direction, Color.magenta);

//			if(Vector3.Distance(mainCamera.transform.position, initCameraPosition) < direction.magnitude){ 
//				//mainCamera.transform.position = initCameraPosition + direction * Time.deltaTime;
//				//centerPoint += direction * Time.deltaTime;
//				mainCamera.transform.Translate(0.5f * direction * Time.deltaTime);
//			}

			Vector3 initA = centerPoint + initLeftPos;
			Vector3 initB = centerPoint + initRightPos;
			Vector3 initN = Vector3.Cross(initA, initB);

			Debug.DrawLine(centerPoint, initA, Color.cyan);
			Debug.DrawLine(centerPoint, initB, Color.cyan);
			Debug.DrawLine(centerPoint, initN, Color.green);


			Vector3 currA = centerPoint + leftPalmPos;
			Vector3 currB = centerPoint + rightPalmPos;
			Vector3 currN = Vector3.Cross(currA, currB);
			
			Debug.DrawLine(centerPoint, currA, Color.red);
			Debug.DrawLine(centerPoint, currB, Color.red);
			Debug.DrawLine(centerPoint, currN, Color.blue);


			Quaternion q = Quaternion.FromToRotation(initN, currN);
			Vector3 rotAxis = Vector3.zero;
			float rotAngle = 0.0f;
			q.ToAngleAxis(out rotAngle, out rotAxis);
			float rotationSpeed = 0.5f;
			//mainCamera.transform.RotateAround(centerPoint, rotAxis, rotationSpeed * rotAngle * Time.deltaTime);
		}else{
			isNavigating = false;
		}

	}

	public void UpdateBrushTool(SkeletalHand hand, bool isLeft){


		SkeletalFinger finger = hand.GetFingerWithType(Leap.Finger.FingerType.TYPE_INDEX) as SkeletalFinger;
		hand.pickingCenter = finger.bones[3].transform.position;
		hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);
		hand.brushIntensity = -0.75f;


		//---
		Vector3 aNormal = sculptMesh.areaNormal(hand.pickedVertices);
		Vector3 aCenter = sculptMesh.areaCenter(hand.pickedVertices);

		
		float deformIntensityBrush = hand.brushIntensity * hand.pickingRadius * 0.1f;
		float deformIntensityFlatten = hand.brushIntensity * 0.3f;
		
		int nbVerts = hand.pickedVertices.Count;
		for(int i = 0; i < nbVerts; i++){

			int v_idx = hand.pickedVertices[i];

			Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
			Vector3 delta = v - hand.pickingCenter;
			
			float distanceToPlane = (v.x - aCenter.x) * aNormal.x + (v.y - aCenter.y) * aNormal.y + (v.z - aCenter.z) * aNormal.z;
			float dist = delta.magnitude/hand.pickingRadius;
			float fallOff = dist * dist;
			
			fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
			fallOff = fallOff * (distanceToPlane * deformIntensityFlatten - deformIntensityBrush);

			v -= aNormal * fallOff * 8.0f * Time.deltaTime;

			
			sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
			
		}

		//---

		ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, hand.brushIntensity, true, isLeft);

	}

	public void UpdateBrushSecondaryTool(SkeletalHand hand, bool isLeft){
		// update the radius of the other hand:
		if(isLeft){
			handController.rightHand.pickingRadius = 0.2f + (1 - hand.GetPinchStrength() );
		}else{
			handController.leftHand.pickingRadius = 0.2f + (1 - hand.GetPinchStrength() );
		}
	}
	List<float> smoothedSpeed = new List<float>();
	List<float> smoothedDistance = new List<float>();
	public void UpdateSmoothTool(SkeletalHand hand, bool isLeft){



		hand.pickingCenter = hand.GetPalmCenterSmoothed();
		float sphereRadius = hand.GetSphereRadius() / 100.0f;
		hand.pickingRadius = 2.0f * sphereRadius * sphereRadius;

		float distance = Vector3.Distance(hand.GetLastPalmCenter(), hand.pickingCenter);
		float speed = hand.GetLeapHand().PalmVelocity.Magnitude/100.0f;

		if(smoothedSpeed.Count > 5){
			smoothedSpeed.RemoveAt(0);
			smoothedDistance.RemoveAt(0);
		}
		smoothedSpeed.Add(speed);
		smoothedDistance.Add(distance);
		float s_ = 0;
		float d_ = 0;
		for(int i = 0; i < smoothedSpeed.Count; i++){
			s_ += smoothedSpeed[i];
			d_ += smoothedDistance[i];
		}
		speed = s_/smoothedSpeed.Count;
		distance = d_/smoothedDistance.Count;

		bool activated = false;
		if(distance < 0.15f && speed > 0.3){

			//speed = Mathf.Min(speed, 2); // bring maximum 

			hand.brushIntensity = 1.0f; // speed/2.0f;
			activated = true;
		}else{
			hand.brushIntensity = 0.0f;
			activated = false;
		}

		ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, hand.brushIntensity, activated, isLeft);

		Debug.Log("palm velocity" + speed + " dist: " + distance  + "intensity" + hand.brushIntensity);

		hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);

		for(int i = 0; i < hand.pickedVertices.Count; i++){
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

		//



		
	}

	public void UpdateDragTool(SkeletalHand hand, bool isLeft){

		if(!hand.GetLeapHand().IsValid){
			hand.pickedVertices.Clear();

			return; // --- OUT --->
		}


		hand.pickingCenter = hand.GetPalmCenter();

		hand.pickingRadius = 1.0f; // 3.0f * sphereRadius * sphereRadius;
		if( hand.GetGrabStrength() > 0.8 ){
			// manipulate....

			List<int> iVerts = hand.pickedVertices;


			for(int i = 0; i< iVerts.Count; i++  ){
				int v_idx = iVerts[i];

				
				Vector3 vertex =  target.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
				hand.dragRay.direction = hand.pickingCenter - hand.dragRay.origin;

				float dist = MathHelper.DistanceToLine(hand.dragRay, vertex);


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
			ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, 1.0f, true, isLeft);
		}
	}

	public void SetToolForHand(Sculpt.Tool tool, SkeletalHand hand){

		if(hand.GetLeapHand().IsLeft){
			currentLeftTool = tool;
		}else{
			currentRightTool = tool;
		}
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
