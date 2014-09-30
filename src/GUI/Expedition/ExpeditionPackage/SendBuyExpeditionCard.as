package GUI.Expedition.ExpeditionPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * gói mua ngư lệnh: bằng vàng or xu or kim cương
	 * @author HiepNM2
	 */
	public class SendBuyExpeditionCard extends BasePacket 
	{
		public var ItemType:String;
		public var Num:int;
		public var TypeCost:String;
		public function SendBuyExpeditionCard(itemType:String, num:int, typeCost:String) 
		{
			URL = "ExpeditionService.buyCard";
			ID = Constant.CMD_BUY_CARD_EXPEDITION;
			ItemType = itemType;
			Num = num;
			TypeCost = typeCost;
			IsQueue = false;
		}
		
	}

}