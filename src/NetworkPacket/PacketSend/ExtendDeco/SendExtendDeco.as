package NetworkPacket.PacketSend.ExtendDeco 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendExtendDeco extends BasePacket 
	{
		public var DecoList:Array;
		
		public function SendExtendDeco() 
		{
			ID = Constant.CMD_SEND_EXTEND_DECO;
			URL = "ItemService.extensionDeco";
			DecoList = [];
		}
		
		public function addItem(_itemType:String, _id:int, _lakeId:int):void
		{
			var obj:Object = new Object();
			obj["ItemType"] = _itemType;
			obj["Id"] = _id;
			obj["LakeId"] = _lakeId;
			DecoList.push(obj);
		}
	}

}