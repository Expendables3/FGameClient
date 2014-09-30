package Event.EventMidAutumn 
{
	import Event.EventMidAutumn.EventPackage.SendGetFinalGift;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.ListBox;
	import GUI.EventEuro.ItemGiftEuro;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIFinalGift extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_RECEIVE_GIFT:String = "btnReceiveGift";
		private var dataGift:Object;
		private var listGift:ListBox;
		private var isLoadContentComplete:Boolean;
		
		public function GUIFinalGift(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				isLoadContentComplete = true;
				img.addChild(WaitData);
				WaitData.x = img.width / 2;
				WaitData.y = img.height / 2;
				
				AddButton(BTN_BACK, "GuiStoreGift_BtnPrevious", 18+60, 400);
				AddButton(BTN_NEXT, "GuiStoreGift_BtnNext", 625, 400);
				AddButton(BTN_RECEIVE_GIFT, "BtnNhanThuong", 306, 525);
				listGift = AddListBox(ListBox.LIST_X, 1, 4, 52, 50);
				listGift.setPos(128, 377);
				SetPos(50 - 8, 43);
				
				if (dataGift != null)
				{
					updateGift(dataGift);
				}
			}
			LoadRes("GuiFinalGift_Theme");
		}
		
		public function showGUI():void
		{
			isLoadContentComplete = false;
			Exchange.GetInstance().Send(new SendGetFinalGift());
			Show(Constant.GUI_MIN_LAYER, 3);
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
									//GuiMgr.getInstance().guiChangeMedalVIP.medalNum += itemGift.data["Num"];
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
						else
						{
							GameLogic.getInstance().user.GenerateNextID();
						}
					}
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KISS_MOON);
					Hide();
					break;
			}
		}
		
		public function updateGift(_dataGift:Object):void
		{
			dataGift = _dataGift;
			if (isLoadContentComplete)
			{
				WaitData.visible = false;
				var s:String;
				var itemGift:ItemGiftEuro;
				var t:String;
				var k:String;
				for (s in dataGift)
				{
					for (t in dataGift[s])
					{
						for (k in dataGift[s][t])
						{
							itemGift = new ItemGiftEuro(listGift.img, "");
							if(t == "Normal")
							{
								itemGift.initItem(dataGift[s][t][k]);
							}
							else
							{
								itemGift.initItem(dataGift[s][t][k], true);
							}
							listGift.addItem(s, itemGift);
						}
					}
				}
				updateButtonNextBack();
			}
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
		
	}

}