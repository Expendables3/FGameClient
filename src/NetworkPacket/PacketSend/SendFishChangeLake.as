package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendFishChangeLake extends BasePacket
	{		
		public var FishId:int;
		public var FromLakeId:int;
		public var ToLakeId:int;
		
		public function SendFishChangeLake(fishId:int, fromLakeId:int, toLakeId:int)
		{
			ID = Constant.CMD_CHANGE_FISH;
			URL = "FishService.changeFish";
			FishId = fishId;
			FromLakeId = fromLakeId;
			ToLakeId = toLakeId;
		}
	}	

}