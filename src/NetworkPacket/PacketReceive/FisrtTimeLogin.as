package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author ...
	 */
	public class FisrtTimeLogin extends BaseReceivePacket 
	{
		public var Error:int;
		public var LastGetGiftTime:int;
		public function FisrtTimeLogin(data:Object) 
		{
			super(data);
			
		}
		
	}

}