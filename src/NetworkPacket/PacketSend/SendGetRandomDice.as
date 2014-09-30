package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetRandomDice extends BasePacket 
	{
		public var isTwoDice :Boolean;
		public var ArrowId :int;	//	trên dưới trái phải
		public var m:int;
		public var n:int;
		//public var timeStamp:int;
		public function SendGetRandomDice(IsTwoDice:Boolean = false, M:int = 1, N:int = 1, arrowId:int = 1, time_Stamp:int = 0) 
		{
			ID = Constant.CMD_RANDOM_DICE;
			URL = "MoonService.randomDice";
			isTwoDice = IsTwoDice;
			m = M;
			n = N;
			ArrowId = arrowId;
			IsQueue = false;
			timeStamp = time_Stamp;
		}
	}

}