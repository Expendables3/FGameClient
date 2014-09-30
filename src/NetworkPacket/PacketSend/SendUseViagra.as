package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author hiepga
	 */
	public class SendUseViagra extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		
		public function SendUseViagra(fishId:int,lakeId:int) 
		{
			ID = Constant.CMD_USE_VIAGRA;
			URL = "FishService.useViagra";
			FishId = fishId;
			LakeId = lakeId;
		}
		
	}

}