package Event.EventNoel.NoelPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * goi tin hoan thanh nhanh trong event noel
	 * @author HiepNM2
	 */
	public class SendFastComplete extends BasePacket 
	{
		public var Type:String;
		public function SendFastComplete(type:String) 
		{
			URL = "EventService.fastComplete";
			ID = Constant.CMD_SEND_FAST_COMPELTE;
			Type = type;
			IsQueue = false;
		}
		
	}

}