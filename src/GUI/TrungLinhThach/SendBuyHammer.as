package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendBuyHammer extends BasePacket 
	{
		public var HammerType:String = '';
		public var HammerId:int;
		public var Num:int;
		
		public function SendBuyHammer() 
		{
			ID = Constant.CMD_BUY_HAMMER;
			URL = "SmashEggService.buyHammer";
			IsQueue = false;
		}
		
	}

}