package GUI
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import GUI.component.BaseGUI;
	
	import flash.events.*;
	import Logic.*;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class GUIHelp extends BaseGUI
	{
		public static var GUI_HELP_BTN_EXIT:String = "ButtonExit";

		
		public function GUIHelp(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIHelp";
		}
		
		public override function InitGUI():void
		{
			//LoadRes("GuiHelp");			
			this.setImgInfo = function():void
			{			
				SetPos(37, 30);
				AddButton(GUI_HELP_BTN_EXIT, "BtnThoat", 706, 21);
				OpenRoomOut();
			}
			LoadRes("GuiHelp_Theme");
		}
	
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch(buttonID)
			{
				case GUI_HELP_BTN_EXIT:		
					Hide();
					break;
			}
		}		
	}

}