package Event.EventNoel.NoelGui.FishNoel 
{
	import com.greensock.TweenMax;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.display.Sprite;
	import Logic.Ultility;
	
	/**
	 * Con boss
	 * @author HiepNM2
	 */
	public class FishBoss extends FishAbstract 
	{
		
		public function FishBoss(parent:Object, fishInfo:FishAbstractInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			//super(parent, fishInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			super(parent, fishInfo, x, y, isLinkAge, imgAlign, true, SetInfo, ImageId);
			ClassName = "FishBoss";
			_realMaxSpeed = Ultility.RandomNumber(4, 5);
		}
		override public function effBleed():void 
		{
			var ptr:Sprite = img;
			var showAgain:Function = function():void
			{
				inFired = false;
				ptr = null;
			}
			TweenMax.to(ptr, 0.2, { colorTransform: { tint:0x000000, tintAmount:0 }, onComplete:showAgain } );
			var compBlack3:Function = function():void
			{
				TweenMax.to(ptr, 0.2, { colorTransform: { tint:0xffffff, tintAmount:0 }, onComplete:showAgain } );
			}
			var compWhite2:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0x000000, tintAmount:0.7}, onComplete:compBlack3});
			}
			var compBlack2:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0xffffff, tintAmount:0.7}, onComplete:compWhite2});
			}
			var compWhite1:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0x000000, tintAmount:0.7}, onComplete:compBlack2});
			}
			var compBlack1:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0xffffff, tintAmount:0.7}, onComplete:compWhite1});
			}
			TweenMax.to(ptr, 0.1, {colorTransform:{tint:0x000000, tintAmount:0.7}, onComplete:compBlack1});
		}
	}

}