using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

[RequireComponent (typeof (MeshCollider))]
[RequireComponent (typeof (MeshFilter))]
[RequireComponent (typeof (MeshRenderer))]

public class Icosphere : MonoBehaviour {
	
	//The radius of the sphere is handled by the mesh scale
	public int refinements = 0;
	int index;
	
	private Dictionary<Int64, int> middlePointIndexCache;
	private List<Vector3> verticesList;    //temporary holder for all vertices lists
	private List<Vector2> uvList;    //temporary holder for all UVs lists
	private Vector3[] finalVertices; //holder for the final array of vertices
	private int[] finalTriangles; //holder for the final array of triangle indexes
	
	Mesh mesh;
	//mesh.vertices is a Vector3[]
	//mesh.triangles is an int[]
	
	public void log(string s){
		Debug.Log (s);
	}
	
	//struct to hold each face's set of vertices.
	private struct TriangleIndices{
		public int v1;
		public int v2;
		public int v3;
		
		public TriangleIndices(int v1, int v2, int v3){
			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;
		}
	}

	
	public void Rebuild(){
		MeshFilter meshFilter = GetComponent<MeshFilter>();
		if (meshFilter==null){
			//Debug.LogError("MeshFilter not found!");
			Debug.Log("MeshFilter not found!");
			return;
		}
		
		//clear everything
		
		this.index = 0;
		this.middlePointIndexCache=new Dictionary<Int64, int>();
		this.verticesList = new List<Vector3>();
		this.uvList = new List<Vector2>();
		
		//Generate a vector list
		//The golden ratio:
		float t = (float)((1.0f + Mathf.Sqrt(5.0f)) / 2.0f);
		
		//add each base vector to the temporary vertices list.  relates to mesh.vertices
		this.verticesList.Add(new Vector3(-1, t, 0));
		this.verticesList.Add(new Vector3(1, t, 0));
		this.verticesList.Add(new Vector3(-1, -t, 0));
		this.verticesList.Add(new Vector3(1, -t, 0));
		
		this.verticesList.Add(new Vector3(0, -1, t));
		this.verticesList.Add(new Vector3(0, 1, t));
		this.verticesList.Add(new Vector3(0, -1, -t));
		this.verticesList.Add(new Vector3(0, 1, -t));
		
		this.verticesList.Add(new Vector3(t, 0, -1));
		this.verticesList.Add(new Vector3(t, 0, 1));
		this.verticesList.Add(new Vector3(-t, 0, -1));
		this.verticesList.Add(new Vector3(-t, 0, 1));
		
		for (var i = 0; i < verticesList.Count; i++){
			verticesList[i] = verticesList[i].normalized;
		}

		
		//update the index values so that new vertices made during refinement
		//will correspond to the appropriate index point in teh vertex list.
		index+=12;
		
		mesh = meshFilter.sharedMesh;
		if (mesh == null){
			meshFilter.mesh = new Mesh();
			mesh = meshFilter.sharedMesh;
		}
		mesh.Clear();
		mesh.RecalculateNormals();
		
		//A list to temporarily hold face traingles. - relates to mesh.Triangles
		List<TriangleIndices> faces = new List<TriangleIndices>();
		
		// 5 faces around point 0
		faces.Add(new TriangleIndices(0, 11, 5));
		faces.Add(new TriangleIndices(0, 5, 1));
		faces.Add(new TriangleIndices(0, 1, 7));
		faces.Add(new TriangleIndices(0, 7, 10));
		faces.Add(new TriangleIndices(0, 10, 11));
		
		// 5 adjacent faces
		faces.Add(new TriangleIndices(1, 5, 9));
		faces.Add(new TriangleIndices(5, 11, 4));
		faces.Add(new TriangleIndices(11, 10, 2));
		faces.Add(new TriangleIndices(10, 7, 6));
		faces.Add(new TriangleIndices(7, 1, 8));
		
		// 5 faces around point 3
		faces.Add(new TriangleIndices(3, 9, 4));
		faces.Add(new TriangleIndices(3, 4, 2));
		faces.Add(new TriangleIndices(3, 2, 6));
		faces.Add(new TriangleIndices(3, 6, 8));
		faces.Add(new TriangleIndices(3, 8, 9));
		
		// 5 adjacent faces
		faces.Add(new TriangleIndices(4, 9, 5));
		faces.Add(new TriangleIndices(2, 4, 11));
		faces.Add(new TriangleIndices(6, 2, 10));
		faces.Add(new TriangleIndices(8, 6, 7));
		faces.Add(new TriangleIndices(9, 8, 1));
		
		//refine the triangles
		for(int i = 0; i<refinements; i++){
			int j=0;
			
			List<TriangleIndices> faces2 = new List<TriangleIndices>();
			foreach(var tri in faces){
				//replace the triangle with four traingles
				//log ("Triange: v1: " + tri.v1 + ", v2: " + tri.v2 + ", v3: " + tri.v3);
				//log ("tri: " + tri.v1 + "," + tri.v2 + "," + tri.v3);
				int a = getMiddlePoint(tri.v1, tri.v2);
				int b = getMiddlePoint(tri.v2, tri.v3);
				int c = getMiddlePoint(tri.v3, tri.v1);
				
				//log ("New Face "+j+": " + a + "," + b + "," + c);
				
				faces2.Add(new TriangleIndices(tri.v1, a, c));
				faces2.Add(new TriangleIndices(tri.v2, b, a));
				faces2.Add(new TriangleIndices(tri.v3, c, b));
				faces2.Add(new TriangleIndices(a,b,c));
				j++;
			}
			
			faces = faces2;
		}//end for(int i)
		
		//now add all the triangles to the mesh
		int numFaces = faces.Count;
		int numVertices = verticesList.Count;
		int ind = 0;
		
		//log("number of faces on the icosphere:" + numFaces);
		//log("Number of Vertices in Icosphere:" + numVertices);
		
		finalTriangles = new int[numFaces*3];
		finalVertices = new Vector3[numVertices];
		
		//convert the list<> to an array[]
		verticesList.CopyTo(finalVertices);
		mesh.vertices = finalVertices;
		
		foreach(var vert in verticesList){
			log ("Vertex " + ind + ": "+ mesh.vertices[ind].x + "," +mesh.vertices[ind].y + "," +mesh.vertices[ind].z);
			ind++;
		}
		
		//add each triangle vertex set to mesh.triangles.
		ind=0;
		foreach(var tri in faces){
			//log ("mesh vertices: " + index);
			finalTriangles[ind]=tri.v1;
			finalTriangles[ind+1]=tri.v2;
			finalTriangles[ind+2]=tri.v3;
			ind+=3;
		}
		mesh.triangles = finalTriangles;
		
		mesh.RecalculateNormals();
		ind=0;
		foreach(var vert in mesh.vertices){
			log ("Vertex " + index + ": "+ mesh.vertices[ind].x + "," +mesh.vertices[ind].y + "," +mesh.vertices[ind].z);
			ind++;
		}
		
		mesh.RecalculateBounds();
		mesh.Optimize();
	}
	
	
	
