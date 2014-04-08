using UnityEngine;
using System.Collections;

public class CameraController : MonoBehaviour {

	Vector3 initPosition = new Vector3(0.0f, 1.0f,-10.0f);
	Quaternion initRotation = Quaternion.identity;
	Camera m_camera = null;
	float speed = 10.0f;
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
	
		m_camera = Camera.main;
		if(m_camera == null){
			return;
		}
		
		if( Input.GetKey(KeyCode.LeftArrow) ){
			m_camera.transform.Translate(Vector3.left*speed*Time.deltaTime);
		}
		if( Input.GetKey(KeyCode.RightArrow) ){
			m_camera.transform.Translate(Vector3.right*speed*Time.deltaTime);
		}
		if( Input.GetKey(KeyCode.UpArrow) ){
			m_camera.transform.Translate(Vector3.forward*speed*Time.deltaTime);
		}
		if( Input.GetKey(KeyCode.DownArrow) ){
			camera.transform.Translate(Vector3.back*speed*Time.deltaTime);
		}
		float angle = 20.0f;
		if( Input.GetKey(KeyCode.W) ){
			camera.transform.Rotate( Vector3.left, angle * Time.deltaTime);
		}
		if( Input.GetKey(KeyCode.S) ){
			camera.transform.Rotate( Vector3.left, -angle * Time.deltaTime);
		}
		if( Input.GetKey(KeyCode.A) ){
			camera.transform.Rotate( Vector3.up, -angle * Time.deltaTime);
		}
		if( Input.GetKey(KeyCode.D) ){
			camera.transform.Rotate( Vector3.up, angle * Time.deltaTime);
		}
		
		if( Input.GetKey(KeyCode.R) ){
			camera.transform.position = initPosition;
			camera.transform.rotation = initRotation;
		}
		
		if( Input.GetKeyDown(KeyCode.F) ){
			GameObject target = GameObject.Find("Target");
			if(target != null){
				camera.transform.LookAt(target.transform);
			}
		}
	}
	
}
