/******************************************************************************\
* Copyright (C) Leap Motion, Inc. 2011-2014.                                   *
* Leap Motion proprietary. Licensed under Apache 2.0                           *
* Available at http://www.apache.org/licenses/LICENSE-2.0.html                 *
\******************************************************************************/

using UnityEngine;
using System.Collections;
using Leap;

// The model for our skeletal hand made out of various polyhedra.
public class SkeletalHand : HandModel {

  protected const float PALM_CENTER_OFFSET = 15.0f;

  public GameObject palm;

  void Start() {
    IgnoreCollisionsWithSelf();
  }

  public override void InitHand() {
    SetPositions();
  }

  public override void UpdateHand() {
    SetPositions();
		for (int i = 0; i < fingers.Length; ++i) {
			if (fingers[i] != null)
				fingers[i].UpdateFinger();
		}

  }

	public float GetPinchStrength(){
		Hand leap_hand = GetLeapHand();
		return leap_hand.PinchStrength;
	}

	public Vector3 GetSphereCenter(){
		Hand leap_hand = GetLeapHand();
		Vector3 offset = leap_hand.Direction.ToUnityScaled() * PALM_CENTER_OFFSET;
	    //Vector3 local_center = leap_hand.PalmPosition.ToUnityScaled() - offset;

		Vector3 local_center = leap_hand.SphereCenter.ToUnityScaled() - offset;
		return GetController().transform.TransformPoint(local_center);
	}

	public float GetSphereRadius(){
		Hand leap_hand = GetLeapHand();
		return leap_hand.SphereRadius;
	}

	protected Vector3 GetPalmCenter() {
	    Hand leap_hand = GetLeapHand();
	    Vector3 offset = leap_hand.Direction.ToUnityScaled() * PALM_CENTER_OFFSET;
	    Vector3 local_center = leap_hand.PalmPosition.ToUnityScaled() - offset;

	    return GetController().transform.TransformPoint(local_center);
  	}

	protected Quaternion GetPalmRotation() {
    	return GetController().transform.rotation *
          	 GetLeapHand().Basis.Rotation();
  	}

	protected void SetPositions() {
    	for (int f = 0; f < fingers.Length; ++f) {
      		if (fingers[f] != null)
        		fingers[f].InitFinger();
		}

    	if (palm != null) {
      		palm.transform.position = GetPalmCenter();
      		palm.transform.rotation = GetPalmRotation();
    	}
  	}

	public FingerModel GetFingerWithType(Finger.FingerType type){
		foreach(FingerModel fm in fingers){
			if(fm.fingerType == type){
				return fm;
			}
		}
		return null;
	}
}
