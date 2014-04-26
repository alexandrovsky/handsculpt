using UnityEngine;
using System.Collections;
using Sculpt;

public class Gui : MonoBehaviour {
	
	public GameObject m_navigationToolPrefab = null;
	public GameObject m_grabToolPrefab = null;
	public GameObject m_pointingToolPrefab = null;
	public GameObject m_shadowToolPrefab = null;

	private GameObject currentNavigationTool = null;
	private GameObject currentManipulationTool = null;

	GameObject target;
	GameObject hands;


	SculptMesh sculptMesh;
	Sculpter sculpter;
	LeapUnityHandController handController;
	public string objectExportFilepath = "/Users/dimi/Desktop/target.obj";
	
	private bool m_DisplayGui = true;

	bool mouseMode;


	void Start(){
		target = GameObject.Find("Target");
		sculptMesh = target.GetComponent<SculptMesh>();
		sculpter = target.GetComponent<Sculpter>();
		hands = GameObject.Find("Leap Hands");	
		handController = hands.GetComponent<LeapUnityHandController>();
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





	void OnGUI(){

		if(m_DisplayGui)
		{

			GUILayout.BeginArea (new Rect (0, 20 , 200, 400));


			if( GUILayout.Button("Object Export") ){
				MeshFilter objMeshFilter = target.GetComponent<MeshFilter>();
				ObjExporter.MeshToFile(objMeshFilter, objectExportFilepath);
			}
			objectExportFilepath = GUILayout.TextField(objectExportFilepath);

//			if( GUILayout.Button("Subdivide") ){
//				GameObject target = GameObject.Find("Target");
//				TargetObjectScript tos = target.GetComponent<TargetObjectScript>();
//				tos.Subdivide();
//			}

//			if( GUILayout.Button("Reset") ){
//				GameObject target = GameObject.Find("Target");
//				TargetObjectScript tos = target.GetComponent<TargetObjectScript>();
//				tos.ResetMesh();
//			}
			{

				SculptMesh sculptMesh = target.GetComponent<Sculpt.SculptMesh>();

				GUILayout.TextField( "verts count: " + sculptMesh.vertices.Count);
				GUILayout.TextField( "tris count: " + sculptMesh.triangles.Count);

				GUILayout.TextField( "scale: " + target.transform.localScale);

			}
			GUILayout.EndArea();




			// set tools:

			GUILayout.BeginArea(new Rect (Screen.width-200, 20 , 200, 600));

			// mouse mode
			{
				mouseMode = GUILayout.Toggle(mouseMode, "mouse enabled");
				sculpter.isEnabled = mouseMode;
				GUILayout.Label("Current Tool " + sculpter.tool );
				GUILayout.BeginVertical();{
					GUILayout.TextField("intesity:" + sculpter.intensity);
					sculpter.intensity = GUILayout.HorizontalSlider(sculpter.intensity, 0.01f, 1.0f);
				}GUILayout.EndVertical();
				
				
				GUILayout.BeginVertical();{
					GUILayout.TextField("radius: " + sculpter.radius);
					sculpter.radius = GUILayout.HorizontalSlider(sculpter.radius, 0.01f, 12.0f);
				}GUILayout.EndVertical();


			}
			GUILayout.Label("-----");
			if(!mouseMode){
				GUILayout.Label("Hand assign " + handController.assignMode );
				GUILayout.BeginHorizontal();
				bool bDynamic = GUILayout.Button("dynamic");
				if(bDynamic){
					handController.assignMode = LeapUnityHandController.HandAssignMode.Dynamic;
				}
				bool bLeft = GUILayout.Button("left");
				if(bLeft){
					handController.assignMode = LeapUnityHandController.HandAssignMode.Left;
				}
				bool bRight = GUILayout.Button("right");
				if(bRight){
					handController.assignMode = LeapUnityHandController.HandAssignMode.Right;
				}
				GUILayout.EndHorizontal();

				GUILayout.Label("-----");

				if( GUILayout.Button( "pointing") ){
					instantiateManipulationTool(m_pointingToolPrefab);
				}
				if( GUILayout.Button( "shadow") ){
					instantiateManipulationTool(m_shadowToolPrefab);
				}
				if( GUILayout.Button("grab") ){
					instantiateManipulationTool(m_grabToolPrefab);
				}

				if( GUILayout.Button( "Apply Navigation Tool") )
				{
					instantiateNavigationTool(m_navigationToolPrefab);
				}
				GUILayout.Label("-----");
				if(currentNavigationTool != null){
					HandTool handTool = currentNavigationTool.GetComponent<HandTool>();
					GUILayout.BeginVertical();{
						handTool.CostumGUI();
					}GUILayout.EndVertical();
				}

				if(currentManipulationTool != null){
					HandTool handTool = currentManipulationTool.GetComponent<HandTool>();
					GUILayout.BeginVertical();{
						handTool.CostumGUI();
					}GUILayout.EndVertical();
					
				}

			}else{
				// set the tool with the mouse
			}

			//GameObject hands = GameObject.Find("Leap Hands");	
			//LeapUnityHandController controller = hands.GetComponent<LeapUnityHandController>();

//			if( GUILayout.Button( "appearance") ){
//				GameObject hands = GameObject.Find("Leap Hands");
//
//			}




			GUILayout.EndArea();
			
		}
	}
	float angleV = 0.0f;
	float angleH = 0.0f;
}
