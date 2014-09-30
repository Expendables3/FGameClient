package GUI.EventEuro 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.ListBox;
	import GUI.EventEuro.ItemFixture;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIEuroRewards extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var listGift:ListBox;
		private var giftData:Object;
		private var loadContentCompleted:Boolean = false;
		private var loadServerCompleted:Boolean = false;
		private var trunkName:String;
		private var itemFixture:ItemFixture;
		private var feedType:String;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_RECEIVE_GIFT:String = "btnReceiveGift";
		static public const CTN_EQUIPMENT:String = "ctnEquipment";
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		
		public function GUIEuroRewards(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(120, 50);
				img.addChild(WaitData);
				WaitData.x = img.width / 2;
				WaitData.y = img.height / 2 + 80;
				WaitData.visible = true;
				var btnClose:Button = AddButton(BTN_CLOSE, "BtnThoat", 523, 50);
				var btnRecieveGift:Button = AddButton(BTN_RECEIVE_GIFT, "GuiEuroRewards_BtnGetGift", 200, 443);
				var btnBack:Button = AddButton(BTN_BACK, "GuiEuroRewards_BtnPrevious", 18, 308);
				var btnNext:Button = AddButton(BTN_NEXT, "GuiEuroRewards_BtnNext", 525, 308);
				listGift = AddListBox(ListBox.LIST_X, 2, 5, 19, 15);
				
				if(itemFixture == null)
				{
					AddImage("", trunkName, 78 + 193, 153).SetScaleXY(2);
					listGift.setPos(60, 242);
				}
				else
				{
					var txtFormat:TextFormat = new TextFormat("arial", 14, 0xffffff);
					txtFormat.align = "center";
					var teamAName:String = Localization.getInstance().getString(itemFixture.teamA);
					var teamBName:String = Localization.getInstance().getString(itemFixture.teamB);
					AddLabel(teamAName, 160 - 17, 200 - 37, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
					AddLabel(teamBName, 370 + 38, 200 - 37, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
					AddImage("", "Flag_" + itemFixture.teamA, 238 - 46, 220);
					AddImage("", "Ic_VS", 385, 230);
					AddImage("", "Flag_" + itemFixture.teamB, 378 + 75, 220);
					
					//AddImage("", "Number_" + itemFixture.dataFixture["Goal"][0], 269, 66).FitRect(38, 38, new Point(269 - 34, 64 + 165));
					//AddImage("", "Number_" + itemFixture.dataFixture["Goal"][1], 339, 66).FitRect(38, 38, new Point(339 - 16, 64 + 165));
					txtFormat.size =  30;
					AddLabel(itemFixture.dataFixture["Goal"][0].toString(), 225, 165 +64 - 37).setTextFormat(txtFormat);
					AddLabel(itemFixture.dataFixture["Goal"][1].toString(), 318, 165 +64 - 37).setTextFormat(txtFormat);
					
					//Du doan dung
					txtFormat.size = 25;
					if(itemFixture.isWin)
					{
						AddImage("", "GuiEventEuro_IcTrue", 323, 320 - 57);
						AddLabel("Chúc mừng bạn đã dự đoán đúng!", 273, 285, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
					}
					else
					{
						AddImage("", "GuiEventEuro_IcFalse", 323, 320 - 57);
						AddLabel("Chúc bạn may mắn ở trận sau nhé!", 273, 285, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
					}
					
					var x00:int = 255;// - 30 * numStar / 2;
					var dxx:int = 30;
					for (var i:int = 0; i < 5; i++)
					{
						if(i < itemFixture.numStar)
						{
							AddImage("", "Ic_Star", x00 + dxx * i, 193 - 37, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);
						}
						else
						{
							AddImage("", "Ic_DarkStar", x00 + dxx * i, 193 - 37, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);
						}
					}
					
					var prediction:String;
					switch(itemFixture.prediction)
					{
						case ItemFixture.PREDICTION_A:
							prediction = "<font size = '18'>Bạn đã dự đoán:<font color='#ffcc00'> đội " + teamAName + " thắng</font></font>";
							break;
						case ItemFixture.PREDICTION_DRAW:
							prediction = "<font size = '18'>Bạn đã dự đoán:<font color = '#ffcc00'> 2 đội hòa</font></font>";
							break;
						case ItemFixture.PREDICTION_B:
							prediction = "<font size = '18'>Bạn đã dự đoán:<font color = '#ffcc00'> đội " + teamBName + " thắng</font></font>";
							break;
					}
					txtFormat.size = 18;
					var labelPrediction:TextField = AddLabel("", 281, 119 - 37, 0xffffff, 1, 0x000000);
					labelPrediction.htmlText = prediction;
					//labelPrediction.setTextFormat(txtFormat);
					
					listGift.setPos(90, 372 - 37);
					btnBack.SetPos(90 - 41, 372 + 74 - 37);
					btnNext.SetPos(557, 372 + 74 - 37);
					btnClose.SetPos(523 + 82, 53 - 37);
					btnRecieveGift.SetPos(46 + 200, 139 + 443 - 37);
					SetPos(100, 0);
				}
				
				loadContentCompleted = true;
				if (loadServerCompleted)
				{
					updateGift(giftData);
				}
			}
			loadContentCompleted = false;
			loadServerCompleted = false;
			if(itemFixture == null)
			{
				LoadRes("GuiEuroRewards_Theme2");
			}
			else
			{
				LoadRes("GuiEuroRewards_Theme1");
			}
		}
		
		public function updateGift(gift:Object):void
		{
			giftData = gift;
			loadServerCompleted = true;
			if (!IsVisible)
			{
				return;
			}
			if (loadContentCompleted)
			{
				WaitData.visible = false;
				var s:String;
				var itemGift:ItemGiftEuro;
				for (s in giftData["Normal"])
				{
					itemGift = new ItemGiftEuro(listGift.img);
					itemGift.initItem(giftData["Normal"][s]);
					listGift.addItem(s, itemGift);
				}
				
				for (s in giftData["Equipment"])
				{
					itemGift = new ItemGiftEuro(listGift.img);
					itemGift.initItem(giftData["Equipment"][s], true);
					listGift.addItem(s, itemGift);
				}
				updateButtonNextBack();
			}
		}
		
		public function showGUI(_trunkName:String, _itemFixture:ItemFixture = null, _feedType:String = ""):void
		{
			feedType = _feedType;
			itemFixture = _itemFixture;
			giftData = new Object();
			trunkName = _trunkName;
			Show(Constant.GUI_MIN_LAYER, 6);
		}
		
		private function updateButtonNextBack():void
		{
			if (listGift.getCurPage() == 0)
			{
				GetButton(BTN_BACK).SetEnable(false);
			}
			else
			{
				GetButton(BTN_BACK).SetEnable(true);
			}
			
			if (listGift.getCurPage() == listGift.getNumPage() - 1)
			{
				GetButton(BTN_NEXT).SetEnable(false);
			}
			else 
			{
				GetButton(BTN_NEXT).SetEnable(true);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_BACK:
					listGift.showPrePage();
					updateButtonNextBack();
					break;
				case BTN_NEXT:
					listGift.showNextPage();
					updateButtonNextBack();
					break;
				case BTN_CLOSE:
				case BTN_RECEIVE_GIFT:
					var obj:Object;
					for each(obj in giftData["Normal"])
					{
						switch (obj["ItemType"])
						{
							case "Exp":
								GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + obj["Num"]);
								break;
							case "Money":
								GameLogic.getInstance().user.UpdateUserMoney(obj["Num"]);
								break;
							case "Jade":
							case "Iron":
							case "SoulRock":
							case "SixColorTinh":
							case "PowerTinh":
							case "Jade":
								GameLogic.getInstance().user.updateIngradient(obj["ItemType"], obj["Num"], obj["ItemId"]);
								break;
							case "Medal":
								break;
							default:
								if (GuiMgr.getInstance().GuiStore.IsVisible)
								{
								GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);
								}
								else 
								{
									GameLogic.getInstance().user.UpdateStockThing(obj["ItemType"],obj["ItemId"], obj["Num"]);
								}
								
							break;
						}
					}
					
					for each(obj in giftData["Equipment"])
					{
						GameLogic.getInstance().user.GenerateNextID();
					}
					
					if (feedType != "")
					{
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(feedType);
					}
					Hide();
					break;
			}
		}
	}

}