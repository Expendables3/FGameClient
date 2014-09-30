package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamUnlockSlot extends BasePacket 
	{
		public var SlotId:int;
		public function SendIceCreamUnlockSlot(slotId:int) 
		{
			ID = Constant.CMD_ICE_CREAM_UNLOCK_SLOT;
			URL = "EventService.iceCream_UnlockSlot";
			SlotId = slotId;
		}
	}

}