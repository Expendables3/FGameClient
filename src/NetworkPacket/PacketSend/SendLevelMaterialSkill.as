package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendLevelMaterialSkill extends BasePacket
	{
		
		public function SendLevelMaterialSkill() 
		{
			ID = Constant.CMD_LEVEL_UP_SKILL_MATERIAL;
			URL = "CommonService.levelUpMaterialSkill";
			IsQueue = false;
		}
		
	}

}