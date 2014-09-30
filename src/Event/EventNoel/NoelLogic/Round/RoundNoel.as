package Event.EventNoel.NoelLogic.Round 
{
	import Data.ConfigJSON;
	import Event.EventNoel.NoelGui.Team.RoundBossTeams;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import flash.geom.Point;
	import Logic.GameLogic;
	import Logic.Ultility;
	/**
	 * Vòng chơi trong trò bắn cá
	 * @author HiepNM2
	 */
	public class RoundNoel extends RoundAbstractInfo 
	{
		public static const ROUND_BOSS:int = 4;
		protected var _oTeam:Object;						//mảng các đàn cá
		private var _requestKey:String;
		protected var _numFish:int;
		protected var _numFishActive:int = 0;					//số lượng cá trên hồ
		protected const o:Object = { "FishCommon": {
								"1": { "min":10, "max":17 },
								"2": { "min":5, "max":10 },
								"3": { "min":3, "max":5 },
								"4" : { "min":1, "max":1 },
								"5" : { "min":3, "max":5 }
							},
							"FishFast": {
								"1": { "min":1, "max":1 }
							},
							"FishBoss": {
								"1": { "min":1, "max":1 }
							}
						};
		protected var listStartPoint:Array = [];
		public function RoundNoel() 
		{
		}
		
		public function get MaxNumActive():int { return 40; }
		public function get NumFishActive():int { return _numFishActive; }
		public function set NumFishActive(val:int):void { _numFishActive = val; }
		//public function set NumFishDie(val:int):void { _num = val; }
		public function get NumFishDie():int { return _num;}
		public function set RequestKey(val:String):void { _requestKey = val; }
		override public function getMainData():Object { return _oTeam; }
		
		protected virtual function initListTeam(oNum:Object, oFish:Object):void { }
		public virtual function getMaxTeamGenerate():int { return 0; }
		public virtual function generateTeamInfo(indexGen:int):TeamAbstractInfo { return null; }
		public virtual function getDeltaTimeGen():Number { return 0; }
		public virtual function setNumFishDie(numFishDie:int):void { }
		public virtual function getStartPoint():Point 
		{  
			var p:Point = new Point();
			var o:Object = listStartPoint.pop();
			p.x = o["x"];
			p.y = o["y"];
			return p;
		}
		public virtual function generateListStartPoint():void { }
		/**
		 * khởi tạo mảng team từ server
			* init _oTeam
		 * @param	data dữ liệu server về danh sách các con cá
		 */
		public function initRoundData(data:Object):void 
		{
			var o:Object = { "oNum":0, "oFish":0 };
			filterData(data, o);
			initListTeam(o["oNum"], o["oFish"]);
		}
		/**
		 * triết xuất dữ liệu server trả về thành dữ liệu dễ xử lý
		 * @param	data [in] dữ liệu của tất cả cá
		 * @param	oNum [out] số lượng từng loại cá
		 * @param	oFish [out] category từng loại cá
		 */
		private function filterData(data:Object, outData:Object):void
		{
			var oNum:Object = { "FishCommon": { "1":0, "2":0, "3":0, "4":0, "5":0 }, 
								"FishFast": { "1":0 }, 
								"FishBoss": { "1":0 } 
							};
			var oFish:Object = { "FishCommon": { "1":0, "2":0, "3":0, "4":0, "5":0 }, 
								"FishFast": { "1":0 }, 
								"FishBoss": { "1":0 } 
							};
			_numFish = 0;
			var temp:Object;
			var s:String;
			for (s in data)
			{
				temp = data[s];
				if (oFish[temp["FishType"]][temp["FishId"]] == 0)
				{
					oFish[temp["FishType"]][temp["FishId"]] = new Object();
				}
				_numFish++;
				oFish[temp["FishType"]][temp["FishId"]][s] = new Object();
				oFish[temp["FishType"]][temp["FishId"]][s]["Blood"] = data[s]["Blood"];
				oFish[temp["FishType"]][temp["FishId"]][s]["BonusIndex"] = data[s]["BonusIndex"];
				oNum[temp["FishType"]][temp["FishId"]]++;//cộng thêm số lượng tùy từng loại cá
			}
			outData["oNum"] = oNum;
			outData["oFish"] = oFish;
		}
		
		
		
		public function updateBloodFish(idTeam:int, id:int, dBlood:int):void 
		{
			var team:TeamAbstractInfo = _oTeam[idTeam];
			team.updateBloodFish(id, dBlood);
		}
		
		override public function isFinish():Boolean 
		{
			var passTime:Number = GameLogic.getInstance().CurServerTime - _startTime;
			return (_num >= getNumRequired()) && (passTime <= getTimeRound());//còn thời gian và đủ số lượng
		}
		override public function getTimeRound():Number 
		{
			return ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["Time"];
		}
		override public function roundUp():Boolean 
		{
			_num = 0;
			return true;
		}
		/**
		 * xóa 1 phần tử trong _oTeam
		 * @param	idTeam
		 */
		public function removeTeam(idTeam:int):void
		{
			if (_oTeam == null || _oTeam[idTeam] == null) return;
			var team:TeamAbstractInfo = _oTeam[idTeam];
			team.destructor();
			delete(_oTeam[idTeam]);
		}
		/**
		 * xóa toàn bộ _oTeam
		 */
		public function removeAllTeam():void
		{
			if (_oTeam == null) return;
			var idTeam:String, team:TeamAbstractInfo;
			for (idTeam in _oTeam)
			{
				team = _oTeam[idTeam];
				team.destructor();
				delete(_oTeam[idTeam]);
			}
			_numFish = 0;
			_numFishActive = 0;
		}
		
		public function Destructor():void
		{
			removeAllTeam();
			_idRound = 0;
			_startTime = 0;
			_num = 0;
		}
		
		static public function createRound(idRound:int):RoundNoel 
		{
			switch(idRound)
			{
				case 1:
				case 2:
				case 3:
					return new RoundNormal();
				case ROUND_BOSS:
					return new RoundBoss();
				case 5:
					return new RoundBonus();
			}
			return new RoundNoel();
		}
		
		public virtual function getTimeStart():Number 
		{
			return EventNoelMgr.getInstance().StartTimeGame;
		}
		
		
	}

}

















