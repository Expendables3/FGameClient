package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendJoinSeaAgain extends BasePacket 
	{
		public var SeaId:int;
		public var PriceType:String;
		public static var isSendPacket:Boolean = false;
		
		public function SendJoinSeaAgain(seaId:int, priceType:String) 
		{
			ID = Constant.CMD_JOIN_SEA_AGAIN;
			URL = "FishWorldService.joinSeaAgain";
			SeaId = seaId;
			PriceType = priceType;
			IsQueue = false;
		}
		
	}

}