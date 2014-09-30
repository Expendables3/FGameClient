package Event.EventNoel.NoelLogic.ItemInfo 
{
	import Data.Localization;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	
	/**
	 * Thông tin về Item Kẹo
	 * @author HiepNM2
	 */
	public class CandyInfo extends ItemCollectionInfo 
	{
		
		public function CandyInfo(type:String) 
		{
			_itemType = type;//"Candy"
		}
		override public function getImageName():String 
		{
			return "EventNoel_" + _itemType + _itemId;
		}
		override public function getTooltipText():String 
		{
			return Localization.getInstance().getString("EventNoel_" + _itemType + _itemId);
		}
	}

}






















