package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyDiamond extends BasePacket 
	{
		public var PackId:int;
		
		public function SendBuyDiamond(_packId:int) 
		{
			PackId = _packId;
			ID = Constant.CMD_BUY_DIAMOND;
			URL = "MarketService.exchangeDiamond";
		}
		
	}

}