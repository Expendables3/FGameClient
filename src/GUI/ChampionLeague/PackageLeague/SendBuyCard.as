package GUI.ChampionLeague.PackageLeague 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBuyCard extends BasePacket 
	{
		public var ItemType:String;
		public var ItemId:int;
		public var Num:int;
		public var PriceType:String;
		public function SendBuyCard() 
		{
			URL = "OccupyService.buyToken";
			ID = Constant.CMD_BUY_CARD;
			ItemType = "OccupyToken";
			ItemId = 1;
			Num = 1;
			PriceType = "ZMoney";
			IsQueue = false;
		}
		
	}

}