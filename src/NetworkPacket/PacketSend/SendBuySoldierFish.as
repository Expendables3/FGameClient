package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendBuySoldierFish extends BasePacket 
	{
		public var RecipeType:String;
		public var RecipeId:int;
		public var isMoney:Boolean;
		
		public function SendBuySoldierFish(RType:String, RId:int, isM:Boolean) 
		{
			RecipeType = RType;
			RecipeId = RId;
			isMoney = isM;
			URL = "FishService.buySoldierFish";
			ID = Constant.CMD_SEND_BUY_SOLDIER;
			IsQueue = false;
		}
		
	}

}