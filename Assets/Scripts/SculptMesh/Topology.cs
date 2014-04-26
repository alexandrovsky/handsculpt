// ------------------------------------------------------------------------------
//  <autogenerated>
//      This code was generated by a tool.
//      Mono Runtime Version: 4.0.30319.1
// 
//      Changes to this file may cause incorrect behavior and will be lost if 
//      the code is regenerated.
//  </autogenerated>
// ------------------------------------------------------------------------------

using UnityEngine;
using System.Collections.Generic;

namespace Sculpt
{
	public class Topology
	{
		public Vector3 center = Vector3.zero; //center point
		Dictionary<int, int> verticesMap = new Dictionary<int, int>(); //to detect new vertices at the middle of edge (for subdivision)
		float radiusSquared = 0.0f; //radius squared
		List<int> iTrisToDelete = new List<int>(); //triangles to be deleted
		List<int> iVertsToDelete = new List<int>(); //vertices to be deleted
		List<int> iVertsDecimated = new List<int>(); //vertices to be updated (mainly for the VBO's, used in decimation and adaptive topo)
		
		bool linearSubdivision = false; //linear subdivision
		bool checkPlane = false; //terminal critera for subdivision/decimation process (false = spherical selection)
		Vector3 planeOrigin = Vector3.zero; //plane origin
		Vector3 planeNormal = Vector3.zero; //plane normal

		SculptMesh mesh;

		public Topology (SculptMesh mesh)
		{
			this.mesh = mesh;
		}




		public void Subdivision(List<int> iTris, float detailMaxSquared){
			List<Triangle> triangles = this.mesh.triangles;
			int nbTriangles = 0;
			do{
				nbTriangles = triangles.Count;
				iTris = subdivide(iTris, detailMaxSquared);
			}while(nbTriangles != triangles.Count);
		}

		private List<int> subdivide(List<int> iTris, float detailMaxSquared){


			List<Vertex> vertices = mesh.vertices;
			List<Triangle> triangles = mesh.triangles;
			int nbVertsInit = vertices.Count;
			int nbTrisInit = triangles.Count;
			List<int> iTrisSubd = new List<int>();
			List<int> split = new List<int>();
			this.verticesMap.Clear();

			// ---
			initSplit(iTris, iTrisSubd, split, detailMaxSquared);

//			if(iTrisSubd.Count > 20 ){
//				mesh.expandsTriangles(iTrisSubd, 3);
//			}

			for(int i = 0; i < iTrisSubd.Count; i++){
				Vector3[] vAr = mesh.vertexArray;
				int[] iAr = mesh.indexArray;
				
				int id = iTrisSubd[i] * 3;
				
				Vector3 v1 = mesh.transform.TransformPoint(vAr[ iAr[id] ]);
				Vector3 v2 = mesh.transform.TransformPoint(vAr[ iAr[id+1] ]);
				Vector3 v3 = mesh.transform.TransformPoint(vAr[ iAr[id+2] ]);
				
				
				Debug.DrawLine(v1, v2, Color.green);
				Debug.DrawLine(v1, v3, Color.green);
			}

			Debug.Log("tris to subdivide " + iTrisSubd.Count);
			// check array length....
			checkArrayLength(iTrisSubd.Count);
			subdivideTriangles(iTrisSubd, split, detailMaxSquared);

			return iTris;
		}


		public void checkArrayLength(int nbTris){

			int vLen = mesh.vertices.Count + nbTris + 200;
			if(mesh.vertexArray.Length < vLen){
				System.Array.Resize(ref mesh.vertexArray, mesh.vertexArray.Length * 2);
				System.Array.Resize(ref mesh.normalArray, mesh.normalArray.Length * 2);
				System.Array.Resize(ref mesh.colorArray, mesh.colorArray.Length * 2);
				System.Array.Resize(ref mesh.indexArray, mesh.indexArray.Length * 2 * 3);
			}
		}

