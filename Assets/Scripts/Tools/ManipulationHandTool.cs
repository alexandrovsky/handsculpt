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
using Leap;



public abstract class ManipulationHandTool : HandTool
{

	protected TargetObjectScript tos;

	protected Mesh mesh = null;
	protected MeshFilter meshFilter;
	protected MeshCollider meshCollider = null;
	protected Vector3[] vertices = null;
	public Color[] colors = null;
	protected int[] triangles = null;
	protected Dictionary<int,List<int>> adjacentTriangles;

	protected RaycastHit handhit;
	protected Dictionary<int, float> selectedVertices;


	public int vertexWithMaxDistance = 0;
	public float maxDistanceFromHit = 0.0f;

	public RaycastHit hit;
	public Ray ray;



	public List<Node> selectedNodes = new List<Node>();
	public Octree octree = null;
	public float minDistance;

	public Bounds toolBounds;

	public override void Start()
	{	
		Debug.Log("Manipulation tool started");
		base.Start();

		PullMeshData();
		selectedVertices = new Dictionary<int, float>();
		octree = tos.octree;
	}


//	void OnDrawGizmos()
//	{
//		Gizmos.color = Color.yellow;
//		//Gizmos.DrawWireCube(target.transform.position, target.transform.renderer.bounds.size);
////		if(octree != null){
////			//			Octree.DrawTree(octree.root, target.transform, vertices);
////			Octree.DrawTree(octree.root);
////
////		}
//		Gizmos.color = Color.red;
//		if(toolBounds != null){
//			Gizmos.DrawWireCube(toolBounds.center, toolBounds.size);
//		}
//
////		Gizmos.DrawWireSphere(palm.transform.position, radius);
//
////
////		if(toolBounds != null && octree != null){
////
//		foreach(Node node in selectedNodes){
//			if(node.isLeaf) Gizmos.color = Color.blue;
//			else Gizmos.color = Color.yellow;
////				if(node.bounds.Intersects(toolBounds) ){
////				if(node.bounds.IntersectRay(ray) ){
////					if(node.isLeaf){
////						Gizmos.color = Color.blue;
////					}
//			Gizmos.DrawWireCube(node.bounds.center, node.bounds.size);
//		}
//
//	}


	public void PullMeshData()
	{
		target = GameObject.Find("Target");

		tos = target.GetComponent<TargetObjectScript>();

		meshCollider = target.collider as MeshCollider; // tos.meshCollider; // 



		meshFilter =  target.GetComponent<MeshFilter>(); // tos.meshFilter;//
		mesh =  meshFilter.sharedMesh; // tos.mesh;

		vertices = mesh.vertices; // tos.vertices;// 
		colors = mesh.colors; // tos.colors; // 
		triangles = mesh.triangles; // tos.triangles; // 

	}

	public void PushMeshData(){
		
		mesh.vertices = vertices;
		mesh.colors = colors;
		mesh.triangles = triangles;


		meshFilter.sharedMesh = mesh;
	}

	#region SELECTION
	public void ClearSelection(){

		//Debug.Log("clear selection!!!");
//		for(int idx = 0; idx < colors.Length; idx++){
//			colors[idx] = Color.cyan; // CleanColor();
//		}
		debugRecursionCount = 0;
		foreach(int v_idx in selectedVertices.Keys){
			colors[v_idx] = CleanColor();
		}
		selectedVertices.Clear();
		selectedNodes.Clear();
		PushMeshData();
	}


//	public void SelectVertices(List<Ray> rays, Node root){
//		PullMeshData();
//		ClearSelection();
//		foreach(Ray ray in rays){
//			selectVertices(ray, root);
//		}
//		PushMeshData();
//	}




	public void SelectVertices(Ray ray, Node root){
	
		PullMeshData();
		this.ray = ray;
		// clear last selection:
		ClearSelection();

		calculateToolBounds(ray, root);

		SelectVerticesRecursive(octree.root, toolBounds);
//		selectVertices(ray, root);

		PushMeshData();
	}



	private void calculateToolBounds(Ray ray, Node root){
		if(root.bounds.IntersectRay(ray) ){
			selectedNodes.Add(root);
			if(root.isLeaf){
//				toolBounds.center = root.bounds.center;
				toolBounds.center = MathHelper.ProjectPointOnLine(ray.origin, ray.direction, root.bounds.center);
			}else{
				foreach(Node node in root.children){
					if(node != null){
						calculateToolBounds(ray, node);
					}
				}
			}
		}
	}

//	private void selectVertices(Ray ray, Node root){
//		if( root.bounds.IntersectRay(ray) ){
//			selectedNodes.Add(root);
//			if(root.isLeaf){
//				foreach(int v_idx in root.vertices){
//
////					if(selectedVertices.ContainsKey(v_idx) ){
////						continue;
////					}
//
//					Vector3 vertex = target.transform.TransformPoint(vertices[v_idx]);
//					
//					float vDist = MathHelper.DistanceToLine(ray, vertex);
//
//
//					if(vDist < radius){
//						selectedVertices.Add(v_idx, vDist);
//						colors[v_idx] = SelectionColor();
//					}
//					if(vDist < minDistance){
//						minDistance = vDist;
//					}
//				}
//			}else{
//				foreach(Node child in root.children){
//					if(child != null){
//						selectVertices(ray, child);
//					}
//				}
//			}
//		}
//
//	}


	public int debugRecursionCount = 0;
	private void SelectVerticesRecursive(Node root, Bounds toolBounds){
		debugRecursionCount++;


//		bool contains = root.bounds.Intersects(toolBounds);
		float distance = Vector3.Distance(root.bounds.center, toolBounds.center);


		if(root.bounds.Intersects(toolBounds) )
		{
			if(!root.isLeaf){
				for(int nodeIdx = 0; nodeIdx < root.children.Length; nodeIdx++){
					Node child = root.children[nodeIdx];
					if(child != null){
						SelectVerticesRecursive(child, toolBounds);
					}
				}
			}else{
				foreach(int v_idx in root.vertices){
					Vector3 vertex = target.transform.TransformPoint(vertices[v_idx]);

//					float vDist = MathHelper.DistanceToLine(ray, vertex);
					float vDist = Vector3.Distance(toolBounds.center, vertex);
					if(vDist < toolBounds.extents.magnitude){
						if(!selectedVertices.ContainsKey(v_idx) ){
							selectedVertices.Add(v_idx, vDist);
							colors[v_idx] = SelectionColor();
						}
					}
				}
				if(distance < minDistance){
					minDistance = distance;
				}
			}
		}
	}
#endregion

#region MANIPULATION

	public abstract void ManipulateVertices(Bounds toolBounds, Transform transform);
#endregion

	public Ray CalculateRay(Leap.Vector pos){
		Leap.InteractionBox iBox = LeapInput.Frame.InteractionBox;
		Leap.Vector normalizedPosition = iBox.NormalizePoint(pos);
		Vector3 screenPos = new Vector3(UnityEngine.Screen.width * normalizedPosition.x,
		                                UnityEngine.Screen.height * normalizedPosition.y,
		                                0.0f);
		ray = Camera.main.ScreenPointToRay (screenPos);
		return ray;
	}

	public static Color CleanColor(){
		return Color.white;
	}

	public static Color SelectionColor(){
		return Color.yellow;
	}

	public static Color ManipulationColor(){
		return Color.red;
	}



}

