package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendSetGoGo extends BasePacket 
	{
		public var NumStep:int;
		//public var timeStamp:int;
		public function SendSetGoGo(numStep:int = 0, time_Stamp:int = 0) 
		{
			ID = Constant.CMD_GO_GO;
			URL = "MoonService.goGo";
			NumStep = numStep;
			IsQueue = false;
			timeStamp = time_Stamp;
		}
		
	}

}