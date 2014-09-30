package GUI.GuiBuyAbstract 
{
	import NetworkPacket.BasePacket;
	import NetworkPacket.PacketSend.LuckyMachine.SendBuyTicket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBuyAbstract extends BasePacket 
	{
		public var ItemType:String;
		public var ItemId:int;
		public var Num:int;
		public var PriceType:String;
		public function SendBuyAbstract(urlAPI:String, idAPI:String,
										type:String, id:int,
										num:int, priceType:String) 
		{
			URL = urlAPI;
			ID = idAPI;
			ItemType = type;
			ItemId = id;
			Num = num;
			PriceType = priceType;
			IsQueue = false;
		}
		
		static public function createPacket(urlBuyAPI:String, idBuyAPI:String, type:String, id:int, num:int, priceType:String,dataBuff:Object):SendBuyAbstract 
		{
			switch(urlBuyAPI)
			{
				case "MiniGameService.buyItem":
					return new SendBuyTicket(urlBuyAPI, idBuyAPI, type, id, num, priceType);
				default:
					return new SendBuyAbstract(urlBuyAPI, idBuyAPI, 
													type, id, 
													num, priceType);
			}
		}
		
	}

}























