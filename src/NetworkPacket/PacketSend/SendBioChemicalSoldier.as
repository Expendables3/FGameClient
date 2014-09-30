package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendBioChemicalSoldier extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		
		public function SendBioChemicalSoldier(fId:int, lId:int) 
		{
			ID = Constant.CMD_BIOCHEMICAL_SOLDIER;
			URL = "FishService.beingBiochemical";
			FishId = fId;
			LakeId = lId;
			//IsQueue = false;
		}
	}

}