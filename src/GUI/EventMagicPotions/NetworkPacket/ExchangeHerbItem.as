package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * doi thuoc
	 * @author longpt
	 */
	public class ExchangeHerbItem extends BasePacket 
	{
		public var IdHerb:int;
		public var IdAuto:int;
		
		public function ExchangeHerbItem(id:int, idAuto:int = 1) 
		{
			ID = Constant.CMD_SEND_EXCHANGE_HERB_ITEM;
			URL = "EventService.exchangeHerbPotion";
			IsQueue = false;
			
			IdHerb = id;
			IdAuto = idAuto;
		}
		
	}

}