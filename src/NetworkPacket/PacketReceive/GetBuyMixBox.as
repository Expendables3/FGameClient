package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author ...
	 */
	public class GetBuyMixBox extends BaseReceivePacket
	{
		public var Money:int;
		public var Exp:int;
		public var Error:int;
		
		public function GetBuyMixBox(data:Object) 
		{
			super(data);
			
		}
		
	}

}