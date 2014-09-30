package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendAddQuartzToSoldier extends BasePacket 
	{
		public var SoldierId:int;
		public var QuartzType:String = '';
		public var Id:int;
		public var SlotId:int;
		
		public function SendAddQuartzToSoldier() 
		{
			ID = Constant.CMD_ADD_QUARTZ_TO_SOLDIER;
			URL = "SmashEggService.addQuartzToSoldier";
			IsQueue = true;
		}
		
	}

}