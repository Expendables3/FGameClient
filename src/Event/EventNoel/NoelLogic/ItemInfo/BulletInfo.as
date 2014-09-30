package Event.EventNoel.NoelLogic.ItemInfo 
{
	import Data.Localization;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	
	/**
	 * Thông tin về các viên đạn
	 * @author HiepNM2
	 */
	public class BulletInfo extends ItemCollectionInfo 
	{
		public var UseXu:Boolean;
		public function BulletInfo(type:String) 
		{
			_itemType = type;
		}
		
		override public function getImageName():String 
		{
			return "EventNoel_" + _itemType + _itemId;
		}
		
		override public function getTooltipText():String 
		{
			return Localization.getInstance().getString("EventNoel_" + _itemType + _itemId);
		}
		public function getBulletFireName():String
		{
			return "GuiHuntFish_" + _itemType + _itemId;
		}
		public function getBulletShopName():String
		{
			return "GuiExchangeCandy_Img" + _itemType + _itemId;
		}
	}

	
}




















