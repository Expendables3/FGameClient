package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendBuySpecialFish extends BasePacket 
	{
		public var ItemType:String; 	// Soldier, Sparta
		public var ItemId:int; 	  	  	 
		public var isMoney:Boolean;
		
		public function SendBuySpecialFish(type:String, id:int, ismoney:Boolean) 
		{
			ID = Constant.CMD_BUY_SPECIAL_FISH;
			URL = "FishService.buySpecialFish";
			ItemType = type;
			ItemId = id;
			isMoney = ismoney;
		}
	}

}