package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendBuyDiscountHammer extends BasePacket 
	{
		
		public var Index:int;	//1-->6	
		public var HammerType:String;
		public var Num:int;
		
		public function SendBuyDiscountHammer() 
		{
			ID = Constant.CMD_BUY_DISCOUNT_HAMMER;
			URL = "SmashEggService.buyDiscountHammer";
			IsQueue = false;
		}
		
	}

}