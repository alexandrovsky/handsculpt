/******************************************************************************\
* Copyright (C) Leap Motion, Inc. 2011-2014.                                   *
* Leap Motion proprietary. Licensed under Apache 2.0                           *
* Available at http://www.apache.org/licenses/LICENSE-2.0.html                 *
\******************************************************************************/

using UnityEngine;
using System.Collections.Generic;
using Leap;

public class HandController : MonoBehaviour {


  // Reference distance from thumb base to pinky base in mm.
  	protected const float MODEL_PALM_WIDTH = 85.0f;

  	public bool separateLeftRight = false;

//prefabs:
	public HandModel leftGraphicsModel;
	public HandModel leftPhysicsModel;
	public HandModel rightGraphicsModel;
	public HandModel rightPhysicsModel;
//

	public SkeletalHand leftHand;
	public SkeletalHand rightHand;

//	public RigidHand leftRigidHand;
//	public RigidHand rightRigidHand;

  	private Controller leap_controller_;
  	



  	void Start() {

    	leap_controller_ = new Controller();

//		leap_controller_.EnableGesture(Gesture.GestureType.TYPE_SCREEN_TAP, true);
//		if(leap_controller_.IsGestureEnabled(Gesture.GestureType.TYPE_SCREEN_TAP) ){
//			Debug.Log("screen tap enabled, success ");
//		}


		leftHand = CreateHand(leftGraphicsModel) as SkeletalHand;
		leftHand.name = "left_hand";
		rightHand = CreateHand(rightGraphicsModel) as SkeletalHand;
		rightHand.name = "right_hand";


//		leftRigidHand = CreateHand(leftPhysicsModel) as RigidHand;
//		leftRigidHand.name = "left_rigid_hand";
//		rightRigidHand = CreateHand(rightPhysicsModel) as RigidHand;
//		rightRigidHand.name = "right_rigid_hand";

    	if (leap_controller_ == null) {
      		Debug.LogWarning(
          		"Cannot connect to controller. Make sure you have Leap Motion v2.0+ installed");
    	}
  	}




  	private void IgnoreHandCollisions(HandModel hand) {
    	// Ignores hand collisions with immovable objects.
    	Collider[] colliders = gameObject.GetComponentsInChildren<Collider>();
    	Collider[] hand_colliders = hand.GetComponentsInChildren<Collider>();

    	for (int i = 0; i < colliders.Length; ++i) {
      		for (int h = 0; h < hand_colliders.Length; ++h) {
        		if (colliders[i].rigidbody == null){
          			Physics.IgnoreCollision(colliders[i], hand_colliders[h]);
				}
      		}
    	}
  	}

  	HandModel CreateHand(HandModel model) {
    	HandModel hand_model = Instantiate(model, transform.position, transform.rotation)
                           as HandModel;
    	hand_model.gameObject.SetActive(true);
		IgnoreHandCollisions(hand_model);

    	return hand_model;
  	}	

  	

  	void Update() {
		if (leap_controller_ == null)
	      		return;

	    Frame frame = leap_controller_.Frame();
		foreach(Hand hand in frame.Hands){
			if(hand.IsLeft){
				updateHand(hand, leftHand);
			}else{
				updateHand(hand, rightHand);
			}
		}


		foreach(Gesture g in frame.Gestures() ){
			Debug.Log("gesture:" +  g.ToString() );
		}

	   	
  	}

	private void updateHand(Hand leap_hand, SkeletalHand hand){
		hand.SetLeapHand(leap_hand);
		hand.SetController(this);
		float hand_scale = leap_hand.PalmWidth / MODEL_PALM_WIDTH;
		hand.transform.localScale = hand_scale * transform.localScale;
		hand.UpdateHand();
		
	}
	
	void FixedUpdate() {
		if (leap_controller_ == null)
	    return;

//		Frame frame = leap_controller_.Frame();
//		foreach(Hand hand in frame.Hands){
//			if(hand.IsLeft){
//				updateHand(hand, leftRigidHand);
//			}else{
//				updateHand(hand, rightRigidHand);
//			}
//		}
	}

	public Frame GetFrame(int idx){
		return leap_controller_.Frame(idx);
	}

}
