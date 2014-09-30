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
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGiftTrunk extends GUIReceiveMultiGiftAbstract 
	{
		private const obj:Object = { "Draft":1, "Paper":2, "GoatSkin":3, "Blessing":4, "Rent":9 };
		private var _id:int = -1;//id của rương
		public function set Id(value:int):void
		{
			if (value == 1 || value == 2)
			{
				_id = value;
			}
			else
			{
				_id = -1;
			}
		}
		public function GuiGiftTrunk(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftTrunk";
			ThemeName = "GuiInputCodeSuccess_Theme_Multi";
		}
		override public function addTip():void 
		{
			var tf:TextField = AddLabel("", 232, 116, 0x096791);
			var fm:TextFormat = new TextFormat();
			fm.align = TextFormatAlign.CENTER;
			fm.size = 20;
			fm.color = 0x096791;
			tf.defaultTextFormat = fm;
			tf.text = "Phần thưởng rương " + getType(_id);
		}
		
		private function getType(id:int):String
		{
			switch(id)
			{
				case 1:
					return "thường";
				case 2:
					return "thần";
				default:
					return "";
			}
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
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, 
																			this.img, 
																			"GuiInputCodeSuccess_Slot1");
			itemGift.initData(gift);
			itemGift.drawGift();
			if (gift["ItemType"] == "Soldier")
			{
				itemGift.setTooltipText("Cá lính " + 
												obj[(gift as GiftNormal).RecipeType] + 
												" sao\n");
			}
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
		
		override public function processGetGift():void 
		{
			var length:int = ListGift.length;
			for (var i:int = 0; i < length; i++)
			{
				var itGift:AbstractItemGift = ListGift.getItemByIndex(i) as AbstractItemGift;
				var gift:AbstractGift = itGift["Gift"];
				//HalloweenMgr.getInstance().addItemStore(gift);
				GuiMgr.getInstance().TrunkHalloween.updateItem(gift);
				GuiMgr.getInstance().guiHalloween.inUnlock = false;
			}
		}
	}

}


















