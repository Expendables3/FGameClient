package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetGiftStore extends BasePacket 
	{
		public function SendGetGiftStore() 
		{
			ID = Constant.CMD_GET_STORE_MID_AUTUMN;
			URL = "EventService.moon_getGiftStore";
			IsQueue = false;
		}
		
	}

}