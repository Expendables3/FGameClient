package GUI.MixMaterial 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUIReceiveMaterial extends BaseGUI 
	{
		public const BTN_RECEIVE:String = "BtnReceive";
		
		private var gift:Object;
		public function GUIReceiveMaterial(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReceiveMaterial";
		}
		
		override public function InitGUI():void
		{
			SetPos(200, 150);
			LoadRes("GUIReceiveMaterial");
			AddButton(BTN_RECEIVE, "BtnReceive", 150, 230, this);
			addGift(gift);
		}
		
		private function addGift(gift:Object):void 
		{
			var ctn:Container = AddContainer("", "ItemBg", 150, 100);
			ctn.AddImage("", "Material" + gift["TypeId"], 35, 30, true, ALIGN_LEFT_TOP);
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Material", gift["TypeId"]);
			ctn.AddLabel(Ultility.StandardNumber(gift["Num"]), -15, 45, 0xffffff, 1, 0x26709C);
			ctn.SetScaleXY(1.2);
			var txtFormat:TextFormat = new TextFormat()
			txtFormat.bold = true;
			txtFormat.color = 0xF37621;
			var toolTip:TooltipFormat = new TooltipFormat();
			toolTip.text = obj["Name"];
			if(obj["Name"].length > 0)
				toolTip.setTextFormat(txtFormat, 0, obj["Name"].length);
			ctn.setTooltip(toolTip);
		}
		
		public function showGift(g:Object):void
		{
			gift = g;
			super.Show(Constant.GUI_MIN_LAYER, 3);	
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_RECEIVE:
					Hide();
					break;
			}
		}
	}

}