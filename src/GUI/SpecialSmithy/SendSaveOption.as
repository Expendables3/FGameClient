package GUI.SpecialSmithy 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendSaveOption extends BasePacket 
	{
		public var ItemId:int;
		public var ItemType:String;
		public function SendSaveOption() 
		{
			ID = Constant.CMD_SAVE_OPTION;
			URL = "HammerManService.saveOption";
			IsQueue = false;
		}
		
	}

}