package GUI.ChampionLeague.FakeServer 
{
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class FakeConfigMgr 
	{
		private const GIFTNUM:int = 8;
		static private var _instance:FakeConfigMgr;
		public const LevelRequire:int = 7;
		public static const Top:Array = ["1", "5", "10", "20", "50", "100", "300", "1000"];
		private const Range:Array = ["30", "50", "100", "300", "1000"];
		
		
		private const Range30:Object = {Delta:1 };
		private const Range50:Object = {Delta:2 };
		private const Range100:Object = {Delta:4 };
		private const Range300:Object = {Delta:10 };
		private const Range1000:Object = {Delta:20 };
		
		private const tempGift:Object = { ItemId:5, ItemType:"Material", Num:5, Rate:1 };
		
		private var _rangeLeague:Object;
		private var _gift:Object;
		private var _param:Object;
		
		static public function getInstance():FakeConfigMgr {
			if (_instance == null) {
				_instance = new FakeConfigMgr();
			}
			return _instance;
		}
		
		public function FakeConfigMgr() 
		{
			initRangeLeague();
			initParam();
			initGift();
		}
		
		public function initRangeLeague():void {
			_rangeLeague = new Object();
			for (var i:int = 0; i < Range.length; i++) 
			{
				var rankBound:String = Range[i];
				_rangeLeague[rankBound] = this["Range" + rankBound];
			}
		}
		
		public function initParam():void {
			_param = new Object();
			_param["League"] = new Object();
			_param["League"]["Time"] = 10;
			_param["League"]["Card"] = 20;
			_param["League"]["LevelRequire"] = 7;
		}
		
		public function initGift():void 
		{
			_gift = new Object();
			for (var i:int = 0; i < Top.length; i++) 
			{
				var topBound:String = Top[i];
				_gift[topBound] = new Object();
				_gift[topBound]["Normal"] = new Object();
				for (var j:int = 1; j <= GIFTNUM; j++) {
					_gift[topBound]["Normal"][j.toString()] = tempGift;
				}
			}
			
			LeagueMgr.getInstance()._listTop.splice(0, LeagueMgr.getInstance()._listTop.length);
			for (var str:String in _gift) {
				var top:int = int(str);
				LeagueMgr.getInstance()._listTop.push(top);
			}
			LeagueMgr.getInstance()._listTop.sort(Array.NUMERIC);
			var _list:Array = LeagueMgr.getInstance()._listTop;
		}
		
		public function get RangeLeague():Object 
		{
			return _rangeLeague;
		}
		
		public function get Param():Object 
		{
			return _param;
		}

		public function get GiftTop():Object {
			return _gift;
		}
		
	}

}










