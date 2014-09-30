package GUI.ChampionLeague.FakeServer 
{
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.LogicLeague.Player;
	import Logic.GameLogic;
	import Logic.MyUserInfo;
	import NetworkPacket.PacketSend.SendAttackFriendLake;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class FakeServerMgr 
	{
		static private var _instance:FakeServerMgr = null;
		
		static public function getInstance():FakeServerMgr {
			if (_instance == null) {
				_instance = new FakeServerMgr();
			}
			return _instance;
		}
		
		private var _listPlayer:Array = [];
		private var _numCard:int;
		private var _lastTimeUpdate:Number;
		public var Data1:Object;
		public function FakeServerMgr() 
		{
		}
		public function initData(listPlayer:Object, numCard:int=20, lastTimeUpdate:Number=-1):void {
			initListPlayer(listPlayer);
			_numCard = numCard;
			_lastTimeUpdate = lastTimeUpdate;
			Data1 = new Object();
			Data1["ListPlayer"] = _listPlayer;
			Data1["NumCard"] = _numCard;
			Data1["LastTimeUpdate"] = _lastTimeUpdate;
		}
		public function initListPlayer(data1:Object):void 
		{
			_listPlayer.splice(0, _listPlayer.length);
			var listFriend:Array = data1["FriendList"];
			for (var i:int = 0; i < 6; i++)
			{
				var obj:Object = new Object();
				obj["Id"] = listFriend[i]["Id"];
				obj["Name"] = listFriend[i]["Name"];
				obj["AvatarPic"] = listFriend[i]["AvatarPic"];
				obj["Rank"] = i + 1;
				obj["SoldierId"] = 102;
				obj["LastTimeAttack"] = -1;
				_listPlayer.push(obj);
			}
			var me:Object = new Object();
			var user:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
			me["Rank"] = 7;
			me["SoldierId"] = 136;
			me["Id"] = user.Id;
			me["Name"] = user.Name;
			me["AvatarPic"] = user.AvatarPic;
			me["LastTimeFight"] = -1;
			_listPlayer.push(me);
		}

		public function get listPlayer():Array 
		{
			return _listPlayer;
		}
		
		public function set listPlayer(value:Array):void 
		{
			_listPlayer = value;
		}
		
		public function get NumCard():int 
		{
			return _numCard;
		}
		
		public function set NumCard(value:int):void 
		{
			_numCard = value;
		}
		
		public function get LastTimeUpdate():Number 
		{
			return _lastTimeUpdate;
		}
		
		public function set LastTimeUpdate(value:Number):void 
		{
			_lastTimeUpdate = value;
		}
		/**
		 * thực hiện việc đánh nhau
		 * @param	me : mình
		 * @param	victim : đối thủ của mình
		 */
		public function ProcessWar(me:Player, victim:Player):void 
		{
			/** gui du lieu **/
			var obj:Object = new Object();
			obj["myFishId"] = me.SoldierId;
			//obj["myFishId"] = 136;		
			obj["myLakeId"] = LeagueMgr.getInstance().getSoldierById(me.SoldierId).LakeId;
			obj["theirId"] = victim.Id;
			//obj["theirId"] = 2199078;
			obj["theirLake"] = 1;
			obj["VictimId"] = victim.SoldierId;
			//obj["VictimId"] = 102;		//id con cá của xe đua ba bánh
			var pk:SendAttackFriendLake = new SendAttackFriendLake(obj);
			Exchange.GetInstance().Send(pk);
		}
	}

}
















