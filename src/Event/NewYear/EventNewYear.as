package Event.NewYear 
{
	import Event.BaseEvent;
	import Event.EventMgr;
	import Event.EventQuest;
	import Event.EventTask;
	import Logic.Layer;
	import Logic.LayerMgr;
	import NetworkPacket.BasePacket;
	import NetworkPacket.PacketReceive.BaseReceivePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EventNewYear extends BaseEvent 
	{
		
		public function EventNewYear(data:BaseReceivePacket)
		{
			super(data);
			IdEvent = EventMgr.EVENT_NEW_YEAR;
		}
		
		public override function OnInitEvent(data:BaseReceivePacket):void
		{
			// cay tre tram dot
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var bamboo:BamBoo = new BamBoo(layer, 500, 700, 0);
			
			//Khoi tao thong tin quest trong event
			//CurQuest.UpdateInfoQuest(data);
			CurQuest = new EventQuest();
			InitStep(1);
		}
		
		
		public function InitStep(step:int):void
		{
			CurQuest.Id = 0;
			switch(step)
			{
				case 0:
					break;
				case 1:
					//Nhiem vu nhat dot tre
					var task:EventTask = new EventTask();
					task.Id = 1;
					task.Num = 5;//So dot tre nhat duoc
					task.MaxNum = 20;
					CurQuest.TaskList.push(task);
					
					//Nhiem vu lap ghep cay tre
					task = new EventTask();
					task.Id = 2;
					task.Num = 4; //So dot tre da lap ghep
					task.MaxNum = 20;
					CurQuest.TaskList.push(task);
					break;
				case 2:
					break;
			}
		}
		
		public override function HandleEventMsg(Type:String, NewData:Object, OldData:Object):void
		{
			UpdateEvent(OldData as BasePacket);
		}
		
	}

}