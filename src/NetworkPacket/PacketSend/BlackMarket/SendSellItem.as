package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendSellItem extends BasePacket 
	{
		public var Type:String;
		public var ItemType:String;
		public var ItemId:int;
		public var Num:int;
		public var PriceTag:Object;
		public var Duration:Number;
		public var Position:int;
		
		public function SendSellItem(_type:String, _itemType:String, _itemId:int, _num:int, _priceTag:Object, _duration:Number, _position:int) 
		{
			ID = Constant.CMD_SELL_ITEM;
			URL = "MarketService.sellItem";
			Type = _type;
			ItemType = _itemType;
			ItemId = _itemId;
			Num = _num;
			PriceTag = _priceTag;
			Duration = _duration;
			Position = _position;
			IsQueue = false;
		}
		
	}

}