package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendMoveDecorate extends BasePacket
	{
		public var DecoList:Array = [];
		public var LakeId:int;
		
		public function SendMoveDecorate(lakeID:int) 
		{
			ID = Constant.CMD_MOVE_DECORATE;
			URL = "ItemService.saveDeco";
			LakeId = lakeID;
		}
		
		public function AddNew(ID:int, ItemType:String, X:int, Y:int, Z:Number):void
		{
			var obj:Object = new Object();
			obj[ConfigJSON.KEY_ID] = ID;
			obj["x"] = X;
			obj["y"] = Y;
			obj["z"] = Z;
			obj["ItemType"] = ItemType;
			DecoList.push(obj);
		}
		
	}

}