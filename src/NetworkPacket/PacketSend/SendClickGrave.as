package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendClickGrave extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		
		public function SendClickGrave(lId:int, fId:int) 
		{
			ID = Constant.CMD_CLICK_GRAVE;
			URL = "FishService.clickGrave";
			LakeId = lId;
			FishId = fId;
		}
	}

}