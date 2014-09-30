package GUI.BossServer 
{
	import Data.Localization;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventLuckyMachine.EventLuckyMachineMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.EventEuro.ItemGiftEuro;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIGiftBossServer extends BaseGUI 
	{
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_RECEIVE_GIFT:String = "btnReceiveGift";
		static public const BTN_CLOSE:String = "btnClose";
		static public const THEME_LAST_HIT:String = "GuiGiftBossServer_ThemeLastHit";
		static public const THEME_TOP:String = "GuiGiftBossServer_ThemeTop";
		static public const THEME_FAIL:String = "GuiGiftBossServer_ThemeFail";
		static public const THEME_MILESTONE:String = "GuiGiftBossServer_ThemeMilestone";
		private var dataGift:Object;
		private var listGift:ListBox;
		private var themeName:String;
		private var goHome:Boolean;
		private var topPosition:int;
		private var totalGift:Object;
		
		public function GUIGiftBossServer(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				if (themeName == THEME_FAIL)
				{
					SetPos(50, 15);
				}
				else
				{
					SetPos(50, 45);
				}
				OpenRoomOut();
			}
			LoadRes(themeName);
		}
		
		override public function EndingRoomOut():void 
		{
			var btnClose:Button = AddButton(BTN_CLOSE, "BtnThoat", 523+169, 54);
			if (themeName == THEME_FAIL)
			{
				AddButton(BTN_RECEIVE_GIFT, "BtnNhanThuong", 300, 443 + 52);
				btnClose.SetPos(763 - 56, 69 - 13);
				SetPos(50, 15);
				var oldRoom:int = GuiMgr.getInstance().guiListBoss.roomGift;
				var bossName:String = Localization.getInstance().getString("BossServer" + oldRoom);
				AddLabel("(" + bossName + " đã phá hủy thủy cung)", 307, 132, 0xffff00, 1, 0x000000);
			}
			else
			{
				if((themeName == THEME_TOP && topPosition <= 10 && topPosition > 0) || themeName == THEME_LAST_HIT)
				{
					AddButton(BTN_RECEIVE_GIFT, "GuiGiftBossServer_BtnShare", 200 + 130, 443 + 68);
				}
				else
				{
					AddButton(BTN_RECEIVE_GIFT, "BtnNhanThuong", 300, 443 + 68);
				}
				SetPos(50, 45);
			}
			
			if (themeName == THEME_TOP)
			{
				var position:int = topPosition;
				var a:int = position / 100;
				var b:int = (position - a * 100) / 10;
				var c:int = position - a * 100 - b * 10;
				var imageA:Image;
				var imageB:Image;
				var imageC:Image;
				if (c >= 0)
				{
					imageC = AddImage("", "Number_" + c, 360, 188);
					imageC.SetScaleXY(1.6);
				}
				if (b > 0 || (a > 0 && b == 0))
				{
					imageC.SetPos(380, 188);
					imageB = AddImage("", "Number_" + b, 340, 188);
					imageB.SetScaleXY(1.6);
				}
				if (a > 0)
				{
					imageC.SetPos(400, 188);
					imageB.SetPos(360, 188);
					imageA = AddImage("", "Number_" + a, 320, 188);
					imageA.SetScaleXY(1.6);
				}
				
			}
			var btnBack:Button = AddButton(BTN_BACK, "GuiGiftBossServer_BtnPrevious", 18+60, 400);
			var btnNext:Button = AddButton(BTN_NEXT, "GuiGiftBossServer_BtnNext", 625, 400);
			listGift = AddListBox(ListBox.LIST_X, 2, 5, 19, 15);
			listGift.setPos(140, 327);
			
			//var s:String;
			var itemGift:ItemGiftEuro;
			var t:String;
			var k:String;
			//for (s in dataGift)
			{
				for (t in dataGift)
				{
					for (k in dataGift[t])
					{
						itemGift = new ItemGiftEuro(listGift.img, "GuiGiftBossServer_GiftBg");
						if(t == "Normal")
						{
							itemGift.initItem(dataGift[t][k]);
						}
						else
						{
							itemGift.initItem(dataGift[t][k], true);
						}
						listGift.addItem(t+k, itemGift);
					}
				}
			}
			updateButtonNextBack();
		}
		
		public function showGUI(_dataGift:Object, _goHome:Boolean = false, _topPosition:int = 0):void
		{
			totalGift = _dataGift;
			topPosition = _topPosition;
			goHome = _goHome;
			if (_dataGift == null || (_dataGift["TopBonus"] == null && _dataGift["LastHitBonus"] == null && _dataGift["LostBonus"] == null && _dataGift["OutTopBonus"] == null && _dataGift["DamageGift"]))
			{
				return;
			}
			else if (_dataGift["LastHitBonus"] != null)
			{
				themeName = THEME_LAST_HIT;
			}
			else if (_dataGift["TopBonus"] != null || _dataGift["OutTopBonus"] != null)
			{
				themeName = THEME_TOP;
			}
			else if (_dataGift["DamageGift"])
			{
				themeName = THEME_MILESTONE;
			}
			else
			{
				themeName = THEME_FAIL;
			}
			
			updateDataGift();
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		private function updateDataGift():void 
		{
			var s:String;
			var itemGift:ItemGiftEuro;
			var t:String;
			var k:String;
			//Merge quà giống nhau
			var cloneData:Object = new Object();
			cloneData["Normal"] = new Object();
			cloneData["Equipment"] = new Object();
			var i:int = 0;
			var j:int = 0;
			var tempGift:Object;
			switch(themeName)
			{
				case THEME_LAST_HIT:
					tempGift = totalGift["LastHitBonus"];
					break;
				case THEME_TOP:
					if(totalGift["TopBonus"] != null)
					{
						tempGift = totalGift["TopBonus"];
					}
					if(totalGift["OutTopBonus"] != null)
					{
						tempGift = totalGift["OutTopBonus"];
					}
					break;
				case THEME_MILESTONE:
					if (totalGift["DamageGift"] != null)
					{
						tempGift = totalGift["DamageGift"];
					}
					break;
				case THEME_FAIL:
					if (totalGift["LostBonus"] != null)
					{
						tempGift = totalGift["LostBonus"];
					}
			}
			//for (s in totalGift)
			{
				for (t in tempGift)
				{
					for (k in tempGift[t])
					{
						var obj:Object = tempGift[t][k];
						if (t == "Normal")
						{
							var check:Boolean = false;
							for (var m:String in cloneData["Normal"])
							{
								var cloneObj:Object = cloneData["Normal"][m];
								if (cloneObj["ItemType"] == obj["ItemType"] && cloneObj["ItemId"] == obj["ItemId"])
								{
									cloneObj["Num"] += obj["Num"];
									check = true;
									break;
								}
							}
							if(!check)
							{
								cloneData["Normal"][i] = obj;
								i++;
							}
						}
						else
						{
							cloneData["Equipment"][j] = obj;
							j++;
						}
					}
				}
			}
			dataGift = cloneData;
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
					for each(var itemGift:ItemGiftEuro in listGift.itemList)
					{
						if (!itemGift.isEquip)
						{
							switch(itemGift.data["ItemType"])
							{
								case "Exp":
									GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + itemGift.data["Num"]);
									break;
								case "Money":
									GameLogic.getInstance().user.UpdateUserMoney(itemGift.data["Num"]);
									break;
								case "Jade":
								case "Iron":
								case "SoulRock":
								case "SixColorTinh":
								case "PowerTinh":
								case "Jade":
									GameLogic.getInstance().user.updateIngradient(itemGift.data["ItemType"], itemGift.data["Num"], itemGift.data["ItemId"]);
									break;
								case "Medal":
									GameLogic.getInstance().numMedalHalloween += int(itemGift.data["Num"]);
									break;
								case "Collection":
									GuiMgr.getInstance().guiFrontEvent.lantern.eatItem(itemGift.data["ItemType"], itemGift.data["ItemId"], itemGift.data["Num"]);
									break;
								case "HalItem":
									HalloweenMgr.getInstance().updateRockStore(itemGift.data["ItemId"], itemGift.data["Num"]);
									break;
								case "ColPItem":
								case "Candy":
									EventSvc.getInstance().updateItem(itemGift.data["ItemType"], itemGift.data["ItemId"], itemGift.data["Num"]);
									break;
								case "Ticket":
									EventLuckyMachineMgr.getInstance().updateTicket(itemGift.data["Num"]);
									break;
								default:
									GuiMgr.getInstance().GuiStore.UpdateStore(itemGift.data["ItemType"], itemGift.data["ItemId"], itemGift.data["Num"]);									
								break;
							}
						}
						else
						{
							GameLogic.getInstance().user.GenerateNextID();
						}
					}
					switch(themeName)
					{
						case THEME_LAST_HIT:
							totalGift["LastHitBonus"] = null;
							if (totalGift["TopBonus"] != null || totalGift["OutTopBonus"] != null)
							{
								themeName = THEME_TOP;
								updateDataGift();
								ClearComponent();
								InitGUI();
							}
							else
							if (totalGift["DamageGift"] != null)
							{
								themeName = THEME_MILESTONE;
								updateDataGift();
								ClearComponent();
								InitGUI();
							}
							else if (totalGift["LostBonus"] != null)
							{
								themeName = THEME_FAIL;
								updateDataGift();
								ClearComponent();
								InitGUI();
							}
							else
							{
								Hide();
								if (goHome)
								{
									GuiMgr.getInstance().guiMainBossServer.OnButtonClick(null, GUIMainBossServer.BTN_HOME);
								}
							}
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_LASTHIT_BOSS_SERVER);
							break;
						case THEME_TOP:
							totalGift["TopBonus"] = null;
							totalGift["OutTopBonus"] = null;
							if (totalGift["DamageGift"] != null)
							{
								themeName = THEME_MILESTONE;
								updateDataGift();
								ClearComponent();
								InitGUI();
							}
							else if (totalGift["LostBonus"] != null)
							{
								themeName = THEME_FAIL;
								updateDataGift();
								ClearComponent();
								InitGUI();
							}
							else
							{
								Hide();
								if (goHome)
								{
									GuiMgr.getInstance().guiMainBossServer.OnButtonClick(null, GUIMainBossServer.BTN_HOME);
								}
							}
							if(topPosition <= 10 && topPosition > 0)
							{
								GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_TOP_BOSS_SERVER, topPosition.toString());
							}
							break;
						case THEME_MILESTONE:
							totalGift["DamageGift"] = null;
							if (totalGift["LostBonus"] != null)
							{
								themeName = THEME_FAIL;
								updateDataGift();
								ClearComponent();
								InitGUI();
							}
							else
							{
								Hide();
								if (goHome)
								{
									GuiMgr.getInstance().guiMainBossServer.OnButtonClick(null, GUIMainBossServer.BTN_HOME);
								}
							}
							break;
						case THEME_FAIL:
							Hide();
							if (goHome)
							{
								GuiMgr.getInstance().guiMainBossServer.OnButtonClick(null, GUIMainBossServer.BTN_HOME);
							}
							break;
					}
					break;
			}
		}
		
	}

}