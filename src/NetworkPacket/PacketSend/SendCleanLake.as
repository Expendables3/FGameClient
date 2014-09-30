package NetworkPacket.PacketSend 
{
	import flash.geom.Point;
	import Logic.Dirty;
	import Logic.GameLogic;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendCleanLake extends BasePacket
	{
		private var PosX:int;
		private var PosY:int;
		
		public var CleanTimes:int;
		public var LakeId:int;
		public var UserId:int;
		
		private var DirtyArr:Array = [];
		
		public function SendCleanLake(lakeID:int, userid:int) 
		{
			ID = Constant.CMD_CLEAN_LAKE;
			URL = "LakeService.cleanLake";
			LakeId = lakeID;
			UserId = userid;
			//CleanTimes = 1;
		}
		
		public function AddDirty(dirty:Dirty):void
		{
			CleanTimes++;
			DirtyArr.push(dirty);
			dirty.IsCleaning = true;
			PosX = dirty.CurPos.x;
			PosY = dirty.CurPos.y;
		}
		
		public function GetDirtyArr():Array
		{
			return DirtyArr;
		}
		
		public function GetPos():Point
		{
			var pos:Point = new Point(PosX, PosY);
			return pos;
		}
	}

}