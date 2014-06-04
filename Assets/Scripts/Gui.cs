using UnityEngine;
using System.Collections;
using Sculpt;

public class Gui : MonoBehaviour {

	public Texture2D m_redTexture = null;
	public Texture2D m_greenTexture = null;
	public Texture2D m_greyTexture = null;

	GameObject target;



	SculptMesh sculptMesh;
	Sculpter sculpter;
	HandController handController;
	ToolDispatcher toolDispatcher;
	public string objectExportFilepath = "/Users/dimi/Desktop/target.obj";
	
	private bool m_DisplayGui = true;

	bool mouseMode;


	void Start(){
		target = GameObject.Find("Target");
		sculptMesh = target.GetComponent<SculptMesh>();
		sculpter = target.GetComponent<Sculpter>();
		handController = (GameObject.Find("LeapManager") as GameObject).GetComponent(typeof(HandController)) as HandController;
		toolDispatcher = (GameObject.Find("GuiEventListener ") as GameObject).GetComponent(typeof(ToolDispatcher)) as ToolDispatcher;
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
	


	
	
	






	void OnGUI(){

		if(m_DisplayGui)
		{

			GUILayout.BeginArea (new Rect (0, 20 , 200, 400));


			if( GUILayout.Button("Object Export") ){
				MeshFilter objMeshFilter = target.GetComponent<MeshFilter>();
				ObjExporter.MeshToFile(objMeshFilter, objectExportFilepath);
			}
			objectExportFilepath = GUILayout.TextField(objectExportFilepath);

			if( GUILayout.Button("Subdivide") ){
//				GameObject target = GameObject.Find("Target");
//				TargetObjectScript tos = target.GetComponent<TargetObjectScript>();
//				tos.Subdivide();

				sculptMesh.subdivideMesh();
			}

			if( GUILayout.Button("Reset") ){

				sculptMesh.resetMesh();
			}
			{
				GUILayout.TextField( "verts count: " + sculptMesh.vertices.Count);
				GUILayout.TextField( "tris count: " + sculptMesh.triangles.Count);

				GUILayout.TextField( "scale: " + target.transform.localScale);
			}

			sculptMesh.drawDebug = GUILayout.Toggle(sculptMesh.drawDebug, "Debug");

			GUILayout.EndArea();




			// set tools:

			GUILayout.BeginArea(new Rect (Screen.width-200, 20 , 200, 600));

			// mouse mode
			{
				mouseMode = GUILayout.Toggle(mouseMode, "mouse enabled");
				sculpter.isEnabled = mouseMode;
				GUILayout.Label("Current Tool left" + toolDispatcher.currentLeftTool );
				GUILayout.Label("Current Tool right" + toolDispatcher.currentRightTool );
				GUILayout.BeginVertical();{
					GUILayout.TextField("intesity:" + toolDispatcher.intensity);
					toolDispatcher.intensity = GUILayout.HorizontalSlider(toolDispatcher.intensity, 0.0f, 1.0f);
				}GUILayout.EndVertical();
				
				
				GUILayout.BeginVertical();{
					GUILayout.TextField("radius: " + toolDispatcher.radius);
					toolDispatcher.radius = GUILayout.HorizontalSlider(toolDispatcher.radius, 0.01f, 3.0f);
				}GUILayout.EndVertical();

				GUILayout.BeginHorizontal();{
					toolDispatcher.symmetry = GUILayout.Toggle(toolDispatcher.symmetry, "symmetry");
					toolDispatcher.inverted = GUILayout.Toggle(toolDispatcher.inverted, "inverted");
				}GUILayout.EndHorizontal();


			}
			GUILayout.Label("-----");
			if(!mouseMode){

				GUILayout.Label("Pointing Tool");
				GUILayout.BeginHorizontal();
				if( GUILayout.Button( "Left") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT, handController.leftHand);
				}
				if( GUILayout.Button( "Right") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT, handController.rightHand);
				}
				GUILayout.EndHorizontal();



				GUILayout.Label("Shadow Tool");
				GUILayout.BeginHorizontal();
				if( GUILayout.Button( "Left") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_SMOOTH, handController.leftHand);
				}
				if( GUILayout.Button( "Right") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_SMOOTH, handController.rightHand);
				}
				GUILayout.EndHorizontal();

				GUILayout.Label("Grab Tool");
				GUILayout.BeginHorizontal();
				if( GUILayout.Button( "Left") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_GRAB, handController.leftHand);
				}
				if( GUILayout.Button( "Right") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_GRAB, handController.rightHand);
				}
				GUILayout.EndHorizontal();


				GUILayout.Label("Pointing Assistent Tool");
				GUILayout.BeginHorizontal();
				if( GUILayout.Button( "Left") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT_ASSISTENT, handController.leftHand);
				}
				if( GUILayout.Button( "Right") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT_ASSISTENT, handController.rightHand);
				}
				GUILayout.EndHorizontal();


				GUILayout.Label("Dynamic Assistent Tool");
				GUILayout.BeginHorizontal();
				if( GUILayout.Button( "Left") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.DYNAMIC_SCECONDARY, handController.leftHand);
				}
				if( GUILayout.Button( "Right") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.DYNAMIC_SCECONDARY, handController.rightHand);
				}
				GUILayout.EndHorizontal();


				GUILayout.Label("Naigation Grab");
				GUILayout.BeginHorizontal();
				if( GUILayout.Button( "Left") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB, handController.leftHand);
				}
				if( GUILayout.Button( "Right") ){
					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB, handController.rightHand);
				}
				GUILayout.EndHorizontal();






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

			// hand status:
			GUILayout.BeginArea(new Rect(Screen.width/2, Screen.height-100, 50, 50));{
				if(handController.rightHand.isHandValid()){
					GUILayout.Label(m_greenTexture);
				}else{
					GUILayout.Label(m_greyTexture);
				}
			}GUILayout.EndArea();

			GUILayout.BeginArea(new Rect(Screen.width/2-50, Screen.height-100, 50, 50));

			if(handController.leftHand.isHandValid()){
				GUILayout.Label(m_greenTexture);
			}else{
				GUILayout.Label(m_greyTexture);
			}
			GUILayout.EndArea();
		}
	}

}
