package GUI.GUIGemRefine.GemPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendRecoverGem extends BasePacket 
	{
		public var ListGem:Array;
		public function SendRecoverGem(list:Array) 
		{
				
			ID = Constant.CMD_RECOVER_GEM;
			URL = "MaterialService.recoverGem";
			IsQueue = false;
			ListGem = list;		
		}
		
	}

}