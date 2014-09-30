package NetworkPacket.PacketSend.CreateEquipment 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendSeparateEquip extends BasePacket 
	{
		public var EquipList:Array;
		
		public function SendSeparateEquip(_equipList:Array) 
		{
			ID = Constant.CMD_SEND_SEPARATE_EQUIP;
			URL = "CraftEquipService.refineIngredient";
			EquipList = _equipList;
			IsQueue = false;
		}
		
	}

}