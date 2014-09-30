package GUI.EventMidle8 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetGiftEvent extends BasePacket 
	{
		public var Type:int;
		public var Element:int;
		public function SendGetGiftEvent(type:int, element:int) 
		{
			ID = Constant.CMD_GET_GIFT_EVENT_SPRING;
			URL = "CommonService.openVipMedalBox";	
			Type = type;
			Element = element;
			IsQueue = false;
		}
		
	}

}