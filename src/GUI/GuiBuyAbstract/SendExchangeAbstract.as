package GUI.GuiBuyAbstract 
{
	import Event.EventNoel.NoelPacket.SendExchangeNoelItem;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendExchangeAbstract extends BasePacket 
	{
		
		public function SendExchangeAbstract(urlAPI:String,idAPI:String) 
		{
			URL = urlAPI;
			ID = idAPI;
		}
		
		public static function createPacket(itemName:String, urlAPI:String, idAPI:String, 
												type:String, idRow:int, idCol:int, num:int,
												data:Object = null):SendExchangeAbstract
		{
			switch(itemName)
			{
				case "NoelItem":
					return new SendExchangeNoelItem(urlAPI, idAPI, idRow, idCol, type, num);
			}
			return new SendExchangeAbstract(urlAPI, idAPI);
		}
	}

	
}



















