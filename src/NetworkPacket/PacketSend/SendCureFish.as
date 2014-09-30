package NetworkPacket.PacketSend 
{
	import flash.geom.Point;
	import Logic.Fish;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendCureFish extends BasePacket
	{
		public var FishList:Array = new Array;
		public var LakeId:int;
		public var UserId:int
		
		private var PosX:int;
		private var PosY:int;
		
		private var FishArr:Array = new Array;
		
		public function SendCureFish(lakeID:int, uID:int) 
		{
			ID = Constant.CMD_CURE_FISH;
			URL = "FishService.cure";			
			LakeId = lakeID;
			UserId = uID;			
		}
	
		public function AddNew(fish:Fish):void
		{
			FishList.push(fish.Id);
			FishArr.push(fish);
		}	
		
		
		public function GetFishArr():Array
		{
			return FishArr;
		}
		
		public function GetPos():Point
		{
			var pos:Point = new Point(PosX, PosY);
			return pos;
		}
	}

}