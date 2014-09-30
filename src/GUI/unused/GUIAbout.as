package  GUI.unused
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import flash.events.*;
	import Logic.*;
	import Data.Localization;
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIAbout extends BaseGUI
	{
		public static var GUI_ABOUT_BTN1:String = "btn1";
		
		
		public function GUIAbout(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIAbout";
		}
		
		public override function InitGUI():void
		{
			var container:Container = AddContainer("container1", "CtnShopItem", 100, 100);			
			
			var btn:Button = container.AddButton(GUI_ABOUT_BTN1, "BtnTrangTri", 10, 30, this);
	

			SetDragable(new Rectangle(100, 0, 300, 30));
			
			var lb:TextField = AddLabel("ta la MinhBenh", -100, -100);
			
			SetPos(200, 200);
		}
	
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			//this.Hide();
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
			//trace("key up " + txtID +  "   "+ event.keyCode);
		}
		
	}

}