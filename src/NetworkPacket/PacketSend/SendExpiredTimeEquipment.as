package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendExpiredTimeEquipment extends BasePacket 
	{
		public var UserId:String = null;
		public var LakeId:int;
		public var SoldierId:int;
		public var ItemType:String;
		public var Id:int;

		public function SendExpiredTimeEquipment(uId:String, type:String, id:int, lId:int = 0, sId:int = 0) 
		{
			UserId = uId;
			ItemType = type;
			Id = id;
			LakeId = lId;
			SoldierId = sId;
			
			ID = Constant.CMD_UPDATE_EXPIRED_TIME_OF_EQUIPMENT;
			URL = "ItemService.updateExpiredTimeOfEquipment";
			
			//IsQueue = false;
		}
		
	}

}