package GUI.FirstPay 
{
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
	public class GuiReceiveGiftPay extends GUIReceiveMultiGiftAbstract 
	{
		private const obj:Object = { "Draft":1, "Paper":2, "GoatSkin":3, "Blessing":4, "Rent":9 };
		private var _listGift:Array = [];
		public function GuiReceiveGiftPay(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiReceiveGiftPay";
			ThemeName = "GuiInputCodeSuccess_Theme_Multi";
		}
		public function initData(listGift:Array):void {
			_listGift.splice(0, _listGift.length);
			/*clone listGift and copy to _listGift*/
			for (var i:int = 0; i < listGift.length; i++) {
				_listGift.push(listGift[i]);
			}
		}
		override public function addTip():void 
		{
			var tf:TextField = AddLabel("Phần thưởng nạp thẻ", 232, 116, 0x096791);
			var fm:TextFormat = new TextFormat();
			fm.align = TextFormatAlign.CENTER;
			fm.size = 20;
			fm.color = 0x096791;
			tf.setTextFormat(fm);
		}
		override public function initListGift():void 
		{
			var i:int;
			for (i = 0; i < _listGift.length; i++)
			{
				var gift:AbstractGift = _listGift[i] as AbstractGift;
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
	}

}














