package Event.EventNoel.NoelLogic.TeamInfo 
{
	import Event.EventNoel.NoelLogic.FishNoelInfo;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import Logic.Ultility;
	/**
	 * Thông tin đội hình cá
	 * @author HiepNM2
	 */
	public class TeamAbstractInfo 
	{
		public static const ALONE:int = 1;
		public static const LINE:int = 2;
		public static const TRIPLE:int = 3;
		public static const BOSS_ROUND:int = 4;
		public static const BOSS:int = 5;
		public static const CIRCLE:int = 6;
		
		protected var _typeTeam:int;
		protected var _idTeam:int;					//id của team
		protected var _oFish:Object;				//mảng thông tin cá trong team
		protected var _numFish:int;					//số lượng cá trong team
		protected var _isActive:Boolean;				//team đang được dùng
		public function TeamAbstractInfo(type:int) 
		{
			_typeTeam = type;
		}
		/**
		 * khởi tạo cho mảng cá trong team
		 * @param	data
		 */
		public virtual function init(data:Object):void
		{
			var info:FishAbstractInfo;
			var temp:Object;
			_oFish = new Object();
			_numFish = 0;
			for (var s:String in data)
			{
				temp = data[s];
				info = FishAbstractInfo.createFishInfo(temp["FishType"], temp["FishId"]);
				info.setInfo(temp);
				_oFish[s] = info;
				_numFish++;
			}
		}
		
		public function removeAllFish():void
		{
			if (_oFish == null)
			{
				return;
			}
			for (var i:String in _oFish)
			{
				delete(_oFish[i]);
			}
			_oFish = null;
			_numFish = 0;
		}
		
		private static function createInfo(type:int, numFish:int = 1):TeamAbstractInfo
		{
			switch(type)
			{
				case ALONE:
					return new AloneTeamInfo(type);
				case LINE:
					return new LineTeamInfo(type);
				case TRIPLE:
					return new TripleTeamInfo(type);
				case BOSS_ROUND:
					return RoundBossTeamsInfo.createTeamInfo(numFish);
			}
			return new TeamAbstractInfo(type);
		}
		/**
		 * tạo thông tin của đội dựa vào vòng và số lượng cá của đội
		 * @param	idRound vòng
		 * @param	numFish số lượng cá
		 * @return this
		 */
		public static function createTeamInfo(idRound:int, numFish:int):TeamAbstractInfo
		{
			if (idRound == BOSS_ROUND)
			{
				return createInfo(idRound, numFish);
			}
			else
			{
				if (numFish == 1)
				{
					return createInfo(ALONE);
				}
				else if(numFish > 1 && numFish < 3)
				{
					return createInfo(Ultility.RandomNumber(ALONE, LINE));
				}
				else if (numFish >= 3 && numFish < 6)
				{
					return createInfo(LINE);
				}
				else
				{
					return createInfo(TRIPLE);
				}
			}
		}
		public function get IdTeam():int { return _idTeam; }
		public function set IdTeam(value:int):void { _idTeam = value; }
		public function get IsActive():Boolean { return _isActive; }
		public function set IsActive(val:Boolean):void { _isActive = val; }
		public function get TypeTeam():int { return _typeTeam; }
		public function get NumFish():int { return _numFish; }
		
		public function updateBloodFish(id:int, dBlood:int):void
		{
			var f:FishAbstractInfo = _oFish[id];
			f.updateBlood(dBlood);
		}
		
		public function getListFish():Object 
		{
			return _oFish;
		}
		
		public virtual function destructor():void
		{
			removeAllFish();
			_idTeam = -1;
			_isActive = false;
			_typeTeam = -1;
		}
		
		public virtual function removeFish(id:int):void
		{
			if (_oFish != null)
			{
				if (_oFish[id] != null)
				{
					delete(_oFish[id]);
					_numFish--;
				}
			}
		}
		
		public virtual function getIdCircle():int { return 0;}//đối với circle team
		public virtual function setIdCircle(idCircle:int):void { }
	}

}































