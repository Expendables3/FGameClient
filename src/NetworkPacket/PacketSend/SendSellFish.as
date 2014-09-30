package NetworkPacket.PacketSend 
{
	import Logic.Fish;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendSellFish extends BasePacket
	{
		public var FishList:Array = [];
		public var LakeId:int;
		
		
		public function SendSellFish(lakeID:int) 
		{
			ID = Constant.CMD_SELL_FISH;
			URL = "FishService.sell";			
			LakeId = lakeID;
		}
		
		public function AddNew(fish:Fish):void
		{
			FishList.push(fish.Id);
		}
		
	}

}