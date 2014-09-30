package GUI.unused
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	
	import flash.events.*;
	import Logic.*;
	import Data.*;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIShop extends BaseGUI
	{
		private const GUI_SHOP_BTN_CLOSE:String = "ButtonClose";
		
		private const GUI_SHOP_BTN_DECORATE:String = "Other";
		private const GUI_SHOP_BTN_NEW:String = "New";
		private const GUI_SHOP_BTN_FISH:String = "Fish";
		private const GUI_SHOP_BTN_FOOD:String = "Food";
		private const GUI_SHOP_BTN_SPECIAL:String = "Special";
		
		// con tro den cac button
		public var btnNew:Button;
		private var btnDecorate:Button;
		private var btnFish:Button;
		private var btnFood:Button;
		private var btnSpecial:Button;
		private var imgTab:Image;
		
		// so tien va xu
		private var txtXu:TextField = null;
		private var txtGold:TextField = null;

		
		// shop type
		public const SHOP_NEW:int = 0;
		public const SHOP_FISH:int = 1;
		public const SHOP_DECORATE_BOTTOM:int = 2;
		public const SHOP_DECORATE_BACKGROUND:int = 3;
		
		
		public function GUIShop(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIShop";
		}
		
		public override function InitGUI() :void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			LoadRes("GUIShopBg");
			// icon cua hang
			//AddImage("", "ShopIconCuaHang", 340, 80);
			
			// image tab
			//imgTab = AddImage("", "ShopIconTab", 94, 100, true, ALIGN_LEFT_TOP);
			
			var image:Image;
			// gold
			var txtGFormat:TextFormat = new TextFormat("Arial", 14, 0xffffff, true);
			var gold:Number = GameLogic.getInstance().user.GetMoney();
			txtGold = AddLabel(Ultility.StandardNumber(gold), 335, 22, 0, 0 , 6);
			txtGold.setTextFormat(txtGFormat);
			// icon gold
			image = AddImage("", "IcGold", 320, 31);
			//image.SetScaleX(0.8);
			//image.SetScaleY(0.8);
			
			// zing xu
			var txtXuFormat:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
			var xu:int = GameLogic.getInstance().user.GetZMoney();
			txtXu = AddLabel(Ultility.StandardNumber(xu), 438, 21, 0, 0, 6);
			txtXu.setTextFormat(txtXuFormat);
			// icon xu
			image = AddImage("", "IcZingXu", 423, 31);
			//image.SetScaleX(0.8);
			//image.SetScaleY(0.8);

			
			// add 1 dong button o day
			AddImage("", "ButtonNew2", 57, 59, true, ALIGN_LEFT_TOP);
			btnNew = AddButton(GUI_SHOP_BTN_NEW, "ButtonNew", 57, 59, this);
			
			AddImage("", "BtnCaGiong2", 157, 59, true, ALIGN_LEFT_TOP);
			btnFish = AddButton(GUI_SHOP_BTN_FISH, "BtnCaGiong", 157, 59, this, INI.getInstance().getHelper("helper9"));
			
			AddImage("", "ButtonThucAn2", 257, 59, true, ALIGN_LEFT_TOP);
			btnFood = AddButton(GUI_SHOP_BTN_FOOD, "ButtonThucAn", 257, 59, this);
			
			AddImage("", "BtnTrangTri2", 357, 59, true, ALIGN_LEFT_TOP);
			btnDecorate = AddButton(GUI_SHOP_BTN_DECORATE, "BtnTrangTri", 357, 59, this, INI.getInstance().getHelper("helper2"));
			
			AddImage("", "BtnSpecial2", 457, 59, true, ALIGN_LEFT_TOP);
			btnSpecial = AddButton(GUI_SHOP_BTN_SPECIAL, "BtnSpecial", 457, 59, this);
			
			var btn:Button = AddButton(GUI_SHOP_BTN_CLOSE, "BtnThoat", 638, -2, this);
			//btn.img.scaleX = 0.8;
			//btn.img.scaleY = 0.8;
			
			if (GameLogic.getInstance().user.IsViewer())
			{
				btnNew.SetEnable(false);
				btnFish.SetEnable(false);
				btnDecorate.SetEnable(false);
				btnSpecial.SetEnable(false);
			}
			
			SetPos(70, 30);
			
			var curShop:String = GuiMgr.getInstance().GuiBuyShop.CurrentShop;
			// tab
			ChangeTabPos(curShop);
			
			// show shop
			GuiMgr.getInstance().GuiBuyShop.InitShop(curShop, GuiMgr.getInstance().GuiBuyShop.CurrentPage);	
		}
		
		private function ChangeTabPos(ShopType:String):void
		{
			btnNew.SetFocus(false);
			btnFish.SetFocus(false);
			btnFood.SetFocus(false);
			btnDecorate.SetFocus(false);
			btnSpecial.SetFocus(false);
			switch (ShopType)
			{
				case "New":
					//imgTab.SetPos(95, 105);
					btnNew.SetFocus(true);
					break;
					
				case "Fish":
					//imgTab.SetPos(94, 145);
					btnFish.SetFocus(true);
					break;
				
				case "Food":
					//imgTab.SetPos(94, 189);
					btnFood.SetFocus(true);
					break;
				
				case "Other":
					btnDecorate.SetFocus(true);
					break;
				case "OceanAnimal":
					break;
				case "OceanTree":
					//imgTab.SetPos(94, 234);
					break;	
					
				case "Special":
					btnSpecial.SetFocus(true);
					//imgTab.SetPos(94, 278);
					break;
			}
		}
		
		public function ShowShop(type:String):void
		{
			ChangeTabPos(type);
			
			switch (type)
			{
				case GUI_SHOP_BTN_NEW:
					GuiMgr.getInstance().GuiBuyShop.InitShop("New", 0);
					break;
					
				case GUI_SHOP_BTN_FISH:
					GuiMgr.getInstance().GuiBuyShop.InitShop("Fish", 0);
					break;
				
				case GUI_SHOP_BTN_FOOD:
					GuiMgr.getInstance().GuiBuyShop.InitShop("Food", 0);
					break;
				
				case GUI_SHOP_BTN_DECORATE:
					GuiMgr.getInstance().GuiBuyShop.InitShop("Other", 0);
					break;
					
				case GUI_SHOP_BTN_SPECIAL:
					GuiMgr.getInstance().GuiBuyShop.InitShop("Special", 0);
					//GuiMgr.getInstance().GuiBuyShop.InitShopMixLake();
					break;
			}
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_SHOP_BTN_NEW:
				case GUI_SHOP_BTN_FISH:
				case GUI_SHOP_BTN_DECORATE:
				case GUI_SHOP_BTN_FOOD:
				case GUI_SHOP_BTN_SPECIAL:
				ShowShop(buttonID);
				break;
				
				case GUI_SHOP_BTN_CLOSE:
				GuiMgr.getInstance().GuiBuyShop.Hide();
				Hide();
				
				
				break;
			}
		}
		
	}

}