/******************************************************************************\
* Copyright (C) Leap Motion, Inc. 2011-2013.                                   *
* Leap Motion proprietary and  confidential.  Not for distribution.            *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement between *
* Leap Motion and you, your company or other organization.                     *
\******************************************************************************/

using UnityEngine;
using System.Collections;
using Leap;

namespace Leap {


	// Extension to the unity Matrix class.
	// Provides conversions to Quaternion and translations.
	public static class UnityMatrixExtension {
		public static readonly Vector LEAP_UP = new Vector(0, 1, 0);
		public static readonly Vector LEAP_FORWARD = new Vector(0, 0, -1);
		public static readonly Vector LEAP_ORIGIN = new Vector(0, 0, 0);
		
		public static Quaternion Rotation(this Matrix matrix) {
			Vector3 up = matrix.TransformDirection(LEAP_UP).ToUnity();
			Vector3 forward = matrix.TransformDirection(LEAP_FORWARD).ToUnity();
			return Quaternion.LookRotation(forward, up);
		}
		
		public static Vector3 Translation(this Matrix matrix) {
			return matrix.TransformPoint(LEAP_ORIGIN).ToUnityScaled();
		}
	}


	//Extension to the unity vector class. Provides automatic scaling into unity scene space.
	//Leap coordinates are in cm, so the .02f scaling factor means 1cm of hand motion = .02m scene motion
	public static class UnityVectorExtension
	{
		public static float ScaleFactor =  1.0f;//0.02f;
//		public static Vector3 InputScale = new Vector3(ScaleFactor, ScaleFactor, ScaleFactor);
//		public static Vector3 InputOffset = new Vector3(0, 0, 0);

//		public static Vector3 InputScale = new Vector3(0.04f, 0.04f, 0.04f);
//		public static Vector3 InputOffset = new Vector3(0,-8,0);

		public static Vector3 InputScale = new Vector3(INPUT_SCALE, INPUT_SCALE, INPUT_SCALE);
		public static Vector3 InputOffset = new Vector3(0, 0,0);

		// Leap coordinates are in mm and Unity is in meters. So scale by 1000.
		public const float INPUT_SCALE = 0.001f;
		public static readonly Vector3 Z_FLIP = new Vector3(1, 1, -1);
		
		// For directions.
		public static Vector3 ToUnity(this Vector leap_vector) {
			return FlipZ(ToVector3(leap_vector));
		}
		
		// For positions and scaled vectors.
		public static Vector3 ToUnityScaled(this Vector leap_vector) {
			return INPUT_SCALE * FlipZ(ToVector3(leap_vector));
		}
		
		private static Vector3 FlipZ(Vector3 vector) {
			return Vector3.Scale(vector, Z_FLIP);
		}
		
		private static Vector3 ToVector3(Vector vector) {
			return new Vector3(vector.x, vector.y, vector.z);
		}
	



//		//For Directions
//		public static Vector3 ToUnity(this Vector lv)
//		{
//			return FlippedZ(lv);
//		}
//		//For Acceleration/Velocity
//		public static Vector3 ToUnityScaled(this Vector lv)
//		{
//			return Scaled(FlippedZ( lv ));
//		}
//		//For Positions
		public static Vector3 ToUnityTranslated(this Vector lv)
		{
			return Offset(Scaled(FlippedZ( lv )));
		}
		
		private static Vector3 FlippedZ( Vector v ) { return new Vector3( v.x, v.y, -v.z ); }
		private static Vector3 Scaled( Vector3 v ) { return new Vector3( v.x * InputScale.x,
																		 v.y * InputScale.y,
																		 v.z * InputScale.z ); }
		private static Vector3 Offset( Vector3 v ) { return v + InputOffset; }
	}
}
