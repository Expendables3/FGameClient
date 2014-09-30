package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendStoreEquipment extends BasePacket 
	{
		public var EquipmentType:String;	// Armor, Helmet, Weapon…
		public var EquipmentId:int;			// auto Id của trang bị
		public var SoldierId:int;			// Id của cá lính
		public var LakeId:int;				// Id hồ chứa cá lính 
		
		public function SendStoreEquipment(et:String, eid:int, sid:int, lid:int) 
		{
			ID = Constant.CMD_STORE_EQUIPMENT;
			URL = "ItemService.storeEquipment";
			EquipmentType = et;
			EquipmentId = eid;
			SoldierId = sid;
			LakeId = lid;
			IsQueue = false;
		}
		
	}

}