package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendExpiredEnergyMachine extends BasePacket 
	{
		public var UserId:int;
		public function SendExpiredEnergyMachine(id:int) 
		{
			ID = Constant.CMD_EXPIRED_ENERGY_MACHINE;
			URL = "CommonService.expiredEnergyMachine";
			UserId = id;
		}
		
	}

}