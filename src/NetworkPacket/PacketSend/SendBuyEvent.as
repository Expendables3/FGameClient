package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author 
	 */
	public class SendBuyEvent extends BasePacket 
	{
		public var IconId:int;
		public var Num:int;
		public var PriceType:String;
		
		public function SendBuyEvent(id:int, num:int = 1, type:String = "ZMoney")
		{
			ID = Constant.CMD_BUY_EVENT;
			URL = "EventService.buyIcon";
			//IsQueue = false;
			
			this.IconId = id;
			this.Num = num;
			this.PriceType = type;
		}
		
	}

}