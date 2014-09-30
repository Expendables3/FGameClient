package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendQuickUpgrade extends BasePacket 
	{
		public var GemId:int;
		public var NumLevel:int;
		public var isMoney:Boolean=true;
		
		public function SendQuickUpgrade(id:int,level:int,isMoney:Boolean) 
		{
			ID = Constant.CMD_QUICK_UPGRADE;
			URL = "MaterialService.quickUpgrade";
			GemId = id;
			NumLevel = level;
			IsQueue = false;
			this.isMoney = isMoney;
		}
		
	}

}