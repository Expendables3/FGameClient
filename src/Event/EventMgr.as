package Event 
{
	import Data.ConfigJSON;
	import Event.NewYear.EventNewYear;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.MyUserInfo;
	import NetworkPacket.BasePacket;
	import NetworkPacket.PacketReceive.BaseReceivePacket;
	/**
	 * ...
	 * @author ...
	 */
	public class EventMgr 
	{
		private static var instance:EventMgr;
		private var EventArr:Array = [];
		private var event:Object;
		
		public static const EVENT_NEW_YEAR:int = 1;
		
		public static const CURRENT_BEFORE_EVENT:int = -1;
		public static const CURRENT_IN_EVENT:int = 0;
		public static const CURRENT_AFTER_EVENT:int = 1;
		public static const CURRENT_NOT_ENOUGH_LEVEL:int = -2;
		public static const CURRENT_NOT_EVENT:int = -3;
		//public static const NAME_EVENT:String = "Event_Tet_2013";		//Bắn cá
		//public static const NAME_EVENT:String = "TreasureIsland";		//Đào vàng
		//public static const NAME_EVENT:String = "LuckyMachine";		//Quay số
		//public static const NAME_EVENT:String = "PearFlower";		//Mê cung
		public static const NAME_EVENT:String = "Hal2012";		//Thạch bảo đồ
		
		public function EventMgr() 
		{
			
		}
		
		public static function getInstance():EventMgr
		{
			if(instance == null)
			{
				instance = new EventMgr();
			}				
			return instance;
		}
		
		public function InitEvent(eventType:int, data:BaseReceivePacket = null):void
		{
			switch(eventType)
			{
				case EVENT_NEW_YEAR:
					var newYear:EventNewYear = new EventNewYear(data);
					EventArr.push(newYear);
					break;
				default:
					break;
			}
		}	
		
		public function HandleEventMsg(Type:String, NewData:Object, OldData:Object):void
		{
			var event:BaseEvent;
			for (var i:int = 0; i < EventArr.length; i++)
			{
				event = EventArr[i] as BaseEvent;
				event.HandleEventMsg(Type, NewData, OldData);
			}
		}
		
		public function IsEvent(Cmd:BasePacket):Boolean
		{
			var i:int;
			var event:BaseEvent;
			// kiem tra du lieu event			
			for (i = 0; i < EventArr.length; i++)
			{
				event = EventArr[i] as BaseEvent;
				if (event.IsEvent(Cmd))
				{
					return true;
				}
			}
			return false;
		}
		
		
		public function UpdateEvent(Type:String, NewData:Object, OldData:Object):void
		{
			var event:BaseEvent;
			for (var i:int = 0; i < EventArr.length; i++)
			{
				event = EventArr[i] as BaseEvent;
				event.UpdateEvent(OldData as BasePacket);
			}
		}		

		/**
		 * Trả về 0 nếu trong event
		 * Trả -1 nếu trước event
		 * Trả 1 nếu sau Event
		 * @param	name
		 * @return
		 */
		public static function CheckEvent(name:String):int
		{
			if (EventMgr.getInstance().event == null)
			{
				EventMgr.getInstance().event = ConfigJSON.getInstance().GetItemList("Event");
			}
			
			var event: Object = EventMgr.getInstance().event;
			
			if (!event[name])	return CURRENT_NOT_EVENT;
			var beginTime:Number = event[name].BeginTime;
			var endTime:Number = event[name].ExpireTime - 100;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var userLevel:int = GameLogic.getInstance().user.GetLevel();
			if (userLevel < event[name]["BeginLevel"])
			{
				return CURRENT_NOT_ENOUGH_LEVEL;
			}
			if (curTime >= beginTime && curTime <= (endTime - 120))//hard code cho event trung thu=> hết event trước 2 phút
			{
				return CURRENT_IN_EVENT;
			}
			else if (curTime < beginTime)
			{
				return CURRENT_BEFORE_EVENT;
			}
			return Math.ceil((curTime - endTime) / 604800);
			return CURRENT_AFTER_EVENT;
		}
		
		/**
		 * Trả về 0 nếu trong event
		 * Trả -1 nếu trước event
		 * Trả 1 nếu sau Event
		 * @param	name
		 * @return
		 */
		public static function CheckGetGiftInEvent(name:String):int
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			if (!event[name])	return CURRENT_NOT_EVENT;
			var beginTime:Number = event[name].BeginTime;
			var endTime:Number = event[name].ExpireTime + 86400 * 7;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (GameLogic.getInstance().user.GetLevel() < event[name]["BeginLevel"])
			{
				return CURRENT_NOT_ENOUGH_LEVEL;
			}
			
			if (curTime >= beginTime && curTime <= endTime)
			{
				return CURRENT_IN_EVENT;
			}
			else if (curTime < beginTime)
			{
				return CURRENT_BEFORE_EVENT;
			}
			return Math.ceil((curTime - endTime) / 604800);
			return CURRENT_AFTER_EVENT;
		}
		
		/**
		 * @author longpt
		 * Hàm check khởi tạo event khi lên level 
		 */
		public function CheckInitEvent():void
		{
			var eventList:Object = ConfigJSON.getInstance().getEventInfo();
			var userInfo:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
			for (var name:String in eventList)
			{
				if (!userInfo.event[name])
				{
					if (CheckEvent(name) == CURRENT_IN_EVENT)
					{
						userInfo.event[name] = new Object();
						switch (name)
						{
							case "SoldierEvent":
								userInfo.event[name]["GaveGift"] = new Array();
								userInfo.event[name]["LuckyStar"] = 0;
								userInfo.event[name]["WinTotal"] = 0;
								break;
						}
					}
				}
			}
		}
	}

}