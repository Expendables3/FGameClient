package GUI.EventEuro.Packet 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyBall extends BasePacket 
	{
		public var Num:int;
		public var ItemId:String;
		public var PriceType:String;
		
		public function SendBuyBall(_type:String, _num:int, _priceType:String) 
		{
			ID = Constant.CMD_BUY_EURO_BALL;
			URL = "EventService.euro_buyBall";
			ItemId = _type;
			Num = _num;
			PriceType = _priceType;
		}
		
	}

}