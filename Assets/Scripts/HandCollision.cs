using UnityEngine;
using System.Collections;

public class HandCollision : MonoBehaviour {

	
	 void OnCollisionEnter(Collision collision) 
	{
		Debug.Log(name + "Collision!!!");
        
		foreach (ContactPoint contact in collision.contacts) {
			Debug.Log("conatctpoint:" + contact.point);
            //Debug.DrawRay(contact.point, contact.normal, Color.red);
			Debug.DrawRay(contact.point, contact.normal * 10, Color.white, 10);
        }
        
        
    }
}
