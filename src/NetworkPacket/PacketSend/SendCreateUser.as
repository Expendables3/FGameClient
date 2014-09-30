package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendCreateUser extends BasePacket
	{
		public var AvatarType:int;
		public function SendCreateUser(idAvatar:int) 
		{
			ID = Constant.CMD_CREATE_USER;
			URL = "UserService.create";
			AvatarType = idAvatar;
			IsQueue = false;
		}
		
	}

}