package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendRemoveQuartzFromSoldier extends BasePacket 
	{
		public var SoldierId:int;
		public var SlotId:int;
		public var QuartzType:String = '';
		public var Id:int;
		
		public function SendRemoveQuartzFromSoldier() 
		{
			ID = Constant.CMD_REMOVE_QUARTZ_SOLDIER;
			URL = "SmashEggService.removeQuartzFromSoldier";
			IsQueue = false;
		}
		
	}

}