package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 * 
	 */
	public class SendMixRequest extends BasePacket
	{
		public var FishList:Array = [];
		public var MixLakeId:int;
		public var LakeId:int;
		
		public function SendMixRequest(lake:int, MixLakeId:int) 
		{
			ID = Constant.CMD_MIX_FISH;
			URL = "FishService.mate";
			LakeId = lake;
			this.MixLakeId = MixLakeId;
			IsQueue = false;
		}
		
		public function AddNew(id:int):void
		{
			FishList.push(id);
		}
		
	}

}