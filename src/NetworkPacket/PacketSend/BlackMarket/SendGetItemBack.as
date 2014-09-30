package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetItemBack extends BasePacket 
	{
		public var Position:int;
		public var AutoId:int;
		
		public function SendGetItemBack(_position:int, _autoId:int) 
		{
			Position = _position;
			AutoId = _autoId;
			ID = Constant.CMD_GET_ITEM_BACK;
			URL = "MarketService.getItemBack";
			IsQueue = false;
		}
		
	}

}