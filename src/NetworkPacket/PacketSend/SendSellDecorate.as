package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendSellDecorate extends BasePacket
	{
		public var DecoList:Array = [];
		public var LakeId:int;
		
		public function SendSellDecorate(lakeID:int) 
		{
			ID = Constant.CMD_SELL_DECORATE;
			URL = "ItemService.sellDeco";
			LakeId = lakeID;
		}
		
		public function AddNew(ID:int):void
		{
			var obj:Object = new Object();
			obj[ConfigJSON.KEY_ID] = ID;
			DecoList.push(obj);
		}
		
	}

}