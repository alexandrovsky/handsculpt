using UnityEngine;
using System.Collections.Generic;

public class TargetObjectScript: MonoBehaviour {

	public GameObject target = null;

	public Mesh mesh = null;
	public MeshFilter meshFilter;

	public Vector3[] vertices = null;
	public Color[] colors = null;
	public int[] triangles = null;
	public Octree octree;

	Mesh init_mesh = null;
	Vector3[] init_vertices = null;
	Color[] init_colors = null;
	int[] init_triangles = null;
	Dictionary<int,List<int>> init_adjacentTrangles;



	void Start () {
		Debug.Log("TOS started");

		pullMeshData();
		pullInitMeshData();
		octree = new Octree(mesh, transform);
	}
	
	// Update is called once per frame
	void Update () {

	}

	private void pullMeshData(){
		target = GameObject.Find("Target");
		
		meshFilter = target.GetComponent<MeshFilter>();
		mesh = meshFilter.sharedMesh;
		vertices = mesh.vertices;
		colors = mesh.colors;
		triangles = mesh.triangles;
	}

	private void pullInitMeshData(){
		init_mesh = meshFilter.sharedMesh; //meshCollider.sharedMesh;
		init_vertices = mesh.vertices;
		init_colors = mesh.colors;
		init_triangles = mesh.triangles;
	}

	public void ResetMesh(){
		pullMeshData();
		vertices = init_vertices;
		triangles = init_triangles;
		colors = init_colors;
		mesh.vertices = vertices;
		mesh.colors = colors;
		mesh.triangles = triangles;
		meshFilter.sharedMesh = init_mesh;
	}

	public void Subdivide(){
		MeshSubdivide.Subdivide4(mesh);
		mesh.RecalculateBounds();
		meshFilter.sharedMesh = mesh;

		pullMeshData();
	}



}
