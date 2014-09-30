package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.Balloon;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIFinalKillBoss extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_NEXT:String = "BtnNext";
		public const BTN_PRE:String = "BtnBack";
		public const BTN_ACCEPT_GIFT:String = "BtnAcceptGift";
		
		public const IMG_GIFT:String = "ImgGift";
		public const ELEMENT_GIFT:String = "ElementGift_";
		
		public const MAX_FISHTYPE:int = 79;
		
		public var ListGift:ListBox;
		
		public var nameGift:String;
		public var domainNameGift:String;
		public var numGift:int;
		public var isRare:Boolean = false;
		
		public var isGiftMore:Boolean = false;
		
		public var arrNumGift:Array = [];
		public var arrObjGift:Array = [];
		public var arrNameGift:Array = [];
		public var arrToolTipGift:Array = [];
		
		public function GUIFinalKillBoss(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIFinalKillBoss";
		}
		
		public function InitGui(objAllGift:Object):void 
		{
			arrNameGift = new Array();
			arrObjGift = new Array();
			arrToolTipGift = new Array();
			arrNumGift = new Array();
			var istr:String;
			var jstr:String;
			var kstr:String;
			for (istr in objAllGift) 	// Các mức phần trăm 5, 10, 15, 20 ...
			{
				if(objAllGift[istr])
				{
					var item:Object = new Object();
					var strName:String = "";
					var strToolTip:String = "";
					var numGift:int = 0;
					var index:int = -1;
					var isGroup:Boolean = true;
					
					for (jstr in objAllGift[istr]) 
					{
						if(jstr != "Normal")
						{
							for (kstr in objAllGift[istr][jstr]) 
							{
								item = objAllGift[istr][jstr][kstr];
								numGift = item.Num;
								switch (jstr) 
								{
									case "Material":
										strName = item.ItemType + item.ItemId;
										if (item.ItemId >= 100)
										{
											strName = item.ItemType + (item.ItemId % 100) + "S";
										}
										strToolTip = Localization.getInstance().getString(item.ItemType + item.ItemId);
										break;
									case "Collection":
										strName = item.ItemType + item.ItemId;
										strToolTip = Localization.getInstance().getString("Tip" + strName);
										break;
									case "ItemList":
										strName = item.Type + item.Rank + "_Shop";
										strToolTip = Localization.getInstance().getString(String(item.Type + item.Rank));
										numGift = 1;
										isGroup = false;
										break;
									case "Mask":
										strName = item.ItemType + item.Rank + "_Shop";
										strToolTip = Localization.getInstance().getString(String(item.ItemType + item.Rank));
										break;
									case "GemList":
										strName = item.ItemType + "_" + item.Element + "_" + item.ItemId;
										strToolTip = Localization.getInstance().getString(String(item.ItemType + item.Element));
										strToolTip = strToolTip.replace("@Type@", Localization.getInstance().getString("GemType" + item.Element));
										strToolTip = strToolTip.replace("@Rank@", "cấp " + item.ItemId);
										var config:Object = ConfigJSON.getInstance().GetItemList("Gem");
										var value:int = config[String(item.ItemId)][String(item.Element)];
										strToolTip = strToolTip.replace("@value@", String(value));
										strToolTip = strToolTip.replace("@day@", String(item.Day));
										break;
									case "MixFormula":
										strName = item.ItemType + "_" + item.ItemId;
										strToolTip = Localization.getInstance().getString(item.ItemType);
										break;
									case "Event":
										//strName = "GUIGameEventMidle8_" + item.ItemType + item.ItemId;	//PearFlower
										//strToolTip = Localization.getInstance().getString(item.ItemType + item.ItemId);
										
										//strName = "EventNoel_" + item.ItemType + item.ItemId;	//Fish Hunter
										//strToolTip = Localization.getInstance().getString(strName);
										
										//strName = "EventLuckyMachine_Ticket1";	//Event máy quay sò
										//strToolTip = "Vỏ Sò May Mắn\nDùng trong Máy Quay Sò";
										
										//strName = "IslandItem15";		//TreasureIsland
										//strToolTip = "Xẻng đào vàng";
										
										strName = "GuiHalloween_HalItem" + item.ItemId;		//Thạch bảo đồ
										strToolTip = Localization.getInstance().getString("EventHalloween_TipHalItem" + item.ItemId);
										break;
									//case "EventEuro":
										//strName = "Ic_" + item.ItemId + "Ball";
										//if(item.ItemId == "ORD")
										//{
											//strToolTip = "Bóng thường Euro";
										//}
										//else
										//{
											//strToolTip = "Bóng vàng Euro";
										//}
										//break;
								}
								if(isGroup)
								{
									index = arrNameGift.indexOf(strName);
									if (index < 0)
									{
										arrNameGift.push(strName);
										arrObjGift.push(item);
										arrToolTipGift.push(strToolTip);
										arrNumGift.push(numGift);
									}
									else 
									{
										arrNumGift[index] += numGift;
									}
								}
								else
								{
									arrNameGift.push(strName);
									arrObjGift.push(item);
									arrToolTipGift.push(strToolTip);
									arrNumGift.push(numGift);
								}
							}
						}
						else
						{
							if(FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)	
							{
								for (kstr in objAllGift[istr][jstr]) 
								{
									item = objAllGift[istr][jstr][kstr];
									numGift = item.Num;
									switch (item.ItemType) 
									{
										case "Exp":
											strName = "IcExp";
											strToolTip = "Kinh nghiệm";
											break;
										case "Money":
											strName = "IcGold";
											strToolTip = "Tiền Vàng";
											break;
									}
									index = arrNameGift.indexOf(strName);
									if (index < 0)
									{
										arrNameGift.push(strName);
										arrObjGift.push(item);
										arrToolTipGift.push(strToolTip);
										arrNumGift.push(numGift);
									}
									else 
									{
										arrNumGift[index] += numGift;
									}
								}
							}
						}
					}
				}
			}
		}
		 
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_ACCEPT_GIFT)	return;
			var index:int = buttonID.split("_")[1];
			var strName:String = arrNameGift[index];
			
			var item:Object = arrObjGift[index];
			if (item.Type && item.Rank && ((item.Type + item.Rank + "_Shop") == strName))
			{
				var equip:FishEquipment = new FishEquipment();
				equip.SetInfo(item);
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			var index:int = buttonID.split("_")[1];
			var strName:String = arrNameGift[index];
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		
		private function UpdateStateBtnNextBack():void 
		{
			var curPage:int = ListGift.curPage + 1;
			var totalPage:int = ListGift.getNumPage();
			if (totalPage <= 1)
			{
				GetButton(BTN_NEXT).SetVisible(false);
				GetButton(BTN_PRE).SetVisible(false);
			}
			else if (curPage == 1) 
			{
				GetButton(BTN_NEXT).SetVisible(true);
				GetButton(BTN_PRE).SetVisible(true);
				GetButton(BTN_NEXT).SetEnable();
				GetButton(BTN_PRE).SetEnable(false);
			}
			else if (curPage == totalPage) 
			{
				GetButton(BTN_NEXT).SetVisible(true);
				GetButton(BTN_PRE).SetVisible(true);
				GetButton(BTN_NEXT).SetEnable(false);
				GetButton(BTN_PRE).SetEnable(true);
			}
			else 
			{
				GetButton(BTN_NEXT).SetVisible(true);
				GetButton(BTN_PRE).SetVisible(true);
				GetButton(BTN_NEXT).SetEnable();
				GetButton(BTN_PRE).SetEnable();
			}
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos((Constant.STAGE_WIDTH - img.width) / 2, (Constant.STAGE_HEIGHT - img.height) / 2);
				
				var txtFm:TextFormat = new TextFormat();
				var str:String = "Bạn đã đánh thắng @Boss!\nBạn nhận được các quà tặng sau!";
				str = str.replace("@Boss", FishWorldController.GetNameBoss());
				var lbToolTip:TextField = AddLabel(str, 222, 123, 0xFFFF00, 0);
				txtFm.color = 0xD80506;
				txtFm.bold = true;
				txtFm.size = 18;
				lbToolTip.setTextFormat(txtFm);
				
				var strLb:String = "Phần thưởng sau khi đánh thắng @Boss";
				strLb = strLb.replace("@Boss", FishWorldController.GetNameBoss());
				var lbComment:TextField = AddLabel(strLb, 163, 308, 0xFFFF00, 0);
				txtFm = new TextFormat();
				txtFm.color = 0x1F4B69;
				txtFm.bold = true;
				txtFm.size = 18;
				lbComment.setTextFormat(txtFm);
				
				var ic:Image = AddImage("ImgBoss", "GuiFinalKillBoss_ImgBoss" + FishWorldController.GetSeaId(), 220, 80,true, Image.ALIGN_LEFT_BOTTOM);
				
				if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)
				{
					ic.FitRect(62, 62, new Point(215, 20));
				}
				
				AddAllButton();
				
				ListGift = AddListBox(ListBox.LIST_X, 2, 6, 20, 20, true);
				ListGift.setPos(85, 340);
				InitListGift();
				
				UpdateStateBtnNextBack();
				
				OpenRoomOut();
			}
			LoadRes("GuiFinalKillBoss_Theme");
		}
		
		public function AddAllButton(isHaveNextBack:Boolean = true):void 
		{
			AddButton(BTN_ACCEPT_GIFT, "BtnFeed", img.width / 2 - 50, img.height - 50, this);
			AddButton(BTN_PRE, "GuiFinalKillBoss_Btn_Next", 60, 420, this).SetVisible(isHaveNextBack);
			AddButton(BTN_NEXT, "GuiFinalKillBoss_Btn_Pre", 665, 420, this).SetVisible(isHaveNextBack);
		}
		
		public function InitListGift():void 
		{
			for (var i:int = 0; i < arrNameGift.length; i++) 
			{
				var container:Container = new Container(ListGift, "GuiFinalKillBoss_CtnSlot");
				var strName:String = arrNameGift[i];
				var imageContent:Image;
				imageContent = container.AddImage("ImgContent", strName, 0, 0, true, ALIGN_CENTER_CENTER, false);
				if (strName.search("EventIceCream_Item") >= 0)
				{
					(imageContent.img as MovieClip).gotoAndStop(1);
				}
				
				imageContent.FitRect(50, 50, new Point(10, 0));
				var txtFormat:TextFormat = new TextFormat();
				txtFormat.bold = true;
				txtFormat.color = 0xFFFF00;
				txtFormat.size = 16;
				var txtBox:TextField = container.AddLabel("x" + Ultility.StandardNumber(arrNumGift[i]), -15, 54, 0xFFFF00, 1, 0x26709C);
				txtBox.setTextFormat(txtFormat);
				
				var tt:TooltipFormat = new TooltipFormat();
				tt.text = arrToolTipGift[i];
				container.setTooltip(tt);
				
				ListGift.addItem(ELEMENT_GIFT + i.toString(), container, this)
			}
		} 
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_NEXT:
					ListGift.showNextPage();
					UpdateStateBtnNextBack();
				break;
				case BTN_PRE:
					ListGift.showPrePage();
					UpdateStateBtnNextBack();
				break;
				case BTN_ACCEPT_GIFT:
					GetButton(BTN_ACCEPT_GIFT).SetDisable();
					Feed();
				break;
			}
		}
		public function Feed():void 
		{
			switch (FishWorldController.GetSeaId()) 
			{
				case Constant.OCEAN_NEUTRALITY:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HOANG_SO, "Tua Rua");
				break;
				case Constant.OCEAN_METAL:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HOANG_KIM, "Hoàng Kim");
				break;
				case Constant.OCEAN_ICE:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HAN_THUY, "Băng Giá");
				break;
				case Constant.OCEAN_FOREST:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HAN_THUY, "Hắc Lâm");
				break;
			}
			
			arrNameGift = [];
			arrNumGift = [];
			arrToolTipGift = [];
			GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
		}
	}

}