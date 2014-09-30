package Event.Factory.FactoryPacket 
{
	import Event.EventNoel.NoelPacket.SendExchangeNoelItem;
	import Event.EventNoel.NoelPacket.SendMakeBullet;
	import Event.EventTeacher.SendExchangeChar;
	import Event.EventTeacher.SendExchangeGiftFromChar;
	import Event.EventTeacher.SendGetGiftCombo;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendExchangeGift extends BasePacket 
	{
		public var ItemId:int;
		public var ItemType:String;
		public var Num:int;
		public function SendExchangeGift() 
		{
			URL = "EventService.colp_exchangeCollection";
			IsQueue = false;
		}
		public static function createPacketExchagne(itemName:String, idRow:int = 1, itemType:String = "Collection", num:int = 1):SendExchangeGift
		{
			switch(itemName)
			{
				case "ColPItem":
					return new SendExchangeChar(idRow, itemType, num);
				case "ColPGGift":
					return new SendExchangeGiftFromChar(idRow, itemType, num);
				case "Combo":
					return new SendGetGiftCombo(num);
				case "Candy":
					return new SendMakeBullet(idRow, itemType, num);
			}
			return null;
		}
	}

}