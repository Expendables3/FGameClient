package GUI.EventEuro.Packet 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendPrediction extends BasePacket 
	{
		public var MatchId:int;
		public var BallNum:int;
		public var BetType:String;
		public var Bet:int;
		
		public function SendPrediction(_matchId:int, _numBall:int, _typeBall:String, _prediction:int) 
		{
			ID = Constant.CMD_SEND_PREDICTION;
			URL = "EventService.euro_betMatch";
			MatchId = _matchId;
			BallNum = _numBall;
			BetType = _typeBall;
			Bet = _prediction;
		}
		
	}

}