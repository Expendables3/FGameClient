package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendDeleteEquipment extends BasePacket 
	{
		public var EquipmentType:String;	// Armor, Helmet, Weapon…
		public var EquipmentId:int;			// auto Id của trang bị
		
		public function SendDeleteEquipment(et:String, eid:int) 
		{
			ID = Constant.CMD_DELETE_EQUIPMENT;
			URL = "ItemService.deleteEquipment";
			EquipmentType = et;
			EquipmentId = eid;
			
		}
		
	}

}