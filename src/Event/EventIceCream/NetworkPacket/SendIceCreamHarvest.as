package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamHarvest extends BasePacket 
	{
		public var SlotId:int;
		public function SendIceCreamHarvest(_SlotId:int) 
		{
			URL = "EventService.iceCream_Harvest";
			ID = Constant.CMD_ICE_CREAM_HARVEST_ICE_CREAM;
			SlotId = _SlotId;
			IsQueue = false;
		}
		
	}

}