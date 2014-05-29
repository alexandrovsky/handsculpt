
using UnityEngine;
using System.Collections.Generic;
using Sculpt;

public class ToolDispatcher : MonoBehaviour {

	public Vector3 center =Vector3.zero;
	public float radius = 2.0f;
	public float intensity = 0.5f;

	public Sculpt.Tool currentLeftTool = Tool.BRUSH;
	public Sculpt.Tool currentRightTool = Tool.BRUSH_SECONDARY;


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

		sculptMesh.updateMesh(this.iTrisSelected, true);
		sculptMesh.pushMeshData();
	}

	public void UpdateBrushTool(SkeletalHand hand, bool isLeft){


		SkeletalFinger finger = hand.GetFingerWithType(Leap.Finger.FingerType.TYPE_INDEX) as SkeletalFinger;
		center = finger.bones[3].transform.position;


		iVertsSelected = sculptMesh.pickVerticesInSphere(center, radius);
		this.iTrisSelected.AddRange(sculptMesh.getTrianglesFromVertices(iVertsSelected) );
		sculpter.activated = true;
		sculpter.sculpt(mainCamera.transform.forward, iVertsSelected, 
		       center, radius, intensity, Tool.BRUSH);



		ColorizeSelectedVertices(center, radius, intensity, true, isLeft);

	}

	public void UpdateBrushSecondaryTool(SkeletalHand hand, bool isLeft){
		radius = (1 - hand.GetPinchStrength() );
	}

	public void UpdateSmoothTool(SkeletalHand hand, bool isLeft){

		sculptMesh.pickVerticesInSphere(center, radius);
		center = hand.GetSphereCenter();

		ColorizeSelectedVertices(center, radius, intensity, true, hand.GetLeapHand().IsRight);

		
	}

	public void UpdateDragTool(SkeletalHand hand, bool isLeft){
		radius = hand.GetSphereRadius();
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
