package Event.EventTeacher 
{
	import Data.Localization;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemTeacherInfo extends ItemCollectionInfo 
	{
		
		public function ItemTeacherInfo(type:String) 
		{
			_itemType = type;
		}
		override public function getImageName():String 
		{
			return "EventTeacher_" + _itemType + _itemId;
		}
		override public function getTooltipText():String 
		{
			return Localization.getInstance().getString("EventTeacher_" + _itemType + _itemId);
		}
	}

}


















