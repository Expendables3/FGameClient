package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendUseEquipmentSoldier extends BasePacket 
	{
		public var EquipmentType:String;	// Armor, Helmet, Weapon…
		public var EquipmentId:int;			// auto Id của trang bị
		public var SoldierId:int;			// Id của cá lính
		public var LakeId:int;				// Id hồ chứa cá lính 
		
		public function SendUseEquipmentSoldier(et:String, eid:int, sid:int, lid:int) 
		{
			ID = Constant.CMD_USE_EQUIPMENT_SOLDIER;
			URL = "ItemService.useEquipmentSoldier";
			EquipmentType = et;
			EquipmentId = eid;
			SoldierId = sid;
			LakeId = lid;
			IsQueue = false;
		}
		
	}

}