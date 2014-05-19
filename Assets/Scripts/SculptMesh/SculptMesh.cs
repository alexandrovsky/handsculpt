using UnityEngine;
using System.Collections.Generic;

namespace Sculpt{
// add this script to the target object

		public class SculptMesh : MonoBehaviour {

		public List<Triangle> triangles;
		public List<Vertex> vertices;

		public Vector3[] vertexArray;
		public Vector3[] normalArray;
		public Color[] colorArray;
		public int[] indexArray; // triangle ideces

		public Octree octree;

		MeshFilter meshFilter;
		public Mesh mesh;

		public Vector3[] vertexArrayReset;
		public Vector3[] normalArrayReset;
		public Color[] colorArrayReset;
		public int[] indexArrayReset;

		List<int> iTrisCandidates; // candidates for picking;
		List<int> iTrisInCells;
		List<Octree> leavesUpdate; // leafes for mesh update


		int pickedTriangle = -1;
		public Vector3 intersectionPoint = Vector3.zero;

		List<int> pickedVertices;

		public float worldRadiusSqr = 0.0f;

		public int debugTrisInOctreeCount;
		public bool drawDebug = false;
		void OnDrawGizmos()
		{
			if(!drawDebug)return;

//			debugTrisInOctreeCount = 0;
//			drawOctreeTriangles(this.octree);
//			Debug.Log("tris in octree "+ debugTrisInOctreeCount);

//			drawVertices();
//			drawPickedVerices();
//			drawSelectedAabbs();

//			drawLeavesUpdate();
//			drawITrisInCells();
			//drawITrisCandidates();
//			drawOctree(this.octree);
//			drawTriangleAabbs();
		}


		void drawOctreeTriangles(Octree root){
			if(root == null) return;

			Gizmos.color = Color.green;
//			Gizmos.DrawWireCube(root.aabbSplit.center, root.aabbSplit.size);
//			Gizmos.color = Color.cyan;
//			Gizmos.DrawWireCube(root.aabbLoose.center, root.aabbLoose.size);
			debugTrisInOctreeCount += root.children.Count;
			if(root.children.Count == 8){
				foreach(Octree child in root.children){
					drawOctreeTriangles(child);
					//				Debug.DrawLine(root.aabbSplit.center, child.aabbSplit.center, Color.blue);
				}
			}else if(root.iTris.Count != 0){

				Gizmos.color = Color.yellow;
				Gizmos.DrawWireCube(root.aabbSplit.center, root.aabbSplit.size);


				Gizmos.color = Color.green;
				foreach(int iTri in root.iTris){
					Triangle t = triangles[iTri];
					Gizmos.DrawWireCube(t.aabb.center, t.aabb.size);
//					Debug.DrawLine(root.aabbSplit.center, t.aabb.center, Color.red);
				}
			}

		}


		void drawVertices(){
			if(vertices == null && vertices.Count == 0) return;

			foreach(Vertex v in vertices){
				if(v == null) return;
				Vector3 vertex = transform.TransformPoint(vertexArray[v.id]);
//				Debug.DrawLine(transform.position, vertex, Color.green);

				foreach(int v_idx in v.ringVertices){
					Vector3 ringVert = transform.TransformPoint(vertexArray[v_idx]);
					Debug.DrawLine(ringVert, vertex, Color.green);
				}
//				for(int i = 0; i < v.tIndices.Count; i++){
//					Triangle t = triangles[v.tIndices[i]];
//					Debug.DrawLine(vertex, t.leaf.aabbSplit.center, Color.green);
//				}

			}
		}

		void drawPickedVerices(){
			foreach(int v_idx in pickedVertices){
				Vector3 v = transform.TransformPoint( vertexArray[v_idx] );
				Debug.DrawLine(this.intersectionPoint, v, Color.blue);
			}
		}

