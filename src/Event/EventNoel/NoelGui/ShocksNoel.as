package Event.EventNoel.NoelGui 
{
	import Data.Localization;
	import Data.ResMgr;
	import Event.EventMgr;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import GUI.component.ActiveTooltip;
	import GUI.component.ButtonEx;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	
	/**
	 * Cái tất noel xuất hiện bên ngoài hồ
	 * @author HiepNM2
	 */
	public class ShocksNoel extends BaseObject 
	{
		public function ShocksNoel(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ShocksNoel";
		}
		override public function SetInfo(data:Object):void 
		{
			drawShocks();
		}
		private function drawShocks():void
		{
			ClearImage();
			LoadRes("KhungFriend");
			//var btn:SimpleButton = ResMgr.getInstance().GetRes("EventTeacher_ImgShocks") as SimpleButton;
			var btn:SimpleButton = ResMgr.getInstance().GetRes("BtnOnlineGift") as SimpleButton;
			btn.scaleX = btn.scaleY = 1.2;
			btn.name = "BtnShocks";
			img.addChild(btn);
			SetPos(450, 620);
			SetAlign(ALIGN_LEFT_BOTTOM);
		}
		override public function ClearImage():void 
		{
			if (img == null) return;
			var btn:SimpleButton = img.getChildByName("BtnShocks") as SimpleButton;
			if (btn)
			{
				img.removeChild(btn);
			}
			super.ClearImage();
		}
		override public function OnMouseClick(event:MouseEvent):void 
		{
			if (EventMgr.CheckEvent("KeepLogin") == EventMgr.CURRENT_IN_EVENT)
			{
				GuiMgr.getInstance().guiGiftOnline.Show(Constant.GUI_MIN_LAYER, 5);
			}
		}
		override public function OnMouseOver(event:MouseEvent):void 
		{
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("EventNoel_TipGiftBag");
			ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
			this.SetHighLight();
		}
		override public function OnMouseOut(event:MouseEvent):void 
		{
			this.SetHighLight( -1);
			ActiveTooltip.getInstance().clearToolTip();
		}
		
	}

}
























