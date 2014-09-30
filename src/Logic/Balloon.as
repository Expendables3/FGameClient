package  Logic
{
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import Logic.BaseObject;
	/**
	 * ...
	 * @author tuannm3
	 */
	public class Balloon extends BaseObject
	{
		public static const BL_BUBBLE:int = 1;
		public static const	BL_BOB:int = 2;
		public static const	BL_FLY:int = 3;		
		
		public var movingState:int;
		public var waterSurface:int;
		public var friction:Number;
		public var scale:Number;
		public var scaleSpeed:Number;
		public var myFish:Fish = null;
		public var alphaSpeed:Number = 0;
		public var isStop:Boolean = false;
		
		public var idSortX:Number;
		
		public function Balloon(parent:Object = null, imgName:String = "")
		{
			super(parent, imgName);
			this.ClassName = "Balloon";
			
			movingState = 0;
			SpeedVec = new Point();
			CurPos = new Point();
			waterSurface = 0;
			friction = 0;
			scale = 1;
			scaleSpeed = 0;
			isStop = false;
		}
		
		public function setMyFish(fish:Fish):void
		{
			myFish = fish;
		}
		
		public function setMovingState(state:int):void
		{
			movingState = state;
		}
		
		public function updateBalloon():void
		{
			if (isStop) return;
			idSortX = CurPos.x;
			switch(movingState)
			{
				case BL_BUBBLE: 
					bubble();
					if (scale < 1)
					{
						scale += scaleSpeed;
						img.scaleX = img.scaleY = scale;
					}
					break;
				case BL_BOB:
					bob();
					if (scale < 1)
					{
						scale += scaleSpeed;
						img.scaleX = img.scaleY = scale;
					}
					break;
				case BL_FLY:
					fly();
					break;
			}
		}
		
		public function setBuble(DirInit:Point, WaterSurface:int):void
		{
			setMovingState(BL_BUBBLE);
			SpeedVec.x = DirInit.x;
			SpeedVec.y = DirInit.y;
			waterSurface = WaterSurface;
			friction = 0.04;
			img.scaleX = img.scaleY = scale = 0.2;
			scaleSpeed = Math.random() * 0.03 + 0.02;
		}
		
		private function bubble():void
		{
			if (CurPos.y <= waterSurface)
			{
				setBob(waterSurface);
				return;
			}			
				
			CurPos.x += SpeedVec.x;
			SpeedVec.x *= (1 - friction);
			
			var fAcsimet:Number = -5;
			CurPos.y += SpeedVec.y + fAcsimet;
			SpeedVec.y *= (1 - friction);	
			
			SetPos(CurPos.x, CurPos.y);
		}
		
		public function setBob(WaterSurface:int):void
		{
			setMovingState(BL_BOB);
			SpeedVec.y = -1;
			waterSurface = WaterSurface;
		}
		
		protected function bob():void
		{
			if (CurPos.y <= waterSurface - 7)
			{
				SpeedVec.y = Math.random() * 0.3 + 0.2;
			}
			else if(CurPos.y >= waterSurface + 7)
			{
				SpeedVec.y = -(Math.random() * 0.3 + 0.2);
			}
			CurPos.y += SpeedVec.y;
			SetPos(CurPos.x, CurPos.y);
		}		
		
		
		public function setFly():void
		{
			setMovingState(BL_FLY);
			SpeedVec.y = -4;
			scaleSpeed = 0.35;
			alphaSpeed = 0.05;
		}
		
		private function fly():void
		{
			if (scale >= 1)
			{
				scale = 1;
				scaleSpeed = -0.35;
			}
			else if (scale <= -1)
			{
				scale = -1;
				scaleSpeed = 0.35;
			}
			scale += scaleSpeed;
			img.alpha -= alphaSpeed;
			img.scaleX = scale;
			CurPos.y += SpeedVec.y;
			SetPos(CurPos.x, CurPos.y);
		}
		
		public function getValue():int
		{
			if(myFish)
				return myFish.moneyBalloon;
			return 0;
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			//setFly();
			collect();
		}
		
		public function collect(isSendData:Boolean = true, isAddMoney:Boolean = true,isMagnet:Boolean=false):void
		{
			myFish.collectBalloon(isSendData, isAddMoney,isMagnet);
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffMoneyBalloon", null, CurPos.x - 57, CurPos.y - 22);
			
			//Effect số tiền bay lên
			var child:Sprite = new Sprite();
			var color:int = 0xffff00;
			var txtFormat:TextFormat = new TextFormat("SansationBold", 22, color, true);
			txtFormat.align = "left";
			txtFormat.font = "SansationBold";
			child.addChild(Ultility.CreateSpriteText("+" +myFish.moneyBalloon.toString() , txtFormat, 6, 0, true));					
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child) as ImgEffectFly;
			var pos:Point = Ultility.PosLakeToScreen(CurPos.x, CurPos.y)
			eff.SetInfo(pos.x + 7, pos.y + 10, pos.x + 7, pos.y - 25 + 5, 3);	
			
			//Hủy bong bóng
			myFish = null;
			Destructor();
		}
		
		override public function OnDestructor():void
		{
			var balloonArr:Array = GameLogic.getInstance().balloonArr;
			var i:int = balloonArr.indexOf(this);
			ClearImage();
			balloonArr.splice(i, 1);	
			myFish = null;
		}
		
		override public function OnMouseOver(event:MouseEvent):void 
		{
			isStop = true;
			SetHighLight();
		}
		
		override public function OnMouseOut(event:MouseEvent):void 
		{
			isStop = false;
			SetHighLight(-1);
		}
	}

}