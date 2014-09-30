package Logic 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class QuestBonus
	{
		public var ItemType:String;
		public var ItemId:int;
		public var Num:int;
		public var Sure:Object;
		public var Lucky:Object;
		public var Rank:int;
		public var Color:int;
		
		public function QuestBonus()
		{
			
		}
		
		public function Init(itemType:String, itemId:int, itemNumb:int):void
		{
			ItemType = itemType;
			ItemId = itemId;
			Num = itemNumb;		
		}
		
		public function SetInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
	}

}