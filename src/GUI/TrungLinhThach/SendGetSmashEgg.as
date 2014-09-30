package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendGetSmashEgg extends BasePacket 
	{
		public var FriendId:int;
		
		public function SendGetSmashEgg() 
		{
			ID = Constant.CMD_GET_SMASH_EGG;
			URL = "SmashEggService.getSmashEgg";
			IsQueue = false;
		}
		
	}

}