package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendRecoverGem extends BasePacket 
	{
		public var ListGem:Array;
		public var idPearl:int;
		
		public function SendRecoverGem(list:Array,id:int) 
		{
				
			ID = Constant.CMD_RECOVER_GEM;
			URL = "MaterialService.recoverGem";
			IsQueue = false;
			ListGem = list;		
			idPearl = id;
		}
		
	}

}