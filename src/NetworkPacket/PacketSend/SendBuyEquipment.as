package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendBuyEquipment extends BasePacket 
	{
		public var Type:String;		// Armor, Helmet, Weapon
		public var Rank:int;		// Cấp của trang bị
		public var Color:int;		// 1-Trằng, 2-Xanh, 3-Vàng 
		public var isMoney:Boolean;	// Mua bằng vàng hay tiền
		
		public function SendBuyEquipment(t:String, r:int, c:int, iMoney:Boolean) 
		{
			ID = Constant.CMD_BUY_EQUIPMENT;
			URL = "ItemService.buyEquipment";
			Type = t;
			Rank = r;
			Color = c;
			isMoney = iMoney;
		}
		
	}

}