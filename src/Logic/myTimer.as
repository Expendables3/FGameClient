package Logic 
{
	/**
	 * ...
	 * @author ...
	 */
	public class myTimer 
	{
		public var delay:Number;	//thời gian delay của timer đơn vị là ms;
		public var startTime:Number;
		public var isRun:Boolean;
		public var functionFinish:Function;
		public var Id:String;
		public function myTimer(IdTimer:String, Delay:Number, f:Function) 
		{
			delay = Delay;
			Id = IdTimer;
			isRun = false;
			functionFinish = f;
		}
		public function Reset():void 
		{
			startTime = GameLogic.getInstance().CurServerTime * 1000;
			isRun = false;
			var arr:Array = GameLogic.getInstance().arrMyTimer;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:myTimer = arr[i];
				if (item.Id == Id)
				{
					arr.splice(i, 1);
				}
				break;
			}
		}
		public function ReSetDelay(Delay:Number):void 
		{
			delay = Delay;
		}
		public function Start():void 
		{
			startTime = GameLogic.getInstance().CurServerTime * 1000;
			isRun = true;
			GameLogic.getInstance().arrMyTimer.push(this);
		}
		public function Finish():void 
		{
			isRun = false;
			functionFinish();
		}
	}

}