package GUI.BlackMarket 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GUI.BlackMarket.Goods;
	import GUI.BlackMarket.GUISell;
	import GUI.BlackMarket.ItemSell;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.BlackMarket.SendGetItemBack;
	import NetworkPacket.PacketSend.BlackMarket.SendGetListSell;
	import NetworkPacket.PacketSend.SendLoadInventory;
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUISell extends BaseGUI
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var waitListSell:MovieClip = new DataLoading();
		private var waitStore:MovieClip = new DataLoading();
		
		private var listItemSell:ListBox;
		private var currentList:ListBox;
		private var currentTab:String;
		private var listEquip:ListBox;
		private var btnTabJewel:Button;
		private var btnTabEquip:Button;
		private var listJewel:ListBox;
		private var activeItem:Sprite;
		private var activeGood:Goods;
		private var isDraging:Boolean = false;
		private var btnTabFish:Button;
		private var btnTabOther:Button;
		private var listFish:ListBox;
		private var listOther:ListBox;
		public var isWaitingListSell:Boolean;
		public var isWaitingStore:Boolean;
		private var isFlyEff:Boolean = false;
		static public const BTN_CLOSE:String = "btnClose";
		static public const CTN_GOODS:String = "ctnGoods";
		static public const CTN_ITEM_SELL:String = "ctnItemSell";
		static public const BTN_BACK_STORE:String = "btnBackStore";
		static public const BTN_NEXT_STORE:String = "btnNextStore";
		static public const BTN_TAB_EQUIP:String = "btnTabEquip";
		static public const BTN_TAB_JEWEL:String = "btnTabJewel";
		static public const BTN_TAB_FISH:String = "btnTabFish";
		static public const BTN_TAB_OTHER:String = "btnTabOther";
		
		public function GUISell(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Sell_Market");
			img.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			SetPos(25, 25);
			
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 705, 20);	
			AddButton(BTN_BACK_STORE, "BtnPrev", 5 + 28, 480 + 23, this);
			AddButton(BTN_NEXT_STORE, "BtnNext", 679, 480 + 23, this);
			
			AddImage("", "Tab_Equip_Selected_Market", 54, 433, true, ALIGN_LEFT_TOP);
			btnTabEquip = AddButton(BTN_TAB_EQUIP, "Btn_Tab_Equip_Market", 54, 433);
			
			AddImage("", "Tab_Jewel_Selected_Market", 156, 433, true, ALIGN_LEFT_TOP);
			btnTabJewel = AddButton(BTN_TAB_JEWEL, "Btn_Tab_Jewel_Market", 156, 433);
			
			AddImage("", "Tab_Fish_Selected_Market", 270, 433, true, ALIGN_LEFT_TOP);
			btnTabFish = AddButton(BTN_TAB_FISH, "Btn_Tab_Fish_Market", 270, 433);
			
			AddImage("", "Tab_Other_Selected_Market", 390, 433, true, ALIGN_LEFT_TOP);
			btnTabOther = AddButton(BTN_TAB_OTHER, "Btn_Tab_Other_Market", 390, 433);
			
			var data:Array;
			var goods:Goods
			var i:int;
			listEquip = AddListBox(ListBox.LIST_X,1, 7, 5);
			listEquip.setPos(68, 468);
			listEquip.visible = true;
			
			listJewel = AddListBox(ListBox.LIST_X,1, 7, 5);
			listJewel.setPos(68, 468);
			listJewel.visible = false;
			
			listFish = AddListBox(ListBox.LIST_X,1, 7);
			listFish.setPos(68, 468);
			listFish.visible = false;
			
			listOther = AddListBox(ListBox.LIST_X,1, 7);
			listOther.setPos(68, 468);
			listOther.visible = false;
			
			btnTabJewel.SetFocus(false);
			btnTabEquip.SetFocus(true);
			
			showTab(BTN_TAB_EQUIP);
			
			listItemSell = AddListBox(ListBox.LIST_Y, 3, 1, 10, 16);
			listItemSell.setPos(60, 95);
			for (i = 0; i < 3; i++)
			{
				var itemSell:ItemSell = new ItemSell(listItemSell.img);
				listItemSell.addItem(CTN_ITEM_SELL + i.toString(), itemSell, this);
				itemSell.position = i + 1;
			}
			
			img.addChild(waitListSell);
			waitListSell.x = 374;
			waitListSell.y = 194;
			isWaitingListSell = true;
			
			img.addChild(waitStore);
			waitStore.x = 374;
			waitStore.y = 510;
			isWaitingStore = true;
			
			//Gui goi tin lay cac hang dang ban
			Exchange.GetInstance().Send(new SendGetListSell());
			// Load lại kho để refresh trang bị
			var cmd:SendLoadInventory = new SendLoadInventory();
			Exchange.GetInstance().Send(cmd);
		}
		
		
		/**
		 * update dữ liệu kho đồ
		 */
		public function updateDataStore():void
		{
			var data:Array;
			var goods:Goods
			var i:int;
			
			data = new Array();
			data = data.concat(GameLogic.getInstance().user.GetStore("Helmet"));
			data = data.concat(GameLogic.getInstance().user.GetStore("Armor"));
			data = data.concat(GameLogic.getInstance().user.GetStore("Weapon"));
			filterData(BTN_TAB_EQUIP, data);
			listEquip.removeAllItem();
			for (i = 0; i < data.length; i++)
			{
				goods = new Goods(listEquip.img);
				goods.initGoods(BTN_TAB_EQUIP, data[i]);
				listEquip.addItem(CTN_GOODS + data[i]["Id"], goods, this);
			}
			
			data = new Array();
			data = data.concat(GameLogic.getInstance().user.GetStore("Bracelet"));
			data = data.concat(GameLogic.getInstance().user.GetStore("Necklace"));
			data = data.concat(GameLogic.getInstance().user.GetStore("Ring"));
			data = data.concat(GameLogic.getInstance().user.GetStore("Belt"));
			filterData(BTN_TAB_JEWEL, data);
			listJewel.removeAllItem();
			for (i = 0; i < data.length; i++)
			{
				goods = new Goods(listJewel.img);
				goods.initGoods(BTN_TAB_JEWEL, data[i]);
				listJewel.addItem(CTN_GOODS + data[i]["Id"], goods, this);
			}
			
			data = new Array();
			data = data.concat(GameLogic.getInstance().user.GetStore("BabyFish"));
			filterData(BTN_TAB_FISH, data);
			listFish.removeAllItem();
			for (i = 0; i < data.length; i++)
			{
				goods = new Goods(listFish.img);
				if (data[i]["FishType"] == Fish.FISHTYPE_SOLDIER)
				{
					data[i]["Type"] = "Soldier";
				}
				else
				{
					data[i]["Type"] = data[i]["Name"];
				}
				goods.initGoods(BTN_TAB_FISH, data[i]);
				listFish.addItem(CTN_GOODS + data[i]["Id"], goods, this);
			}
			
			data = new Array();
			data = GameLogic.getInstance().user.StockThingsArr.Material;
			for (i = 0; i < data.length; i++)
			{
				data[i]["Type"] = "Material";
				data[i]["ItemId"] = data[i]["Id"];
			}
			var dataQuartz:Array = new Array();
			
			var dataQPurple:Array = new Array();
			dataQPurple = updateArrNext(GameLogic.getInstance().user.StockThingsArr.QPurple);
			
			var dataQYellow:Array = new Array();
			dataQYellow = updateArrNext(GameLogic.getInstance().user.StockThingsArr.QYellow);
			
			var dataQGreen:Array = new Array();
			dataQGreen = updateArrNext(GameLogic.getInstance().user.StockThingsArr.QGreen);
			
			var dataQWhite:Array = new Array();
			dataQWhite = updateArrNext(GameLogic.getInstance().user.StockThingsArr.QWhite);
			
			var dataQVIP:Array = new Array();
			dataQVIP = updateArrNext(GameLogic.getInstance().user.StockThingsArr.QVIP);
			
			dataQuartz = dataQuartz.concat(dataQVIP, dataQPurple, dataQYellow, dataQGreen, dataQWhite);
			
			
			
			data = data.concat(dataQuartz);
			listOther.removeAllItem();
			for (i = 0; i < data.length; i++)
			{
				goods = new Goods(listOther.img);
				goods.initGoods(BTN_TAB_OTHER, data[i]);
				listOther.addItem(CTN_GOODS + data[i]["Type"] + data[i]["Id"], goods, this);
				//trace(data[i]["ItemId"]);
			}
			
			updateNextBackBtn(currentList);
			
			isWaitingStore = false;
			if(img.contains(waitStore))
			{
				img.removeChild(waitStore);
			}
		}
		
		private function updateArrNext(dataStore:Array):Array
		{
			if (dataStore == null)
			{
				null;
			}
			var dataEquip:Array = new Array();
			var levelOne:int;
			if (dataStore.length > 0)
			{
				levelOne = dataStore[0].Level;
			}
			else
			{
				levelOne = 0;
			}
			
			for (var i:int = 0; i < dataStore.length; i++)
			{
				if (dataStore[i].Level > levelOne)
				{
					levelOne = dataStore[i].Level;
				}
			}
			//trace("levelOne== " + levelOne);
			var arrLevel:Array = new Array;
			var itemIdOne:int = 0;
			for (var k:int = levelOne + 1; k > 0; k--)
			{
				arrLevel.splice(0, arrLevel.length);
				for (var j:int = 0; j < dataStore.length; j++)
				{
					if (dataStore[j].Level == k)
					{
						if (dataStore[j].ItemId > itemIdOne)
						{
							itemIdOne = dataStore[j].ItemId;
						}
						//trace("Level== " + dataStore[j].Level + " |k== " + k);
						arrLevel.push(dataStore[j]);
					}
				}
				//trace("itemIdOne== " + itemIdOne);
				for (var h:int = itemIdOne + 1; h > 0; h--)
				{
					for (var m:int = 0; m < arrLevel.length; m++)
					{
						if (arrLevel[m].ItemId == h)
						{
							//trace("ItemId== " + arrLevel[m].ItemId + " |h== " + h);
							dataEquip.push(arrLevel[m]);
						}
					}
				}
			}
			
			return dataEquip;
		}
		
		/**
		 * Hiển thị các món đồ đang rao trên chợ
		 * @param	data
		 */
		public function updateListSell(data:Object):void
		{
			//trace("-----------updateListSell() data== " + data);
			var i:int = 0;
			for (var s:String in data)
			{
				//trace("s========= " + s);
				var itemSell:ItemSell = listItemSell.itemList[int(s)-1] as ItemSell;
				var tabType:String = getTabType(data[s]["PageType"]);
				//Gan du lieu cho 1 so truong hop
				data[s]["Object"]["Type"] = data[s]["Type"];
				//trace("[Object][Type]== " + data[s]["Object"]["Type"] + " |data[Type]== " + data[s]["Type"]);
				if (data[s]["Type"] == "Material")
				{
					data[s]["Object"]["Id"] = data[s]["Object"]["ItemId"];
				}
				if (data[s]["Type"] == "QWhite" || data[s]["Type"] == "QGreen" || data[s]["Type"] == "QYellow" || data[s]["Type"] == "QPurple" || data[s]["Type"] == "QVIP")
				{
					tabType = "btnTabOther";
					//trace("Dac biet ItemId== " + data[s]["Object"]["ItemId"] );
					//trace("Dac biet Type== " + data[s]["Object"]["Type"]);
				}
				//trace("tabType== " + tabType + " |data[s][Object]== " + data[s]["Object"]);
				itemSell.setGoods(tabType, data[s]["Object"]);
				var remainTime:Number = data[s]["Duration"] -(GameLogic.getInstance().CurServerTime - data[s]["StartTime"]);
				itemSell.initSell(remainTime, data[s]["PriceTag"]["Diamond"], data[s]["PageId"]);
				itemSell.AutoId = data[s]["AutoId"];
				if (data[s]["isSold"])
				{
					itemSell.itemState = ItemSell.IS_SOLD;
				}
				i++;
			}
			isWaitingListSell = false;
			if(img.contains(waitListSell))
			{
				img.removeChild(waitListSell);
			}
		}
		
		private function getTabType(itemType:String):String
		{
			switch(itemType)
			{
				case "Armor":
				case "Weapon":
				case "Helmet":
					return BTN_TAB_EQUIP;
				case "Ring":
				case "Necklace":
				case "Belt":
				case "Bracelet":
					return BTN_TAB_JEWEL;
				case "Fish":
				case "Batman":
				case "Sparta":
				case "Spiderman":
				case "SuperFish":
				case "Soldier":
					return BTN_TAB_FISH;
				case "Material":
					return BTN_TAB_OTHER;
			}
			return "";
		}
		
		/**
		 * Lọc dữ liệu bán ở các tab
		 * @param	typeTab id tab cần lọc
		 * @param	data dữ liệu lọc
		 */
		private function filterData(typeTab:String, data:Array):void 
		{
			var i:int;
			switch(typeTab)
			{
				case BTN_TAB_EQUIP:
				case BTN_TAB_JEWEL:
					data.sortOn(["Color", "Element", "Rank"], Array.DESCENDING | Array.NUMERIC);
					for (i = 0; i < data.length; i++)
					{
						if (!Ultility.checkSource(data[i]["Source"]) || data[i]["IsUsed"])
						{
							data.splice(i, 1);
							i--;
						}
					}
					break;
				case BTN_TAB_FISH:
					for (i = 0; i < data.length; i++)
					{
						if (data[i]["FishType"] != Fish.FISHTYPE_SOLDIER && data[i]["Name"] == null)
						{
							data.splice(i, 1);
							i--;
						}
					}
					break;
			}
		}
		
		public function onDoubleClick(event:MouseEvent, buttonID:String):void
		{
			GuiMgr.getInstance().guiTooltipEgg.Hide();
			GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			if (isWaitingListSell || isWaitingStore || isFlyEff)
			{
				return;
			}
			
			if (buttonID.search(CTN_GOODS) >= 0)
			{
				var goods:Goods = currentList.getItemById(buttonID) as Goods;
				var success:Boolean;
				
				if(goods.tabType != BTN_TAB_OTHER)
				{
					success = addGoods(goods);
					if (!success)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Gian hàng của bạn đã đầy. Không thể rao bán tiếp được");
					}
				}
				else
				{
					//trace("goods.data.ItemType=============" + goods.data["ItemType"]);
					if (goods.data["ItemType"] == "Material")
					{
						GuiMgr.getInstance().guiChooseNumber.showGUI(Math.min(1000, goods.num), "Ngư Thạch", goods.imageGoods.ImgName, function f(num:int):void {
							if(num != 0)
							{
								success = addGoods(goods, num);
								if (!success)
								{
									GuiMgr.getInstance().GuiMessageBox.ShowOK("Gian hàng của bạn đã đầy. Không thể rao bán tiếp được");
								}
							}
						});
					}
					else
					{
						success = addGoods(goods);
						if (!success)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Gian hàng của bạn đã đầy. Không thể rao bán tiếp được");
						}
					}
				}
			}
			else
			if (buttonID.search(CTN_ITEM_SELL) >= 0)
			{
				var itemSell:ItemSell = listItemSell.getItemById(buttonID) as ItemSell;
				if(itemSell.itemState == ItemSell.IS_READY)
				{
					removeGoods(itemSell);
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TAB_EQUIP:
				case BTN_TAB_JEWEL:
				case BTN_TAB_FISH:
				case BTN_TAB_OTHER:
					showTab(buttonID);
					break;
				case BTN_BACK_STORE:
					if (currentList.getCurPage() > 0)
					{
						currentList.showPrePage();
					}
					updateNextBackBtn(currentList);
					break;
				case BTN_NEXT_STORE:	
					if (currentList.getCurPage() < currentList.getNumPage())
					{
						currentList.showNextPage();
					}
					updateNextBackBtn(currentList);
				default:
					if (buttonID.search(CTN_GOODS) >= 0)
					{
						//var goods:Goods = currentList.getItemById(buttonID)as Goods;
						//addGoods(goods);
					}
					else if (buttonID.search(CTN_ITEM_SELL) >= 0)
					{
						/*var itemSell:ItemSell = listItemSell.getItemById(buttonID) as ItemSell;
						if(itemSell.itemState == ItemSell.IS_READY && event.target == itemSell.imageItem_Bg.img)
						{
							removeGoods(itemSell);
						}*/
					}
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var obj:Object;
			var fishEquip:FishEquipment;
			if (buttonID.search(CTN_GOODS) >= 0)
			{
				var goods:Goods = currentList.getItemById(buttonID) as Goods;
				if (goods.tabType == BTN_TAB_EQUIP || goods.tabType == BTN_TAB_JEWEL)
				{
					obj = new Object();
					obj = goods.data;
					if (obj as FishEquipment == null)
					{
						fishEquip = new FishEquipment();
						fishEquip.SetInfo(obj);
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, fishEquip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
					else
					{
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
				}
				else if (goods.tabType == BTN_TAB_OTHER && goods.data["ItemType"] != "Material")
				{
					GuiMgr.getInstance().guiTooltipEgg.showGUI(goods.data, event.stageX, event.stageY);
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_GOODS) >= 0)
			{
				GuiMgr.getInstance().guiTooltipEgg.Hide();
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		
		override public function OnButtonDown(event:MouseEvent, buttonID:String):void 
		{
			if (isWaitingListSell || isWaitingStore || isFlyEff)
			{
				return;
			}
			//Kéo đồ vào để bán
			var canAddGood:Boolean = false;
			for each( var itemSell:ItemSell in listItemSell.itemList)
			{
				if (itemSell.itemState == ItemSell.IS_EMPTY || itemSell.itemState == ItemSell.IS_READY)
				{
					canAddGood = true;
					break;
				}
			}
			if (buttonID.search(CTN_GOODS) >= 0 && canAddGood)
			{
				var goods:Goods = currentList.getItemById(buttonID) as Goods;
				//goods.imageGoods.img.visible = false;
				activeGood = goods;
				activeItem = Ultility.CloneImage(goods.imageGoods.img);
				img.addChild(activeItem);
				var pS:Point = img.globalToLocal(goods.img.localToGlobal(new Point(goods.imageGoods.img.x, goods.imageGoods.img.y)));
				activeItem.x = pS.x;
				activeItem.y = pS.y;
				activeItem.mouseEnabled = false;
				activeItem.mouseChildren = false;
				activeItem.startDrag();
				
				isDraging = true;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (activeItem != null && isDraging)
			{
				isDraging = false;
				
				var check:Boolean = true;
				for each(var itemSell:ItemSell in listItemSell.itemList)
				{
					if (activeItem.hitTestObject(itemSell.img) && (itemSell.itemState == ItemSell.IS_EMPTY || itemSell.itemState == ItemSell.IS_READY))
					{
						//Nếu đã có đồ thì remove cái cũ đi
						if (itemSell.itemState == ItemSell.IS_READY)
						{
							removeGoods(itemSell);
						}
						showTab(activeGood.tabType);
						//add hàng vào
						//trace("ItemType== " + activeGood.data["ItemType"]);
						if (activeGood.tabType == BTN_TAB_OTHER && activeGood.data["ItemType"] == "Material")
						{
							GuiMgr.getInstance().guiChooseNumber.showGUI(Math.min(1000, activeGood.num), "Ngư Thạch", activeGood.imageGoods.ImgName, function f(num:int):void {
								if(num != 0)
								{
									setItemSellGood(itemSell, activeGood, num);
								}
								else
								{
									activeItem.stopDrag();
									activeGood.imageGoods.img.visible = true;
									img.removeChild(activeItem);
									activeItem = null;
									activeGood = null;
								}
							});
						}
						else
						{
							setItemSellGood(itemSell, activeGood);
						}
						activeItem.stopDrag();
						check = false;
						break;
					}
				}
				
				if (check)
				{
					activeItem.stopDrag();
					activeGood.imageGoods.img.visible = true;
					img.removeChild(activeItem);
					activeItem = null;
					activeGood = null;
				}
			}
		}
		
		public function removeGoods(itemSell:ItemSell):void 
		{
			var goods:Goods;
			switch(itemSell.tabType)
			{
				case BTN_TAB_EQUIP:
					goods = new Goods(listEquip.img);
					goods.initGoods(BTN_TAB_EQUIP, itemSell.data);
					listEquip.addItem(CTN_GOODS + itemSell.data["Id"], goods, this);
					showTab(BTN_TAB_EQUIP);
					break;
				case BTN_TAB_JEWEL:
					goods = new Goods(listJewel.img);
					goods.initGoods(BTN_TAB_JEWEL, itemSell.data);
					listJewel.addItem(CTN_GOODS + itemSell.data["Id"], goods, this);
					showTab(BTN_TAB_JEWEL);
					break;
				case BTN_TAB_OTHER:
					var goodsItem:Goods = listOther.getItemById(CTN_GOODS + itemSell.data["Type"] + itemSell.data["Id"]) as Goods;
					//trace("case BTN_TAB_OTHER: goodsItem== " + goodsItem);
					if(goodsItem == null)
					{
						itemSell.data["Num"] = itemSell.num;
						goods = new Goods(listOther.img);
						goods.initGoods(BTN_TAB_OTHER, itemSell.data);
						listOther.addItem(CTN_GOODS + itemSell.data["ItemType"] + itemSell.data["Id"], goods, this);
					}
					else
					{
						goodsItem.num += itemSell.num;
					}
					showTab(BTN_TAB_OTHER);
					break;
				case BTN_TAB_FISH:
					goods = new Goods(listFish.img);
					goods.initGoods(BTN_TAB_FISH, itemSell.data);
					listFish.addItem(CTN_GOODS + itemSell.data["Id"], goods, this);
					showTab(BTN_TAB_FISH);
					break;
			}
			itemSell.removeGoods();
			//trace(itemSell.data["Type"]);
		}
		
		private function addGoods(goods:Goods, num:int = 0):Boolean
		{
			for each( var itemSell:ItemSell in listItemSell.itemList)
			{
				if (itemSell.itemState == ItemSell.IS_EMPTY)
				{
					setItemSellGood(itemSell, goods, num);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Hàm cho đồ bay lên slot bán
		 * @param	itemSell slot bán
		 * @param	goods đồ
		 * @param	num
		 */
		private function setItemSellGood(itemSell:ItemSell, goods:Goods, num:int = 0):void
		{
			isFlyEff = true;
			itemSell.itemState == ItemSell.IS_READY;
			var mc:Sprite;
			if (activeItem == null)
			{
			mc = Ultility.CloneImage(goods.imageGoods.img);
			img.addChild(mc);
			var pS:Point = img.globalToLocal(goods.img.localToGlobal(new Point(goods.imageGoods.img.x, goods.imageGoods.img.y)));
			mc.x = pS.x;
			mc.y = pS.y;
			}
			else
			{
				mc = activeItem;
			}
			var pD:Point = img.globalToLocal(itemSell.img.localToGlobal(new Point(itemSell.imageGoods.img.x, itemSell.imageGoods.img.y)));
			if (num != 0)
			{
				TweenMax.to(mc, 0.2, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:finishPutGoods, onCompleteParams:[mc, goods, itemSell, num] } );
			}
			else
			{
				TweenMax.to(mc, 0.2, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:finishPutGoods, onCompleteParams:[mc, goods, itemSell] } );
			}
			if(goods.num == num)
			{
				currentList.removeItem(goods.IdObject);
			}
			else
			{
				goods.num -= num;
			}
		}
		
		private function finishPutGoods(mc:Sprite, goods:Goods, itemSell:ItemSell, num:int = 0):void 
		{
			img.removeChild(mc);
			var obj:Object = goods.data;
			if (num != 0)
			{
				obj["Num"] = num;
			}
			itemSell.setGoods(goods.tabType, obj);
			mc = null;
			activeItem = null;
			activeGood = null;
			isFlyEff = false;
		}
		
		private function showTab(tabName:String):void
		{
			currentTab = tabName;
			switch(tabName)
			{
				case BTN_TAB_EQUIP:
					currentList = listEquip;
					listEquip.visible = true;
					listJewel.visible = false;
					listFish.visible = false;
					listOther.visible = false;
					btnTabEquip.SetFocus(true);
					btnTabJewel.SetFocus(false);
					btnTabFish.SetFocus(false);
					btnTabOther.SetFocus(false);
					break;
				case BTN_TAB_JEWEL:
					currentList = listJewel;
					listEquip.visible = false;
					listJewel.visible = true;
					listFish.visible = false;
					listOther.visible = false;
					btnTabEquip.SetFocus(false);
					btnTabJewel.SetFocus(true);
					btnTabFish.SetFocus(false);
					btnTabOther.SetFocus(false);
					break;
				case BTN_TAB_FISH:
					currentList = listFish;
					listEquip.visible = false;
					listJewel.visible = false;
					listFish.visible = true;
					listOther.visible = false;
					
					btnTabEquip.SetFocus(false);
					btnTabJewel.SetFocus(false);
					btnTabFish.SetFocus(true);
					btnTabOther.SetFocus(false);
					break;
				case BTN_TAB_OTHER:
					currentList = listOther;
					listEquip.visible = false;
					listJewel.visible = false;
					listFish.visible = false;
					listOther.visible = true;
					
					btnTabEquip.SetFocus(false);
					btnTabJewel.SetFocus(false);
					btnTabFish.SetFocus(false);
					btnTabOther.SetFocus(true);
					break;
			}
			//currentList.sortById();
			currentList.showPage(currentList.curPage);
			updateNextBackBtn(currentList);
		}
		
		public function updateNextBackBtn(list:ListBox):void
		{
			if (list.curPage > 0)
			{
				GetButton(BTN_BACK_STORE).SetEnable(true);
			}
			else
			{
				GetButton(BTN_BACK_STORE).SetEnable(false);
			}
			if (list.curPage < list.getNumPage() -1)
			{
				GetButton(BTN_NEXT_STORE).SetEnable(true);
			}
			else
			{
				GetButton(BTN_NEXT_STORE).SetEnable(false);
			}
		}
		
		override public function OnHideGUI():void 
		{
			var guiMarket:GUIMarket  = GuiMgr.getInstance().guiMarket;
			if (guiMarket.IsVisible)
			{
				guiMarket.numDiamond = GameLogic.getInstance().user.getDiamond();
				guiMarket.refreshCurPage();
			}
		}
		
		public function getItemSellByPosition(position:int):ItemSell
		{
			return listItemSell.itemList[position - 1] as ItemSell;
		}
	}

}