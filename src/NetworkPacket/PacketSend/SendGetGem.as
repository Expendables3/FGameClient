package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetGem extends BasePacket 
	{
		public var GemId:int;
		
		public function SendGetGem(id:int) 
		{
			ID = Constant.CMD_GET_GEM;
			URL = "MaterialService.getGem";
			GemId = id;
			IsQueue = false;
		}
		
	}

}