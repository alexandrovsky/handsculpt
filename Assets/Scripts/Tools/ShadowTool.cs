using UnityEngine;
using System.Collections.Generic;
using Leap;
public class ShadowTool : ManipulationHandTool 
{



	public override void Start () {
		name = "shadow";
		workingHandIdx = 0;
		base.Start();
		mode = HandTool.HandToolMode.Enabled;
		sculpter.tool = Sculpt.Tool.SMOOTH;
		MinActivationDistance = 2.0f;
		activatePalm();
	}
	
	public override void CostumGUI(){

		GUILayout.TextField( "dist: " + hand.PalmPosition.ToUnityTranslated().magnitude);
		GUILayout.BeginVertical();{
			GUILayout.TextField("Min Activation Distance: " + MinActivationDistance);
			MinActivationDistance = GUILayout.HorizontalSlider(MinActivationDistance, 0.01f, 12.0f);
		}GUILayout.EndVertical();
	}
	
	



	public override void Update ()
	{
		sculpter.clear();
		base.Update();

		if( !hand.IsValid || HandTool.HandToolMode.Disabled == mode)
		{
			return; // --- OUT --->
		}



		/*
		 * check ray in both directions:
		 * first up, because otherwise, i could collect backfaces!
		 */
		ray = new Ray(palm.transform.position, palm.transform.up);
		if(!sculptMesh.intersectRayMesh(ray) ){
			ray = new Ray(palm.transform.position, -palm.transform.up);
			sculptMesh.intersectRayMesh(ray);
		}

		Debug.DrawLine(ray.origin, ray.origin + ray.direction, Color.green);



		Leap.InteractionBox iBox = LeapInput.Frame.InteractionBox;
		Vector3 iBoxCenter = iBox.Center.ToUnityTranslated();
		Vector3 handPos = hand.PalmPosition.ToUnityTranslated();

		float activationDistance = Vector3.Distance(iBoxCenter, handPos);
		if(activationDistance < MinActivationDistance){
//		if(hand.PalmPosition.ToUnityTranslated().magnitude < MinActivationDistance ){
			sculpter.activated = true;
		}else{
			sculpter.activated = false;
		}

		radiusQueue.Add(hand.SphereRadius);
		if(radiusQueue.Count > radiusQueueSize){
			radiusQueue.RemoveAt(0);
		}

		float smoothRadius = 0.0f;
		foreach(float r in radiusQueue){
			smoothRadius += r;
		}
		smoothRadius = smoothRadius / radiusQueue.Count;

//		float radius = sculpter.radius * (hand.SphereRadius/10.0f) * (mainCamera.fieldOfView/180.0f); // scale the radius depending on "distance"
		float radius = sculpter.radius * (smoothRadius/10.0f) * (mainCamera.fieldOfView/180.0f); // scale the radius depending on "distance"


		this.iVertsSelected = sculptMesh.pickVerticesInSphere(radius);
		Vector3 center = sculptMesh.intersectionPoint;



		float intensity = sculpter.intensity;


		// smooth transition
		if(!sculpter.activated){
			float range = 8+MinActivationDistance;//2 * MinActivationDistance;

			if(activationDistance > range){
				intensity = 0;
			}else{
				intensity = 1.0f - (activationDistance/range);
			}

			Debug.Log("intsity:" + intensity + "dist: " + activationDistance);
		}

		
		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
		                center, radius, intensity, Sculpt.Tool.SMOOTH);

		this.iTrisSelected = sculpter.iTrisSelected;
		this.iVertsSelected = sculpter.iVertsSelected;

		sculptMesh.updateMesh(this.iTrisSelected, true);
		
		sculptMesh.pushMeshData();

	}





	public override void OnDestroy(){
//		activatePalm();
		base.OnDestroy();
	}
}