		void drawITrisInCells(){
			Gizmos.color = Color.cyan;
			if(iTrisInCells == null) return;
			foreach(int iTris in iTrisInCells){
				Triangle t = triangles[iTris];
				Gizmos.DrawWireCube(t.aabb.center, t.aabb.size);
			}
			
			//			if(pickedTriangle != -1){
			//				Triangle t = triangles[pickedTriangle];
			//				Gizmos.DrawWireCube(t.aabb.center, t.aabb.size);
			//			}
			
		}

		void drawITrisCandidates(){
//			Gizmos.color = Color.cyan;
//			foreach(int iTris in iTrisCandidates){
//				Triangle t = triangles[iTris];
//				Gizmos.DrawWireCube(t.aabb.center, t.aabb.size);
//			}

			if(pickedTriangle != -1){
				Gizmos.color = Color.red;
				Triangle t = triangles[pickedTriangle];
				Gizmos.DrawWireCube(t.aabb.center, t.aabb.size);
			}

		}

		void drawLeavesUpdate(){
			if(leavesUpdate == null) return;
			foreach(Octree node in leavesUpdate){
				Gizmos.color = Color.red;
				Gizmos.DrawWireCube(node.aabbSplit.center, node.aabbSplit.size);
			}
		}

		void drawSelectedAabbs(){
			foreach(Octree node in Octree.selectedNodes){
				Gizmos.color = Color.yellow;
				Gizmos.DrawWireCube(node.aabbSplit.center, node.aabbSplit.size);
			}
		}

		void drawTriangleAabbs(){
			Gizmos.color = Color.cyan;
			foreach(Triangle t in triangles)
			{
	//				Triangle t = triangles[42];
				Gizmos.DrawWireCube(t.aabb.center, t.aabb.size);
//				Debug.DrawLine(t.aabb.center, t.leaf.aabbSplit.center, Color.red);

//				int iVert1 = indexArray[t.id * 3 + 0];
//				int iVert2 = indexArray[t.id * 3 + 1];
//				int iVert3 = indexArray[t.id * 3 + 2];
//				Vector3 v1 = transform.TransformPoint(vertexArray[iVert1]);
//				Vector3 v2 = transform.TransformPoint(vertexArray[iVert2]);
//				Vector3 v3 = transform.TransformPoint(vertexArray[iVert3]);
//
//				Debug.DrawLine(v1, t.aabb.center, Color.green);
//				Debug.DrawLine(v2, t.aabb.center, Color.green);
//				Debug.DrawLine(v3, t.aabb.center, Color.green);
			}
		}

		void drawOctree(Octree root){
			Gizmos.color = Color.yellow;
			Gizmos.DrawWireCube(root.aabbSplit.center, root.aabbSplit.size);
			Gizmos.color = Color.cyan;
			Gizmos.DrawWireCube(root.aabbLoose.center, root.aabbLoose.size);
			foreach(Octree child in root.children){
				drawOctree(child);
//				Debug.DrawLine(root.aabbSplit.center, child.aabbSplit.center, Color.blue);
			}
		}

		// Use this for initialization
		void Start () {

			vertices = new List<Vertex>();
			triangles = new List<Triangle>();
			iTrisCandidates = new List<int>();
			iTrisInCells = new List<int>();
			leavesUpdate = new List<Octree>();
			pickedVertices = new List<int>();

			initMesh();


			this.vertexArrayReset = new Vector3	[vertexArray.Length];
			this.colorArrayReset  = new Color	[colorArray.Length];
			this.normalArrayReset = new Vector3	[normalArray.Length];
			this.indexArrayReset  = new int		[indexArray.Length];

			System.Array.Copy(this.vertexArray, this.vertexArrayReset, vertexArray.Length);
			System.Array.Copy(this.colorArray,  this.colorArrayReset,  colorArray.Length);
			System.Array.Copy(this.normalArray, this.normalArrayReset, normalArray.Length);
			System.Array.Copy(this.indexArray,  this.indexArrayReset,  indexArray.Length);

		}

		public void resetMesh(){

			mesh.vertices = this.vertexArrayReset;
			mesh.colors = this.colorArrayReset;
			mesh.normals = this.normalArrayReset;
			mesh.triangles = this.indexArrayReset;

			vertices = new List<Vertex>();
			triangles = new List<Triangle>();
			iTrisCandidates = new List<int>();
			iTrisInCells = new List<int>();
			leavesUpdate = new List<Octree>();
			pickedVertices = new List<int>();

			initMesh();
		}

