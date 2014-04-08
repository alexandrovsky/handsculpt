using UnityEngine;
using System.Collections;

public class TargetTransformer : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
		if(Input.GetKeyDown(KeyCode.Z)){
			transform.Rotate(Vector3.forward, 10);
		}
		if(Input.GetKeyDown(KeyCode.X)){
			transform.Rotate(Vector3.up, 10);
		}
	}
}
