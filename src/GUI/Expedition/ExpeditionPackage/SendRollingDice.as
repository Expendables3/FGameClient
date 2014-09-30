package GUI.Expedition.ExpeditionPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendRollingDice extends BasePacket 
	{
		public var TypePrice:String;
		public function SendRollingDice(typePrice:String) 
		{
			URL = "ExpeditionService.rollingDice";
			ID = Constant.CMD_ROLLING_DICE;
			TypePrice = typePrice;
			IsQueue = false;
			
		}
		
	}

}