package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendUseRankPointBottle extends BasePacket 
	{
		public var LakeId:int;
		public var SoldierId:int;
		public var ItemId:int;
		public var Num:int;
		
		public function SendUseRankPointBottle(_lakeId:int, _soldierId:int, _itemId:int, _num:int) 
		{
			URL = "StoreService.useRankPointBottle";
			ID = Constant.CMD_SEND_USE_RANK_POINT_BOTTLE;
			LakeId = _lakeId;
			SoldierId = _soldierId;
			ItemId = _itemId;
			Num = _num;
			IsQueue = false;
		};
		
	}

}