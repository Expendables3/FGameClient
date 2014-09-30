package GUI.GuiGetStatus 
{
	import Event.EventNoel.NoelPacket.SendFireGun;
	import Event.EventNoel.NoelPacket.SendGotoSea;
	import NetworkPacket.BasePacket;
	
	/**
	 * gói lấy thông tin chung
	 * 		dùng để lấy thông tin cho những họ GUI khởi tạo sau khi nhận dữ liệu từ server về
	 * @author HiepNM2
	 */
	public class SendGetStatus extends BasePacket 
	{
		public function SendGetStatus(url:String,id:String) 
		{
			URL = url;
			ID = id;
			IsQueue = false;
		}
		
		static public function createPacket(url:String, id:String, data:Object = null):SendGetStatus
		{
			switch(url)
			{
				case"EventService.getBoardGame":
					//var idMap:int = data["IdMap"];
					//var idBoard:int = data["IdBoard"];
					var isPlayNow:Boolean = data["IsPlayNow"];
					return new SendGotoSea(url, id, isPlayNow/*, idMap, idBoard*/);
				case "EventService.fireGun":
					var boardId:int = data["BoardId"];
					var key:int = data["Key"];
					var info:Array = data["FireInfo"];
					return new SendFireGun(url,id,boardId, info, key);
				default:
					return new SendGetStatus(url, id);
			}
		}
	}

}
















