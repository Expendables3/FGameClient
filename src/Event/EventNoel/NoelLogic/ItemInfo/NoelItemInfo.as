package Event.EventNoel.NoelLogic.ItemInfo 
{
	import Data.Localization;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	
	/**
	 * Thông tin về vật phẩm rơi ra khi săn cá
	 * @author HiepNM2
	 */
	public class NoelItemInfo extends ItemCollectionInfo 
	{
		
		public function NoelItemInfo(type:String) 
		{
			_itemType = type;//"NoelItem"
		}
		override public function getImageName():String 
		{
			return "EventNoel_" + _itemType + _itemId;
		}
		
		override public function getTooltipText():String 
		{
			return Localization.getInstance().getString("EventNoel_" + _itemType + _itemId);
		}
		override public function getItemName():String 
		{
			return Localization.getInstance().getString("EventNoel_" + _itemType + _itemId);
		}
		
	}

}