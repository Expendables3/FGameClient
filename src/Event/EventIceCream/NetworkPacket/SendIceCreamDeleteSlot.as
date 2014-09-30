package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamDeleteSlot extends BasePacket 
	{
		public var SlotId:int;
		public function SendIceCreamDeleteSlot(_SlotId:int) 
		{
			ID = Constant.CMD_ICE_CREAM_DELETE_SLOT;
			URL = "EventService.iceCream_Delete";
			SlotId = _SlotId;
		}
	}

}