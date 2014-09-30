package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyDiscount extends BasePacket 
	{
		public var discountId:int;
		public var isMoney:Boolean;
		
		public function SendBuyDiscount(_discountId:int, isMoney:Boolean = false) 
		{
			ID = Constant.CMD_BUY_DISCOUNT;
			URL = "ItemService.buyDiscount";
			discountId = _discountId;
			isMoney = isMoney;
		}
		
	}

}