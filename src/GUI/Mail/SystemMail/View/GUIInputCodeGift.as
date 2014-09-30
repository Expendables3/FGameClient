package GUI.Mail.SystemMail.View 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import GUI.Mail.SystemMail.Controller.GiftInputCodeMgr;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * gui hiển thị quà sau khi nạp code
	 * @author HiepNM2
	 */
	public class GUIInputCodeGift extends GUIReceiveMultiGiftAbstract 
	{

		public function GUIInputCodeGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIInputCodeGift2";
			ThemeName = "GuiInputCodeSuccess_Theme_Multi";
		}

		override public function addTip():void 
		{
			var tf:TextField = AddLabel("Bạn đã nạp code thành công\nBạn nhận được", 232, 110, 0x096791);
			var fm:TextFormat = new TextFormat();
			fm.align = TextFormatAlign.CENTER;
			fm.size = 20;
			fm.color = 0x096791;
			tf.setTextFormat(fm);
		}
		override public function initListGift():void 
		{
			var i:int;
			var allGift:Array = GiftInputCodeMgr.getInstance().ListAllGift;
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
	}

}


































