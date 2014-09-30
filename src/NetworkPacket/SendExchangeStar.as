package NetworkPacket 
{
	/**
	 * ...
	 * @author longpt
	 */
	public class SendExchangeStar extends BasePacket 
	{
		
		public function SendExchangeStar() 
		{
			ID = Constant.CMD_EXCHANGE_STAR;
			URL = "EventService.receiveGift";
			IsQueue = false;
		}
		
	}

}