package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author ...
	 */
	public class GetMixFish extends BaseReceivePacket
	{
		public var Error:int;
		public var Id:int;
		public var Name:String = "";
		public var Sex:int;
		public var FishTypeId:int;
		public var LakeId:int;
		public var Money:int;
		public var IsSuccess:Boolean;
		public var ColorLevel:int;
		
		public function GetMixFish(data:Object) 
		{
			super(data);			
		}
		
	}

}