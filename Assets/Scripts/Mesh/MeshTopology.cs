using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/*
	Useful mesh functions
	// http://wiki.unity3d.com/index.php/MeshSmoother#TestSmoothFilter.cs
*/
public class MeshTopology

{
//	public static Dictionary<int,List<int>> RecalculateTopology(Vector3[] vertices, int[] triangles){
//		Dictionary<int,List<int>> adjacentVertices = new Dictionary<int,List<int>>();
//		for(int idx = 0; idx < vertices.Length; idx++){
//			Vector3 vertex = vertices[idx];
//			adjacentVertices.Add(idx, MeshTopology.findAdjacentNeighborIndexes(vertices, triangles, vertex) );
//		}
//		return adjacentVertices;
//	}

	public static Dictionary<int, int> RecalculateMirrorVertices(Mesh mesh, Transform transform){
		Dictionary<int, int> mirrorVertices = new Dictionary<int, int>();
//		Vector3[] v = mesh.vertices;
//		Vector3[] n = mesh.normals;
//		for(int v_idx = 0; v_idx <  5; v_idx++){
//			Vector3 vertex = transform.TransformPoint(v[v_idx]);
//			Vector3 normal = transform.position;
//			Ray ray = new Ray(vertex, normal);
//			Debug.DrawLine(ray.origin, ray.direction, Color.red, 350);
////			RaycastHit hit;
////			Physics.Raycast(ray, out hit)
//		}
		return mirrorVertices;
	}


	// Finds a set of adjacent vertices for a given vertex
	// Note the success of this routine expects only the set of neighboring faces to eacn contain one vertex corresponding
	// to the vertex in question
	public static List<Vector3> findAdjacentNeighbors ( Vector3[] v, int[] t, Vector3 vertex )
	{
		List<Vector3>adjacentV = new List<Vector3>();
		List<int>facemarker = new List<int>();
		int facecount = 0;	
		
		// Find matching vertices
		for (int i=0; i<v.Length; i++)
			if (Mathf.Approximately (vertex.x, v[i].x) && 
			    Mathf.Approximately (vertex.y, v[i].y) && 
			    Mathf.Approximately (vertex.z, v[i].z))
		{
			int v1 = 0;
			int v2 = 0;
			bool marker = false;
			
			// Find vertex indices from the triangle array
			for(int k=0; k<t.Length; k=k+3)
				if(facemarker.Contains(k) == false)
			{
				v1 = 0;
				v2 = 0;
				marker = false;
				
				if(i == t[k])
				{
					v1 = t[k+1];
					v2 = t[k+2];
					marker = true;
				}
				
				if(i == t[k+1])
				{
					v1 = t[k];
					v2 = t[k+2];
					marker = true;
				}
				
				if(i == t[k+2])
				{
					v1 = t[k];
					v2 = t[k+1];
					marker = true;
				}
				
				facecount++;
				if(marker)
				{
					// Once face has been used mark it so it does not get used again
					facemarker.Add(k);
					
					// Add non duplicate vertices to the list
					if ( isVertexExist(adjacentV, v[v1]) == false )
					{	
						adjacentV.Add(v[v1]);
						//Debug.Log("Adjacent vertex index = " + v1);
					}
					
					if ( isVertexExist(adjacentV, v[v2]) == false )
					{
						adjacentV.Add(v[v2]);
						//Debug.Log("Adjacent vertex index = " + v2);
					}
					marker = false;
				}
			}
		}
		
		//Debug.Log("Faces Found = " + facecount);
		
		return adjacentV;
	}
	
	public static Dictionary<int,List<int>> findAllAdjecentVertexIndeces(Mesh mesh){

		Vector3[] vertices = mesh.vertices;
		int[] triangles = mesh.triangles;
		Dictionary<int,List<int>> adjacentVertices = new Dictionary<int,List<int>>();

		for(int v_idx = 0; v_idx < vertices.Length; v_idx++){
//			Vector3 vertex = vertices[idx];
//			adjacentVertices.Add(idx, MeshTopology.findAdjacentNeighborIndexes(vertices, triangles, vertex) );
			adjacentVertices.Add (v_idx, findAdjacentNeighborIndexes(v_idx, triangles) );

		}
		return adjacentVertices;
	}


