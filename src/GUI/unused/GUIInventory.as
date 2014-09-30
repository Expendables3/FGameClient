package GUI.unused
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Sound.SoundMgr;
	/**
	 * ...
	 * @author tuan
	 */
	public class GUIInventory extends BaseGUI
	{
		
		private const GUI_INVENTORY_BTN_CLOSE:String = "ButtonClose";
		
		private const GUI_INVENTORY_BTN_DECORATE:String = "Other";
		private const GUI_INVENTORY_BTN_NEW:String = "New";
		private const GUI_INVENTORY_BTN_FISH:String = "Fish";
		private const GUI_INVENTORY_BTN_FOOD:String = "Food";
		private const GUI_INVENTORY_BTN_SPECIAL:String = "Special";
		
		private var btnFood:Button;
		private var btnDecorate:Button;
		private var btnFish:Button;
		private var btnSpecial:Button;
		private var imgTab:Image;
		
		// so tien va xu
		private var txtXu:TextField = null;
		private var txtGold:TextField = null;
		
		public function GUIInventory(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIInventory";
		}
		
		public override function InitGUI() :void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			LoadRes("GUI_Store");
			
			// icon cua ahng
			//AddImage("", "IconKho", 135, 20);
			
			// image tab
			imgTab = AddImage("", "ShopIconTab", 92, 100, true, ALIGN_LEFT_TOP);
			
			var image:Image;
			// gold
			var txtGFormat:TextFormat = new TextFormat("Arial", 16, 0x000000, true);
			var gold:Number = GameLogic.getInstance().user.GetMoney();
			txtGold = AddLabel(gold.toString(), 185, 19, 0xffff, 0);
			txtGold.setTextFormat(txtGFormat);
			// icon gold
			image = AddImage("", "IcGold", 175, 32);
			image.SetScaleX(0.8);
			image.SetScaleY(0.8);
			
			// zing xu
			var txtXuFormat:TextFormat = new TextFormat("Arial", 16, 0x000000, true);
			var xu:int = GameLogic.getInstance().user.GetZMoney();
			txtXu = AddLabel(xu.toString(), 480, 19, 0xffff, 0);
			txtXu.setTextFormat(txtXuFormat);
			// icon xu
			image = AddImage("", "IcZingXu", 469, 32);
			image.SetScaleX(0.8);
			image.SetScaleY(0.8);
			
			// add 1 dong button o day
			btnFish = AddButton(GUI_INVENTORY_BTN_FISH, "BtnCaGiong", 17, 110, this);
			btnFood = AddButton(GUI_INVENTORY_BTN_FOOD, "ButtonThucAn", 17, 152, this);
			btnDecorate = AddButton(GUI_INVENTORY_BTN_DECORATE, "BtnTrangTri", 17, 195, this);
			btnSpecial = AddButton(GUI_INVENTORY_BTN_SPECIAL, "BtnSpecial", 17, 240, this);
			var btn:Button = AddButton(GUI_INVENTORY_BTN_CLOSE, "BtnThoat", 633, 10, this);
			//btn.img.scaleX = 0.9;
			//btn.img.scaleY = 0.9;

			//SetDragable(new Rectangle(100, 0, 300, 30)); 
			
			SetPos(80, 10);
			
			
			var curShop:String = GuiMgr.getInstance().GuiSubInvetory.CurrentShop;
			ChangeTabPos(curShop);
		}
		
		public function UpdateXuGold():void
		{
			// gold
			if (txtGold != null)
			{
				var txtGFormat:TextFormat = new TextFormat("Arial", 16, 0x000000, true);
				var gold:Number = GameLogic.getInstance().user.GetMoney(false);
				txtGold.text = gold.toString();
				txtGold.setTextFormat(txtGFormat);
			}
			
			// zing xu
			if (txtXu != null)
			{
				var txtXuFormat:TextFormat = new TextFormat("Arial", 16, 0x000000, true);
				var xu:int = GameLogic.getInstance().user.GetZMoney(false);
				txtXu.text = xu.toString();
				txtXu.setTextFormat(txtXuFormat);
			}
		}
		
		private function ChangeTabPos(ShopType:String):void
		{
			switch (ShopType)
			{
				case "Fish":
					imgTab.SetPos(95, 103);
					break;
				
				case "Food":
					imgTab.SetPos(94, 145);
					break;
				
				case "Other":
				case "OceanAnimal":
				case "OceanTree":
					imgTab.SetPos(94, 189);
					break;	
					
				case "Special":
					imgTab.SetPos(94, 234);
					break;
			}
		}
		
		public function ShowInventory(type:String):void
		{
			ChangeTabPos(type);
			
			switch (type)
			{
				case GUI_INVENTORY_BTN_FOOD:
					GuiMgr.getInstance().GuiSubInvetory.InitInventory("Food", 0);
				break;
				case GUI_INVENTORY_BTN_DECORATE:
					GuiMgr.getInstance().GuiSubInvetory.InitInventory("Other", 0);
				break;
				case GUI_INVENTORY_BTN_FISH:
					GuiMgr.getInstance().GuiSubInvetory.InitInventory("Fish", 0);
				break;
				case GUI_INVENTORY_BTN_SPECIAL:
					GuiMgr.getInstance().GuiSubInvetory.InitInventory("Special", 0);
					break;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{
				case GUI_INVENTORY_BTN_FISH:
				case GUI_INVENTORY_BTN_FOOD:
				case GUI_INVENTORY_BTN_DECORATE:
				case GUI_INVENTORY_BTN_SPECIAL:
				ShowInventory(buttonID);
				break;
				
				case GUI_INVENTORY_BTN_CLOSE:
				GuiMgr.getInstance().GuiSubInvetory.Hide();
				Hide();				
				break;
			}
		}
	}		
}

