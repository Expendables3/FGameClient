package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendCareFlower extends BasePacket 
	{
		public function SendCareFlower() 
		{
			ID = Constant.CMD_SEND_CARE_FLOWER;
			URL = "EventService.careFlower";
			IsQueue = false;
		}
	}

}