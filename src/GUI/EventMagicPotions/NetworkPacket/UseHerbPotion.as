package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Ca'n Thuo'c
	 * @author longpt
	 */
	public class UseHerbPotion extends BasePacket 
	{
		public var HerbPotionId:int;
		public var LakeId:int;
		public var FishId:int;
		public var Num:int;
		
		public function UseHerbPotion(hId:int, lId:int, fId:int, num:int) 
		{
			ID = Constant.CMD_SEND_USE_HERB_POTION;
			URL = "FishService.useHerbPotion";
			IsQueue = false;
			
			HerbPotionId = hId;
			LakeId = lId;
			FishId = fId;
			Num = num;
		}
		
	}

}