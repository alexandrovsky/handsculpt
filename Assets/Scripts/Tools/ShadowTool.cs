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
		MinActivationDistance = 4.0f;
//		deactivatePalm();
	}
	
	public override void CostumGUI(){

		GUILayout.TextField( "dist: " + hand.PalmPosition.ToUnityTranslated().magnitude);
		GUILayout.BeginVertical();{
			GUILayout.TextField("Min Activation Distance: " + MinActivationDistance);
			MinActivationDistance = GUILayout.HorizontalSlider(MinActivationDistance, 0.01f, 12.0f);
		}GUILayout.EndVertical();

//		GUILayout.TextField( "Selection Mode: " + selectionMode);
//		GUILayout.BeginHorizontal();
//		if(GUILayout.Button("1") ) selectionMode = SelectionMode.EYE_TO_PALM_POS;
//		if(GUILayout.Button("2") ) selectionMode = SelectionMode.CENTER_TO_PALM_POS;
//		if(GUILayout.Button("3") ) selectionMode = SelectionMode.PALM_POS_TO_PALM_UP;
//		GUILayout.EndHorizontal();
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


		if(hand.PalmPosition.ToUnityTranslated().magnitude < MinActivationDistance ){
			sculpter.activated = true;
		}else{
			sculpter.activated = false;
		}
		

//		sculptMesh.intersectRayMesh(ray);

		float radius = sculpter.radius * (hand.SphereRadius/10.0f) * (mainCamera.fieldOfView/180.0f); // scale the radius depending on "distance"
		
		this.iVertsSelected = sculptMesh.pickVerticesInSphere(radius);
		Vector3 center = sculptMesh.intersectionPoint;



		float intensity = sculpter.intensity;
		
		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
		                center, radius, intensity, Sculpt.Tool.SMOOTH);
		
		sculptMesh.updateMesh(this.iTrisSelected, this.iVertsSelected, true);
		
		sculptMesh.pushMeshData();

	}





	public override void OnDestroy(){
//		activatePalm();
		base.OnDestroy();
	}
}