	public static List<int> findAdjacentNeighborIndexes ( int v, int[] t){
		List<int> adjacent = new List<int>();
		for(int i = 0; i < t.Length; i+=3){
			if(t[i] == v){
				adjacent.Add(t[i+1]);
				adjacent.Add(t[i+2]);
			}else if(t[i+1] == v){
				adjacent.Add(t[i]);
				adjacent.Add(t[i+2]);
			}
			else if(t[i+2] == v){
				adjacent.Add(t[i]);
				adjacent.Add(t[i+1]);
			}
		}
		return adjacent;
	}


	// Finds a set of adjacent vertices indexes for a given vertex
	// Note the success of this routine expects only the set of neighboring faces to eacn contain one vertex corresponding
	// to the vertex in question
	public static List<int> findAdjacentNeighborIndexes ( Vector3[] v, int[] t, Vector3 vertex )
	{
		List<int>adjacentIndexes = new List<int>();
		List<Vector3>adjacentV = new List<Vector3>();
		List<int>facemarker = new List<int>();
		int facecount = 0;	
		
		// Find matching vertices
		for (int i=0; i<v.Length; i++)
			if (Mathf.Approximately (vertex.x, v[i].x) && 
			    Mathf.Approximately (vertex.y, v[i].y) && 
			    Mathf.Approximately (vertex.z, v[i].z))
		{
			int v1 = 0;
			int v2 = 0;
			bool marker = false;
			
			// Find vertex indices from the triangle array
			for(int k=0; k<t.Length; k=k+3)
				if(facemarker.Contains(k) == false)
			{
				v1 = 0;
				v2 = 0;
				marker = false;
				
				if(i == t[k])
				{
					v1 = t[k+1];
					v2 = t[k+2];
					marker = true;
				}
				
				if(i == t[k+1])
				{
					v1 = t[k];
					v2 = t[k+2];
					marker = true;
				}
				
				if(i == t[k+2])
				{
					v1 = t[k];
					v2 = t[k+1];
					marker = true;
				}
				
				facecount++;
				if(marker)
				{
					// Once face has been used mark it so it does not get used again
					facemarker.Add(k);
					
					// Add non duplicate vertices to the list
					if ( isVertexExist(adjacentV, v[v1]) == false )
					{	
						adjacentV.Add(v[v1]);
						adjacentIndexes.Add(v1);
						//Debug.Log("Adjacent vertex index = " + v1);
					}
					
					if ( isVertexExist(adjacentV, v[v2]) == false )
					{
						adjacentV.Add(v[v2]);
						adjacentIndexes.Add(v2);
						//Debug.Log("Adjacent vertex index = " + v2);
					}
					marker = false;
				}
			}
		}
		
		//Debug.Log("Faces Found = " + facecount);
		
		return adjacentIndexes;
	}
	
	// Does the vertex v exist in the list of vertices
	static bool isVertexExist(List<Vector3>adjacentV, Vector3 v)
	{
		bool marker = false;
		foreach (Vector3 vec in adjacentV)
			if (Mathf.Approximately(vec.x,v.x) && Mathf.Approximately(vec.y,v.y) && Mathf.Approximately(vec.z,v.z))
		{
			marker = true;
			break;
		}
		
		return marker;
	}




	public static void DrawTriangle(Vector3[] vertices, Transform transform, int[] triangles, int triangleIndex, Color color){
		Vector3 p0 = vertices[triangles[triangleIndex * 3 + 0]];
		Vector3 p1 = vertices[triangles[triangleIndex * 3 + 1]];
		Vector3 p2 = vertices[triangles[triangleIndex * 3 + 2]];
		
		p0 = transform.TransformPoint(p0);
		p1 = transform.TransformPoint(p1);
		p2 = transform.TransformPoint(p2);
		Debug.DrawLine(p0, p1, color);
		Debug.DrawLine(p1, p2, color);
		Debug.DrawLine(p2, p0, color);
	}
}