package Event.Factory.FactoryPacket 
{
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBuyEventItem extends SendExchangeItem 
	{
		
		public function SendBuyEventItem(urlAPI:String, idAPI:String,
											type:String, id:int,
											num:int, priceType:String) 
		{
			super(urlAPI, idAPI);
			ItemType = type;
			ItemId = id;
			Num = num;
			PriceType = priceType;
			IsQueue = false;
		}
		
	}

}