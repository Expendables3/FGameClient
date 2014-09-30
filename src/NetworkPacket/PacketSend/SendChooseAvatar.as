package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author Quangvh
	 */
	public class SendChooseAvatar  extends BasePacket
	{
		public var AvatarType:int;
		public function SendChooseAvatar(idAvatar:int) 
		{
			ID = Constant.CMD_CHOOSE_AVATAR;
			URL = "UserService.chooseAvatar";
			AvatarType = idAvatar;
			IsQueue = false;
		}
		
	}

}