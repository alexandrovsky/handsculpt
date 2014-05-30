﻿/******************************************************************************\
* Copyright (C) Leap Motion, Inc. 2011-2014.                                   *
* Leap Motion proprietary. Licensed under Apache 2.0                           *
* Available at http://www.apache.org/licenses/LICENSE-2.0.html                 *
\******************************************************************************/

using UnityEngine;
using System.Collections.Generic;
using Leap;

// The model for our skeletal hand made out of various polyhedra.
public class SkeletalHand : HandModel {

	 protected const float PALM_CENTER_OFFSET = 15.0f;

	public GameObject palm;

	Vector3 lastPalmPosition = Vector3.zero;
	Quaternion lastPalmRotation = Quaternion.identity;

	public List<int> pickedVertices = new List<int>();
	public Vector3 pickingCenter = Vector3.zero;
	public float pickingRadius = 0.75f;
	public float brushIntensity = 0.25f;

	public Ray dragRay = new Ray();
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


	public bool isHandValid(){
		Hand leap_hand = GetLeapHand();
		if(leap_hand == null || !leap_hand.IsValid){
			return false;
		}
		return true;
	}

	public float GetPinchStrength(){
		Hand leap_hand = GetLeapHand();
		return leap_hand.PinchStrength;
	}

	public float GetGrabStrength(){
		Hand leap_hand = GetLeapHand();
		return leap_hand.GrabStrength;
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

	public Vector3 GetPalmCenterSmoothed(){
		Hand leap_hand = GetLeapHand();
		Vector3 offset = leap_hand.Direction.ToUnityScaled() * PALM_CENTER_OFFSET;
		Vector3 local_center = leap_hand.StabilizedPalmPosition.ToUnityScaled() - offset;
		
		return GetController().transform.TransformPoint(local_center);
	}

	public Vector3 GetLastPalmCenter() {
		return lastPalmPosition;
	}
	public Vector3 GetPalmCenter() {
	    Hand leap_hand = GetLeapHand();
	    Vector3 offset = leap_hand.Direction.ToUnityScaled() * PALM_CENTER_OFFSET;
	    Vector3 local_center = leap_hand.PalmPosition.ToUnityScaled() - offset;

	    return GetController().transform.TransformPoint(local_center);
  	}

	public Vector3 GetPalmNormal(){
		Hand leap_hand = GetLeapHand();
		Vector3 local_normal = leap_hand.PalmNormal.ToUnity();
		
		return GetController().transform.TransformDirection(local_normal);
	}

	public Quaternion GetPalmRotation() {
    	return GetController().transform.rotation *
          	 GetLeapHand().Basis.Rotation();
  	}

	public Quaternion GetLastPalmRotation(){
		return lastPalmRotation;
	}

	protected void SetPositions() {
    	for (int f = 0; f < fingers.Length; ++f) {
      		if (fingers[f] != null)
        		fingers[f].InitFinger();
		}

    	if (palm != null) {
			lastPalmPosition = palm.transform.position;
			lastPalmRotation = palm.transform.rotation;

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