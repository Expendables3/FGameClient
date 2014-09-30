package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendAddMaterialIntoFish extends BasePacket 
	{
		//$ItemType     = $param['ItemType'];
		//$Id           = $param['Id'];
		//$LakeId       = $param['LakeId'];
		//$MaterialId   = $param['MaterialId'];
		public var ItemType:String;
		public var Id:int;
		public var LakeId:int;
		public var MaterialId:int;
		public var KindFish:int;
		
		/**
		 * 
		 * @param	idFish		:	id của con cá đó
		 * @param	lakeId		:	Hồ mà con cá đang ở đó
		 * @param	materialId	:	id của ngư thạch 
		 * @param	itemType	:	là loại cá nào: Fish, Sparta, Swat, Batman, Spiderman, Superman, 
		 */
		public function SendAddMaterialIntoFish(idFish:int, lakeId:int, materialId:int, itemType:String, kindFish:int = 0) 
		{
			ID = Constant.CMD_ADD_MATERIAL_FISH;
			URL = "MaterialService.addMaterialIntoFish";
			Id = idFish;
			LakeId = lakeId;
			MaterialId = materialId;
			ItemType = itemType;
			KindFish = kindFish;
			IsQueue = false;
		}
		
	}

}