
using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using Sculpt;
using Leap;

public class ToolDispatcher : MonoBehaviour {


	public MenuBehavior.ButtonAction currentLeftTool = MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB;
	public MenuBehavior.ButtonAction currentRightTool = MenuBehavior.ButtonAction.TOOL_PAINT;
	public bool symmetry = true;
	public bool inverted = true;
	HandController handController;
	GameObject target;

	SculptMesh sculptMesh;
	Camera mainCamera;
	Camera handCamera;

	public bool toolsEnabled; // Flag for the GUI
	public float radius = 1.0f;
	public float intensity = 0.0f;

	void Start () {
		handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
		target = GameObject.Find("Target");
		sculptMesh = target.GetComponent<SculptMesh>();
		mainCamera = (GameObject.Find("Main Camera") as GameObject).GetComponent(typeof(Camera)) as Camera;
		handCamera = (GameObject.Find("Hand Camera") as GameObject).GetComponent(typeof(Camera)) as Camera;

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

		if(toolsEnabled){
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


	}

	private void brushVerts(List<int> iVerts, Vector3 aCenter, Vector3 aNormal, float radius, float deformIntensityFlatten, float deformIntensityBrush){
		int nbVerts = iVerts.Count;
		for(int i = 0; i < nbVerts; i++){
			
			int v_idx = iVerts[i];
			
			Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
			Vector3 delta = v - aCenter;
			
			
			//float distanceToPlane = MathHelper.SignedDistancePlanePoint(v, aCenter, aNormal);
			float distanceToPlane = (v.x - aCenter.x) * aNormal.x + (v.y - aCenter.y) * aNormal.y + (v.z - aCenter.z) * aNormal.z;
			float dist = delta.magnitude/radius;
			float fallOff = dist * dist;
			
			fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
			fallOff = fallOff * (distanceToPlane * deformIntensityFlatten - deformIntensityBrush);
			//if(fallOff > 1.0f) fallOff = 1.0f; 
			v -= aNormal * fallOff * 0.5f; // * Time.deltaTime;
			
			
			sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
		}
	}


	public void UpdateBrushTool(SkeletalHand hand){

		hand.brushIntensity =  this.inverted? -this.intensity : this.intensity;
		hand.pickingRadius = this.radius;


		SkeletalFinger finger = hand.GetFingerWithType(Leap.Finger.FingerType.TYPE_INDEX) as SkeletalFinger;
		hand.pickingCenter = finger.bones[3].transform.position;
		hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);

		if(symmetry){
			hand.pickingCenterSymmetry = GetSymmetryPoint(hand.pickingCenter);
			hand.pickedVerticesSymmetry = sculptMesh.pickVerticesInSphere(hand.pickingCenterSymmetry, hand.pickingRadius);
			hand.pickedVertices.Where(i => !hand.pickedVerticesSymmetry.Remove(i));
			hand.pickedVerticesSymmetry.Where(i => !hand.pickedVertices.Remove(i));
		}


		hand.pickingAreaNormal = sculptMesh.areaNormal(hand.pickedVertices).normalized;
		hand.pickingAreaCenter = sculptMesh.areaCenter(hand.pickedVertices);


		if(symmetry){
			hand.pickingAreaNormalSymmetry = sculptMesh.areaNormal(hand.pickedVerticesSymmetry).normalized;
			hand.pickingAreaCenterSymmetry = sculptMesh.areaCenter(hand.pickedVerticesSymmetry);
		}



		float deformIntensityBrush = hand.brushIntensity * hand.pickingRadius * 0.1f;
		float deformIntensityFlatten = hand.brushIntensity * 0.3f;
		brushVerts(hand.pickedVertices, hand.pickingAreaCenter, hand.pickingAreaNormal,
		           hand.pickingRadius, deformIntensityBrush, deformIntensityFlatten);
		if(symmetry){
			brushVerts(hand.pickedVerticesSymmetry, hand.pickingAreaCenterSymmetry, hand.pickingAreaNormalSymmetry,
			           hand.pickingRadius, deformIntensityBrush, deformIntensityFlatten);
		}


		ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, hand.brushIntensity, true, hand.IsLeftHand() );
		if(symmetry){
			ColorizeSelectedVertices(hand.pickingCenterSymmetry, hand.pickingRadius, hand.brushIntensity, true, !hand.IsLeftHand() );
		}

	}

	public void UpdateBrushSecondaryTool(SkeletalHand hand){
		// update the radius of the other hand:
		float pinch = 1 - hand.GetPinchStrength();
		this.radius = 0.5f + 2.0f * pinch * pinch;
//		if(hand.IsLeftHand() ){
//			handController.rightHand.pickingRadius = pinch * pinch;
//		}else{
//			handController.leftHand.pickingRadius = pinch * pinch;
//		}
	}

	private void smoothVerts(List<int> iVerts, Vector3 center, float intensity){
		int nbVerts = iVerts.Count;
		for(int i = 0; i < nbVerts; i++){
			int v_idx = iVerts[i];
			Vector3 n = Vector3.zero;
			Vertex vertex = sculptMesh.vertices[v_idx];
			
			Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
			
			if(vertex.ringVertices.Count > 0){
				for(int j = 0; j < vertex.ringVertices.Count; j++){
					Vector3 ringV = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[vertex.ringVertices[j]]); 
					n += ringV;
				}
				n *= 1.0f/vertex.ringVertices.Count;
				
				Vector3 d = (n - v) * intensity;
				v += d;
				
			}
			sculptMesh.vertexArray[v_idx] = sculptMesh.transform.InverseTransformPoint(v);
		}
	}

	public void UpdateSmoothTool(SkeletalHand hand){

		SkeletalHand otherHand = OtherHand(hand);
		if(otherHand.tool != MenuBehavior.ButtonAction.TOOL_PAINT_ASSISTENT){
			float sphereRadius = hand.GetSphereRadiusSmoothed() / 100.0f;
			hand.pickingRadius = 1.5f * sphereRadius;
		}else{
			hand.pickingRadius = this.radius;
		}
		Vector3 palmPos = hand.GetPalmCenter();

		bool activated = false;


		//Debug.Log("palm velocity" + speed + " dist: " + distance  + "intensity" + hand.brushIntensity);
		Vector3 palmNormal = hand.GetPalmNormal();
		Ray ray = new Ray(palmPos, palmNormal);

		if(sculptMesh.intersectRayMesh(ray) ){
			Triangle t = sculptMesh.triangles[sculptMesh.pickedTriangle];
			if(Vector3.Dot(t.normal, ray.direction) <= 0.0f){
				hand.pickingCenter = sculptMesh.intersectionPoint;
				if(symmetry){
					hand.pickingCenterSymmetry = GetSymmetryPoint(hand.pickingCenter);
				}

				float distanceFromHit = Vector3.Distance(palmPos, hand.pickingCenter);
				if( distanceFromHit < hand.pickingRadius){
					activated = true;
					hand.brushIntensity = this.intensity;
					hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);
					if(symmetry){
						hand.pickedVerticesSymmetry = sculptMesh.pickVerticesInSphere(hand.pickingCenterSymmetry, hand.pickingRadius);
						hand.pickedVertices.Where(i => !hand.pickedVerticesSymmetry.Remove(i));
						hand.pickedVerticesSymmetry.Where(i => !hand.pickedVertices.Remove(i));
					}
				}else{
					distanceFromHit = hand.pickingRadius;
					activated = false;
					hand.brushIntensity = 0.0f;
					hand.pickedVertices.Clear();
				}
				

				

				if(activated){
					smoothVerts(hand.pickedVertices, hand.pickingCenter, hand.brushIntensity);
					if(symmetry){
						smoothVerts(hand.pickedVerticesSymmetry, hand.pickingCenterSymmetry, hand.brushIntensity);
					}
				}
			}
		}

		ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, hand.brushIntensity, activated, hand.IsLeftHand() );
		if(symmetry){
			ColorizeSelectedVertices(hand.pickingCenterSymmetry, hand.pickingRadius, hand.brushIntensity, activated, !hand.IsLeftHand() );
		}
	}

	private void dragVerts(List<int> iVerts, Vector3 from, Vector3 to, Ray ray, float radius, float intensity){
		for(int i = 0; i< iVerts.Count; i++  ){
			int v_idx = iVerts[i];
			Vector3 vertex =  target.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
			ray.direction = from - ray.origin;
			
			float dist = MathHelper.DistanceToLine(ray, vertex) / radius;
			
			
			Vector3 dragDirection = from - to;
			float fallOff = dist * dist;
			fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
			if(fallOff > 1.0f) fallOff = 1.0f; 
			Vector3 dir = dragDirection * fallOff * intensity;
			//if(dir.magnitude > 1.0f) dir *= 1/dir.magnitude;

			vertex += dir;
			
			sculptMesh.vertexArray[v_idx] = target.transform.InverseTransformPoint(vertex);
		}
	}

	public Vector3 GetSymmetryPoint(Vector3 point){
		Vector3 cymmetry_local_point = target.transform.InverseTransformPoint(point);
		cymmetry_local_point.x =  -cymmetry_local_point.x;
		return target.transform.TransformPoint(cymmetry_local_point);
	}

	static float grabReleaseDelay = 1.0f;
	public void UpdateGrabTool(SkeletalHand hand){

		if(!hand.isHandValid() ){
			hand.pickedVertices.Clear();

			return; // --- OUT --->
		}


		hand.pickingCenter = hand.GetPalmCenter();

		if(symmetry){
			hand.pickingCenterSymmetry = GetSymmetryPoint(hand.pickingCenter);
		}

		hand.pickingRadius = this.radius; // 1.5f;// 3.0f * sphereRadius * sphereRadius;
		hand.brushIntensity = this.intensity;
		if( hand.GetGrabStrength() > 0.8f ){

			if(!hand.grabbed){
				hand.grabbed = true;
			}else{
				dragVerts(hand.pickedVertices, hand.pickingCenter, hand.GetLastPalmCenter(), hand.dragRay, hand.pickingRadius, hand.brushIntensity);
				if(symmetry){
					Vector3 lastSymmmetryPoint = GetSymmetryPoint(hand.GetLastPalmCenter() );
					dragVerts(hand.pickedVerticesSymmetry, hand.pickingCenterSymmetry, lastSymmmetryPoint, hand.dragRaySymmetry, hand.pickingRadius, hand.brushIntensity);
				}
			}

		}else{

			if(hand.grabbed){
				hand.grabReleaseTime = Time.time;
			}
			if(Time.time > hand.grabReleaseTime + grabReleaseDelay){
				// released:
				hand.grabbed = false;
			} 



			hand.pickedVertices = sculptMesh.pickVerticesInSphere(hand.pickingCenter, hand.pickingRadius);
			hand.dragRay.origin = sculptMesh.areaCenter(hand.pickedVertices);
			ColorizeSelectedVertices(hand.pickingCenter, hand.pickingRadius, 1.0f, true, hand.IsLeftHand() );
			if(symmetry){
				hand.pickedVerticesSymmetry = sculptMesh.pickVerticesInSphere(hand.pickingCenterSymmetry, hand.pickingRadius);
				hand.pickedVertices.Where(i => !hand.pickedVerticesSymmetry.Remove(i));
				hand.pickedVerticesSymmetry.Where(i => !hand.pickedVertices.Remove(i));
				ColorizeSelectedVertices(hand.pickingCenterSymmetry, hand.pickingRadius, 1.0f, true, !hand.IsLeftHand() );
				hand.dragRaySymmetry.origin = sculptMesh.areaCenter(hand.pickedVerticesSymmetry);
			}
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
		if( hand.GetGrabStrength() < 0.8f  ){

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
