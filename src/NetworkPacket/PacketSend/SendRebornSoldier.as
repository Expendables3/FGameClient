package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendRebornSoldier extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		public var GinsengId:int;
		public var isGrave:Boolean;
		
		public function SendRebornSoldier(fId:int, lId:int, gId:int, isG:Boolean = false) 
		{
			ID = Constant.CMD_REBORN_SOLDIER;
			URL = "FishService.rebornSoldier";
			FishId = fId;
			LakeId = lId;
			GinsengId = gId;
			isGrave = isG;
			//IsQueue = false;
		}
	}

}