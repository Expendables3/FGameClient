package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendEnchantEquipment extends BasePacket 
	{
		
		public var EquipmentType:String;	// Armor...
		public var EquipmentId:int;
		public var isMoney:Boolean;
		public var ListMaterial:Array;
		public var UseGodCharm:Boolean;
		
		public function SendEnchantEquipment(eType:String, eId:int, iMoney:Boolean, list:Array, useGC:Boolean) 
		{
			ID = Constant.CMD_ENCHANT_EQUIPMENT;
			URL = "ItemService.enchantEquipment";
			EquipmentType = eType;
			EquipmentId = eId;
			isMoney = iMoney;
			ListMaterial = list;
			UseGodCharm = useGC;
			IsQueue = false;
		}
		
	}

}