/******************************************************************************\
* Copyright (C) Leap Motion, Inc. 2011-2013.                                   *
* Leap Motion proprietary and  confidential.  Not for distribution.            *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement between *
* Leap Motion and you, your company or other organization.                     *
\******************************************************************************/
using UnityEngine;
using System.Collections;

//This relatively simple classis added to fingertip objects by the LeapUnityBridge,
//which allows our LeapSelectionController to be notified when a finger collides with any
//object tagged as 'Touchable'
public class LeapFingerCollisionDispatcher : MonoBehaviour {
	
	//const float kHitDistance = 20.0f;
	const float kHitRadius = 0.5f;
	ContactPoint[] contacts = null;
	
	void OnCollisionEnter(Collision collision) 
	{
		/*
		foreach (ContactPoint contact in collision.contacts) {
            Debug.DrawRay(contact.point, contact.normal * 100.0f, Color.red);
        }
		
		//Debug.Log("Collision with " + collision.gameObject.name);
		if (collision.gameObject.tag == "Touchable")
		{
			//Debug.Log("Collision with " + collision.gameObject.name + " Touchable ");
			
			MeshFilter mf = collision.collider.GetComponent<MeshFilter>();
       		Mesh mesh = mf.mesh;
			
			
			
			Vector3[] vertices = mesh.vertices;
			
        	Vector3 hitPoint = transform.InverseTransformPoint(collision.contacts[0].point);
			Vector3 hitDir = transform.InverseTransformDirection(collision.contacts[0].normal);
			contacts = collision.contacts;
			
			
			int i = 0;
        	while (i < vertices.Length) {
				
            	float distance = Vector3.Distance(vertices[i], hitPoint);
				
				if(distance < kHitRadius){
					
					Vector3 vertMove = hitDir * 0.1f;
                	vertices[i] -= vertMove;
					
				}
				i++;
			}
			mesh.vertices = vertices;
			mesh.RecalculateBounds();
			
		}
		*/
	}
	/*
	void OnCollisionStay(Collision collisionInfo) {
		Debug.Log("OnCollisionStay");
		
        
    }
	*/
	void OnCollisionExit(Collision collision) {
    	//print("No longer in contact with " + collision.gameObject.name);
		contacts = null;
    }
	
	
		/*
	void OnTriggerEnter(Collider other)
	{	
		Debug.Log("OnTriggerEnter");
		if( other.tag == "Touchable" )
		{
			LeapUnitySelectionController.Get().OnTouched(gameObject, other);
		}
	}
	*/
	/*
	void OnTriggerExit(Collider other)
	{
		Debug.Log("Collision Exit");
		if( other.tag == "Touchable" )
		{
			LeapUnitySelectionController.Get().OnStoppedTouching(gameObject, other);	
		}
	}
	*/
	void Update()
	{
		//Debug.DrawRay(transform.position, new Vector3(0.0f, 1.0f, 0.0f) * 100.0f, Color.red);
		if(contacts != null){
			//Debug.Log("---has contacts["+contacts.Length.ToString()+"]");
			foreach(ContactPoint p in contacts){
				Debug.DrawRay(p.point, p.normal, Color.green);
			}
		}else{
			//Debug.Log("has no contacts---");
		}
		
		//Debug.Log("CollisionDispatcher Update(): " + name + " Contains CollisionDispatcher: " + GetComponent<LeapFingerCollisionDispatcher>() != null ? "Yes" : "No");
		/*
		if( gameObject.collider.enabled )
		{
			Debug.DrawRay(transform.position, transform.forward, Color.green);
			RaycastHit hit;
			if( Physics.Raycast(transform.position, transform.forward, out hit, 20.0f) )
			{
				LeapUnitySelectionController.Get().OnRayHit(hit);	
			}
		}
		*/
	}
	
	
}