		/** Subdivide all the triangles that need to be subdivided */
		public void subdivideTriangles(List<int>iTrisSubd, List<int> split, float detailMaxSquared)
		{
			var iAr = this.mesh.indexArray;
			var nbTris = iTrisSubd.Count;
			for (int i = 0; i < nbTris; ++i)
			{
				int ind = iTrisSubd[i] * 3;
				if (split[i] == 1)
					this.halfEdgeSplit(iTrisSubd[i], iAr[ind], iAr[ind + 1], iAr[ind + 2]);
				else if (split[i] == 2)
					this.halfEdgeSplit(iTrisSubd[i], iAr[ind + 1], iAr[ind + 2], iAr[ind]);
				else if (split[i] == 3)
					this.halfEdgeSplit(iTrisSubd[i], iAr[ind + 2], iAr[ind], iAr[ind + 1]);
				else
				{
					int splitNum = this.findSplit(iTrisSubd[i], detailMaxSquared, false);
					if (splitNum == 1)
						this.halfEdgeSplit(iTrisSubd[i], iAr[ind], iAr[ind + 1], iAr[ind + 2]);
					else if (splitNum == 2)
						this.halfEdgeSplit(iTrisSubd[i], iAr[ind + 1], iAr[ind + 2], iAr[ind]);
					else if (splitNum == 3)
						this.halfEdgeSplit(iTrisSubd[i], iAr[ind + 2], iAr[ind], iAr[ind + 1]);
				}
			}
		}

		/** Detect which triangles to split and the edge that need to be split */
		void initSplit(List<int>iTris, List<int>iTrisSubd, List<int>split, float detailMaxSquared)
		{
			int nbTris = iTris.Count;
			for (var i = 0; i < nbTris; ++i)
			{
				var splitNum = this.findSplit(iTris[i], detailMaxSquared, true);
				switch (splitNum)
				{
				case 1:
					split.Add(1);
					break;
				case 2:
					split.Add(2);
					break;
				case 3:
					split.Add(3);
					break;
				default:
					continue;
				}
				iTrisSubd.Add(iTris[i]);
			}
		}

		/** Find the edge to be split (0 otherwise) */
		int findSplit(int iTri, float detailMaxSquared, bool checkInsideSphere)
		{
			Vector3 v1 = Vector3.zero;
			Vector3 v2 = Vector3.zero;
			Vector3 v3 = Vector3.zero;



			Vector3[] vAr = mesh.vertexArray;
			int[] iAr = mesh.indexArray;
			
			int id = iTri * 3;

			v1 = mesh.transform.TransformPoint(vAr[ iAr[id] ]);
			v2 = mesh.transform.TransformPoint(vAr[ iAr[id+1] ]);
       		v3 = mesh.transform.TransformPoint(vAr[ iAr[id+2] ]);


//			Debug.DrawLine(v1, v2, Color.green);
//			Debug.DrawLine(v1, v3, Color.green);

			if (this.checkPlane)
			{
				var po = this.planeOrigin;
				var pn = this.planeNormal;

				if(Vector3.Dot(pn, v1 - po) < 0.0f &&
				   Vector3.Dot(pn, v2 - po) < 0.0f &&
				   Vector3.Dot(pn, v3 - po) < 0.0f){
					return 0;
				}

//				if (vec3.dot(pn, vec3.sub(tmp, v1, po)) < 0.0 &&
//				    vec3.dot(pn, vec3.sub(tmp, v2, po)) < 0.0 &&
//				    vec3.dot(pn, vec3.sub(tmp, v3, po)) < 0.0)
//					return 0;
			}
			else if (checkInsideSphere == true)
			{
				if (!Geometry.triangleInsideSphere(this.center, this.radiusSquared, v1, v2, v3))
				{
					if (!Geometry.pointInsideTriangle(this.center, v1, v2, v3))
					{
						return 0;
					}
				}
			}


			
			float length1 = (v1 - v2).sqrMagnitude;
			float length2 = (v2 - v3).sqrMagnitude;
			float length3 = (v1 - v3).sqrMagnitude;
			if (length1 > length2 && length1 > length3)
				return length1 > detailMaxSquared ? 1 : 0;
			else if (length2 > length3)
				return length2 > detailMaxSquared ? 2 : 0;
			else
				return length3 > detailMaxSquared ? 3 : 0;
			
		}

