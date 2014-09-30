package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendFillEnergy extends BasePacket
	{
		
		public function SendFillEnergy() 
		{
			ID = Constant.CMD_FILL_ENERGY;
			URL = "CommonService.fillEnergy";
			IsQueue = false;
		}
		
	}

}