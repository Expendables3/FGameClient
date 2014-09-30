package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyIconND extends BasePacket 
	{
		public var IconId:int;
		public var Num:int;
		public var PriceType:String;
		
		public function SendBuyIconND(_iconId:int, _num:int, _priceType:String = "ZMoney") 
		{
			ID = Constant.CMD_SEND_BUY_ICON_ND;
			URL = "EventService.buyIcon";
			IconId = _iconId;
			Num = _num;
			IsEvent = true;
			PriceType = _priceType;
			IsQueue = false;
		}
	}

}