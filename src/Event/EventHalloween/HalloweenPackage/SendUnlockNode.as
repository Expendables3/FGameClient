package Event.EventHalloween.HalloweenPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendUnlockNode extends BasePacket 
	{
		public var X:int;
		public var Y:int;
		
		public function SendUnlockNode(x:int, y:int) 
		{
			URL = "EventService.hal_stepAStep";
			//URL = "FakeEventService.unlockRock";
			ID = Constant.CMD_UNLOCK_ROCK;
			X = x;
			Y = y;
		}
		
	}

}