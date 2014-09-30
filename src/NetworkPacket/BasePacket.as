package NetworkPacket 
{
	/**
	 * ...
	 * @author ...
	 */
	import Data.INI;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	public class BasePacket
	{
		public 		var IsQuest:Boolean 		= false;
		public 		var IsExpeditionQuest:Boolean = false;//kiểm tra quest viễn chinh
		protected 	var IsMerge:Boolean 		= false;
		protected 	var URL:String;
		protected 	var ID:String;
		protected 	var SendTimer:Timer;
		protected	var TimeOutSend:int = 1000;
		protected	var IsQueue:Boolean 		= true;
		public		var IsEvent:Boolean 		= false;
		public		var timeStamp:Number		= 0;
		
		public function BasePacket() 
		{
			URL = INI.getInstance().getPostUrl();
		}
		
		public function GetURL():String
		{
			return URL;
		}
		
		public function GetID():String
		{
			return ID;
		}
		
		public function getAPI():String
		{
			if (URL != null)
			{
				return URL.split(".")[1];
			}
			return "";
		}
		
		public function IsMergedPacket():Boolean
		{
			return IsMerge;
		};
		
		public function IsMustQueue():Boolean
		{
			return IsQueue;
		};
		
		public function ActivateTimer(Handler:Function):void 
		{
			if (IsMerge)
			{
				SendTimer = new Timer(TimeOutSend, 1);
				SendTimer.start();
				SendTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Handler);				
			}
		}
		
		public function RemoveTimer(Handler:Function):void
		{
			SendTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, Handler);
		}
	}

}