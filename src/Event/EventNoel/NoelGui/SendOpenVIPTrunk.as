package Event.EventNoel.NoelGui 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendOpenVIPTrunk extends BasePacket 
	{
		public var ByZMoney:int;
		private var Element:int;
		
		/**
		 * 
		 * @param	_byZMoney 1 la xu, 0 la key
		 */
		public function SendOpenVIPTrunk(_byZMoney:int, _element:int) 
		{
			ID = Constant.CMD_OPEN_VIP_TRUNK;
			URL = "VipBoxService.vbOpenBox";
			ByZMoney = _byZMoney;
			IsQueue = false;
			Element = _element;
		}
		
	}

}