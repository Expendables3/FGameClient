package GUI.TrainingTower.TrainingLogic 
{
	import Data.ConfigJSON;
	import Event.EventMgr;
	import flash.geom.Point;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class Room 
	{
		static public const STATE_LOCK:int = -1; // nếu StartTime < 0
		static public const STATE_IDLE:int = 0;	//nếu StartTime = 0;
		static public const STATE_TRAIN:int = 1;// nếu StartTime > 0
		static public const STATE_FINISH:int = 2;//nếu StartTime > 0 và CurTime-StartTime>=TrainTime
		
		//server
		private var _startTime:Number;
		//public var StartTime:Number;
		private var _timeType:int;
		public var IntensityType:int;
		private var _listGift:Array = [];
		
		public var SoldierId:int;
		public var SoldierName:String;
		public var LakeId:int;
		//config
		public var ZMoney:int;
		public var RoomId:int;
		//dẫn xuất
		public var State:int;	//nhận các giá trị phía trên
		public var TimeTrain:int;
		public var inSeek:Boolean = false;
		
		public var TimePayType:String = "Free";
		public var IntensityPayType:String = "Free";
		
		public function Room() 
		{
			
		}
		
		public function setInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
		
		/**
		 * xét xem việc luyện tập đã hoàn thành chưa
		 * @param	curTime : thời điểm đang luyện
		 * @return
		 */
		public function isFinish(curTime:Number):Boolean 
		{
			var passedTime:Number = curTime - StartTime;
			if (passedTime >= TimeTrain)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		/*
		public function countState():void 
		{
			//tính state sau khi đã có starttime và trainingtime
			if (StartTime < 0 || StartTime == null)//chưa thiết lập giá trị cho StartTime
			{
				State = STATE_LOCK;
			}
			else if (StartTime == 0)			//Thiết lập = 0
			{
				State = STATE_IDLE;
			}
			else
			{
				var trainTime:int = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"][TimeType];
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				if (curTime - StartTime >= trainTime)
				{
					State = STATE_FINISH;
				}
				else
				{
					State = STATE_TRAIN;
				}
			}
		}
		*/
		public function set StartTime(value:Number):void
		{
			_startTime = value;
			if (value < 0) 
			{
				State = STATE_LOCK;
			}
			else if (value == 0)
			{
				State = STATE_IDLE;
			}
			else
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				if (curTime-StartTime >= TimeTrain)
				{
					State = STATE_FINISH;
				}
				else {
					State = STATE_TRAIN;
				}
			}
		}
		
		public function get StartTime():Number {
			return _startTime;
		}
		
		public function get TimeType():int 
		{
			return _timeType;
		}
		
		public function set TimeType(value:int):void 
		{
			_timeType = value;
			TimeTrain = 60 * value;
		}
		
		public function get IntervalTime():int {
			return RoomId * 20;
		}
		
		public function get GiftList():Array 
		{
			return _listGift;
		}
		
		public function set GiftList(value:Array):void 
		{
			_listGift.splice(0, _listGift.length);
			var str:String;
			var i:int;
			var abstractGift:AbstractGift;
			for (i = 0; i < value.length;i++)
			{
				abstractGift = new GiftNormal();
				/*if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT)
				{
					if (value[i]["ItemType"] == "Meridian")
					{
						value[i]["Num"] *= 2;
					}
				}*/
				(abstractGift as GiftNormal).setInfo(value[i]);
				_listGift.push(abstractGift);
			}
		}
		public function updateState(time:Number):void
		{
			if (_startTime < 0)
			{
				State = STATE_LOCK;
			}
			else if (_startTime == 0)
			{
				State = STATE_IDLE;
			}
			else
			{
				if (State != STATE_FINISH) //không thể chuyển ngược từ finish về train
				{
					var remainTime:int = TimeTrain - (time - _startTime);
					if (remainTime > 0)
					{
						State = STATE_TRAIN;
					}
					else
					{
						//trace("finish here");
						State = STATE_FINISH;
					}
				}
			}
			
			
		}
		public function get EffPosition():Point {
			var pos:Point = new Point();
			switch(IntensityType) {
				case 1:
					pos.x = 318;
					pos.y = 435;
				break;
				case 2:
					pos.x = 361;
					pos.y = 521;
				break;
				case 3:
					pos.x = 358;
					pos.y = 520;
				break;
				case 4:
					pos.x = 434;
					pos.y = 520;
				break;
				default:
					pos.x = pos.y = 0;
			}
			return pos;
		}
	}

}




















