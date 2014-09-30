package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendUseGem extends BasePacket 
	{
		public var LakeId:int; 
		public var FishId:int;
		public var UserId:int;
		public var ListGem:Array;
		
		public function SendUseGem(LId:int, FId:int, UId:int) 
		{
			ID = Constant.CMD_USE_GEM;
			URL = "MaterialService.useGem";
			IsQueue = false;
			
			LakeId = LId;
			FishId = FId;
			UserId = UId;
		}
		
		public function SetListGem(e:int, id:int, day:int, num:int = 1):void
		{
			ListGem = [];
			var o:Object = new Object();
			o.Element = e;
			o.GemId = id;
			o.Day = day;
			o.Num = num;
			ListGem.push(o);
		}
		
	}

}