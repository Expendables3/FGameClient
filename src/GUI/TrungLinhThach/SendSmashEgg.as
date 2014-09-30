package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendSmashEgg extends BasePacket 
	{
		public var EggType:String = '';
		public var Num:int;
		
		public function SendSmashEgg() 
		{
			ID = Constant.CMD_SMASH_EGG;
			URL = "SmashEggService.smashEgg";
			IsQueue = false;
		}
		
	}

}