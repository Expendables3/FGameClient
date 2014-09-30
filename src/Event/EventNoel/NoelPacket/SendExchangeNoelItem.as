package Event.EventNoel.NoelPacket 
{
	import GUI.GuiBuyAbstract.SendExchangeAbstract;
	
	/**
	 * Gói tin đổi quà từ bộ sưu tập trong eventNoel
	 * @author HiepNM2
	 */
	public class SendExchangeNoelItem extends SendExchangeAbstract 
	{
		public var ItemType:String;
		public var ItemId:int;
		public var Index:int;
		public var Num:int;
		public function SendExchangeNoelItem(urlAPI:String, idAPI:String, 
												idRow:int, idCol:int, 
												itemType:String, num:int) 
		{
			super(urlAPI, idAPI);
			ItemType = itemType;
			ItemId = idRow;
			Index = idCol;
			Num = num;
			IsQueue = false;
		}
		
	}

}