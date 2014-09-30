package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetNewUserGiftBag extends BasePacket 
	{
		
		public function SendGetNewUserGiftBag() 
		{
			ID = Constant.CMD_GET_NEW_USER_GIFT_BAG;
			URL = "CommonService.getNewUserGiftBag";
			IsQueue = false;
		}
		
	}

}