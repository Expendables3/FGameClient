package Event.EventNoel.NoelGui.ItemGui.EffectEvent 
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import Logic.MotionObject;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class EffChest extends MotionObject 
	{
		private var _rank:int;
		private var spRank:Sprite;
		public function EffChest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, Num:int = 0, Rank:int = 0) 
		{
			_rank = Rank;
			super(parent, imgName, x, y, isLinkAge, imgAlign, Num);
			ClassName = "EffChest";
			
		}
		override public function OnLoadResComplete():void 
		{
			//thực hiện vẽ thêm Rank vào
			if (spRank == null)
			{
				spRank = ResMgr.getInstance().GetRes("ImgLaMa" + _rank) as Sprite;
				img.addChild(spRank);
				spRank.x = 0;
				spRank.y = img.height - 10;
			}
		}
		override public function removeSelf():void 
		{
			img.removeChild(spRank);
			spRank = null;
			super.removeSelf();
		}
	}

}
























