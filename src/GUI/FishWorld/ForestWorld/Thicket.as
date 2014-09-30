package GUI.FishWorld.ForestWorld 
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import Logic.BaseObject;
	import Logic.FishSoldier;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Thicket extends FishSoldier 
	{
		public const STATE_THICKET_EMPTY:int = 1;
		public const STATE_THICKET_FULL:int = 2;
		public var StateThicket:int = 1;
		public var fishSoldier:FishSoldier;
		public var position:int;
		public function Thicket(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			this.ClassName = "Thicket";
		}
		
		override public function Init(x:int, y:int):void 
		{
			//super.Init(x, y);
			
			Dragable = true;			
			Eated = 0;
			SetDeep(curDeep);		
			if(Ultility.IsInMyFish())
			{
				SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40));
			}
			else 
			{
				//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD - 40));
				SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
			}
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
			ClearImage();
			switch(StateThicket)
			{
				case STATE_THICKET_EMPTY:
					LoadRes("LoadingForestWorld_ImgThicketEmpty");
				break;
				case STATE_THICKET_FULL:
					LoadRes("LoadingForestWorld_ImgThicketFull");
				break;
			}
			
			img.scaleX = OrientX*Scale;
			img.scaleY = Scale;
			
			sortContentLayer();			

			//Add bóng
			var isDeadFish:Boolean = (Emotion == DEAD);
			if ((shadow == null) && !isDeadFish)
			{
				shadow = ResMgr.getInstance().GetRes("FishShadow") as Sprite;				
				Parent.addChild(shadow);
				shadow.x = img.x;
				shadow.y = GameController.getInstance().GetLakeBottom() - curDeep * SHADOW_SCOPE;
				shadow.scaleY = 0.7;
			}
			
			if ((shadow != null) && isDeadFish)
			{
				Parent.removeChild(shadow);
			}
		}
	}

}