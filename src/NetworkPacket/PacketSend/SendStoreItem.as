package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendStoreItem extends BasePacket
	{
		public var ItemList:Array = [];
		public var LakeId:int;
		
		public function SendStoreItem() 
		{
			ID = Constant.CMD_STORE_ITEM;
			URL = "StoreService.store";
		}
		
		public function AddItem(id:int):void
		{
			ItemList.push(id);
		}
	}

}