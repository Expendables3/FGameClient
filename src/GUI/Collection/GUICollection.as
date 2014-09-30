package GUI.Collection 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import GUI.Collection.PageCollections;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ListBox;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUICollection extends BaseGUI 
	{
		static public const BTN_TAB_WEAPON:String = "btnTabSword";
		static public const BTN_TAB_ARMOR:String = "btnTabArmor";
		static public const BTN_TAB_HELMET:String = "btnTabHat";
		static public const BTN_TAB_FISHWORLD:String = "btnTabFishworld";
		static public const IMG_TAB_SEA:String = "imgTabSea";
		static public const IMG_TAB_METALSEA:String = "imgTabSeaMetal";
		static public const IMG_TAB_ICESEA:String = "imgTabIceMetal";
		static public const BTN_TAB_SEA:String = "btnTabSea";
		static public const BTN_TAB_METALSEA:String = "btnTabSeaMetal";
		static public const BTN_TAB_ICESEA:String = "btnTabIceMetal";
		static private const BTN_CLOSE:String = "btnClose";
		private var pageWeapon:PageCollections;
		private var pageArmor:PageCollections;
		private var pageHelmet:PageCollections;
		private var pageWorldBase:PageCollections;
		private var pageWorldMetal:PageCollections;
		private var pageWorldIce:PageCollections;
		public var curPage:PageCollections;
		private var buttonTabWeapon:Button;
		private var buttonTabArmor:Button;
		private var buttonTabHat:Button;
		private var buttonTabFishworld:Button;
		private var buttonTabSea:Button;
		private var buttonTabMetalSea:Button;
		private var buttonTabIceSea:Button;
		
		//Focus vao 1 bo collection
		public var isFocus:Boolean = false;
		public var rewardTab:String;
		public var rewardType:String;
		public var rewardId:int;
		public var rewardNum:int;
		
		public var finishEff:Boolean = false;
		public var serverRespond:Boolean = false;
		public var isGettingGift:Boolean = false;
		
		public function GUICollection(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(25, 25);
				OpenRoomOut();
			}			
			LoadRes("GuiCollection_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 705, 20);	
			
			AddImage("", "GuiCollection_Selected_Weapon_Tab", 54,73, true, ALIGN_LEFT_TOP);
			buttonTabWeapon = AddButton(BTN_TAB_WEAPON, "GuiCollection_Btn_Tab_Weapon", 54, 73);
			
			AddImage("", "GuiCollection_Selected_Armor_Tab", 282 - 117, 73, true, ALIGN_LEFT_TOP);
			buttonTabArmor = AddButton(BTN_TAB_ARMOR, "GuiCollection_Btn_Tab_Armor", 282 - 117, 73);
			
			AddImage("", "GuiCollection_Selected_Helmet_Tab", 480 - 200, 73, true, ALIGN_LEFT_TOP);
			buttonTabHat = AddButton(BTN_TAB_HELMET, "GuiCollection_Btn_Tab_Helmet", 480 - 200, 73);
			
			AddImage("", "GuiCollection_Selected_Fishworld_Tab", 480 - 85, 73, true, ALIGN_LEFT_TOP);
			buttonTabFishworld = AddButton(BTN_TAB_FISHWORLD, "GuiCollection_Btn_Tab_Fishworld", 480 - 85, 73);
			
			AddImage(IMG_TAB_SEA, "GuiCollection_Selected_Sea_Tab", 72, 105, true, ALIGN_LEFT_TOP);
			buttonTabSea = AddButton(BTN_TAB_SEA, "GuiCollection_Btn_Tab_Sea", 72, 105);
			
			AddImage(IMG_TAB_METALSEA, "GuiCollection_Selected_MetalSea_Tab", 192, 105, true, ALIGN_LEFT_TOP);
			buttonTabMetalSea = AddButton(BTN_TAB_METALSEA, "GuiCollection_Btn_Tab_MetalSea", 192, 105);
			
			AddImage(IMG_TAB_ICESEA, "GuiCollection_Selected_IceSea_Tab", 312, 105, true, ALIGN_LEFT_TOP);
			buttonTabIceSea = AddButton(BTN_TAB_ICESEA, "GuiCollection_Btn_Tab_IceSea", 312, 105);
			
			buttonTabWeapon.SetFocus(true);
			buttonTabArmor.SetFocus(false);
			buttonTabHat.SetFocus(false);
			buttonTabFishworld.SetFocus(false);
			buttonTabSea.SetFocus(false);
			buttonTabMetalSea.SetFocus(false);
			buttonTabIceSea.SetFocus(false);
			
			var config:Object = ConfigJSON.getInstance().getItemInfo("ItemCollectionExchange", -1);
			var itemCollection:Object = GameLogic.getInstance().user.StockThingsArr["ItemCollection"];
			
			pageWeapon = new PageCollections(this.img);
			pageWeapon.initPageCollection(config["Weapon"], "Weapon");
			
			pageArmor = new PageCollections(this.img);
			pageArmor.initPageCollection(config["Armor"], "Armor");
			pageArmor.SetVisible(false);
			
			pageHelmet = new PageCollections(this.img);
			pageHelmet.initPageCollection(config["Helmet"], "Helmet");
			pageHelmet.SetVisible(false);
			
			pageWorldBase = new PageCollections(this.img);
			pageWorldBase.initPageCollection(config["Sea"], "Sea");
			pageWorldBase.SetVisible(false);
			
			pageWorldMetal = new PageCollections(this.img);
			pageWorldMetal.initPageCollection(config["MetalSea"], "MetalSea");
			pageWorldMetal.SetVisible(false);
			
			pageWorldIce = new PageCollections(this.img);
			pageWorldIce.initPageCollection(config["IceSea"], "IceSea");
			//pageWorldIce.initPageCollection(config["MetalSea"], "MetalSea");
			pageWorldIce.SetVisible(false);
			
			initData(itemCollection);
			if (isFocus)
			{
				focusTo(rewardTab, rewardType, rewardId, rewardNum);
			}
			
			HideSubButton();
		}
		
		public function initData(data:Object):void
		{
			pageWeapon.initData(data);
			pageArmor.initData(data);
			pageHelmet.initData(data);
			pageWorldBase.initData(data);
			pageWorldMetal.initData(data);
			pageWorldIce.initData(data);
		}
		
		public function HideSubButton(isHide:Boolean = true):void 
		{
			buttonTabSea.SetVisible(!isHide);
			buttonTabMetalSea.SetVisible(!isHide);
			buttonTabIceSea.SetVisible(!isHide);
			GetImage(IMG_TAB_SEA).img.visible = !isHide;
			GetImage(IMG_TAB_METALSEA).img.visible = !isHide;
			GetImage(IMG_TAB_ICESEA).img.visible = !isHide;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					isFocus = false;
					Hide();
					break;
				case BTN_TAB_WEAPON:
					pageWeapon.SetVisible(true);
					pageArmor.SetVisible(false);
					pageHelmet.SetVisible(false);
					pageWorldBase.SetVisible(false);
					pageWorldMetal.SetVisible(false);
					pageWorldIce.SetVisible(false);
					
					buttonTabArmor.SetFocus(false);
					buttonTabHat.SetFocus(false);
					buttonTabWeapon.SetFocus(true);
					buttonTabFishworld.SetFocus(false);
					buttonTabSea.SetFocus(false);
					buttonTabMetalSea.SetFocus(false);
					buttonTabIceSea.SetFocus(false);
					
					curPage = pageWeapon;
					HideSubButton();
					break;
				case BTN_TAB_ARMOR:
					pageArmor.SetVisible(true);
					pageWeapon.SetVisible(false);
					pageHelmet.SetVisible(false);
					pageWorldBase.SetVisible(false);
					pageWorldMetal.SetVisible(false);
					pageWorldIce.SetVisible(false);
					
					buttonTabWeapon.SetFocus(false);
					buttonTabArmor.SetFocus(true);
					buttonTabHat.SetFocus(false);
					buttonTabFishworld.SetFocus(false);
					buttonTabSea.SetFocus(false);
					buttonTabMetalSea.SetFocus(false);
					buttonTabIceSea.SetFocus(false);
					
					curPage = pageArmor;
					HideSubButton();
					break;
				case BTN_TAB_HELMET:
					pageHelmet.SetVisible(true);
					pageWeapon.SetVisible(false);
					pageArmor.SetVisible(false);
					pageWorldBase.SetVisible(false);
					pageWorldMetal.SetVisible(false);
					pageWorldIce.SetVisible(false);
					
					buttonTabWeapon.SetFocus(false);
					buttonTabArmor.SetFocus(false);
					buttonTabHat.SetFocus(true);
					buttonTabFishworld.SetFocus(false);
					buttonTabSea.SetFocus(false);
					buttonTabMetalSea.SetFocus(false);
					buttonTabIceSea.SetFocus(false);
					
					curPage = pageHelmet;
					
					HideSubButton();
					break;
				case BTN_TAB_FISHWORLD:
				case BTN_TAB_SEA:
					HideSubButton(false);
					
					pageHelmet.SetVisible(false);
					pageWeapon.SetVisible(false);
					pageArmor.SetVisible(false);
					pageWorldBase.SetVisible(true);
					pageWorldMetal.SetVisible(false);
					pageWorldIce.SetVisible(false);
					
					buttonTabWeapon.SetFocus(false);
					buttonTabArmor.SetFocus(false);
					buttonTabHat.SetFocus(false);
					buttonTabFishworld.SetFocus(true);
					buttonTabSea.SetFocus(true);
					buttonTabMetalSea.SetFocus(false);
					buttonTabIceSea.SetFocus(false);
					buttonTabMetalSea.SetVisible(true);
					buttonTabIceSea.SetVisible(true);
					buttonTabSea.SetVisible(false);
					
					curPage = pageWorldBase;
					break;
				case BTN_TAB_METALSEA:
					HideSubButton(false);
				
					pageHelmet.SetVisible(false);
					pageWeapon.SetVisible(false);
					pageArmor.SetVisible(false);
					pageWorldBase.SetVisible(false);
					pageWorldMetal.SetVisible(true);
					pageWorldIce.SetVisible(false);
					
					buttonTabWeapon.SetFocus(false);
					buttonTabArmor.SetFocus(false);
					buttonTabHat.SetFocus(false);
					buttonTabFishworld.SetFocus(true);
					
					buttonTabSea.SetFocus(false);
					buttonTabMetalSea.SetFocus(true);
					buttonTabIceSea.SetFocus(false);
					
					buttonTabMetalSea.SetVisible(false);
					buttonTabIceSea.SetVisible(true);
					buttonTabSea.SetVisible(true);
					
					curPage = pageWorldMetal;
					break;
				case BTN_TAB_ICESEA:
					HideSubButton(false);
				
					pageHelmet.SetVisible(false);
					pageWeapon.SetVisible(false);
					pageArmor.SetVisible(false);
					pageWorldBase.SetVisible(false);
					pageWorldMetal.SetVisible(false);
					pageWorldIce.SetVisible(true);
					
					buttonTabWeapon.SetFocus(false);
					buttonTabArmor.SetFocus(false);
					buttonTabHat.SetFocus(false);
					buttonTabFishworld.SetFocus(true);
					buttonTabSea.SetFocus(false);
					buttonTabMetalSea.SetFocus(false);
					buttonTabIceSea.SetFocus(true);
					buttonTabMetalSea.SetVisible(true);
					buttonTabIceSea.SetVisible(false);
					buttonTabSea.SetVisible(true);
					
					curPage = pageWorldIce;
					break;
			}
		}
		
		private function focusTo(rewardTab:String, rewardType:String, rewardId:int, rewardNum:int):void
		{
			pageWeapon.SetVisible(false);
			pageArmor.SetVisible(false);
			pageHelmet.SetVisible(false);
			pageWorldBase.SetVisible(false);
			pageWorldBase.SetVisible(false);
			
			buttonTabWeapon.SetFocus(false);
			buttonTabArmor.SetFocus(false);
			buttonTabHat.SetFocus(false);
			buttonTabFishworld.SetFocus(false);
			buttonTabSea.SetFocus(false);
			buttonTabMetalSea.SetFocus(false);
			buttonTabIceSea.SetFocus(false);
			switch(rewardTab)
			{
				case "Weapon":
					pageWeapon.SetVisible(true);
					pageWeapon.focusTo(rewardType, rewardId);
					buttonTabWeapon.SetFocus(true);
					
					curPage = pageWeapon;
					break;
				case "Armor":
					pageArmor.SetVisible(true);
					pageArmor.focusTo(rewardType, rewardId);
					buttonTabArmor.SetFocus(true);
					
					curPage = pageArmor;
					break;
				case "Helmet":
					pageHelmet.SetVisible(true);
					pageHelmet.focusTo(rewardType, rewardId);
					buttonTabHat.SetFocus(true);
					
					curPage = pageHelmet;
					break;
				case "FishWorld":
					pageWorldBase.SetVisible(true);
					pageWorldBase.focusTo(rewardType, rewardId);
					buttonTabFishworld.SetFocus(true);
					
					curPage = pageWorldBase;
					break;
				case "MetalSea":
					pageWorldMetal.SetVisible(true);
					pageWorldMetal.focusTo(rewardType, rewardId);
					buttonTabMetalSea.SetFocus(true);
					
					curPage = pageWorldMetal;
					break;
				case "FishWorld":
					pageWorldIce.SetVisible(true);
					pageWorldIce.focusTo(rewardType, rewardId);
					buttonTabIceSea.SetFocus(true);
					
					curPage = pageWorldIce;
					break;
			}
		}
		
		public function setFocusData(_rewardTab:String, _rewardType:String, _rewardId:int, _rewardNum:int):void
		{
			rewardTab = _rewardTab;
			rewardType = _rewardType;
			rewardId = _rewardId;
			rewardNum = _rewardId;
			isFocus = true;
			if (rewardTab == "Weapon" || rewardTab == "Helmet" || rewardTab == "Armor")
			{
				HideSubButton();
			}
			else
			{
				HideSubButton(false);
			}
		}
	}

}