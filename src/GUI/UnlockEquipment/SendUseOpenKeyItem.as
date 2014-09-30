package GUI.UnlockEquipment 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendUseOpenKeyItem extends BasePacket 
	{
		public var Type:String;
		public var Id:int;
		public function SendUseOpenKeyItem(_Type:String, _Id:int) 
		{
			ID = Constant.CMD_USE_OPEN_KEY;
			URL = "ItemService.useOpenKeyItem";
			Type = _Type;
			Id = _Id;
		}
	}

}