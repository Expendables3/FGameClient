package Event.EventNoel.NoelGui 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetVIPBox extends BasePacket 
	{
		
		public function SendGetVIPBox() 
		{
			ID = Constant.CMD_GET_VIP_BOX;
			URL = "VipBoxService.getVipBox";
			IsQueue = false;
		}
		
	}

}