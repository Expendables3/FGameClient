package NetworkPacket.PacketSend.LuckyMachine 
{
	import GUI.GuiBuyAbstract.SendBuyAbstract;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBuyTicket extends SendBuyAbstract 
	{
		public function SendBuyTicket(urlAPI:String, idAPI:String,
										type:String, id:int,
										num:int, priceType:String) 
		{
			super(urlAPI, idAPI, type, id, num, priceType);
			//ID = Constant.CMD_SEND_BUY_TICKET_FOR_LM;
			//URL = "MiniGameService.buyItem";
			
			//ItemType = type;
			//ItemId = id;
			//Num = num;
		}
		
	}

}