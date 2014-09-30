package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class SendChangeKey extends BasePacket
	{
		public var KeyId:int;
		
		public function SendChangeKey(keyId:int) 
		{
			ID = Constant.CMD_CHANGE_KEY;
			URL = "EventService.exchangeIcon";
			IsQueue = false;
			
			KeyId = keyId;
		}
		
	}

}