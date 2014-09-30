package Event.EventNoel.NoelLogic.Round 
{
	import Event.EventNoel.NoelLogic.TeamInfo.CircleTeamInfo;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class RoundBoss extends RoundNoel 
	{
		private const MAX_TEAM_GENERATE:int = 3;
		private const DELTA_TIME_GENERATE:int = 3;
		public function RoundBoss() 
		{
			generateListStartPoint();
		}
		/**
		 * Khởi tạo các team cho vòng boss
		 * @param	oNum [in] chắc chắn có "FishBoss" số lượng 1
		 * @param	oFish [in] lấy luôn "FishBoss"
		 */
		override protected function initListTeam(oNum:Object, oFish:Object):void 
		{
			_oTeam = new Object();
			initBossTeam(oNum, oFish);
			initCircleTeams(oNum, oFish);
		}
		/**
		 * khởi tạo dữ liệu cho team boss
		 * @param	oFish
		 */
		private function initBossTeam(oNum:Object, oFish:Object):void 
		{
			var dataBoss:Object;
			var bossTeam:TeamAbstractInfo = TeamAbstractInfo.createTeamInfo(ROUND_BOSS, 1);
			for (var idBoss:String in oFish["FishBoss"]["1"])
			{
				dataBoss = oFish["FishBoss"]["1"][idBoss];
			}
			var dataTeam:Object = { "IdTeam":1, "Id":int(idBoss), 
							"FishType":"FishBoss", "FishId":1, 
							"Blood":dataBoss["Blood"],
							"BonusIndex":dataBoss["BonusIndex"] 
						};
			bossTeam.init(dataTeam);
			_oTeam["1"] = bossTeam;
			delete(oNum["FishBoss"]["1"]);
			delete(oNum["FishBoss"]);
		}
		/**
		 * khởi tạo dữ liệu cho các team Circle (CircleTeamInfo)
			* số lượng team cuối cùng là ít nhất vì nó là số cá còn lại
		 * @param	oNum
		 * @param	oFish
		 */
		private function initCircleTeams(oNum:Object, oFish:Object):void 
		{
			var type:String, fishId:String, idFish:String, dataTeam:Object;
			var idTeam:int = 1;
			var tempIdCircle:int = 2;
			var numFish:int, idCircle:int;
			var circleTeam:TeamAbstractInfo;
			var oTotal:Object = { "FishCommon":0, "FishFast":0 };//tổng số lượng cá trừ con boss
			for (type in oNum)
			{
				for (fishId in oNum[type])
				{
					oTotal[type] += oNum[type][fishId];
				}
			}
			var total:int;
			for (type in oFish)
			{
				total = oTotal[type];
				while (total > 0)
				{
					tempIdCircle %= 2;
					idCircle = tempIdCircle + 1;
					numFish = CircleTeamInfo.getNumFish(idCircle);//số lượng cá của team sắp được sinh ra (không bao giờ được = 1)
					var tempNum:int = numFish;
					dataTeam = new Object();
					circleTeam = TeamAbstractInfo.createTeamInfo(ROUND_BOSS, numFish);
					circleTeam.IdTeam =++idTeam;
					for (fishId in oFish[type])
					{
						for (idFish in oFish[type][fishId])
						{
							dataTeam[idFish] = { 
													"IdTeam":idTeam, "Id":int(idFish), 
													"FishType":type, "FishId":fishId, 
													"Blood":oFish[type][fishId][idFish]["Blood"],
													"BonusIndex":oFish[type][fishId][idFish]["BonusIndex"] 
												};
							delete(oFish[type][fishId][idFish]);
							if (--total == 0 || --tempNum == 0) break;
						}
						if (total == 0 || tempNum == 0) break;
					}
					circleTeam.setIdCircle(idCircle);
					circleTeam.init(dataTeam);
					_oTeam[idTeam] = circleTeam;
					tempIdCircle++;
				}
			}
		}
		
		/**
		 * chọn team
			* chọn team boss trước
			* chọn 2 team có số lượng đông => 2 team ngay sát team boss
		 * @return
		 */
		override public function generateTeamInfo(indexGen:int):TeamAbstractInfo 
		{
			var info:TeamAbstractInfo;
			switch(indexGen)
			{
				case 0://gen lần đầu => ra BossTeamInfo
					info = _oTeam["1"];
					break;
				default:
					info = _oTeam[indexGen + 1];
			}
			if (info == null)
			{
				return null;
			}
			_numFishActive += info.NumFish;
			info.IsActive = true;
			return info;
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
			
			listStartPoint.push( { "x": -100, "y":100 } );
			listStartPoint.push( { "x": -100, "y":240 } );
			listStartPoint.push( { "x": -100, "y":370 } );
		}
		
		override public function isFinish():Boolean 
		{
			var passTime:Number = GameLogic.getInstance().CurServerTime - _startTime;
			if (passTime > getTimeRound())
			{
				return false;
			}
			var bossTeamInfo:TeamAbstractInfo = _oTeam["1"];
			if (bossTeamInfo.NumFish == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		override public function getDeltaTimeGen():Number { return DELTA_TIME_GENERATE; }
		override public function setNumFishDie(numFishDie:int):void { _num = 0; }
	}
}



























