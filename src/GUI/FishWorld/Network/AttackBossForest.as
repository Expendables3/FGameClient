package GUI.FishWorld.Network 
{
	import adobe.utils.CustomActions;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AttackBossForest extends BasePacket 
	{
		public var SeaId:int;
		public var IdMonster:int;
		public function AttackBossForest(obj:Object) 
		{
			ID = Constant.CMD_ATTACK_BOSS_FOREST;
			URL = "FishWorldService.acttackBossForest";
			SeaId = obj.SeaId;
			IdMonster = obj.IdMonster;
			IsQueue = false;
		}
	}
}