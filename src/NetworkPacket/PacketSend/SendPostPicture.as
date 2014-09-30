package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendPostPicture extends BasePacket
	{
		
		public function SendPostPicture() 
		{
			ID = Constant.CMD_SNAPSHOT;
			URL = "PictureService.takePicture";
			IsQueue = false;
		}
		
	}

}