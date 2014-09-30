package GUI.Mail.SystemMail.Controller 
{
	import GUI.ItemGift.ItemNormalGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GiftInputCodeMgr 
	{
		private var _lstNormalGift:Array = [];
		private var _lstSpecialGift:Array = [];
		private var _lstAllGift:Array = [];
		private static var _instance:GiftInputCodeMgr;
		
		public function GiftInputCodeMgr() 
		{
			
		}
		
		public function get ListNormalGift():Array
		{
			return _lstNormalGift;
		}
		
		public function get ListSpecialGift():Array
		{
			return _lstSpecialGift;
		}
		public function get ListAllGift():Array
		{
			return _lstAllGift;
		}
		
		public static function getInstance():GiftInputCodeMgr
		{
			if (_instance == null)
			{
				_instance = new GiftInputCodeMgr();
			}
			return _instance;
		}
		
		public function initData(data:Object):void
		{
			_lstAllGift.splice(0, _lstAllGift.length);
			initNormalGift(data["Normal"]);
			initSpecialGift(data["Special"]);
			trace("finish load all gift into _lstAllGift voi length = " + _lstAllGift.length);
		}
		
		private function initNormalGift(data:Object):void
		{
			var tmp:AbstractGift;
			for (var str:String in data)
			{
				tmp = new GiftNormal();
				tmp.setInfo(data[str]);
				_lstAllGift.push(tmp);
			}
		}
		
		private function initSpecialGift(data:Object):void
		{
			var tmp:AbstractGift;
			for (var str:String in data)
			{
				tmp = AbstractGift.createGift(data[str]["Type"]);
				//tmp = new GiftSpecial();
				tmp.setInfo(data[str]);
				_lstAllGift.push(tmp);
			}
		}
		
		public function getTotalGiftLength():int
		{
			return _lstNormalGift.length + _lstSpecialGift.length;
		}
	}

}
























