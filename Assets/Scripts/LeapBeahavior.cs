using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Leap;


public class LeapBeahavior : MonoBehaviour {

	public GameObject HandPrefab;

	public static Leap.Controller 		m_controller	= null;
	public Leap.Frame m_Frame;
    public static int handCount 						= 0;
	
	public IDictionary <int,GameObject> handDict;
	
	void Start()
    {
		Debug.Log( "Leap.Start()" );
        m_controller = new Leap.Controller();
		m_Frame = null;
		
		handDict = new Dictionary<int, GameObject>();
    }


    void Update()
    {
		//Debug.Log( "Leap.Update()" );
		if(null != m_controller){
			Frame lastFrame = m_Frame == null ? Frame.Invalid : m_Frame;
			
        	m_Frame = m_controller.Frame();
			handCount = m_Frame.Hands.Count;
			//Debug.Log("lastFrame: " + lastFrame.Hands.ToString() + "currFrame: " + m_Frame.Hands.ToString());
			HandFound(lastFrame, m_Frame);
			HandLost(lastFrame, m_Frame);
			HandUpdate(m_Frame);
        // do something with the tracking data in the frame...
		}
		
		
    }
	
	void HandFound(Frame oldFrame, Frame newFrame){
		foreach( Hand h in newFrame.Hands )
		{
			if( h.IsValid  && !handDict.ContainsKey(h.Id) ){
				
//				GameObject sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
//				sphere.transform.position =  new Vector3(h.PalmPosition.x, h.PalmPosition.y, -h.PalmPosition.z);
//				sphere.transform.localScale = new Vector3(100.0f, 20.0f, 100.0f);
//				Rigidbody sphereRigidBody = sphere.AddComponent<Rigidbody>();
//				sphereRigidBody.velocity = new Vector3(0.0f, 0.0f, 0.0f);
//				sphereRigidBody.maxAngularVelocity = 0.0f;
//				sphere.name = "hand_"+ h.Id.ToString();
//				
//				sphere.AddComponent("HandCollision");


				
				
				//sphere.rigidbody.detectCollisions = true;
//				handDict.Add(h.Id, sphere);

				GameObject hand = Instantiate(HandPrefab) as GameObject;
				handDict.Add(h.Id, hand);
			}
		}
	}
	
	void HandLost(Frame oldFrame, Frame newFrame){
		foreach( Hand h in oldFrame.Hands ){
			if( !newFrame.Hand(h.Id).IsValid){
				
				GameObject go = handDict[h.Id];
				//Debug.Log("LostHand with id" +h.Id.ToString()  + go.ToString() );
				Destroy(go);
				handDict.Remove(h.Id);
				
			}
		}
	}
	void HandUpdate(Frame frame){
		foreach(Hand h in frame.Hands){

//			Vector3 vFingerDir = pointable.Direction.ToUnity();
//			Vector3 vFingerPos = pointable.TipPosition.ToUnityTranslated();
//			
//			fingerObject.transform.localPosition = vFingerPos;
//			fingerObject.transform.localRotation = Quaternion.FromToRotation( Vector3.forward, vFingerDir );

			handDict[h.Id].transform.position = new Vector3(h.PalmPosition.x, h.PalmPosition.y, -h.PalmPosition.z);
			Vector3 palmNormal = new Vector3(h.PalmNormal.x, h.PalmNormal.y, h.PalmNormal.z);
			handDict[h.Id].transform.localRotation = Quaternion.FromToRotation(Vector3.down, palmNormal); 
		}
	}
}
