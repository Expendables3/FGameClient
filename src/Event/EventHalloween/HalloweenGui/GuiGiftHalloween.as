package Event.EventHalloween.HalloweenGui 
{
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.GuiMgr;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGiftHalloween extends GUIReceiveMultiGiftAbstract 
	{
		public var autoId:int = -1;
		private const obj:Object = { "Draft":1, "Paper":2, "GoatSkin":3, "Blessing":4, "Rent":9 };
		public function GuiGiftHalloween(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftHalloween";
			ThemeName = "GuiGiftHalloween_Theme";
			xListBox = 125;
			yListBox = 315;
			numRow = 2;
			numCol = 4;
			xClose = 688;
			yClose = 50;
			xReceive = 300;
			yReceive = 520;
			dCol = 40;
			dRow = 07;
			xNext = 670;
			xPrev = 45;
			yNextPrev = 385;
		}
		
		override public function initListGift():void 
		{
			var i:int;
			var allGift:Array = HalloweenMgr.getInstance().getAgent();
			for (i = 0; i < allGift.length; i++)
			{
				var gift:AbstractGift = allGift[i] as AbstractGift;
				addGift(gift);
			}
		}
		
		override public function addGift(gift:AbstractGift):void 
		{
			var itemGift:AbstractItemGift;
			if (gift.ClassName == "GiftNormal")
			{
				itemGift = new ItemNormalGift(this.img, "GuiGiftHalloween_ImgSlot");
			}
			else if (gift.ClassName == "GiftSpecial")
			{
				itemGift = new ItemSpecialGift(this.img, "KhungFriend");
			}
			itemGift.initData(gift, "", 75, 78, false);
			itemGift.drawGift();
			if (gift["ItemType"] == "Soldier")
			{
				itemGift.setTooltipText("Cá lính " + 
												obj[(gift as GiftNormal).RecipeType] + 
												" sao\n");
			}
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
		
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().guiFinishAuto.IsVisible)
			{
				GuiMgr.getInstance().guiFinishAuto.Hide();
			}
			if (GuiMgr.getInstance().guiHalloween.IsVisible)
			{
				GuiMgr.getInstance().guiHalloween.Hide();
				HalloweenMgr.getInstance().lockHalloween();
			}
			//HalloweenMgr.getInstance().RemainPlayCount--;
			if (autoId > 0)
			{
				GameLogic.getInstance().user.GetMyInfo().AutoId = autoId;
			}
			
		}
		
		
	}

}




















