package GUI.Password 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyPasswordFeature extends BasePacket 
	{
		public var Type:String;
		
		public function SendBuyPasswordFeature(_type:String) 
		{
			Type = _type;
			ID = Constant.CMD_BUY_PASSWORD_FEATURE;
			URL = "UserService.buyFeatureLock";
			IsQueue = false;
		}
		
	}

}