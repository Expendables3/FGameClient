package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendUsePetrol extends BasePacket 
	{
		public var Type:int;
		public function SendUsePetrol(idpetrol:int) 
		{
			ID = Constant.CMD_USE_PETROL;
			URL = "CommonService.usePetrol";
			Type = idpetrol;
		}
		
	}

}