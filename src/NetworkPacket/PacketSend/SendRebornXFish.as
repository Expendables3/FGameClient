package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendRebornXFish extends BasePacket 
	{
		public var TypeFish:String;
		public var TypeMedicine:int;
		public var IdFish:int;
		public var IdLake:int;
		
		public function SendRebornXFish(typeFish:String,typeMedicine:int,idFish:int,idLake:int) 
		{
			ID = "";
			URL = "ItemService.rebornXFish";
			this.TypeFish = typeFish;
			this.TypeMedicine = typeMedicine;
			this.IdFish = idFish;
			this.IdLake = idLake;
		}
		
	}

}