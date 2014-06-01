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

	public Light fingerLight = null;
	public Light palmLight = null;

	Vector3 lastPalmPosition = Vector3.zero;
	Quaternion lastPalmRotation = Quaternion.identity;

	public List<int> pickedVertices = new List<int>();
	public List<int> pickedVerticesSymmetry = new List<int>();
	public List<float> smoothedRadius = new List<float>(0);

	private MenuBehavior.ButtonAction tool_;
	public MenuBehavior.ButtonAction tool{
		get{
			return tool_;
		}
		set{
			tool_ = value;
			switch(tool_){
			
			case MenuBehavior.ButtonAction.TOOL_GRAB:
			case MenuBehavior.ButtonAction.TOOL_SMOOTH:
				palmLight.enabled = true;
				fingerLight.enabled = false;
				break;
			case MenuBehavior.ButtonAction.TOOL_PAINT:
				fingerLight.enabled = true;
				palmLight.enabled = false;
				break;

			default:
				palmLight.enabled = false;
				fingerLight.enabled = false;
				break;
			}
		}
	}
	public Vector3 pickingCenter = Vector3.zero;
	public Vector3 pickingCenterSymmetry = Vector3.zero;

	public Vector3 pickingAreaCenter = Vector3.zero;
	public Vector3 pickingAreaCenterSymmetry = Vector3.zero;

	public Vector3 pickingAreaNormal = Vector3.zero;
	public Vector3 pickingAreaNormalSymmetry = Vector3.zero;

	private float pickingRadius_ =1.0f;
	private float brushIntensity_ = 0.5f;

	public float pickingRadius{
		get{
			return pickingRadius_;
		}
		set{
			pickingRadius_ = value;
			fingerLight.range = 2.0f + pickingRadius_ * pickingRadius_;
			palmLight.range =   2.0f + pickingRadius_ * pickingRadius_;
		}
	}
	public float brushIntensity{
		get{
			return brushIntensity_;
		}
		set{
			brushIntensity_ = value;
//			fingerLight.intensity = brushIntensity_ * brushIntensity_;
//			palmLight.intensity = brushIntensity_ * brushIntensity_;
		}
	}


	public Ray dragRay = new Ray();
	public Ray dragRaySymmetry = new Ray();
	void Start() {
	 	IgnoreCollisionsWithSelf();

	}

	public override void InitHand() {

	   	SetPositions();

//		palm.AddComponent<Light>();
//		palm.light.color = Color.red;
//		palm.light.intensity = 2.0f;
//		palm.light.range = 4.0f;

	}

	public override void UpdateHand() {
    	SetPositions();
		for (int i = 0; i < fingers.Length; ++i) {
			if (fingers[i] != null)
				fingers[i].UpdateFinger();
		}
		if(smoothedRadius.Count > 5){
			smoothedRadius.RemoveAt(0);
		}
		smoothedRadius.Add(GetSphereRadius());
  	}

	public bool IsLeftHand(){
		return GetLeapHand().IsLeft;
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

	public float GetSphereRadiusSmoothed(){
		float r = 0.0f;
		for(int i = 0; i < smoothedRadius.Count; i++){
			r += smoothedRadius[i];
		}
		return r/smoothedRadius.Count;
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


	public Vector3 GetPalmVelocity(){
		Hand leap_hand = GetLeapHand();
		Vector3 local_velocity = leap_hand.PalmVelocity.ToUnity();
		
		return GetController().transform.TransformDirection(local_velocity);
	}

	public Vector3 GetPalmDirection(){
		Hand leap_hand = GetLeapHand();
		Vector3 local_direction = leap_hand.Direction.ToUnity();
		
		return GetController().transform.TransformDirection(local_direction);
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
