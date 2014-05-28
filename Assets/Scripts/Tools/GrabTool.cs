
using UnityEngine;
using System.Collections.Generic;
using Leap;
using Sculpt;




public class GrabTool : ManipulationHandTool 
{	

	Vector3 grabInitPos = Vector3.zero;
	Dictionary<int, float> selectedVertices;

	float radius;
	public override void Start () {
		name = "grab";
		workingHandIdx = 0;
		base.Start();
		mode = HandTool.HandToolMode.Enabled;
		sculpter.tool = Sculpt.Tool.DRAG;
		selectedVertices = new Dictionary<int, float>();
		activatePalm();
	}


	public override void CostumGUI(){

	}

	public void ManipulateVertices(){
		foreach(int v_idx in selectedVertices.Keys ){
			float dist = selectedVertices[v_idx];

			Vector3 vertex =  target.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);

			Vector3 dragDirection = (palm.transform.position -lastPalmPosition);


			float fallOff = dist * dist;
			fallOff = 3.0f * fallOff * fallOff - 4.0f * fallOff * dist + 1.0f;
			vertex += dragDirection * fallOff;

//			Debug.DrawLine(vertex, vertex+dragDirection);

//			sculptMesh.colorArray[v_idx] = Sculpter.ACTIVATED;
			//updateSelector(this.radius, 1.0f);
			colorizeSelectedVertices(sculptMesh.intersectionPoint, radius, 1.0f, sculpter.activated);
			sculptMesh.vertexArray[v_idx] = target.transform.InverseTransformPoint(vertex);
		}

	}

	public override void Update () 
	{

		sculpter.clear();
		base.Update();
		
		if( !hand.IsValid || HandTool.HandToolMode.Disabled == mode)
		{
			selectedVertices.Clear();
			iVertsSelected.Clear();
			return; // --- OUT --->
		}


		if(hand.GrabStrength > 0.8 ){
			mode = HandToolMode.Manipulate;
			sculpter.activated = true;

			ray = new Ray(grabInitPos, palm.transform.position);
			sculpter.dragDir = ray.direction;
//			ray = new Ray(sculptMesh.intersectionPoint, palm.transform.position - lastPalmPosition);
			Debug.DrawLine(ray.origin, ray.origin + ray.direction, Color.blue);
			ManipulateVertices();
		}else{

			mode = HandToolMode.Select;
			sculpter.activated = false;
			grabInitPos = palm.transform.position;
//			Vector3 screenPoint = mainCamera.WorldToScreenPoint(palm.transform.position);
//			ray = mainCamera.ScreenPointToRay(screenPoint);
//

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
			// --- 

			this.radius = sculpter.radius * (mainCamera.fieldOfView/180.0f); // scale the radius depending on "distance"
			
			this.iVertsSelected = sculptMesh.pickVerticesInSphere(sculptMesh.intersectionPoint, radius);
			selectedVertices.Clear();

			for(int i = 0; i < iVertsSelected.Count; i++){
				int v_idx = iVertsSelected[i];
				Vector3 v = sculptMesh.transform.TransformPoint(sculptMesh.vertexArray[v_idx]);
				Vector3 delta = v - sculptMesh.intersectionPoint;
				
				float dist = delta.magnitude/radius;
				selectedVertices.Add(v_idx, dist);

				//sculptMesh.colorArray[ iVertsSelected[i] ] = Sculpter.SELECTED_HIGH;

				colorizeSelectedVertices(sculptMesh.intersectionPoint, radius, 0.0f, sculpter.activated);
			}
		}


		sculptMesh.updateMesh(sculpter.iTrisSelected, !sculpter.activated);
		sculptMesh.pushMeshData();

	}

	public override void OnDestroy(){
		base.OnDestroy();
	}
}
