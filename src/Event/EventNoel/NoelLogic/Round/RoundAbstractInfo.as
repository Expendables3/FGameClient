package Event.EventNoel.NoelLogic.Round 
{
	import Data.ConfigJSON;
	import Logic.GameLogic;
	/**
	 * Thể hiện từng bàn chơi
	 * @author HiepNM2
	 */
	public class RoundAbstractInfo 
	{
		protected const ROUND_MAX:int = 5;
		protected var _idRound:int;			//số thứ tự của round
		protected var _startTime:Number;	//thời điểm vào round
		protected var _num:int;				//số lượng item đã đạt được
		
		public function RoundAbstractInfo() 
		{
			
		}
		public function set IdRound(val:int):void { _idRound = val; }
		public function get IdRound():int { return _idRound; }
		public function set StartTime(val:Number):void { _startTime = val; }
		public function get StartTime():Number { return _startTime; }
		
		public static function createRound(type:String):RoundAbstractInfo
		{
			switch(type)
			{
				case "Noel":
					return new RoundNoel();
			}
			return new RoundAbstractInfo();
		}
		public virtual function updateNum(dNum:int):void
		{
			_num += dNum;
		}
		
		public virtual function roundUp():Boolean { return false; }		//qua bài?
		public virtual function isFinish():Boolean { return false; }	//hoàn thành?
		public virtual function isFail():Boolean { return false; }		//thua?
		public virtual function getNumRequired():int { return 0; }		//số lượng item cần đạt để finish Round
		public virtual function getMainData():Object { return null; }	//get dữ liệu chính của bài toán
		public virtual function getTimeRound():Number { return 0; }		//thời gian đi round
	}

}
















