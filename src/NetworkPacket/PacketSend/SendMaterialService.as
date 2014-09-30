package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendMaterialService extends BasePacket
	{
		public var MaterialList:Array;
		public var PriceType:String;
		public function SendMaterialService(materialList:Array, PriceType:String = "Money") 
		{
			ID = Constant.CMD_MATERIAL;
			URL = "MaterialService.boostItem";
			MaterialList = [];
			this.PriceType = PriceType;
			var arrElement:Object;
			for (var i:int = 0; i < materialList.length; i++) 
			{
				if (materialList[i] > 0) 
				{
					var r:int = i % 2;
					var q:int = (i / 2 + 1);
					arrElement = new Object();
					arrElement["Num"] = materialList[i];
					arrElement["TypeId"] = q + r*100;
					MaterialList.push(arrElement);
				}
			}
			IsQueue = false;
		}
		
	}

}