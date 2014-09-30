package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBuyFlower extends BasePacket 
	{
		public var Item:Object;
		public function SendBuyFlower(_item:Object) 
		{
			IsEvent = true;
			URL = "EventService.buyItemInEvent";
			ID = Constant.CMD_SEND_BUY_FLOWER;
			Item = _item;
		}
	}

}