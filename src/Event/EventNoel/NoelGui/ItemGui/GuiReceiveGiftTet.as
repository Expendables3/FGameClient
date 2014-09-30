package Event.EventNoel.NoelGui.ItemGui 
{
	import Event.Factory.FactoryLogic.EventSvc;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiReceiveGiftTet extends GUIReceiveMultiGiftAbstract 
	{
		
		public function GuiReceiveGiftTet(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ThemeName = "GuiReceiveGiftTet_Theme";
			xReceive = 255;
			yReceive = 370;
			xPrev = 30;
			xNext = 522;
			//xPrev = 522;
			yNextPrev = 265;
			xClose = 564;
			yClose = -5;
			xListBox = 67;
			yListBox = 178;
			numCol = 5;
			numRow = 2;
			dCol = 10;
			dRow = 10;
		}
		override public function addTip():void 
		{
			RemoveButton("idBtnClose");
		}
		override public function initListGift():void 
		{
			var listGift:Array = EventSvc.getInstance().getGiftServer();
			for (var i:int = 0; i < listGift.length; i++)
			{
				var gift:AbstractGift = listGift[i];
				addGift(gift);
			}
		}
		override public function addGift(gift:AbstractGift):void 
		{
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "GuiReceiveGiftTet_ImgSlot");
			itemGift.initData(gift);
			itemGift.drawGift();
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
	}

}