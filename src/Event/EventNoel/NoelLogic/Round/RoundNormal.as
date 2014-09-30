package Event.EventNoel.NoelLogic.Round 
{
	import Data.ConfigJSON;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import flash.geom.Point;
	import Logic.Ultility;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class RoundNormal extends RoundNoel 
	{
		private const MAX_TEM_GENERATE:int = 4;
		private const DELTA_TIME_GENERATE:int = 6;
		public function RoundNormal() 
		{
			generateListStartPoint();
		}
		
		override protected function initListTeam(oNum:Object, oFish:Object):void 
		{
			var team:TeamAbstractInfo, rand:int, dataTeam:Object, num:int, tempNum:int;
			var idTeam:int = 0;
			_oTeam = new Object();
			for (var s:String in oFish)
			{
				for (var i:String in oFish[s])
				{
					var total:int = oNum[s][i];
					while (total > 0)
					{
						dataTeam = new Object();
						rand = int(Ultility.RandomNumber(o[s][i]["min"], o[s][i]["max"]));
						num = int(Math.min(total, rand));
						num = o[s][i]["min"] > num ? 1 : num;
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
		/**
		 * sinh ra team 1 cách ngẫu nhiên = cách chọn 1 team trong _oTeam. Điều kiện
			* chưa xuất hiện trên hồ
			* số lượng trên hồ + số lượng của đàn được chọn <= số lượng tối đa được phép xuất hiện trên hồ
		 * @return team
		 */
		override public function generateTeamInfo(indexTeam:int):TeamAbstractInfo 
		{
			var info:TeamAbstractInfo;
			var listTeamOk:Array = [];
			for (var idTeam:String in _oTeam)
			{
				info = _oTeam[idTeam];
				if (!info.IsActive && (_numFishActive + info.NumFish <= MaxNumActive))
				{
					listTeamOk.push(idTeam);
				}
			}
			if (listTeamOk.length > 0)
			{
				var index:int = Ultility.RandomNumber(0, listTeamOk.length - 1);
				info = _oTeam[listTeamOk[index]];
				_numFishActive += info.NumFish;
				info.IsActive = true;
				return info;
			}
			return null;
		}
		
		override public function getMaxTeamGenerate():int 
		{
			return MAX_TEM_GENERATE;
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
		override public function getNumRequired():int 
		{
			return ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")[_idRound]["NumFishRequire"];
		}
		override public function getDeltaTimeGen():Number { return DELTA_TIME_GENERATE; }
		override public function setNumFishDie(numFishDie:int):void { _num = numFishDie; }
	}

}






















