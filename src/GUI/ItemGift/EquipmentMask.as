package GUI.ItemGift 
{
	import Data.ConfigJSON;
	import Logic.GameLogic;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class EquipmentMask extends GiftSpecial 
	{
		public static const MASK_DRAGON:int = 1;
		public static const MASK_SHEN:int = 2;
		public static const MASK_SPARTA:int = 3;
		public static const MASK_TUARUA:int = 4;
		public static const MASK_CHAMPION:int = 5;
		public var TimeUse:Number;
		public function EquipmentMask() 
		{
			
		}
		
		public function getTimeLeftString():String
		{
			var cfg:Object = ConfigJSON.getInstance().GetEquipmentInfo(_itemType, Rank + "$" + Color);
			var strTime:String = "";
			var timeLeft:Number = cfg.TimeUse + StartTime - GameLogic.getInstance().CurServerTime;
			var dayLeft:int = Math.floor(timeLeft / 86400);
			var hourLeft:int = Math.floor((timeLeft % 86400) / 3600);
			var minLeft:int = Math.floor(((timeLeft  % 86400) % 3600) / 60);
			var secLeft:int = timeLeft - dayLeft * 86400 - hourLeft * 3600 - minLeft * 60;
			
			if (dayLeft > 0)
			{
				strTime += (dayLeft + 1) + " ngày";
			}
			else if (hourLeft > 0)
			{
				strTime += hourLeft + " giờ";
			}
			else if (minLeft > 0)
			{
				strTime += minLeft + " phút";
			}
			else if (secLeft > 0)
			{
				strTime += secLeft + " giây";
			}
			return strTime;
		}
		
		public function getFishByMaskId():String
		{
			switch (Rank)
			{
				case MASK_DRAGON:
					return "Dragon_4";
				case MASK_SHEN:
					return "Shen";
				case MASK_SPARTA:
					return "SpartaWar";
				case MASK_TUARUA:
					return "TuaRuaBaoTu";
				case MASK_CHAMPION:
					return "Champion";
			}
			return "";
		}
		
	}
}


















