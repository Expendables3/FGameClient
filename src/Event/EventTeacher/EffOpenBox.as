package Event.EventTeacher 
{
	import Effect.SwfEffect;
	import Logic.BaseObject;
	
	/**
	 * can thiệp vào frame để cho chữ bay ra
	 * @author HiepNM2
	 */
	public class EffOpenBox extends SwfEffect 
	{
		private const FRAME_JOIN:int = 13;
		private var joined:Boolean = false;
		public var funcJoin:Function = null;
		public function EffOpenBox(parent:Object, swfName:String, ChildList:Array=null, x:Number=0, y:Number=0, ReUse:Boolean=false, IsLoop:Boolean=false, ObjUse:BaseObject=null, f:Function=null) 
		{
			super(parent, swfName, ChildList, x, y, ReUse, IsLoop, ObjUse, f);
			joined = false;
		}
		override public function UpdateEffect():void 
		{
			super.UpdateEffect();
			if (!joined && funcJoin != null)
			{
				if (img.currentFrame > FRAME_JOIN)
				{
					joined = true;
					funcJoin();
				}
			}
		}
	}

}