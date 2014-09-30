package NetworkPacket.PacketSend.ExtendDeco 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendExpiredDeco extends BasePacket 
	{
		public var ownerId:int;
		public var DecoList:Array;
		public var LakeId:int;
		public function SendExpiredDeco(_ownerId:int, _decoList:Array, _lakeId:int) 
		{
			ID = Constant.CMD_SEND_EXPIRED_DECO;
			URL = "ItemService.updateExpiredDeco";
			ownerId = _ownerId;
			DecoList = _decoList;
			LakeId = _lakeId;
		}
		
	}

}