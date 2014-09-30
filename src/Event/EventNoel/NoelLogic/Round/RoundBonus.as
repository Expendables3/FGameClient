package Event.EventNoel.NoelLogic.Round 
{
	import Data.ConfigJSON;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Logic.Ultility;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class RoundBonus extends RoundNoel 
	{
		private const MAX_TEAM_GENERATE:int = 4;
		private const DELTA_TIME_GENERATE:int = 4;			//thời gian sinh lứa kế tiếp
		public function RoundBonus() 
		{
			generateListStartPoint();
		}
		
		override protected function initListTeam(oNum:Object, oFish:Object):void 
		{
			var team:TeamAbstractInfo, indexRand:int, dataTeam:Object, num:int, tempNum:int;
			var idTeam:int = 0;
			_oTeam = new Object();
			var listRandom:Array = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 8];
			//var listRandom:Array = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 8];
			for (var s:String in oFish)
			{
				for (var i:String in oFish[s])
				{
					var total:int = oNum[s][i];
					while (total > 0)
					{
						dataTeam = new Object();
						indexRand = int(Ultility.RandomNumber(0, listRandom.length - 1));
						num = int(Math.min(total, listRandom[indexRand]));
						tempNum = num;
						team = TeamAbstractInfo.createTeamInfo(_idRound, num);
						team.IdTeam = ++idTeam;
						for (var j:String in oFish[s][i])
						{
							if (oFish[s][i][j]["Blood"] > 0)
							{
								dataTeam[j] = { "IdTeam":idTeam, "Id":int(j), 
												"FishType":s, "FishId":int(i), 
												"Blood":oFish[s][i][j]["Blood"],
												"BonusIndex":oFish[s][i][j]["BonusIndex"] 
											};
								delete(oFish[s][i][j]);
								if (--tempNum == 0) break;
							}
							else
							{
								//trace("Server trả về con cá có máu <= 0");
							}
						}
						team.init(dataTeam);
						_oTeam[idTeam] = team;
						total -= num;
					}
				}
			}
		}
		override public function generateTeamInfo(indexTeam:int):TeamAbstractInfo 
		{
			var info:TeamAbstractInfo, hasTeamOk:Boolean = false;
			for (var idTeam:String in _oTeam)
			{
				info = _oTeam[idTeam];
				if (!info.IsActive && (_numFishActive + info.NumFish <= MaxNumActive))
				{
					hasTeamOk = true;
					break;
				}
			}
			if (hasTeamOk)
			{
				_numFishActive += info.NumFish;
				info.IsActive = true;
				return info;
			}
			return null;
		}
		override public function getMaxTeamGenerate():int 
		{
			return MAX_TEAM_GENERATE;
		}
		override public function generateListStartPoint():void 
		{
			if (listStartPoint == null)
			{
				listStartPoint = [];
			}
			listStartPoint.splice(0, listStartPoint.length);
			
			listStartPoint.push( { "x": -100, "y":200 } );			//làn giữa bên trái
			listStartPoint.push( { "x": 910, "y":350 } );			//làn giữa bên phải
			listStartPoint.push( { "x": 910, "y":200 } );
			listStartPoint.push( { "x": -100, "y":350 } );
		}
		
		override public function getNumRequired():int { return _numFish; }
		override public function getDeltaTimeGen():Number { return DELTA_TIME_GENERATE; }
		override public function roundUp():Boolean 
		{
			_num = 0;
			return false;
		}
		override public function getTimeRound():Number 
		{
			return  ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")[_idRound]["Time"] - 2;
		}
		override public function getTimeStart():Number 
		{
			return EventNoelMgr.getInstance().LastTimeFinish;
		}
		override public function setNumFishDie(numFishDie:int):void { _num = 0; }
	}

}































