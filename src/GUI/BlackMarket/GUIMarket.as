package GUI.BlackMarket 
{
	import com.bit101.components.ComboBox;
	import Data.ConfigJSON;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.BlackMarket.SendGetListItem;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIMarket extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_TAB_EQUIP:String = "btnTabWeapon";
		static public const BTN_TAB_FISH:String = "btnTabArmor";
		static public const BTN_TAB_JEWEL:String = "btnTabJewel";
		static public const BTN_TAB_OTHER:String = "btnTabOther";
		static public const BTN_COST:String = "btnTabCost";
		static public const BTN_NAME:String = "btnTabName";
		static public const BTN_TIME:String = "btnTabTime";
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_SEARCH:String = "btnSearch";
		static public const BTN_SELL:String = "btnSell";
		static public const TXTBOX_PAGE:String = "txtboxPage";
		static public const COMBOBOX_KIND:String = "ComboBoxKind";
		static public const COMBOBOX_QUALITY:String = "ComboBoxQuality";
		static public const COMBOBOX_ELEMENT:String = "ComboBoxElement";
		static public const COMBOBOX_CHANEL:String = "ComboBoxChanel";
		static public const COMBOBOX_STAR:String = "comboboxStar";
		static public const BTN_SHOP:String = "btnShop";
		static public const BTN_BUY_DIAMOND:String = "btnBuyG";
		static public const BTN_HELP:String = "btnHelp";
		static public const COMBOBOX_LEVEL:String = "comboboxLevelEquip";
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public var pageType:String;
		public var pageId:int;
		private var buttonTabWeapon:Button;
		private var buttonTabFish:Button;
		private var buttonTabOther:Button;
		private var buttonTabJewel:Button;
		private var labelKind:TextField;
		private var comboBoxKind:ComboBoxEx;
		private var comboBoxQuality:ComboBoxEx;
		private var comboBoxElement:ComboBoxEx;
		private var comboBoxChanel:ComboBoxEx;
		private var labelQuality:TextField;
		private var labelLevel:TextField;
		private var comboBoxLevel:ComboBoxEx;
		
		private const boxEquipData:Array = ["Vũ Khí", "Áo Giáp", "Mũ"];
		private const boxFishData:Array = [ "Ngư Thủ", "Siêu Cá"];
		private const boxElementData:Array = ["Tất Cả", "Kim", "Mộc", "Thổ", "Thủy", "Hỏa"];
		private const boxJewelData:Array = ["Nhẫn", "Vòng Cổ", "Vòng Tay", "Thắt Lưng"];
		private const boxQualityData:Array = ["Tất Cả", "Thường", "Đặc biệt", "Quý", "Thần"];
		private const boxStarData:Array = ["Tất Cả", "1 Sao", "2 Sao", "3 Sao"/*, "4 Sao", "5 Sao"*/];
		private var boxChanelData:Array = ["Kênh 1", "Kênh 2", "Kênh 3", "Kênh 4", "Kênh 5", "Kênh 6", "Kênh 7", "Kênh 8", "Kênh 9", "Kênh 10", 
									"Kênh 11", "Kênh 12", "Kênh 13", "Kênh 14", "Kênh 15", "Kênh 16", "Kênh 17", "Kênh 18", "Kênh 19", "Kênh 20"];
		private const boxOtherData:Array = ["Huy Hiệu", "Ngư Thạch"];
		private const boxMaterialQuality:Array = ["Tất Cả", "Cấp 1", "Cấp 2", "Cấp 3", "Cấp 4", "Cấp 5", "Cấp 6", "Cấp 7", "Cấp 8", "Cấp 9", "Cấp 10", "Cấp 11", "Cấp 12", "Cấp 13", "Cấp 14", "Cấp 15"];
		private const boxQuartzData:Array = ["Tất Cả", "Thường", "Đặc biệt", "Quý", "Thần"];
		private const boxQuartzQuality:Array = ["Tất Cả", "Cấp 1", "Cấp 2", "Cấp 3", "Cấp 4", "Cấp 5", "Cấp 6", "Cấp 7", "Cấp 8", "Cấp 9", "Cấp 10", "Cấp 11", "Cấp 12", "Cấp 13", "Cấp 14", "Cấp 15", "Cấp 16", "Cấp 17", "Cấp 18", "Cấp 19", "Cấp 20"];
		private const boxLevelData:Array = ["Tất Cả", "Cấp 1", "Cấp 2", "Cấp 3", "Cấp 4", "Cấp 5", "Cấp 6", "Cấp 7", "Cấp 8", "Cấp 9", "Cấp 10"];
		
		private const mapLevel:Object = 
		{
			"Tất Cả":0, "Cấp 1":1, "Cấp 2":2, "Cấp 3":3, "Cấp 4":4, "Cấp 5":5, "Cấp 6":6, "Cấp 7":7, "Cấp 8":8, "Cấp 9":9, "Cấp 10":10, "Cấp 11":11, "Cấp 12":12, "Cấp 13":13, "Cấp 14":14, "Cấp 15":15
		}
		
		private const mapEquip:Object = 
		{
			"Vũ Khí":"Weapon", "Áo Giáp":"Armor", "Mũ":"Helmet"
		}
		private const mapFish:Object = 
		{
			"Siêu Cá":"SuperFish", "Ngư Thủ":"Soldier"
		}
		private const mapElement:Object = 
		{
			"Tất Cả":0, "Kim":1, "Mộc":2, "Thổ":3, "Thủy":4, "Hỏa":5
		}
		private const mapJewel:Object = 
		{
			"Nhẫn":"Ring", "Vòng Cổ":"Necklace", "Vòng Tay":"Bracelet", "Thắt Lưng":"Belt"
		}
		
		private const mapQuality:Object = 
		{
			"Tất Cả":0, "Thường":1, "Đặc biệt":2, "Quý":3, "Thần":4
		}
		private const mapStar:Object = 
		{
			"Tất Cả":0, "1 Sao":1, "2 Sao":2, "3 Sao":3/*, "4 Sao":4, "5 Sao":5*/
		}
		private var mapChanel:Object = 
		{
			"Kênh 1":1, "Kênh 2":2, "Kênh 3":3, "Kênh 4":4, "Kênh 5":5, "Kênh 6":6, "Kênh 7":7, "Kênh 8":8, "Kênh 9":9, "Kênh 10":10, 
			"Kênh 11":11, "Kênh 12":12, "Kênh 13":13, "Kênh 14":14, "Kênh 15":15, "Kênh 16":16, "Kênh 17":17, "Kênh 18":18, "Kênh 19":19, "Kênh 20":20
		}
		private const mapOther:Object = 
		{
			"Huy Hiệu":"Quartz", "Ngư Thạch":"Material"
		}
		private const mapMaterialQuality:Object = 
		{
			"Tất Cả":0, "Cấp 1":1, "Cấp 2":2, "Cấp 3":3, "Cấp 4":4, "Cấp 5":5, "Cấp 6":6, "Cấp 7":7, "Cấp 8":8, "Cấp 9":9, "Cấp 10":10, "Cấp 11":11, "Cấp 12":12, "Cấp 13":13, "Cấp 14":14, "Cấp 15":15
		}
		private const mapQuaztElement:Object = 
		{
			"Tất Cả":0, "Thường":1, "Đặc biệt":2, "Quý":3, "Thần":4
		}
		private const mapQuaztQuality:Object = 
		{
			"Tất Cả":0, "Cấp 1":1, "Cấp 2":2, "Cấp 3":3, "Cấp 4":4, "Cấp 5":5, "Cấp 6":6, "Cấp 7":7, "Cấp 8":8, "Cấp 9":9, "Cấp 10":10, "Cấp 11":11, "Cấp 12":12, "Cấp 13":13, "Cấp 14":14, "Cấp 15":15, "Cấp 16":16, "Cấp 17":17, "Cấp 18":18, "Cấp 19":19, "Cấp 20":20
		}
		
		private const TypeIndexQuartz:Object = 
		{
			"1":"QWhite", "2":"QGreen", "3":"QYellow", "4":"QPurple", "4":"QVIP"
		}
		
		private var labelElement:TextField;
		private var buttonTabName:Button;
		private var buttonTabCost:Button;
		private var buttonTabTime:Button;
		private var listEquip:ListBox;
		private var listFish:ListBox;
		private var listJewel:ListBox;
		private var listOther:ListBox;
		private var currentList:ListBox;
		private var currentTab:String;
		private var labelPage:TextField;
		
		private var increaseName:Boolean;
		private var increaseCost:Boolean;
		private var increaseTime:Boolean;
		private var txtBox:TextBox;
		private var comboBoxStar:ComboBoxEx;
		private var dataEquip:Object;
		private var dataJewel:Object;
		private var dataFish:Object;
		private var dataOther:Object;
		private var isWaitingData:Boolean = false;
		private var labelDiamond:TextField;
		private var _numDiamond:int;
		
		public function GUIMarket(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function():void
			{
				SetPos(25, 25);
				
				var config:Object = ConfigJSON.getInstance().GetItemList("Param")["Market"];
				var maxChannel:int = config["MaxPage"];
				boxChanelData = [];
				mapChanel = new Object();
				for (var i:int = 1; i <= maxChannel; i++)
				{
					boxChanelData.push("Kênh " + i);
					mapChanel["Kênh " + i] = i;
				}
				OpenRoomOut();
			}
			
			LoadRes("GuiBlackMarket");
		}
		
		override public function EndingRoomOut():void 
		{
			img.addChild(WaitData);
			WaitData.x = img.width / 2;
			WaitData.y = img.height / 2 - 20;
			WaitData.visible = false;
			
			var tooltip:TooltipFormat = new TooltipFormat();
			//AddButton(BTN_HELP, "GuiBlackMarket_BtnGuide", 660, 20);
			AddButton(BTN_CLOSE, "BtnThoat", 705, 20);	
			tooltip.text = "Kho bán đồ";
			AddButton(BTN_SELL, "Btn_Sell_Market", 530 + 84, 565).setTooltip(tooltip);
			tooltip = new TooltipFormat();
			tooltip.text = "Mua kim cương";
			AddButton(BTN_BUY_DIAMOND, "Btn_BuyDiamond", 567 - 147, 563 - 2).setTooltip(tooltip);
			tooltip = new TooltipFormat();
			tooltip.text = "Cửa hàng chợ đen";
			AddButton(BTN_SHOP, "Btn_Shop_BlackMarket", 76 - 35, 560).setTooltip(tooltip);
			//AddImage("", "IcNewShop", 76 - 30, 582);
			AddButton(BTN_BACK, "Btn_Back_Market", 215 - 35, 563, this);
			AddButton(BTN_NEXT, "Btn_Next_Market", 366 - 35, 563, this);
			labelPage = AddLabel("/1", 284 + 45 - 35, 566, 0xffffff, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			//txtFormat.align = TextFormatAlign.CENTER;
			labelPage.setTextFormat(txtFormat);
			labelPage.defaultTextFormat = txtFormat;
			txtBox = AddTextBox(TXTBOX_PAGE, "1", 300 - 35, 566, 0xffffff, 20, this);
			txtBox.SetSize(30, 20);
			txtFormat = new TextFormat("arial", 15, 0xffffff, true);
			txtFormat.align = TextFormatAlign.RIGHT;
			txtBox.SetTextFormat(txtFormat);
			txtBox.SetDefaultFormat(txtFormat);
			
			labelDiamond = AddLabel("So kim cuong", 460, 565);
			txtFormat = new TextFormat("arial", 18, 0xff00ff, true);
			labelDiamond.defaultTextFormat = txtFormat;
			numDiamond = GameLogic.getInstance().user.getDiamond();
			
			
			AddLabel("Kênh: ", 467, 71, 0xffffff);
			comboBoxChanel = new ComboBoxEx(this.img, 543, 66, boxChanelData[0], boxChanelData);
			comboBoxChanel.setEventHandler(this, COMBOBOX_CHANEL);
			comboBoxChanel.setWidth(130);
			comboBoxChanel.numVisibleItem = 10;
			
			//AddButton(BTN_SEARCH, "Btn_Search_Market", 600 - 187, 68);	
			
			AddImage("", "Tab_Equip_Selected_Market", 54,70, true, ALIGN_LEFT_TOP);
			buttonTabWeapon = AddButton(BTN_TAB_EQUIP, "Btn_Tab_Equip_Market", 54, 70);
			
			AddImage("", "Tab_Jewel_Selected_Market", 54 + 95, 70, true, ALIGN_LEFT_TOP);
			buttonTabJewel = AddButton(BTN_TAB_JEWEL, "Btn_Tab_Jewel_Market", 54 + 95, 70);
			
			AddImage("", "Tab_Fish_Selected_Market", 256, 70, true, ALIGN_LEFT_TOP);
			buttonTabFish = AddButton(BTN_TAB_FISH, "Btn_Tab_Fish_Market", 256, 70);
			
			AddImage("", "Tab_Other_Selected_Market", 256 + 109, 70, true, ALIGN_LEFT_TOP);
			buttonTabOther = AddButton(BTN_TAB_OTHER, "Btn_Tab_Other_Market", 256 + 109, 70);
			
			buttonTabWeapon.SetFocus(true);
			buttonTabFish.SetFocus(false);
			buttonTabJewel.SetFocus(false);
			buttonTabOther.SetFocus(false);
			
			buttonTabName = AddButton(BTN_NAME, "Btn_Name_Market", 48, 142);
			buttonTabCost = AddButton(BTN_COST, "Btn_Cost_Market", 282, 142);
			buttonTabTime = AddButton(BTN_TIME, "Btn_Time_Market", 480, 142);
			
			listEquip = AddListBox(ListBox.LIST_Y, 4, 1, 25, 7);
			listEquip.setPos(55, 187);
			listEquip.visible = false;
			
			listFish = AddListBox(ListBox.LIST_Y, 4, 1, 25, 10);
			listFish.setPos(55, 187);
			listFish.visible = false;
			
			listJewel = AddListBox(ListBox.LIST_Y, 4, 1, 25, 10);
			listJewel.setPos(55, 187);
			listJewel.visible = false;
			
			listOther = AddListBox(ListBox.LIST_Y, 4, 1, 25, 10);
			listOther.setPos(55, 187);
			
			
			labelKind = AddLabel("Loại:", 23, 110, 0x157d93);
			comboBoxKind = new ComboBoxEx(this.img, 100, 105, boxEquipData[0], boxEquipData);
			comboBoxKind.setEventHandler(this, COMBOBOX_KIND);
			comboBoxKind.setWidth(130);
			
			labelElement = AddLabel("Hệ:", 220, 110, 0x157d93);
			comboBoxElement = new ComboBoxEx(this.img, 300, 105, boxElementData[0], boxElementData);
			comboBoxElement.setEventHandler(this, COMBOBOX_ELEMENT);
			comboBoxElement.setWidth(130);
			labelElement.visible = false;
			comboBoxElement.visible = false;
			comboBoxElement.numVisibleItem = 6;
			
			labelQuality = AddLabel("Phẩm chất:", 300, 110, 0x157d93);
			comboBoxQuality = new ComboBoxEx(this.img, 400, 105, boxQualityData[0], boxQualityData);
			comboBoxQuality.setEventHandler(this, COMBOBOX_QUALITY);
			comboBoxQuality.setWidth(130);	
			
			labelLevel = AddLabel("Cấp:", 400 + 157, 110, 0x157d93);
			comboBoxLevel = new ComboBoxEx(this.img, 557, 105, boxLevelData[0], boxLevelData);
			comboBoxLevel.setEventHandler(this, COMBOBOX_LEVEL);
			comboBoxLevel.setWidth(100);
			
			//labelStar = AddLabel("Sao", 300, 110, 0x157d93);
			//comboBoxStar = new ComboBoxEx(this.img, 400, 105, boxStarData[0], boxStarData);
			//comboBoxStar.setEventHandler(this, COMBOBOX_STAR);
			//comboBoxStar.setWidth(90);
			
			initTab(BTN_TAB_EQUIP);
			
			increaseName = true;
			increaseCost = true;
			increaseTime = true;
			
			
			//Hien ban gioi thieu beta
			//var sharedObj:Object = SharedObject.getLocal("PopUpIntroBetaMarket");
			//var uId:String = String(GameLogic.getInstance().user.GetMyInfo().Id);
			//if (!sharedObj.data[uId])
			//{
				//sharedObj.data[uId] = new Object();
			//}
			//var today:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			//if (!(sharedObj.data[uId]["Date"]) || (today.date != sharedObj.data[uId]["Date"]))
			//{
				//GuiMgr.getInstance().guiIntroBetaMarket.Show(Constant.GUI_MIN_LAYER, 3);
				//sharedObj.data[uId]["Date"] = today.date;
			//}
		}
		
		/**
		 * update dữ liệu từ server
		 * @param	dataType
		 * @param	data
		 */
		public function updateData(dataType:String, data:Object):void
		{
			//trace("updateData() dataType== " + dataType + " |data== " + data);
			isWaitingData = false;
			WaitData.visible = false;
			var type:String;
			for each(type in mapEquip)
			{
				if (dataType == type)
				{
					//setData(listEquip, data);
					dataEquip = data;
					filterData(currentTab);
					currentList.visible = true;
					return;
				}
			}
			for each(type in mapJewel)
			{
				if (dataType == type)
				{
					//setData(listJewel, data);
					dataJewel = data;
					filterData(currentTab);
					currentList.visible = true;
					return;
				}
			}
			for each(type in mapFish)
			{
				if (dataType == type)
				{
					//setData(listFish, data);
					dataFish = data;
					filterData(currentTab);
					currentList.visible = true;
					return;
				}
			}
			
			for each(type in mapOther)
			{
				//trace("366----- dataType== " + dataType + " |type== " + type);
				if (dataType == type)
				{
					dataOther = data;
					filterData(currentTab);
					currentList.visible = true;
					return;
				}
			}
		}
		
		/**
		 * Khởi tạo dữ liệu cho list đồ ở chợ
		 * @param	listBox
		 * @param	data
		 */
		private function setData(listBox:ListBox, data:Object):void
		{
			listBox.removeAllItem();
			
			if (data != null)
			{
				var ctnItem:ItemMarket;
				for (var s:String in data)
				{
					//trace("setData s=== " + s);
					var time:Number = data[s]["Duration"] - (GameLogic.getInstance().CurServerTime-data[s]["StartTime"]);
					time = int(time * 10) / 10;
					if (time > 0)
					{
						var cost:int = data[s]["PriceTag"]["Diamond"];
						var seller:Object = new Object();
						seller["uId"] = data[s]["UId"];
						seller["userName"] = data[s]["Username"];
						
						ctnItem = new ItemMarket(listBox.img);
						var type:String = data[s]["Type"];
						var autoId:int = data[s]["AutoId"];
						ctnItem.init(type, data[s]["Object"], cost, time, int(s), seller, autoId);
						listBox.addItem(s, ctnItem);
					}
				}
			}
		}
		
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var item:ItemMarket;
			var arr:Array;
			var i:int;
			comboBoxKind.isShow = false;
			switch(buttonID)
			{
				case BTN_HELP:
					GuiMgr.getInstance().guiIntroBetaMarket.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_BUY_DIAMOND:
					GuiMgr.getInstance().guiBuyDiamond.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_SHOP:
					GuiMgr.getInstance().guiShopMarket.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_SELL:
					GuiMgr.getInstance().guiSell.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				case BTN_TAB_EQUIP:
				case BTN_TAB_FISH:
				case BTN_TAB_JEWEL:
				case BTN_TAB_OTHER:
					initTab(buttonID);
					break;
				case BTN_BACK:
					if (currentList.curPage > 0)
					{
						currentList.showPrePage();
						txtBox.SetText(String(currentList.curPage + 1));
						labelPage.text = "/" + currentList.getNumPage();
					}
					updateNextBackBtn(currentList);
					break;
				case BTN_NEXT:
					if (currentList.curPage < currentList.getNumPage() -1)
					{
						currentList.showNextPage();
						txtBox.SetText(String(currentList.curPage + 1));
						labelPage.text = "/" + currentList.getNumPage();
					}
					updateNextBackBtn(currentList);
					break;
				case BTN_NAME:
					arr = new Array();
					arr = arr.concat(currentList.itemList);
					arr.sortOn(["sortName", "cost", "time"], Array.CASEINSENSITIVE);
					currentList.itemList.splice(0, currentList.itemList.length);
					if (increaseName)
					{
						for (i = 0; i < arr.length; i++)
						{
							item = arr[i] as ItemMarket;
							currentList.addItem(item.IdObject, item);
						}
					}
					else
					{
						for (i = arr.length - 1; i >= 0; i--)
						{
							item = arr[i] as ItemMarket;
							currentList.addItem(item.IdObject, item);
						}
					}
					currentList.showFirstPage();
					increaseName = !increaseName;
					txtBox.SetText(String(currentList.curPage + 1));
					labelPage.text = "/" + currentList.getNumPage();
					break;
				case BTN_COST:
					arr = new Array();
					arr = arr.concat(currentList.itemList);
					arr.sortOn(["cost", "sortName", "time"], Array.CASEINSENSITIVE | Array.NUMERIC);
					currentList.itemList.splice(0, currentList.itemList.length);
					if (increaseCost)
					{
						for (i = 0; i < arr.length; i++)
						{
							item = arr[i] as ItemMarket;
							currentList.addItem(item.IdObject, item);
						}
					}
					else
					{
						for (i = arr.length - 1; i >= 0; i--)
						{
							item = arr[i] as ItemMarket;
							currentList.addItem(item.IdObject, item);
						}
					}
					currentList.showFirstPage();
					increaseCost = !increaseCost;
					txtBox.SetText(String(currentList.curPage + 1));
					labelPage.text = "/" + currentList.getNumPage();
					break;
				case BTN_TIME:
					arr = new Array();
					arr = arr.concat(currentList.itemList);
					arr.sortOn([ "time", "cost", "sortName"], Array.DESCENDING | Array.NUMERIC);
					currentList.itemList.splice(0, currentList.itemList.length);
					if (increaseTime)
					{
						for (i = 0; i < arr.length; i++)
						{
							item = arr[i] as ItemMarket;
							currentList.addItem(item.IdObject, item);
						}
					}
					else
					{
						for (i = arr.length - 1; i >= 0; i--)
						{
							item = arr[i] as ItemMarket;
							currentList.addItem(item.IdObject, item);
						}
					}
					currentList.showFirstPage();
					increaseTime = !increaseTime;
					txtBox.SetText(String(currentList.curPage + 1));
					labelPage.text = "/" + currentList.getNumPage();
					break;
				case BTN_SEARCH:	
					filterData(currentTab);
					//trace(currentTab, comboBoxKind.selectedItem);
					break;
				case TXTBOX_PAGE:
					txtBox.textField.setSelection(0, txtBox.textField.length);
					break;
			}
		}
		
		/**
		 * Lọc dữ liệu của tab
		 * @param	currentTab
		 */
		private function filterData(currentTab:String):void 
		{
			var type:String;
			var element:int;
			var color:int;
			var level:int;
			var s:String;
			var ctnItem:ItemMarket;
			var data:Object = new Object();
			//trace("filterData currentTab== " + currentTab);
			switch(currentTab)
			{
				case BTN_TAB_EQUIP:
					element = mapElement[comboBoxElement.selectedItem];
					color = mapQuality[comboBoxQuality.selectedItem];
					level = mapLevel[comboBoxLevel.selectedItem];
					if (dataEquip != null)
					{
						for (s in dataEquip)
						{
							if((element == 0 || dataEquip[s]["Object"]["Element"] == element) && (color == 0 || dataEquip[s]["Object"]["Color"] == color) && (level == 0 || dataEquip[s]["Object"]["Rank"]%10 == level))
							{
								data[s] = dataEquip[s];
							}
						}
					}
					else
					{
						data = dataEquip;
					}
					setData(listEquip, data);
					break;
				case BTN_TAB_FISH:
					element = mapElement[comboBoxElement.selectedItem];
					color = mapStar[comboBoxQuality.selectedItem];
					//trace(type, element, color);
					
					if ((element != 0 || color != 0) && dataFish != null)
					{
						for (s in dataFish)
						{
							var numStar:int = Ultility.getStarByReceiptType(dataFish[s]["Object"]["RecipeType"]["ItemType"]);
							if ((element != 0 && color != 0 && dataFish[s]["Object"]["Element"] == element && numStar == color)
							|| (element == 0 && color != 0 && numStar == color) || (element != 0 && color == 0 && dataFish[s]["Object"]["Element"] == element))
							{
								data[s] = dataFish[s];
							}
						}
					}
					else
					{
						data = dataFish;
					}
					setData(listFish, data);
					break;
				case BTN_TAB_JEWEL:
					element = mapJewel[comboBoxElement.selectedItem];
					color = mapQuality[comboBoxQuality.selectedItem];
					level = mapLevel[comboBoxLevel.selectedItem];
					if (dataJewel != null)
					{
						for (s in dataJewel)
						{
							if((element == 0 || dataJewel[s]["Object"]["Element"] == element) && (color == 0 || dataJewel[s]["Object"]["Color"] == color) && (level == 0 || dataJewel[s]["Object"]["Rank"] == level))
							{
								data[s] = dataJewel[s];
							}
						}
					}
					else
					{
						data = dataJewel;
					}
					setData(listJewel, data);
					break;
				case BTN_TAB_OTHER:
					type = mapOther[comboBoxKind.selectedItem];
					switch(type)
					{
						case "Quartz":
							color = mapQuaztElement[comboBoxQuality.selectedItem];
							level = mapQuaztQuality[comboBoxLevel.selectedItem];
							if (dataOther != null)
							{
								for (s in dataOther)
								{
									if((color == 0 || dataOther[s]["Object"]["Type"] == TypeIndexQuartz[color]) && (level == 0 || dataOther[s]["Object"]["Level"] == level))
									{
										data[s] = dataOther[s];
									}
								}
							}
							else
							{
								data = dataOther;
							}
							
							break;
						case "Material":
							level = mapMaterialQuality[comboBoxLevel.selectedItem];
							if (level != 0 && dataOther != null)
							{
								for (s in dataOther)
								{
									if (dataOther[s]["Object"]["ItemId"]%100 == level)
									{
										data[s] = dataOther[s];
									}
								}
							}
							else
							{
								data = dataOther;
							}
							break;
					}
					//trace("listOther== " + listOther + " |data== " + data)
					setData(listOther, data);
					break;
			}
			
			txtBox.SetText(String(currentList.curPage + 1));
			labelPage.text = "/" + currentList.getNumPage();
			updateNextBackBtn(currentList);
		}
		
		public function removeItem(itemMarket:ItemMarket):void
		{
			currentList.removeItem(itemMarket.IdObject);
			currentList.showPage(currentList.curPage);
			txtBox.SetText(String(currentList.curPage + 1));
			labelPage.text = "/" + currentList.getNumPage();
			updateNextBackBtn(currentList);
		}
		
		public function updateNextBackBtn(list:ListBox):void
		{
			if (list.curPage > 0)
			{
				GetButton(BTN_BACK).SetEnable(true);
			}
			else
			{
				GetButton(BTN_BACK).SetEnable(false);
			}
			if (list.curPage < list.getNumPage() -1)
			{
				GetButton(BTN_NEXT).SetEnable(true);
			}
			else
			{
				GetButton(BTN_NEXT).SetEnable(false);
			}
		}
		
		/**
		 * show 1 tab
		 * @param	tabName
		 */
		private function initTab(tabName:String):void
		{
			currentTab = tabName;
			listEquip.visible = false;
			listFish.visible = false;
			listJewel.visible = false;
			listOther.visible = false;
			comboBoxKind.visible = false;
			comboBoxQuality.visible = false;
			comboBoxElement.visible = false;
			comboBoxLevel.visible = false;
			labelKind.visible = false;
			labelQuality.visible = false;
			labelElement.visible = false;
			labelLevel.visible = false;
			switch(tabName)
			{
				case BTN_TAB_EQUIP:
					buttonTabFish.SetFocus(false);
					buttonTabJewel.SetFocus(false);
					buttonTabWeapon.SetFocus(true);
					buttonTabOther.SetFocus(false);
					
					comboBoxKind.items = boxEquipData;
					comboBoxKind.defaultLabel = boxEquipData[0];
					comboBoxQuality.items = boxQualityData;
					comboBoxQuality.defaultLabel = boxQualityData[0];
					
					comboBoxKind.visible = true;
					comboBoxQuality.visible = true;
					comboBoxElement.visible = true;
					comboBoxLevel.visible = true;
					
					labelKind.visible = true;
					labelElement.visible = true;
					labelQuality.visible = true;
					labelLevel.visible = true;
					
					labelKind.x = 40;
					comboBoxKind.x = 80;
					comboBoxKind.width = 100;
					
					labelQuality.x = 190;
					comboBoxQuality.x = 270;
					comboBoxQuality.width = 100;
					
					labelElement.x = 400;
					comboBoxElement.x = 440;
					comboBoxElement.width = 100;
					
					labelLevel.x = 550;
					comboBoxLevel.x = 600;
					comboBoxLevel.width = 100;
					
					currentList = listEquip;
					pageType = mapEquip[comboBoxKind.selectedItem];
					pageId = mapChanel[comboBoxChanel.selectedItem];
					Exchange.GetInstance().Send(new SendGetListItem(pageType, pageId));
					break;
				case BTN_TAB_FISH:
					buttonTabWeapon.SetFocus(false);
					buttonTabFish.SetFocus(true);
					buttonTabJewel.SetFocus(false);
					buttonTabOther.SetFocus(false);
					
					comboBoxKind.items = boxFishData;
					comboBoxKind.defaultLabel = boxFishData[0];
					comboBoxQuality.items = boxStarData;
					comboBoxQuality.defaultLabel = boxStarData[0];
					comboBoxElement.items = boxElementData;
					comboBoxElement.defaultLabel = boxElementData[0];
					
					comboBoxKind.visible = true;
					comboBoxQuality.visible = true;
					comboBoxElement.visible = true;
					labelKind.visible = true;
					labelQuality.visible = true;
					labelElement.visible = true;
					
					labelKind.x = 50;
					comboBoxKind.x = 100;
					labelQuality.x = 250;
					comboBoxQuality.x = 325;
					labelElement.x = 450;
					comboBoxElement.x = 500;
					
					currentList = listFish;
					pageType = mapFish[comboBoxKind.selectedItem];
					pageId = mapChanel[comboBoxChanel.selectedItem];
					Exchange.GetInstance().Send(new SendGetListItem(pageType, pageId));
					break;
				case BTN_TAB_JEWEL:					
					buttonTabWeapon.SetFocus(false);
					buttonTabFish.SetFocus(false);
					buttonTabJewel.SetFocus(true);
					buttonTabOther.SetFocus(false);
					
					comboBoxKind.items = boxJewelData;
					comboBoxKind.defaultLabel = boxJewelData[0];
					comboBoxQuality.items = boxQualityData;
					comboBoxQuality.defaultLabel = boxQualityData[0];
					
					comboBoxKind.visible = true;
					comboBoxQuality.visible = true;
					comboBoxLevel.visible = true;
					
					labelKind.visible = true;
					labelQuality.visible = true;
					labelLevel.visible = true;
					
					labelKind.x = 40;
					comboBoxKind.x = 80;
					comboBoxKind.width = 100;
					
					labelQuality.x = 190;
					comboBoxQuality.x = 270;
					comboBoxQuality.width = 100;
					
					labelLevel.x = 400;
					comboBoxLevel.x = 450;
					comboBoxLevel.width = 100;
					
					currentList = listJewel;
					pageType = mapJewel[comboBoxKind.selectedItem];
					pageId = mapChanel[comboBoxChanel.selectedItem];
					Exchange.GetInstance().Send(new SendGetListItem(pageType, pageId));
					break;
				case BTN_TAB_OTHER:
					buttonTabWeapon.SetFocus(false);
					buttonTabFish.SetFocus(false);
					buttonTabJewel.SetFocus(false);
					buttonTabOther.SetFocus(true);
					
					comboBoxKind.items = boxOtherData;
					comboBoxKind.defaultLabel = boxOtherData[0];
					comboBoxQuality.items = boxQuartzData;
					comboBoxQuality.defaultLabel = boxQuartzData[0];
					comboBoxLevel.items = boxQuartzQuality;
					comboBoxLevel.defaultLabel = boxQuartzQuality[0];
					
					comboBoxKind.visible = true;
					comboBoxQuality.visible = true;
					comboBoxLevel.visible = true;
					labelKind.visible = true;
					labelQuality.visible = true;
					labelLevel.visible = true;
					
					labelKind.x = 50;
					comboBoxKind.x = 100;
					labelQuality.x = 250;
					comboBoxQuality.x = 330;
					labelLevel.x = 500;
					comboBoxLevel.x = 530;
					
					listJewel.visible = false;
					listEquip.visible = false;
					listFish.visible = false;
					listOther.visible = true;
					
					currentList = listOther;
					pageType = mapOther[comboBoxKind.selectedItem];
					pageId = mapChanel[comboBoxChanel.selectedItem];
					
					Exchange.GetInstance().Send(new SendGetListItem(pageType, pageId));
					break;
			}
			currentList.visible = false;
			WaitData.visible = true;
			isWaitingData = true;
			
			txtBox.SetText(String(currentList.curPage + 1));
			labelPage.text = "/" + currentList.getNumPage();
			txtBox.textField.selectable = true;
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			if (txtID == TXTBOX_PAGE)
			{
				var num:int = int(txtBox.GetText());
				if (num > 0 && num-1 < currentList.getNumPage())
				{
					currentList.showPage(num -1);
				}
			}
		}
		
		override public function onComboboxChange(event:Event, comboboxId:String):void 
		{
			switch(comboboxId)
			{
				case COMBOBOX_KIND:
				case COMBOBOX_CHANEL:
					//trace("onComboboxChange currentTab== " + currentTab);
					switch(currentTab)
					{
						case BTN_TAB_EQUIP:
							pageType = mapEquip[comboBoxKind.selectedItem];
							break;
						case BTN_TAB_JEWEL:
							pageType = mapJewel[comboBoxKind.selectedItem];
							break;
						case BTN_TAB_FISH:
							pageType = mapFish[comboBoxKind.selectedItem];
							if (mapFish[comboBoxKind.selectedItem] == "SuperFish")
							{
								labelQuality.visible = false;
								labelElement.visible = false;
								comboBoxQuality.visible = false;
								comboBoxElement.visible = false;
								labelLevel.visible = false;
							}
							else
							{
								labelQuality.visible = true;
								labelElement.visible = true;
								comboBoxQuality.visible = true;
								comboBoxElement.visible = true;
								labelLevel.visible = false;
							}
							break;
						case BTN_TAB_OTHER:
							pageType = mapOther[comboBoxKind.selectedItem];
							if (pageType == "Quartz")
							{
								labelQuality.visible = true;
								comboBoxQuality.visible = true;
								comboBoxLevel.items = boxQuartzQuality;
								comboBoxLevel.defaultLabel = boxQuartzQuality[0];
							}
							else
							{
								comboBoxQuality.visible = false;
								labelQuality.visible = false;
								comboBoxLevel.items = boxMaterialQuality;
								comboBoxLevel.defaultLabel = boxMaterialQuality[0];
							}
							break;
					}
					pageId = mapChanel[comboBoxChanel.selectedItem];
					Exchange.GetInstance().Send(new SendGetListItem(pageType, pageId));
					currentList.visible = false;
					isWaitingData = true;
					WaitData.visible = true;
					break;
				case COMBOBOX_ELEMENT:
				case COMBOBOX_QUALITY:
				case COMBOBOX_LEVEL:
					//trace("case COMBOBOX_QUALITY:case COMBOBOX_QUALITY:== " + comboBoxKind.selectedItem);
					filterData(currentTab);
					break;
			}
		}
		
		public function get numDiamond():int 
		{
			return _numDiamond;
		}
		
		public function set numDiamond(value:int):void 
		{
			_numDiamond = value;
			labelDiamond.text = Ultility.StandardNumber(value);
		}
		
		public function refreshCurPage():void
		{
			Exchange.GetInstance().Send(new SendGetListItem(pageType, pageId));
		}
	}

}