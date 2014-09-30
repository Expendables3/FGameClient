package NetworkPacket.PacketSend 
{
	import flash.sampler.NewObjectSample;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendUseItemSoldier extends BasePacket 
	{
		public var LakeId:int;
		public var FishId:int;
		public var ItemList:Array;
		//ItemType 	  	 
		//ItemId 	  	 
		//Num
		
		public function SendUseItemSoldier(LId:int, FId:int) 
		{
			ID = Constant.CMD_USE_ITEM_SOLDIER;
			URL = "ItemService.useItemSoldier";
			LakeId = LId;
			FishId = FId;
		}
		
		public function SetItemList(IType:String, IId:int, N:int, T:int):void
		{
			ItemList = [];
			var o:Object = new Object();
			o.ItemType = IType;
			o.ItemId = IId;
			o.Num = N;
			o.Turn = T;
			ItemList.push(o);
		}
	}

}