package GUI.EventMagicPotions.GUIGetGiftUseHerb 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * GUI Show toàn bộ phần thưởng khi sử dụng herb SLL
	 * @author longpt
	 */
	public class GUIGetGiftUseHerb extends BaseGUI 
	{
		private const BTN_NEXT:String = "BtnNext";
		private const BTN_BACK:String = "BtnBack";
		private const BTN_GET:String = "BtnGet";
		
		private var giftObj:Object;
		private var giftListOriginal:Array;
		private var listGift:ListBox;
		
		private var btnNext:Button;
		private var btnBack:Button;
		
		private var listGiftName:Array = ["HerbMedal", "Equip", "EnergyItem", "RankPointBottle", "Material", "Exp", "Rank", "Money"];
		
		public function GUIGetGiftUseHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGetGiftUseHerb";
		}
		
		public override function InitGUI():void
		{
			LoadRes("GuiGetGiftUseHerb_Theme");
			SetPos(120, 70);
			RefreshContent();
			UpdateBtnNextBack();
		}
		
		public function InitAll(giftList:Array, isUpdateStore:Boolean = false):void
		{
			giftListOriginal = giftList;
			RemixGift(giftList);
			
			if (isUpdateStore)
			{
				ProcessUpdateStore();
			}
			
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		public function RefreshContent():void
		{
			ClearComponent();
			// Buttons
			btnNext = AddButton(BTN_NEXT, "GuiSelectNumberHerb_Btn_Pre", 495, 257);
			btnBack = AddButton(BTN_BACK, "GuiSelectNumberHerb_Btn_Next", 50, 257);
			AddButton(BTN_GET, "BtnNhanThuong", 220, 430);
			
			// Gifts
			listGift = AddListBox(ListBox.LIST_X, 2, 5, 10, 10, false);
			listGift.setPos(76, 190);
			var i:int;
			for (i = 0; i < listGiftName.length; i++)
			{
				var gift:Object = giftObj[listGiftName];
				var ctn:Container;
				var tF:TextField;
				var txtF:TextFormat = new TextFormat();
				txtF.size = 15;
				txtF.align = "center";
				
				var tt:TooltipFormat;
				
				var s:String;
				switch (listGiftName[i])
				{
					case "Rank":
						if (giftObj[listGiftName[i]])
						{
							ctn = new Container(listGift.img, "GuiTooltipHerb_Ctn", 0, 0);
							ctn.AddImage("", "IcRank", 30, 25).SetScaleXY(1.3);
							tF = ctn.AddLabel(Ultility.StandardNumber(giftObj[listGiftName[i]]), -12, 58, 0xffffff, 0, 0x000000);
							tF.autoSize = "center";
							tF.defaultTextFormat = txtF;
							
							tt = new TooltipFormat();
							tt.text = "Điểm chiến công";
							ctn.setTooltip(tt);
							
							listGift.addItem("", ctn, this);
							
						}
						break;
					case "Money":
						if (giftObj[listGiftName[i]])
						{
							ctn = new Container(listGift.img, "GuiTooltipHerb_Ctn", 0, 0);
							ctn.AddImage("", "GiftCoin100", 0, 0).FitRect(70, 70, new Point(0, 0));
							tF = ctn.AddLabel(Ultility.StandardNumber(giftObj[listGiftName[i]]), -12, 58, 0xffffff, 0, 0x000000);
							tF.autoSize = "center";
							tF.defaultTextFormat = txtF;
							
							tt = new TooltipFormat();
							tt.text = "Tiền vàng";
							ctn.setTooltip(tt);
							
							listGift.addItem("", ctn, this);
						}
						break;
					case "Exp":
						ctn = new Container(listGift.img, "GuiTooltipHerb_Ctn", 0, 0);
						ctn.AddImage("", "IcExp", ctn.img.width / 2 - 10, ctn.img.height / 2 - 20).SetScaleXY(1.7);
						tF = ctn.AddLabel(Ultility.StandardNumber(giftObj[listGiftName[i]]), -12, 58, 0xffffff, 0, 0x000000);
						tF.autoSize = "center";
						tF.defaultTextFormat = txtF;
						
						tt = new TooltipFormat();
						tt.text = "Kinh nghiệm";
						ctn.setTooltip(tt);
						
						listGift.addItem("", ctn, this);
						break;
					case "EnergyItem":
						for (s in giftObj[listGiftName[i]])
						{
							ctn = new Container(listGift.img, "GuiTooltipHerb_Ctn", 0, 0);
							ctn.AddImage("", listGiftName[i] + s, ctn.img.width / 2 - 7, ctn.img.height / 2 - 13).SetScaleXY(1.4);
							tF = ctn.AddLabel(Ultility.StandardNumber(giftObj[listGiftName[i]][s]), -12, 58, 0xffffff, 0, 0x000000);
							tF.autoSize = "center";
							tF.defaultTextFormat = txtF;
							
							tt = new TooltipFormat();
							tt.text = Localization.getInstance().getString(listGiftName[i] + s);
							ctn.setTooltip(tt);
							
							listGift.addItem("", ctn, this);
						}
						break;
					case "Material":
						for (s in giftObj[listGiftName[i]])
						{
							ctn = new Container(listGift.img, "GuiTooltipHerb_Ctn", 0, 0);
							ctn.AddImage("", listGiftName[i] + s, ctn.img.width - 14, ctn.img.height / 2 + 20).SetScaleXY(1.3);
							tF = ctn.AddLabel(Ultility.StandardNumber(giftObj[listGiftName[i]][s]), -12, 58, 0xffffff, 0, 0x000000);
							tF.autoSize = "center";
							tF.defaultTextFormat = txtF;
							
							tt = new TooltipFormat();
							tt.text = Localization.getInstance().getString(listGiftName[i] + s);
							ctn.setTooltip(tt);
							
							listGift.addItem("", ctn, this);
						}
						break;
					case "RankPointBottle":
					case "HerbMedal":
						for (s in giftObj[listGiftName[i]])
						{
							ctn = new Container(listGift.img, "GuiTooltipHerb_Ctn", 0, 0);
							ctn.AddImage("", listGiftName[i] + s, ctn.img.width - 20, ctn.img.height / 2 + 10).FitRect(70, 70, new Point(3, 3));
							tF = ctn.AddLabel(Ultility.StandardNumber(giftObj[listGiftName[i]][s]), -12, 58, 0xffffff, 0, 0x000000);
							tF.autoSize = "center";
							tF.defaultTextFormat = txtF;
							
							tt = new TooltipFormat();
							tt.text = Localization.getInstance().getString(listGiftName[i] + s);
							ctn.setTooltip(tt);
							
							listGift.addItem("", ctn, this);
						}
						break;
					case "Equip":
						if (giftObj[listGiftName[i]])
						for (var j:int = 0; j < giftObj[listGiftName[i]].length; j++)
						{
							var giftt:Object = giftObj[listGiftName[i]][j];
							switch (giftt.Color)
							{
								case FishEquipment.FISH_EQUIP_COLOR_GREEN:
									ctn = new Container(listGift.img, "CtnEquipmentSpecial", 0, 0);
									ctn.SetScaleXY(1.05);
									break;
								case FishEquipment.FISH_EQUIP_COLOR_PINK:
									ctn = new Container(listGift.img, "CtnEquipmentDivine", 0, 0);
									ctn.SetScaleXY(1.05);
									break;
								default:
									ctn = new Container(listGift.img, "GuiTooltipHerb_Ctn", 0, 0);
									break;
							}
							
							ctn.AddImage("", giftt.Type + giftt.Rank + "_Shop", 0, 0, true,ALIGN_CENTER_BOTTOM, false, function():void {this.FitRect(60, 60, new Point (7, 7))});
							
							listGift.addItem("Ctn_" + j, ctn, this);
						}
						break;
				}
			}
		}
		
		private function UpdateBtnNextBack():void
		{
			if (listGift.numItem > (listGift.ColShow * listGift.RowShow))
			{
				btnNext.SetEnable();
				btnBack.SetEnable();
				if (listGift.curPage == 0)
				{
					btnBack.SetDisable();
				}
				else if (listGift.curPage == (listGift.getNumPage() - 1))
				{
					btnNext.SetDisable();
				}
			}
			else
			{
				btnNext.SetDisable();
				btnBack.SetDisable();
			}
		}
		
		private function RemixGift(a:Array):void
		{
			var o:Object = new Object();
			for (var i:int = 0; i < a.length; i++)
			{
				var gift:Object = a[i];
				switch (gift.ItemType)
				{
					case "Rank":
					case "Money":
					case "Exp":
						if (!o[gift.ItemType])
						{
							o[gift.ItemType] = gift.Num;
						}
						else
						{
							o[gift.ItemType] += gift.Num;
						}
						break;
					case "Material":
					case "EnergyItem":
					case "RankPointBottle":
					case "HerbMedal":
						if (gift.Num <= 0)
						{
							break;
						}
						if (!o[gift.ItemType])
						{
							o[gift.ItemType] = new Object();
						}
						if (!o[gift.ItemType][gift.ItemId])
						{
							o[gift.ItemType][gift.ItemId] = gift.Num;
						}
						else
						{
							o[gift.ItemType][gift.ItemId] += gift.Num;
						}
						break;
					default:
						if (!o["Equip"])
						{
							o["Equip"] = new Array();
						}
						o["Equip"].push(gift);
						break;
				}
			}
			
			giftObj = o;
		}
		
		private function ProcessUpdateStore():void
		{
			var i:int;
			var numGold:int = 0;
			for (i = 0; i < giftListOriginal.length; i++)
			{
				switch (giftListOriginal[i].ItemType)
				{
					case "Rank":
						break;
					case "Money":
						//GameLogic.getInstance().user.UpdateUserMoney(giftListOriginal[i].Num);
						numGold += giftListOriginal[i].Num;
						break;
					case "Exp":
						GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + giftListOriginal[i].Num);
						break;
					case "Material":
					case "EnergyItem":
					case "RankPointBottle":
					case "HerbMedal":
						GuiMgr.getInstance().GuiStore.UpdateStore(giftListOriginal[i].ItemType, giftListOriginal[i].ItemId, giftListOriginal[i].Num);
						break;
					default:
						GameLogic.getInstance().user.GenerateNextID();
						break;
				}
			}
			
			if (numGold > 0)
			{
				GameLogic.getInstance().user.UpdateUserMoney(numGold);
			}
		}
		
		private function CheckFeed():Boolean
		{
			var isFeed:Boolean = false;
			
			if (giftObj["Equip"] == null)
			{
				return isFeed;
			}

			for (var j:int = 0; j < giftObj["Equip"].length; j++)
			{
				var giftt:Object = giftObj["Equip"][j];
				if (giftt.Color == FishEquipment.FISH_EQUIP_COLOR_PINK)
				{
					isFeed = true;
					break;
				}
			}
			return isFeed;
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_NEXT:
					listGift.showNextPage();
					UpdateBtnNextBack();
					break;
				case BTN_BACK:
					listGift.showPrePage();
					UpdateBtnNextBack();
					break;
				case BTN_GET:
					this.Hide();
					if (CheckFeed())
					{
						GuiMgr.getInstance().GuiFeedWall.ShowFeed("EventMagicPotionDivine");
					}
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			if (a[0] == "Ctn")
			{
				var eq:FishEquipment = new FishEquipment();
				eq.SetInfo(giftObj["Equip"][a[1]]);
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, eq, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			if (a[0] == "Ctn")
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
	}

}