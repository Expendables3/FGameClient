package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendSeekGroupUpTime extends BasePacket 
	{
		public function SendSeekGroupUpTime() 
		{
			URL = "EventService.speedUp";
			ID = Constant.CMD_SEND_SEEK_GROWUP_FLOWER;
		}
	}

}