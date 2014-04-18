using UnityEngine;
using System.Collections;
using Leap;




public abstract class HandTool : MonoBehaviour {
	
	public enum HandToolMode{
		Manipulate,
		Select,
		Enabled,
		SwitchedEnabled, // spectial mode for finding enter point
		Disabled,
		SwitchedDisabled
	
	};

	public Camera mainCamera;

	public float MinActivationDistance;

	public HandToolMode m_mode = HandToolMode.Disabled;
	public HandToolMode mode{
		get{
			return m_mode;
		}
		set{
			lastMode = m_mode;
			
			if(HandToolMode.Disabled == lastMode && HandToolMode.Enabled == value){
				m_mode = HandToolMode.SwitchedEnabled;
			}else if(HandToolMode.Enabled == lastMode && HandToolMode.Disabled == value){
				m_mode = HandToolMode.SwitchedDisabled;
			}else{
				m_mode = value;
			}
		}
	}
	
	
	
	public HandToolMode lastMode;
	public int workingHandIdx = 0;  // on which hand the operator should work
	
	
	//Vector3 offset = new Vector3(0.0f, 0.0f, 0.0f);
	
	
	protected Quaternion lastPalmRotation = Quaternion.identity;
	protected Vector3 lastPalmPosition = Vector3.zero;


	protected LeapUnityHandController controller = null;
	
	protected Leap.Hand hand = Leap.Hand.Invalid;
	protected GameObject palm = null;
	
	
	protected GameObject target = null;
	
	public virtual void Start()
	{	
		mainCamera = Camera.main;
		//transform.localPosition = offset;
		target = GameObject.Find("Target");
		
		GameObject hands = GameObject.Find("Leap Hands");
		controller = hands.GetComponent<LeapUnityHandController>();
		palm = controller.m_palms[workingHandIdx];
		
		LeapInput.HandUpdated += new LeapInput.HandUpdatedHandler(OnHandUpdated);
	}


	void OnHandUpdated( Hand hand ){
		if(hand.Id == controller.HandIdForIndex(workingHandIdx) ){
			this.hand = hand;
		} 	
	}

	public abstract void CostumGUI();

	public void activatePalm(){
//		Collider collider = palm.GetComponent<Collider>();
//		collider.enabled = true;

		palm.SetActive(true);
	}

	public void deactivatePalm(){
		Collider collider = palm.GetComponent<Collider>();
		collider.enabled = false;

		palm.SetActive(false);
	}
	
	public virtual void Update()
	{
		// save last state before transformation:
		lastPalmRotation.Set(transform.rotation.x,
						 transform.rotation.y,
						 transform.rotation.z,
						 transform.rotation.w );
		lastPalmPosition.Set(transform.position.x,
						transform.position.y,
						transform.position.z);
		
		// new transformation:
		transform.rotation = palm.transform.rotation;
		transform.position = palm.transform.position;
	}
	


	
	public virtual void OnDestroy() {
		print(name +" script was destroyed");
    }
}


