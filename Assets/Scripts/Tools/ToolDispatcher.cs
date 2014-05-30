
using UnityEngine;
using System.Collections.Generic;
using Sculpt;

public class ToolDispatcher : MonoBehaviour {

	public Vector3 center =Vector3.zero;
	public float radius = 2.0f;
	public float intensity = 0.5f;

	public Sculpt.Tool currentLeftTool = Tool.TWO_HAND_NAVIGATION;
	public Sculpt.Tool currentRightTool = Tool.TWO_HAND_NAVIGATION;
	public bool isTwoHandTool = false;

	HandController handController;
	GameObject target;
	Sculpter sculpter;
	SculptMesh sculptMesh;
	Camera mainCamera;
	List<int> iVertsSelected = new List<int>();
	List<int> iTrisSelected = new List<int>();

	void Start () {
		handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
		target = GameObject.Find("Target");
		sculpter = target.GetComponent<Sculpter>();
		sculptMesh = target.GetComponent<SculptMesh>();
		mainCamera = Camera.main;
	}
	
	// Update is called once per frame
	void Update () {

		this.iTrisSelected.Clear();

		if(!isTwoHandTool){
			if(handController.leftHand.GetLeapHand() != null){
				
				switch(currentLeftTool){
				case Tool.BRUSH:
					UpdateBrushTool(handController.leftHand,true);
					break;
				case Tool.BRUSH_SECONDARY:
					UpdateBrushSecondaryTool(handController.leftHand,true);
					break;
				case Tool.SMOOTH:
					UpdateSmoothTool(handController.leftHand, true);
					break;
				case Tool.DRAG:
					UpdateDragTool(handController.leftHand, true);
					break;
				default: break;
				}
			}
			
			if(handController.rightHand.GetLeapHand() != null){
				switch(currentRightTool){
				case Tool.BRUSH:
					UpdateBrushTool(handController.rightHand, false);
					break;
				case Tool.BRUSH_SECONDARY:
					UpdateBrushSecondaryTool(handController.rightHand,true);
					break;
				case Tool.SMOOTH:
					UpdateSmoothTool(handController.rightHand, false);
					break;
				case Tool.DRAG:
					UpdateDragTool(handController.rightHand, false);
					break;
				default: break;
				}
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


		sculptMesh.updateMesh(this.iTrisSelected, true);
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
		center = finger.bones[3].transform.position;


		hand.pickedVertices = sculptMesh.pickVerticesInSphere(center, radius);
		this.iVertsSelected.AddRange(hand.pickedVertices);
		this.iTrisSelected.AddRange(sculptMesh.getTrianglesFromVertices(hand.pickedVertices) );
		sculpter.activated = true;
		sculpter.sculpt(mainCamera.transform.forward, hand.pickedVertices, 
		       center, radius, intensity, Tool.BRUSH);



		ColorizeSelectedVertices(center, radius, intensity, true, isLeft);

	}

	public void UpdateBrushSecondaryTool(SkeletalHand hand, bool isLeft){
		radius = 0.2f + (1 - hand.GetPinchStrength() );
	}

	public void UpdateSmoothTool(SkeletalHand hand, bool isLeft){


		//center = hand.GetSphereCenter();
		center = hand.GetPalmCenter();
		float sphereRadius = hand.GetSphereRadius() / 100.0f;
		radius = 3.0f * sphereRadius * sphereRadius;


		hand.pickedVertices = sculptMesh.pickVerticesInSphere(center, radius);

		sculpter.activated = true;
		sculpter.sculpt(mainCamera.transform.forward, hand.pickedVertices, 
		                center, radius, intensity, Tool.SMOOTH);

		ColorizeSelectedVertices(center, radius, intensity, true, hand.GetLeapHand().IsRight);

		
	}

	public void UpdateDragTool(SkeletalHand hand, bool isLeft){

		if(!hand.GetLeapHand().IsValid){
			hand.pickedVertices.Clear();

			return; // --- OUT --->
		}


		center = hand.GetPalmCenter();

		radius = 1.0f; // 3.0f * sphereRadius * sphereRadius;
		if( hand.GetGrabStrength() > 0.8 ){
			// manipulate....

			List<int> iVerts = hand.pickedVertices;


			for(int i = 0; i< iVerts.Count; i++  ){
				int v_idx = iVerts[i];

				
				Vector3 vertex =  target.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
				hand.dragRay.direction = center - hand.dragRay.origin;
				float dragDistance = Vector3.Distance(hand.dragRay.origin, center);

				float dist = MathHelper.DistanceToLine(hand.dragRay, vertex);


				Vector3 dragDirection = center - hand.GetLastPalmCenter();
				
				
				float fallOff = dist * dist;
				fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
				vertex += dragDirection * fallOff;



//				Debug.DrawRay(hand.dragRay.origin, hand.dragRay.direction, Color.green);
//				Debug.DrawRay(vertex, hand.dragRay.direction * dragDistance * fallOff);



				ColorizeSelectedVertices(center,radius, 1.0f, true, isLeft);
				sculptMesh.vertexArray[v_idx] = target.transform.InverseTransformPoint(vertex);

			}

		}else{

			hand.pickedVertices = sculptMesh.pickVerticesInSphere(center, radius);
			hand.dragRay.origin = sculptMesh.areaCenter(hand.pickedVertices);
		}


		

		
		ColorizeSelectedVertices(center, radius, intensity, true, hand.GetLeapHand().IsRight);

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
