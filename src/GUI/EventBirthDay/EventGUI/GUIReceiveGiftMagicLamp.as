package GUI.EventBirthDay.EventGUI 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.EventBirthDay.EventLogic.MagicLampMgr;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIReceiveGiftMagicLamp extends GUIReceiveMultiGiftAbstract 
	{
		
		public function GUIReceiveGiftMagicLamp(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIReceiveGiftMagicLamp";
			ThemeName = "GuiInputCodeSuccess_Theme_Multi";
		}
		
		override public function initListGift():void 
		{
			var i:int;
			var allGift:Array = MagicLampMgr.getInstance().ListAllGift;
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
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
		
		override public function addTip():void 
		{
			var tf:TextField = AddLabel("Hôm qua bạn quên chưa nhận quà\n Thần đèn gửi trả bạn nè", 232, 110, 0x096791);
			var fm:TextFormat = new TextFormat();
			fm.align = TextFormatAlign.CENTER;
			fm.size = 19;
			fm.color = 0x096791;
			tf.setTextFormat(fm);
		}
	}

}



























