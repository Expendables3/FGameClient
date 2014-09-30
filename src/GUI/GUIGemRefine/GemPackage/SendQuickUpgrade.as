package GUI.GUIGemRefine.GemPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendQuickUpgrade extends BasePacket 
	{
		public var GemId:int;
		public var isMoney:Boolean=true;
		
		public function SendQuickUpgrade(id:int,isMoney:Boolean) 
		{
			ID = Constant.CMD_QUICK_UPGRADE;
			URL = "MaterialService.quickUpgrade";
			GemId = id;
			IsQueue = false;
			this.isMoney = isMoney;
		}
		
	}

}