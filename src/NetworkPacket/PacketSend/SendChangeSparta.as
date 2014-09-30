package NetworkPacket.PacketSend 
{
	import Logic.BaseObject;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendChangeSparta extends BasePacket
	{
		public var LakeFromId:int;
		public var LakeToId:int;
		public var Id:int;
		public var ItemType:String
		
		public function SendChangeSparta(id:int, lakeFromId:int, lakeToId:int, itemType:String) 
		{
			ID = Constant.CMD_SELL_CHANGE_LAKE;
			URL = "ItemService.changeSparta";
			LakeFromId = lakeFromId;
			LakeToId = lakeToId;
			ItemType = itemType;
			Id = id;
		}
		
	}

}