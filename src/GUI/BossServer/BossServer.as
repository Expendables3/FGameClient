package GUI.BossServer 
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import GameControl.GameController;
	import Logic.FishSoldier;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class BossServer extends FishSoldier 
	{
		private var bossImgName:String;
		
		public function BossServer(parent:Object = null, imgName:String = "Fish300_Old_Idle") 
		{
			super(parent, imgName);
			bossImgName = imgName;
		}
		
		override public function Init(x:int, y:int):void 
		{
			FishType = FISHTYPE_SOLDIER;
			isActor = ACTOR_THEIRS;
			Dragable = false;			
			Eated = 0;
			SetDeep(curDeep);		
			SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
			
			SetPos(x, y);
			
			if (y < SwimingArea.top)
			{
				SetMovingState(FS_FALL);
			}
			else if (!isInRightSide)
			{	
				SetMovingState(FS_SWIM);
				FindDes(false);
			}	
			
			RefreshImg();
		}
		
		override public function RefreshImg():void 
		{
			LoadRes(bossImgName);
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			
		}
		
		override public function Swim(speedFish:int = -1):void 
		{
			super.Swim(speedFish);
			GuiFishStatus.Hide();
		}
	}

}