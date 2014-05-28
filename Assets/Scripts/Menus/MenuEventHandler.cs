using UnityEngine;
using System.Collections;

public class MenuEventHandler : MonoBehaviour {

	TextMesh eventText;

	
	void Start () { 

		eventText = gameObject.GetComponent(typeof(TextMesh)) as TextMesh;
	}

	public void recieveMenuEvent(MenuBehavior.ButtonAction action, SkeletalHand hand)
	{
		eventText.text = "Events:\n" + action.ToString() +  " from " + hand.GetLeapHand().ToString();
		switch(action){
		case MenuBehavior.ButtonAction.TOOL_SMOOTH:

			break;
		case MenuBehavior.ButtonAction.TOOL_PAINT:
			break;
			
		case MenuBehavior.ButtonAction.TOOL_GROW:
			break;
			
		default: break;
		}

	}
}
