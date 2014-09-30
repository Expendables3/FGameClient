package GUI.BlackMarket 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIShopMarket extends BaseGUI
	{
		static public const BTN_PREVIOUS:String = "bntPrevious";
		static public const BTN_NEXT:String = "btnNext";
		static public const CTN_ITEM_SHOP:String = "ctnItemShop";
		private var listItem:ListBox;
		private var btnSoldier:Button;
		private var btnOther:Button;
		private var imgFocusBtnSupport:Image;
		private var btnSupport:Button;
		private var imgFocusBtnFormula:Image;
		private var btnFormula:Button;
		private var imgFocusBtnHelmet:Image;
		private var btnHelmet:Button;
		private var imgFocusBtnArmor:Image;
		private var btnArmor:Button;
		private var imgFocusBtnWeapon:Image;
		private var btnWeapon:Button;
		static private const BTN_CLOSE:String = "btnClose";
		static private const BTN_TAB_SOLDIER:String = "btnSoldier";
		static private const BTN_TAB_OTHER:String = "btnOther";
		static private const BTN_TAB_FISH_SUPPORT:String = "tabFishSupport";
		static private const BTN_TAB_FISH_FORMULA:String = "btnTabFishFormula";
		static private const BTN_TAB_HELMET:String = "btnTabHelmet";
		static private const BTN_TAB_ARMOR:String = "btnTabArmor";
		static private const BTN_TAB_WEAPON:String = "guiShopBtnTabWeapon";
		private var btnPrevious:Button;
		private var btnNext:Button;
		private var labelDiamond:TextField;
		private var _numDiamond:int;
		
		public function GUIShopMarket(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function():void
			{
				SetPos(25, 25);
				OpenRoomOut();
			}
			LoadRes("GuiShopMarket");
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 706, 20);
			
			//Cac button tab
			AddImage("", "GuiShopMarket_BtnCaLinh2", 105, 66, true, ALIGN_LEFT_TOP);
			btnSoldier = AddButton(BTN_TAB_SOLDIER, "GuiShopMarket_BtnCaLinh", 105, 66, this);
			AddImage("", "GuiShopMarket_BtnSpecial2", 2*105, 66, true, ALIGN_LEFT_TOP);
			btnOther = AddButton(BTN_TAB_OTHER, "GuiShopMarket_BtnSpecial", 2 * 105, 66, this);	
			
			imgFocusBtnSupport = AddImage("", "GuiShopMarket_ImgTabHoTro", 90, 102, true, ALIGN_LEFT_TOP);
			btnSupport = AddButton(BTN_TAB_FISH_SUPPORT, "GuiShopMarket_BtnTabHoTro", imgFocusBtnSupport.img.x, imgFocusBtnSupport.img.y, this);
			imgFocusBtnFormula = AddImage("", "GuiShopMarket_ImgTabCtLai", imgFocusBtnSupport.img.x + imgFocusBtnSupport.img.width + 6, 102, true, ALIGN_LEFT_TOP);
			btnFormula = AddButton(BTN_TAB_FISH_FORMULA, "GuiShopMarket_BtnTabCtLai", imgFocusBtnFormula.img.x, imgFocusBtnFormula.img.y, this);
			imgFocusBtnHelmet = AddImage("", "GuiShopMarket_ImgTabMuGiap", imgFocusBtnFormula.img.x + imgFocusBtnFormula.img.width + 3, 102, true, ALIGN_LEFT_TOP);
			btnHelmet = AddButton(BTN_TAB_HELMET, "GuiShopMarket_BtnTabMuGiap", imgFocusBtnHelmet.img.x, imgFocusBtnHelmet.img.y, this);
			imgFocusBtnArmor = AddImage("", "GuiShopMarket_ImgTabAoGiap", imgFocusBtnHelmet.img.x + imgFocusBtnHelmet.img.width + 1, 102, true, ALIGN_LEFT_TOP);
			btnArmor = AddButton(BTN_TAB_ARMOR, "GuiShopMarket_BtnTabAoGiap", imgFocusBtnArmor.img.x, imgFocusBtnArmor.img.y, this);
			imgFocusBtnWeapon = AddImage("", "GuiShopMarket_ImgTabVuKhi", imgFocusBtnArmor.img.x + imgFocusBtnArmor.img.width + 2, 102, true, ALIGN_LEFT_TOP);
			btnWeapon = AddButton(BTN_TAB_WEAPON, "GuiShopMarket_BtnTabVuKhi", imgFocusBtnWeapon.img.x, imgFocusBtnWeapon.img.y, this);			
			
			btnPrevious = AddButton(BTN_PREVIOUS, "GuiShopMarket_BtnPreShop", 25, 304);
			btnNext = AddButton(BTN_NEXT, "GuiShopMarket_BtnNextShop", 680, 304);
			listItem = AddListBox(ListBox.LIST_X, 2, 3);
			listItem.setPos(64, 128);
			
			labelDiamond = AddLabel("So kim cuong", 310, 536);
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xff00ff, true);
			labelDiamond.defaultTextFormat = txtFormat;
			numDiamond = GameLogic.getInstance().user.getDiamond();
			showTab(BTN_TAB_FISH_SUPPORT);
		}
		
		private function setVisibleTabSoldier(visible:Boolean):void
		{
			imgFocusBtnSupport.img.visible = visible;
			btnSupport.img.visible = visible;
			imgFocusBtnFormula.img.visible = visible;
			btnFormula.img.visible = visible;
			imgFocusBtnHelmet.img.visible = visible;
			btnHelmet.img.visible = visible;
			imgFocusBtnArmor.img.visible = visible;
			btnArmor.img.visible = visible;
			imgFocusBtnWeapon.img.visible = visible;
			btnWeapon.img.visible = visible;
		}
		
		public function showTab(tabName:String):void
		{
			btnSoldier.SetFocus(true);
			btnOther.SetFocus(false);
			btnSupport.SetFocus(false);
			btnFormula.SetFocus(false);
			btnHelmet.SetFocus(false);
			btnArmor.SetFocus(false);
			btnWeapon.SetFocus(false);
			setVisibleTabSoldier(true);
			var config:Object = ConfigJSON.getInstance().GetItemList("BlackMarketShop");
			var tabType:String;
			var subTab:String;
			switch(tabName)
			{
				case BTN_TAB_SOLDIER:
				case BTN_TAB_FISH_SUPPORT:
					btnSupport.SetFocus(true);
					tabType = "Soldier";
					subTab = "Support";
					break;
				case BTN_TAB_FISH_FORMULA:
					btnFormula.SetFocus(true);
					tabType = "Soldier";
					subTab = "MixFormula";
					break;
				case BTN_TAB_WEAPON:
					btnWeapon.SetFocus(true);
					tabType = "Soldier";
					subTab = "Weapon";
					break;
				case BTN_TAB_ARMOR:
					btnArmor.SetFocus(true);
					tabType = "Soldier";
					subTab = "Armor";
					break;
				case BTN_TAB_HELMET:
					btnHelmet.SetFocus(true);
					tabType = "Soldier";
					subTab = "Helmet";
					break;
				case BTN_TAB_OTHER:
					setVisibleTabSoldier(false);
					btnOther.SetFocus(true);
					btnSoldier.SetFocus(false);
					tabType = "Grocery";
					subTab = "";
					break;
			}
			
			if (subTab != "")
			{
				config = config[tabType][subTab];
			}
			else
			{
				config = config[tabType];
			}
			listItem.removeAllItem();
			for (var s:String in config)
			{
				var itemShopMarket:ItemShopMarket = new ItemShopMarket(listItem.img);
				itemShopMarket.initItem(config[s], int(s), tabType, subTab);
				listItem.addItem(CTN_ITEM_SHOP + s, itemShopMarket, this);
			}
			updateBtnNextPrevious();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TAB_SOLDIER:
				case BTN_TAB_FISH_SUPPORT:
				case BTN_TAB_FISH_FORMULA:
				case BTN_TAB_WEAPON:
				case BTN_TAB_ARMOR:
				case BTN_TAB_HELMET:
				case BTN_TAB_OTHER:
					showTab(buttonID)
					break;
				case BTN_PREVIOUS:
					listItem.showPrePage();
					updateBtnNextPrevious();
					break;
				case BTN_NEXT:
					listItem.showNextPage();
					updateBtnNextPrevious();
					break;
			}
		}
		
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_ITEM_SHOP) >= 0)
			{
				var itemShopMarket:ItemShopMarket = listItem.getItemById(buttonID) as ItemShopMarket;
				var itemType:String = itemShopMarket.data["ItemType"];
				var itemId:int = itemShopMarket.data["ItemId"];
				switch(itemType)
				{
					case "Draft":
					case "Paper":
					case "GoatSkin":
					case "Blessing":
						var obj:Object = ConfigJSON.getInstance().getItemInfo(itemType, itemId);
						GuiMgr.getInstance().GuiMixFormulaInfo.InitAll(obj, event.stageX, event.stageY);
						break;
					case "Helmet":
					case "Armor":
					case "Weapon":
					case "Bracelet":
					case "Belt":
					case "Ring":
					case "Necklace":
						var id:int= int(itemShopMarket.data["Element"]) * 100 + int(itemShopMarket.data["Rank"]);
						var idMix:String = id + "$" + itemShopMarket.data["Color"];
						var config:Object = ConfigJSON.getInstance().GetEquipmentInfo(itemType, idMix);
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, config);
						break;
					case "Seal":
						var seal:FishEquipment = new FishEquipment();
						seal.Color = FishEquipment.FISH_EQUIP_COLOR_PINK;
						seal.Type = "Seal";
						seal.Rank = itemShopMarket.data["ItemId"];
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, seal, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
						break;
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_ITEM_SHOP) >= 0)
			{
				var itemShopMarket:ItemShopMarket = listItem.getItemById(buttonID) as ItemShopMarket;
				var itemType:String = itemShopMarket.data["ItemType"];
				switch(itemType)
				{
					case "Draft":
					case "Paper":
					case "GoatSkin":
					case "Blessing":
						GuiMgr.getInstance().GuiMixFormulaInfo.Hide();
						break;
					case "Helmet":
					case "Armor":
					case "Weapon":
					case "Bracelet":
					case "Belt":
					case "Ring":
					case "Necklace":
					case "Seal":
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
						break;
				}
			}
		}
		
		private function updateBtnNextPrevious():void
		{
			if (listItem.curPage > 0)
			{
				btnPrevious.SetEnable(true);
			}
			else
			{
				btnPrevious.SetEnable(false);
			}
			if (listItem.curPage == listItem.getNumPage() - 1)
			{
				btnNext.SetEnable(false);
			}
			else
			{
				btnNext.SetEnable(true);
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
		
		override public function OnHideGUI():void 
		{
			var guiMarket:GUIMarket  = GuiMgr.getInstance().guiMarket;
			if (guiMarket.IsVisible)
			{
				guiMarket.numDiamond = numDiamond;
			}
		}
		
		public function updateBuyButton():void
		{
			for each(var itemShop:ItemShopMarket in listItem.itemList)
			{
				if (itemShop.data["Diamond"] > GameLogic.getInstance().user.getDiamond())
				{
					itemShop.GetButton(ItemShopMarket.BTN_DIAMOND).SetEnable(false);
				}
				else
				{
					itemShop.GetButton(ItemShopMarket.BTN_DIAMOND).SetEnable(true);
				}
			}
		}
	}

}