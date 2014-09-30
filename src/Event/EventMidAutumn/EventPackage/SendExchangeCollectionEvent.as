package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendExchangeCollectionEvent extends BasePacket 
	{
		public var CollectionId:int;
		public function SendExchangeCollectionEvent(id:int) 
		{
			URL = "EventService.moon_exchangeItemCollection";
			ID = Constant.CMD_EXCHANGE_COLLECTION_GIFT;
			CollectionId = id;
			IsQueue = false;
		}
		
	}

}