		public void subdivideMesh(){
			MeshSubdivide.Subdivide4(mesh);
			mesh.RecalculateBounds();
			meshFilter.sharedMesh = mesh;


			vertices = new List<Vertex>();
			triangles = new List<Triangle>();
			iTrisCandidates = new List<int>();
			iTrisInCells = new List<int>();
			leavesUpdate = new List<Octree>();
			pickedVertices = new List<int>();

			initMesh();
		}


		void initMesh(){

	//			GameObject target = GameObject.Find("Target");
			
			meshFilter = GetComponent<MeshFilter>();
			mesh = meshFilter.sharedMesh; 

	//			MeshFilter mf = GetComponent<MeshFilter>();
	//			Mesh mesh = mf.mesh;
			
			vertexArray = mesh.vertices;
			normalArray = mesh.normals;
			indexArray = mesh.triangles;
			colorArray = mesh.colors;

			Bounds aabb = new Bounds();

			// create empty vertices:
			for(int i = 0; i < vertexArray.Length; i++){
				vertices.Add(new Vertex(i) );
//				this.coumputeRingVertices(i);
				Vector3 vertex = this.transform.TransformPoint(vertexArray[i]);
				aabb.Encapsulate(vertex );
			}




			// compute neigbour triangles for a vertex:
//			for(int triangleIndex = 0; triangleIndex < vertexArray.Length; triangleIndex++){
//			for(int t_idx = 0; t_idx < triangles.Count; t_idx+=3){
			int nbTriangles = indexArray.Length/3;
			for(int i = 0; i < nbTriangles; i++){
				int iV1 = indexArray[i * 3 + 0];
				int iV2 = indexArray[i * 3 + 1];
				int iV3 = indexArray[i * 3 + 2];
				
				Vertex v1 = vertices[iV1];
				Vertex v2 = vertices[iV2];
				Vertex v3 = vertices[iV3];

				v1.tIndices.Add(i);
				v2.tIndices.Add(i);
				v3.tIndices.Add(i);

			}



			for(int i = 0; i < vertexArray.Length; i++){
				coumputeRingVertices(i);
			}


//			int nbTriangles = indexArray.Length/3;

			for(int i = 0; i < nbTriangles; i++){
				Triangle t = new Triangle(i);

				updateTriangleAabbAndNormal(t);
				triangles.Add(t);
			}

			computeOctree(aabb);


		}

		void updateTriangleAabbAndNormal(Triangle t){
			int iTri = t.id;
			
			int iVert1 = indexArray[3 * iTri + 0];
			int iVert2 = indexArray[3 * iTri + 1];
			int iVert3 = indexArray[3 * iTri + 2];
			
			Vector3 v1 = transform.TransformPoint(vertexArray[iVert1]);
			Vector3 v2 = transform.TransformPoint(vertexArray[iVert2]);
			Vector3 v3 = transform.TransformPoint(vertexArray[iVert3]);
			
			Geometry.triangleNormal(v1, v2, v3, out t.normal);
			Geometry.triangleAabb(v1, v2, v3, out t.aabb);
		}

		void updateTrianglesAabbAndNormal(List<int> iTris){
			for(int i = 0; i < iTris.Count; i++){
				Triangle t = triangles[iTris[i]];
				updateTriangleAabbAndNormal(t);

			}
		}

		void computeOctree(Bounds aabbSplit){
			this.octree = new Octree(null, Octree.maxDepth);
			this.octree.aabbSplit.SetMinMax(aabbSplit.min, aabbSplit.max);

			int nbTriangles = triangles.Count;
			List<int> allTris = new List<int>();
			for(int i = 0; i < nbTriangles; i++){
				allTris.Add(i);
			}

			octree.build(this, allTris);
		}

