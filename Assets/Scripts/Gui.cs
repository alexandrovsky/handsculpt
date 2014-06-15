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
	public string objectExportFilepath = "/Users/dimi/Desktop/";
	public string objectExportFilename = "target";
	public string objectExportFileextension = ".obj";

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
		//display whole gui:
		if( Input.GetKeyDown(KeyCode.H) )
		{
			m_DisplayGui = !m_DisplayGui;
		}

		// tool parameters:
		if( Input.GetKeyUp(KeyCode.S) )
		{
			toolDispatcher.symmetry = !toolDispatcher.symmetry;
		}

		if( Input.GetKeyUp(KeyCode.I) )
		{
			toolDispatcher.inverted = !toolDispatcher.inverted;
		}


		// tool assignment:
		if( Input.GetKeyUp(KeyCode.Alpha1) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT, handController.leftHand);
		}
		if( Input.GetKeyUp(KeyCode.Alpha2) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT, handController.rightHand);
		}
		if( Input.GetKeyUp(KeyCode.Alpha3) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_SMOOTH, handController.leftHand);
		}
		if( Input.GetKeyUp(KeyCode.Alpha4) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_SMOOTH, handController.rightHand);
		}
		if( Input.GetKeyUp(KeyCode.Alpha5) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_GRAB, handController.leftHand);
		}
		if( Input.GetKeyUp(KeyCode.Alpha6) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_GRAB, handController.rightHand);
		}
		if( Input.GetKeyUp(KeyCode.Alpha7) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB, handController.leftHand);
		}
		if( Input.GetKeyUp(KeyCode.Alpha8) )
		{
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB, handController.rightHand);
		}

		// radius scale with [ctrl]  [+] | [ctrl]  [-]
		if(Input.GetKey(KeyCode.LeftControl) ){
			float step = 0.05f;
			if(Input.GetKey(KeyCode.Plus) ){
				if( (toolDispatcher.radius + step) < 3.0f){
					toolDispatcher.radius += step;
				}else{
					toolDispatcher.radius = 3.0f;
				}
			}
			if(Input.GetKey(KeyCode.Minus) ){
				if( (toolDispatcher.radius - step) > 0.01f){
					toolDispatcher.radius -= step;
				}else{
					toolDispatcher.radius = 0.01f;
				}
			}
		}

		// intensity scale with [alt]  [+] | [alt]  [-]
		if(Input.GetKey(KeyCode.LeftAlt) ){
			float step = 0.015f;
			if(Input.GetKey(KeyCode.Plus) ){
				if( (toolDispatcher.intensity + step) < 1.0f){
					toolDispatcher.intensity += step;
				}else{
					toolDispatcher.intensity = 1.0f;
				}
			}
			if(Input.GetKey(KeyCode.Minus) ){
				if( (toolDispatcher.intensity - step) > 0.0f){
					toolDispatcher.intensity -= step;
				}else{
					toolDispatcher.intensity = 0.0f;
				}
			}
		}


		// undo redo [ctrg] + [z] | [ctrg] + [y]
		if(Input.GetKey(KeyCode.LeftControl) ){
			if(Input.GetKey(KeyCode.Z) ){
				toolDispatcher.undo();
			}
			if(Input.GetKey(KeyCode.Y) ){
				toolDispatcher.redo();
			}
		}

		// export object [ctrg] + [e]
		if(Input.GetKey(KeyCode.LeftControl) ){
			if(Input.GetKey(KeyCode.E) ){
				MeshFilter objMeshFilter = target.GetComponent<MeshFilter>();
				ObjExporter.MeshToFile(objMeshFilter, generateExportFilePath() );
			}

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

	string generateExportFilePath(){
		string result = objectExportFilepath + objectExportFilename
			+ "_" + System.DateTime.Now.ToString("yyyy_MM_dd_hh_mm_ss")			
			+ "_left_" + toolDispatcher.currentLeftTool.ToString() 
			+ "_right_" + toolDispatcher.currentRightTool.ToString() 
			+ objectExportFileextension;
		return result;
	}


	void OnApplicationQuit(){
		MeshFilter objMeshFilter = target.GetComponent<MeshFilter>();
		ObjExporter.MeshToFile(objMeshFilter, generateExportFilePath() );
		sculptMesh.resetMesh();
	}


	void OnGUI(){


		// hand status:
		GUILayout.BeginArea(new Rect(Screen.width/2 +10, 20, 50, 50));{
			if(handController.rightHand.lost){
				GUILayout.Label(m_greyTexture);
			}else{
				GUILayout.Label(m_greenTexture);
			}
		}GUILayout.EndArea();
		
		GUILayout.BeginArea(new Rect(Screen.width/2-50 -10, 20, 50, 50));
		
		if(handController.leftHand.lost){
			GUILayout.Label(m_greyTexture);
		}else{
			GUILayout.Label(m_greenTexture);
		}
		GUILayout.EndArea();
		
		
		if(m_DisplayGui)
		{

			GUILayout.BeginArea (new Rect (0, 20 , 200, 400));
			meshControlGui();
			GUILayout.EndArea();

			// set tools:
			GUILayout.BeginArea(new Rect (Screen.width-200, 20 , 200, 600));

			toolParamsGui();

			GUILayout.Label("-----");

			toolSelectionGui();
			GUILayout.EndArea();
		}
	}

	private void meshControlGui(){

		objectExportFilepath = GUILayout.TextField(objectExportFilepath);
		objectExportFilename = GUILayout.TextField(objectExportFilename);
		if( GUILayout.Button("Object Export") ){
			MeshFilter objMeshFilter = target.GetComponent<MeshFilter>();
			ObjExporter.MeshToFile(objMeshFilter, generateExportFilePath());
		}

		
		if( GUILayout.Button("Subdivide") ){
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
		
		GUILayout.BeginHorizontal();
		if( GUILayout.Button("Undo \n [ctrl] + [z]") ){
			toolDispatcher.undo();
		}
		if( GUILayout.Button("Redo \n [ctrl]  + [y]") ){
			toolDispatcher.redo();
		}
		GUILayout.EndHorizontal();
		
		sculptMesh.drawDebug = GUILayout.Toggle(sculptMesh.drawDebug, "Debug");
	}
	private void toolParamsGui(){
		GUILayout.Label("Current Tool left" + toolDispatcher.currentLeftTool );
		GUILayout.Label("Current Tool right" + toolDispatcher.currentRightTool );
		GUILayout.BeginVertical();{
			GUILayout.TextField("intesity:" + toolDispatcher.intensity);
			toolDispatcher.intensity = GUILayout.HorizontalSlider(toolDispatcher.intensity, 0.0f, 1.0f);
		}GUILayout.EndVertical();
		
		
		GUILayout.BeginVertical();{
			GUILayout.TextField("radius: " + toolDispatcher.radius);
			toolDispatcher.radius = GUILayout.HorizontalSlider(toolDispatcher.radius, 0.0f, 2.5f);
		}GUILayout.EndVertical();
		
		GUILayout.BeginHorizontal();{
			toolDispatcher.symmetry = GUILayout.Toggle(toolDispatcher.symmetry, "[s]ymmetry");
			toolDispatcher.inverted = GUILayout.Toggle(toolDispatcher.inverted, "[i]nverted");
		}GUILayout.EndHorizontal();
	}
	private void toolSelectionGui(){

		GUILayout.Label("Pointing Tool");
		GUILayout.BeginHorizontal();
		if( GUILayout.Button( "Left [1]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT, handController.leftHand);
		}
		if( GUILayout.Button( "Right [2]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT, handController.rightHand);
		}
		GUILayout.EndHorizontal();
		
		
		
		GUILayout.Label("Shadow Tool");
		GUILayout.BeginHorizontal();
		if( GUILayout.Button( "Left [3]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_SMOOTH, handController.leftHand);
		}
		if( GUILayout.Button( "Right [4]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_SMOOTH, handController.rightHand);
		}
		GUILayout.EndHorizontal();



		GUILayout.Label("Grab Tool");
		GUILayout.BeginHorizontal();
		if( GUILayout.Button( "Left [5]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_GRAB, handController.leftHand);
		}
		if( GUILayout.Button( "Right [6]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_GRAB, handController.rightHand);
		}
		GUILayout.EndHorizontal();

		
		GUILayout.Label("Naigation Grab");
		GUILayout.BeginHorizontal();
		if( GUILayout.Button( "Left [7]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB, handController.leftHand);
		}
		if( GUILayout.Button( "Right [8]") ){
			toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_NAVIGATION_GRAB, handController.rightHand);
		}
		GUILayout.EndHorizontal();
		
		
		//				GUILayout.Label("Pointing Assistent Tool");
	//				GUILayout.BeginHorizontal();
	//				if( GUILayout.Button( "Left") ){
	//					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT_ASSISTENT, handController.leftHand);
	//				}
	//				if( GUILayout.Button( "Right") ){
	//					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.TOOL_PAINT_ASSISTENT, handController.rightHand);
	//				}
	//				GUILayout.EndHorizontal();
	
	
	//				GUILayout.Label("Dynamic Assistent Tool");
	//				GUILayout.BeginHorizontal();
	//				if( GUILayout.Button( "Left") ){
	//					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.DYNAMIC_SCECONDARY, handController.leftHand);
	//				}
	//				if( GUILayout.Button( "Right") ){
	//					toolDispatcher.SetToolForHand(MenuBehavior.ButtonAction.DYNAMIC_SCECONDARY, handController.rightHand);
	//				}
	//				GUILayout.EndHorizontal();
	}
	
}
