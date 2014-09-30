package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author 
	 */
	public class SendUpgradeSkill extends BasePacket 
	{
		public var Skill:String;
		public function SendUpgradeSkill(skillName:String)
		{
			ID = Constant.CMD_UPGRADE_SKILL;
			URL = "CommonService.upgradeSkill";
			IsQueue = false;
			
			this.Skill = skillName;
		}
		
	}

}