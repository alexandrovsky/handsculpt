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

//		deactivatePalm();
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
		sculpter.clearColors();
		base.Update();

		if( ! hand.IsValid 
		   || HandTool.HandToolMode.Disabled == mode)
		{
			return; // --- OUT --->
		}
		if( target.renderer.bounds.Contains(palm.transform.position) ){
			ray = new Ray(palm.transform.position, palm.transform.up);
		}else{
			ray = new Ray(palm.transform.position, -palm.transform.up);
		}



		if(hand.PalmPosition.ToUnityTranslated().magnitude < MinActivationDistance ){
			sculpter.activated = true;
		}else{
			sculpter.activated = false;
		}
		
//		Vector3 screenPoint = mainCamera.WorldToScreenPoint(palm.transform.position);
//		ray = mainCamera.ScreenPointToRay(screenPoint);
//
//		Debug.DrawLine(ray.origin, palm.transform.position, Color.green);


		sculptMesh.intersectRayMesh(ray);

		float radius = sculpter.radius * hand.SphereRadius * Leap.UnityVectorExtension.ScaleFactor; // * (camera.fieldOfView/180.0f); // scale the radius depending on "distance"
		
		this.iVertsSelected = sculptMesh.pickVerticesInSphere(radius);
		Vector3 center = sculptMesh.intersectionPoint;
		
		float intensity = sculpter.intensity;
		
		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
		                center, radius, intensity, Sculpt.Tool.SMOOTH);
		
		sculptMesh.updateMesh(this.iTrisSelected, this.iVertsSelected, true);
		
		sculptMesh.pushMeshData();

	}





	public override void OnDestroy(){
		activatePalm();
		base.OnDestroy();
	}
}
