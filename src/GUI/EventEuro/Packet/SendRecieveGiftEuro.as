package GUI.EventEuro.Packet 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendRecieveGiftEuro extends BasePacket 
	{
		public var MatchId:int;
		public var Type:String;
		public var Element:int;
		
		public function SendRecieveGiftEuro(type:String, matchId:int = 0, element:int = 0) 
		{
			Type = type;
			MatchId = matchId;
			Element = element;
			ID = Constant.CMD_RECIEVE_GIFT_EURO;
			URL = "EventService.euro_getGift";
			IsQueue = false;
			
		}
		
	}

}