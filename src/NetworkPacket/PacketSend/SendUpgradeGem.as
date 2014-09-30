package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendUpgradeGem extends BasePacket 
	{
		public var Element:int;	// mã của ngọc cần ép
		public var ListGem:Array;	// mảng ngọc cần ép
		public var LevelDone:int; // Level ngọc ép ra
		public var SlotId:int;
					
		public function SendUpgradeGem(el:int,list:Array,level:int,slot:int) 
		{
			
			ID = Constant.CMD_UPGRADE_GEM;
			URL = "MaterialService.upgradeGem";
			IsQueue = false;
			Element = el;
			ListGem = list;
			LevelDone = level;
			SlotId = slot;
		}			
		
	}

}