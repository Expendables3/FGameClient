package GUI.ChangeEnchant.ChangeEnchantPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Chuyển cường hóa
	 * @author HiepNM2
	 */
	public class SendChangeEnchantLevel extends BasePacket 
	{
		public var InEquip:Object;
		public var OutEquip:Object;
		public var PriceType:String;
		//public var MaterialList:Array;
		public var MaterialList:Object;
		
		public function SendChangeEnchantLevel(inEquip:Object,
												outEquip:Object,
												priceType:String,
												materialList:Object) 
		{
			ID = Constant.CMD_CHANGE_ENCHANT_LEVEL;
			URL = "ItemService.changeEnchantLevel";
			InEquip = inEquip;
			OutEquip = outEquip;
			PriceType = priceType;
			MaterialList = materialList;
			IsQueue = false;
		}
		
	}

}