  /**
   * Update Octree
   * For each triangle we check if its position inside the octree has changed
   * if so... we mark this triangle and we remove it from its former cells
   * We push back the marked triangles into the octree
   */
		public void updateOctree(List<int>iTris)
		{
			int nbTris = iTris.Count;
			List<int> trisToMove = new List<int>();


			Octree leaf;
			List<int> trisLeaf;
			for (int i = 0; i < nbTris; ++i) //recompute position inside the octree
			{
				Triangle t = triangles[iTris[i]];
				leaf = t.leaf;
//				trisToMove.Add(iTris[i]);
//				leaf.iTris.Remove(t.id);
				if ( !leaf.aabbSplit.Contains(t.aabb.center) )
				{
					trisToMove.Add(iTris[i]);
					trisLeaf = leaf.iTris;
					if(leaf.iTris.Contains(t.id) ){
						leaf.iTris.Remove(t.id);
//						t.leaf = null;
					}
				}
				else if (!t.aabb.Intersects(leaf.aabbLoose)){
					leaf.aabbLoose.Encapsulate(t.aabb);
				}
			}
			int nbTrisToMove = trisToMove.Count;
			for (int i = 0; i < nbTrisToMove; ++i) //add triangle to the octree
			{
				Triangle tri = triangles[trisToMove[i]];
				if (!this.octree.aabbLoose.Intersects(tri.aabb)) //we reconstruct the whole octree, slow... but rare
				{
					Debug.Log("reconstruct whole octree");
					Bounds aabb = new Bounds(octree.aabbSplit.center, octree.aabbSplit.size);

					List<int> allTris = new List<int>();
					var nbTriangles = triangles.Count;
					for (i = 0; i < nbTriangles; ++i){
						allTris.Add(i);
					}
					List<int> iVerts = getVerticesForTriangles(trisToMove);
					for(int j = 0; j <iVerts.Count; j++){
						Vector3 vertex = transform.TransformPoint(vertexArray[iVerts[j]]);
						aabb.Encapsulate(vertex);
					}

					this.octree = new Octree(null, Octree.maxDepth);
					this.octree.aabbSplit = aabb;
					this.octree.build(this, allTris);
					this.leavesUpdate.Clear();
					break;
				}
				else
				{
					leaf = tri.leaf;
					this.octree.addTriangle(tri);

//					if (leaf == tri.leaf) // failed to insert tri in octree
//					{
//						Debug.Log("failed to insert triangle[" + tri.id + "]");
//						trisLeaf = leaf.iTris;
//						tri.posInLeaf = trisLeaf.Count;
//						trisLeaf.Add(trisToMove[i]);
//					}
				}
			}
		}

		public void pushMeshData(){
			mesh.vertices = this.vertexArray;
			mesh.normals = this.normalArray;
			mesh.triangles = this.indexArray;
			mesh.colors = this.colorArray;
		}

		public void updateMesh(List<int> iTris, List<int> iVerts, bool bUpdateOctree){
			if(bUpdateOctree){
				updateTrianglesAabbAndNormal(iTris);
				updateOctree(iTris);
			}
			pushMeshData();


		}

		public void coumputeRingVertices(int iVert){
			Vertex v = vertices[iVert];
			v.ringVertices.Clear();


			for(int i = 0; i < v.tIndices.Count; i++){
				int iTri = v.tIndices[i] * 3;
				int iVert1 = indexArray[iTri + 0];
				int iVert2 = indexArray[iTri + 1];
				int iVert3 = indexArray[iTri + 2];

				if(iVert != iVert1) v.ringVertices.Add(iVert1);
				if(iVert != iVert2) v.ringVertices.Add(iVert2);
				if(iVert != iVert3) v.ringVertices.Add(iVert3);
			}
		}

