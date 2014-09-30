package Event.Tet2013.TetPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendRevertDay extends BasePacket 
	{
		public var DayIndex:int;
		public function SendRevertDay(dayIndex:int) 
		{
			URL = "KeepLoginService.restoreKeepLogin";
			ID = Constant.CMD_REVERT_DAY_GIFT;
			DayIndex = dayIndex;
			IsQueue = false;
		}
	}

}