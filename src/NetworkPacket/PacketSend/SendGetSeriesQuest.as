package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendGetSeriesQuest extends BasePacket
	{
		private var _IsInitRun:Boolean = false;
		private var _IdSeriQuest:int;
		
		public function SendGetSeriesQuest() 
		{
			ID = Constant.CMD_GET_SERIES_QUEST;
			URL = "QuestService.getSeriesQuest";
			_IsInitRun = true;
			_IdSeriQuest = 0;
			IsQueue = false;
		}
		
		public function set IsInitRun(isInitRun:Boolean):void
		{
			_IsInitRun = isInitRun;
		}
		
		public function get IsInitRun():Boolean
		{
			return _IsInitRun;
		}		
		
		public function set IdSeriQuest(idSeri:int):void
		{
			_IdSeriQuest = idSeri;
		}
		
		public function get IdSeriQuest():int
		{
			return _IdSeriQuest;
		}
	}

}