package NetworkPacket.PacketSend 
{
	import Logic.Fish;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendCareFish extends BasePacket
	{
		public var FishList:Array = new Array; 
		public var UserId:int;
		public var LakeId:int;
		
		private var FishArr:Array = new Array;
		
		public function SendCareFish(lakeID:int, friendId:int) 
		{
			ID = Constant.CMD_CARE_FISH;
			URL = "FishService.careFriendFish";	
			UserId = friendId;
			LakeId = lakeID;
		}
		
		public function AddNew(fish:Fish):void
		{
			FishList.push(fish.Id);
			FishArr.push(fish);
		}	
		
		
		public function GetFishArr():Array
		{
			return FishArr;
		}	
	}

}