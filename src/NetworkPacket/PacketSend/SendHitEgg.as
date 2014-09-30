package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendHitEgg extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		
		public function SendHitEgg() 
		{
			ID = Constant.CMD_HIT_EGG;
			URL = "FishService.hitEgg";			
		}
		
		public function AddNew(FishId:int, LakeId:int):void
		{
			this.FishId = FishId;
			this.LakeId = LakeId;
		}
		
	}

}