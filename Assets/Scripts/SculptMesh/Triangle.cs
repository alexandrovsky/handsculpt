// ------------------------------------------------------------------------------
//  <autogenerated>
//      This code was generated by a tool.
//      Mono Runtime Version: 4.0.30319.1
// 
//      Changes to this file may cause incorrect behavior and will be lost if 
//      the code is regenerated.
//  </autogenerated>
// ------------------------------------------------------------------------------
using System;
using UnityEngine;
namespace Sculpt
{
	public class Triangle
	{
		public int id;
		public Vector3 normal;
		public Bounds aabb;
		public Octree leaf;
		public int posInLeaf;

		public Triangle(int id)
		{
			this.id = id;
			this.normal = Vector3.forward;
			this.aabb = new Bounds();
			this.leaf = null;
			this.posInLeaf = -1;
		}
	}
}

