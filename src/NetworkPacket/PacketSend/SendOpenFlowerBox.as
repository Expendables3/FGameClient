package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendOpenFlowerBox extends BasePacket 
	{
		public var BoxId:int;
		public function SendOpenFlowerBox(boxId:int) 
		{
			ID = Constant.CMD_SEND_OPEN_FLOWERBOX;
			URL = "EventService.openBox";
			BoxId = boxId;
			IsQueue = false;
		}
		
	}

}