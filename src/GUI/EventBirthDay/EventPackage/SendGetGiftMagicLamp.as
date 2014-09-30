package GUI.EventBirthDay.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendGetGiftMagicLamp extends BasePacket 
	{
		public var FirstDay:Boolean;
		public var GiftId:int;
		public var Element:int;
		public function SendGetGiftMagicLamp(fisrtTimeInDay:Boolean, giftId:int = -1, element:int = -1) 
		{
			URL = "EventService.getGiftInLight";
			ID = Constant.CMD_GET_GIFT_IN_MAGIC_LAMP;
			FirstDay = fisrtTimeInDay;
			GiftId = giftId;
			Element = element;
			IsQueue = false;
		}
		
	}

}