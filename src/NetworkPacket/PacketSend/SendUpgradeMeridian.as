package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendUpgradeMeridian extends BasePacket 
	{
		public var soldierId:int;
		public var lakeId:int;
		
		public function SendUpgradeMeridian(_lakeId:int, _soldierId:int) 
		{
			lakeId = _lakeId;
			soldierId = _soldierId;
			
			ID = Constant.CMD_SEND_UPGRADDE_MERIDIAN;
			URL = "SoldierService.upgradeMeridian";
		}
		
	}

}