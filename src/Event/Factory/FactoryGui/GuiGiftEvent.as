package Event.Factory.FactoryGui 
{
	import Event.Factory.FactoryLogic.EventSvc;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGiftEvent extends GUIReceiveMultiGiftAbstract 
	{
		protected var _slotName:String;
		public function GuiGiftEvent(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftEvent";
			ThemeName = "";
		}
		
		override public function initListGift():void 
		{
			var i:int;
			var allGift:Array = [];
			allGift = EventSvc.getInstance().getGiftServer();
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
																			_slotName,
																			0, 0);
			itemGift.initData(gift);
			itemGift.drawGift();
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
	}

}













