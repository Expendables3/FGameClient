package Event.TreasureIsland 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
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
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUIReceiveGiftChangeMedal extends BaseGUI 
	{
		private var gBox:ListBox;
		public const BTN_RECEIVE:String = "BtnReceive";
		private var type:int;
		public function GUIReceiveGiftChangeMedal(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReceiveGiftChangeMedal";
		}
		
		override public function InitGUI():void
		{
			SetPos(150, 150);
			LoadRes("GUIReceiveGiftChangeMedal_Theme");
			AddButton(BTN_RECEIVE, "BtnNhanThuong", 175, 285, this);
			gBox = AddListBox(ListBox.LIST_X, 1, 3);
			gBox.setPos(210, 140);
		}
		
		public function showGui(giftList:Array):void
		{
			super.Show(Constant.GUI_MIN_LAYER, 3);	
			gList = giftList;
			addGift();
		}
		private var gList:Array;
		private function addGift():void 
		{
			gBox.removeAllItem();
			type = 0;
			var item:Image;
			for (var i:int = 0; i < gList.length; i++)
			{
				if (gList[i] as Array) return;
				var tip:TooltipFormat = new TooltipFormat();
				var container:Container = new Container(img, "GUIReceiveGiftChangeMedal_ItemBg", 0, 0);
				var txtNum:TextField;
				var idObj:String;
				if (gList[i].hasOwnProperty("ItemType"))
				{
					var giftType:String = gList[i]["ItemType"];
					txtNum = container.AddLabel("x" + Ultility.StandardNumber(gList[i]["Num"]), -10, 55, 0xFFFF00, 1, 0x717100);
					switch (giftType)
					{
						case "Exp":
							container.AddImage("", "IcExp", 40, 30);
							tip.text = "Kinh nghiệm";
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + gList[i]["Num"]);
							idObj = "Normal_" + i;
							container.setTooltip(tip);
							break;
						case "Money":
							container.AddImage("", "IcGold", 40, 40);
							tip.text = "Tiền vàng";
							GameLogic.getInstance().user.UpdateUserMoney(gList[i]["Num"]);
							idObj = "Normal_" + i;
							container.setTooltip(tip);
							break;
						case "Material":
							container.AddImage("", "Material" + gList[i]["ItemId"], 60, 50);
							tip.text = "Ngư thạch cấp " + gList[i]["ItemId"];
							GuiMgr.getInstance().GuiStore.UpdateStore(giftType, gList[i]["ItemId"], gList[i]["Num"]);
							idObj = "Normal_" + i;
							container.setTooltip(tip);
							break;
						case "Island_Item":
							item = container.AddImage("", "IslandItem" + gList[i]["ItemId"], 70, 65);
							item.SetScaleXY(0.8);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							GuiMgr.getInstance().GuiStore.UpdateStore(giftType, gList[i]["ItemId"], gList[i]["Num"]);
							idObj = "Normal_" + i;
							container.setTooltip(tip);
							break;
						case "EnergyItem":
							item = container.AddImage("", giftType + gList[i]["ItemId"], 40, 30);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							GuiMgr.getInstance().GuiStore.UpdateStore(giftType, gList[i]["ItemId"], gList[i]["Num"]);
							idObj = "Normal_" + i;
							container.setTooltip(tip);
						case "RankPointBottle":
							item = container.AddImage("", giftType + gList[i]["ItemId"], 45, 40);
							item.SetScaleXY(0.7);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							GuiMgr.getInstance().GuiStore.UpdateStore(giftType, gList[i]["ItemId"], gList[i]["Num"]);
							idObj = "Normal_" + i;
							container.setTooltip(tip);
							break;
						case "Seal":
							equip = new FishEquipment();
							if (gList[i].hasOwnProperty("ItemId"))	gList[i]["Rank"] = gList[i]["ItemId"];
							gList[i]["Type"] = gList[i]["ItemType"]
							equip.SetInfo(gList[i]);
							container.AddContainer("", FishEquipment.GetBackgroundName(equip.Color), 0, 0, true, this);
							
							txtNum = container.AddLabel("x1", -10, 55, 0xFFFF00, 1, 0x717100);
							var s1:String = gList[i]["ItemType"] + gList[i]["Rank"];
							item = container.AddImage("", s1 + "_Shop", 30, 25);
							item.SetScaleXY(1.2);
							GuiMgr.getInstance().GuiStore.UpdateStore(gList[i]["ItemType"], gList[i]["Rank"]);
							
							GameLogic.getInstance().user.GenerateNextID();
							idObj = "Special_" + i;
							type = 2;
							break;
					}
				}
				else
				{
					equip = new FishEquipment();
					equip.SetInfo(gList[i]);
					container.AddContainer("", FishEquipment.GetBackgroundName(equip.Color), 0, 0, true, this);
					
					txtNum = container.AddLabel("x1", -10, 55, 0xFFFF00, 1, 0x717100);
					var s2:String = FishEquipment.GetEquipmentName(gList[i]["Type"], gList[i]["Rank"], gList[i]["Color"]);
					item = container.AddImage("", s2 + "_Shop", 40, 45);
					item.SetScaleXY(0.7);
					//GuiMgr.getInstance().GuiStore.UpdateStore(gList[i]["Type"], gList[i]["Rank"]);
					
					GameLogic.getInstance().user.GenerateNextID();
					idObj = "Special_" + i;
					if (gList[i]["Color"] == 5)
					{
						type = 100;
					}
					//type = 1;
					
				}
				gBox.addItem(idObj, container, this);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_RECEIVE:
					Hide();
					/*if (type <= 0) break;
					if (type == 1)
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_ISLAND_GET_COLLECTION);
					else
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_ISLAND_GET_MEDAL);*/
					switch(type)
					{
						case 0:
							//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_AUTUMN_MEDAL_2);
							break;
						case 1:
							//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_AUTUMN_MEDAL_1);
							break;
						case 2:
							//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_AUTUMN_MEDAL_3);
							break;
						case 100:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_HALLOWEEN_VIP4);
					}
					break;
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
		
		private var equip:FishEquipment;
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var arr:Array = buttonID.split("_");
			if (arr[0] == "Special")
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, 0);
			}
		}
	}

}