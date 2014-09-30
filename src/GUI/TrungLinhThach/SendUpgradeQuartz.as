package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendUpgradeQuartz extends BasePacket 
	{
		public var SoldierId:int;
		public var QuartzType:String;
		public var Id:int;
		public var Quartzs:Array;
		
		public function SendUpgradeQuartz() 
		{
			ID = Constant.CMD_UPGRADE_QUARTZ_SOLDIER;
			URL = "SmashEggService.upgradeQuartz";
			IsQueue = false;
		}
		
	}

}