		public bool intersectRayMesh(Ray ray){
			bool intersected = false;
			Octree.selectedNodes.Clear();
	//		foreach(int iTri in iTrisCandidates){
	//			
	//			int iVert1 = indexArray[iTri + 0];
	//			int iVert2 = indexArray[iTri + 1];
	//			int iVert3 = indexArray[iTri + 2];
	//			
	//			colorArray[iVert1] = Color.white;
	//			colorArray[iVert2] = Color.white;
	//			colorArray[iVert3] = Color.white;
	//		}

			iTrisCandidates = octree.intersectRay(ray);

			float minDist = Mathf.Infinity;
			this.pickedTriangle = -1;
			this.intersectionPoint = Vector3.zero;

			foreach(int iTri in iTrisCandidates){

				Triangle t = triangles[iTri];
				if( t.aabb.IntersectRay(ray) ){

					if(Vector3.Distance(ray.origin, t.aabb.center) < minDist ){

						int iVert1 = indexArray[3 * iTri + 0];
						int iVert2 = indexArray[3 * iTri + 1];
						int iVert3 = indexArray[3 * iTri + 2];
						
//						colorArray[iVert1] = Color.red;
//						colorArray[iVert2] = Color.red;
//						colorArray[iVert3] = Color.red;

						Vector3 v1 = transform.TransformPoint( vertexArray[iVert1] );
						Vector3 v2 = transform.TransformPoint( vertexArray[iVert2] );
						Vector3 v3 = transform.TransformPoint( vertexArray[iVert3] );

						float dist = Vector3.Distance(ray.origin, v1);
						if(dist < minDist) {
							minDist = dist;
							this.pickedTriangle = iTri;
							this.intersectionPoint = v1;
						}

						dist = Vector3.Distance(ray.origin, v2);
						if(dist < minDist) {
							minDist = dist;
							this.pickedTriangle = iTri;
							this.intersectionPoint = v2;
						}

						dist = Vector3.Distance(ray.origin, v3);
						if(dist < minDist) {
							minDist = dist;
							this.pickedTriangle = iTri;
							this.intersectionPoint = v3;
						}
					}

				}
				if(-1 != this.pickedTriangle){
					intersected = true;
					this.worldRadiusSqr = 1.0f;
				}else{
					this.worldRadiusSqr = 0.0f;
				}
			}

			mesh.colors = colorArray;
			return intersected;
		}


		public List<int> pickVerticesInSphere(float radius){
			this.leavesUpdate.Clear();
			this.pickedVertices.Clear();

			this.worldRadiusSqr = radius;
			this.iTrisInCells = this.octree.intersectSphere(this.intersectionPoint, this.worldRadiusSqr, this.leavesUpdate);

			List<int> iVerts = getVerticesForTriangles(this.iTrisInCells);
			long vertexSculptMask = ++Vertex.SculptMask;
			for(int i = 0; i < iVerts.Count; i++){
				int idx = iVerts[i];

				Vector3 v = transform.TransformPoint( vertexArray[idx] );
				float dist = Vector3.Distance(this.intersectionPoint, v);
				if(dist < this.worldRadiusSqr){
					vertices[idx].sculptFlag = vertexSculptMask;
					this.pickedVertices.Add(idx);

//					colorArray[idx] = Color.red;

				}
			}
			if (this.pickedVertices.Count == 0 && this.pickedTriangle != -1) //no vertices inside the brush radius (big triangle or small radius)
			{

				int j = this.pickedTriangle * 3;
				this.pickedVertices.Add(this.indexArray[j]);
				this.pickedVertices.Add(this.indexArray[j+1]);
				this.pickedVertices.Add(this.indexArray[j+2]);
				                       
			}
			return this.pickedVertices;
		}

		public List<int> getVerticesForTriangles(List<int> iTris){

			long vertexTagMask = ++Vertex.TagMask;

			List<int> iVerts = new List<int>();
			for(int i = 0; i < iTris.Count; i++){
				int triIdx = iTris[i] * 3;
				int iVert1 = indexArray[triIdx + 0];
				int iVert2 = indexArray[triIdx + 1];
				int iVert3 = indexArray[triIdx + 2];

				if (vertices[iVert1].tagFlag != vertexTagMask)
				{
					iVerts.Add(iVert1);
					vertices[iVert1].tagFlag = vertexTagMask;
				}
				if (vertices[iVert2].tagFlag != vertexTagMask)
				{
					iVerts.Add(iVert2);
					vertices[iVert2].tagFlag = vertexTagMask;
				}
				if (vertices[iVert3].tagFlag != vertexTagMask)
				{
					iVerts.Add(iVert3);
					vertices[iVert3].tagFlag = vertexTagMask;
				}
			}
			return iVerts;
		}

