package NetworkPacket.PacketSend.CreateEquipment 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendAutoSeparateEquip extends BasePacket 
	{
		public var Color:int;
		public var Rank:int;
		
		public function SendAutoSeparateEquip(_color:int, _rank:int) 
		{
			Color = _color;
			Rank = _rank;
			
			IsQueue = false;
			ID = Constant.CMD_SEND_AUTO_SEPARATE_EQUIP;
			URL = "CraftEquipService.autoRefineIngredient";
		}
		
	}

}