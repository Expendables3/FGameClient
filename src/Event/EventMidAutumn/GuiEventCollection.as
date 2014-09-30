package Event.EventMidAutumn 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import Event.EventMidAutumn.EventPackage.SendExchangeCollectionEvent;
	import Event.EventMidAutumn.ItemEvent.EventItemInfo;
	import Event.EventMidAutumn.ItemEvent.ItemEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.EventBirthDay.EventGUI.GUICongrateEventBirthday;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiEventCollection extends GUIGetStatusAbstract 
	{
		private const ID_BTN_CLOSE:String = "IdBtnClose";
		private const ID_BTN_CHANGE:String = "IdBtnChange";
		private const ID_BTN_BUY:String = "IdBtnBuy";
		private var _listItemInfo:Array;
		private var _listTextNum:Array;
		private var _listItemEvent:Array = [];
		private var isChanging:Boolean = false;
		private var guiCongrate:GUICongrateEventBirthday = new GUICongrateEventBirthday(null, "");
		public function GuiEventCollection(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiEventCollection";
			//IsExternDataReady = true;
			_imgThemeName = "EventMidAutumnGuiCollection_Theme";
		}
		
		//override protected function onGetReadyData():void 
		protected function onGetReadyData():void 
		{
			processData(GuiMgr.getInstance().guiFrontEvent.ListCollection);
		}
		override protected function onInitGuiBeforeServer():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 705, 17);
		}
		
		override protected function onInitData(data1:Object):void 
		{
			_listItemInfo = new Array();
			var line1:Array = new Array();
			var line2:Array = new Array();
			var id:int;
			var listCollection:Object = data1;
			var s:String;
			for (s in listCollection)
			{
				id = int(s);
				if (id == 1 || id == 2 || id == 3 || id == 4)
				{
					line1.push(listCollection[s]);
				}
				else
				{
					line2.push(listCollection[s]);
				}
			}
			line1.sortOn("ItemId", Array.NUMERIC);
			line2.sortOn("ItemId", Array.NUMERIC);
			_listItemInfo.push(line1);
			_listItemInfo.push(line2);
		}
		
		
		override protected function onInitGuiAfterServer():void 
		{
			var itemInfo:EventItemInfo;
			var itGift:AbstractItemGift;
			var i:int;
			var j:int;
			var x:int = 130;
			var y:int = 155;
			var sCollectId:String;
			var maxNum:int;
			var sNum:String;
			var tfNum:TextField;
			var fm:TextFormat = new TextFormat("Arial", 14);
			var oLineText:Object = new Object();
			var itemGiftS:ItemSpecialGift;
			var giftS:GiftSpecial;
			_listTextNum = [];
			var isEnable :Boolean;
			
			var outputType:String;
			var outputId:int;
			var outputNum:int;
			for (i = 0; i < _listItemInfo.length; i++)
			{
				oLineText[i] = new Array();
				x = 100;
				isEnable = true;
				for (j = 0; j < _listItemInfo[i].length; j++)
				{
					//add vào ảnh item
					itemInfo = _listItemInfo[i][j];
					itGift = new ItemEvent(this.img, "KhungFriend", x, y);
					itGift.initData(itemInfo);
					itGift["IsTextNum"] = false;
					itGift.drawGift();
					_listItemEvent.push(itGift);
					//add vào container số lượng va số lượng
					var xCtn:int, yCtn:int;
					if (itemInfo.ItemId > 4)
					{
						if (itemInfo.ItemId == 7)
						{
							xCtn = x - 41;
							yCtn = y + 27;
						}
						else
						{
							xCtn = x - 21;
							yCtn = y + 27;
						}
					}
					else
					{
						xCtn = x - 21;
						yCtn = y + 38;
					}
					AddImage("", "EventMidAutumnGuiCollection_CtnNumBg", xCtn, yCtn, true,ALIGN_LEFT_TOP);
					maxNum = ConfigJSON.getInstance().getItemInfo("MidMoon_Collection")[i + 1]["Input"][j + 1]["Num"];
					sNum = itemInfo.Num + " / " + maxNum;
					fm.color = 0xFFFFFF;
					if (itemInfo.Num < maxNum)
					{
						isEnable = false;
						fm.color = 0xFF0000;
					}
					tfNum = AddLabel(sNum, xCtn - 31, yCtn + 4);
					tfNum.setTextFormat(fm);
					oLineText[i].push(tfNum);
					//add vào nút mua, nhờ bạn (nếu có)
					if (itemInfo.ItemId == 6)
					{
						x += 110;
					}
					else
					{
						x += 80;
					}
					
				}
				//add vào ảnh quà thứ nhất (cái dương 1)
				AddImage("", "EventMidAutumnGuiCollection_ImgSlot", 595, y + 5);
				
				outputType = ConfigJSON.getInstance().getItemInfo("MidMoon_Collection")[i + 1]["Gift"]["1"]["ItemType"];
				outputId = ConfigJSON.getInstance().getItemInfo("MidMoon_Collection")[i + 1]["Gift"]["1"]["ItemId"];
				outputNum = ConfigJSON.getInstance().getItemInfo("MidMoon_Collection")[i + 1]["Gift"]["1"]["Num"];
				if (outputType != "Weapon" && outputType != "Helmet" && outputType != "Armor")
				{
					var imgGift:ButtonEx = AddButtonEx("", outputType + outputId, 597, y - 6);
					imgGift.setTooltipText(Localization.getInstance().getString(outputType + outputId));
					imgGift.SetScaleXY(1.5);
				}
				else
				{
					var rank:int = ConfigJSON.getInstance().getItemInfo("MidMoon_Collection")[i + 1]["Gift"]["1"]["Rank"];
					var imgTrunk:Container = AddContainer("", "EquipmentChest4_Trunk", 550, y - 40);
					imgTrunk.setTooltipText("Vũ khí thần cấp " + rank);
					var imgIcon:Image = imgTrunk.AddImage("", "EquipmentChest4_" + outputType, 22, 11);
					imgIcon.img.mouseEnabled = false;
					imgTrunk.SetScaleXY(1.5);
				}
				
				//add vào nút đổi
				var btnChange:Button = AddButton(ID_BTN_CHANGE + "_" + (i + 1), "EventMidAutumnGuiCollection_BtnChange", 570, y + 45);
				btnChange.SetEnable(isEnable);
				//thêm vào mảng textfiled
				_listTextNum.push(oLineText[i]);
				y += 175;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (isChanging)
			{
				return;
			}
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
					break;
				case ID_BTN_CHANGE:
					if (EventMgr.CheckEvent("MidMoon") == EventMgr.CURRENT_IN_EVENT)
					{
						var collectId:int = int(data[1]);
						changeGift(collectId);
					}
					else
					{
						GetButton(buttonID).setTooltipText("Hết thời gian event");
					}
					break;
				case ID_BTN_BUY:
					break;
			}
		}
		/**
		 * Đổi quà
		 * @param	collectId
		 */
		private function changeGift(collectId:int):void 
		{
			var index:int = collectId - 1;
			var i:int;
			var maxNum:int;
			var itemInfo:EventItemInfo;
			//check xem co doi duoc ko?
			var isChangeOK:Boolean = true;
			for (i = 0; i < _listItemInfo[index].length; i++)
			{
				maxNum = ConfigJSON.getInstance().getItemInfo("MidMoon_Collection")[collectId]["Input"][i + 1]["Num"];
				itemInfo = _listItemInfo[index][i] as EventItemInfo;
				if (itemInfo.Num < maxNum)
				{
					isChangeOK = false;
					break;
				}
			}
			if (!isChangeOK)//không đổi được
			{
				var sKind:String = Localization.getInstance().getString("EventMidAutumn_" + itemInfo.ItemType + itemInfo.ItemId);
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ " + sKind, 310, 200, 1);
				return;
			}
			//gửi gói đổi quà lên
			var pk:SendExchangeCollectionEvent = new SendExchangeCollectionEvent(collectId);
			Exchange.GetInstance().Send(pk);
			isChanging = true;
			//trừ số item
			var tfNum:TextField;
			var fm:TextFormat = new TextFormat("Arial", 14);//xanh lá cây
			var isEnable:Boolean = true;
			for (i = 0; i < _listItemInfo[index].length; i++)
			{
				maxNum = ConfigJSON.getInstance().getItemInfo("MidMoon_Collection")[collectId]["Input"][i + 1]["Num"];
				itemInfo = _listItemInfo[index][i] as EventItemInfo;
				itemInfo.Num -= maxNum;
				tfNum = _listTextNum[index][i];
				fm.color = 0xffffff;
				if (itemInfo.Num < maxNum)
				{
					isEnable = false;
					fm.color = 0xff0000;
				}
				tfNum.text = itemInfo.Num + " / " + maxNum;
				tfNum.setTextFormat(fm);
				
			}
			GetButton(ID_BTN_CHANGE + "_" + collectId).SetEnable(isEnable);
		}
		
		/**
		 * xử lý nhận quà
		 * @param	data : dữ liệu quà
		 */
		public function processGetGift(data:Object, oldData:Object):void
		{
			isChanging = false;
			var gift:AbstractGift = new GiftSpecial();
			if ((oldData as SendExchangeCollectionEvent).CollectionId == 1)
			{
				gift = new GiftNormal();
				gift.setInfo(data["Gift"]["Normal"]["0"]);
			}
			else
			{
				gift = new GiftSpecial();
				gift.setInfo(data["Gift"]["Equipment"]["0"]);
				GameLogic.getInstance().user.GenerateNextID();
			}
			guiCongrate.initData(gift);
			guiCongrate.Show(Constant.GUI_MIN_LAYER, 5);
			
		}
		
		private function mergeBuyAction(itemType:String, itemId:int, num:int):void
		{
			
		}
		
		private function sendAllBuyAction():void
		{
			
		}
		
		override public function OnHideGUI():void 
		{
			sendAllBuyAction();
		}
		
		override public function ClearComponent():void 
		{
			var itemEvent:AbstractItemGift;
			for (var i:int = 0; i < _listItemEvent.length; i++)
			{
				itemEvent = _listItemEvent[i] as ItemEvent;
				img.removeChild(itemEvent.img);
				itemEvent.Destructor();
			}
			_listItemEvent.splice(0, _listItemEvent.length);
			super.ClearComponent();
		}
	}

}




