		public List<int>getTrianglesFromVertices(List<int>iVerts)
		{
			long triangleTagMask = ++Triangle.tagMask;
			List<int> iTris = new List<int>();
			int nbVerts = iVerts.Count;

			for (var i = 0; i < nbVerts; ++i)
			{
				List<int> ringTris = vertices[iVerts[i]].tIndices;
				int nbTris = ringTris.Count;
				for (var j = 0; j < nbTris; ++j)
				{
					var iTri = ringTris[j];
					if (triangles[iTri].tagFlag != triangleTagMask)
					{
						iTris.Add(iTri);
						triangles[iTri].tagFlag = triangleTagMask;
					}
				}
			}
			return iTris;
		}


		/** Get more triangles (n-ring) */
		public void expandsTriangles(List<int> iTris, int nRing)
		{
			long triangleTagMask = ++Triangle.tagMask;
			int nbTris = iTris.Count;
			int[] iAr = this.indexArray;
			int i = 0;
			int j = 0;
			for (i = 0; i < nbTris; ++i){
				triangles[iTris[i]].tagFlag = triangleTagMask;
			}
			int iBegin = 0;
			while (nRing > 0)
			{
				--nRing;
				for (i = iBegin; i < nbTris; ++i)
				{
					int ind = iTris[i] * 3;
					List<int> iTris1 = vertices[ind].tIndices;
					List<int> iTris2 = vertices[ind + 1].tIndices;
					List<int> iTris3 = vertices[ind + 2].tIndices;
					int nbTris1 = iTris1.Count;
					int nbTris2 = iTris2.Count;
					int nbTris3 = iTris3.Count;

					for (j = 0; j < nbTris1; ++j)
					{
						Triangle t1 = triangles[iTris1[j]];
						if (t1.tagFlag != triangleTagMask)
						{
							t1.tagFlag = triangleTagMask;
							iTris.Add(iTris1[j]);
						}
					}
					for (j = 0; j < nbTris2; ++j)
					{
						Triangle t2 = triangles[iTris2[j]];
						if (t2.tagFlag != triangleTagMask)
						{
							t2.tagFlag = triangleTagMask;
							iTris.Add(iTris2[j]);
						}
					}
					for (j = 0; j < nbTris3; ++j)
					{
						Triangle t3 = triangles[iTris3[j]];
						if (t3.tagFlag != triangleTagMask)
						{
							t3.tagFlag = triangleTagMask;
							iTris.Add(iTris3[j]);
						}
					}
				}
				iBegin = nbTris;
				nbTris = iTris.Count;
			}
		}


		/** Compute average normal of a group of vertices with culling */
		public Vector3 areaNormal(List<int>iVerts)
		{
			int nbVerts = iVerts.Count;
			Vector3 aNormal = Vector3.zero;
			
			for (int i = 0; i < nbVerts; ++i)
			{
				Vector3 normal = transform.TransformPoint(normalArray[iVerts[i]]);
//				Vector3 v = transform.TransformPoint(vertexArray[iVerts[i]]);
//				Debug.DrawLine(v, v + normal* 0.001f, Color.cyan);

               aNormal += normal.normalized;
       		}
       		return aNormal.normalized;
       	}

		/** Compute average normal of a group of vertices with culling */
		public Vector3 areaCenter(List<int>iVerts)
		{
			int nbVerts = iVerts.Count;
			Vector3 aCenter = Vector3.zero;
			
			for (int i = 0; i < nbVerts; ++i)
			{

				Vector3 v = transform.TransformPoint(vertexArray[iVerts[i]]);
				//				Debug.DrawLine(v, v + normal* 0.001f, Color.cyan);
				
				aCenter += v;
			}
			return aCenter * (1.0f/nbVerts);
		}
	}
}
