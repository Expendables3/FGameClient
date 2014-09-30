package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendFireLantern extends BasePacket 
	{
		public var ItemType:String;
		public var ItemId:int;
		public var Num:int;
		public function SendFireLantern(itemType:String, itemId:int, num:int) 
		{
			ID = Constant.CMD_FIRE_LANTERN;
			URL = "EventService.moon_fireLantern";
			
			ItemType = itemType;
			ItemId = itemId;
			Num = num;
		}
		
	}

}































































