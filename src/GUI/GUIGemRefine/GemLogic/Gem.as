package GUI.GUIGemRefine.GemLogic 
{
	/**
	 * Lớp logic cho viên đan ở khu đan
	 * @author HiepNM2
	 */
	public class Gem 
	{
		private var _dayLife:int;				//thời gian sống
		private var _element:int;				//hệ
		private var _level:int;					//cấp
		//private var _timeToRefine:Number;		//thời gian luyện
		private var _num:int;					//số lượng
		
		public function get Element():int
		{
			return _element;
		}
		public function get Level():int
		{
			return _level;
		}
		public function get Num():int
		{
			return _num;
		}
		public function set Num(value:int):void
		{
			_num = value;
		}
		public function get DayLife():int
		{
			return _dayLife;
		}
		public function set DayLife(value:int):void
		{
			_dayLife = value;
		}
		/*xét đan đã bị phế hay chưa */
		public function get IsExpired():Boolean
		{
			return (_dayLife <= 0);
		}
		
		
		public function equal(gem:Gem):Boolean
		{
			if (_element == gem.Element && _level == gem.Level && _dayLife == gem.DayLife && _num == gem.Num)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function Gem(element:int, level:int, dayLife:int,num:int) 
		{
			_element = element;
			_level = level;
			_dayLife = dayLife;
			_num = num;
		}
		public function clone():Gem
		{
			return new Gem(_element, _level, _dayLife, _num);
		}
		
	}

}