package Event.EventNoel.NoelPacket 
{
	import GUI.GuiGetStatus.SendGetStatus;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendGotoSea extends SendGetStatus 
	{
		//public var MapId:int;
		//public var BoardId:int;
		public var IsPlayNow:Boolean = false;
		public function SendGotoSea(url:String, id:String, isPlayNow:Boolean/*, idMap:int, idBoard:int*/) 
		{
			super(url, id);
			//MapId = idMap;
			//BoardId = idBoard;
			IsPlayNow = isPlayNow;
			IsQueue = false;
		}
		
	}

}