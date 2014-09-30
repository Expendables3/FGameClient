package GUI.UpgradeEquipment 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
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
	public class GUIUpgradeEquip extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_TAB_TRAINING:String = "btnTabTraining";
		static public const BTN_TAB_UPGRADE:String = "btnTabUpgrade";
		static public const IMG_ARROW:String = "imgArrow";
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_TAB_NOMAL:String = "btnTabNomal_1";
		static public const BTN_TAB_SPECIAL:String = "btnTabSpecial_2";
		static public const BTN_TAB_RARE:String = "btnTabRare_3";
		static public const BTN_TAB_GOD:String = "btnTabGod_4";
		static public const TXTBOX_PAGE:String = "txtboxPage";
		private var isDataReady:Boolean;
		private var btnTabTrainingEquip:Button;
		private var btnTabUpgradeEquip:Button;
		private var listSlot:ListBox;
		private var ctnTraining:Container;
		private var ctnUpgrade:Container;
		private var curEquip:FishEquipment;
		private var listEquip:ListBox;
		private var curSubTab:String;
		private var oEquip:Array;
		private var curPage:int;
		private	var numPage:int;
		private var dataEquip:Array;
		private var labelPage:TextField;
		private var txtBox:TextBox;
		private var tx:TextField;
		
		public function GUIUpgradeEquip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIUpgradeEquip";
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
			LoadRes("GUIUpgradeEquip_Bg");
		}
		
		public function showGUI():void
		{
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		private function addContent():void
		{
			AddButton(BTN_CLOSE, "BtnThoat", 704, 19, this);
			btnTabTrainingEquip = AddButton(BTN_TAB_TRAINING, "BtnTabTrainingEquip", 45, 67);
			btnTabUpgradeEquip = AddButton(BTN_TAB_UPGRADE, "BtnTabUpgradeEquip", 185, 67);
			listSlot = AddListBox(ListBox.LIST_X, 1, 4, 20, 35, true);
			listSlot.setPos(53, 469);
			listEquip = AddListBox(ListBox.LIST_X, 3, 3, 5, 5, true);
			listEquip.setPos(428, 155);
			ctnTraining = AddContainer("", "CtnTraining", 60, 120);
			ctnUpgrade = AddContainer("", "CtnUpgrade", 60, 120);
			initTab(BTN_TAB_TRAINING, true);
		}
		
		private function initTab(tabName:String, isInit:Boolean = false):void
		{
			if (isInit)	getItemList();
			ctnTraining.SetVisible(false);
			ctnUpgrade.SetVisible(false);
			listSlot.visible = false;
			listEquip.visible = false;
			switch (tabName)
			{
				case BTN_TAB_TRAINING:
					ctnTraining.SetVisible(true);
					listSlot.visible = true;
					if (tx && tx.visible) tx.visible = false;
					GetButton(BTN_TAB_TRAINING).SetFocus(true, false);
					GetButton(BTN_TAB_UPGRADE).SetFocus(false, false);
					updateTabTraining();
					break;
				case BTN_TAB_UPGRADE:
					ctnUpgrade.SetVisible(true);
					listEquip.visible = true;
					GetButton(BTN_TAB_TRAINING).SetFocus(false, false);
					GetButton(BTN_TAB_UPGRADE).SetFocus(true, false);
					updateTabUpgrade();
					filterListEquip();
					break;
			}
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
					if (dataEquip[s]["Color"] == curSubTab.split("_")[1])
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
			tx.visible = false;
			if (oEquip.length <= 0)	tx.visible = true;
			curPage = 1;
			numPage = numElementInList / 9 + 1;
			if (numElementInList % 9 == 0)	numPage = numElementInList / 9;
			txtBox.SetText(curPage.toString());
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			labelPage.text = "/" + numPage;
			updateNextBackBtn();
		}
		
		private function addList(data:Object, fromE:int = 1, toE:int = 9):void
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
							ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), 9, 21, true, ALIGN_LEFT_TOP, true);
						}
						var imag:Image = ctn.AddImage("", o.imageName + "_Shop", 15, 30);
						imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, o.Color) };
						imag.FitRect(60, 60, new Point(15, 30));
						FishSoldier.EquipmentEffect(imag.img, o.Color);
						
						if (o.EnchantLevel > 0)
						{
							var txt:TextField = ctn.AddLabel("+" + o.EnchantLevel, 2, 2, 0xFFF100, 0, 0x603813);
							var tF:TextFormat = new TextFormat();
							tF.size = 18;
							tF.bold = true;
							txt.setTextFormat(tF);
						}
						//ctn.AddImage("CheckBg", "CheckBg", 70, 80);
						//ctn.AddImage("ImgMark", "ImgMark", 70, 80);
						//ctn.GetImage("ImgMark").img.visible = false;
						//if (ind != "" && int(ind.split("_")[1]) == s)	
						//{
							//ctn.GetImage("ImgMark").img.visible = true;
						//}
						listEquip.addItem("Ctn" + o.Type + "_" + s, ctn, this);
					}
				}
			}
		}
		
		private function updateTabTraining(e:FishEquipment = null):void 
		{
			ctnTraining.ClearComponent();
			curEquip = e;
			var ctn:Container = ctnTraining.AddContainer("CtnEquip", "CtnEquipBg", 275, 120, true, this);
			if (e == null)
			{
				ctnTraining.AddImage(IMG_ARROW, "IcHelper", 325, 110);
				return;
			}
			if (e.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				ctn.LoadRes(FishEquipment.GetBackgroundName(e.Color), true);
			}
			var imag:Image = ctn.AddImage("", e.imageName + "_Shop", 0, 0);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, e.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
			FishSoldier.EquipmentEffect(imag.img, e.Color);
		}
		
		private function updateTabUpgrade():void 
		{
			ctnUpgrade.ClearComponent();
			AddButton(BTN_BACK, "BtnBackVIP", 185, 435, this);
			AddButton(BTN_NEXT, "BtnNextVIP", 290, 435, this);
			
			AddButton(BTN_TAB_NOMAL, "BtnNomal", 415, 110).SetFocus(true, false);
			AddButton(BTN_TAB_SPECIAL, "BtnSpecial", 483.3, 110).SetFocus(false, false);
			AddButton(BTN_TAB_RARE, "BtnRare", 551.6, 110).SetFocus(false, false);
			AddButton(BTN_TAB_GOD, "BtnGod", 620, 110).SetFocus(false, false);
			
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
			curSubTab = BTN_TAB_NOMAL;
			
			tx = AddLabel("Không có trang bị nào", 200, 200, 0xFFFF00, 1, 0x000000);
			var tF:TextFormat = new TextFormat();
			tF.size = 18;
			tx.setTextFormat(tF)
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TAB_TRAINING:
				case BTN_TAB_UPGRADE:
					initTab(buttonID);
					break;
				case "CtnEquip":
					GuiMgr.getInstance().guiChooseVIPEquip.showGUI(updateTabTraining);
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case "CtnEquip":
					if (curEquip != null)	GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, curEquip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
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
		
		public function updateTime():void 
		{
			
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
				addList(oEquip, (curPage - 1) * 9 + 1, curPage * 9);
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
		
	}

}