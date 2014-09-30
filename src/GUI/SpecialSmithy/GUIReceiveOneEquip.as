package GUI.SpecialSmithy 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
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
	public class GUIReceiveOneEquip extends BaseGUI 
	{
		public const BTN_RECEIVE:String = "BtnReceive";
		
		private var gBox:ListBox;
		private var giftList:Array;
		public function GUIReceiveOneEquip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReceiveOneEquip";
		}
		
		override public function InitGUI():void
		{
			SetPos(200, 150);
			LoadRes("GUIReceiveOneEquip");
			AddButton(BTN_RECEIVE, "BtnReceive", 120, 215, this);
			gBox = AddListBox(ListBox.LIST_X, 1, 1);
			gBox.setPos(150, 82);
			addGift(giftList);
		}
		
		private function addGift(gList:Array):void 
		{
			gBox.removeAllItem();
			equipArr = new Object();
			var item:Image;
			for (var i:int = 0; i < gList.length; i++)
			{
				if (gList[i] as Array) return;
				var container:Container = new Container(img, "CtnEquipment", 0, 0);
				var e:FishEquipment = new FishEquipment();
				e.SetInfo(gList[i]);
				equipArr[i] = e;
				container.AddContainer("", FishEquipment.GetBackgroundName(gList[i].Color), 0, 0);
				
				var s:String = gList[i]["Type"] + gList[i]["Rank"];
				item = container.AddImage("", s + "_Shop", 43, 45);
				item.SetScaleXY(0.7);
				var idObj:String = "Special_" + i;
				gBox.addItem(idObj, container, this);
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (buttonID.split("_")[0] == "Special")
			{
				if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
				{
					GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				}
			}
		}
		
		private var equipArr:Object;
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var arr:Array = buttonID.split("_");
			if (arr[0] == "Special")
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equipArr[arr[1]], GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, 0);
			}
		}
		public function showGift(gList:Array):void
		{
			giftList = gList;
			super.Show(Constant.GUI_MIN_LAYER, 3);	
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_RECEIVE:
					Hide();
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SPECIAL_SMITHY_GIFT);
					break;
			}
		}
	}

}