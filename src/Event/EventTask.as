package Event 
{
	import Logic.TaskInfo;
	/**
	 * ...
	 * @author ...
	 */
	public class EventTask extends TaskInfo
	{	
		public function EventTask() 
		{
			
		}
		
		
		public function isDone():Boolean
		{
			if (Num >= MaxNum)
				return true;
			return false;
		}
	}

}