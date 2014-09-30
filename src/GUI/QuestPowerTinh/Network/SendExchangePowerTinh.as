package GUI.QuestPowerTinh.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Doi tinh luc
	 * @author longpt
	 */
	public class SendExchangePowerTinh extends BasePacket 
	{
		public var IdExchangeItem:int;
		
		public function SendExchangePowerTinh(id:int) 
		{
			ID = Constant.CMD_SEND_EXCHANGE_POWER_TINH;
			URL = "MiniGameService.exchangePowerTinh";
			
			IdExchangeItem = id;
			
			IsQueue = false;
		}
		
	}

}