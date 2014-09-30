package NetworkPacket.PacketSend.CreateEquipment 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuySpirit extends BasePacket 
	{
		// = 1 la vang, 2 la G
		public var Type:String;
		
		public function SendBuySpirit(_type:String) 
		{
			ID = Constant.CMD_BUY_SPIRIT;
			URL = "CraftEquipService.buyPowerTinh";
			Type = _type;
			//IsQueue = false;
		}
		
	}

}