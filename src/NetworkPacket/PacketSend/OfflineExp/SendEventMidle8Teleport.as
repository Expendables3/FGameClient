package NetworkPacket.PacketSend.OfflineExp 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendEventMidle8Teleport extends BasePacket 
	{
		public var Postion:Object;
		//public var timeStamp:int;
		public function SendEventMidle8Teleport(y:int = 0, x:int = 0, time_Stamp:int = 0) 
		{
			ID = Constant.CMD_TELEPORT;
			URL = "MoonService.teleport";
			Postion = new Object();
			Postion.X = x;
			Postion.Y = y;
			timeStamp = time_Stamp;
		}
		
	}

}