package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendAnswerQuestion extends BasePacket 
	{
		public var AnswerId:int;
		public var isQuick:Boolean;
		//public var timeStamp:int;
		public function SendAnswerQuestion(answerId:int, IsQuick:Boolean, time_Stamp:int) 
		{
			ID = Constant.CMD_ANSWER_QUESTION;
			URL = "MoonService.answer";
			AnswerId = answerId;
			isQuick = IsQuick;
			IsQueue = false;
			timeStamp = time_Stamp;
		}
		
	}

}