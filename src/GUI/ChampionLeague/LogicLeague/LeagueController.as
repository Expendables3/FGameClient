package GUI.ChampionLeague.LogicLeague 
{
	import Data.ConfigJSON;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.Ultility;
	/**
	 * Lớp điều hành ngữ cảnh của Liên đấu
	 * 		lưu các dữ liệu cần thiết
	 * @author HiepNM2
	 */
	public class LeagueController 
	{
		static public const TIME_REFRESH:int = 9;
		static public const IN_HOME:int = 0;
		static public const IN_LEAGUE:int = 1;
		static public const DELETE:int = 0;				//khóa delete, thực hiện xóa hết tất cả GUI + Logic khi vào liên đấu
		static public const INVISIBLE:int = 1;			//khóa invisible, thực hiện ẩn tất cả GUI khi vào liên đấu
		private static var _instance:LeagueController = null;
		private var _mode:int;
		public var IsBuying:Boolean;		//đang trong quá trình mua
		public var destructFish:Boolean = false;
		private var _key:int;
		public var isRefreshingFriend:Boolean = false;
		public var isWaitReponseGift:Boolean = false;
		public var timeRefresh:Number = -1;
		public var homeBgId:int = 1;
		public var hasUpdateBtnLeague:Boolean = false;
		public function LeagueController() 
		{
			//_mode = NOT_IN_LEAGUE;
		}
		static public function getInstance():LeagueController {
			if (_instance == null) {
				_instance = new LeagueController();
			}
			return _instance;
		}
		
		public function changeState(mode:int):void 
		{
			_mode = mode;
			GameLogic.getInstance().BackToIdleGameState();
			if (mode == IN_LEAGUE) {
				GameLogic.getInstance().gameMode = GameMode.GAMEMODE_WAR;
			}
			else {
				GameLogic.getInstance().gameMode = GameMode.GAMEMODE_NORMAL;
			}
			GameInput.getInstance().lastAttackTime = 0;
		}
		
		public function get mode():int 
		{
			return _mode;
		}
		
		public function set mode(value:int):void 
		{
			_mode = value;
		}
		
		/**
		 * lấy cách vào và thoát khỏi liên đấu
		 */
		public function get key():int 
		{
			return _key;
		}
		/**
		 * chọn cách vào vào thoát khỏi liên đấu
		 */
		public function set key(value:int):void 
		{
			_key = value;
		}
		/**
		 * Chuyển 1 thời điểm trong ngày sang unix Time
		 * @param	curTime : thời điểm hiện tại
		 * @param	sTime : thời điểm trong ngày có dạng "hh:mm:ss"
		 * @param	isCountForNextDay : tính ra thời điểm của ngày hôm sau hay không?
		 * @return : giá trị unixTime cho thời điểm của ngày (hôm nay hoặc hôm sau)
		 */
		static public function convertToUnixTime(curTime:Number, sTime:String, isCountForNextDay:Boolean):Number
		{
			var data:Array = sTime.split(":");
			var h:int = int(data[0]);
			var m:int = int(data[1]);
			var s:int = int(data[2]);
			var second:int = h * 3600 + m * 60 + s - 7*3600;
			var secondNow:int = curTime % 86400;
			var GMT:Number = 0;
			//đưa về mốc 07:00:00 Vietnam => 0:0:0 English
			if (isCountForNextDay)
			{
				GMT = curTime - secondNow + 86400;
			}
			else 
			{
				GMT = curTime - secondNow;
			}
			return GMT + second;
		}
		
		/**
		 * xác định thời điểm hiện tại đã vượt quá thời điểm mốc chưa
		 * @param	curTime : thời điểm hiện tại
		 * @param	sTime : thời điểm mốc
		 * @return vượt quá => false, chưa vượt => true
		 */
		static public function isInDay(curTime:Number, sTime:String):Boolean
		{
			var data:Array = sTime.split(":");
			var h:int = int(data[0]);
			var m:int = int(data[1]);
			var s:int = int(data[2]);
			var second:int = h * 3600 + m * 60 + s - 7*3600;
			var secondNow:int = curTime % 86400;
			if (secondNow <= second)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		static public function rankText(rank:int):String
		{
			if (rank >= 1 && rank <= 1000)
			{
				return Ultility.StandardNumber(rank);
			}
			else if (rank == 0) {
				return "0";
			}
			else {
				return ">1000";
			}
		}
		
		public static function IsActive():Boolean
		{
			var active:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["Active"];
			return (active == 1);
		}
	}

}





















