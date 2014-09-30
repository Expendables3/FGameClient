package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendUseItem extends BasePacket
	{
		public var ItemList:Array = [];
		public var LakeId:int;
		
		public function SendUseItem(lakeID:int) 
		{
			ID = Constant.CMD_USE_ITEM;
			URL = "StoreService.useItem";
			LakeId = lakeID;
		}
		
		public function AddNew(ID:int, itemID:int, itemType:String, X:int, Y:int, Z:int, name:String = null):void
		{
			var obj:Object = new Object();
			obj[ConfigJSON.KEY_ID] = ID;
			obj["ItemId"] = itemID;
			obj["ItemType"] = itemType;
			obj["x"] = X;
			obj["y"] = Y;
			obj["z"] = Z;
			//obj[ConfigJSON.KEY_NAME] = name;

			ItemList.push(obj);
		}
		
	}

}