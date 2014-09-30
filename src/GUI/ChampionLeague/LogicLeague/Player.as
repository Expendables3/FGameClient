package GUI.ChampionLeague.LogicLeague 
{
	import Logic.GameLogic;
	/**
	 * Lớp thể hiện người chơi Liên đấu
	 * @author HiepNM2
	 */
	public class Player 
	{
		private var _rank:int;
		private var _id:int;
		private var _soldierId:int;
		private var _name:String;
		private var _avatarPic:String;
		private var _lastTimeAttack:Number;
		//private var _top:int;
		
		public function Player() 
		{
			_rank = 0;
			_id = 0;
			_soldierId = 0;
		}
		
		public function setInfo(data:Object):void {
			for (var itm:String in data) {
				try {
					this[itm] = data[itm];
				}
				catch (err:Error) {
					//trace("thiếu thuộc tính " + itm);
				}
			}
		}
		
		public function IsMe():Boolean 
		{
			var myId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			if (_id == myId) {
				return true;
			}
			else {
				return false;
			}
		}
		public function get Rank():int 
		{
			return _rank;
		}
		
		public function set Rank(value:int):void 
		{
			_rank = value;
		}
		
		public function get Id():int 
		{
			return _id;
		}
		
		public function set Id(value:int):void 
		{
			_id = value;
		}
		
		public function get SoldierId():int 
		{
			return _soldierId;
		}
		
		public function set SoldierId(value:int):void 
		{
			_soldierId = value;
		}
		
		public function get Name():String 
		{
			return _name;
		}
		
		public function set Name(value:String):void 
		{
			if (value != null) {
				_name = value;
			}
			else {
				_name = "Unknown";
			}
		}
		
		public function get Avatar():String 
		{
			return _avatarPic;
		}
		
		public function set Avatar(value:String):void 
		{
			if (value == null || value == "") {
				_avatarPic = Main.staticURL + "/avatar.png";
			}
			else {
				_avatarPic = value;
			}
			
		}
		
		public function get LastTimeAttack():Number 
		{
			return _lastTimeAttack;
		}
		
		public function set LastTimeAttack(value:Number):void 
		{
			_lastTimeAttack = value;
		}
		
		public function get Top():int 
		{
			return LeagueMgr.getInstance().getTop(_rank);
		}
	}

}