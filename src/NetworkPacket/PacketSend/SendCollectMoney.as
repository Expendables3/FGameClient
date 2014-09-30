package NetworkPacket.PacketSend 
{
	import Logic.Pocket;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendCollectMoney extends BasePacket 
	{
		public var FishList:Array = [];
		public var LakeId:int;
		public var FriendId:int;
		
		private var pocket:Pocket;
		public var isMagnet:Boolean = false;
		
		//public function SendCollectMoney(pocket:Pocket)
		//{
			//ID = Constant.CMD_COLLECT_MONEY;
			//URL = "FishService.collectMoney";
			//this.pocket = pocket;
		//}
		
		public function SendCollectMoney(lakeId:int, friendId:int)
		{
			ID = Constant.CMD_COLLECT_MONEY;
			URL = "FishService.collectMoney";	
			this.LakeId = lakeId;
			this.FriendId = friendId;
		}
		
		public function AddNew(fishId:int):void
		{
			FishList.push(fishId);
		}
		
		//public function GetPocket():Pocket
		//{
			//return this.pocket;
		//}
		
	}

}