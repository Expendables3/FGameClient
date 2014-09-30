package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGiftSaveHalloween extends GUIReceiveMultiGiftAbstract 
	{
		private const obj:Object = { "Draft":1, "Paper":2, "GoatSkin":3, "Blessing":4, "Rent":9 };
		public function GuiGiftSaveHalloween(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftSaveHalloween";
			ThemeName = "GuiGiftSaveHalloween_Theme";
			xClose = 348;
			yClose = 16;
			xReceive = 127;
			yReceive = 212;
			xListBox = 145;
			yListBox = 103;
		}
		
		override public function initListGift():void 
		{
			var i:int;
			var allGift:Array = HalloweenMgr.getInstance().GiftSave;
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
				itemGift = new ItemNormalGift(this.img, "KhungFriend");
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
		
		override public function addTip():void 
		{
			var tfTip:TextField = AddLabel("", 138, 67);
			var fm:TextFormat = new TextFormat("Arial", 16, 0x000000, true);
			fm.align = TextFormatAlign.CENTER;
			tfTip.defaultTextFormat = fm;
			var strTip:String = "Đã hết thời gian bạn không kịp giải cứu\ncông chúa Lạc Lạc! ";
			tfTip.text = strTip;
		}
	}

}
















