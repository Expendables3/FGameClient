package GUI.EventBirthDay.EventGUI 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.GUIAbstractCongrate;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUICongrateEventBirthday extends GUIAbstractCongrate 
	{
		
		private var _gift:AbstractGift;
		public function GUICongrateEventBirthday(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUICongrateEventBirthday";
		}
		public function initData(gift:AbstractGift):void
		{
			type = "RECEIVE";
			_gift = gift;
		}
		
		override protected function addGift():void 
		{
			var itemGift:AbstractItemGift;
			if (_gift.ClassName == "GiftNormal")
			{
				itemGift = new ItemNormalGift(this.img, "KhungFriend", 168 + 52, 144 + 53);
				(itemGift as ItemNormalGift).xNum = -75;
				(itemGift as ItemNormalGift).yNum = -11;
			}
			else if (_gift.ClassName == "GiftSpecial")
			{
				itemGift = new ItemSpecialGift(this.img, "KhungFriend", 158, 137);
			}
			itemGift.initData(_gift, "", 0, 0, false);
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
	}

}





































