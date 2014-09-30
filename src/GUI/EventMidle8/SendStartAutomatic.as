package GUI.EventMidle8 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendStartAutomatic extends BasePacket 
	{
		public var Type:int
		public function SendStartAutomatic(type:int) 
		{
			ID = Constant.CMD_PLAY_FAST;
			URL = "MoonService.autoPlay";
			Type = type;
			IsQueue = false;
		}
		
	}

}