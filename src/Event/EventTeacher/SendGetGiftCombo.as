package Event.EventTeacher 
{
	import Event.Factory.FactoryPacket.SendExchangeGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendGetGiftCombo extends SendExchangeGift 
	{
		public var IsNormalGift:Boolean = false;
		public var Ans:int;
		public function SendGetGiftCombo(num:int) 
		{
			URL = "EventService.colp_comboGGift";
			ID = Constant.CMD_RECEIVE_COMBO_GIFT;
			IsQueue = false;
			Num = num;
		}
		
	}

}