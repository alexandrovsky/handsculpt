using UnityEngine;
using System.Collections;

public class MenuEventHandler : MonoBehaviour {

	TextMesh eventText;

	ToolDispatcher toolDispatcher;
	void Start () { 

		eventText = gameObject.GetComponent(typeof(TextMesh)) as TextMesh;
		toolDispatcher = gameObject.GetComponent<ToolDispatcher>();
	}

	public void recieveMenuEvent(MenuBehavior.ButtonAction action, SkeletalHand hand)
	{
		eventText.text = "Events:\n" + action.ToString() +  " from " + hand.GetLeapHand().ToString();
		switch(action){
		case MenuBehavior.ButtonAction.TOOL_SMOOTH:
			toolDispatcher.SetToolForHand(Sculpt.Tool.SMOOTH, hand);
			break;
		case MenuBehavior.ButtonAction.TOOL_PAINT:
			toolDispatcher.SetToolForHand(Sculpt.Tool.BRUSH, hand);
			break;
			
		case MenuBehavior.ButtonAction.TOOL_GROW:
			toolDispatcher.SetToolForHand(Sculpt.Tool.DRAG, hand);
			break;
			
		default: break;
		}

	}
}
