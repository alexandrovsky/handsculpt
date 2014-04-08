// ------------------------------------------------------------------------------
//  <autogenerated>
//      This code was generated by a tool.
//      Mono Runtime Version: 4.0.30319.1
// 
//      Changes to this file may cause incorrect behavior and will be lost if 
//      the code is regenerated.
//  </autogenerated>
// ------------------------------------------------------------------------------


// http://wiki.unity3d.com/index.php/3d_Math_functions

using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public class MathHelper
{
	public MathHelper ()
	{
	}


	/*
	 * y = 1/(sqrt(1*pi*sigma)) * exp( ( (x-mue )²) / ( sqrt(2*sigma²) ) ) 
	 * @param x in range of [0..1]
	 */



	public static float Gaussian2D(float x, float s, float m){
		const float inv_sqrt_2pi = 0.3989422804014327f;
		float a = (x - m) / s;
		return inv_sqrt_2pi / s * Mathf.Exp(-(0.5f) * a * a);
	}


	//caclulate the rotational difference from A to B
	public static Quaternion SubtractRotation(Quaternion B, Quaternion A){
		
		Quaternion C = Quaternion.Inverse(A) * B;		
		return C;
	}

	//This function returns a point which is a projection from a point to a plane.
	public static Vector3 ProjectPointOnPlane(Vector3 planeNormal, Vector3 planePoint, Vector3 point){
		
		float distance;
		Vector3 translationVector;
		
		//First calculate the distance from the point to the plane:
		distance = SignedDistancePlanePoint(planeNormal, planePoint, point);
		
		//Reverse the sign of the distance
		distance *= -1;
		
		//Get a translation vector
		translationVector = SetVectorLength(planeNormal, distance);
		
		//Translate the point to form a projection
		return point + translationVector;
	}

	//Get the shortest distance between a point and a plane. The output is signed so it holds information
	//as to which side of the plane normal the point is.
	public static float SignedDistancePlanePoint(Vector3 planeNormal, Vector3 planePoint, Vector3 point){
		
		return Vector3.Dot(planeNormal, (point - planePoint));
	}

	//create a vector of direction "vector" with length "size"
	public static Vector3 SetVectorLength(Vector3 vector, float size){
		
		//normalize the vector
		Vector3 vectorNormalized = Vector3.Normalize(vector);
		
		//scale the vector
		return vectorNormalized *= size;
	}

	public static float DistanceToLine(Ray ray, Vector3 point)
	{
		return Vector3.Cross(ray.direction, point - ray.origin).magnitude;
	}


	//This function returns a point which is a projection from a point to a line.
	//The line is regarded infinite. If the line is finite, use ProjectPointOnLineSegment() instead.
	public static Vector3 ProjectPointOnLine(Vector3 linePoint, Vector3 lineVec, Vector3 point){		
		
		//get vector from point on line to point in space
		Vector3 linePointToPoint = point - linePoint;
		
		float t = Vector3.Dot(linePointToPoint, lineVec);
		
		return linePoint + lineVec * t;
	}


	public static bool BoxIntersectsSphere(Bounds bounds, Vector3 C, float r) {
		return doesCubeIntersectSphere(bounds.min, bounds.max, C, r);
	}

	static float squared(float v) { return v * v; }
	static bool doesCubeIntersectSphere(Vector3 C1, Vector3 C2, Vector3 S, float R)
	{
		float dist_squared = R * R;
		/* assume C1 and C2 are element-wise sorted, if not, do that now */
		if (S.x < C1.x) dist_squared -= squared(S.x - C1.x);
		else if (S.x > C2.x) dist_squared -= squared(S.x - C2.x);
		if (S.y < C1.y) dist_squared -= squared(S.y - C1.y);
		else if (S.y > C2.y) dist_squared -= squared(S.y - C2.y);
		if (S.z < C1.z) dist_squared -= squared(S.z - C1.z);
		else if (S.z > C2.z) dist_squared -= squared(S.z - C2.z);
		return dist_squared > 0;
	}



}
