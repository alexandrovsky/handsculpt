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


		Leap.Vector tipPos = hand.Fingers.Frontmost.StabilizedTipPosition;
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

		updateSelector(radius);

		float intensity = sculpter.intensity;

		if(invert){
			intensity *= -1;
		}
		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
		                center, radius, intensity, sculpter.tool);
		
		sculptMesh.updateMesh(this.iTrisSelected, this.iVertsSelected, true);
		
		sculptMesh.pushMeshData();
	}

	public override void OnDestroy(){
//		activatePalm();
		base.OnDestroy();

	}

}
