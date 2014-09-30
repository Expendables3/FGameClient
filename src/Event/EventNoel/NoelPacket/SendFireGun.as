package Event.EventNoel.NoelPacket 
{
	import GUI.GuiGetStatus.SendGetStatus;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendFireGun extends SendGetStatus 
	{
		public var BoardId:int;
		public var FireInfo:Array;				//mảng thông tin bắn được batch lại nha
		public var Key:int;
		public function SendFireGun(url:String,id:String,boardId:int, info:Array, key:int) 
		{
			super(url, id);
			//URL = "EventService.fireGun";
			//ID = Constant.CMD_SEND_FIRE_GUN;
			BoardId = boardId;
			FireInfo = info;
			Key = key;
			//IsQueue = false;
		}
		
	}

}