package Event.TreasureIsland 
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
	public class GUIReceiveTreasure extends BaseGUI 
	{
		public const BTN_RECEIVE:String = "BtnReceive";
		public const BTN_NEXT:String = "BtnNext";
		public const BTN_BACK:String = "BtnBack";
		
		private var btnNext:Button;
		private var btnBack:Button;
		private var gBox:ListBox;
		private var giftList:Array;
		public function GUIReceiveTreasure(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReceiveTreasure";
		}
		
		override public function InitGUI():void
		{
			SetPos(40, 65);
			LoadRes("GUIReceiveTreasure");
			AddButton(BTN_RECEIVE, "BtnReceive", 305, 480, this);
			btnNext = AddButton(BTN_NEXT, "TreasureIsland_BtnNext", 652, 355, this);
			btnBack = AddButton(BTN_BACK, "TreasureIsland_BtnBack", 60, 355, this);
			gBox = AddListBox(ListBox.LIST_X, 2, 5);
			gBox.setPos(150, 280);
			addGift(giftList);
			btnBack.SetVisible(false);
			btnNext.SetVisible(false);
			if (giftList.length > 10)
			{
				btnNext.SetVisible(true);
				btnBack.SetVisible(true);
				btnBack.SetDisable();
				btnNext.SetEnable();
			}
		}
		
		private function addGift(gList:Array):void 
		{
			gBox.removeAllItem();
			equipArr = new Object();
			var item:Image;
			for (var i:int = 0; i < gList.length; i++)
			{
				if (gList[i] as Array) return;
				var tip:TooltipFormat = new TooltipFormat();
				var container:Container = new Container(img, "AutoDigItemBg", 0, 0);
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
							break;
						case "Money":
							container.AddImage("", "IcGold", 40, 30);
							tip.text = "Tiền vàng";
							break;
						case "Matertial":
						case "Material":
							container.AddImage("", "Material" + gList[i]["ItemId"], 60, 50);
							tip.text = "Ngư thạch cấp " + gList[i]["ItemId"];
							break;
						case "Island_Item":
							item = container.AddImage("", "IslandItem" + gList[i]["ItemId"], 60, 65);
							item.SetScaleXY(0.8);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							break;
						case "EnergyItem":
							item = container.AddImage("", giftType + gList[i]["ItemId"], 40, 30);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							break;
						case "RankPointBottle":
							item = container.AddImage("", giftType + gList[i]["ItemId"], 50, 40);
							item.SetScaleXY(0.7);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							break;
						case "HammerWhite":
							container.AddImage("", "GuiTrungLinhThach_Hammer_1", 35, 30);
							tip.text = "Búa thường";
							break;
						case "HammerGreen":
							container.AddImage("", "GuiTrungLinhThach_Hammer_2", 35, 30);
							tip.text = "Búa đặc biệt";
							break;
						case "HammerYellow":
							container.AddImage("", "GuiTrungLinhThach_Hammer_3", 35, 30);
							tip.text = "Búa quý";
							break;
						case "HammerPurple":
							container.AddImage("", "GuiTrungLinhThach_Hammer_4", 35, 30);
							tip.text = "Búa thần";
							break;
						case "VipTag":
							container.AddImage("", giftType + gList[i]["ItemId"], 35, 30);
							tip.text = "Bùa mở bảo rương VIP";
							break;
					}
					idObj = "Normal_" + i;
					container.setTooltip(tip);
				}
				else
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(gList[i]);
					equipArr[i] = equip;
					container.AddContainer("", FishEquipment.GetBackgroundName(equip.Color), 0, 0);
					
					txtNum = container.AddLabel("x1", -10, 55, 0xFFFF00, 1, 0x717100);
					var s:String = gList[i]["Type"] + gList[i]["Rank"];
					item = container.AddImage("", s + "_Shop", 43, 45);
					item.SetScaleXY(0.7);
					idObj = "Special_" + i;
				}
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
		public function showTreasure(gList:Array):void
		{
			giftList = gList;
			super.Show(Constant.GUI_MIN_LAYER, 3);	
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_NEXT:
					gBox.showNextPage();
					checkEnabelBtnNextBack();
					break;
				case BTN_BACK:
					gBox.showPrePage();
					checkEnabelBtnNextBack();
					break;
				case BTN_RECEIVE:
					var showFeed:Boolean = false;
					for (var i:int = 0; i < giftList.length; i++ )
					{
						if (giftList[i] as Array)	break;
						if (giftList[i].hasOwnProperty("ItemType"))
						{
							switch (giftList[i]["ItemType"])
							{
								case "Money":
									GameLogic.getInstance().user.UpdateUserMoney(giftList[i]["Num"]);
									break;
								case "Exp":
									GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + giftList[i]["Num"]);
									break;
								case "Island_Item":
									//trace("itemId = 2 thì add vào chìa khóa vàng, từ 5->9 thì cho vào bộ sưu tập");
									GuiMgr.getInstance().GuiStore.UpdateStore(giftList[i]["ItemType"], giftList[i]["ItemId"], giftList[i]["Num"]);
									if (giftList[i]["ItemId"] ==  14) GuiMgr.getInstance().guiChangeMedalVIP.medalNum += giftList[i]["Num"];
									break;
								case "Matertial":
									GuiMgr.getInstance().GuiStore.UpdateStore("Material", giftList[i]["ItemId"], giftList[i]["Num"]);
									break;
								case "RankPointBottle":
									GuiMgr.getInstance().GuiStore.UpdateStore(giftList[i]["ItemType"], giftList[i]["ItemId"], giftList[i]["Num"]);
									break;
							}
						}
						else
						{
							var type:String = giftList[i]["Type"];
							if (type == "Helmet" || type == "Armor" || type == "Weapon" || type == "Belt" || type == "Bracelet" || type == "Necklace" || type == "Ring")
							{
								GuiMgr.getInstance().GuiStore.UpdateStore(giftList[i]["Type"], giftList[i]["Rank"]);
								showFeed = true;
							}
						}
					}
					if (showFeed)	GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_ISLAND_EXIT);
					Hide();
					break;
			}
		}
		
		private function checkEnabelBtnNextBack():void
		{
			btnNext.SetEnable();
			btnBack.SetEnable();
			if(gBox.curPage >= gBox.getNumPage()-1)
			{
				btnNext.SetDisable();
			}
			else if(gBox.curPage <= 0)
			{				
				btnBack.SetDisable();
			}			
		}
	}

}