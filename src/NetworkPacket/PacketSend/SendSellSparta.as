package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendSellSparta extends BasePacket
	{
		public var ItemType:String = "";
		public var Id:int;
		public var LakeId:int;
		
		public function SendSellSparta(lakeId:int, id:int, itemType:String) 
		{
			ID = Constant.CMD_SELL_SPARTA;
			URL = "ItemService.sellSpecialItem";
			ItemType = itemType;
			Id = id;
			LakeId = lakeId;
		}
		
	}

}