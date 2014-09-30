package NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RunPacket extends BasePacket
	{
		public var UserID:int;
		public var LakeID:int;
		
		public function RunPacket() 
		{
			ID = "run";
		}
	}
}