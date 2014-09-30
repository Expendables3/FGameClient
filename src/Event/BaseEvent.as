package Event 
{
	import flash.media.Sound;
	
	import NetworkPacket.BasePacket;
	import NetworkPacket.PacketReceive.BaseReceivePacket;
	/**
	 * ...
	 * @author ...
	 */
	public class BaseEvent 
	{
		//private const GUI_MAIN_BTN_INVENTORY:String = "1";
		public var IdEvent:int = 0;
		public var CurQuest:EventQuest
		
		public function BaseEvent(data:BaseReceivePacket) 
		{
			OnInitEvent(data);
		}
		
		//public function InitGUI(gui:BaseGUI):void
		//{
			//gui.LoadRes("ImgFrameFriend");						
			//gui.SetPos(190, 90);						
			//gui.AddButtonEx(GUI_MAIN_BTN_INVENTORY, "ButtonInventory", 252, 10, gui);
		//}	
		
		
		public virtual function OnInitEvent(data:BaseReceivePacket):void
		{
			
		}		
		
		public virtual function HandleEventMsg(Type:String, NewData:Object, OldData:Object):void
		{
			
		}
		
		// kiem tra xem 1 action co phai thuoc quest ko
		public function IsEvent(Cmd:BasePacket):Boolean
		{
			var quest:EventQuest;
			// kiem tra du lieu event			
			if (CurQuest.IsEvent(Cmd))
			{
				return true;
			}
			return false;
		}
		
		public function UpdateEvent(cmd:BasePacket, nAction:int = 1):void
		{
			CurQuest.UpdateQuest(cmd, nAction);
		}
	}

}