package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author longpt
	 */
	public class SendExtendEquipment extends BasePacket 
	{
		public var EquipmentType:String;	// Armor, Helmet, Weapon…
		public var EquipmentId:int;			// auto Id của trang bị
		public var SoldierId:int;			// Id của cá lính
		public var LakeId:int;				// Id hồ chứa cá lính 
		public var PriceType:String;			// Mua bằng tiền hay G
			
		public function SendExtendEquipment(et:String, eid:int, _priceType:String, sid:int, lid:int) 
		{
			ID = Constant.CMD_EXTEND_EQUIPMENT;
			URL = "ItemService.extendEquipment";
			EquipmentType = et;
			EquipmentId = eid;
			SoldierId = sid;
			LakeId = lid;
			PriceType = _priceType;
			IsQueue = false;
		}
		
	}

}