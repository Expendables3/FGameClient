package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendUseLotus extends BasePacket 
	{
		public var SoldierList:Object = new Object();
		public function SendUseLotus(obj:Object) 
		{
			ID = Constant.CMD_USE_LOTUS;
			URL = "FishWorldService.useLotusFlower";
			IsQueue = false;
			SoldierList = obj;
		}
		
	}

}