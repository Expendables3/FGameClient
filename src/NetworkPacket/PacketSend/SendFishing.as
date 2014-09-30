package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author Le Ba Dung
	 */
	public class SendFishing extends BasePacket
	{
		public var LakeId:int;
		public var UserId:int;
		//public var Success:Boolean;
		
		//public function SendFishing(userid:int, lakeID:int, success:Boolean) 
		//{
			//ID = Constant.CMD_FISHING;
			//URL = "MiniGameService.fishing";
			//LakeId = lakeID;
			//UserId = userid;		
			//Success = success;
		//}		
		
		public function SendFishing(userid:int, lakeID:int) 
		{
			ID = Constant.CMD_FISHING;
			URL = "MiniGameService.fishing";
			LakeId = lakeID;
			UserId = userid;
			IsQueue = false;
		}		
	}

}