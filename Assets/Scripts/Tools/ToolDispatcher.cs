
using UnityEngine;
using System.Collections;
using Sculpt;

public class ToolDispatcher : MonoBehaviour {

	// Use this for initialization
	HandController _handController;
	Sculpt.Tool currentLeftTool = Tool.NONE;
	Sculpt.Tool currentRightTool = Tool.NONE;
	void Start () {
		_handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
	}
	
	// Update is called once per frame
	void Update () {
		switch(currentLeftTool){
		case Tool.BRUSH:
			break;
		case Tool.SMOOTH:
			break;
		case Tool.DRAG:
			break;
		default: break;
		}

		switch(currentRightTool){
		case Tool.BRUSH:
			break;
		case Tool.SMOOTH:
			break;
		case Tool.DRAG:
			break;
		default: break;
		}

	}

	public void SetToolForHand(Sculpt.Tool tool, SkeletalHand hand){
		if(hand.GetLeapHand().IsLeft){
			currentLeftTool = tool;
		}else{
			currentRightTool = tool;
		}
	}
}
