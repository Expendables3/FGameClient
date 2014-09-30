package GUI.SpecialSmithy 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendCancelOption extends BasePacket 
	{
		public var ItemId:int;
		public var ItemType:String;
		public function SendCancelOption() 
		{
			ID = Constant.CMD_CANCEL_OPTION;
			URL = "HammerManService.cancelOption";
			IsQueue = false;
		}
		
	}

}