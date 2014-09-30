package NetworkPacket.PacketSend.CreateEquipment 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendCreateEquip extends BasePacket 
	{
		public var SkillCraft:String;
		public var LevelCraft:int;
		public var Element:int;
		public var TypeEquip:String;
		
		public function SendCreateEquip(_skillType:String, _level:int, _element:int, _typeEquip:String) 
		{
			ID = Constant.CMD_CREATE_EQUIP;
			URL = "CraftEquipService.craftEquip";
			SkillCraft = _skillType;
			LevelCraft = _level;
			Element = _element;
			TypeEquip = _typeEquip;
			IsQueue = false;
		}
		
	}

}