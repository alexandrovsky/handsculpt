using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MeshTopologyTriangles {

	public static int debugRecursionCount = 0;

	public static Dictionary<int,List<int>> findAllAdjecentTriangleIndeces(Mesh mesh){
		Dictionary<int,List<int>> adjacentTriangles = new Dictionary<int, List<int>>();

		for(int t_idx = 0; t_idx < mesh.triangles.Length/3; t_idx++){
			adjacentTriangles.Add(t_idx, findAdjacentTriangleIndeces(t_idx, mesh.triangles) );
		}

		return adjacentTriangles;
	}

	public static List<int> findAdjacentTriangleIndeces(int inTriangleIdx, int[] triangles){

		List<int> adjacent = new List<int>();

		int inV0 = triangles[inTriangleIdx * 3 + 0];
		int inV1 = triangles[inTriangleIdx * 3 + 1];
     	int inV2 = triangles[inTriangleIdx * 3 + 2];

		for(int t_idx = 0; t_idx < triangles.Length; t_idx+=3){
			if(t_idx == inTriangleIdx) continue; // --- OUT --->

			if( triangles[t_idx] == inV0 || 
			    triangles[t_idx] == inV1 ||
			    triangles[t_idx] == inV2 ||
			    
			    triangles[t_idx+1] == inV0 || 
			    triangles[t_idx+1] == inV1 ||
			    triangles[t_idx+1] == inV2 ||

			    triangles[t_idx+2] == inV0 || 
			    triangles[t_idx+2] == inV1 ||
			    triangles[t_idx+2] == inV2 )
			{
				adjacent.Add(t_idx/3);
			}
		}
		return adjacent;
	}

	public static HashSet<int> selectTriangles(Dictionary<int,List<int>> adjacentTriangles, int inTriangleIdx, int depth){
		HashSet<int> selectedTriangles = new HashSet<int>();
		selectedTriangles.Add(inTriangleIdx);
		debugRecursionCount++;
		depth--;
		if(depth > 0){
			foreach(int triNeigbour in adjacentTriangles[inTriangleIdx]){
				selectedTriangles.UnionWith( selectTriangles(adjacentTriangles, triNeigbour, depth) );
			}
		}
		return selectedTriangles;
	}

	// with radius
	public static HashSet<int> selectTriangles(Dictionary<int,List<int>> adjacentTriangles, Vector3[] vertices, int[] triangles, int inTriangleIdx,  float radius, HashSet<int> selectedTriangles){
		selectedTriangles.Add(inTriangleIdx);
		debugRecursionCount++;
		if(radius > -0.1f){

			Vector3 p0 = vertices[triangles[inTriangleIdx * 3 + 0]];
			Vector3 p1 = vertices[triangles[inTriangleIdx * 3 + 1]];
			
			Vector3 center = 0.5f * p0 + 0.5f * p1;


			foreach(int triNeigbour in adjacentTriangles[inTriangleIdx]){

				if(selectedTriangles.Contains(triNeigbour) ){
					continue; // --- OUT --->
				}

				Vector3 neighbor_p0 = vertices[triangles[triNeigbour * 3 + 0]];
				Vector3 neighbor_p1 = vertices[triangles[triNeigbour * 3 + 1]];
				
				Vector3 neighbor_center = 0.5f * neighbor_p0 + 0.5f * neighbor_p1;

				float neighbor_radius = radius - Vector3.Distance(center, neighbor_center);

				selectTriangles(adjacentTriangles,vertices, triangles, triNeigbour, neighbor_radius, selectedTriangles);
			}
		}
		return selectedTriangles;
	}





	public static void DrawTriangle(Vector3[] vertices, Transform transform, int[] triangles, int triangleIndex){
		Vector3 p0 = vertices[triangles[triangleIndex * 3 + 0]];
		Vector3 p1 = vertices[triangles[triangleIndex * 3 + 1]];
		Vector3 p2 = vertices[triangles[triangleIndex * 3 + 2]];
		
		p0 = transform.TransformPoint(p0);
		p1 = transform.TransformPoint(p1);
		p2 = transform.TransformPoint(p2);
		Debug.DrawLine(p0, p1, Color.red, 5.0f);
		Debug.DrawLine(p1, p2, Color.red, 5.0f);
		Debug.DrawLine(p2, p0, Color.red, 5.0f);
	}

	public static void DrawTriangle(Vector3[] vertices, int[] triangles, int triangleIndex, Color[] colors, Color color ){
	
		int v0_idx = triangles[triangleIndex * 3 + 0];
		int v1_idx = triangles[triangleIndex * 3 + 1];
		int v2_idx = triangles[triangleIndex * 3 + 2];

		colors[v0_idx] = color;
		colors[v1_idx] = color;
		colors[v2_idx] = color;

//		Vector3 p0 = vertices[v0_idx];
//		Vector3 p1 = vertices[v1_idx];
//		Vector3 p2 = vertices[v2_idx];
//		
//		p0 = transform.TransformPoint(p0);
//		p1 = transform.TransformPoint(p1);
//		p2 = transform.TransformPoint(p2);
//		Debug.DrawLine(p0, p1, Color.red, 5.0f);
//		Debug.DrawLine(p1, p2, Color.red, 5.0f);
//		Debug.DrawLine(p2, p0, Color.red, 5.0f);
	
	}

}