	private int getMiddlePoint(int p1, int p2){
		//check to make sure we don't already have the point
		bool firstisSmaller = p1 < p2;
		
		//log ("first is smaller: " + firstisSmaller + "  | "+ p1 + ", " + p2);
		
		Int64 smallerIndex = firstisSmaller ? p1 : p2;
		Int64 greaterIndex = firstisSmaller ? p2 : p1;
		Int64 key = (smallerIndex << 32) + greaterIndex;
		
		int ret;
		if(this.middlePointIndexCache.TryGetValue(key, out ret)){
			//log ("ret: " + ret);
			return ret;
		}
		
		//if it is not in the cache, calculate it
		Vector3 point1 = verticesList[p1];
		Vector3 point2 = verticesList[p2];
		Vector3 middle = new Vector3( (point1.x + point2.x)/2.0f,
		                              (point1.y + point2.y)/2.0f,
		                              (point1.z + point2.z)/2.0f);
		
		//addVertex makes sure that the point is on unit sphere
		int i = addVertex(middle);
		//log ("i: " + i);
		
		//store item and return index
		this.middlePointIndexCache.Add(key,i);
		return i;
	}
	
	private int addVertex(Vector3 p){
		
		double length = Mathf.Sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
		verticesList.Add(new Vector3((float)(p.x/length), (float)(p.y/length), (float)(p.z/length)));
		return index++;
	}
	
	void Start(){
		Rebuild();
	}
	
	// Update is called once per frame
	void Update () {
		//put code that handles LOD here
	}
}