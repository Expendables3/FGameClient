package NetworkPacket.PacketSend 
{
	import adobe.utils.CustomActions;
	import Logic.Pocket;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendStealMoney extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		public var FriendId:int;
		
		private var pocket:Pocket;
		
		public function SendStealMoney(pocket:Pocket) 
		{
			ID = Constant.CMD_STEAL_MONEY;
			URL = "FishService.stealMoney";
			this.pocket = pocket;
		}
		
		public function AddNew(fishId:int, lakeId:int, friendId:int):void
		{
			this.FishId = fishId;
			this.LakeId = lakeId;
			this.FriendId = friendId;
		}
		
		public function GetPocket():Pocket
		{
			return this.pocket;
		}
	}

}