package GUI.SpecialSmithy 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendMakeOption extends BasePacket 
	{
		public var ItemId:int;
		public var ItemType:String;
		public function SendMakeOption() 
		{
			ID = Constant.CMD_MAKE_OPTION;
			URL = "HammerManService.makeOption";
			IsQueue = false;
		}
		
	}

}