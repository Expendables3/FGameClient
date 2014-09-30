package GUI.ChampionLeague.GuiLeague 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIMainLeague extends BaseGUI 
	{
		static public const ID_BTN_CHOOSE_SOLDIER:String = "idBtnChooseSoldier";
		
		public function GUIMainLeague(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("");
			SetPos(0, 0);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CHOOSE_SOLDIER:
					GuiMgr.getInstance().guiSelectSoldier.Show(Constant.GUI_MIN_LAYER, 3);
				break;
			}
		}
		
	}

}