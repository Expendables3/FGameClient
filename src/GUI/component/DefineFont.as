package GUI.component 
{
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class DefineFont 
	{
		//font Liên đấu
		private var S_CHAMPION_NO0:Number = 10.70;			//độ rộng từng số
		private var S_CHAMPION_NO1:Number = 7.25;
		private var S_CHAMPION_NO2:Number = 11.10;
		private var S_CHAMPION_NO3:Number = 10.95;
		private var S_CHAMPION_NO4:Number = 11.80;
		private var S_CHAMPION_NO5:Number = 11.10;
		private var S_CHAMPION_NO6:Number = 10.95;
		private var S_CHAMPION_NO7:Number = 10.75;
		private var S_CHAMPION_NO8:Number = 10.80;
		private var S_CHAMPION_NO9:Number = 10.95;
		private var S_CHAMPION_COMMA:Number = 4.4;
		
		private var D_CHAMPION_NO0:Number = 2.5;			//độ khoảng cách đằng sau từng số
		private var D_CHAMPION_NO1:Number = 2.5;
		private var D_CHAMPION_NO2:Number = 2.5;
		private var D_CHAMPION_NO3:Number = 2.5;
		private var D_CHAMPION_NO4:Number = 2.5;
		private var D_CHAMPION_NO5:Number = 2.5;
		private var D_CHAMPION_NO6:Number = 2.5;
		private var D_CHAMPION_NO7:Number = 2.5;
		private var D_CHAMPION_NO8:Number = 2.5;
		private var D_CHAMPION_NO9:Number = 2.5;
		private var D_CHAMPION_COMMA:Number = 1.5;
		
		private static var _instance:DefineFont = null;
		public static function getInstance():DefineFont {
			if (_instance == null) {
				_instance = new DefineFont();
			}
			return _instance;
		}
		public function DefineFont() 
		{
			
		}
		
		public function getWidth(name:String):Number 
		{
			return this["S_" + name];
		}
		public function getDistance(name:String):Number 
		{
			return this["D_" + name];
		}
		
	}

}