package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyItemShopMarket extends BasePacket 
	{
		public var idItemShop:int;
		public var Tab:String;
		public var SubTab:String;
		public function SendBuyItemShopMarket(_tab:String, _idItemShop:int, _subTab:String = "") 
		{
			Tab = _tab;
			SubTab = _subTab;
			idItemShop = _idItemShop;
			ID = Constant.CMD_SEND_BUY_ITEM_SHOP_MARKET;
			URL = "MarketService.buyItemBlackMarket";
			IsQueue = false;
		}
		
	}

}