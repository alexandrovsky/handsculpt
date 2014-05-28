using UnityEngine;
using System.Collections;
using Leap;
public class ToolDispatcher : MonoBehaviour {

	// Use this for initialization
	GameObject Widget;
	HandController handController;
	void Start () {
		handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
		Widget = GameObject.CreatePrimitive(PrimitiveType.Sphere);

	}
	
	// Update is called once per frame
	void Update () {
		Widget.transform.position = handController.leftHand.palm.transform.position;

	}


	public void WidgetGuiButtonPressed(int id){
		Debug.Log("WidgetButtonPressed" + id);
	}
}
