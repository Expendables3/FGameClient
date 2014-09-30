package GUI.EventMagicPotions.GUIQuestHerbDone 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	
	/**
	 * GUI nhận thưởng nhiệm vụ thảo dược
	 * @author longpt
	 */
	public class GUIQuestHerbDone extends BaseGUI 
	{
		private static const BTN_GET_GIFT:String = "BtnGetGift";
		private var HerbId:int;
		
		public function GUIQuestHerbDone(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIQuestHerbDone";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(225, 140);
				
				OpenRoomOut();
			}
			LoadRes("GuiQuestHerbDone_Theme");
		}
		
		public function Init(id:int):void
		{
			HerbId = id;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		public override function EndingRoomOut():void
		{
			RefreshComponent();
		}
		
		public function RefreshComponent():void
		{
			var ctn:Container = AddContainer("", "GuiQuestHerbDone_Ctn", 166, 153);
			ctn.AddImage("", "Herb" + HerbId, 0, 0).FitRect(50, 50, new Point(5, 5));
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = Localization.getInstance().getString("Herb" + HerbId);
			ctn.setTooltip(tt);
			AddButton(BTN_GET_GIFT, "BtnNhanThuong", 126, 260);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_GET_GIFT:
					// Nhận thưởng
					this.Hide();
					break;
			}
		}
	}

}