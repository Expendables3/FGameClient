package GUI.UnlockEquipment 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBuyOpenKeyItem extends BasePacket 
	{
		public var PriceType:String;
		public function SendBuyOpenKeyItem(priceType:String = "ZMoney") 
		{
			ID = Constant.CMD_BUY_OPEN_KEY;
			URL = "ItemService.buyOpenKeyItem";
			PriceType = priceType;
			IsQueue = false;
		}
	}

}