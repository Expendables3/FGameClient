package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiReceiveEquipment extends GUIReceiveMultiGiftAbstract 
	{
		private var _gift:AbstractGift;
		public function set GiftS(value:GiftSpecial):void
		{
			_gift = value;
		}
		public function GuiReceiveEquipment(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiReceiveEquipment";
			ThemeName = "GuiInputCodeSuccess_Theme_Single";
			xListBox = 149;
			yListBox = 127;
			numCol = 1;
			numRow = 1;
			xReceive = 165;
			yReceive = 253;
			xClose = 376;
			yClose = 27;
		}
		override public function initListGift():void 
		{
			addGift(_gift);
		}
		override public function addGift(gift:AbstractGift):void 
		{
			var itemGift:AbstractItemGift;
			itemGift = new ItemSpecialGift(this.img, "KhungFriend");
			itemGift.initData(gift);
			itemGift.drawGift();
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
	}

}






















