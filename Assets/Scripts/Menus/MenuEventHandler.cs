using UnityEngine;
using System.Collections;

public class MenuEventHandler : MonoBehaviour {

	TextMesh eventText;
	string leftTool;
	string rightTool;
	ToolDispatcher toolDispatcher;
	void Start () { 

		eventText = gameObject.GetComponent(typeof(TextMesh)) as TextMesh;
		toolDispatcher = gameObject.GetComponent<ToolDispatcher>();
	}

	public void recieveMenuEvent(MenuBehavior.ButtonAction action, SkeletalHand hand)
	{
		if(hand.IsLeftHand() ){
			leftTool = action.ToString();
		}else{
			rightTool = action.ToString();
		}
		eventText.text = "Left:" + leftTool + "\n" +
			"Right: " + rightTool;

		toolDispatcher.SetToolForHand(action, hand);

//		switch(action){
//		case MenuBehavior.ButtonAction.TOOL_SMOOTH:
//			toolDispatcher.SetToolForHand(Sculpt.Tool.SMOOTH, hand);
//			break;
//
//		case MenuBehavior.ButtonAction.TOOL_PAINT:
//			toolDispatcher.SetToolForHand(Sculpt.Tool.BRUSH, hand);
//			break;
//
//		case MenuBehavior.ButtonAction.TOOL_PAINT_ASSISTENT:
//			toolDispatcher.SetToolForHand(Sculpt.Tool.BRUSH_SECONDARY, hand);
//			break;
//			
//		case MenuBehavior.ButtonAction.TOOL_DRAG:
//			toolDispatcher.SetToolForHand(Sculpt.Tool.DRAG, hand);
//			break;
//			
//		default: break;
//		}

	}
}
