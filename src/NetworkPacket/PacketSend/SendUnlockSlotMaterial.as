package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author 
	 */
	public class SendUnlockSlotMaterial extends BasePacket 
	{
		public var PriceType:String;
		
		public function SendUnlockSlotMaterial(PriceType:String) 
		{
			ID = Constant.CMD_UNLOCK_SLOT_MATERIAL;
			URL = "FishService.unlockSlotMate";
			
			this.PriceType = PriceType;
		}		
	}

}