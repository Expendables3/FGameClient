package Event.TreasureIsland 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUIMessageInEvent extends BaseGUI 
	{
		private const BTN_BUY_ITEM_BY_DIAMOND:String = "BuyItemByDiamond";
		private const BTN_BUY_ITEM_BY_G:String = "BuyItemByG";
		private const BTN_OK:String = "Ok";
		private const BTN_CLOSE:String = "Close";
		
		private var btnG:Button;
		private var btnDiamond:Button;
		private var txtMsg:TextField;
		private var Msg:String = "";
		private var callFuction:Function;
		private var id:int;
		private var titleId:int;
		public function GUIMessageInEvent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMessageInEvent";
		}
		
		override public function InitGUI():void
		{
			LoadRes("GUIMessageInEvent");
			SetPos(200, 120);
			if (titleId != 0)
			{
				LoadRes("GUIMessageInEvent");
				SetPos(200, 120);
				AddImage("", "TitleMsg" + titleId, 100, 17, true, ALIGN_LEFT_TOP);
			}
			else
			{
				LoadRes("GUILostGift");
				SetPos(150, 100);
			}
			txtMsg = AddLabel(Msg, 30, 70);
			txtMsg.setTextFormat(new TextFormat("arial", 13, 0xDD0000, null, null, null, null, null, "center"));
			txtMsg.wordWrap = true;
			txtMsg.width = 330;
		}
		
		public function ShowMessBuyItem(msg:String, itemId:int, callBackFuction:Function):void
		{
			Msg = msg;
			id = itemId;
			titleId = 1;
			super.Show(Constant.GUI_MIN_LAYER, 3);	
			//add Image chia khoa
			callFuction = callBackFuction;
			AddButton(BTN_CLOSE, "BtnThoat", 350, 17, this);
			btnG = AddButton(BTN_BUY_ITEM_BY_G, "Btn_Xu", 125, 225, this);
			btnDiamond = AddButton(BTN_BUY_ITEM_BY_DIAMOND, "Btn_Diamond", 215, 225, this);
			AddImage("", "ItemBg", 190, 150);
			var itemImg:Image = AddImage("", "IslandItem" + itemId, 215, 175);
			itemImg.SetScaleXY(1);
			var config:Object = ConfigJSON.getInstance().getItemInfo("Island_Item");
			if (itemId == 1)
			{
				AddLabel(config["1"]["ZMoney"], 95, 225, 0x008000, 1, 0xFFFFB3);
				AddLabel(config["1"]["Diamond"], 185, 225, 0x004080, 1, 0xFFFFB3);
			}
			else
			{
				AddLabel(config["2"]["ZMoney"], 95, 225, 0x008000, 1, 0xFFFFB3);
				AddLabel(config["2"]["Diamond"], 185, 225, 0x004080, 1, 0xFFFFB3);
			}
		}
		
		public function ShowMessTimeOut(msg:String, gift:Object):void
		{
			Msg = msg;
			titleId = 3;
			super.Show(Constant.GUI_MIN_LAYER, 3);	
			//add Image phan thuong an ui
			AddImage("", "ItemBg", 190, 150);
			var itemImg:Image = AddImage("", gift["ItemType"], 200, 150);
			itemImg.SetScaleXY(0.7);
			var txt:TextField = AddLabel("x" + Ultility.StandardNumber(gift["Num"]), 140, 160, 0xffff00, 1, 0xcc3300);
			AddButton(BTN_OK, "BtnReceive", 125, 232, this);
			if (gift["ItemType"] == "Exp")
				GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + gift["Num"]);
			//else
				//GameLogic.getInstance().user.UpdateUserMoney(gift["Num"]);
		}
		
		public function ShowMessLostGift(msg:String, gList:Array):void
		{
			titleId = 0;
			Msg = "";
			super.Show(Constant.GUI_MIN_LAYER, 3);
			//add Image quà bị mất
			var listG:ListBox = AddListBox(ListBox.LIST_X, 1, 3, 15);
			var arr:Array = [];
			for (var i:int = 0; i < gList.length; i++ )
			{
				if (!(gList[i] as Array)) arr.push(gList[i]);
			}
			var giftList:Array = groupGift(arr);
			equipArr = new Object();
			for (i = 0; i < giftList.length; i++ )
			{
				var container:Container = new Container(img, "ItemBg");
				var giftType:String = giftList[i]["ItemType"];
				var item:Image;
				var tip:TooltipFormat = new TooltipFormat();
				var idObj:String = "Normal_" + i;
				switch (giftType)
				{
					case "Exp":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						container.AddImage("", "IcExp", 35, 30);
						tip.text = "Kinh nghiệm";
						container.setTooltip(tip);
						break;
					case "Money":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						container.AddImage("", "IcGold", 35, 30);
						tip.text = "Tiền vàng";
						container.setTooltip(tip);
						break;
					case "Material":
					case "Matertial":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						container.AddImage("", "Material" + giftList[i]["ItemId"], 55, 50);
						tip.text = "Ngư thạch cấp " + giftList[i]["ItemId"];
						container.setTooltip(tip);
						break;
					case "Island_Item":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						item = container.AddImage("", "IslandItem" + giftList[i]["ItemId"], 60, 65);
						tip.text = Localization.getInstance().getString(giftType + giftList[i]["ItemId"]);
						container.setTooltip(tip);
						break;
					case "EnergyItem":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						item = container.AddImage("", giftType + giftList[i]["ItemId"], 35, 35);
						tip.text = Localization.getInstance().getString(giftType + giftList[i]["ItemId"]);
						container.setTooltip(tip);
						break;
					case "RankPointBottle":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						item = container.AddImage("", giftType + giftList[i]["ItemId"], 45, 40);
						tip.text = Localization.getInstance().getString(giftType + giftList[i]["ItemId"]);
						item.SetScaleXY(0.7);
						container.setTooltip(tip);
						break;
					case "HammerWhite":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						item = container.AddImage("", "GuiTrungLinhThach_Hammer_1", 45, 40);
						tip.text = "Búa Thường";
						item.SetScaleXY(0.9);
						container.setTooltip(tip);
						break;
					case "HammerGreen":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						item = container.AddImage("", "GuiTrungLinhThach_Hammer_2", 45, 40);
						tip.text = "Búa Đặc Biệt";
						item.SetScaleXY(0.9);
						container.setTooltip(tip);
						break;
					case "HammerYellow":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						item = container.AddImage("", "GuiTrungLinhThach_Hammer_3", 45, 40);
						tip.text = "Búa Quý";
						item.SetScaleXY(0.9);
						container.setTooltip(tip);
						break;
					case "HammerPurple":
						container.AddLabel("-" + Ultility.StandardNumber(giftList[i]["Num"]), -10, 50, 0xFF0000, 1, 0xFFFFFF);
						item = container.AddImage("", "GuiTrungLinhThach_Hammer_4", 45, 40);
						tip.text = "Búa Thần";
						item.SetScaleXY(0.9);
						container.setTooltip(tip);
						break;
					default:
						var equip:FishEquipment = new FishEquipment();
						equip.SetInfo(giftList[i]);
						equipArr[i] = equip;
						container.AddLabel("-1", -10, 50, 0xFF0000, 1, 0xFFFFFF);
						container.AddContainer("", FishEquipment.GetBackgroundName(equip.Color), 0, 0, true, this);
						var s:String = equip.Type + equip.Rank;
						item = container.AddImage("", s + "_Shop", 50, 45);
						item.SetScaleXY(0.7);
						idObj = "Special_" + i;
						break;
				}
				listG.addItem(idObj, container, this);
			}
			if (giftList.length == 1)	listG.setPos(250, 180);
			else if (giftList.length == 2)	listG.setPos(200, 180);
			else listG.setPos(160, 180);
			AddButton(BTN_OK, "Btn_OK", 250, 310, this);
		}
		private var equipArr:Object;
		private function groupGift(treasureList:Array):Array 
		{
			var temp:Array = [];
			temp.push(treasureList[0]);
			var i:int = 1;
			if (treasureList.length == i)	return temp;
			do
			{
				for (var j:int = 0; j < temp.length; j++ )
				{
					if ((treasureList[i].hasOwnProperty("ItemType") && treasureList[i]["ItemType"] == temp[j]["ItemType"]) || 
					(treasureList[i].hasOwnProperty("Type") && treasureList[i]["Type"] == temp[j]["Type"]))
					{
						if (treasureList[i]["ItemType"] == "Exp" || treasureList[i]["ItemType"] == "Money")
						{
							temp[j]["Num"] += treasureList[i]["Num"];
							i++;
							break;
						}
						if (treasureList[i].hasOwnProperty("ItemId"))
						{
							if (treasureList[i]["ItemId"] == temp[j]["ItemId"])
							{
								temp[j]["Num"] += treasureList[i]["Num"];
								i++;
								break;
							}
							else
							{
								if (j == temp.length - 1)	
								{
									temp.push(treasureList[i]);
									i++;
									break;
								}
							}
						}
						if (treasureList[i].hasOwnProperty("Type"))
						{
							temp.push(treasureList[i]);
							i++;
							break;
						}
					}
					else
					{
						if (j == temp.length - 1)	
						{
							temp.push(treasureList[i]);
							i++;
							break;
						}
					}
				}
			}
			while (i < treasureList.length)
			return temp;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_BUY_ITEM_BY_DIAMOND:
					if (id == 1)	callFuction("BuySilverKeyDiamond");
					else	callFuction("BuyGoldKeyDiamond");
					break;
				case BTN_BUY_ITEM_BY_G:
					if (id == 1)	callFuction("BuySilverKeyCoin");
					else	callFuction("BuyGoldKeyCoin");
					break;
				case BTN_OK:
				case BTN_CLOSE:
					Hide();
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
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var arr:Array = buttonID.split("_");
			if (arr[0] == "Special")
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equipArr[arr[1]], GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, 0);
			}
		}
	}

}