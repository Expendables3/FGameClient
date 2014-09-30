package GUI.UpgradeEquipment 
{
	import Data.ConfigJSON;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUIChooseVIPEquip extends BaseGUI 
	{
		static public const BTN_TAB_VIP1:String = "btnTabVip_1";
		static public const BTN_TAB_VIP2:String = "btnTabVip_2";
		static public const BTN_TAB_VIP3:String = "btnTabVip_3";
		static public const BTN_TAB_VIP4:String = "btnTabVip_4";
		static public const BTN_TAB_VIP5:String = "btnTabVip_5";
		static public const BTN_CLOSE:String = "btnClose";
		static public const TXTBOX_PAGE:String = "txtboxPage";
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_G:String = "btnG";
		static public const BTN_GOLD:String = "btnGold";
		static public const IMG_ARROW:String = "imgArrow";
		
		private static const CTN_HELMET:String = "CtnHelmet";
		private static const CTN_ARMOR:String = "CtnArmor";
		private static const CTN_WEAPON:String = "CtnWeapon";
		private static const CTN_BELT:String = "CtnBelt";
		private static const CTN_BRACELET:String = "CtnBracelet";
		private static const CTN_NECKLACE:String = "CtnNecklace";
		private static const CTN_RING:String = "CtnRing";
		
		private var listEquip:ListBox;
		private var dataEquip:Array;
		private var labelPage:TextField;
		private var txtBox:TextBox;
		private var tx:TextField;
		private var curSubTab:String;
		private var oEquip:Array;
		private var curPage:int;
		private	var numPage:int;
		private	var ind:String = "";
		private var equipSelected:FishEquipment;
		private var newEquip:FishEquipment;
		private var ctnMain:Container;
		private var callFunc:Function;
		public function GUIChooseVIPEquip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChooseVIPEquip";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(25, 15);
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)	sound.play();
				addContent();
			}
			LoadRes("GUIUpgradeEquip_ChooseEquipBg");
		}
		
		private function addContent():void
		{
			getItemList();
			AddButton(BTN_CLOSE, "BtnThoat", 740, 19, this);
			AddButton(BTN_BACK, "BtnBackVIP", 185, 435, this);
			AddButton(BTN_NEXT, "BtnNextVIP", 290, 435, this);
			
			listEquip = AddListBox(ListBox.LIST_X, 3, 4, 5, -3);
			listEquip.setPos(60, 110);
			
			AddButton(BTN_TAB_VIP1, "BtnVIP1", 68, 75).SetFocus(true, false);
			AddButton(BTN_TAB_VIP2, "BtnVIP2", 141.5, 75).SetFocus(false, false);
			AddButton(BTN_TAB_VIP3, "BtnVIP3", 215, 75).SetFocus(false, false);
			AddButton(BTN_TAB_VIP4, "BtnVIP4", 288.5, 75).SetFocus(false, false);
			AddButton(BTN_TAB_VIP5, "BtnVIP5", 362, 75).SetFocus(false, false);
			
			labelPage = AddLabel("/1", 250, 443, 0xffffff, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			labelPage.setTextFormat(txtFormat);
			labelPage.defaultTextFormat = txtFormat;
			
			txtBox = AddTextBox(TXTBOX_PAGE, "1", 220, 443, 30, 20, this);
			txtFormat = new TextFormat("arial", 15, 0xffffff, true);
			txtFormat.align = TextFormatAlign.RIGHT;
			txtBox.SetTextFormat(txtFormat);
			txtBox.SetDefaultFormat(txtFormat);
			
			txtBox.SetText("1");
			txtBox.textField.selectable = true;
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			curSubTab = BTN_TAB_VIP1;
			filterListEquip(curSubTab);
			ctnMain = AddContainer("", "CtnMain", 460, 102);
			updateInfo();
		}
		
		private function getItemList():void
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
		
		private function filterListEquip(curSubTab:String = ""):void 
		{
			var s:int;
			var numElementInList:int;
			oEquip = new Array();
			if (dataEquip.length > 0)
			{
				for (s = 0; s < dataEquip.length; s++ )
				{
					if (dataEquip[s] == null)	continue;
					//if (dataEquip[s]["Color"] < 5) continue;	//chỉ dùng đổ VIP
					if (dataEquip[s]["Rank"]%100 == curSubTab.split("_")[1])
					{
						oEquip[s] = dataEquip[s];
						numElementInList++;
					}
				}
			}
			else
			{
				oEquip = dataEquip;
			}
			addList(oEquip);
			if (tx != null && img.contains(tx))
			{
				img.removeChild(tx);
				tx = null;
			}
			if (oEquip.length <= 0)
			{
				tx = AddLabel("Không có trang bị nào", 200, 200, 0xFFFF00, 1, 0x000000);
				var tF:TextFormat = new TextFormat();
				tF.size = 18;
				tx.setTextFormat(tF);
			}
			curPage = 1;
			numPage = numElementInList / 12 + 1;
			if (numElementInList % 12 == 0)
				numPage = numElementInList / 12;
			txtBox.SetText(curPage.toString());
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			labelPage.text = "/" + numPage;
			updateNextBackBtn();
		}
		
		private function addList(data:Object, fromE:int = 1, toE:int = 12):void
		{
			listEquip.removeAllItem();
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
						var ctn:Container = new Container(img, "CtnEquipBg", 0, 0);
						var o:FishEquipment = data[s] as FishEquipment;
						if (o.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
						{
							ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), 0, 0, true, ALIGN_LEFT_TOP, true);
						}
						var imag:Image = ctn.AddImage("", o.imageName + "_Shop", 7, 7);
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
						ctn.AddImage("CheckBg", "CheckBg", 60, 60);
						ctn.AddImage("ImgMark", "ImgMark", 60, 60);
						ctn.GetImage("ImgMark").img.visible = false;
						if (ind != "" && int(ind.split("_")[1]) == s)	
						{
							ctn.GetImage("ImgMark").img.visible = true;
						}
						listEquip.addItem("Ctn" + o.Type + "_" + s, ctn, this);
					}
				}
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
				addList(oEquip, (curPage - 1) * 12 + 1, curPage * 12);
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
		
		public function showGUI(f:Function):void
		{
			callFunc = f;
			Show();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TAB_VIP1:
				case BTN_TAB_VIP2:
				case BTN_TAB_VIP3:
				case BTN_TAB_VIP4:
				case BTN_TAB_VIP5:
					GetButton(BTN_TAB_VIP1).SetFocus(false, false);
					GetButton(BTN_TAB_VIP2).SetFocus(false, false);
					GetButton(BTN_TAB_VIP3).SetFocus(false, false);
					GetButton(BTN_TAB_VIP4).SetFocus(false, false);
					GetButton(BTN_TAB_VIP5).SetFocus(false, false);
					curSubTab = buttonID;
					GetButton(buttonID).SetFocus(true, false);
					filterListEquip(curSubTab);
					break;
				case BTN_BACK:
				case BTN_NEXT:
					updateNextBackBtn(buttonID);
					break;
				case BTN_G:
				case BTN_GOLD:
					callFunc(equipSelected);
					Hide();
					break;
				default:
					var ctn1:Container = listEquip.getItemById(buttonID);
					if (ind != "")
					{
						var ctn2:Container = listEquip.getItemById(ind);
						if (ctn2)
						{
							ctn2.GetImage("ImgMark").img.visible = false;
						}
					}
					ind = buttonID;
					ctn1.GetImage("ImgMark").img.visible = true;
					equipSelected = dataEquip[buttonID.split("_")[1]] as FishEquipment;
					newEquip = setNewEquip();
					updateInfo(equipSelected);
					break;
			}
		}
		
		private function setNewEquip():FishEquipment 
		{
			if (equipSelected == null) return null;
			var newE:FishEquipment = new FishEquipment();
			var o:Object = new Object();
			o.Color = equipSelected.Color;
			o.Type = equipSelected.Type;
			o.Rank = equipSelected.Rank + 1;
			o.Element = equipSelected.Element;
			newE.SetInfo(o);
			return newE;
		}
		
		private function updateInfo(e:FishEquipment = null):void 
		{
			ctnMain.ClearComponent();
			if (e == null)
			{
				ctnMain.AddLabel("Chọn trang bị cần tu luyện", 100, 120, 0xFFFFFF, 1, 0x000000);
				ctnMain.AddImage(IMG_ARROW, "IcHelper", 40, 145);
				ctnMain.GetImage(IMG_ARROW).img.rotation = 90;
				return;
			}
			ctnMain.AddImage("", "DetailBg", 144, 179);
			var ctn1:Container = ctnMain.AddContainer("Equip_1", FishEquipment.GetBackgroundName(2), 40, 80, true, this);
			if (e.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				ctn1.LoadRes(FishEquipment.GetBackgroundName(e.Color), true);
			}
			var imag:Image = ctn1.AddImage("", e.imageName + "_Shop", 0, 0);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, e.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
			FishSoldier.EquipmentEffect(imag.img, e.Color);
			
			var ctn2:Container = ctnMain.AddContainer("Equip_2", FishEquipment.GetBackgroundName(2), 173, 80, true, this);
			if (newEquip.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				ctn2.LoadRes(FishEquipment.GetBackgroundName(newEquip.Color), true);
			}
			imag = ctn2.AddImage("", newEquip.imageName + "_Shop", 0, 0);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, newEquip.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
			FishSoldier.EquipmentEffect(imag.img, newEquip.Color);
			
			ctnMain.AddButton(BTN_GOLD, "BtnGold", 40, 300, this);
			ctnMain.AddButton(BTN_G, "BtnG", 150, 300, this);
		}
		
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
				case "Equip":
					if (a[1] == 1)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equipSelected, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
					else
					{
						var s:String = newEquip.Rank + "$" + newEquip.Color;
						var o:Object = ConfigJSON.getInstance().GetEquipmentInfo(newEquip.Type, s);
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, o);
					}
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
				addList(oEquip, (num - 1) * 12 + 1, num * 12);
				updateNextBackBtn();
			}
		}
	}

}