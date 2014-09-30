package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendChangePointGetGift extends BasePacket 
	{
		public var Type:int; //20 or 50 or 100
		public var Element:int;	// 1 2 3 4 5
		public function SendChangePointGetGift(type:int, element:int) 
		{
			//super();
			URL = "EventService.changePointToGetGift";
			ID = Constant.CMD_SEND_CHANGE_POINT;
			Type = type;
			Element = element;
		}
		
	}

}