package GUI 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import flash.events.*;
	import GUI.component.BaseGUI;
	import Logic.*;
	import Data.*;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIBuyDecorate extends BaseGUI
	{
		private const GUI_DECORATE_BTN_DECO_CLOSE:String = "ButtonDecorateClose";
		
		public function GUIBuyDecorate(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIBuyDecorate";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GUI_MessageBox");
			SetPos(250, 50);
			
			AddButton(GUI_DECORATE_BTN_DECO_CLOSE, "BtnThoat", 200, 10, this);
		}

		public function ShowBuyDeco(iLayer:int, name:String, price:int):void
		{
			//super.Show(iLayer);
			super.Show();
			AddLabel("Name: " + name, 10, 10);
			AddLabel("gold " + price, 10, 30);
		}

		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_DECORATE_BTN_DECO_CLOSE:
				Hide();
				GameLogic.getInstance().BackToIdleGameState();
				break;		
			}
		}
		
	}

}