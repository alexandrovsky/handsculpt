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
		createSelector();

		deactivatePalm();

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


		//Leap.Vector tipPos = hand.Fingers.Frontmost.StabilizedTipPosition;
		Leap.Vector tipPos = hand.Fingers.Frontmost.TipPosition;
		ray = CalculateRay(tipPos);


//		int fIdx = controller.IndexForFingerId(hand.Fingers.Frontmost.Id);
//		GameObject finger = controller.m_fingers[fIdx];



		if(tipPos.z + POINTING_Z_OFFSET < 0.0f ){
			sculpter.activated = true;
		}else{
			sculpter.activated = false;
		}


		sculptMesh.intersectRayMesh(ray);
		float radius = sculpter.radius; // * (camera.fieldOfView/180.0f); // scale the radius depending on "distance"

		this.iVertsSelected = sculptMesh.pickVerticesInSphere(radius);
		Vector3 center = sculptMesh.intersectionPoint;



		float intensity = sculpter.intensity;

		if(invert){
			intensity *= -1;
		}


		// smooth transition
		if(!sculpter.activated){
			int clamp = Mathf.Clamp((int)(tipPos.z + POINTING_Z_OFFSET), 0, 100);
			intensity = 1.0f - (clamp/100.0f);
//			Debug.Log("intsity:" + intensity);
		}

		updateSelector(radius, intensity);
		colorizeSelectedVertices(sculptMesh.intersectionPoint, radius, intensity, sculpter.activated);

		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
		                center, radius, intensity, sculpter.tool);

		this.iTrisSelected = sculpter.iTrisSelected;
		this.iVertsSelected = sculpter.iVertsSelected;

		sculptMesh.updateMesh(sculpter.iTrisSelected, true);
		
		sculptMesh.pushMeshData();
	}

	public override void OnDestroy(){
//		activatePalm();
		base.OnDestroy();

	}

}
