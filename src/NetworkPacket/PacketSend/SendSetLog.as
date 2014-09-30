package NetworkPacket.PacketSend 
{
	import Logic.GameLogic;
	import Logic.LogInfo;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class SendSetLog extends BasePacket
	{
		public var FriendId:int;
		public var Time:int;
		public var Log:Array;
		
		public function SendSetLog() 
		{
			ID = Constant.CMD_SET_LOG;
			URL = "HistoryService.log";
		}
		
		public function SetData(log:LogInfo):void
		{
			FriendId = GameLogic.getInstance().user.Id;
			//if (FriendId == GameLogic.getInstance().user.GetMyInfo().Id)
			//{
				//trace(FriendId, GameLogic.getInstance().user.GetMyInfo().Id, log.UserId);
				//trace("Ghi nhầm log rùi");
			//}
			Time = log.LastTimeAct;
			Log = new Array;
			Log = log.ActNumArr.slice();
		}
	}

}