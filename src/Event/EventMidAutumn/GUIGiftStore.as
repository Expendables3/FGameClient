package Event.EventMidAutumn
{
	import Data.ConfigJSON;
	import Event.EventMidAutumn.EventPackage.SendGetGiftStore;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ListBox;
	import GUI.EventEuro.ItemGiftEuro;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIGiftStore extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_RECEIVE_GIFT:String = "btnReceiveGift";
		static public const BTN_CLOSE:String = "btnClose";
		private var dataGift:Object;
		private var listGift:ListBox;
		private var themeName:String;
		private var isLoadContentComplete:Boolean;
		private var stone:int;
		private var showAll:Boolean;
		private var position:int;
		private var stonePosition:int;
		
		public function GUIGiftStore(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				img.addChild(WaitData);
				WaitData.x = img.width / 2;
				WaitData.y = img.height / 2;
				
				//var btnClose:Button = AddButton(BTN_CLOSE, "BtnThoat", 703, 53);
				var label:TextField;
				if(!showAll)
				{
					AddButton(BTN_RECEIVE_GIFT, "BtnNhanThuong", 200 + 130 - 35, 443 + 74);
					label = AddLabel("Bạn đã chinh phục  được mốc " + stonePosition + " km", 325, 107, 0xffff00, 1, 0x000000);
					label.setTextFormat(new TextFormat("arial", 20, 0xffff00, true));
				}
				else
				{
					AddButton(BTN_CLOSE, "BtnDong", 200 + 130 - 19, 443 + 74);
					if(stonePosition < 759)
					{
						label = AddLabel("Hãy vượt qua mốc " + stonePosition + " km để nhận thưởng", 325, 107, 0xffff00, 1, 0x000000);
					}
					else
					{
						label = AddLabel("Chúc mừng bạn đã chinh phục cung trăng!", 325, 107, 0xffff00, 1, 0x000000);
					}
					label.setTextFormat(new TextFormat("arial", 20, 0xffff00, true));
				}
				
				AddImage("", "GuiBackground_GiftTrunk", 350, 200).SetScaleXY(1.3);
				AddLabel(stonePosition + " km", 315, 160, 0xffff00, 1, 0x000000).setTextFormat(new TextFormat("arial", 20, 0xffff00, true)); 
				
				var btnBack:Button = AddButton(BTN_BACK, "GuiStoreGift_BtnPrevious", 18+60, 400);
				var btnNext:Button = AddButton(BTN_NEXT, "GuiStoreGift_BtnNext", 625, 400);
				listGift = AddListBox(ListBox.LIST_X, 2, 5, 19, 15);
				listGift.setPos(140, 327);
				SetPos(50, 3);
				isLoadContentComplete = true;
				
				if (dataGift != null)
				{
					updateGift(dataGift);
				}
			}
			LoadRes("GuiStoreGift_Theme");
		}
		
		public function updateGift(_dataGift:Object):void
		{
			//trace("stone" , stone);
			dataGift = _dataGift;
			if (isLoadContentComplete)
			{
				WaitData.visible = false;
				var s:String;
				var itemGift:ItemGiftEuro;
				var t:String;
				var k:String;
				var h:String;
				//Merge quà giống nhau
				var cloneData:Object = new Object();
				cloneData["Normal"] = new Object();
				cloneData["Equipment"] = new Object();
				var i:int = 0;
				var j:int = 0;
				for (s in dataGift)
				{
					for ( h in dataGift[s])
					{
						if(int(h) <= stone || showAll)
						for (t in dataGift[s][h])
						{
							for (k in dataGift[s][h][t])
							{
								var obj:Object = dataGift[s][h][t][k];
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
				}
				
				for (s in cloneData)
				{
					for ( h in cloneData[s])
					{
						itemGift = new ItemGiftEuro(listGift.img, "GuiStoreGift_ItemBg");
						if(s == "Normal")
						{
							itemGift.initItem(cloneData[s][h]);
						}
						else
						{
							itemGift.initItem(cloneData[s][h], true);
						}
						listGift.addItem(s +h, itemGift);
					}
				}
				updateButtonNextBack();
			}
		}
		
		public function showGUI(_position:int, _showAll:Boolean):void
		{
			position = _position;
			//Tính mốc quà đã vượt qua ứng với vị trí hoặc cần vượt qua
			var configStone:Object = ConfigJSON.getInstance().GetItemList("MidMoon_GenMap")["GiftStone"];
			var maxPosition:int;
			var minPosition:int = 1000;
			for (var s:String in configStone)
			{
				if (!_showAll)
				{
					if (int(configStone[s]["NumStep"]) <= position && int(configStone[s]["NumStep"]) >= maxPosition)
					{
						maxPosition = int(configStone[s]["NumStep"]);
						stone = int(s);
						stonePosition = maxPosition;
					}
				}
				else
				{
					if (int(configStone[s]["NumStep"]) > position && int(configStone[s]["NumStep"]) <= minPosition)
					{
						minPosition = int(configStone[s]["NumStep"]);
						stone = int(s);
						stonePosition = minPosition;
					}
				}
			}
			showAll = _showAll;
			isLoadContentComplete = false;
			Exchange.GetInstance().Send(new SendGetGiftStore());
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnHideGUI():void 
		{
			dataGift = null;
			GuiMgr.getInstance().guiBackGround.isStop = false;
			isLoadContentComplete = false;
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
			
			if (listGift.getCurPage() >= listGift.getNumPage() - 1)
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
									//GuiMgr.getInstance().guiChangeMedalVIP.medalNum += int(itemGift.data["Num"]);
									GameLogic.getInstance().numMedalHalloween += int(itemGift.data["Num"]);
									break;
								case "Collection":
									GuiMgr.getInstance().guiFrontEvent.lantern.eatItem(itemGift.data["ItemType"], itemGift.data["ItemId"], itemGift.data["Num"]);
									break;
								default:
									GuiMgr.getInstance().GuiStore.UpdateStore(itemGift.data["ItemType"], itemGift.data["ItemId"], itemGift.data["Num"]);									
								break;
							}
						}
						//else
						//{
							//GameLogic.getInstance().user.GenerateNextID();
						//}
					}
					Hide();
					if (stonePosition == 759)
					{
						GuiMgr.getInstance().guiFinalGift.showGUI();
					}
					break;
				case BTN_CLOSE:
					Hide();
					break;
			}
		}
		
	}

}