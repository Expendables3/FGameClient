package GUI.EventBirthDay.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendOpenBirtDayBox extends BasePacket 
	{
		public var BoxId:int;
		public function SendOpenBirtDayBox(boxId:int) 
		{
			ID = Constant.CMD_SEND_OPEN_BIRTHDAYBOX;
			URL = "EventService.openBox";
			BoxId = boxId;
			IsQueue = false;
		}
		
	}

}