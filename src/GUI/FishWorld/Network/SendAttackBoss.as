package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendAttackBoss extends BasePacket 
	{
		public var SeaId:int;
		public var IdMonster:int;
		public function SendAttackBoss(seaID:int, idBoss:int = 1) 
		{
			ID = Constant.CMD_ATTACK_BOSS_OCEAN_SEA;
			URL = "FishWorldService.acttackBoss";
			SeaId = seaID;
			IdMonster = idBoss;
			IsQueue = false;
		}
	}

}