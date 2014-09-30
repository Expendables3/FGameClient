package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author SieuSon
	 */
	public class SendDeleteGem extends BasePacket 
	{
		public var ListGem:Array = [];
		public function SendDeleteGem(list:Array) 
		{
			ID = Constant.CMD_DELETE_GEM;
			URL = "MaterialService.deleteGem";
			IsQueue = false;
			ListGem = list;
		}
		
	}

}