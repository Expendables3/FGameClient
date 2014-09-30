package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetNextMap extends BasePacket 
	{
		public var isFirstLogin:Boolean;
		public var PriceType:String;
		public function SendGetNextMap(priceType:String, IsFirstLogin:Boolean = false) 
		{
			ID = Constant.CMD_NEXT_MAP;
			URL = "MoonService.nextMap";
			isFirstLogin = IsFirstLogin;
			PriceType = priceType;
			IsQueue = false;
		}
		
	}

}