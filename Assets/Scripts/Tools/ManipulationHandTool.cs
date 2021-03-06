// ------------------------------------------------------------------------------
//  <autogenerated>
//      This code was generated by a tool.
//      Mono Runtime Version: 4.0.30319.1
// 
//      Changes to this file may cause incorrect behavior and will be lost if 
//      the code is regenerated.
//  </autogenerated>
// ------------------------------------------------------------------------------
using UnityEngine;
using System.Collections.Generic;
using Leap;
using Sculpt;


public abstract class ManipulationHandTool : HandTool
{
	public enum SelectionMode{
		EYE_TO_PALM_POS,
		CENTER_TO_PALM_POS,
		PALM_POS_TO_PALM_UP
	}

	protected TargetObjectScript tos;

	public SelectionMode selectionMode = SelectionMode.PALM_POS_TO_PALM_UP; // for witchin betee

	public int vertexWithMaxDistance = 0;
	public float maxDistanceFromHit = 0.0f;
	protected Sculpter sculpter;
	protected SculptMesh sculptMesh;
	public Ray ray;

	public static int radiusQueueSize = 10;
	protected List<float> radiusQueue = new List<float>();

	public Vector3 gizmoPos = Vector3.zero;
	public float gizmoRadius = 1.0f;
	public GameObject selector = null;

	protected List<int> iVertsSelected = new List<int>();
	protected List<int> iTrisSelected = new List<int>();

	public override void Start()
	{	
		Debug.Log("Manipulation tool started");
		base.Start();
		sculpter = target.GetComponent<Sculpter>();
		sculptMesh = target.GetComponent<SculptMesh>();

	}

	public void createSelector(){
		destroySelector();
		selector = GameObject.CreatePrimitive(PrimitiveType.Sphere);
		selector.renderer.material.shader = Shader.Find("Transparent/Diffuse");
		selector.renderer.material.color = Sculpt.Sculpter.CLEAR;

	}


	public void colorizeSelectedVertices(Vector3 center, float radius, float intensity, bool flag){
		Vector4 brushPos = new Vector4(center.x, 
		                               center.y, 
		                               center.z,
		                               1.0f);
		target.renderer.material.SetVector("_BrushPos", brushPos);
		target.renderer.material.SetFloat("_BrushRadius", radius);
		target.renderer.material.SetFloat("_BrushActivationState", intensity);
		target.renderer.material.SetInt("_BrushActivationFlag", flag ? 1 : 0);

		Debug.Log("flag:" + flag);

//		target.renderer.material.SetColor("_BrushColorSelectedLow", Sculpter.SELECTED_LOW);
//		target.renderer.material.SetColor("_BrushColorSelectedHigh", Sculpter.SELECTED_HIGH);
//		target.renderer.material.SetColor("_BrushDirtyColor", Sculpter.ACTIVATED);

	}
	
	public void updateSelector(float radius, float intensity){
		if(iVertsSelected.Count > 0){
			gizmoPos = sculptMesh.intersectionPoint;
			gizmoRadius = radius * radius;
			selector.renderer.material.color = new Color(Sculpter.SELECTED_HIGH.r,
			                                             Sculpter.SELECTED_HIGH.g,
			                                             Sculpter.SELECTED_HIGH.b, 
			                                             0.25f);
			selector.SetActive(false);


		}else{
			gizmoPos = ray.origin + ray.direction;
			gizmoRadius = radius * radius / mainCamera.transform.position.magnitude;
			selector.renderer.material.color = new Color(Sculpter.CLEAR.r,
			                                             Sculpter.CLEAR.g,
			                                             Sculpter.CLEAR.b, 
			                                             0.75f);



			selector.SetActive(true);
		}
		
		selector.transform.position = gizmoPos;
		selector.transform.localScale = Vector3.one * gizmoRadius;
	}

	public void destroySelector(){
		if(selector != null){
			GameObject.Destroy(selector);
			selector = null;
		}
	}
	void OnDrawGizmos(){

//		Gizmos.DrawWireSphere(gizmoPos, gizmoRadius);

//		Gizmos.color = Color.green;
////		Gizmos.DrawLine(ray.origin, ray.origin + ray.direction * 100);

//		Leap.InteractionBox iBox = LeapInput.Frame.InteractionBox;
//		Vector3 center = iBox.Center.ToUnityTranslated();
//		Leap.Vector size = new Leap.Vector(iBox.Width, iBox.Height, iBox.Depth);
//		Gizmos.DrawWireCube(center, size.ToUnityTranslated() );
//		Gizmos.DrawWireSphere(center, 0.2f);
//		Gizmos.DrawWireSphere(hand.PalmPosition.ToUnityTranslated(), 0.2f);
//		Gizmos.DrawLine(hand.PalmPosition.ToUnityTranslated(), center);

//		Leap.Vector tipPos = hand.Fingers.Frontmost.StabilizedTipPosition;
//		Vector3 normalizedPosition = iBox.NormalizePoint(tipPos).ToUnity();
//		Gizmos.DrawLine(center, tipPos.ToUnity() );
//		
	}


	public Ray CalculateRay(Leap.Vector pos){
		Leap.InteractionBox iBox = LeapInput.Frame.InteractionBox;
		Leap.Vector normalizedPosition = iBox.NormalizePoint(pos);
		Vector3 screenPos = new Vector3(UnityEngine.Screen.width * normalizedPosition.x,
		                                UnityEngine.Screen.height * normalizedPosition.y,
		                                0.0f);
		ray = Camera.main.ScreenPointToRay (screenPos);
		return ray;
	}

	public override void OnDestroy(){
		destroySelector();
		base.OnDestroy();
	}
}

