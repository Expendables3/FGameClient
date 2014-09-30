package GUI.FirstPay 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * gói tin nhận quà và chọn hệ trong gui nạp thẻ lần đầu
	 * @author HiepNM2
	 */
	public class SendGetGiftPay extends BasePacket 
	{
		public var GiftType:int;
		public var Element:int;
		
		public function SendGetGiftPay(giftType:int = -1, element:int = -1) 
		{
			ID = Constant.CMD_RECEIVE_GIFT_PAY;
			URL = "UserService.getFirstAddXuGift";
			GiftType = giftType;
			Element = element;
			IsQueue = false;
		}
	}

}