package GUI.TrungLinhThach 
{
	import com.adobe.images.BitString;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	import Sound.SoundMgr;
	import com.adobe.serialization.json.JSON;
	
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.FishWings; 
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.FishSoldier;
	import Logic.Fish;
	import GUI.component.TooltipFormat;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIWareRoomLinhThach extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_TRANG:String = "QWhite";
		static public const BTN_XANH:String = "QGreen";
		static public const BTN_VANG:String = "QYellow";
		static public const BTN_TIM:String = "QPurple";
		static public const BTN_VIP:String = "QVIP";
		static public const TXTBOX_PAGE:String = "TxtboxPage";
		static public const BTN_BACK:String = "BtnBackList";
		static public const BTN_NEXT:String = "BtnNextList";
		static public const BTN_BACK_SOLIDER:String = "btnBackSolider";
		static public const BTN_NEXT_SOLIDER:String = "btnNextSolider";
		private static const CTN_INFO:String = "Group_Info";
		
		private static const CTN_QUARTZ_1:String = "Ctn_Quartz_1";
		private static const CTN_QUARTZ_2:String = "Ctn_Quartz_2";
		private static const CTN_QUARTZ_3:String = "Ctn_Quartz_3";
		private static const CTN_QUARTZ_4:String = "Ctn_Quartz_4";
		private static const CTN_QUARTZ_5:String = "Ctn_Quartz_5";
		private static const CTN_QUARTZ_6:String = "Ctn_Quartz_6";
		private static const CTN_QUARTZ_7:String = "Ctn_Quartz_7";
		private static const CTN_QUARTZ_8:String = "Ctn_Quartz_8";
		
		private static const CTN_QUARTZ_WHITE:String = "Ctn_QWhite";
		private static const CTN_QUARTZ_GREEN:String = "Ctn_QGreen";
		private static const CTN_QUARTZ_YELLOW:String = "Ctn_QYellow";
		private static const CTN_QUARTZ_PURPLE:String = "Ctn_QPurple";
		
		private var buttonClose:Button;
		private var buttonTrang:Button;
		private var buttonXanh:Button;
		private var buttonVang:Button;
		private var buttonTim:Button;
		private var buttonVIP:Button;
		private var btnBackSolider:Button;
		private var btnNextSolider:Button;
		private var buttonBack:Button;
		private var buttonNext:Button;
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		public var IsInitFinish:Boolean = false;
		
		private var oEquip:Array = new Array();
		private var curPage:int;
		private	var numPage:int = 1;
		private var labelPage:TextField;
		private var txtBox:TextBox;
		private var dataEquip:Array = new Array();
		private var currentList:ListBox;
		private var listCustom:ListBox;
		private var labelSoldierName:TextField;
		private var labelSoldierLevel:TextField;
		
		private var arrSolider:Array;
		public var curSoldier:FishSoldier;					// Current Soldier is changing equips
		private var curSoldierImg:Image;					// Current Soldier image in GUI
		private var wings:FishWings;
		private var InteractiveCtn:Array = new Array();		// List all the Container can be interact
		private var ItemPos:Object;							// Positions of all the container in GUI (fixed)
		private var dataQuartz:Array = new Array();
		
		private var ctnQuartz_1:Container;
		private var ctnQuartz_2:Container;
		private var ctnQuartz_3:Container;
		private var ctnQuartz_4:Container;
		private var ctnQuartz_5:Container;
		private var ctnQuartz_6:Container;
		private var ctnQuartz_7:Container;
		private var ctnQuartz_8:Container;
		
		private var ctnQuart:Container;
		
		private var lastTimeClick:Number = 0;				// Double click purpose
		private var lastTimeCtn:String = "";				// Double click purpose
		private var curEquipImage:Image;					// Image dragable
		private var isReleaseItem:Boolean;					// Flag
		private var isWare:Boolean = true;	
		private var curEquip:FishEquipment;					// Current Equipment Selected
		private static const DOUBLE_CLICK_TIMER:Number = 0.5;
		private var curTabQuartz:String = "QWhite";
		private var curTypeQuartz:String = "QWhite";
		private var curIdSoldier:int;
		private var idItemQuartz:int;
		private var lastItemCtn:String = "";				// Double click purpose
		private var curIdLinhThach:int;
		private var numItem:int = 9;
		private var curSlotIdAll:int = 0;
		private var slotData:Array = new Array();
		
		private var mcTrang:Image;
		private var mcXanh:Image;
		private var mcVang:Image;
		private var mcTim:Image;
		private var mcVIP:Image;
		private var ctnBonus:Container;
		
		private var isUpdate:Boolean = true;
		private var objUser:Object = new Object();
		private var objStore:Object = new Object();
		private var maxSlotId:int;
		private var arrUser:Array = new Array();
		private var arrStore:Array = new Array();
		
		private var listCopyData:Object;			//mảng copy
		private var listOriginal:Object;			//mảng gốc
		
		public function GUIWareRoomLinhThach(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			isDataReady = false;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiWareRoomLinhThach";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				IsInitFinish = false;
				SetPos(0, 0);
				
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				// Load lại kho để refresh trang bị
				var cmd:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(cmd);
				
				OpenRoomOut();
			}
			LoadRes("GuiWareRoomLinhThach_Bg");
		}
		
		public function showGUI():void
		{
			isDataReady = true;
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function EndingRoomOut():void 
		{
			isDataReady = true;
			IsInitFinish = true;
			//trace("EndingRoomOut()== " + isDataReady);
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
			//trace("refreshComponent()");
			isDataReady = dataAvailable;
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			addContent();
		}
		
		/*Add thong tin content cho Gui*/
		private function addContent():void
		{
			listCustom = AddListBox(ListBox.LIST_X, 3, 3, 8, 27);
			listCustom.setPos(445, 138);
			
			buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 736, 50);
			buttonClose.setTooltipText("Đóng lại");
			
			mcTrang = AddImage("", "mc_btnTrang", 472, 122);
			buttonTrang = AddButton(BTN_TRANG, "GuiWareRoomLinhThach_Trang", 445, 111);
			mcXanh = AddImage("", "mc_btnXanh", 528, 122);
			buttonXanh = AddButton(BTN_XANH, "GuiWareRoomLinhThach_Xanh", 500, 111);
			mcVang = AddImage("", "mc_btnVang", 581, 122);
			buttonVang = AddButton(BTN_VANG, "GuiWareRoomLinhThach_Vang", 555, 111);
			mcTim = AddImage("", "mc_btnTim", 636, 122);
			buttonTim = AddButton(BTN_TIM, "GuiWareRoomLinhThach_Tim", 610, 111);
			mcVIP = AddImage("", "mc_btnVIP", 691, 122);
			buttonVIP = AddButton(BTN_VIP, "GuiWareRoomLinhThach_VIP", 665, 111);
			mcTrang.img.visible = true;
			mcXanh.img.visible = false;
			mcVang.img.visible = false;
			mcTim.img.visible = false;
			mcVIP.img.visible = false;
			buttonTrang.SetFocus(true);
			buttonXanh.SetFocus(false);
			buttonVang.SetFocus(false);
			buttonTim.SetFocus(false);
			buttonVIP.SetFocus(false);
			
			labelPage = AddLabel("/1", 580, 517, 0xffffff, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			labelPage.setTextFormat(txtFormat);
			labelPage.defaultTextFormat = txtFormat;
			
			txtBox = AddTextBox(TXTBOX_PAGE, "1", 550, 517, 30, 20, this);
			txtFormat = new TextFormat("arial", 15, 0xffffff, true);
			txtFormat.align = TextFormatAlign.RIGHT;
			txtBox.SetTextFormat(txtFormat);
			txtBox.SetDefaultFormat(txtFormat);
			
			buttonBack = AddButton(BTN_BACK, "GuiWareRoomLinhThach_BtnBack", 490, 515, this);
			buttonNext = AddButton(BTN_NEXT, "GuiWareRoomLinhThach_BtnNext", 650, 515, this);
			
			dataEquip.splice(0, dataEquip.length);
			
			filterListEquip(BTN_TRANG, false);
			currentList = listCustom;
			
			ctnBonus = AddContainer(CTN_INFO, "GuiChooseEquipment_ImgFrameFriend", 80, 415);
			
			addSolider(null);
			ShowSlots();
			AddEquipsToSlot();
		}
		
		public function updateGUI():void 
		{
			if (IsInitFinish)
			{
				//trace("updateGUI()");
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//trace("---------OnButtonClick buttonID== " + buttonID);
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TRANG:
					//trace("BTN_TRANG");
					mcTrang.img.visible = true;
					mcXanh.img.visible = false;
					mcVang.img.visible = false;
					mcTim.img.visible = false;
					mcVIP.img.visible = false;
					buttonTrang.SetFocus(true);
					buttonXanh.SetFocus(false);
					buttonVang.SetFocus(false);
					buttonTim.SetFocus(false);
					buttonVIP.SetFocus(false);
					
					dataEquip.splice(0, dataEquip.length);
					
					filterListEquip(buttonID, false);
					break;
				case BTN_XANH:
					//trace("BTN_XANH");
					mcTrang.img.visible = false;
					mcXanh.img.visible = true;
					mcVang.img.visible = false;
					mcTim.img.visible = false;
					mcVIP.img.visible = false;
					buttonTrang.SetFocus(false);
					buttonXanh.SetFocus(true);
					buttonVang.SetFocus(false);
					buttonTim.SetFocus(false);
					buttonVIP.SetFocus(false);
					
					dataEquip.splice(0, dataEquip.length);
					
					filterListEquip(buttonID, false);
					break;
				case BTN_VANG:
					//trace("BTN_VANG");
					mcTrang.img.visible = false;
					mcXanh.img.visible = false;
					mcVang.img.visible = true;
					mcTim.img.visible = false;
					mcVIP.img.visible = false;
					buttonTrang.SetFocus(false);
					buttonXanh.SetFocus(false);
					buttonVang.SetFocus(true);
					buttonTim.SetFocus(false);
					buttonVIP.SetFocus(false);
					
					dataEquip.splice(0, dataEquip.length);
					
					filterListEquip(buttonID, false);
					break;
				case BTN_TIM:
					//trace("BTN_TIM");
					mcTrang.img.visible = false;
					mcXanh.img.visible = false;
					mcVang.img.visible = false;
					mcTim.img.visible = true;
					mcVIP.img.visible = false;
					buttonTrang.SetFocus(false);
					buttonXanh.SetFocus(false);
					buttonVang.SetFocus(false);
					buttonTim.SetFocus(true);
					buttonVIP.SetFocus(false);
					
					dataEquip.splice(0, dataEquip.length);
				
					filterListEquip(buttonID, false);
					break;
				case BTN_VIP:
					//trace("BTN_VIP");
					mcTrang.img.visible = false;
					mcXanh.img.visible = false;
					mcVang.img.visible = false;
					mcTim.img.visible = false;
					mcVIP.img.visible = true;
					buttonTrang.SetFocus(false);
					buttonXanh.SetFocus(false);
					buttonVang.SetFocus(false);
					buttonTim.SetFocus(false);
					buttonVIP.SetFocus(true);
					
					dataEquip.splice(0, dataEquip.length);
				
					filterListEquip(buttonID, false);
					break;
				case BTN_BACK:
					if (curPage > 1)
					{
						curPage--;
						txtBox.SetText(curPage.toString());
						labelPage.text = "/" + (numPage);
						addList(currentList, oEquip, (curPage -1 ) * numItem + 1, curPage * numItem);
						buttonBack.SetVisible(true);
						buttonNext.SetVisible(true);
						if (curPage <= 1)
						{
							buttonBack.SetVisible(false);
							buttonNext.SetVisible(true);
						}
					}
					//updateNextBackBtn();
					break;
				case BTN_NEXT:
					if (curPage < numPage)
					{
						curPage++;
						txtBox.SetText(curPage.toString());
						labelPage.text = "/" + (numPage);
						addList(currentList, oEquip, (curPage -1 ) * numItem + 1, curPage * numItem);
						buttonBack.SetVisible(true);
						buttonNext.SetVisible(true);
						if (curPage == numPage)
						{
							buttonBack.SetVisible(true);
							buttonNext.SetVisible(false);
						}
					}
					//updateNextBackBtn();
					break;
				case BTN_BACK_SOLIDER:
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
					}
					var backSolider:FishSoldier;
					for (var i:int = 0; i < arrSolider.length; i++)
					{
						if (arrSolider[i].Id == curSoldier.Id)
						{
							if( i== 0)
							{
								backSolider = arrSolider[arrSolider.length - 1];
							}
							else
							{
								backSolider = arrSolider[i - 1];
							}
							break;
						}
					}
					var arrSoldierInLake:Array = GameLogic.getInstance().user.FishSoldierArr;
					for (var n:int = 0; n < arrSoldierInLake.length; n++)
					{
						if (arrSoldierInLake[n].Id == backSolider.Id)
						{
							backSolider = arrSoldierInLake[n];
							break;
						}
					}
					addSolider(backSolider, true);
					break;
				case BTN_NEXT_SOLIDER:
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
					}
					var nextSolider:FishSoldier;
					for (var j:int = 0; j < arrSolider.length; j++)
					{
						if (arrSolider[j].Id == curSoldier.Id)
						{
							if( j== arrSolider.length - 1)
							{
								nextSolider = arrSolider[0];
							}
							else
							{
								nextSolider = arrSolider[j + 1];
							}
							break;
						}
					}
					var arrSoldierInLake2:Array = GameLogic.getInstance().user.FishSoldierArr;
					for (var m:int = 0; m < arrSoldierInLake2.length; m++)
					{
						if (arrSoldierInLake2[m].Id == nextSolider.Id)
						{
							nextSolider = arrSoldierInLake2[m];
							break;
						}
					}
					addSolider(nextSolider, true);
					break;
			}
		}
		
		private function filterListEquip(curSubTab:String = "", changeTab:Boolean = false):void 
		{
			curTabQuartz = curSubTab;
			oEquip.splice(0, oEquip.length);
			var dataStore:Array = new Array;
			dataStore = GameLogic.getInstance().user.GetStore(curSubTab);
			//trace("curSubTab== " + curSubTab + " |dataStore.length== " + dataStore.length);
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
				//trace("Level== " + dataStore[i].Level + " |levelOne== " + levelOne);
				if (dataStore[i].Level > levelOne)
				{
					levelOne = dataStore[i].Level;
				}
			}
			//trace("-----------levelOne== " + levelOne);
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
				//trace("arrLevel.length== " + arrLevel.length);
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
			//trace("dataEquip.length== " + dataEquip.length);
			
			var type:String;
			var element:int;
			var color:int;
			var s:int;
			var numElementInList:int;
			
			if (dataEquip.length > 0)
			{
				oEquip = dataEquip;
				for (s = 0; s < dataEquip.length; s++ )
				{
					numElementInList++;
				}
			}
			else
			{
				oEquip = dataEquip;
			}
			
			numPage = numElementInList / numItem + 1;
			if (numElementInList % numItem == 0)
				numPage = numElementInList / numItem;
			
			if (changeTab)
			{
				//trace("filterListEquipcurPage: " + changeTab + " |curPage= " + curPage + " |numPage= " + numPage);
				if (curPage > numPage)
				{
					curPage = numPage;
					//trace("gan lai curPage= " + curPage);
					//txtBox.SetText(curPage.toString());
				}
				
				if (curPage == 0 && numPage == 1)
				{
					addList(listCustom, oEquip);
					curPage = 1;
				}
				else
				{
					addList(listCustom, oEquip, (curPage -1 ) * numItem + 1, curPage * numItem);
				}
			}
			else
			{
				//trace("goi ben duoi--------");
				addList(listCustom, oEquip);
				curPage = 1;
			}
			
			txtBox.SetText(curPage.toString());
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			if (numPage == 0)
			{
				numPage = 1;
			}
			labelPage.text = "/" + numPage;
			
			if (numPage > 1)
			{
				buttonBack.SetVisible(true);
				buttonNext.SetVisible(true);
				if (curPage <= 1)
				{
					buttonBack.SetVisible(false);
					buttonNext.SetVisible(true);
				}
				
				if (curPage == numPage)
				{
					buttonBack.SetVisible(true);
					buttonNext.SetVisible(false);
				}
			}
			else
			{
				buttonBack.SetVisible(false);
				buttonNext.SetVisible(false);
			}
			
			invateTabMenu(curSubTab);
			
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			var value:int = int(txtBox.GetText());
			//trace("OnTextboxChange==== value== " + value);
			if (value > numPage && numPage == 0)
			{
				txtBox.SetText(curPage.toString());
			}
			else if (value > numPage && numPage != 0)
			{
				txtBox.SetText(numPage.toString());
			}
			
			
			if (txtID == TXTBOX_PAGE)
			{
				var num:int = int(txtBox.GetText());
				if (num < 1) num = 1;
				if (num > numPage) num = numPage;
				curPage = num;
				txtBox.SetText(curPage.toString());
				addList(currentList, oEquip, (num - 1) * numItem + 1, num * numItem);
				//trace("OnTextboxChange num== " + num);
				if (num <= 1 && num == numPage)
				{
					buttonBack.SetVisible(false);
					buttonNext.SetVisible(false);
				}
				else if (num <= 1 && numPage > num)
				{
					buttonBack.SetVisible(false);
					buttonNext.SetVisible(true);
				}
				else if (num > 1 && num == numPage)
				{
					buttonBack.SetVisible(true);
					buttonNext.SetVisible(false);
				}
			}
		}
		
		private function addList(listBox:ListBox, data:Array, fromE:int = 1, toE:int = 9):void
		{
			listBox.removeAllItem();
			
			if (data != null)
			{
				var i:int = 0;
				for (var j:String in data)
				{
					i++; 
					if (i >= fromE && i <= toE)
					{
						//trace("addList Type== " + data[j].Type);
						var ctn:Container = new Container(img, "Bg_Item_" + data[j].Type, 0, -15);
						ctn.img.cacheAsBitmap = false;
						ctn.IdObject =  data[j].Id;
						//trace("addList ctn.IdObject== " + ctn.IdObject);
						var GuiToolTipItem:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
						var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
						GuiToolTipItem.Init(data[j]);
						GuiToolTipItem.InitPos(ctn, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
						ctn.setGUITooltip(GuiToolTipItem);
						
						var imagName:String = data[j].Type + data[j].ItemId;
						var imag1:Image = ctn.AddImage(data[j].Id, imagName, 43, 51);
						//trace("addList imagName== " + imagName);
						var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
						var txt:TextField = ctn.AddLabel(Ultility.StandardNumber(data[j].Level), -9, 1, 0xFFFF00, 1);
						txt.autoSize = TextFieldAutoSize.CENTER
						txt.filters = [glow];
						
						listBox.addItem("CtnItemTrung" + "_" + data[j].Type + "_" + data[j].ItemId + "_" + data[j].Id, ctn, this);
						ContainerArr.splice(ContainerArr.length - 1, 1);
						
						var updateLevel:Button = ctn.AddButton("item_" + (i - 1), "GuiWareRoomLinhThach_UpdateLevel", 34, 80, this);
						updateLevel.setTooltipText("Nâng cấp Huy Hiệu");
						updateLevel.img.addEventListener(MouseEvent.MOUSE_OVER, overUpdateQWareroom);
						updateLevel.img.addEventListener(MouseEvent.CLICK, clickPopupUpdateQWareroom);
						updateLevel.img.tabIndex = i - 1;
						updateLevel.img.mouseEnabled = true;
						updateLevel.img.parent.mouseEnabled = true;
					}
				}
			}
		}
		
		override public function OnHideGUI():void 
		{
			if (curSoldier)
			{
				processChangeClothes();
				UpdateAllFishArr();
				
				curSoldier = null;
			}
			curEquip = null;
		}
		
		private function addSolider(s:FishSoldier, updateSolider:Boolean = false):void
		{
			var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
			
			arrSolider = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			arrSolider = arrSolider.concat(new Array());
			//trace("arrSolider.length== " + arrSolider.length);
			
			for (var i:int = 0; i < arrSolider.length; i++)
			{
				if (FishSoldier(arrSolider[i]).SoldierType != FishSoldier.SOLDIER_TYPE_MIX)
				{
					arrSolider.splice(i, 1);
					i--;
				}
			}
			
			if (!s && arrSolider.length > 0)
			{
				curSoldier = arrSolider[0];
			}
			else
			{
				curSoldier = s;
			}
			
			if (updateSolider)
			{
				removeTextSolider();
				AddEquipsToSlot();
			}
			
			//trace("curSoldier.Id" + curSoldier.Id);
			if (curSoldier)
			{
				curIdSoldier = curSoldier.Id;
				
				var nameSoldier:String = "Tiểu " + Ultility.GetNameElement(curSoldier.Element) + " Ngư";
				if (curSoldier.nameSoldier != null && curSoldier.nameSoldier != "")
				{
					nameSoldier = curSoldier.nameSoldier;
				}
				
				labelSoldierName = AddLabel(nameSoldier, 210, 210, 0xffffff, 0);
				var txtFormat:TextFormat = new TextFormat("arial", 13, 0xffff00, true);
				labelSoldierName.setTextFormat(txtFormat);
				labelSoldierName.defaultTextFormat = txtFormat;
				
				var levelSoldier:String = "Cấp " + curSoldier.Rank + " - " + Localization.getInstance().getString("FishSoldierRank" + curSoldier.Rank);
				labelSoldierLevel = AddLabel(levelSoldier, 196, 310, 0xFFFF00, 0);
				var txtFormatLevel:TextFormat = new TextFormat("arial", 13, 0xFFFF00, true, null, null, null, null, "center");
				labelSoldierLevel.autoSize = TextFieldAutoSize.CENTER
				labelSoldierLevel.setTextFormat(txtFormatLevel);
				labelSoldierLevel.defaultTextFormat = txtFormatLevel;
				labelSoldierLevel.filters = [glow];
				
				UpdateFishContent();
				UpdateStart();
			}
			else
			{
				var labelSoldierReport:TextField = AddLabel("Bạn không có  ngư thủ nào", 150, 260, 0xffffff, 0);
				var txtFormatReport:TextFormat = new TextFormat("arial", 14, 0x000000, true);
				labelSoldierReport.setTextFormat(txtFormatReport);
				labelSoldierReport.defaultTextFormat = txtFormatReport;
			}
			AddInfo();
			
			btnBackSolider = AddButton(BTN_BACK_SOLIDER, "GuiWareRoomLinhThach_Btn_Down", 190, 270, this);
			btnBackSolider.img.scaleX = btnBackSolider.img.scaleY = 0.7;
			btnBackSolider.img.rotation += 90;
			btnNextSolider = AddButton(BTN_NEXT_SOLIDER, "GuiWareRoomLinhThach_Btn_Up", 350, 270, this);
			btnNextSolider.img.scaleX = btnNextSolider.img.scaleY = 0.7;
			btnNextSolider.img.rotation += 90;
			
			if (arrSolider == null || arrSolider.length < 2 || !Ultility.IsInMyFish())
			{
				btnBackSolider.SetVisible(false);
				btnNextSolider.SetVisible(false);
			}
		}
		
		private function removeTextSolider():void
		{
			if (labelSoldierName && img)
			{
				img.removeChild(labelSoldierName);
			}
			if (labelSoldierLevel && img)
			{
				img.removeChild(labelSoldierLevel);
			}
			LabelArr.splice(0, LabelArr.length);
			labelSoldierName = null;
			labelSoldierLevel = null;
		}
		
		private function UpdateFishContent():void
		{
			var s:String;
			var i:int;
			
			AddActor();
			
			for (s in curSoldier.EquipmentList)
			{
				//trace("s===== " + s + " |EquipmentList[s].length== " + curSoldier.EquipmentList[s].length);
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					//trace("curSoldier.EquipmentList[s][i] == " + curSoldier.EquipmentList[s][i]);
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(eq);
				}
			}
		}
		
		private function AddActor():void
		{
			if (curSoldierImg)
			{
				if (curSoldierImg.img)
				img.removeChild(curSoldierImg.img);
			}
			
			if (curSoldier.EquipmentList.Mask[0])
			{
				curSoldierImg = AddImage("", curSoldier.EquipmentList.Mask[0].TransformName, 0, 0);
				curSoldierImg.img.mouseChildren = false;
				curSoldierImg.img.mouseEnabled = false;
				curSoldierImg.img.parent.mouseEnabled = false;
			}
			else
			{
				curSoldierImg = AddImage("", Fish.ItemType + curSoldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 0, 0);
				curSoldierImg.img.parent.mouseEnabled = false;
				curSoldierImg.img.mouseChildren = false;
				curSoldierImg.img.mouseEnabled = false;
			}
			
			curSoldierImg.FitRect(100, 100, new Point (200, 230));
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		public function ChangeEquipment(eq:FishEquipment):void
		{
			var Type:String = eq.Type;
			var resName:String = eq.imageName;
			var color:int = eq.Color;
			
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(curSoldierImg.img, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.parent = child.parent as Sprite;
				eq.index = index;
				eq.oldChild = child;
				eq.Color = color;
				eq.loadComp = function f():void
				{
					var dob:DisplayObject = this.parent.addChildAt(this.img, this.index);
					dob.name = Type;
					if (this.oldChild != null && this.parent.contains(this.oldChild))
					this.parent.removeChild(this.oldChild);
					FishSoldier.EquipmentEffect(dob, this.Color);
				}
				eq.loadRes(resName);
			}
			if (eq.Type == "Seal")
			{
				if (wings != null && curSoldierImg.img.contains(wings.img))
				{
					curSoldierImg.img.removeChild(wings.img);
				}
				
				var activeRowSeal:int = Ultility.getActiveRowSeal(eq, curSoldier);
				if (activeRowSeal > 0)
				{
					wings = new FishWings(curSoldierImg.img, "Wings" + eq.Rank + activeRowSeal);
					curSoldierImg.img.setChildIndex(wings.img, 0);
					switch(curSoldier.Element)
					{
						case 4:
						case 2:
						case 1:
							wings.img.y = -30;
							wings.img.x = 16;
							break;
						case 3:
							wings.img.y = -40;
							wings.img.x = -16;
							break;
						case 5:
							wings.img.y = -25;
							wings.img.x = 20;
							break;
					}
				}
			}
		}
		
		private function UpdateAllFishArr():void
		{
			var mySoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			//trace("UpdateAllFishArr() mySoldier.length== " + mySoldier.length);
			for (var i:int = 0; i < mySoldier.length; i++)
			{
				if (mySoldier[i].Id == curSoldier.Id)
				{
					mySoldier[i].EquipmentList = curSoldier.EquipmentList;
					mySoldier[i].bonusEquipment = curSoldier.bonusEquipment;
					break;
				}
			}
		}
		
		private function AddInfo():void
		{
			/*if (!ctnBonus)
			{
				ctnBonus = AddContainer(CTN_INFO, "GuiWareRoomLinhThach_ImgFrameFriend", 120, 434);
			}
			else
			{
				ctnBonus = GetContainer("GuiWareRoomLinhThach_ImgFrameFriend")
			}*/
			
			ctnBonus.ClearComponent();
			//RemoveContainer(CTN_INFO);
			
			var dmgTotal:int = 0;
			var critTotal:Number = 0;
			var vitTotal:int = 0;
			var defTotal:int = 0;
			
			if (curSoldier)
			{
				if (curSoldier.bonusEquipment == null)
				{
					//trace("AddInfo() tren curSoldier.bonusEquipment== " + curSoldier.bonusEquipment);
					dmgTotal = curSoldier.Damage;
					critTotal = curSoldier.Critical;
					vitTotal = curSoldier.Vitality;
					defTotal = curSoldier.Defence;
				}
				else 
				{
					//trace("AddInfo() duoi curSoldier.bonusEquipment== " + curSoldier.bonusEquipment);
					dmgTotal = curSoldier.getTotalDamage();
					critTotal = curSoldier.getTotalCritical();
					vitTotal = curSoldier.getTotalVitality();
					defTotal = curSoldier.getTotalDefence();
				}
				//trace("AddInfo() dmgTotal== " + dmgTotal + " |getTotalDamage()== " + curSoldier.getTotalDamage());
			}
			
			var tF:TextField;
			var txtF:TextFormat;
			
			tF = ctnBonus.AddLabel(dmgTotal + "", 75, 80, 0xFFFFFF, 0, 0x603813);
			
			if (curSoldier)
			{
				if (dmgTotal > curSoldier.Damage)
				{
					txtF = new TextFormat();
					txtF.color = 0x00ff00;
					tF.setTextFormat(txtF);
				}
				else if (dmgTotal < curSoldier.Damage)
				{
					txtF = new TextFormat();
					txtF.color = 0xff0000;
					tF.setTextFormat(txtF);
				}
			}
			
			tF = ctnBonus.AddLabel(defTotal + "", 75, 108, 0xFFFFFF, 0, 0x603813);
			if (curSoldier)
			{
				if (defTotal > curSoldier.Defence)
				{
					txtF = new TextFormat();
					txtF.color = 0x00ff00;
					tF.setTextFormat(txtF);
				}
				else if (defTotal < curSoldier.Defence)
				{
					txtF = new TextFormat();
					txtF.color = 0xff0000;
					tF.setTextFormat(txtF);
				}
			}
			
			tF = ctnBonus.AddLabel(critTotal + "", 240, 80, 0xFFFFFF, 0, 0x603813);
			if (curSoldier)
			{
				if (critTotal > curSoldier.Critical)
				{
					txtF = new TextFormat();
					txtF.color = 0x00ff00;
					tF.setTextFormat(txtF);
				}
				else if (critTotal < curSoldier.Critical)
				{
					txtF = new TextFormat();
					txtF.color = 0xff0000;
					tF.setTextFormat(txtF);
				}
			}
			
			tF = ctnBonus.AddLabel(vitTotal + "", 240, 108, 0xFFFFFF, 0, 0x603813);
			if (curSoldier)
			{
				if (vitTotal > curSoldier.Vitality)
				{
					txtF = new TextFormat();
					txtF.color = 0x00ff00;
					tF.setTextFormat(txtF);
				}
				else if (vitTotal < curSoldier.Vitality)
				{
					txtF = new TextFormat();
					txtF.color = 0xff0000;
					tF.setTextFormat(txtF);
				}
			}
		}
		
		/**
		 * Show all slots to wear clothes
		 */
		private function ShowSlots():void
		{
			InteractiveCtn.splice(0, InteractiveCtn.length);
			
			if (!ItemPos)
			{
				ItemPos = new Object();
				// Fix positions of slots
				ItemPos.Quartz_1 = new Point(200, 85);		// coordinate of ctn Quartz_1
				ItemPos.Quartz_2 = new Point(315, 130);		// coordinate of ctn Quartz_2
				ItemPos.Quartz_3 = new Point(355, 230);		// coordinate of ctn Quartz_3
				ItemPos.Quartz_4 = new Point (310, 330);	// coordinate of ctn Quartz_4
				ItemPos.Quartz_5 = new Point (205, 380);	// coordinate of ctn Quartz_5
				ItemPos.Quartz_6 = new Point (95, 335);	// coordinate of ctn Quartz_6
				ItemPos.Quartz_7 = new Point (55, 232);	// coordinate of ctn Quartz_7
				ItemPos.Quartz_8 = new Point (95, 130);	// coordinate of ctn Quartz_8 1
			}
			
			ctnQuartz_1 = AddContainer(CTN_QUARTZ_1, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_1.x, ItemPos.Quartz_1.y, true, this);
			InteractiveCtn.push(ctnQuartz_1);
			ctnQuartz_2 = AddContainer(CTN_QUARTZ_2, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_2.x, ItemPos.Quartz_2.y, true, this);
			InteractiveCtn.push(ctnQuartz_2);
			ctnQuartz_3 = AddContainer(CTN_QUARTZ_3, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_3.x, ItemPos.Quartz_3.y, true, this);
			InteractiveCtn.push(ctnQuartz_3);
			ctnQuartz_4 = AddContainer(CTN_QUARTZ_4, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_4.x, ItemPos.Quartz_4.y, true, this);
			InteractiveCtn.push(ctnQuartz_4);
			ctnQuartz_5 = AddContainer(CTN_QUARTZ_5, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_5.x, ItemPos.Quartz_5.y, true, this);
			InteractiveCtn.push(ctnQuartz_5);
			ctnQuartz_6 = AddContainer(CTN_QUARTZ_6, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_6.x, ItemPos.Quartz_6.y, true, this);
			InteractiveCtn.push(ctnQuartz_6);
			ctnQuartz_7 = AddContainer(CTN_QUARTZ_7, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_7.x, ItemPos.Quartz_7.y, true, this);
			InteractiveCtn.push(ctnQuartz_7);
			ctnQuartz_8 = AddContainer(CTN_QUARTZ_8, "GuiWareRoomLinhThach_ItemGhepBg", ItemPos.Quartz_8.x, ItemPos.Quartz_8.y, true, this);
			InteractiveCtn.push(ctnQuartz_8);
		}
		
		/**
		 * Add current Equips of fishes
		 */
		private function AddEquipsToSlot():void
		{
			//trace("AddEquipsToSlot() slotObjData== " + GuiMgr.getInstance().guiTrungLinhThach.slotObjData);
			var k:int;
			if (curSoldier)
			{
				//trace("curSoldier.Id== " + curSoldier.Id);
				slotData.splice(0, slotData.length);
				var curItem:Object = curSoldier.EquipmentList;
				var dataServer:Object = GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id];
				listOriginal = new Object();
				listCopyData = new Object();
				if (dataServer)
				{
					for (var h:int = 1; h < 9; h++)
					{
						if (dataServer[h])
						{
							//trace("dataSlot " + h + " data== " + GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][h] + " |Id== " + GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][h].Id + " |QuartzType== " + GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][h].QuartzType);
							var data:Object = new Object()
							data.slot = h;
							data.Id = GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][h].Id;
							data.QuartzType = GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][h].QuartzType;
							slotData.push(data);
						}
						if (dataServer[h])
						{
							listOriginal[h] = dataServer[h]["Id"];
							listCopyData[h] = dataServer[h]["Id"];
						}
						else
						{
							listOriginal[h] = 0;
							listCopyData[h] = 0;
						}
					}
					//trace("slotData.length== " + slotData.length);
				}
			}
			var s:String;
			var i:int = 0;
			dataQuartz.splice(0, dataQuartz.length);
			
			for (k = 0; k < InteractiveCtn.length; k++)
			{
				InteractiveCtn[k].ClearComponent();
				var obj:Object = new Object();
				dataQuartz.push(obj);
			}
			//trace("curSoldier.Id=============== " + curSoldier.Id);
			//trace("dataQuartz.length== " + dataQuartz.length);
			for (s in curItem)
			{
				for (k = 0; k < curItem[s].length; k ++)
				{
					//trace("s== " + s + " |k== " + k + " |curItem[s][k]== " + curItem[s][k]);
					if (curItem[s][k])
					{
						//trace("Co data curItem[s][k].Id== " + curItem[s][k].Id + " |curItem[s][k].Type== " + curItem[s][k].Type + " |slotData.length== " + slotData.length);
						for (var j:int = 0; j < slotData.length; j++ )
						{
							//trace("slotData[j].Id== " + slotData[j].Id + " |slotData[j].QuartzType== " + slotData[j].QuartzType + " |slotData[j].slot== " + slotData[j].slot);
							if (slotData[j].Id == curItem[s][k].Id && slotData[j].QuartzType == curItem[s][k].Type)
							{
								//trace("nhan tai======================= " + slotData[j].slot);
								var indexArr:int = slotData[j].slot - 1;
								dataQuartz[indexArr] = curItem[s][k];
							}
						}
						i++;
					}
				}
			}
			//trace("dataQuartz.length== " + dataQuartz.length);
			dawItemSoldier();
		}
		
		private function dawItemSoldier():void
		{
			var index:int = 0;
			var numSlot:int = 0;
			var ctn:Container;
			var tooltipFormat:TooltipFormat;
			for (var j:int = 0; j < dataQuartz.length; j++)
			{
				index++;
				
				ctn = this["ctnQuartz_" + index];// GetContainer("Ctn_Quartz_" + index);
				ctn.IdObject = "Ctn_Quartz_" + index;
				var RequireLevel:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Slot")[index]["RequireLevel"];
				var userLevel:int = 0;// curSoldier.Rank;// GameLogic.getInstance().user.GetLevel();
				if (curSoldier)
				{
					userLevel = curSoldier.Rank;
				}
				//trace("userLevel== " + userLevel + " |RequireLevel== " + RequireLevel);
				if (userLevel >= RequireLevel)
				{
					numSlot++;
					ctn.isLook = true;
					//trace("dawItemSoldier dataQuartz[j].Id== " + dataQuartz[j].Id);
					if (dataQuartz[j].Id)
					{
						//trace(">>>>>>>>>>>>>Type== " + dataQuartz[j].Type + " |dataQuartz[j].ItemId=== " + dataQuartz[j].ItemId);
						curIdLinhThach = 10;
						var imageNen:Image  = ctn.AddImage("", "Bg_Item_" + dataQuartz[j].Type, 41, 46);
						imageNen.img.cacheAsBitmap = false;
						var imag:Image = null;
						
						/*if (dataQuartz[j].ItemId > 4)
						{
							dataQuartz[j].ItemId = 0;
						}*/
						var imagName:String = dataQuartz[j].Type + dataQuartz[j].ItemId;
						var tF:TextFormat = new TextFormat();
						var imag1:Image = ctn.AddImage(dataQuartz[j].Id, imagName, 43, 51);
						//trace("imagName== " + imagName + " |index== " + index + " |Level== " + dataQuartz[j].Level);
						
						var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
						var labelNumber:TextField = ctn.AddLabel(Ultility.StandardNumber(dataQuartz[j].Level), -8, 1, 0xFFFF00, 0);
						labelNumber.autoSize = TextFieldAutoSize.CENTER
						labelNumber.filters = [glow];
						
						var updateLevel:Button = ctn.AddButton("item_" + j, "GuiWareRoomLinhThach_UpdateLevel", 34, 82);
						updateLevel.setTooltipText("Nâng cấp Huy Hiệu");
						updateLevel.img.addEventListener(MouseEvent.CLICK, clickPopupUpdateLevel);
						updateLevel.img.tabIndex = j;
						updateLevel.img.name = j + "_" + index;
						
						/*var GuiToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
						var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
						GuiToolTip.Init(dataQuartz[j]);
						GuiToolTip.InitPos(ctn, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
						ctn.setGUITooltip(GuiToolTip);*/
						ctn.isQuartz = true;
						
					}
					else
					{
						//trace("khong co hinh anh gi ca==============");
						ctn.isQuartz = false;
					}
				}
				else
				{
					ctn.isLook = false;
					var itemLook:Image = ctn.AddImage("", "GuiWareRoomLinhThach_lookItem", 43, 43);
					
					var numRequireLevel:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Slot")[j + 1].RequireLevel;
					var txtNumLevel:TextField = ctn.AddLabel("Cấp " + Ultility.StandardNumber(numRequireLevel), 20, 60, 0xffffff, 0);
					tooltipFormat = new TooltipFormat();
					tooltipFormat.text = "Cấp Ngư Thủ " + Ultility.StandardNumber(numRequireLevel) + " mới mở";
					ctn.setTooltip(tooltipFormat);
				}
			}
			
			maxSlotId = numSlot;
		}
		
		/**
		 * Return number of slots for each type of equipment
		 * @param	type
		 * @return
		 */
		private function GetNumSlotEachType(type:String):int
		{
			//trace("type== " + type);
			switch (type)
			{
				case CTN_QUARTZ_WHITE:
				case CTN_QUARTZ_GREEN:
				case CTN_QUARTZ_YELLOW:
				case CTN_QUARTZ_PURPLE:
					return 8;
			}
			return 0;
		}
		
		private function overUpdateQWareroom(event:MouseEvent):void
		{
			//trace("-----------overUpdateQWareroom");
			//GuiToolTipItem.Hide();
		}
		
		private function clickPopupUpdateQWareroom(event:MouseEvent):void
		{
			//trace("-----------clickPopupUpdateQWareroom() == " + isUpdate);
			if (isUpdate)
			{
				processChangeClothes();
				GuiMgr.getInstance().guiUpdateLinhThach.showGUI(0, dataEquip[event.currentTarget.tabIndex].Type, dataEquip[event.currentTarget.tabIndex], 0);
			}
		}
		
		private function clickPopupUpdateLevel(event:MouseEvent):void
		{
			if (isUpdate)
			{
				processChangeClothes();
				var objItem:FishEquipment = dataQuartz[event.currentTarget.tabIndex];			
				//trace("clickPopupUpdateLevel name== " + event.currentTarget.name);
				var a:Array = event.currentTarget.name.split("_");
				//trace("a[0]== " + a[0] + " |a[1]== " + a[1]);
				GuiMgr.getInstance().guiUpdateLinhThach.showGUI(curIdSoldier, objItem.Type, objItem, a[1]);
			}
		}
		
		public override function OnButtonDown(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			idItemQuartz = a[3];
			var imagName:String = a[1] + a[2];
			//trace("OnButtonDown buttonID== " + buttonID);
			switch (a[0])
			{
				case "CtnItemTrung":
					
					//trace("case CtnItemTrung: imagName== " + imagName)
					curEquipImage = new Image(this.img, imagName);
					curEquipImage.img.startDrag();
					curEquipImage.img.mouseEnabled = false;
					curEquipImage.img.x = event.stageX - curEquipImage.img.width / 2 - this.CurPos.x;
					curEquipImage.img.y = event.stageY - curEquipImage.img.height / 2 - this.CurPos.y;
					img.addEventListener(MouseEvent.MOUSE_UP, OnReleaseItem);
					lastTimeCtn = buttonID;
					//trace("case CtnItemTrung:== " + id);
					Mouse.cursor = MouseCursor.HAND;
					break;
				case "Ctn":
					lastItemCtn = a[0];
					break;
			}
			
			if (GameLogic.getInstance().CurServerTime - lastTimeClick < DOUBLE_CLICK_TIMER && lastTimeCtn == buttonID)
			{
				var container:Container = GetContainer(buttonID);
				var idItem:int = a[3];
				curSlotIdAll = 0;
				ProcessWare(container, idItem);
				
				if (curEquipImage)
				{
					if (curEquipImage.img != null && curEquipImage.img.parent == img)
					{
						curEquipImage.img.stopDrag();
						img.removeChild(curEquipImage.img);
						curEquipImage.Destructor();
					}
				}
					
				lastTimeClick = 0;
			}
			else if (GameLogic.getInstance().CurServerTime - lastTimeClick < DOUBLE_CLICK_TIMER && lastItemCtn == a[0])
			{
				var containerRemove:Container = this["ctnQuartz_" + a[2]];// GetContainer(buttonID);
				
				if (containerRemove.isLook && containerRemove.isQuartz)
				{
					//trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>du dieu kien remove");
					var indexItemCtn:int = a[2];
					if (indexItemCtn > 0)
					{
						ProcessUnware(indexItemCtn);
						lastTimeClick = 0;
					}
					else
					{
						lastTimeClick = GameLogic.getInstance().CurServerTime;
					}
				}
				else
				{
					if (!containerRemove.isLook)
					{
						var message:String = '';
						if (curSoldier)
						{
							message = 'Ngư thủ của bạn chưa đủ cấp độ mở khóa!';
						}
						else
						{
							message = 'Bạn chưa có ngư thủ để trang bị!';
						}
						GuiMgr.getInstance().GuiMessageBox.ShowOK(message);
					}
				}
			}
			else
			{
				lastTimeClick = GameLogic.getInstance().CurServerTime;
				if (curEquipImage)
				{
					if (curEquipImage.img != null && curEquipImage.img.parent == img)
					{
						curEquipImage.img.mouseEnabled = false;
						curEquipImage.img.mouseChildren = false;
					}
				}
			}
		}
		
		
		private function OnReleaseItem(event:MouseEvent):void
		{
			//trace("------------------OnReleaseItem");
			//trace("isWare== " + isWare + " |curSoldier== " + curSoldier);
			Mouse.cursor = MouseCursor.AUTO;
			// Remove listener
			img.removeEventListener(MouseEvent.MOUSE_UP, OnReleaseItem);
			
			if (isWare && curSoldier)
			{
				var curItem:Object = curSoldier.EquipmentList;
				var s:String;
				//trace("isWare== " + isWare + " |curSoldier== " + curSoldier);
				for (s in curItem)
				{
					var isProcessWare:Boolean = false;
					for (var k:int = 0; k < GetNumSlotEachType("Ctn_" + s); k++)
					{
						var target:Container = this["ctnQuartz_" + (k + 1)];//GetContainer("Ctn_Quartz_" + (k + 1));
						//trace("curEquipImage.img== " + curEquipImage.img);
					//	trace("target.img== " + target.img);
						if (curEquipImage.img != null && target.img != null && !target.isQuartz)
						{
							if(curEquipImage.img.hitTestObject(target.img))// if collision detected
							{
								//trace("2 diem gap nhau roi===========");
								curSlotIdAll = k + 1
								isProcessWare = true;
								break;
							}
						}
					}
					
					if (isProcessWare)
					{
						break;
					}
				}
				//trace("isProcessWare== " + isProcessWare + " |curSoldier== " + curSoldier);
				if (isProcessWare && curSoldier)
				{
					//trace("tha vao dung roi curSlotIdAll== " + curSlotIdAll);
					ProcessWare(target, idItemQuartz);
				}
				else if (!isProcessWare && curSoldier) // Nếu ko thả trúng ô nào -> check xem thả vào cá hay không
				{
					//trace("--------Tha khong dung");
				}
			}
			else
			{
				
			}
			
			AddInfo();
			
			// Remove the image follow the mouse
			if (curEquipImage)
			{
				if (curEquipImage.img != null && curEquipImage.img.parent == img)
				{
					curEquipImage.img.stopDrag();
					img.removeChild(curEquipImage.img);
					curEquipImage.Destructor();
				}
			}
			
			//curEquip = null;
			isReleaseItem = true;
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var a:Array = buttonID.split("_");
			switch (a[0])
			{
				case "Ctn":
					var index:int = 0;
					index = a[2];
					GuiMgr.getInstance().guiTooltipEgg.showGUI(dataQuartz[index - 1], event.stageX, event.stageY);
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			GuiMgr.getInstance().guiTooltipEgg.Hide();
			isReleaseItem = false;
		}
		
		private function ProcessUnware(slotId:int):void
		{
			var indexArr:int = slotId - 1;
			
			listCopyData[slotId] = 0;
			
			var ctn:Container = this["ctnQuartz_" + slotId];
			if (ctn)
			{
				ctn.ClearComponent();
				//ctn.guiTooltip.Hide();
				//ctn.guiTooltip = null;
			}
			ctn.isQuartz = false;
			for (var i:int = 0; i < curSoldier.EquipmentList[dataQuartz[indexArr].Type].length; i++)
			{
				if (curSoldier.EquipmentList[dataQuartz[indexArr].Type][i].Type == dataQuartz[indexArr].Type
				&& curSoldier.EquipmentList[dataQuartz[indexArr].Type][i].Id == dataQuartz[indexArr].Id)
				{
					curSoldier.EquipmentList[dataQuartz[indexArr].Type].splice(i, 1);
					break;
				}
			}
			
			var obj:FishEquipment = dataQuartz[indexArr];
			var olData:Object = new Object();
			updateCurSoldier(obj, false, indexArr);
			var slotObjData:Object = GuiMgr.getInstance().guiTrungLinhThach.slotObjData;
			if (slotObjData[curIdSoldier])
			{
				for (var itm:String in slotObjData[curIdSoldier])
				{
					if (slotObjData[curSoldier.Id][itm].QuartzType == dataQuartz[indexArr].Type
						&& slotObjData[curSoldier.Id][itm].Id == dataQuartz[indexArr].Id)
						{
							delete(GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][itm]);
						}
				}
			}
			
			GameLogic.getInstance().user.UpdateQuartzToStore(dataQuartz[indexArr], true);
			
			curSoldier.UpdateBonusEquipment();
			AddInfo();
			filterListEquip(dataQuartz[indexArr].Type, true);
			
			isUpdate = true;
			
			UpdateStart();
		}
		
		private function ProcessWare(ctn:Container, itemId:int):void
		{
			if (!curSoldier) return;
			
			var objData:Object = GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id];
			
			var slotIDAdd:int = 0;
			var i:int = 1;
			if (curSoldier)
			{
				isUpdate = true;
				if (curSlotIdAll == 0)
				{
					//trace("maxSlotId=== " + maxSlotId);
					if (GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id])
					{
						for (i = 1; i < maxSlotId + 1; i++)
						{
							if (GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][i])
							{
								//trace("dataSlot " + i + " data== " + GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][i]);
							}
							else
							{
								slotIDAdd = i;
								//trace("Khong co data trong slot===== i==== " + i);
								i = maxSlotId;
							}
						}
					}
					else
					{
						//trace("else  slot===== i==== " + i);
						slotIDAdd = i;
					}
				}
				else
				{
					slotIDAdd = curSlotIdAll;
				}
				//trace("slotIDAdd== " + slotIDAdd);
				if (slotIDAdd == 0 || slotIDAdd > maxSlotId)
				{
					return;
				}
				
				var dataAdd:Object = GameLogic.getInstance().user.getItemStore(curTabQuartz, itemId);

				listCopyData[slotIDAdd] = itemId;
				
				var ctn:Container = this["ctnQuartz_" + (slotIDAdd)];
				if (ctn)
				{
					ctn.ClearComponent();
					
					//trace("receiveAddQuartz== " + Data["oQuartz"]["Type"]);
					var imageNen:Image  = ctn.AddImage("", "Bg_Item_" + curTabQuartz, 41, 46);
					imageNen.img.cacheAsBitmap = false;
					var imagName:String = dataAdd.Type + dataAdd.ItemId; 
					var tF:TextFormat = new TextFormat();
					var imag1:Image = ctn.AddImage(dataAdd.Id, imagName, 43, 51);
					//var imag1:Image = ctn.AddImage("", imagName, 43, 51);
					
					var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
					var labelNumber:TextField = ctn.AddLabel(Ultility.StandardNumber(dataAdd.Level), -8, 1, 0xFFFF00, 0);
					labelNumber.autoSize = TextFieldAutoSize.CENTER
					labelNumber.filters = [glow];
					
					var index:int = slotIDAdd - 1;
					var updateLevel:Button = ctn.AddButton("item_" + index, "GuiWareRoomLinhThach_UpdateLevel", 34, 82);
					updateLevel.setTooltipText("Nâng cấp Huy Hiệu");
					updateLevel.img.addEventListener(MouseEvent.CLICK, clickPopupUpdateLevel);
					updateLevel.img.tabIndex = index;
					updateLevel.img.name = index + "_" + slotIDAdd;
					
					/*var GuiToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
					var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
					GuiToolTip.Init(dataAdd);
					GuiToolTip.InitPos(ctn, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
					ctn.setGUITooltip(GuiToolTip);*/
					ctn.isQuartz = true;
				}
				
				var item:Object = new Object();
				item.QuartzType = curTabQuartz;
				item.Id = itemId;
				
				if (GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id])
				{
					//trace("Add vi đa co == " + item);
					GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][slotIDAdd] = item;
				}
				else
				{
					//trace("Add vi chua co== " + item);
					GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id] = new Object()
					GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id][slotIDAdd] = item;
				}
				
				var obj:FishEquipment = new FishEquipment();
				obj.Id = dataAdd.Id;
				obj.Type = dataAdd.Type;
				obj.Level = dataAdd.Level;
				obj.ItemId = dataAdd.ItemId;
				obj.Point = dataAdd.Point;
				
				var dataStore:Object = GameLogic.getInstance().user.loadFunctionQuartz(obj.ItemId, obj.Type, obj.Level);
					
				obj.Damage = dataStore.Damage;
				obj.OptionDamage = dataStore.OptionDamage;
				
				obj.Defence = dataStore.Defence;
				obj.OptionDefence = dataStore.OptionDefence;
				
				obj.Critical = dataStore.Critical;
				obj.OptionCritical = dataStore.OptionCritical;
				
				obj.Vitality = dataStore.Vitality;
				obj.OptionVitality = dataStore.OptionVitality;
				
				
				//trace("Push data obj.Type== " + obj.Type + " |obj.Id== " + obj.Id);
				//curSoldier.EquipmentList[obj.Type].push(obj);
				
				updateCurSoldier(obj, true, 0);
				
				GameLogic.getInstance().user.UpdateQuartzToStore(obj, false);
				filterListEquip(curTabQuartz, true);
				
				var indexArr:int = slotIDAdd - 1;
				dataQuartz[indexArr] = obj;
				curSoldier.UpdateBonusEquipment();
				AddInfo();
				isUpdate = true;
				UpdateStart();
			}
		}
		
		public function receiveAddQuartz():void
		{
			
		}
		
		public function receiveRemoveQuartz():void
		{
			
		}
		
		private function UpdateStart():void
		{
			var i:int;
			var s:String;
			var quartId:int;
			var quartType:String;
			var obj:Object = { "QWhite":1, "QGreen":2, "QYellow":3, "QPurple":4, "QVIP":5 };
			for (s in curSoldier.EquipmentList)
			{
				/*for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					ChangeEquipment(curSoldier.EquipmentList[s][i]);
				}*/
				
				if (obj[s] != null &&  curSoldier.EquipmentList[s].length > 0 && obj[s] > quartId)
				{
					quartId = obj[s];
					quartType = s;
				}
			}
			
			if (ctnQuart != null)
			{
				ctnQuart.ClearComponent();
			}
			if (quartType != null)
			{
				var maxId:int;
				for (i = 0; i < curSoldier.EquipmentList[quartType].length; i++)
				{
					if (curSoldier.EquipmentList[quartType][i]["ItemId"] > maxId)
					{
						maxId = curSoldier.EquipmentList[quartType][i]["ItemId"];
					}
				}
				var numStar:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[quartType][maxId]["Star"];				
				if(ctnQuart == null)
				{
					ctnQuart = new Container(img, "", 260, 268);
					ctnQuart.LoadRes("");
				}
				ctnQuart.ClearComponent();
				for (i = 0; i < numStar; i++)
				{
					ctnQuart.AddImage("", "Ic" + quartType.substring(1, quartType.length) + "Star", (i - numStar / 2) * 17, -64);
					//trace(("Ic" + quartType.substring(1, quartType.length) + "Star") , ((i - numStar / 2) * 17));
				}
				img.addChild(ctnQuart.img);
			}
		}
		
		private function updateCurSoldier(obj:Object, isPush:Boolean, index:int):void
		{
			var soldierInLake:FishSoldier;
			for (var i:int = 0; i < GameLogic.getInstance().user.FishSoldierArr.length; i++)
			{
				if (GameLogic.getInstance().user.FishSoldierArr[i].Id == curSoldier.Id)
				{
					soldierInLake = GameLogic.getInstance().user.FishSoldierArr[i];
					if (isPush)
					{
						soldierInLake.EquipmentList[obj.Type].push(obj);
					}
					else
					{						
						for (var k:int = 0; k < soldierInLake.EquipmentList[obj.Type].length; k++ )
						{
							if (soldierInLake.EquipmentList[obj.Type][k])
							{
								if (soldierInLake.EquipmentList[obj.Type][k].Type == obj.Type
								&& soldierInLake.EquipmentList[obj.Type][k].Id == obj.Id)
								{
									soldierInLake.EquipmentList[obj.Type].splice(k, 1);
									break;
								}
							}
						}
					}
					break;
				}
			}
			
			var soldierMyAll:FishSoldier = null;
			var allSoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			for (var j:int = 0; j < allSoldier.length; j++)
			{
				if (allSoldier[j].Id == curSoldier.Id)
				{
					var isLuu:Boolean = true;
					soldierMyAll = allSoldier[j];
					if (isPush)
					{
						var data:Array = soldierMyAll.EquipmentList[obj.Type];
						for (var h:int = 0; h < data.length; h++)
						{
							if (data[h].Type == obj.Type && data[h].Id == obj.Id)
							{
								isLuu = false;
							}
						}
						
						if (isLuu)
						{
							soldierMyAll.EquipmentList[obj.Type].push(obj);
						}
					}
					else
					{
						//soldierInLake.EquipmentList[obj.Type].splice(index, 1);
					}
					break;
				}
			}
			
		}
		
		private function updateImgFishSoldier():void
		{
			//trace("updateImgFishSoldier() curSoldier.Id== " + curSoldier.Id);
			var soldierInLake:FishSoldier = null;
			for (var i:int = 0; i < GameLogic.getInstance().user.FishSoldierArr.length; i++)
			{
				if (GameLogic.getInstance().user.FishSoldierArr[i].Id == curSoldier.Id)
				{
					soldierInLake = GameLogic.getInstance().user.FishSoldierArr[i];
					break;
				}
			}
			//trace("updateImgFishSoldier() soldierInLake== " + soldierInLake);
			if (soldierInLake != null)
			{
				//trace("goi vao ham soldierInLake.RefreshImg()");
				soldierInLake.RefreshImg();
			}
		}
		
		private function processChangeClothes():void
		{
			if (curSoldier)
			{
				updateImgFishSoldier();
			}
			
			var listRemove:Array=[];
			var listAdd:Array = [];
			var idData:int;
			/*tìm mảng remove*/
			if (!listCopyData || !listOriginal) return;
			
			for (var i:int = 1; i <= 8; i++)
			{
				if (listCopyData[i] != listOriginal[i])
				{
					if (listOriginal[i])
					{
						listRemove.push(i);
					}
				}
			}
			/*tìm mảng add*/
			for (i = 1; i <= 8; i++)
			{
				if (listCopyData[i] != listOriginal[i])
				{
					if (listCopyData[i])
					{
						idData = listCopyData[i];
						var p:Point = new Point(idData, i);//p.x: Id huy hiệu, p.y: SlotId
						listAdd.push(p);
					}
				}
				listOriginal[i] = listCopyData[i];
			}
			for (var j:int = 0; j < listRemove.length; j++ )
			{
				var cmd:SendRemoveQuartzFromSoldier = new SendRemoveQuartzFromSoldier();
				cmd.SoldierId = curSoldier.Id;
				cmd.SlotId = listRemove[j];
				Exchange.GetInstance().Send(cmd);
			}
			
			for (var k:int = 0; k < listAdd.length; k++ )
			{
				var obj:Object = GuiMgr.getInstance().guiTrungLinhThach.slotObjData[curSoldier.Id];
				var data:Object = obj[listAdd[k].y];
				var cmdStore:SendAddQuartzToSoldier = new SendAddQuartzToSoldier();
				cmdStore.SoldierId = curSoldier.Id;
				cmdStore.QuartzType = data.QuartzType;
				cmdStore.Id = listAdd[k].x;
				cmdStore.SlotId = listAdd[k].y;
				Exchange.GetInstance().Send(cmdStore);
			}
			
		}
		
		public function updateWareromm(obj:Object, curIdSoldier:int, slotIndex:int):void
		{
			//trace("updateWareromm type== " + obj.Type);
			filterListEquip(obj.Type, true);
			
			if (curIdSoldier > 0)
			{
				
				if(slotIndex > 0)
				{
					var ctn:Container = this["ctnQuartz_" + slotIndex];
					
					ctn.ClearComponent();
					
					var imageNen:Image  = ctn.AddImage("", "Bg_Item_" + obj.Type, 41, 46);
					imageNen.img.cacheAsBitmap = false;
					var imagName:String = obj.Type + obj.ItemId; 
					var tF:TextFormat = new TextFormat();
					var imag1:Image = ctn.AddImage(obj.Id, imagName, 43, 51);
					
					var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
					var labelNumber:TextField = ctn.AddLabel(Ultility.StandardNumber(obj.Level), -8, 1, 0xFFFF00, 0);
					labelNumber.autoSize = TextFieldAutoSize.CENTER
					labelNumber.filters = [glow];
					
					var index:int = slotIndex - 1;
					var updateLevel:Button = ctn.AddButton("item_" + index, "GuiWareRoomLinhThach_UpdateLevel", 34, 82);
					updateLevel.setTooltipText("Nâng cấp Huy Hiệu");
					updateLevel.img.addEventListener(MouseEvent.CLICK, clickPopupUpdateLevel);
					updateLevel.img.tabIndex = index;
					updateLevel.img.name = index + "_" + slotIndex;
					
					var GuiToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
					var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
					GuiToolTip.Init(obj);
					GuiToolTip.InitPos(ctn, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
					ctn.setGUITooltip(GuiToolTip);
					ctn.isQuartz = true;
				}
				curSoldier.UpdateBonusEquipment();
				AddInfo();
			}
		}
		
		private function invateTabMenu(type:String):void
		{
			//trace("invateTabMenu type== " + type);
			if (type == 'QWhite')
			{
				mcTrang.img.visible = true;
				mcXanh.img.visible = false;
				mcVang.img.visible = false;
				mcTim.img.visible = false;
				mcVIP.img.visible = false;
				buttonTrang.SetFocus(true);
				buttonXanh.SetFocus(false);
				buttonVang.SetFocus(false);
				buttonTim.SetFocus(false);
				buttonVIP.SetFocus(false);
			}
			else if (type == 'QGreen')
			{
				mcTrang.img.visible = false;
				mcXanh.img.visible = true;
				mcVang.img.visible = false;
				mcTim.img.visible = false;
				mcVIP.img.visible = false;
				buttonTrang.SetFocus(false);
				buttonXanh.SetFocus(true);
				buttonVang.SetFocus(false);
				buttonTim.SetFocus(false);
				buttonVIP.SetFocus(false);
			}
			else if (type == 'QYellow')
			{
				mcTrang.img.visible = false;
				mcXanh.img.visible = false;
				mcVang.img.visible = true;
				mcTim.img.visible = false;
				mcVIP.img.visible = false;
				buttonTrang.SetFocus(false);
				buttonXanh.SetFocus(false);
				buttonVang.SetFocus(true);
				buttonTim.SetFocus(false);
				buttonVIP.SetFocus(false);
			}
			else if (type == 'QPurple')
			{
				mcTrang.img.visible = false;
				mcXanh.img.visible = false;
				mcVang.img.visible = false;
				mcTim.img.visible = true;
				mcVIP.img.visible = false;
				buttonTrang.SetFocus(false);
				buttonXanh.SetFocus(false);
				buttonVang.SetFocus(false);
				buttonTim.SetFocus(true);
				buttonVIP.SetFocus(false);
			}
			else if (type == 'QVIP')
			{
				mcTrang.img.visible = false;
				mcXanh.img.visible = false;
				mcVang.img.visible = false;
				mcTim.img.visible = false;
				mcVIP.img.visible = true;
				buttonTrang.SetFocus(false);
				buttonXanh.SetFocus(false);
				buttonVang.SetFocus(false);
				buttonTim.SetFocus(false);
				buttonVIP.SetFocus(true);
			}
		}
		
		//End
	}
}