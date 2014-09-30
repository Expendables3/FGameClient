package GUI.EventBirthDay.EventLogic 
{
	import Data.ConfigJSON;
	import Data.Localization;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class BirthdayItem 
	{
		public var ItemType:String;
		public var ItemId:int;
		
		public var UnlockType:int;
		public var ZMoney:int;
		public var Money:int;
		private var _num:int;
		
		public function BirthdayItem() 
		{
			ItemType = "BirthDayItem";
		}
		
		public function get Name():String
		{
			return Localization.getInstance().getString(ItemType + ItemId);
		}
		
		public function setInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try {
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
		
		public function set Num(value:int):void
		{
			if (value)
			{
				_num = value;
			}
			else
			{
				_num = 0;
			}
		}
		
		public function get Num():int
		{
			return _num;
		}
		
		public function get ImageName():String
		{
			return ItemType + ItemId;
		}
		
		public function getScalePriceTable():Number
		{
			var scale:Number;
			var length:int = _num.toString().length;
			switch(length)
			{
				case 6:
				case 5:
					scale = 1;
				break;
				case 4:
					scale = 0.8;
				break;
				default:
					scale = 0.6;
			}
			return scale;
		}
	}

}








































