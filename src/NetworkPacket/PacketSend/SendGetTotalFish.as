package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendGetTotalFish extends BasePacket
	{		
		public function SendGetTotalFish() 
		{
			ID = Constant.CMD_GET_TOTAL_FISH;
			URL = "LakeService.getTotalFish";			
			IsQueue = false;
		}
	}

}