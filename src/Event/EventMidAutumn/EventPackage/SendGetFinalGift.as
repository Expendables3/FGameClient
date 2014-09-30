package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetFinalGift extends BasePacket 
	{
		
		public function SendGetFinalGift()
		{
			ID = Constant.CMD_SEND_GET_FINAL_GIFT;
			URL = "EventService.moon_kissMissMoon";
			IsQueue = false;
		}
		
	}

}