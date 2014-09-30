package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBuyArrow extends BasePacket 
	{
		public var ArrowId:int;
		public var PriceType:String;
		
		public function SendBuyArrow(arrowId:int, priceType:String) 
		{
			ID = Constant.CMD_SEND_BUY_ARROW;
			URL = "MoonService.buyArrow";
			ArrowId = arrowId;
			PriceType = priceType;
			IsQueue = false;
		}
		
	}

}