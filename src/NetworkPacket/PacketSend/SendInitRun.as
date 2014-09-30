package NetworkPacket.PacketSend 
{
	//import flash.utils.describeType;
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendInitRun extends BasePacket
	{
		public var UserId:String = null;
		public var LakeId:int = 1;
		
		public function SendInitRun() 
		{
			ID = Constant.CMD_INIT_RUN;
			URL = "UserService.run";
			IsQueue = false;
			//var varList:XML = describeType(this);
		}		
	}

}