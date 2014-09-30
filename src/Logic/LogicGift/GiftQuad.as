package Logic.LogicGift 
{
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GiftQuad extends AbstractGift 
	{
		public var Level:int;
		public var Point:int;
		public function set Type(value:String):void
		{
			_itemType = value;
		}
		//public function set ItemId(value:int):void
		//{
			//_itemId = value;
		//}
		public var Id:int;
		public function GiftQuad() 
		{
			
		}
		override public function setInfo(data:Object):void 
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
		override public function getImageName():String 
		{
			return _itemType + _itemId;
		}
		
		override public function getTooltipText():String 
		{
			return "";
		}
	}

}