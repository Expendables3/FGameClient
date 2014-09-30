package GUI.TrungLinhThach 
{
	import com.adobe.images.BitString;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
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
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	import Logic.Ultility;
	import Logic.GameLogic;
	import GUI.FishWar.FishEquipment;
	import GUI.GUIFeedWall;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIUpdateLinhThach extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_BACK:String = "BtnBackList";
		static public const BTN_NEXT:String = "BtnNextList";
		static public const TXTBOX_PAGE:String = "TxtboxPage";
		static public const BTN_CHECK_ALL:String = "btnCheckAll";
		static public const BTN_REMOVE_CHECK_ALL:String = "btnRemoveCheckAll";
		static public const BTN_CHECK_ONE_PAGE:String = "btnCheckOnePage";
		static public const BTN_HAP_THU:String = "btnHapThu";
		static public const ITEM_LINH_THACH:String = "CtnItemTrung";
		
		private var buttonBack:Button;
		private var buttonNext:Button;
		private var buttonClose:Button;
		private var btnCheckAll:Button;
		private var btnRemoveCheckAll:Button;
		private var btnHapThu:Button;
		private var buttonCheckOnePage:Button;
		
		private var labelPage:TextField;
		private var txtBox:TextBox;
		private var prgLevel:ProgressBar;
		private var textPoint:TextField;
		private var textLevel:TextField;
		private var textNumBonus:TextField;
		private var reportFull:TextField;
		private var currentList:ListBox;
		private var listCustom:ListBox;
		private var textNumItem:TextField;
		private var imageItem:Image;
		private var textGold:TextField;
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		public var IsInitFinish:Boolean = false;
		
		private var oEquip:Object;
		private var curPage:int;
		private var dataEquip:Array = new Array();
		private var choosenList:Array = new Array();
		private var ItemList:Array = new Array();
		private	var numPage:int;
		private var curIdSoldier:int;
		private var curTabQuartz:String = "QWhite";
		private var quartzsCheckArr:Array = new Array();
		private var itemPage:int = 9;
		private var objDataUpLevel:Object;
		private var totalPointUpdate:int = 0;
		private var ctnItemUpdate:Container;
		private var isHapThu:Boolean = false;
		private var selectAll:Boolean = false;
		private var progressHapThu:Image;
		private var itemUpdate:Image;
		private var slotIndex:int;
		private var arrPageCheckOne:Array = new Array();
		private var isLoadEff:Boolean = false;
		private var isEffect:Boolean = false;
		private var numGold:int = 0;
		private var levelUpdate:int = 0;
		private var typeUpdate:String = "";
		
		private const maxLevl:Object = 
		{
			"QWhite":"5", "QGreen":"10", "QYellow":"15", "QPurple":"20", "QVIP":"20"
		}
		
		public function GUIUpdateLinhThach(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			isDataReady = false;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiUpdateLinhThach";
		}
		
		override public function InitGUI():void 
		{
			//trace("InitGUI()");
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
				
				OpenRoomOut();
			}
			LoadRes("GuiUpdateLinhThach_Bg");
		}
		
		public function showGUI(idSoldier:int, tabQuartz:String, obj:Object, slot:int):void
		{
			isLoadEff = false;
			curIdSoldier = idSoldier;
			curTabQuartz = tabQuartz; 
			objDataUpLevel = obj;
			slotIndex = slot;
			
			quartzsCheckArr = [];
			isHapThu = false;
			//quartzsCheckArr.splice(0, quartzsCheckArr.length);
			ItemList.splice(0, ItemList.length);
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
			
			var typeArr:Array = new Array();
			if (objDataUpLevel.Type == "QWhite")
			{
				typeArr = ["QWhite"];
			}
			else if (objDataUpLevel.Type == "QGreen")
			{
				typeArr = ["QWhite", "QGreen"];
			}
			else if (objDataUpLevel.Type == "QYellow")
			{
				typeArr = ["QWhite", "QGreen", "QYellow"];
			}
			else if (objDataUpLevel.Type == "QPurple")
			{
				typeArr = ["QWhite", "QGreen", "QYellow", "QPurple"];
			}
			else if (objDataUpLevel.Type == "QVIP")
			{
				typeArr = ["QWhite", "QGreen", "QYellow", "QPurple", "QVIP"];
			}
			//trace("Type== " + objDataUpLevel.Type + " |typeArr.length== " + typeArr.length)
			updateDataQuartz(false, objDataUpLevel.Level, typeArr);
			addContent();
		}
		
		private function updateDataQuartz(isList:Boolean, levelFil:int, typeArr:Array):void
		{
			dataEquip.splice(0, dataEquip.length);
			for (var j:int = 0; j < typeArr.length; j++ )
			{
				var data:Array = GameLogic.getInstance().user.GetStore(typeArr[j]);
				//trace("updateDataQuartz trên dataEquip.length== " + dataEquip.length);
				//trace("updateDataQuartz levelFil=== " + levelFil + " |typeArr[j]=== " + typeArr[j]);
				if (data)
				{
				//	trace("updateDataQuartz data.length== " + data.length);
					for (var i:int = 0; i < data.length; i++)
					{
						//trace("data[i].Level== " + data[i].Level + " |objDataUpLevel.Level== " + objDataUpLevel.Level);
						if (objDataUpLevel.Type == data[i].Type)
						{
						//	trace("data[i].levelFil== " + data[i].levelFil + " |data[i].Id== " + data[i].Id + " |objDataUpLevel.Id== " + objDataUpLevel.Id);
							//if (data[i].Level <= levelFil && data[i].Id != objDataUpLevel.Id)
							if (data[i].Id != objDataUpLevel.Id)
							{
								dataEquip.push(data[i]);
							//	trace("----du dieu kien push data");
							}
						}
						else
						{
							dataEquip.push(data[i]);
						}
					}
				}
			}
			
			if (isList)
			{
				filterListEquip(true);
			}
			//trace("updateDataQuartz dưới dataEquip.length== " + dataEquip.length);
		}
		
		/*Add thong tin content cho Gui*/
		private function addContent():void
		{
			addContentUpdate();
			
			listCustom = AddListBox(ListBox.LIST_X, 3, 3, 7, 4);
			listCustom.setPos(94, 119);
			
			buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 744, 52);
			buttonClose.setTooltipText("Đóng lại");
			
			progressHapThu = AddImage("", "progressHapThu", 465, 284);
			progressHapThu.GoToAndStop(1);
			
			labelPage = AddLabel("/1", 220, 490, 0xffffff, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			labelPage.setTextFormat(txtFormat);
			labelPage.defaultTextFormat = txtFormat;
			
			txtBox = AddTextBox(TXTBOX_PAGE, "1", 190, 490, 30, 20, this);
			txtFormat = new TextFormat("arial", 15, 0xffffff, true);
			txtFormat.align = TextFormatAlign.RIGHT;
			txtBox.SetTextFormat(txtFormat);
			txtBox.SetDefaultFormat(txtFormat);
			
			buttonBack = AddButton(BTN_BACK, "GuiUpdateLinhThach_BtnBack", 140, 488, this);
			buttonNext = AddButton(BTN_NEXT, "GuiUpdateLinhThach_BtnNext", 290, 488, this);
			
			filterListEquip(false);
			currentList = listCustom;
			
		}
		
		private function addContentUpdate():void
		{	
			btnCheckAll = AddButton(BTN_CHECK_ALL, "GuiUpdateLinhThach_CheckAll", 180, 538);
			btnRemoveCheckAll = AddButton(BTN_REMOVE_CHECK_ALL, "GuiUpdateLinhThach_RemoveAll", 280, 538);
			buttonCheckOnePage = AddButton(BTN_CHECK_ONE_PAGE, "GuiUpdateLinhThach_BtnSelectOnePage", 80, 538, this);
			btnHapThu = AddButton(BTN_HAP_THU, "GuiUpdateLinhThach_HapThu", 415, 390);
			
			AddImage("", "GuiUpdateLinhThach_Gold", 410, 360);
			
			textGold = AddLabel("", 426, 350, 0xFFFF00, 0);
			numGold = 0;
			pustTotalGoldUpdate();
			
			levelUpdate = 0;
			typeUpdate = "";
			
			var fmPoint:TextFormat = new TextFormat("arial", 15, 0xFF0000, true, null, null, null, null, "center");
			reportFull = AddLabel("", 585, 410, 0x000000, 1);
			reportFull.defaultTextFormat = fmPoint;
			reportFull.text = "Đã đạt cấp tối đa!";
			reportFull.visible = false;
			
			var max:int = maxLevl[objDataUpLevel.Type];
			//trace("Type== " + objDataUpLevel.Type + " |max== " + max + " |level== " + objDataUpLevel.Level);
			if (objDataUpLevel.Level >= max)
			{
				//trace("max roi con dau-------------");
				btnHapThu.SetVisible(false);
				reportFull.visible = true;
			}
			//Tong diem khi chon cac Item de nang cap
			textNumBonus = AddLabel("", 409, 270, 0x000000, 1);
			totalPointUpdate = 0;
			pustTotalPointUpdate();
			ctnItemUpdate = new Container(img, "GuiUpdateLinhThach_BgItemUpdate", 545, 220);
			contentItemUpdate(objDataUpLevel, false);
		}
		
		private function pustTotalGoldUpdate():void
		{
			var glowPoint:GlowFilter = new GlowFilter(0x000000, 1, 4, 4, 10);
			var fmGold:TextFormat = new TextFormat("arial", 17, 0xFFFF00, true);
			textGold.defaultTextFormat = fmGold;
			textGold.text = Ultility.StandardNumber(numGold);
			textGold.filters = [glowPoint];
		}
		
		private function pustTotalPointUpdate():void
		{
			var glow:GlowFilter = new GlowFilter(0x330000, 1, 6, 6, 10); 
			var fmBonus:TextFormat = new TextFormat("arial", 25, 0xFFFF00);
			textNumBonus.defaultTextFormat = fmBonus;
			textNumBonus.text = Ultility.StandardNumber(totalPointUpdate);
			textNumBonus.filters = [glow];
		}
		
		private function contentItemUpdate(obj:Object, isUpdate:Boolean):void
		{
			ctnItemUpdate.ClearComponent();
			
			var imageNen:Image  = ctnItemUpdate.AddImage("", "Update_Bg_Item_" + obj.Type, 93, 60);
			imageNen.img.cacheAsBitmap = false;
			
			var glow:GlowFilter = new GlowFilter(0x330000, 1, 6, 6, 10); 
			var glowNum:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
			
			/*if (obj.ItemId > 4)
			{
				obj.ItemId = 0;
			}*/
			var imagName:String = obj.Type + obj.ItemId;
			var imag1:Image = ctnItemUpdate.AddImage(obj.Id, imagName, 95, 70);
			
			textNumItem  = ctnItemUpdate.AddLabel("", 44, 5, 0x000000, 1);
			var fmNumItem:TextFormat = new TextFormat("arial", 15, 0xFFFF00);
			textNumItem.defaultTextFormat = fmNumItem;
			textNumItem.text = Ultility.StandardNumber(obj.Level);
			textNumItem.filters = [glow];
			
			textLevel = ctnItemUpdate.AddLabel("", -24, 137, 0x000000, 1);
			var fmLevel:TextFormat = new TextFormat("arial", 15, 0xFFFFFF);
			textLevel.defaultTextFormat = fmLevel;
			textLevel.text = 'Cấp ' + obj.Level;
			
			var numPoint:Number =  obj.Point;// ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[obj.Type][obj.Level]["Point"];
			var totalPoint:Number = 0;
			var max:int = maxLevl[obj.Type];
			if (obj.Level == max)
			{
				numPoint = 0;
				totalPoint = 1;
			}
			else
			{
				//trace("obj.Type== " + obj.Type + " |obj.Level== " + obj.Level);
				totalPoint = ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[obj.Type][obj.Level + 1]["RequirePoint"];
			}
			prgLevel = ctnItemUpdate.AddProgress("", "GuiUpdateLinhThach_progresLevel", 60, 140, this);
			if (isUpdate)
			{
				//GameLogic.getInstance().AddPrgToProcess(prgLevel, numPoint / totalPoint);
				prgLevel.setStatusProgress(numPoint / totalPoint, 0.5, true, true); //Hieu ung chay progress bar cho dep
			}
			else
			{
				prgLevel.setStatus(numPoint / totalPoint);
			}
			
			
			var glowPoint:GlowFilter = new GlowFilter(0xFFFFFF, 1, 4, 4, 10); 
			textPoint = ctnItemUpdate.AddLabel("", 60, 137, 0x000000, 1);
			var fmPoint:TextFormat = new TextFormat("arial", 15, 0x000000, true, null, null, null, null, "center");
			textPoint.defaultTextFormat = fmPoint;
			if (obj.Level == max)
			{
				numPoint = 0;
				totalPoint = 0;
			}
			textPoint.text = Ultility.StandardNumber(numPoint) + ' / ' + Ultility.StandardNumber(totalPoint);
			textPoint.filters = [glowPoint];
			
			var GuiToolTip:GUIUpdateLinhThachToolTip = new GUIUpdateLinhThachToolTip(null, "");
			var globalParent:Point = ctnItemUpdate.img.localToGlobal(new Point(0, 0));
			GuiToolTip.Init(obj);
			GuiToolTip.InitPos(ctnItemUpdate, "GuiUpdateLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
			/*if (ctnItemUpdate.guiTooltip)
			{
				ctnItemUpdate.guiTooltip.Destructor();
			}*/
			ctnItemUpdate.setGUITooltip(GuiToolTip);
		}
		
		private function filterListEquip(changeTab:Boolean = false):void 
		{
			var type:String;
			var element:int;
			var color:int;
			var s:int;
			var numElementInList:int;
			//trace("filterListEquip dataEquip.length== " + dataEquip.length);
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
			
			numPage = numElementInList / itemPage + 1;
			if (numElementInList % itemPage == 0)
				numPage = numElementInList / itemPage;
			
			//trace("changeTab== " + changeTab);
			if (changeTab)
			{
				//trace("filterListEquipcurPage: " + changeTab + " |curPage= " + curPage + " |numPage= " + numPage);
				if (curPage > numPage)
				{
					curPage = numPage;
					//trace("gan lai curPage= " + curPage);
					//txtBox.SetText(curPage.toString());
				}
				addList(listCustom, oEquip, (curPage -1 ) * itemPage + 1, curPage * itemPage);
			}
			else
			{
				//trace("goi ben duoi--------");
				addList(listCustom, oEquip, 1, itemPage);
				curPage = 1;
			}
			
			txtBox.SetText(curPage.toString());
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			labelPage.text = "/" + numPage;
			//trace("labelPage.text== " + labelPage.text);
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
				addList(currentList, oEquip, (num - 1) * itemPage + 1, num * itemPage);
				
				buttonBack.SetVisible(true);
				buttonNext.SetVisible(true);
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
				
				if (selectAll)
				{
					buttonCheckOnePage.SetEnable(false);
					btnCheckAll.SetEnable(false);
					btnRemoveCheckAll.SetEnable(true);
				}
				else
				{
					buttonCheckOnePage.SetEnable(true);
					btnCheckAll.SetEnable(true);
					btnRemoveCheckAll.SetEnable(true);
				}
			}
		}
		
		private function addList(listBox:ListBox, data:Object, fromE:int, toE:int):void
		{
			var checkPage:Boolean = false;
			var indexPage:int = ((fromE - 1) / itemPage) + 1;
			
			for (var k:int = 0; k < arrPageCheckOne.length; k++)
			{
				if (arrPageCheckOne[k] == indexPage)
				{
					checkPage = true;
					//trace("arrPageCheckOne[k]== " + arrPageCheckOne[k] + " |indexPage== " + indexPage + " |checkPage== " + checkPage);
				}
			}
			//trace("addList fromE= " + fromE + " |toE= " + toE + " |indexPage== " + indexPage + " |arrPageCheckOne.length== " + arrPageCheckOne.length);
			listBox.removeAllItem(); 
			if (data != null)
			{
				var i:int = 0;
				for (var j:String in data)
				{
					i++; 
					//trace("fromE= " + fromE + " |toE= " + toE + " |i= " + i + " |j= " + j + " |data.id= " + data.id);
					if (i >= fromE && i <= toE)
					{
						var ctn:Container = new Container(img, "Bg_Item_" + data[j].Type, 0, 0);
						ctn.img.cacheAsBitmap = false;
						
						var GuiToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
						var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
						GuiToolTip.Init(data[j]);
						GuiToolTip.InitPos(ctn, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
						ctn.setGUITooltip(GuiToolTip);
						
						/*if (data[j].ItemId > 4)
						{
							data[j].ItemId = 0;
						}*/
						var imagName:String = data[j].Type + data[j].ItemId;
						var imag1:Image = ctn.AddImage(data[j].Id, imagName, 43, 52);
						
						var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
						var txt:TextField = ctn.AddLabel(Ultility.StandardNumber(data[j].Level), -9, 1, 0xFFFF00, 1);
						txt.filters = [glow];
						
						ctn.AddImage("GuiUpdateLinhThach_Check", "GuiUpdateLinhThach_Check", 68, 79);
						ctn.GetImage("GuiUpdateLinhThach_Check").img.visible = false;
						
						ctn.AddImage("GuiUpdateLinhThach_UnCheck", "GuiUpdateLinhThach_UnCheck", 68, 79);
						ctn.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = true;
						
						if (selectAll || checkPage)
						{
							ctn.GetImage("GuiUpdateLinhThach_Check").img.visible = true;
							ctn.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = false;
						}
						
						for (var h:int = 0; h < quartzsCheckArr.length; h++)
						{
							if (quartzsCheckArr[h].QuartzType == data[j].Type && quartzsCheckArr[h].Id == data[j].Id)
							{
								ctn.GetImage("GuiUpdateLinhThach_Check").img.visible = true;
								ctn.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = false;
							}
						}
						
						ctn.AddImage("", "nenPointItem", 42, 103);
						var pointMaterial:int = ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[data[j].Type][data[j].Level]["Point"];
						var txtPoint:TextField = ctn.AddLabel(Ultility.StandardNumber(pointMaterial), -5, 93, 0xFF0000, 1);
						var txtFormat:TextFormat = new TextFormat("arial", 15, 0xFF0000, true);
						txtPoint.setTextFormat(txtFormat);
						txtPoint.defaultTextFormat = txtFormat;
						
						listBox.addItem("CtnItemTrung" + "_" + data[j].Id + "_" + data[j].Level + "_" + data[j].Type, ctn, this);
						ContainerArr.splice(ContainerArr.length - 1, 1);
					}
				}
			}
			
			if (selectAll)
			{
				buttonCheckOnePage.SetEnable(false);
				btnCheckAll.SetEnable(false);
				btnRemoveCheckAll.SetEnable(true);
			}
			else if (checkPage)
			{
				buttonCheckOnePage.SetEnable(false);
				btnCheckAll.SetEnable(true);
				btnRemoveCheckAll.SetEnable(true);
			}
			else
			{
				buttonCheckOnePage.SetEnable(true);
				btnCheckAll.SetEnable(true);
				btnRemoveCheckAll.SetEnable(true);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//trace("OnButtonClick== " + buttonID.split("_")[0]);
			switch(buttonID.split("_")[0])
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_BACK:
					if (curPage > 1)
					{
						if (selectAll)
						{
							buttonCheckOnePage.SetEnable(false);
							btnCheckAll.SetEnable(false);
							btnRemoveCheckAll.SetEnable(true);
						}
						else
						{
							buttonCheckOnePage.SetEnable(true);
							btnCheckAll.SetEnable(true);
							btnRemoveCheckAll.SetEnable(true);
						}
						curPage--;
						txtBox.SetText(curPage.toString());
						labelPage.text = "/" + (numPage);
						addList(currentList, oEquip, (curPage -1 ) * itemPage + 1, curPage * itemPage);
						buttonBack.SetVisible(true);
						buttonNext.SetVisible(true);
						if (curPage <= 1)
						{
							buttonBack.SetVisible(false);
							buttonNext.SetVisible(true);
						}
					}
					break;
				case BTN_NEXT:
					if (curPage < numPage)
					{
						if (selectAll)
						{
							buttonCheckOnePage.SetEnable(false);
							btnCheckAll.SetEnable(false);
							btnRemoveCheckAll.SetEnable(true);
						}
						else
						{
							buttonCheckOnePage.SetEnable(true);
							btnCheckAll.SetEnable(true);
							btnRemoveCheckAll.SetEnable(true);
						}
						curPage++;
						txtBox.SetText(curPage.toString());
						labelPage.text = "/" + (numPage);
						addList(currentList, oEquip, (curPage -1 ) * itemPage + 1, curPage * itemPage);
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
				case BTN_HAP_THU:
					updateLinhThach();
					break;
				case BTN_CHECK_ALL:
					if (!isLoadEff)
					{
						buttonCheckOnePage.SetEnable(false);
						btnCheckAll.SetEnable(false);
						btnRemoveCheckAll.SetEnable(true);
						arrPageCheckOne = [];
						selectAll = true;
						choosenList = [];
						quartzsCheckArr = [];
						for (var j:int = 0; j < listCustom.length; j++ )
						{
							var container:Container = listCustom.itemList[j] as Container;
							var s:int = int(container.IdObject.split("_")[1]);
							container.GetImage("GuiUpdateLinhThach_Check").img.visible = true;
							container.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = false;
							var nameObjectAll:String = container.IdObject;
						}
						
						for (var m:int = 0; m < dataEquip.length; m++)
						{
							addItemArr(dataEquip[m].Id, dataEquip[m].Level, dataEquip[m].Type);
						}
					}
					break;
				case BTN_REMOVE_CHECK_ALL:
					buttonCheckOnePage.SetEnable(true);
					btnCheckAll.SetEnable(true);
					btnRemoveCheckAll.SetEnable(true);
					arrPageCheckOne = [];
					selectAll = false;
					for (var k:int = 0; k < listCustom.length; k++ )
					{
						var c:Container = listCustom.itemList[k] as Container;
						c.GetImage("GuiUpdateLinhThach_Check").img.visible = false;
						c.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = true;
					}
					choosenList = [];
					quartzsCheckArr = [];
					updateTotalPoint();
					break;
				case BTN_CHECK_ONE_PAGE:
					if (selectAll == false && isLoadEff == false)
					{
						buttonCheckOnePage.SetEnable(false);
						btnCheckAll.SetEnable(true);
						btnRemoveCheckAll.SetEnable(true);
						arrPageCheckOne.push(curPage);
						//trace("BTN_CHECK_ONE_PAGE = " + curPage);
						for (var h:int = 0; h < listCustom.length; h++ )
						{
							var containerOne:Container = listCustom.itemList[h] as Container;
							var checkOne:int = int(containerOne.IdObject.split("_")[1]);
							containerOne.GetImage("GuiUpdateLinhThach_Check").img.visible = true;
							containerOne.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = false;
							var nameObjectOne:String = containerOne.IdObject;
							var b:Array = nameObjectOne.split("_");
							addItemArr(b[1], b[2], b[3]);
							//trace("container.IdObject== " + container.IdObject + " |b[1]== " + b[1] + " |b[2]== " + b[2]);
						}
					}
					break;
				case ITEM_LINH_THACH:
					if (!isLoadEff)
					{
						var ctn:Container = listCustom.getItemById(buttonID);
						var nameObject:String = ctn.IdObject;
						var a:Array = nameObject.split("_");
						selectAll = false;
						//trace("ctn.IdObject== " + ctn.IdObject + " |a[1]== " + a[1] + " |a[2]== " + a[2] + " |a[3]== " + a[3]);
						//trace("case ITEM_LINH_THACH: quartzsCheckArr.length== " + quartzsCheckArr.length);
						if (ctn.GetImage("GuiUpdateLinhThach_Check").img.visible == false)
						{
							ctn.GetImage("GuiUpdateLinhThach_Check").img.visible = true;
							ctn.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = false;
							addItemArr(a[1], a[2], a[3]);
						}
						else
						{
							ctn.GetImage("GuiUpdateLinhThach_Check").img.visible = false;
							ctn.GetImage("GuiUpdateLinhThach_UnCheck").img.visible = true;
							removeItemArr(a[1]);
						}
					}
					break;
			}
		}
		
		private function removeItemArr(id:int):void
		{
			for (var i:int = 0; i < quartzsCheckArr.length; i++)
			{
				//trace("quartzsCheckArr[i].Id== " + quartzsCheckArr[i].Id + " |id== "+ id);
				if (quartzsCheckArr[i].Id == id)
				{
					quartzsCheckArr.splice(i, 1);
				}
			}
			//trace("removeItemArr quartzsCheckArr.length== " + quartzsCheckArr.length);
			updateTotalPoint();
		}
		
		private function addItemArr(id:int, level:int, type:String):void
		{
			//trace("id== " + id + " |level== " + level + " |type== " + type);
			for (var i:int = 0; i < quartzsCheckArr.length; i++)
			{
				if (quartzsCheckArr[i].QuartzType == type && quartzsCheckArr[i].Id == id)
				{
					return;
				}
			}
			
			var objData:Object = new Object()
			objData.Id = id;
			objData.QuartzType = type;
			objData.Level = level;
			quartzsCheckArr.push(objData);
			//trace("addItemArr quartzsCheckArr.length== " + quartzsCheckArr.length);
			updateTotalPoint();
		}
		
		private function updateTotalPoint():void
		{
			totalPointUpdate = 0;
			numGold = 0;
			for (var i:int = 0; i < quartzsCheckArr.length; i++)
			{
				//trace("Type== " + quartzsCheckArr[i].QuartzType + " |Level== " + quartzsCheckArr[i].Level);
				var numPoint:Number = ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[quartzsCheckArr[i].QuartzType][quartzsCheckArr[i].Level]["Point"];
				//trace("numPoint==== " + numPoint);
				totalPointUpdate += numPoint;
				var goldConfig:int = ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")["Price"]["HeSo"];
				numGold = goldConfig * totalPointUpdate;
			}
			//trace("totalPointUpdate== " + totalPointUpdate);
			pustTotalGoldUpdate();
			pustTotalPointUpdate();
		}
		
		private function updateLinhThach():void
		{
			//trace("updateLinhThach quartzsCheckArr.length== " + quartzsCheckArr.length);
			if (quartzsCheckArr.length > 0)
			{
				if (GameLogic.getInstance().user.GetMoney() >= numGold)
				{
					btnHapThu.SetVisible(false);
					buttonCheckOnePage.SetEnable(true);
					btnCheckAll.SetEnable(true);
					btnRemoveCheckAll.SetEnable(true);
					arrPageCheckOne = [];
					isHapThu = true;
					selectAll = false;
					
					var cmd:SendUpgradeQuartz = new SendUpgradeQuartz();
					cmd.SoldierId = curIdSoldier;
					cmd.QuartzType = curTabQuartz;
					cmd.Id = objDataUpLevel.Id;
					cmd.Quartzs = quartzsCheckArr;
					Exchange.GetInstance().Send(cmd);
					
					quartzsCheckArr = [];
					
					GameLogic.getInstance().user.UpdateUserMoney(-numGold);
				}
				else
				{
					var messageGold:String = 'Bạn không có đủ ' + Ultility.StandardNumber(numGold) + " vàng để nâng cấp Huy Hiệu";
					GuiMgr.getInstance().GuiMessageBox.ShowOK(messageGold);
				}
			}
			else
			{
				var message:String = 'Bạn chưa chọn Huy Hiệu để làm nguyên liệu nâng cấp!';
				GuiMgr.getInstance().GuiMessageBox.ShowOK(message);
			}
		}
		
		override public function OnHideGUI():void 
		{
			if (isLoadEff)
			{
				progressHapThu.GoToAndStop(20);
				progressHapThu.img.removeEventListener(Event.ENTER_FRAME, onEnterProgess);
			}
			//trace("itemUpdate== " + itemUpdate);
			if (itemUpdate)
			{
				itemUpdate.GoToAndStop(25);
				itemUpdate.img.removeEventListener(Event.ENTER_FRAME, onEnterItemUpdate);
				itemUpdate.img.visible = false;
				itemUpdate = null;
			}
			
			selectAll = false;
			arrPageCheckOne = [];
			//trace("OnHideGUI");
			if (isHapThu)
			{
				GuiMgr.getInstance().guiWareRoomLinhThach.updateWareromm(objDataUpLevel, curIdSoldier, slotIndex);
			}
		}
		
		public function updateLevelQuartz(OldData:Object, objData:Object):void
		{
			effText(ctnItemUpdate.img, 100, 230, 100, 150, "+", totalPointUpdate);
			
			var QuartzsPush:Array = OldData["Quartzs"]
			
			objDataUpLevel.Point = objData["oQuartz"].Point;
			
			levelUpdate = objData["oQuartz"].Level;
			typeUpdate = objData["oQuartz"].Type;
			
			contentItemUpdate(objData["oQuartz"], true);
			updateWareroom(QuartzsPush, objData["oQuartz"].Level, objData["oQuartz"].Type);
			btnHapThu.SetVisible(false);
			reportFull.visible = false;
			var max:int = maxLevl[objData["oQuartz"].Type];
			//trace("updateLevelQuartz() Type== " + objData["oQuartz"].Type + " |max== " + max + " |level== " + objData["oQuartz"].Level);
			if (objData["oQuartz"].Level >= max)
			{
				//trace("max roi con dau-------------");
				btnHapThu.SetVisible(false);
				reportFull.visible = true;
			}
			
			totalPointUpdate = 0;
			pustTotalPointUpdate();
			
			numGold = 0;
			pustTotalGoldUpdate();
			
			isLoadEff = true;
			progressHapThu.GoToAndPlay(1);
			progressHapThu.img.addEventListener(Event.ENTER_FRAME, onEnterProgess);
			
			if (objData["oQuartz"].Level > objDataUpLevel.Level)
			{
				objDataUpLevel.Level = objData["oQuartz"].Level;
				pushFedd();
			}
			
			GameLogic.getInstance().user.ChangeQuartzToStore(objData["oQuartz"].Type, objData["oQuartz"].Id, objData["oQuartz"].Level, objData["oQuartz"].Point);
		}
		
		private function effText(img1:Sprite, dx1:int, dy1:int, dx2:int,dy2:int,asign:String = "+", num:int = 1):void
		{
			var str:String = asign + Ultility.StandardNumber(num);
			var posStart:Point = new Point(img1.x + dx1, img1.y + dy1);
			posStart  = img.localToGlobal(posStart);
			var posEnd:Point = new Point(img1.x + dx2, img1.y + dy2);
			posEnd = img.localToGlobal(posEnd);
			var fm:TextFormat = new TextFormat("Arial", 16);
			fm.align = "center";
			fm.bold = true;
			if (asign == "-")
			{
				fm.color = 0xff0000;
			}
			else
			{
				fm.color = 0xffff00;
			}
			Ultility.ShowEffText(str, null, posStart, posEnd, fm);
		}
		
		private function onEnterProgess(event:Event):void
		{
			//trace("currentFrame== " + EffSmashEgg.currentFrame);
			if(progressHapThu.currentFrame == 20)
			{
				progressHapThu.GoToAndStop(20);
				progressHapThu.img.removeEventListener(Event.ENTER_FRAME, onEnterProgess);
				isLoadEff = true;
				loadAnimationItem();
			}
		}
		
		private function loadAnimationItem():void
		{
			isLoadEff = true;
			itemUpdate = AddImage("", "animationItemUpdate", 637, 284);
			itemUpdate.GoToAndPlay(1);
			itemUpdate.img.addEventListener(Event.ENTER_FRAME, onEnterItemUpdate);
		}
		
		private function onEnterItemUpdate(event:Event):void
		{
			//trace("currentFrame== " + EffSmashEgg.currentFrame);
			if(itemUpdate.currentFrame == 25)
			{
				itemUpdate.GoToAndStop(25);
				itemUpdate.img.removeEventListener(Event.ENTER_FRAME, onEnterItemUpdate);
				itemUpdate.img.visible = false;
				itemUpdate = null;
				progressHapThu.GoToAndStop(1);
				
				var max:int = maxLevl[typeUpdate];
				if (levelUpdate >= max)
				{
					btnHapThu.SetVisible(false);
				}
				else
				{
					btnHapThu.SetVisible(true);
				}
				isLoadEff = false;
				
				levelUpdate = 0;
				typeUpdate = "";
			}
		}
		
		private function updateWareroom(QuartzsPush:Array, levelFil:int, typeFil:String):void
		{
			//trace("updateWareroom QuartzsPush.length== " + QuartzsPush.length);
			for (var i:int = 0; i < QuartzsPush.length; i++ )
			{
				var obj:FishEquipment = new FishEquipment();
				obj.Id = QuartzsPush[i].Id;
				obj.Type = QuartzsPush[i].QuartzType;
				obj.Level = QuartzsPush[i].Level;
				
				GameLogic.getInstance().user.UpdateQuartzToStore(obj, false);
			}
			
			var typeArr:Array = new Array();
			if (typeFil == "QWhite")
			{
				typeArr = ["QWhite"];
			}
			else if (typeFil == "QGreen")
			{
				typeArr = ["QWhite", "QGreen"];
			}
			else if (typeFil == "QYellow")
			{
				typeArr = ["QWhite", "QGreen", "QYellow"];
			}
			else if (typeFil == "QPurple")
			{
				typeArr = ["QWhite", "QGreen", "QYellow", "QPurple"];
			}
			else if (typeFil == "QVIP")
			{
				typeArr = ["QWhite", "QGreen", "QYellow", "QPurple", "QVIP"];
			}
			
			updateDataQuartz(true, levelFil, typeArr);
		}
		
		private function pushFedd():void
		{
			GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_UPDATE_QUARTZ);
		}
	}
}