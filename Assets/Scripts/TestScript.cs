using UnityEngine;
using System.Collections.Generic;
using System.Linq;
public class TestScript : MonoBehaviour {


	GameObject target = null;
	TargetObjectScript tos = null;
	Vector3[] vertices = null;


	Octree octree = null;

	void Start () {
		Debug.Log("TestScript started, yeah");
		target = GameObject.Find("Target");
		MeshFilter mf = target.GetComponent<MeshFilter>();
		vertices = mf.sharedMesh.vertices;
		tos = target.GetComponent<TargetObjectScript>();
		octree = tos.octree;
	}



//	void OnDrawGizmos()
//	{
//		Gizmos.color = Color.yellow;
//		//Gizmos.DrawWireCube(target.transform.position, target.transform.renderer.bounds.size);
//		if(octree != null){
////			Octree.DrawTree(octree.root, target.transform, vertices);
//			Octree.DrawTree(octree.root);
//		}
//	}



	public static long ConvertPoint(Transform transform, Vector3 point)
	{

		Vector3 Offset = new Vector3(100, 100, 100); //offsetting for positive values only


		long shiftX = 1000000;
		long shiftY = 10000;
		long shiftZ = 100;

		Vector3 transformedPoint = transform.TransformPoint(point + Offset); // convert into worldspace
		long result = (long)(shiftX * (transformedPoint.x + 0.005f) )+ 
					  (long)(shiftY * (transformedPoint.y + 0.005f) )+ 
					  (long)(shiftZ * (transformedPoint.z + 0.005f) );
		return result;
	}




	void OnGUI(){

		GUI.TextField(new Rect(300, 100, 200, 20), "octree node count " + octree.nodes.Count);
	}



	void Update(){

	}


//	void Update () {
//	//Vector3[] normals = mesh.normals;
//
//
//
//		RaycastHit hit;
//		Ray ray;
//		if(Input.GetMouseButtonDown(0))
//		{
//
//			Debug.Log("mouse clicked");
//
//
//			ray = Camera.main.ScreenPointToRay(Input.mousePosition);
//			MeshCollider meshCollider = target.collider as MeshCollider;
//			if(Physics.Raycast(ray, out hit) ){
//
//				//Debug.DrawLine(ray.origin, hit.point, Color.green, 5.0f);
//
//
//
//				mesh = meshCollider.sharedMesh;
//				
//				vertices = mesh.vertices;
//				triangles = mesh.triangles;
//
//
//
//
//				Transform hitTransform = hit.collider.transform;
//
//				MeshTopologyTriangles.DrawTriangle(vertices, hitTransform, triangles, hit.triangleIndex);
//
//				HashSet<int> selectedTriangles = null;
//				//selectedTriangles = MeshTopologyTriangles.selectTriangles(adjacentTriangles, hit.triangleIndex, 3);
//				selectedTriangles = MeshTopologyTriangles.selectTriangles(adjacentTriangles, vertices, triangles, hit.triangleIndex, 0.001f, selectedTriangles);
//
//
//
//				foreach(int t_idx in selectedTriangles){
//					MeshTopologyTriangles.DrawTriangle(vertices, hitTransform, triangles, t_idx);
//				}
//			}
//			
//		}
//	}




	



}
