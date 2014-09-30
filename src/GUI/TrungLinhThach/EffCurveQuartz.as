package GUI.TrungLinhThach 
{
	import Logic.MotionObject;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class EffCurveQuartz extends MotionObject 
	{
		
		public function EffCurveQuartz(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, Num:int=0) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, Num);
			ClassName = "EffCurveText";
		}
		override public function fall(DesY:int, Gravity:Number = 4, ExistTime:Number = 2):void 
		{
			super.fall(DesY, Gravity, ExistTime);
			SpeedVec.x = Ultility.RandomNumber(-15, 2);
		}
		override public function curve(x:int, y:int, dir:int, forceTimeOut:Number = 0, force:Number = 3, turnSpeed:Number = 0, Friction:Number = 1.00):void 
		{
			super.curve(x, y, dir, forceTimeOut, force, turnSpeed, Friction);
			
		}
	}

}