package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendUnlockSea extends BasePacket 
	{
		public var SeaId:int;
		public var PriceType:String;
		/**
		 * 
		 * @param	seaId		:	Id của biển
		 * @param	priceType	:	Loại tiền "Money", "ZMoney"
		 */
		public function SendUnlockSea(seaId:int, priceType:String = "") 
		{
			ID = Constant.CMD_UNLOCK_OCEAN_SEA;
			URL = "FishWorldService.unlockSea";
			SeaId = seaId;
			PriceType = priceType;
			IsQueue = false;
		}
		
	}

}