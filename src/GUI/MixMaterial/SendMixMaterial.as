package GUI.MixMaterial 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendMixMaterial extends BasePacket 
	{
		public var Num:int;
		public var PriceType:String;
		public var TypeId:int;
		
		public function SendMixMaterial() 
		{
			ID = Constant.CMD_SEND_MIX_MATERIAL;
			URL = "MaterialService.boostItem";
			IsQueue = false;
		}
		
	}

}