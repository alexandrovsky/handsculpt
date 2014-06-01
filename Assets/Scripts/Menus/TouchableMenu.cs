using UnityEngine;
using System.Collections;

public class TouchableMenu : MonoBehaviour {



	public MenuBehavior.ButtonAction buttonAction;


	HandController handController;
	ToolDispatcher toolDispatcher;



	Camera uiCam;
	Camera handCamera;

	bool isSelected;


	public MenuEventHandler eventHandler;

	// Use this for initialization
	void Start () {
		uiCam = (GameObject.Find("UI Camera") as GameObject).GetComponent(typeof(Camera)) as Camera;
		handCamera = (GameObject.Find("Hand Camera") as GameObject).GetComponent(typeof(Camera)) as Camera;
		handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
		toolDispatcher = (GameObject.Find("GuiEventListener ") as GameObject).GetComponent(typeof(ToolDispatcher)) as ToolDispatcher;

	}
	

	public bool CheckHand(SkeletalHand hand){
		SkeletalFinger finger = hand.GetFingerWithType(Leap.Finger.FingerType.TYPE_INDEX) as SkeletalFinger;
		Vector3 pointerPositionWorld = finger.bones[3].transform.position;
		
		
		if(pointerPositionWorld.z < transform.position.z){
			//Debug.Log("lefthand behind menu");
			renderer.enabled = true;
			toolDispatcher.toolsEnabled = false;
		}else{ 
			//Debug.Log("lefthand in front menu");
			renderer.enabled = false;
			toolDispatcher.toolsEnabled = true;
			if(isSelected){
				Debug.Log("Menu item selected");
				
				eventHandler.recieveMenuEvent(buttonAction, hand);
			}
		}
		
		if(renderer.enabled){ 
			Vector3 fwd = handCamera.transform.forward;
			Ray ray = new Ray(pointerPositionWorld, fwd);
			
			Debug.DrawLine(ray.origin, ray.direction * 10);
			
			RaycastHit hit;
			if( Physics.Raycast(ray,out hit) ){
				if(hit.collider.tag == "Menu"){
					renderer.material.color = Color.green;
					isSelected = true;

				}
			}else{
				renderer.material.color = Color.white;
				isSelected = false;
			}
		}
		
		return renderer.enabled;

	}

	void Update () {


		if(!CheckHand(handController.leftHand)){
			CheckHand(handController.rightHand);
		}



	}
}
