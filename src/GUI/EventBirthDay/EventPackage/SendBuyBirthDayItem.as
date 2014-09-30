package GUI.EventBirthDay.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBuyBirthDayItem extends BasePacket 
	{
		public var Item:Object;
		public function SendBuyBirthDayItem(item:Object) 
		{
			URL = "EventService.buyItem";
			ID = Constant.CMD_SEND_BUY_BIRTHDAYITEM;
			Item = item;
		}
	}

}