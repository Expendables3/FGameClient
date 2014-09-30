package GUI.EventLuckyMachine 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.GUIAbstractCongrate;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * Gui nhận thưởng trong máy quay sò
	 * @author HiepNM2
	 */
	public class GUIDigitWheelGift extends GUIAbstractCongrate 
	{
		private var _gift:AbstractGift;
		
		public function GUIDigitWheelGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIDigitWheelGift";
		}
		
		public function initData(gift:AbstractGift, Type:String):void
		{
			type = Type;
			_gift = gift;
		}
		
		override protected function addGift():void 
		{
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(_gift.ItemType, 
																			this.img, 
																			"GuiInputCodeSuccess_Slot1");
			itemGift.initData(_gift);
			itemGift.drawGift();
		}
		
		override protected function addTip():void 
		{
			var tf:TextField = AddLabel("Phần thưởng", 145, 96);
			var fm:TextFormat = new TextFormat();
			fm.size = 20;
			fm.color = 0x1F4872;
			fm.bold = true;
			tf.setTextFormat(fm);
		}
		
		override protected function receive():void 
		{
			Hide();
		}
		override public function Hide():void 
		{
			GuiMgr.getInstance().guiDigitWheel.resetMachine();
			super.Hide();
		}
		override protected function feed():void 
		{
			GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_LUCKY_MACHINE_VUKHIVIP);
			Hide();
		}
	}

}



















