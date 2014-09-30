package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendChangeSoliderName extends BasePacket 
	{
		public var SoldierId:int;
		public var NameSoldier:String;
		public var LakeId:int;
		
		public function SendChangeSoliderName(_lakeId:int, _soldierId:int, _soldierName:String) 
		{
			ID = Constant.CMD_SEND_CHANGE_SOLDIER_NAME;
			URL = "FishService.changeSoldierName";
			IsQueue = false;
			
			LakeId = _lakeId;
			SoldierId = _soldierId;
			NameSoldier = _soldierName;
		}
		
	}

}