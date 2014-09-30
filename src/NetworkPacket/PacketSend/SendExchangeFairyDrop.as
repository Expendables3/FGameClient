package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Gửi lên khi hút cá
	 * @author HiepNM
	 */
	public class SendExchangeFairyDrop extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		//public var 
		public function SendExchangeFairyDrop(fId:int,lId:int) 
		{
			ID = Constant.CMD_EXCHANGEFAIRYDROP;
			URL = "FishService.exchangeFairyDrop";
			FishId = fId;
			LakeId = lId;
			IsQueue = false;
		}
		
	}

}