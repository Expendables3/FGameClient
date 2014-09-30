package GUI 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import GUI.component.Button;
	
	import GUI.component.BaseGUI;
	import Logic.*;
	import GameControl.*;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIDecorateInfo extends BaseGUI
	{
		private const GUI_DECOINFO_BTN_ZOOMIN:String = "0";
		private const GUI_DECOINFO_BTN_ZOOMOUT:String = "1";
		private const GUI_DECOINFO_BTN_STORE:String = "2";
		private const GUI_DECOINFO_BTN_SELL:String = "3";
		private const GUI_DECOINFO_BTN_PAN:String = "4";
		
		public var CurObject:Decorate = null;
		public var OldScale:Number;
		
		private var btnZoomIn:Button;
		private var btnZoomOut:Button;
		private var btnStore:Button;
		private var btnSell:Button;
		
		public function GUIDecorateInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIDecorateInfo";
			
		}
		
		public override function InitGUI() :void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			LoadRes("");
			// add 1 dong button o day
			btnZoomIn = AddButton(GUI_DECOINFO_BTN_ZOOMIN, "BtnZoomIn", -20, 30, this);
			btnZoomIn.img.scaleX = 1.2;
			btnZoomIn.img.scaleY = 1.2;
			
			btnZoomOut = AddButton(GUI_DECOINFO_BTN_ZOOMOUT, "BtnZoomOut", 90, 60, this);
			btnZoomOut.img.scaleX = 1.2;
			btnZoomOut.img.scaleY = 1.2;
			
			//btnStore = AddButton(GUI_DECOINFO_BTN_STORE, "ButtonStoreDeco", 20, 10, this);
			//btnStore.img.scaleX = 0.8;
			//btnStore.img.scaleY = 0.8;
			//btnSell = AddButton(GUI_DECOINFO_BTN_SELL, "ButtonSellDeco", 70, 10, this);
			//btnSell.img.scaleX = 0.8;
			//btnSell.img.scaleY = 0.8;
			
			SetPos(100, 10);
			//this.SetAlign(ALIGN_CENTER_BOTTOM);
			
			if (CurObject != null)
			{
				OldScale = CurObject.Scale;
			}
			
			//ChangeButtonPos();
		}
		
		public function ShowDecoInfo(deco:Decorate):void
		{
			var pt:Point = new Point();
			var rec:Rectangle = deco.img.getBounds(deco.img.parent);
			var w:int = rec.width;
			var h:int = rec.height;
			pt.x = rec.left;
			pt.y = rec.top;
			pt = Ultility.PosLakeToScreen(pt.x, pt.y);
			
			//super.Show(Constant.GUI_MIN_LAYER + 1);
			super.Show();
			SetPos(pt.x, pt.y);
			
			// doi cho cac button
			btnZoomIn.img.x = w;
			btnZoomIn.img.y = -10;
			
			btnZoomOut.img.x = w;
			btnZoomOut.img.y = 20;
			
			//btnSell.img.x = w - btnSell.img.width;
			//btnSell.img.y = h;
			//
			//btnStore.img.x = btnSell.img.x - btnStore.img.width - 5;
			//btnStore.img.y = h;
		}
		
		private function ChangeButtonPos():void
		{
			if (CurObject != null)
			{
				var w:int = CurObject.img.width;
				var h:int = CurObject.img.height;
				btnZoomIn.img.x = w + 50;
				btnZoomOut.img.x = w + 50;
				
				btnSell.img.x = w;
				btnStore.img.x = w - 50;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_DECOINFO_BTN_PAN:
				GameController.getInstance().ActiveObj = CurObject;
				GameController.getInstance().StartMoveDecorate();
				break;
				
				case GUI_DECOINFO_BTN_ZOOMIN:
				CurObject.Zoom(0.2);
				break;
				
				case GUI_DECOINFO_BTN_ZOOMOUT:
				CurObject.Zoom( -0.2);
				break;
				
				case GUI_DECOINFO_BTN_SELL:
				Hide();
				GameLogic.getInstance().Sell(CurObject);
				//GameLogic.getInstance().BackToIdleGameState();
				break;
				
				case GUI_DECOINFO_BTN_STORE:
				GameLogic.getInstance().StoreDecorate(CurObject);
				Hide();
				break;
			}
		}
		
		public function HasChanged():Boolean
		{
			if (CurObject != null)
			{
				if (CurObject.Scale != OldScale)
				{
					return true;
				}
			}
			
			return false;
		}
		
	}

}