package Event.EventNoel.NoelGui.FishNoel 
{
	import com.greensock.TweenMax;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.display.Sprite;
	import Logic.Ultility;
	
	/**
	 * con cá mặt trời, bơi nhanh
	 * @author HiepNM2
	 */
	public class FishFast extends FishAbstract 
	{
		
		public function FishFast(parent:Object, fishInfo:FishAbstractInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, fishInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "FishFast";
			_realMaxSpeed = 5;// Ultility.RandomNumber(3, 5);
		}
		override public function effBleed():void 
		{
			super.effBleed();
		}
		override public function OnLoadResComplete():void 
		{
			var cl:int = 0xffff00;
			TweenMax.to(img, 1, { glowFilter: { color:cl, alpha:1, blurX:20, blurY:20, strength:1.5 }} );
			
			super.OnLoadResComplete();
		}
	}

}



























