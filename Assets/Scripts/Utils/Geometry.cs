// ------------------------------------------------------------------------------
//  <autogenerated>
//      This code was generated by a tool.
//      Mono Runtime Version: 4.0.30319.1
// 
//      Changes to this file may cause incorrect behavior and will be lost if 
//      the code is regenerated.
//  </autogenerated>
// ------------------------------------------------------------------------------
using System.Collections.Generic;
using UnityEngine;

public class Geometry
{
	public static void triangleNormal(Vector3 v1, Vector3 v2, Vector3 v3, out Vector3 normal){
		normal = (v1 + v2 + v3) / 3;
	}

	public static void triangleAabb(Vector3 v1, Vector3 v2, Vector3 v3, out Bounds aabb){
		aabb = new Bounds();

		Vector3 min = Vector3.Min(v1, v2);
		min = Vector3.Min(min, v3);

		Vector3 max = Vector3.Min(v1, v2);
		max = Vector3.Max(max, v3);
		aabb.center = (min + max) * 0.5f;
		aabb.Encapsulate(v1);
		aabb.Encapsulate(v2);
		aabb.Encapsulate(v3);
	}

	public static bool boundsIntersectSphere(Bounds aabb, Vector3 c, float r){
		return StaticTest(aabb.min, aabb.max, c, r);
	}

	//http://blog.nuclex-games.com/tutorials/collision-detection/static-sphere-vs-aabb/
	public static bool StaticTest(Vector3 aabbMin, Vector3 aabbMax, Vector3 sphereCenter, float sphereRadius)
	{
		Vector3 closestPointInAabb = Vector3.Min(Vector3.Max(sphereCenter, aabbMin), aabbMax);
		float distanceSquared = (closestPointInAabb - sphereCenter).sqrMagnitude;
		
		// The AABB and the sphere overlap if the closest point within the rectangle is
		// within the sphere's radius
		return distanceSquared < (sphereRadius );//* sphereRadius);
	}

	/** If a sphere intersect a triangle */
	public static bool triangleInsideSphere(Vector3 point, float radiusSq, Vector3 v1, Vector3 v2, Vector3 v3)
	{
		if (Geometry.distanceSqToSegment(point, v1, v2) < radiusSq) return true;
		if (Geometry.distanceSqToSegment(point, v2, v3) < radiusSq) return true;
		if (Geometry.distanceSqToSegment(point, v1, v3) < radiusSq) return true;
		return false;
	}

	/** Minimum squared distance to a segment */
	public static float distanceSqToSegment(Vector3 point, Vector3 v1, Vector3 v2)
	{                           
		Vector3 pt = Vector3.zero;
		Vector3 v2v1 = Vector3.zero;

		pt = point - v1;
		v2v1 = v2 - v1;
			
		float len = v2v1.sqrMagnitude;
		float t = Vector3.Dot(pt, v2v1) / len;
		if (t < 0.0) return pt.sqrMagnitude;
		if (t > 1.0) return (point - v2).sqrMagnitude;
		
		pt[0] = point[0] - v1[0] - t * v2v1[0];
		pt[1] = point[1] - v1[1] - t * v2v1[1];
		pt[2] = point[2] - v1[2] - t * v2v1[2];
		return pt.sqrMagnitude;

	}

	/** If point is inside the triangle, test the sum of the areas */
	public static bool pointInsideTriangle(Vector3 point, Vector3 v1, Vector3 v2, Vector3 v3)
	{
		Vector3 vec1 = Vector3.zero;
		Vector3 vec2 = Vector3.zero;
		Vector3 vecP1 = Vector3.zero;
		Vector3 vecP2 = Vector3.zero;


		vec1 = v1 - v2;
		vec2 = v1 - v3;
		vecP1 = point - v2;
		vecP2 = point - v3;
		float total = Vector3.Cross(vec1, vec2).magnitude;
		float area1 = Vector3.Cross(vec1, vecP1).magnitude;
		float area2 = Vector3.Cross(vec2, vecP2).magnitude;
		float area3 = Vector3.Cross(vecP1, vecP2).magnitude;
		return Mathf.Abs(total - (area1 + area2 + area3)) < 1E-20;

	}
}


