package Event.EventLuckyMachine 
{
	import Event.EventMgr;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class EventLuckyMachineMgr 
	{
		private static var _instance:EventLuckyMachineMgr = null;
		public static function getInstance():EventLuckyMachineMgr
		{
			if (_instance == null)
			{
				_instance = new EventLuckyMachineMgr();
			}
			return _instance;
		}
		private var _ticket:Number = 0;
		public function EventLuckyMachineMgr() 
		{
			
		}
		public function updateTicket(dTicket:Number):void
		{
			_ticket += dTicket;
			if (_ticket < 0)
			{
				_ticket = 0;
			}
		}
		public function getTicketNum():Number
		{
			return _ticket;
		}
		public function initData(data:Object):void
		{
			_ticket = 0;
			if (data["Store"] != null && 
				data["Store"]["StoreList"] &&
				data["Store"]["StoreList"]["EventItem"] != null &&
				data["Store"]["StoreList"]["EventItem"][EventMgr.NAME_EVENT] != null &&
				data["Store"]["StoreList"]["EventItem"][EventMgr.NAME_EVENT]["Ticket"] != null&&
				data["Store"]["StoreList"]["EventItem"][EventMgr.NAME_EVENT]["Ticket"]["1"] != null)
			{
				_ticket = data["Store"]["StoreList"]["EventItem"][EventMgr.NAME_EVENT]["Ticket"]["1"];
			}
		}
		
		
	}

}