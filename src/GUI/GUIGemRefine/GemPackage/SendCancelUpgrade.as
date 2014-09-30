package GUI.GUIGemRefine.GemPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendCancelUpgrade extends BasePacket 
	{
		public var GemId:int;
		public function SendCancelUpgrade(id:int) 
		{
			ID = Constant.CMD_CANCEL_UPGRADE;
			URL = "MaterialService.cancelUpgrade";
			IsQueue = false;
			GemId = id;	
		}
		
	}

}