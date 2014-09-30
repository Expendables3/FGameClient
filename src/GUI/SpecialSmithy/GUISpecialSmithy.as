package GUI.SpecialSmithy 
{
	import adobe.utils.CustomActions;
	import com.adobe.serialization.json.JSON;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.FishMeridian.GUIMeridian;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.CreateEquipment.SendGetIngradient;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUISpecialSmithy extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "BtnClose";
		static public const BTN_TAB_EQUIP:String = "TabEquipSmithy";
		static public const BTN_TAB_CUSTOM:String = "TabCustom";
		
		static public const BTN_SUB_TAB_WEAPON:String = "BtnSubTab_Weapon";
		static public const BTN_SUB_TAB_JEWEL:String = "BtnSubTab_Jewel";
		static public const BTN_SUB_TAB_HELMET:String = "BtnSubTab_Helmet";
		static public const BTN_SUB_TAB_ARMOR:String = "BtnSubTab_Armor";
		static public const BTN_MAKE_EQUIP_GOLD:String = "BtnMakeEquipGold";
		static public const BTN_MAKE_EQUIP_G:String = "BtnMakeEquipG";
		static public const BTN_SELECT_ALL:String = "BtnSelectAll";
		static public const BTN_DESELECT_ALL:String = "BtnDeselectAll";
		static public const BTN_SELECT_ONE_PAGE:String = "buttonSelectOnePage";
		static public const BTN_BREAK:String = "buttonBreak";
		static public const BTN_MAKE_OPTION:String = "BtnMakeOption";
		static public const BTN_BUY:String = "BtnBuy";
		static public const BTN_SAVE:String = "BtnSaveEquip";
		static public const BTN_CANCEL:String = "BtnCancel";
		static public const BTN_ADD:String = "BtnAdd";
		static public const BTN_SUB:String = "BtnSub";
		
		private static const CTN_HELMET:String = "CtnHelmet";
		private static const CTN_ARMOR:String = "CtnArmor";
		private static const CTN_WEAPON:String = "CtnWeapon";
		private static const CTN_BELT:String = "CtnBelt";
		private static const CTN_BRACELET:String = "CtnBracelet";
		private static const CTN_NECKLACE:String = "CtnNecklace";
		private static const CTN_RING:String = "CtnRing";
		
		static public const BTN_BACK:String = "BtnBackSmithy";
		static public const BTN_NEXT:String = "BtnNextSmithy";
		static public const TXTBOX_PAGE:String = "TxtboxPage";
		static public const TXTBOX_NUM:String = "TxtboxNum";
		
		static public const COMBOBOX_KIND:String = "ComboBoxKind";
		static public const COMBOBOX_QUALITY:String = "ComboBoxQuality";
		static public const COMBOBOX_RANK:String = "ComboBoxRank";
		static public const COMBOBOX_ELEMENT:String = "ComboBoxElement";
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		private var buttonClose:Button;
		private var buttonTabEquip:Button;
		private var buttonTabCustom:Button;
		private var buttonMakeEquipGold:Button;
		private var buttonMakeEquipG:Button;
		private var buttonSelectAll:Button;
		private var buttonDeselectAll:Button;
		private var buttonSelectOnePage:Button;
		private var buttonBreak:Button;
		private var buttonSubTabWeapon:Button;
		private var buttonSubTabArmor:Button;
		private var buttonSubTabJewel:Button;
		private var buttonSubTabHelmet:Button;
		private var buttonAdd:Button;
		private var buttonSub:Button;
		
		private var comboBoxKind:ComboBoxEx;
		private var comboBoxRank:ComboBoxEx;
		private var comboBoxQuality:ComboBoxEx;
		private var comboBoxElement:ComboBoxEx;
		private var labelKind:TextField;
		private var labelRank:TextField;
		private var labelQuality:TextField;
		private var labelElement:TextField;
		
		private const boxEquipData:Array = ["Vũ Khí", "Áo Giáp", "Mũ", "Nhẫn", "Vòng Cổ", "Vòng Tay", "Thắt Lưng"];
		private const boxRankData:Array = ["3", "4"];
		private const boxElementData:Array = ["Kim", "Mộc", "Thổ", "Thủy", "Hỏa"];
		private const boxQualityData:Array = ["Thần"];
		
		private const mapEquip:Object = { "Vũ Khí":"Weapon", "Áo Giáp":"Armor", "Mũ":"Helmet", "Nhẫn":"Ring", "Vòng Cổ":"Necklace", "Vòng Tay":"Bracelet", "Thắt Lưng":"Belt" };
		private const mapRank:Object = { "3":3, "4":4 };
		private const mapElement:Object = { "Kim":1, "Mộc":2, "Thổ":3, "Thủy":4, "Hỏa":5 };
		private const mapQuality:Object = { "Thần":4 }
		
		private var dataEquip:Array;
		
		private var listEquip:ListBox;
		private var listCustom:ListBox;
		private var currentList:ListBox;
		private var currentTab:String;
		private var labelPage:TextField;
		private var txtBox:TextBox;
		private var txtNum:TextBox;
		private var txtTotalPoint:TextField;
		private var txtRequirePoint:TextField;
		private var txtCost:TextField;
		private var ctnEquip:Container;
		private var choosenList:Array = new Array();
		private var shareObj:SharedObject;
		private var _totalPercent:Number = 0;
		private var percent:Number = 0;
		private var _costGold:Number = 0;
		private var _costG:Number = 0;
		private var ItemList:Array = new Array();
		private var isDataReady:Boolean;
		private var effMakeEquip:Image;
		private var effMakeEquipBg:Image;
		
		public function GUISpecialSmithy(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISpecialSmithy";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(25, 15);
				
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;	
				
				var pk:SendGetIngradient = new SendGetIngradient();
				Exchange.GetInstance().Send(pk);
				
				// Load lại kho để refresh trang bị
				var cmd:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(cmd);
				OpenRoomOut();
			}
			LoadRes("GuiSpecialSmithy_Bg");
			configTime = ConfigJSON.getInstance().getItemInfo("Param")["HammerManTime"];
			
			timePlay = GameLogic.getInstance().CurServerTime * 1000 - 10 * 1000;
			var date:Date = new Date(timePlay);
			hour = int(date.getUTCHours() + Constant.TIME_ZONE_SERVER);
			if (hour >= 24)	hour -= 24;
			min = int(date.getUTCMinutes());
			sec = int(date.getUTCSeconds());
			if (sec == 0)
			{
				if (min == 0) 
				{
					hour = 24 - hour;
				}
				else 
				{
					hour = 23 - hour;
					min = 60 - min;
				}
			}
			else 
			{
				sec = 60 - sec;
				min = 59 - min;
				hour = 23 - hour;
			} 
		}
		
		public function showGUI():void
		{
			ItemList.splice(0, ItemList.length);
			isDataReady = false;
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		public var isNextDay:Boolean = false;
		public var timePlay:Number = 0;
		public function UpdateGUI():void 
		{
			if (isNextDay)
			{
				if (GameLogic.getInstance().CurServerTime > configTime["EndTime"] || GameLogic.getInstance().CurServerTime < configTime["StartTime"])
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian, lò rèn đã đóng cửa.");
					Hide();
				}
			}
			else
			{
				if (GameLogic.getInstance().CurServerTime - (timePlay + 10 * 1000) / 1000 >= 1)
				{
					timePlay += 1000;
					if (sec == 0)
					{
						sec = 59;
						if (min == 0)
						{
							min = 59;
							if (hour == 0)
							{
								isNextDay = true;
								if (GameLogic.getInstance().CurServerTime > configTime["EndTime"] || GameLogic.getInstance().CurServerTime < configTime["StartTime"])
								{
									GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian, lò rèn đã đóng cửa.");
									Hide();
								}
							}
							else 
							{
								hour--;
							}
						}
						else 
						{
							min--;
						}
					}
					else 
					{
						sec--;
					}
				}
			}
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
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
			shareObj = SharedObject.getLocal("SpecialSmithy" + GameLogic.getInstance().user.GetMyInfo().Id);
			if (shareObj.data.currentTab != null)
			{
				initTab(shareObj.data.currentTab, true);
			}
			else
			{
				initTab(BTN_TAB_EQUIP, true);
			}
			Ultility.FlushData(shareObj);
		}
		
		public var hour:int = 0;
		public var min:int = 0;
		public var sec:int = 0;
		private function addContent():void
		{
			buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 707, 19, this);
			ctnEquip = AddContainer("", "CtnContent", 30, 115, true, this);
			AddButton(BTN_BACK, "BtnBackSmithy", 470, 450, this);
			AddButton(BTN_NEXT, "BtnNextSmithy", 620, 450, this);
			
			labelPage = AddLabel("/1", 550, 458, 0xffffff, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			labelPage.setTextFormat(txtFormat);
			labelPage.defaultTextFormat = txtFormat;
			
			txtBox = AddTextBox(TXTBOX_PAGE, "1", 520, 458, 30, 20, this);
			txtFormat = new TextFormat("arial", 15, 0xffffff, true);
			txtFormat.align = TextFormatAlign.RIGHT;
			txtBox.SetTextFormat(txtFormat);
			txtBox.SetDefaultFormat(txtFormat);
			
			buttonTabEquip = AddButton(BTN_TAB_EQUIP, "BtnTabEquipSmithy", 54, 70);
			buttonTabCustom = AddButton(BTN_TAB_CUSTOM, "BtnTabCustomSmithy", 194, 70);
			
			buttonSubTabWeapon = AddButton(BTN_SUB_TAB_WEAPON, "CustomBtnWeapon", 430, 115);
			buttonSubTabArmor = AddButton(BTN_SUB_TAB_ARMOR, "CustomBtnArmor", 485, 115);
			buttonSubTabHelmet = AddButton(BTN_SUB_TAB_HELMET, "CustomBtnHelmet", 540, 115);
			buttonSubTabJewel = AddButton(BTN_SUB_TAB_JEWEL, "CustomBtnJewel", 595, 115);
			
			listEquip = AddListBox(ListBox.LIST_X, 3, 3, 5, 10);
			listEquip.setPos(435, 160);
			listEquip.visible = false;
			
			listCustom = AddListBox(ListBox.LIST_X, 3, 3, 5, 10);
			listCustom.setPos(435, 160);
			
			labelKind = AddLabel("Loại:", 20, 152, 0x006699);
			comboBoxKind = new ComboBoxEx(this.img, 90, 150, boxEquipData[0], boxEquipData);
			comboBoxKind.setEventHandler(this, COMBOBOX_KIND);
			comboBoxKind.setWidth(100);
			
			labelRank = AddLabel("Cấp:", 20, 197, 0x006699);
			comboBoxRank = new ComboBoxEx(this.img, 90, 195, boxRankData[0], boxRankData);
			comboBoxRank.setEventHandler(this, COMBOBOX_RANK);
			comboBoxRank.setWidth(100);
			
			labelElement = AddLabel("Hệ:", 20, 242, 0x006699);
			comboBoxElement = new ComboBoxEx(this.img, 90, 240, boxElementData[0], boxElementData);
			comboBoxElement.setEventHandler(this, COMBOBOX_ELEMENT);
			comboBoxElement.setWidth(100);
			
			labelQuality = AddLabel("Chất:", 20, 287, 0x006699);
			comboBoxQuality = new ComboBoxEx(this.img, 90, 285, boxQualityData[0], boxQualityData);
			comboBoxQuality.setEventHandler(this, COMBOBOX_QUALITY);
			comboBoxQuality.setWidth(100);
			
			//var txtAnnounce:TextField = AddLabel("", 450, 80, 0x000000, 1, 0xFFFFFF);
			//var fDate:Date = new Date(configTime["StartTime"] * 1000);
			//var tDate:Date = new Date(configTime["EndTime"] * 1000);
			//txtAnnounce.htmlText = "Lò rèn mở cửa từ ngày " + "<font color='#FF0000'>" + fDate.getDate() + "/" + (fDate.getMonth() + 1).toString() + "/" + fDate.getFullYear() + "</font>"
							//+ " đến hết ngày " + "<font color='#FF0000'>" + tDate.getDate() + "/" + (tDate.getMonth() + 1).toString() + "/" + tDate.getFullYear() + "</font>";
		}
		private var configTime:Object;
		private function initTab(tabName:String, isInit:Boolean = false):void
		{
			if (isInit)	GetItemList();
			currentTab = tabName;
			listEquip.visible = false;
			listCustom.visible = false;
			switch(tabName)
			{
				case BTN_TAB_EQUIP:
					resetChoosenList()
					buttonTabEquip.SetFocus(true, false);
					buttonTabCustom.SetFocus(false, false);
					
					comboBoxKind.items = boxEquipData;
					comboBoxKind.defaultLabel = boxEquipData[0];
					if (shareObj.data.type != null)		comboBoxKind.defaultLabel = shareObj.data.type;
					
					comboBoxRank.items = boxRankData;
					comboBoxRank.defaultLabel = boxRankData[0];
					if (shareObj.data.rank != null)		comboBoxRank.defaultLabel = shareObj.data.rank;
					
					comboBoxElement.items = boxElementData;
					comboBoxElement.defaultLabel = boxElementData[0];
					if (shareObj.data.element != null)		comboBoxElement.defaultLabel = shareObj.data.element;
					
					comboBoxQuality.items = boxQualityData;
					comboBoxQuality.defaultLabel = boxQualityData[0];
					if (shareObj.data.color != null)	comboBoxQuality.defaultLabel = shareObj.data.color;
					
					comboBoxRank.visible = comboBoxKind.visible = comboBoxQuality.visible = comboBoxElement.visible = true;
					labelRank.visible = labelKind.visible = labelQuality.visible = labelElement.visible = true;
					labelQuality.y = comboBoxQuality.y = 285;
					
					buttonSubTabArmor.img.visible = buttonSubTabHelmet.img.visible = buttonSubTabJewel.img.visible = buttonSubTabWeapon.img.visible = false;
					currentList = listEquip;
					
					if (mapEquip[comboBoxKind.selectedItem] == "Ring" || mapEquip[comboBoxKind.selectedItem] == "Necklace" 
					|| mapEquip[comboBoxKind.selectedItem] == "Bracelet" || mapEquip[comboBoxKind.selectedItem] == "Belt")
					{
						comboBoxElement.visible = labelElement.visible = false;
						labelQuality.y = comboBoxQuality.y = 240;
					}
					updateTabEquip();
					break;
				case BTN_TAB_CUSTOM:
					buttonTabEquip.SetFocus(false, false);
					buttonTabCustom.SetFocus(true, false);
					
					comboBoxRank.visible = comboBoxKind.visible = comboBoxQuality.visible = comboBoxElement.visible = false;
					labelRank.visible = labelKind.visible = labelElement.visible = labelQuality.visible = false;
					buttonSubTabArmor.img.visible = buttonSubTabHelmet.img.visible = buttonSubTabJewel.img.visible = buttonSubTabWeapon.img.visible = true;
					buttonSubTabArmor.SetFocus(false, false);
					buttonSubTabHelmet.SetFocus(false, false);
					buttonSubTabWeapon.SetFocus(true, false);
					buttonSubTabJewel.SetFocus(false, false);
					curSubTab = BTN_SUB_TAB_WEAPON;
					currentList = listCustom;
					updateTabCustom();
					break;
			}
			currentList.visible = true;
			txtBox.SetText("1");
			txtBox.textField.selectable = true;
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			filterListEquip(curSubTab);
		}
		
		private var curSubTab:String;
		private function GetItemList():void
		{
			dataEquip = [];
			
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Belt"));
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Bracelet"));
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Necklace"));
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Ring"));
			
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Helmet"));
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Armor"));
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Weapon"));
			dataEquip = dataEquip.concat(GameLogic.getInstance().user.GetStore("Mask"));
			
			sortList();
		}
		
		private function sortList():void 
		{
			var itemTemp:FishEquipment;
			for (var i:int = 0; i < dataEquip.length; i++ )
			{
				for (var j:int = i + 1; j < dataEquip.length; j++ )
				{
					if (dataEquip[i].Color < dataEquip[j].Color)
					{
						itemTemp = dataEquip[i];
						dataEquip[i] = dataEquip[j];
						dataEquip[j] = itemTemp;
					}
					else if (dataEquip[i].Color == dataEquip[j].Color)
					{
						if (dataEquip[i].Rank % 100 < dataEquip[j].Rank % 100)
						{
							itemTemp = dataEquip[i];
							dataEquip[i] = dataEquip[j];
							dataEquip[j] = itemTemp;
						}
						else if (dataEquip[i].Rank % 100 == dataEquip[j].Rank % 100)
						{
							if (dataEquip[i].EnchantLevel < dataEquip[j].EnchantLevel)
							{
								itemTemp = dataEquip[i];
								dataEquip[i] = dataEquip[j];
								dataEquip[j] = itemTemp;
							}
						}
					}
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					shareObj.data.currentTab = currentTab;
					Ultility.FlushData(shareObj);
					Hide();
					break;
				case BTN_TAB_EQUIP:
				case BTN_TAB_CUSTOM:
					initTab(buttonID);
					break;
				case BTN_SUB_TAB_JEWEL:
				case BTN_SUB_TAB_WEAPON:
				case BTN_SUB_TAB_HELMET:
				case BTN_SUB_TAB_ARMOR:
					buttonSubTabArmor.SetFocus(false, false);
					buttonSubTabHelmet.SetFocus(false, false);
					buttonSubTabWeapon.SetFocus(false, false);
					buttonSubTabJewel.SetFocus(false, false);
					curSubTab = buttonID;
					GetButton(buttonID).SetFocus(true, false);
					filterListEquip(curSubTab);
					break;
				case BTN_BACK:
				case BTN_NEXT:
					updateNextBackBtn(buttonID);
					break;
				case BTN_ADD:
				case BTN_SUB:
					updateAddSubButton(buttonID);
					break;
				case BTN_MAKE_EQUIP_GOLD:
				case BTN_MAKE_EQUIP_G:
					makeEquip(buttonID);
					break;
				case BTN_BREAK:
					breakEquip();
					break;
				case BTN_MAKE_OPTION:
					makeOption();
					break;
				case BTN_SAVE:
					saveOption();
					break;
				case BTN_CANCEL:
					cancelMakeEquip();
					break;
				case BTN_BUY:
					GuiMgr.getInstance().guiBuySpirit.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_SELECT_ONE_PAGE:
					selectOnePage();
					break;
				case BTN_SELECT_ALL:
					selectAll();
					break;
				case BTN_DESELECT_ALL:
					deselectAll();
					break;
				default:
					if (buttonID == "NewEquip_1")	return;
					if (buttonID.split("_")[1] == null) return;
					switch (currentTab)
					{
						case BTN_TAB_EQUIP:
							var ctn:Container = listEquip.getItemById(buttonID);
							var equip:FishEquipment = dataEquip[buttonID.split("_")[1]] as FishEquipment;
							if (equip == null)	return;
							var cf1:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Lookup");
							var iRank:int = equip.Rank % 100;
							var iColor:int = equip.Color;
							if (!ctn.GetImage("ImgMark").img.visible)
							{
								markList[buttonID.split("_")[1]] = true;
								choosenList.push(equip);
								var fP:Point = new Point(event.stageX - 30, event.stageY - 30);
								var tP:Point = new Point(520, 150);
								EffectMgr.getInstance().effectPartSmithy(fP,tP);
								percent += cf1[iRank][iColor]["Percent"];
								totalPercent += cf1[iRank][iColor]["Percent"];
							}
							else
							{
								markList[buttonID.split("_")[1]] = false;
								for (var i:int = 0; i < choosenList.length; i++ )
								{
									var e:FishEquipment = choosenList[i] as FishEquipment;
									if (equip == e)
									{
										choosenList.splice(i, 1);
										percent -= cf1[iRank][iColor]["Percent"];
										totalPercent -= cf1[iRank][iColor]["Percent"];
										break;
									}
								}
								buttonSelectAll.SetEnable(true);
								if (choosenList.length == 0)
									buttonDeselectAll.SetEnable(false);
							}
							buttonBreak.SetDisable();
							buttonDeselectAll.SetDisable();
							if (choosenList.length > 0)
							{
								buttonBreak.SetEnable();
								buttonDeselectAll.SetEnable();
							}
							ctn.GetImage("ImgMark").img.visible = !ctn.GetImage("ImgMark").img.visible;
							//setContentTabEquip();
							setBtnOnePage();
							break;
						case BTN_TAB_CUSTOM:
							if (isChanging)
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("SmithyMess1"));
								return;
							}
							var ctn1:Container = listCustom.getItemById(buttonID);
							if (ind != "")
							{
								var ctn2:Container = listCustom.getItemById(ind);
								if (ctn2)
								{
									ctn2.SetHighLight( -1);
								}
							}
							var n:int = (int)(ctn1.GetTextBox("NumChange").textField.text);
							if (n > 0)
							{
								equipSelected = dataEquip[buttonID.split("_")[1]] as FishEquipment;
								updateTabCustom(equipSelected);
								ind = buttonID;
								ctn1.SetHighLight(0xFFFFFF);
							}
							else
							{
								var posStart:Point = GameInput.getInstance().MousePos;
								var posEnd:Point = new Point(posStart.x, posStart.y - 100);
								var txtFormat:TextFormat = new TextFormat("Arial", 14, 0xFF0000, true, null, null, null, null, "center");
								Ultility.ShowEffText(Localization.getInstance().getString("SmithyMess2"), img, posStart, posEnd, txtFormat, 1, 0xffffff);
							}
							break;
					}
					break;
			}
		}
		
		private function saveOption():void 
		{
			isChanging = false;
			buttonSave.SetEnable(false);
			buttonCancel.SetEnable(false);
			enableButton(false);
			var cmdSave:SendSaveOption = new SendSaveOption();
			cmdSave.ItemType = equipSelected.Type;
			cmdSave.ItemId = equipSelected.Id;
			Exchange.GetInstance().Send(cmdSave);
		}
		
		private function makeOption():void 
		{
			if (equipSelected == null)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("SmithyMess4"));
				return;
			}
			var myPT:Number = GameLogic.getInstance().user.getPowerTinh();
			var cf:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Option");
			var r:int = equipSelected.Rank % 100;
			if (myPT >= Number(cf[r][equipSelected.Color]["Power"]))
			{
				isChanging = true;
				enableButton(false);
				var cmdMakeOption:SendMakeOption = new SendMakeOption();
				var smithyData:Object = GameLogic.getInstance().user.smithyData;
				var rank:int = equipSelected.Rank % 100;
				var num:int = smithyData["LimitChangeOption"][equipSelected["Color"]];
				var p:Point = new Point(290, 250);
				var tF:TextFormat = new TextFormat("Arial", 18, 0xffffff, true, null, null, null, null, "center");
				if (num - equipSelected.NumChangeOption > 0)
				{
					Ultility.ShowEffText("-1", img, p, new Point(p.x, p.y - 20), tF, 1, 0x000000);
					p = new Point(250, 550);
					Ultility.ShowEffText("-" + cf[rank][equipSelected.Color]["Power"], img, p, new Point(p.x, p.y - 30), tF, 1, 0x000000);
					
					cmdMakeOption.ItemType = equipSelected.Type;
					cmdMakeOption.ItemId = equipSelected.Id;
					Exchange.GetInstance().Send(cmdMakeOption);
					GameLogic.getInstance().user.updateIngradient("PowerTinh", -cf[rank][equipSelected.Color]["Power"]);
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("SmithyMess3"));
					isChanging = false;
					enableButton();
				}
			}
			else
			{
				GuiMgr.getInstance().guiBuySpirit.Show(Constant.GUI_MIN_LAYER, 3);
			}
		}
		
		private function makeEquip(buttonId:String):void 
		{
			if (buttonId == BTN_MAKE_EQUIP_G)
			{
				if (GameLogic.getInstance().user.GetZMoney() < costG)
				{
					GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
					return;
				}
			}
			var tP1:Point = new Point(320, 250);
			var fP1:Point = new Point(520, 150);
			EffectMgr.getInstance().effectPartSmithy(fP1,tP1);
			buttonMakeEquipGold.SetEnable(false);
			buttonMakeEquipG.SetEnable(false);
			enableButton(false);
			
			var cmd:SendMakeEquipment = new SendMakeEquipment();
			var obj:Object = new Object();
			obj.Rank = mapRank[comboBoxRank.selectedItem];
			obj.Color = mapQuality[comboBoxQuality.selectedItem];
			if (buttonId == BTN_MAKE_EQUIP_G)	cmd.PriceType = "ZMoney";
			obj.Type = mapEquip[comboBoxKind.selectedItem];
			obj.Element = mapElement[comboBoxElement.selectedItem];
			if (mapEquip[comboBoxKind.selectedItem] == "Ring" || mapEquip[comboBoxKind.selectedItem] == "Necklace" 
			|| mapEquip[comboBoxKind.selectedItem] == "Bracelet" || mapEquip[comboBoxKind.selectedItem] == "Belt")
			{
				obj.Element = 0;
			}
			cmd.Target = obj;
			cmd.Num = int(txtNum.GetText());
			Exchange.GetInstance().Send(cmd);
		}
		
		private function breakEquip():void
		{
			enableButton(false);
			var checkedList:Array = checkList(choosenList);
			var cmd:SendBreakEquipment = new SendBreakEquipment();
			cmd.Input = checkedList;
			Exchange.GetInstance().Send(cmd);
		}
		
		private function checkList(choosenList:Array):Array 
		{
			var arr:Array = new Array();
			arr.push(choosenList[0]);
			var check:Boolean;
			for (var i:int = 0; i < choosenList.length; i++ )
			{
				check = false;
				for (var j:int = 0; j < arr.length; j++ )
				{
					if (choosenList[i]["Id"] == arr[j]["Id"])
					{
						check = true;
					}
				}
				if (!check)
					arr.push(choosenList[i]);
			}
			return arr;
		}
		
		private function cancelMakeEquip():void 
		{
			isChanging = false;
			buttonSave.SetEnable(false);
			buttonCancel.SetEnable(false);
			GameLogic.getInstance().user.smithyData["HammerMan"]["TempBonus"] = null;
			updateTabCustom(equipSelected);
			dataEquip.push(equipSelected);
			GameLogic.getInstance().user.UpdateEquipmentToStore(equipSelected);
			sortList();
			filterListEquip(curSubTab);
			var cmdCancel:SendCancelOption = new SendCancelOption();
			cmdCancel.ItemType = equipSelected.Type;
			cmdCancel.ItemId = equipSelected.Id;
			Exchange.GetInstance().Send(cmdCancel);
		}
		
		private function deselectAll():void 
		{
			for (var k:int = 0; k < listEquip.length; k++ )
			{
				var c:Container = listEquip.itemList[k] as Container;
				c.GetImage("ImgMark").img.visible = false;
			}
			resetChoosenList();
			totalPercent -= percent;
			percent = 0;
			buttonSelectAll.SetEnable(true);
			buttonSelectOnePage.SetEnable(true);
			buttonDeselectAll.SetEnable(false);
			//setContentTabEquip();
			buttonBreak.SetDisable();
		}
		
		private function selectAll():void 
		{
			choosenList = [];
			totalPercent -= percent;
			percent = 0;
			for (var j:int = 0; j < listEquip.length; j++ )
			{
				var container:Container = listEquip.itemList[j] as Container;
				container.GetImage("ImgMark").img.visible = true;
			}
			var po:Number = 0;
			for (var str:String in oEquip)
			{
				markList[str] = true;
				choosenList.push(oEquip[str]);
				var eq:FishEquipment = oEquip[str] as FishEquipment;
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Lookup");
				var iR:int = eq.Rank % 100;
				var iC:int = eq.Color;
				po += cfg[iR][iC]["Percent"];
			}
			percent += po;
			totalPercent += po;
			buttonDeselectAll.SetEnable(true);
			buttonSelectAll.SetEnable(false);
			buttonSelectOnePage.SetEnable(false);
			//buttonMakeEquipG.SetEnable(true);
			//setContentTabEquip();
			buttonBreak.SetEnable();
		}
		
		private function selectOnePage():void 
		{
			for (var k:int = 0; k < listEquip.length; k++ )
			{
				var container:Container = listEquip.itemList[k] as Container;
				container.GetImage("ImgMark").img.visible = true;
			}
			var po:Number = 0;
			var startE:int = (curPage - 1) * 9 + 1;
			var endE:int = curPage * 9;
			var i:int;
			for (var s:int = 0; s < oEquip.length; s++)
			{
				if (!oEquip.hasOwnProperty(s))	continue;
				if (oEquip[s].Id <= 0)	continue;
				i++;
				if (i >= startE && i <= endE)
				{
					if (!markList[s])
					{
						markList[s] = true;
						choosenList.push(oEquip[s]);
						var eq:FishEquipment = oEquip[s] as FishEquipment;
						var cfg:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Lookup");
						var iR:int = eq.Rank % 100;
						var iC:int = eq.Color;
						po += cfg[iR][iC]["Percent"];
					}
				}
			}
			percent += po;
			totalPercent += po;
			buttonSelectOnePage.SetEnable(false);
			buttonDeselectAll.SetEnable(true);
			//setContentTabEquip();
			buttonBreak.SetEnable();
		}
		private var isChanging:Boolean = false;
		private var equipSelected:FishEquipment;
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			switch (a[0])
			{
				case CTN_ARMOR:
				case CTN_HELMET:
				case CTN_WEAPON:
				case CTN_BELT:
				case CTN_NECKLACE:
				case CTN_BRACELET:
				case CTN_RING:
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, oEquip[a[1]], GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					break;
				case "NewEquip":
					var rank:int;
					if (mapEquip[comboBoxKind.selectedItem] == "Ring" || mapEquip[comboBoxKind.selectedItem] == "Necklace" 
					|| mapEquip[comboBoxKind.selectedItem] == "Bracelet" || mapEquip[comboBoxKind.selectedItem] == "Belt")
					{
						rank = mapRank[comboBoxRank.selectedItem];
					}
					else
					{
						rank = mapElement[comboBoxElement.selectedItem] * 100 + mapRank[comboBoxRank.selectedItem];
					}
					var s:String = rank + "$" + mapQuality[comboBoxQuality.selectedItem];
					var o:Object = ConfigJSON.getInstance().GetEquipmentInfo(mapEquip[comboBoxKind.selectedItem], s);
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, o);
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		private var buttonChange:Button;
		private var buttonSave:Button;
		private var buttonCancel:Button;
		public function updateTabCustom(e:FishEquipment = null, newBonus:Array = null):void
		{
			if (currentTab != BTN_TAB_CUSTOM)	return;
			equipSelected = e;
			ctnEquip.ClearComponent();
			ctnEquip.AddImage("", "Ctn" + currentTab, 0, 0, true, ALIGN_LEFT_TOP);
			var buttonBuy:Button = ctnEquip.AddButton(BTN_BUY, "BtnBuyPowerTinh", 250, 430, this);
			if (e != null)
			{
				addEquipInfo(e, newBonus);
			}
			else
			{
				var smithyData:Object = GameLogic.getInstance().user.smithyData["HammerMan"];
				if (smithyData.TempBonus && !(smithyData.TempBonus as Array))
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(smithyData.TempEquipment);
					var nB:Array = [];
					equipSelected = equip;
					nB = nB.concat(smithyData.TempBonus.bonus);
					addEquipInfo(equip, nB);
					isChanging = true;
				}
			}
			var myPT:Number = GameLogic.getInstance().user.getPowerTinh();
			var txtMyPT:TextField = ctnEquip.AddLabel(Ultility.StandardNumber(myPT), 135, 425);
			txtMyPT.setTextFormat(new TextFormat("arial", 14, 0xFFFFFF, true));
			if (!isChanging)
			{
				buttonChange = ctnEquip.AddButton(BTN_MAKE_OPTION, "BtnChangeOption", 120, 360, this);
				if (e != null)
				{
					var cf:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Option");
					var rank:int = e.Rank % 100;
					var txtPT:TextField = ctnEquip.AddLabel(Ultility.StandardNumber(cf[rank][e.Color]["Power"]), 140, 330);
					txtPT.setTextFormat(new TextFormat("arial", 18, 0x003300, true));
				}
			}
			else
			{
				buttonSave = ctnEquip.AddButton(BTN_SAVE, "BtnSmithySave", 220, 340, this);
				buttonCancel = ctnEquip.AddButton(BTN_CANCEL, "BtnSmithyCancel", 50, 340, this);
			}
		}
		
		private function addEquipInfo(e:FishEquipment, newBonus:Array):void 
		{
			var ctn:Container = ctnEquip.AddContainer("", FishEquipment.GetBackgroundName(2), 152, 20, true, this);
			if (e.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				ctn.LoadRes(FishEquipment.GetBackgroundName(e.Color), true);
			}
			var imag:Image = ctn.AddImage("", e.imageName + "_Shop", 0, 0);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, e.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
			FishSoldier.EquipmentEffect(imag.img, e.Color);
			
			ctn.AddImage("", "NumChangeBg", 60, 70);
			var smithyData:Object = GameLogic.getInstance().user.smithyData;
			var tip:TooltipFormat = new TooltipFormat();
			var num:int = smithyData["LimitChangeOption"][e.Color];
			ctn.AddTextBox("NumChange", String(num - e.NumChangeOption), 53, 57, 20, 20);
			tip.text = "Còn " + (num - e.NumChangeOption).toString() + " lần tùy biến";
			ctn.setTooltip(tip);
			var tf:TextField = ctn.GetTextBox("NumChange").textField as TextField;	
			tf.mouseEnabled = false;
			tf.setTextFormat(new TextFormat("arial", 18, 0xFFFF00, true));
			var glow:GlowFilter = new GlowFilter(0x6D3636, 1, 4, 4);
			tf.filters = [glow];
			
			//Show các chỉ số
			for (var i:int = 0; i < e.bonus.length; i++ )
			{
				for (var s:String in e.bonus[i])
				{
					ctnEquip.AddImage("", "BonusBar", 100, 170 + 30 * i);
					ctnEquip.AddLabel(Localization.getInstance().getString(s) + ":", 40, 160 + 30 * i, 0xFFFFFF, 0);
					ctnEquip.AddLabel(e.bonus[i][s], 60, 160 + 30 * i, 0xFFFF00, 2);
				}
				
				if (newBonus != null)
				{
					for (s in newBonus[i])
					{
						ctnEquip.AddImage("", "NewBonusBar", 270, 170 + 30 * i);
						ctnEquip.AddLabel(Localization.getInstance().getString(s) + ": ", 200, 160 + 30 * i, 0xFFFFFF, 0);
						ctnEquip.AddLabel(newBonus[i][s], 230, 160 + 30 * i, 0xFFFF00, 2);
					}
				}
			}
		}
		
		private function setContentTabEquip():void
		{
			if (choosenList.length > 0)
			{
				buttonMakeEquipGold.SetVisible(true);
				buttonMakeEquipG.SetVisible(true);
				pointBg.img.visible = txtCost.visible = txtCostG.visible = txtTotalPoint.visible = true;
				var smithyData:Object = GameLogic.getInstance().user.smithyData;
				var numE:int = (totalPercent + percent) / smithyData["NumberPointChangeItem"];
				if (numE > 0)
				{
					txtDetail.text = "Chế tạo được: " + numE + " trang bị";
					txtDetail.setTextFormat(new TextFormat("arial", 14, 0x00ffff, true));
					txtDetail.y = 325;
					txtDetail.visible = true;
				}
				else
				{
					txtDetail.visible = false;
				}
				//imgArrow.img.visible = false;
			}
			else
			{
				buttonMakeEquipGold.SetVisible(false);
				buttonMakeEquipG.SetVisible(false);
				pointBg.img.visible = txtCost.visible = txtCostG.visible = txtTotalPoint.visible = false;
				txtDetail.text = "Chọn nguyên liệu để chế tạo";
				txtDetail.setTextFormat(new TextFormat("arial", 18, 0x00ffff, true));
				txtDetail.visible = true;
				txtDetail.y = 305;
				//imgArrow.img.visible = true;
			}
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4);
			txtDetail.filters = [glow];
		}
		private var pointBg:Container;
		//private var imgArrow:Image;
		private var txtDetail:TextField;
		private var maxNum:int;
		public function updateTabEquip():void
		{
			ctnEquip.ClearComponent();
			ctnEquip.AddImage("", "Ctn" + currentTab, 0, 0, true, ALIGN_LEFT_TOP);
			effMakeEquipBg = ctnEquip.AddImage("", "EffMakeEquipBg", 175, 26, true, ALIGN_LEFT_TOP);
			effMakeEquip = ctnEquip.AddImage("", "EffMakeEquip", 175, 26, true, ALIGN_LEFT_TOP);
			effMakeEquip.GoToAndStop(1);
			effMakeEquipBg.GoToAndStop(1);
			
			buttonSelectOnePage = ctnEquip.AddButton(BTN_SELECT_ONE_PAGE, "BtnSelectOnePage", 510, 370, this);
			buttonSelectAll = ctnEquip.AddButton(BTN_SELECT_ALL, "BtnSelectAll", 430, 373, this);
			buttonDeselectAll = ctnEquip.AddButton(BTN_DESELECT_ALL, "BtnDeselectAll", 585, 373, this);
			if (dataEquip.length <= 0)	
			{
				buttonSelectOnePage.SetDisable();
				buttonSelectAll.SetDisable();
				buttonDeselectAll.SetDisable();
			}
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Chọn tất cả trang bị";
			buttonSelectAll.setTooltip(tip);
			tip = new TooltipFormat();
			tip.text = "Chọn trang này";
			buttonSelectOnePage.setTooltip(tip);
			tip = new TooltipFormat();
			tip.text = "Bỏ chọn tất cả";
			buttonDeselectAll.setTooltip(tip);
			
			buttonAdd = ctnEquip.AddButton(BTN_ADD, "BtnAdd", 237, 311, this);
			buttonSub = ctnEquip.AddButton(BTN_SUB, "BtnSub", 132, 311, this);
			
			var smithyData:Object = GameLogic.getInstance().user.smithyData;
			txtNum = ctnEquip.AddTextBox(TXTBOX_NUM, "1", 170, 312, 30, 20, this);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xFFFF80, true);
			txtFormat.align = TextFormatAlign.RIGHT;
			txtNum.SetTextFormat(txtFormat);
			txtNum.SetDefaultFormat(txtFormat);
			
			var c:Container = ctnEquip.AddContainer("PointBg", "TotalPointBg", 200, 220);
			tip = new TooltipFormat();
			tip.text = "Điểm yêu cầu";
			c.setTooltip(tip);
			
			var conf:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Finish");
			var oRank:int = mapRank[comboBoxRank.selectedItem];
			var oColor:int = mapQuality[comboBoxQuality.selectedItem];
			txtRequirePoint = c.AddLabel(Ultility.StandardNumber(conf[oRank][oColor]["Point"]), 30, 3);
			txtRequirePoint.setTextFormat(new TextFormat("arial", 14, 0x00ffff, true));
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4);
			txtRequirePoint.filters = [glow];
			
			pointBg = ctnEquip.AddContainer("", "PointBg", 460, 10);
			tip = new TooltipFormat();
			tip.text = "Điểm chế tạo";
			pointBg.setTooltip(tip);
			
			//imgArrow = ctnEquip.AddImage("", "IcHelper", 370, 320, true, ALIGN_LEFT_TOP);
			//imgArrow.img.rotation = -90;
			//txtDetail = ctnEquip.AddLabel("9", 145, 325); 
			txtTotalPoint = ctnEquip.AddLabel("0", 480, 10);
			totalPercent = smithyData["HammerMan"]["TotalPercent"];
			
			txtCost = ctnEquip.AddLabel("0", 95, 350);
			txtCostG = ctnEquip.AddLabel("0", 190, 350);
			buttonMakeEquipGold = ctnEquip.AddButton(BTN_MAKE_EQUIP_GOLD, "BtnMakeEquipGold", 95, 375, this);
			buttonMakeEquipG = ctnEquip.AddButton(BTN_MAKE_EQUIP_G, "BtnMakeEquipG", 200, 375, this);
			//setContentTabEquip();
			buttonBreak = ctnEquip.AddButton(BTN_BREAK, "BtnBreak", 485, 420, this);
			buttonBreak.SetEnable(false);
			
			maxNum = totalPercent / Ultility.ConvertStringToInt(txtRequirePoint.text);
			txtNum.textField.text = String(maxNum);
			updateAddSubButton();
			
			var e:FishEquipment = new FishEquipment();
			var o:Object = new Object();
			o.Color = mapQuality[comboBoxQuality.selectedItem];
			o.Type = mapEquip[comboBoxKind.selectedItem];
			if (mapEquip[comboBoxKind.selectedItem] == "Ring" || mapEquip[comboBoxKind.selectedItem] == "Necklace" 
			|| mapEquip[comboBoxKind.selectedItem] == "Bracelet" || mapEquip[comboBoxKind.selectedItem] == "Belt")
			{
				o.Rank = mapRank[comboBoxRank.selectedItem];
				o.Element = 0;
			}
			else
			{
				o.Rank = mapElement[comboBoxElement.selectedItem] * 100 + mapRank[comboBoxRank.selectedItem];
				o.Element = mapElement[comboBoxElement.selectedItem];
			}
			e.SetInfo(o);
			var ctn:Container = ctnEquip.AddContainer("NewEquip_1", FishEquipment.GetBackgroundName(2), 235, 90, true, this);
			if (e.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				ctn.LoadRes(FishEquipment.GetBackgroundName(e.Color), true);
			}
			var imag:Image = ctn.AddImage("", e.imageName + "_Shop", 0, 0);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, e.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
			FishSoldier.EquipmentEffect(imag.img, e.Color);
			
			percent = 0;
		}
		
		private function updateAddSubButton(buttonId:String = ""):void 
		{
			var num:int = int(txtNum.GetText());
			if (buttonId != "")
			{
				if (buttonId == BTN_SUB)
				{
					if (num > 0)	num--;
				}
				else
				{
					if (num < maxNum)	num++;
				}
				txtNum.SetText(num.toString());
				txtNum.textField.stage.focus = txtBox.textField;
				txtNum.textField.setSelection(0, txtBox.textField.length);
			}
			buttonAdd.SetDisable();
			buttonSub.SetDisable();
			if (num > 0) buttonSub.SetEnable();
			if (num < maxNum)	buttonAdd.SetEnable();
			
			buttonMakeEquipGold.SetDisable();
			buttonMakeEquipG.SetDisable();
			costG = costGold = 0;
			if (num <= 0)	return;
			var cf:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Finish");
			var oRank:int = mapRank[comboBoxRank.selectedItem];
			var oColor:int = mapQuality[comboBoxQuality.selectedItem];
			costGold = cf[oRank][oColor]["Money"] * num;
			costG = cf[oRank][oColor]["ZMoney"] * num;
			if (GameLogic.getInstance().user.GetMoney() >= costGold)		buttonMakeEquipGold.SetEnable();
			if (GameLogic.getInstance().user.GetZMoney() >= costG)		buttonMakeEquipG.SetEnable();
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			var num:int;
			if (txtID == TXTBOX_PAGE)
			{
				num = int(txtBox.GetText());
				if (num < 1) num = 1;
				if (num > numPage) num = numPage;
				curPage = num;
				txtBox.SetText(curPage.toString());
				addList(currentList, oEquip, (num - 1) * 9 + 1, num * 9);
				updateNextBackBtn();
			}
			else if (txtID == TXTBOX_NUM)
			{
				num = int(txtNum.GetText());
				if (num < 0) num = 0;
				if (num > maxNum) num = maxNum;
				txtNum.SetText(num.toString());
				updateAddSubButton();
			}
		}
		
		override public function onComboboxChange(event:Event, comboboxId:String):void 
		{
			switch(comboboxId)
			{
				case COMBOBOX_KIND:
					shareObj.data.type = comboBoxKind.selectedItem;
					comboBoxElement.visible = labelElement.visible = true;
					labelQuality.y = comboBoxQuality.y = 285;
					if (mapEquip[comboBoxKind.selectedItem] == "Ring" || mapEquip[comboBoxKind.selectedItem] == "Necklace" 
					|| mapEquip[comboBoxKind.selectedItem] == "Bracelet" || mapEquip[comboBoxKind.selectedItem] == "Belt")
					{
						comboBoxElement.visible = labelElement.visible = false;
						labelQuality.y = comboBoxQuality.y = 240;
					}
					break;
				case COMBOBOX_ELEMENT:
					shareObj.data.element = comboBoxElement.selectedItem;
					break;
				case COMBOBOX_QUALITY:
					shareObj.data.color = comboBoxQuality.selectedItem;
					break;
				case COMBOBOX_RANK:
					shareObj.data.rank = comboBoxRank.selectedItem;
					break;
			}
			resetChoosenList();
			updateTabEquip();
			filterListEquip();
		}
		
		private var oEquip:Array;
		private var curPage:int;
		private	var numPage:int;
		private function filterListEquip(curSubTab:String = ""):void 
		{
			var type:String;
			var element:int;
			var color:int;
			var s:int;
			var numElementInList:int;
			oEquip = new Array();
			ind = "";
			switch(currentTab)
			{
				case BTN_TAB_EQUIP:
					color = mapQuality[comboBoxQuality.selectedItem];
					
					if (dataEquip.length > 0)
					{
						for (s = 0; s < dataEquip.length; s++ )
						{
							if (dataEquip[s] == null)	continue;
							//if (dataEquip[s]["Rank"] % 100 > mapRank[comboBoxRank.selectedItem]) continue;
							//if (dataEquip[s]["Rank"] % 100 >= 5) continue;	//chưa cho dùng đồ cấp 5
							if (dataEquip[s]["Color"] >= 5) continue;	//ko dùng đổ VIP
							oEquip[s] = dataEquip[s];
							numElementInList++;
						}
					}
					else
					{
						oEquip = dataEquip;
					}
					addList(listEquip, oEquip);
					if (listEquip.length <= 0)
					{
						buttonSelectAll.SetEnable(false);
						buttonSelectOnePage.SetEnable(false);
					}
					else
					{
						buttonSelectAll.SetEnable(true);
						buttonSelectOnePage.SetEnable(true);
					}
					break;
				case BTN_TAB_CUSTOM:
					if (dataEquip.length > 0)
					{
						for (s = 0; s < dataEquip.length; s++ )
						{
							//if (dataEquip[s]["Rank"] % 100 >= 5) continue; //chưa cho dùng đồ cấp 5
							if (dataEquip[s]["Color"] < 2 || dataEquip[s]["Color"] >= 5) continue;		//Không dùng đồ thường & đồ VIP
							var smithyData:Object = GameLogic.getInstance().user.smithyData;
							var num:int = smithyData["LimitChangeOption"][dataEquip[s]["Color"]];
							if (num - dataEquip[s]["NumChangeOption"] > 0)
							{
								if (curSubTab.split("_")[1] != "Jewel")
								{
									if (dataEquip[s]["Type"] == curSubTab.split("_")[1])
									{
										numElementInList++;
										oEquip[s] = dataEquip[s];
									}
								}
								else
								{
									if (dataEquip[s]["Type"] == "Ring" || dataEquip[s]["Type"] == "Necklace" || dataEquip[s]["Type"] == "Bracelet" || dataEquip[s]["Type"] == "Belt")
									{
										numElementInList++;
										oEquip[s] = dataEquip[s];
									}
								}
							}
						}
					}
					else
					{
						oEquip = dataEquip;
					}
					addList(listCustom, oEquip);
					break;
			}
			if (tx != null && img.contains(tx))
			{
				img.removeChild(tx);
				tx = null;
			}
			if (oEquip.length <= 0)
			{
				tx = AddLabel("Không có trang bị nào", 500, 200, 0xFFFF00, 1, 0x000000);
				var tF:TextFormat = new TextFormat();
				tF.size = 18;
				tx.setTextFormat(tF);
			}
			curPage = 1;
			numPage = numElementInList / 9 + 1;
			if (numElementInList % 9 == 0)
				numPage = numElementInList / 9;
			txtBox.SetText(curPage.toString());
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			labelPage.text = "/" + numPage;
			updateNextBackBtn();
		}
		
		private function setBtnOnePage():void
		{
			if (currentTab == BTN_TAB_CUSTOM)	return;
			var j:int;
			for (var i:int = 0; i < listEquip.itemList.length; i++)
			{
				var ctn:Container = listEquip.itemList[i] as Container;
				if (ctn.GetImage("ImgMark").img.visible)	j++;
				if (j >= listEquip.itemList.length)	
					buttonSelectOnePage.SetEnable(false);
				else
					buttonSelectOnePage.SetEnable(true);
			}
		}
		
		private var tx:TextField;
		private var markList:Array = [];
		private var ind:String = "";
		private function addList(listBox:ListBox, data:Object, fromE:int = 1, toE:int = 9):void
		{
			listBox.removeAllItem();
			var smithyData:Object = GameLogic.getInstance().user.smithyData;
			if (data != null)
			{
				var i:int;
				for (var s:int = 0; s < data.length; s++)
				{
					if (!data.hasOwnProperty(s))	continue;
					if (data[s].Id <= 0)	continue;
					i++;
					if (i >= fromE && i <= toE)
					{
						var ctn:Container = new Container(img, "CtnEquipment", 0, 0);
						var o:FishEquipment = data[s] as FishEquipment;
						if (o.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
						{
							ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), 0, 0, true, ALIGN_LEFT_TOP, true);
						}
						var imag:Image = ctn.AddImage("", o.imageName + "_Shop", 10, 10);
						imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, o.Color) };
						imag.FitRect(60, 60, new Point(7, 7));
						FishSoldier.EquipmentEffect(imag.img, o.Color);
						
						if (o.EnchantLevel > 0)
						{
							var txt:TextField = ctn.AddLabel("+" + o.EnchantLevel, 2, 2, 0xFFF100, 0, 0x603813);
							var tF:TextFormat = new TextFormat();
							tF.size = 18;
							tF.bold = true;
							txt.setTextFormat(tF);
						}
						if (currentTab == BTN_TAB_CUSTOM)
						{
							ctn.AddImage("", "NumChangeBg", 60, 70);
							var tip:TooltipFormat = new TooltipFormat();
							var num:int = smithyData["LimitChangeOption"][o.Color];
							ctn.AddTextBox("NumChange", String(num - o.NumChangeOption), 53, 57, 20, 30);
							tip.text = "Còn " + (num - o.NumChangeOption).toString() + " lần tùy biến";
							ctn.setTooltip(tip);
							var tf:TextField = ctn.GetTextBox("NumChange").textField as TextField;	
							tf.mouseEnabled = false;
							tf.setTextFormat(new TextFormat("arial", 18, 0xFFFF00, true));
							var glow:GlowFilter = new GlowFilter(0x6D3636, 1, 4, 4);
							tf.filters = [glow];
							if (ind != "" && int(ind.split("_")[1]) == s)	ctn.SetHighLight(0xFFFFFF);
						}
						else
						{
							var cf1:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Lookup");
							var iRank:int = o.Rank % 100;
							var iColor:int = o.Color;
							ctn.AddLabel(Ultility.StandardNumber(cf1[iRank][iColor]["Percent"]), -25, 55, 0x00FFFF, 1, 0x000000);
							
							ctn.AddImage("CheckBg", "CheckBg", 60, 60);
							ctn.AddImage("ImgMark", "ImgMark", 60, 60);
							ctn.GetImage("ImgMark").img.visible = false;
							if (markList[int(s)] && markList[int(s)] == true)
								ctn.GetImage("ImgMark").img.visible = true;
						}
						
						listBox.addItem("Ctn" + o.Type + "_" + s, ctn, this);
						ContainerArr.splice(ContainerArr.length - 1, 1);
					}
				}
				setBtnOnePage();
			}
		}
		
		public function updateNextBackBtn(buttonId:String = ""):void
		{
			if (buttonId != "")
			{
				if (buttonId == BTN_BACK)
				{
					if (curPage > 1)	curPage--;
				}
				else
				{
					if (curPage < numPage)	curPage++;
				}
				txtBox.SetText(curPage.toString());
				txtBox.textField.stage.focus = txtBox.textField;
				txtBox.textField.setSelection(0, txtBox.textField.length);
				labelPage.text = "/" + (numPage);
				addList(currentList, oEquip, (curPage - 1) * 9 + 1, curPage * 9);
			}
			if (numPage <= 1)	
			{
				GetButton(BTN_NEXT).SetEnable(false);
				GetButton(BTN_BACK).SetEnable(false);
			}
			GetButton(BTN_BACK).SetEnable(false);
			GetButton(BTN_NEXT).SetEnable(false);
			if (curPage > 1)	GetButton(BTN_BACK).SetEnable(true);
			if (curPage < numPage)	GetButton(BTN_NEXT).SetEnable(true);
		}
		
		private function enableButton(visible:Boolean = true):void
		{
			if (!this.IsVisible) return;
			buttonTabCustom.SetEnable(visible);
			buttonTabEquip.SetEnable(visible);
			buttonClose.SetEnable(visible);
			GetButton(BTN_BACK).SetEnable(visible);
			GetButton(BTN_NEXT).SetEnable(visible);
			if (currentTab == BTN_TAB_EQUIP)
			{
				buttonSelectAll.SetEnable();
				buttonSelectOnePage.SetEnable();
				buttonDeselectAll.SetEnable();
				if (dataEquip.length <= 0)	
				{
					buttonSelectOnePage.SetDisable();
					buttonSelectAll.SetDisable();
					buttonDeselectAll.SetDisable();
				}
				buttonAdd.SetEnable(visible);
				buttonSub.SetEnable(visible);
				buttonBreak.SetEnable();
				if (choosenList.length <= 0)	buttonBreak.SetEnable(false);
				for (var i:int = 0; i < listEquip.length; i++ )
				{
					var ctn:Container = listEquip.itemList[i] as Container;
					ctn.enable = visible;
				}
			}
			else
			{
				if (buttonChange && buttonChange.img)	
					buttonChange.SetEnable(visible);
			}
			comboBoxKind.setEnable(visible);
			comboBoxElement.setEnable(visible);
			comboBoxQuality.setEnable(visible);
			comboBoxRank.setEnable(visible);
		}
		
		private function getCurPercent():int
		{
			var smithyData:Object = GameLogic.getInstance().user.smithyData;
			var oP:Object = smithyData["HammerMan"]["Percent"];
			var cP:int;
			for (var s:String in oP)
			{
				if (s == mapEquip[comboBoxKind.selectedItem])
				{
					for (var t:String in oP[s])
					{
						if (t == mapRank[comboBoxRank.selectedItem])
						{
							for (var k:String in oP[s][t])
							{
								if (k == mapQuality[comboBoxQuality.selectedItem])
								{
									for (var u:String in oP[s][t][k])
									{
										if (u == "0" || u == mapElement[comboBoxElement.selectedItem])		cP = oP[s][t][k][u];
									}
								}
							}
						}
					}
				}
			}
			return cP;
		}
		
		public function processMakeEquip(data1:Object, sendData:SendMakeEquipment):void 
		{
			var numPoint:Number = Ultility.ConvertStringToInt(txtRequirePoint.text) * int(txtNum.GetText());
			var p:Point = new Point(680, 180);
			Ultility.ShowEffText("-" + Ultility.StandardNumber(numPoint), img, p, new Point(p.x, p.y - 30), new TextFormat("arial", 15, 0xFF0000, true), 1, 0xFFFFFF);
			var smithyData:Object = GameLogic.getInstance().user.smithyData;
			effMakeEquip.GoToAndPlay(1);
			effMakeEquip.img.addEventListener(Event.ENTER_FRAME, effRun);
			function effRun():void
			{
				if (effMakeEquip.currentFrame >= effMakeEquip.totalFrames)
				{
					effMakeEquip.img.removeEventListener(Event.ENTER_FRAME, effRun);
					effMakeEquip.GoToAndStop(1);
					
					if (data1.hasOwnProperty("Equipment") && data1["Equipment"])	
					{
						var e:FishEquipment;
						for (var i:int = 0; i < data1["Equipment"].length; i++ )
						{
							e = new FishEquipment()
							e.SetInfo(data1["Equipment"][i]);
							GameLogic.getInstance().user.UpdateEquipmentToStore(e);
							GameLogic.getInstance().user.GenerateNextID();
							dataEquip.push(e);
						}
						if (data1["Equipment"].length > 1)
							GuiMgr.getInstance().guiReceiveMoreEquip.showGift(data1["Equipment"]);
						else
							GuiMgr.getInstance().guiReceiveOneEquip.showGift(data1["Equipment"]);
					}
					totalPercent -= numPoint;
					GameLogic.getInstance().user.smithyData["HammerMan"]["TotalPercent"] = totalPercent;
					maxNum = totalPercent / Ultility.ConvertStringToInt(txtRequirePoint.text);
					txtNum.textField.text = String(maxNum);
					endMakeEquip(sendData.PriceType);
				}
			}
		}
		
		public function processBreakEquip(data1:Object):void 
		{
			for (i = 0; i < listEquip.length; i++ )
			{
				var container:Container = listEquip.itemList[i] as Container;
				if (container.GetImage("ImgMark").img.visible)
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffSeparate", null, container.img.x + 460, container.img.y + 170);
			}
			for (var i:int = 0; i < choosenList.length; i++)
			{
				for (var j:int = 0; j < dataEquip.length; j++)
				{
					if (choosenList[i] == dataEquip[j])
					{
						dataEquip.splice(j, 1);
						break;
					}
				}
			}
			if (percent > 0)
			{
				var p:Point = new Point(680, 180);
				Ultility.ShowEffText("+" + Ultility.StandardNumber(percent), img, p, new Point(p.x, p.y - 30), new TextFormat("arial", 15, 0x00FFFF, true), 1, 0x000000);
			}
			totalPercent = data1["TotalPercent"];
			GameLogic.getInstance().user.smithyData["HammerMan"]["TotalPercent"] = totalPercent;
			maxNum = totalPercent / Ultility.ConvertStringToInt(txtRequirePoint.text);
			txtNum.textField.text = String(maxNum);
			updateAddSubButton();
			resetChoosenList();
			sortList();
			filterListEquip();
			percent = 0;
			enableButton();
		}
		
		private function endMakeEquip(priceType:String):void 
		{
			if (priceType == "Money")
				GameLogic.getInstance().user.UpdateUserMoney(-costGold);
			else
				GameLogic.getInstance().user.UpdateUserZMoney(-costG);
			enableButton();
			filterListEquip();
			updateTabEquip();
		}
		
		private function resetChoosenList():void
		{
			choosenList = [];
			for (var i:int = 0; i < markList.length; i++ )
			{
				markList[i] = false;
			}
		}
		
		public function processMakeCustom(data1:Object):void 
		{
			var smithData:Object = GameLogic.getInstance().user.smithyData["HammerMan"];
			equipSelected.NumChangeOption++;
			smithData["TempEquipment"] = data1["TempEquipment"];
			updateTabCustom(equipSelected, data1["NewBonus"]);
			for (var i:int = 0; i < dataEquip.length; i++ )
			{
				if (dataEquip[i] == equipSelected)
				{
					dataEquip.splice(i, 1);
					GameLogic.getInstance().user.UpdateEquipmentToStore(equipSelected, false);
					break;
				}
			}
			filterListEquip(curSubTab);
			var obj:Object = new Object();
			obj.ItemId = equipSelected.Id;
			obj.bonus = data1["NewBonus"];
			GameLogic.getInstance().user.smithyData["HammerMan"]["TempBonus"] = obj;
			for (i = 0; i < data1["NewBonus"].length; i++ )
			{
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffChange", null, 130, 290 + 30 * i, false, false, null, enableButton);
			}
		}
		
		public function processSaveEquip(data1:Object):void 
		{
			var e:FishEquipment = new FishEquipment();
			e.SetInfo(data1["Equipment"]);
			equipSelected = e;
			
			GameLogic.getInstance().user.smithyData["HammerMan"]["TempBonus"] = null;
			GameLogic.getInstance().user.UpdateEquipmentToStore(equipSelected);
			dataEquip.push(equipSelected);
			sortList();
			filterListEquip(curSubTab);
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffSave", null, 260, 285, false, false, null, stopEff);
			function stopEff():void
			{
				enableButton();
				updateTabCustom(equipSelected);
			}
		}
		
		public function updatePowerTinh():void 
		{
			if (currentTab != BTN_TAB_CUSTOM)	return;
			ctnEquip.ClearComponent();
			ctnEquip.AddImage("", "Ctn" + currentTab, 0, 0, true, ALIGN_LEFT_TOP);
			var buttonBuy:Button = ctnEquip.AddButton(BTN_BUY, "BtnBuyPowerTinh", 250, 430, this);
			var smithyData:Object = GameLogic.getInstance().user.smithyData["HammerMan"];
			if (equipSelected != null)
			{
				if (smithyData.TempBonus && !(smithyData.TempBonus as Array))
				{
					addEquipInfo(equipSelected, smithyData.TempBonus.bonus);
				}
				else
				{
					addEquipInfo(equipSelected, []);
				}
			}
			else
			{
				if (smithyData.TempBonus && !(smithyData.TempBonus as Array))
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(smithyData.TempEquipment);
					var nB:Array = [];
					equipSelected = equip;
					nB = nB.concat(smithyData.TempBonus.bonus);
					addEquipInfo(equip, nB);
					isChanging = true;
				}
			}
			var myPT:Number = GameLogic.getInstance().user.getPowerTinh();
			var txtMyPT:TextField = ctnEquip.AddLabel(Ultility.StandardNumber(myPT), 135, 425);
			txtMyPT.setTextFormat(new TextFormat("arial", 14, 0xFFFFFF, true));
			if (!isChanging)
			{
				buttonChange = ctnEquip.AddButton(BTN_MAKE_OPTION, "BtnChangeOption", 120, 360, this);
				if (equipSelected != null)
				{
					var cf:Object = ConfigJSON.getInstance().getItemInfo("HammerMan_Option");
					var rank:int = equipSelected.Rank % 100;
					var txtPT:TextField = ctnEquip.AddLabel(Ultility.StandardNumber(cf[rank][equipSelected.Color]["Power"]), 140, 330);
					txtPT.setTextFormat(new TextFormat("arial", 18, 0x003300, true));
				}
			}
			else
			{
				buttonSave = ctnEquip.AddButton(BTN_SAVE, "BtnSmithySave", 220, 340, this);
				buttonCancel = ctnEquip.AddButton(BTN_CANCEL, "BtnSmithyCancel", 50, 340, this);
			}
		}
		
		private var frame:int;
		private var txtCostG:TextField;
		public function get costGold():Number 
		{
			return _costGold;
		}
		
		public function set costGold(value:Number):void 
		{
			_costGold = value;
			costG = Math.ceil(value / 1000000);
			txtCost.text = String(Ultility.StandardNumber(value));
			txtCost.setTextFormat(new TextFormat("arial", 16, 0xFFFF00, true));
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4);
			txtCost.filters = [glow];
		}
		
		public function get costG():Number 
		{
			return _costG;
		}
		
		public function set costG(value:Number):void 
		{
			_costG = value;
			txtCostG.text = String(Ultility.StandardNumber(value));
			txtCostG.setTextFormat(new TextFormat("arial", 16, 0x00F200, true));
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4);
			txtCostG.filters = [glow];
		}
		
		public function get totalPercent():Number 
		{
			return _totalPercent;
		}
		
		public function set totalPercent(value:Number):void 
		{
			_totalPercent = value;
			txtTotalPoint.text = Ultility.StandardNumber(value);
			txtTotalPoint.setTextFormat(new TextFormat("arial", 14, 0x00ffff, true));
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4);
			txtTotalPoint.filters = [glow];
		}
	}
}