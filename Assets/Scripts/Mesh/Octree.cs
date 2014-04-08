

using UnityEngine;
using System.Collections.Generic;



public class Node {

	public int id;
	public bool isLeaf;
	public bool isEmpty;
	public List<int>vertices;
	public Node[] children;
	public Node parent;
	public Bounds bounds;
	public int depth;



	public Node(){

		vertices = new List<int>();
		children = new Node[8];
		isLeaf = true;
		isEmpty = true;
		bounds = new Bounds();
	}

	public Node(List<int>vertices, Bounds bounds, bool isLeaf){
		this.vertices = vertices;
		this.bounds = bounds;
		this.isLeaf = isLeaf;
		this.children = new Node[8];
		this.isEmpty = true;
	}
}

public class Octree {

	public Node root;
	public int depth;
	public Bounds bounds;
	public Dictionary<int,Node> taggedVertices;
	public List<Node> nodes;


	public Octree(Mesh mesh, Transform transf){

		nodes = new List<Node>();

		root = new Node();
		root.bounds = transf.renderer.bounds;
		root.parent = root;

		Vector3[] vertices = mesh.vertices;

		taggedVertices = new Dictionary<int, Node>();


		for(int i = 0; i < vertices.Length; i++){
			root.vertices.Add(i);
			taggedVertices[i] = null;
		}

		CreateTree(root,transf,vertices, 3);
		depth = 0;
	}

	public bool RemoveVertex(Node leaf, Vector3 positon, int v_idx){

		if(leaf.parent == leaf){
			return false;
		}

		if(!leaf.bounds.Contains(positon) ){
			leaf.vertices.Remove(v_idx);
			taggedVertices[v_idx] = null;
			RemoveVertex(leaf.parent, positon, v_idx);
			return true;
		}
		return false;
	}

	public void InsertVertex(Node root, Vector3 positon, int v_idx){
		if( root.bounds.Contains(positon) ){
			root.vertices.Add(v_idx);
			taggedVertices[v_idx] = root;
			foreach(Node child in root.children){
				InsertVertex(child, positon, v_idx);
			}
		}
	}



	public void CreateTree(Node root, Transform transform, Vector3[] vertices, int depth){
		Bounds bounds = root.bounds;
		root.bounds = bounds;

		--depth;

		if(depth < 0){
			return; // --- OUT--->
		}


		for(int i = 0; i < 8; i++){

			Vector3 extends = root.bounds.extents/2;

			switch(i){
			case 2:
			case 3:
				extends.x = -extends.x;
				break;
			case 4:
			case 5:
				extends.y = -extends.y;
				break;
			case 6:
			case 7:
				extends.x = -extends.x;
				extends.y = -extends.y;
				break;
			default: break;
			}

			if(i%2 != 0){
				extends = extends * -1;
			}

			Vector3 childCenter = root.bounds.center + extends;
			Vector3 childSize = root.bounds.size/2;
			Bounds childBounds = new Bounds(childCenter, childSize);
			Node child = new Node(new List<int>(), childBounds, true);
			child.isEmpty = true;

			foreach(int v_idx in root.vertices){


				Vector3 vertex = transform.TransformPoint(vertices[v_idx]);

				if( child.bounds.Contains(vertex) ){
					child.vertices.Add(v_idx);
					child.isEmpty = false;

					nodes.Add(child);
					child.id = depth * 8 + i;
					taggedVertices[v_idx] = child;

					root.children[i] = child;
					child.parent = root;
					root.isLeaf = false;
				}
			}

			if(!child.isEmpty){
				CreateTree(child,transform, vertices,  depth);
			}
			
		}
	}

	public static void DrawTree(Node root){
		foreach(Node child in root.children){
			if(child == null) {
				continue; // out -->
			}
			DrawTree(child);
			Debug.DrawLine(root.bounds.center, child.bounds.center, Color.blue);

		}
//		Gizmos.DrawWireSphere(root.bounds.center,root.bounds.size.magnitude);
		Gizmos.DrawWireCube(root.bounds.center, root.bounds.size);
	}

	public static void DrawTree(Node root, Transform transf, Vector3[] vertices){


//			foreach(int v_idx in root.vertices){
//				Vector3 vertex = transf.TransformPoint(vertices[v_idx]);
//				Debug.DrawLine(root.bounds.center, vertex, Color.red);
//			}

		
		if(root.isLeaf){
//			foreach(int v_idx in root.vertices){
//				Vector3 vertex = transf.TransformPoint(vertices[v_idx]);
//				Debug.DrawLine(root.bounds.center, vertex, Color.red);
//			}
		}else{
			foreach(Node child in root.children){
				if(child == null) {
					continue; // out -->
				}
				//DrawTree(child);
				DrawTree(child, transf, vertices);
				Debug.DrawLine(root.bounds.center, child.bounds.center, Color.blue);
			}
		}


		Gizmos.DrawWireCube(root.bounds.center, root.bounds.size);
	}
}
