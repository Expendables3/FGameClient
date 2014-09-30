package Event.EventIceCream.NetworkPacket 
{
	import Logic.GameLogic;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamTheft extends BasePacket 
	{
		public var SlotId:int;
		public var FriendId:int;
		public function SendIceCreamTheft(_SlotId:int) 
		{
			URL = "EventService.iceCream_Theft";
			ID = Constant.CMD_ICE_CREAM_THEFT_ICE_CREAM;
			SlotId = _SlotId;
			FriendId = GameLogic.getInstance().user.Id;
			IsQueue = false;
		}
		
	}

}