package Event.EventHalloween.HalloweenGui.unused 
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
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGiftFinish extends GUIReceiveMultiGiftAbstract 
	{
		private const obj:Object = { "Draft":1, "Paper":2, "GoatSkin":3, "Blessing":4, "Rent":9 };
		public function GuiGiftFinish(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftFinish";
			ThemeName = "GuiGiftFinish_Theme";
		}
		override public function addTip():void 
		{
			var tf:TextField = AddLabel("", 232, 116, 0x096791);
			var fm:TextFormat = new TextFormat();
			fm.align = TextFormatAlign.CENTER;
			fm.size = 20;
			fm.color = 0x096791;
			tf.defaultTextFormat = fm;
			tf.text = "Phần thưởng mật bảo";
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
				itemGift = new ItemNormalGift(this.img, "GuiGiftFinish_Slot1");
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
			if (GuiMgr.getInstance().guiHalloween.IsVisible)
			{
				GuiMgr.getInstance().guiHalloween.Hide();
				HalloweenMgr.getInstance().lockHalloween();
			}
			
		}
	}

}
