		/**
 * Subdivide one triangle, it simply cut the triangle in two at a given edge.
 * The position of the vertex is computed as follow :
 * 1. Initial position of the new vertex at the middle of the edge
 * 2. Compute normal of the new vertex (average of the two normals of the two vertices defining the edge)
 * 3. Compute angle between those two normals
 * 4. Move the new vertex along its normal with a strengh proportional to the angle computed at step 3.
 */
		public void halfEdgeSplit(int iTri, int iv1, int iv2, int iv3)
		{
			
			int[] key = new int[2];
			
			
			List<Vertex> vertices = mesh.vertices;
			List<Triangle> triangles = mesh.triangles;
			Vector3[] vAr = mesh.vertexArray;
			Vector3[] nAr = mesh.normalArray;
			Color[] cAr = mesh.colorArray;
			int[] iAr = mesh.indexArray;
			
			var leaf = triangles[iTri].leaf;
			var iTrisLeaf = leaf.iTris;
			Vertex v1 = vertices[iv1];
			Vertex v2 = vertices[iv2];
			Vertex v3 = vertices[iv3];
			
			var vMap = this.verticesMap;
			key[0] = Mathf.Min(iv1, iv2);
			key[1] = Mathf.Max(iv1, iv2);
			bool isNewVertex = false;
			int ivMid = -1;
			if( !vMap.ContainsKey(key[0]) ) 
			{
				ivMid = vertices.Count;
				isNewVertex = true;
				vMap[key[0]] = ivMid;
			}else{
				ivMid = vMap[key[0]];
			}
			
			v3.ringVertices.Add(ivMid);
			var id = iTri * 3;
			iAr[id] = iv1;
			iAr[id + 1] = ivMid;
			iAr[id + 2] = iv3;
			
			int iNewTri = triangles.Count;
			Triangle newTri = new Triangle(iNewTri);
			id = iNewTri * 3;


			iAr[id] = ivMid;
			iAr[id + 1] = iv2;
			iAr[id + 2] = iv3;

			
			v3.tIndices.Add(iNewTri);
			v2.replaceTriangle(iTri, iNewTri);
			newTri.leaf = leaf;

			if (isNewVertex) //new vertex
			{
				int ind = vertices.Count;
				Vertex vMidTest = new Vertex(ind);
				

				Vector3 v1_ = mesh.transform.TransformPoint(vAr[iv1]);
				Vector3 v2_ = mesh.transform.TransformPoint(vAr[iv2]);


				Vector3 n1 = mesh.transform.TransformPoint(nAr[iv1]);
				Vector3 n2 = mesh.transform.TransformPoint(nAr[iv2]);


				Color c1 = cAr[iv1];
				Color c2 = cAr[iv1];

				Vector3 n1n2 = n1+n2;
				float len = 1 / n1n2.magnitude;
				nAr[id] = n1n2 * len;
				
				cAr[id] = (c1 + c2) * 0.5f;

				float offset = 0;
				if (!this.linearSubdivision)
				{
					float dot = Vector3.Dot(n1, n2);
					float angle = 0;
					if (dot <= -1) angle = Mathf.PI;
					else if (dot >= 1) angle = 0;
					else angle = Mathf.Acos(dot);

					Vector3 edge = v1_ - v2_;
					len = edge.magnitude;

					offset = angle * len * 0.12f;
					if ((edge.x * (n1.x - n2.x) + edge.y * (n1.y - n2.y) + edge.z * (n1.z - n2.z)) < 0)
						offset = -offset;
				}
				
				vAr[id] = (v1_ + v2_) * 0.5f + nAr[id] * offset;


				vMidTest.ringVertices.Add(iv1);
				vMidTest.ringVertices.Add(iv2);
				vMidTest.ringVertices.Add(iv3);

				v1.replaceRingVertex(iv2, ivMid);
				v2.replaceRingVertex(iv1, ivMid);
				vMidTest.tIndices.Add(iTri);
				vMidTest.tIndices.Add(iNewTri);
				vertices.Add(vMidTest);
			}
			else
			{
				Vertex vm = vertices[ivMid];
				vm.ringVertices.Add(iv3);
				vm.tIndices.Add(iTri);
				vm.tIndices.Add(iNewTri);
			}
			iTrisLeaf.Add(iNewTri);
			triangles.Add(newTri);
			
		}
	}



}

