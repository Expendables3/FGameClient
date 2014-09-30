package GUI.GUIGemRefine.GemLogic 
{
	import Data.ConfigJSON;
	import Logic.GameLogic;
	/**
	 * Lớp logic cho viên đan ở khu luyện
	 * @author HiepNM2
	 */
	public class UpgradingGem 
	{
		private var _slotId:		int;			//id của slot đang luyện
		private var _element:		int;			//hệ
		private var _levelDone:		int;			//level tiếp theo sau khi luyện xong
		private var _listGemSource:	Array;			//danh sách những đan nguồn đưa vào để luyện ra đan này
		private var _timeRefine:	Number;			//thời gian luyện
		private var _startTime:		Number;			//thời gian bắt đầu luyện
		private var _dayExpired:	int;			//thời gian tồn tại sau khi luyện xong
		public var JustRefined:		Boolean;		//vừa luyện xong
		public function get SlotId():int
		{
			return _slotId;
		}
		public function set SlotId(value:int):void
		{
			_slotId = value;
		}
		public function get Element():int
		{
			return _element;
		}
		public function get LevelDone():int
		{
			return _levelDone;
		}
		public function get ListGemSource():Array
		{
			return _listGemSource;
		}
		public function get TimeRefine():Number
		{
			return _timeRefine;
		}
		public function set TimeRefine(val:Number):void
		{
			_timeRefine = val;
		}
		public function get StartTimeRefine():Number
		{
			return _startTime;
		}
		public function set StartTimeRefine(val:Number):void
		{
			_startTime = val;
		}
		public function get DayExpired():int
		{
			return _dayExpired;
		}
		
		public function get Level():int
		{
			return _levelDone - 1;
		}
		
		public function get IsWaitingPress():Boolean
		{
			return (StartTimeRefine < 0);
		}
		
		public function equal(uGem:UpgradingGem):Boolean
		{
			if (_slotId == uGem.SlotId)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		/**
		 * return -1: chua luyen, 0: dang luyen, 1: da luyen xong
		 */
		public function get StepRefine():int
		{
			//if (TimeRefine < 0)
			//{
				//return -2;
			//}
			if (IsWaitingPress)
			{
				return -1;
			}
			else
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				var remainTime:Number = curTime - StartTimeRefine;
				var timeWait:Number = TimeRefine - remainTime;
				if (timeWait > 0)
				{
					return 0;
				}
				else
				{
					return 1;
				}
			}
		}

		public function UpgradingGem(slotId:int, element:int, levelDone:int, listGemSrc:Array, timeRefine:Number, startTime:Number, dayExpired:int) 
		{
			_slotId = slotId;
			_element = element;
			_levelDone = levelDone;
			_listGemSource = listGemSrc;
			_timeRefine = timeRefine;
			_startTime = startTime;
			_dayExpired = dayExpired;
		}
		
		public function pushToListGem(element:int, level:int, dayLife:int, num:int = 1):void
		{
			var gem:Gem = new Gem(element, level, dayLife, num);
			_listGemSource.push(gem);
		}
		
		/**
		 * thực hiện lên cấp cho viên đan
		 */
		public function levelUp():void
		{
			_levelDone++;
			_startTime = -1;
			_timeRefine = ConfigJSON.getInstance().getItemInfo("Gem")[Level]["TimeUpgrade"];
			_dayExpired = findMinDay(_listGemSource);
			var gem:Gem = new Gem(_element, Level, DayExpired, 1);
			_listGemSource.splice(0, _listGemSource.length);		//đổ hết mảng gem trước đó
			_listGemSource.push(gem);
		}
		
		/**
		 * tìm ngày tồn tại nhỏ nhất trong mảng đan
		 * @param	lstGemSource: mảng đan
		 * @return : ngày nhỏ nhất
		 */
		private function findMinDay(lstGemSource:Array):int
		{
			var i:int, minDay:int = 9999;
			for (i = 0; i < lstGemSource.length; i++)
			{
				var gem:Gem = lstGemSource[i] as Gem;
				if (minDay > gem.DayLife)
				{
					minDay = gem.DayLife;
				}
			}
			return minDay;
		}
		
		public function clone():UpgradingGem
		{
			return new UpgradingGem(_slotId, _element, _levelDone, _listGemSource, _timeRefine, _startTime, _dayExpired);
		}
	}

}