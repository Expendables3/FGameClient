package GUI.ChampionLeague.GuiLeague.itemGui 
{
	import flash.geom.Point;
	import GUI.component.Container;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * Item quà trong liên đấu
	 * @author HiepNM2
	 */
	public class ItemSlotGift extends Container 
	{
		private var _gift:AbstractGift;
		private var _itemGift:AbstractItemGift;
		public function ItemSlotGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ItemSlotGift";
		}

		public function set gift(value:AbstractGift):void 
		{
			_gift = value;
		}
		public function drawGift():void
		{
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, 
																			this.img, 
																			"GuiInputCodeSuccess_Slot1");
			_itemGift.initData(_gift);
			_itemGift.drawGift();
			_itemGift.FitRect(60, 60, new Point(0, 0));
		}
		
		override public function Destructor():void 
		{
			_itemGift.Destructor();
			super.Destructor();
		}
	}

}