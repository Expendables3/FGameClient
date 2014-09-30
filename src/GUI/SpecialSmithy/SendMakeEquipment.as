package GUI.SpecialSmithy 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendMakeEquipment extends BasePacket 
	{
		public var PriceType:String = "Money";
		public var Target:Object;
		public var Num:int;
		public function SendMakeEquipment() 
		{
			ID = Constant.CMD_MAKE_EQUIP;
			URL = "HammerManService.makeEquip";
			IsQueue = false;
		}
		
	}

}