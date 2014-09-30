package GUI.SpecialSmithy 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetHammerMan extends BasePacket 
	{
		
		public function SendGetHammerMan() 
		{
			ID = Constant.CMD_GET_HAMMERMAN;
			URL = "HammerManService.getHammerMan";
			IsQueue = false;
		}
		
	}

}