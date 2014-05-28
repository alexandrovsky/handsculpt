/******************************************************************************\
* Copyright (C) Leap Motion, Inc. 2011-2014.                                   *
* Leap Motion proprietary. Licensed under Apache 2.0                           *
* Available at http://www.apache.org/licenses/LICENSE-2.0.html                 *
\******************************************************************************/

using UnityEngine;
using System.Collections;
using Leap;

// The finger model for our skeletal hand made out of various polyhedra.
public class SkeletalFinger : FingerModel {

  	public Transform[] bones = new Transform[NUM_BONES];

  	public override void InitFinger() {
    	SetPositions(GetController().transform);
  	}	



  	public override void UpdateFinger() {
    	SetPositions(GetController().transform);
		checkCollision();
  	}



	private void checkCollision(){

		float distance = 1.0f;
		RaycastHit hit;
		if(Physics.Raycast(GetBonePosition(3), GetBoneDirection(3), out hit,distance) ){



			if(hit.collider.tag.Equals("GUIWidget") ){

				WidgetGui widget = hit.collider.gameObject.GetComponent<WidgetGui>();
				//widget.PerformAction();
				widget.SendMessage("WidgetGuiButtonPressed", widget.Identifier);
				Debug.Log("button clicked " + hit.collider.tag);
			}
		}
		Debug.DrawLine(GetBonePosition(3), GetBoneDirection(3), Color.green);


	}

  	private void SetPositions(Transform deviceTransform) {
    	for (int i = 0; i < bones.Length; ++i) {
      		if (bones[i] != null) {
        		bones[i].transform.position = GetBonePosition(i);
        		bones[i].transform.rotation = GetBoneRotation(i);
      		}
    	}
  	}
}
