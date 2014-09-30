package NetworkPacket.PacketSend.CreateEquipment 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetIngradient extends BasePacket 
	{
		public function SendGetIngradient() 
		{
			ID = Constant.CMD_GET_INGRADIENT;
			URL = "CraftEquipService.getIngredient";
			IsQueue = false;
		}
		
	}

}