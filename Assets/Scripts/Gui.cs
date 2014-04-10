using UnityEngine;
using System.Collections;

public class Gui : MonoBehaviour {
	
	public GameObject m_navigationToolPrefab = null;
	public GameObject m_grabToolPrefab = null;
	public GameObject m_pointingToolPrefab = null;
	public GameObject m_shadowToolPrefab = null;

	private GameObject currentNavigationTool = null;
	private GameObject currentManipulationTool = null;

	
	public string objectExportFilepath = "/Users/dimi/Desktop/target.obj";
	
	private bool m_DisplayGui = true;


	void Start(){
		
	}
	
	void Update()
	{
		if( Input.GetKeyDown(KeyCode.H) )
		{
			m_DisplayGui = !m_DisplayGui;
		}
	}
	/*
	void OnDrawGizmos()
	{
		GameObject obj = GameObject.Find("Target");
		Gizmos.color = Color.yellow;
		Gizmos.DrawWireCube(obj.transform.position, obj.transform.renderer.bounds.size);
	}
	*/
	


	
	
	
	void instantiateManipulationTool(GameObject tool){
		if(currentManipulationTool != null) {// only one tool should exist at a time.
			GameObject.Destroy(currentManipulationTool);
		}
		currentManipulationTool = Instantiate(tool) as GameObject;
	}

	void instantiateNavigationTool(GameObject tool){
		if(currentNavigationTool != null) {// only one tool should exist at a time.
			GameObject.Destroy(currentNavigationTool);
		}
		currentNavigationTool = Instantiate(tool) as GameObject;
	}





//	void OnGUI(){
//
//		if(m_DisplayGui)
//		{
//
//			GUILayout.BeginArea (new Rect (0, 20 , 200, 400));
//
//
//			if( GUILayout.Button("Object Export") ){
//				GameObject obj = GameObject.Find("Target");
//				MeshFilter objMeshFilter = obj.GetComponent<MeshFilter>();
//				ObjExporter.MeshToFile(objMeshFilter, objectExportFilepath);
//			}
//			objectExportFilepath = GUILayout.TextField(objectExportFilepath);
//
//			if( GUILayout.Button("Subdivide") ){
//				GameObject target = GameObject.Find("Target");
//				TargetObjectScript tos = target.GetComponent<TargetObjectScript>();
//				tos.Subdivide();
//			}
//
//			if( GUILayout.Button("Reset") ){
//				GameObject target = GameObject.Find("Target");
//				TargetObjectScript tos = target.GetComponent<TargetObjectScript>();
//				tos.ResetMesh();
//			}
//			{
//				GameObject target = GameObject.Find("Target");
//				MeshFilter targetMeshFilter = target.GetComponent<MeshFilter>();
//				Mesh targetMesh = targetMeshFilter.mesh;
//				GUILayout.TextField( "verts count: " + targetMesh.vertices.Length);
//				GUILayout.TextField( "tris count: " + targetMesh.triangles.Length);
//
//				GUILayout.TextField( "scale: " + target.transform.localScale);
//
//			}
//			GUILayout.EndArea();
//
//
//
//
//			// set tools:
//
//			GUILayout.BeginArea(new Rect (Screen.width-200, 20 , 200, 600));
//
//
//			//GameObject hands = GameObject.Find("Leap Hands");	
//			//LeapUnityHandController controller = hands.GetComponent<LeapUnityHandController>();
//
////			if( GUILayout.Button( "appearance") ){
////				GameObject hands = GameObject.Find("Leap Hands");
////
////			}
//
//
//			if( GUILayout.Button( "pointing") ){
//				instantiateManipulationTool(m_pointingToolPrefab);
//			}
//			if( GUILayout.Button( "shadow") ){
//				instantiateManipulationTool(m_shadowToolPrefab);
//			}
//			if( GUILayout.Button("grab") ){
//				instantiateManipulationTool(m_grabToolPrefab);
//			}
//			
//
//
//
////			if(currentManipulationTool != null){
////				HandTool handTool = currentManipulationTool.GetComponent<HandTool>();
////				GUILayout.TextField("current tool " + handTool.name);
////
////				GUILayout.BeginVertical();{
////					GUILayout.TextField("strength:" + handTool.strength);
////					handTool.strength = GUILayout.HorizontalSlider(handTool.strength, 0.01f, 1.0f);
////				}GUILayout.EndVertical();
////
////
////				GUILayout.BeginVertical();{
////					GUILayout.TextField("radius: " + handTool.radius);
////					handTool.radius = GUILayout.HorizontalSlider(handTool.radius, 0.0f, 12.0f);
////				}GUILayout.EndVertical();
////
////
////				GUILayout.BeginVertical();{
////					GUILayout.TextField("min activation dist:" + handTool.MinActivationDistance);
////					handTool.MinActivationDistance = GUILayout.HorizontalSlider(handTool.MinActivationDistance, 0.5f, 5.0f);
////				}GUILayout.EndVertical();
////
////				GUILayout.BeginVertical();{
////					handTool.CostumGUI();
////				}GUILayout.EndVertical();
////
////			}
//			// TEST ROTATION:
//			GUILayout.BeginVertical();{
//				angleV = GUILayout.HorizontalSlider(angleV, 0.0f, 360.0f);
//				GameObject target = GameObject.Find("Target");
//				Camera.main.transform.RotateAround(target.transform.position, Camera.main.transform.up, angleV);
//				//angle = 0.0f;
//			}GUILayout.EndVertical();
//			GUILayout.BeginVertical();{
//				angleH = GUILayout.HorizontalSlider(angleH, 0.0f, 360.0f);
//				GameObject target = GameObject.Find("Target");
//				Camera.main.transform.RotateAround(target.transform.position, Camera.main.transform.right, angleH);
////				angle = 0.0f;
//			}GUILayout.EndVertical();
//
//
//			if( GUILayout.Button( "Apply Navigation Tool") )
//			{
//				instantiateNavigationTool(m_navigationToolPrefab);
//			}
//
//			if(currentNavigationTool != null){
//				HandTool handTool = currentNavigationTool.GetComponent<HandTool>();
//				
//				GUILayout.BeginVertical();{
//					handTool.CostumGUI();
//				}GUILayout.EndVertical();
//			}
//
//			GUILayout.EndArea();
//			
//		}
//	}
	float angleV = 0.0f;
	float angleH = 0.0f;
}
