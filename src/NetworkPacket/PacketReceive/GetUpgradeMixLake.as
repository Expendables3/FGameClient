package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class GetUpgradeMixLake extends BaseReceivePacket 
	{
		public var LevelMixLake:int;
		public function GetUpgradeMixLake(data:Object) 
		{
			super(data);
		}
		
	}

}