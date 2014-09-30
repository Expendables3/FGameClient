package Event.Factory.FactoryPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendExchangeItem extends BasePacket 
	{
		
		public function SendExchangeItem(urlAPI:String, idAPI:String) 
		{
			URL = urlAPI;
			ID = idAPI;
		}
		/**
		 * tao ra goi tin doi qua
		 * @param	urlAPI dia chi cua service
		 * @param	idExchangeAPI id cua service -> de bat goi tin tra ve
		 * @param	params tham so
		 * @param	dataPacket du lieu them vao cho goi tin
		 * @return
		 */
		static public function createExchangePacket(urlAPI:String, idAPI:String, params:Array = null, dataPacket:Object = null):SendExchangeItem
		{
			switch(urlAPI)
			{
				case "EventService.buyItem":
					var priceType:String = params[0];
					var itemType:String = params[1];
					var itemId:int= int(params[2]);
					var num:String = int(params[3]);
					return new SendBuyEventItem(urlAPI, idAPI, itemType, itemId, num, priceType);
			}
			return new SendExchangeItem(urlAPI, idAPI);
	}

}