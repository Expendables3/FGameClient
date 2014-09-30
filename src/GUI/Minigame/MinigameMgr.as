package GUI.Minigame 
{
	import Data.ConfigJSON;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class MinigameMgr 
	{
		// const
		static public const CURRENT_MINIGAME:String = "LuckyMachine";
		private var _config:Object;
		
		// var
		static private var _instance:MinigameMgr = null;
		
		
		static public function getInstance():MinigameMgr 
		{
			if (_instance == null) {
				_instance = new MinigameMgr();
			}
			return _instance;
		}
		
		public function initData(name:String = CURRENT_MINIGAME):void
		{
			var param:Object = ConfigJSON.getInstance().getItemInfo("Param");
			if (param["MiniGame"])
			{
				_config = param["MiniGame"][name];
			}
		}
		
		public function MinigameMgr() 
		{
			
		}
		
		/**
		 * check xem có tồn tại minigame không
		 * @return : true nếu có minigame, false nếu không có
		 */
		public function checkMinigame():Boolean 
		{
			if (_config == null)
			{
				return false;
			}
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var beginTime:Number = _config["BeginTime"];
			var endTime:Number = _config["ExpireTime"];//1337181700curTime = 1337935681.265
			var levelRequire:int = _config["LevelRequire"];
			var myLevel:int = GameLogic.getInstance().user.GetLevel();
			if (myLevel >= levelRequire && (curTime<endTime&&curTime>beginTime))
			{
				return true;
			}
			else {
				return false;
			}
		}
		
		public function get config():Object 
		{
			return _config;
		}
		
		public function set config(value:Object):void 
		{
			_config = value;
		}
		
		
	}

}




















