package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetListSell extends BasePacket 
	{
		
		public function SendGetListSell() 
		{
			ID = Constant.CMD_GET_LIST_SELL;
			URL = "MarketService.getMarket";
			IsQueue = false;
		}
		
	}

}