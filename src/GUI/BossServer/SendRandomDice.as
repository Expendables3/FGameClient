package GUI.BossServer 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendRandomDice extends BasePacket 
	{
		public var PriceType:String;
		public var Type:int;
		public function SendRandomDice(_priceType:String, _type:int) 
		{
			IsQueue = false;
			ID = Constant.CMD_SEND_RANDOM_DICE;
			URL = "ServerBossService.randomDice";
			PriceType = _priceType;
			Type = _type;
		}
		
	}

}