package GUI.SpecialSmithy 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBreakEquipment extends BasePacket 
	{
		public var Input:Array;
		public function SendBreakEquipment() 
		{
			ID = Constant.CMD_BREAK_EQUIP;
			URL = "HammerManService.splitEquip";
			IsQueue = false;
		}
		
	}

}