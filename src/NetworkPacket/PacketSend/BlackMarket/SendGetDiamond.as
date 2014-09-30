package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetDiamond extends BasePacket 
	{
		
		public var Position:int;
		
		public function SendGetDiamond(_position:int) 
		{
			Position = _position;
			ID = Constant.CMD_GET_DIAMOND;
			URL = "MarketService.getDiamond";
			IsQueue = false;
		}
		
	}

}