package Logic 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameControl.GameController;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.Food;
	/**
	 * ...
	 * @author ...
	 */
	public class FishOceanHappy extends Fish 
	{
		public static const OCEAN_HAPPY_WAIT_CLICK:String = "Gift";
		public static const OCEAN_HAPPY_OK_CLICK:String = "Happy";
		
		public var idTrue:Array;
		public var LastPlayMiniGame:int;
		public var mainFish:FishOceanHappy;
		public var auxiliaryFish:FishOceanHappy;
		public var deltaX:Number;
		public var deltaY:Number;
		public var kind:int;
		public var cycle:Number = 60;
		
		public static const MAIN:int = 0;
		public static const AUXILIARY:int = 1;
		
		private var PrgWaitClick:ProgressBar = null;
		
		public var EmoHappyWait:Sprite = null;
		public var EmoHappyOk:Sprite = null;
		public var prgClock:ProgressBar;
		
		public function FishOceanHappy(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			this.ClassName = "FishOceanHappy";
			aboveContent.cacheAsBitmap = true;
			underContent.cacheAsBitmap = true;
		}
		
		// Các hàm cấn sửa lại
		//{
			//
		//}
		
		override public function FindDes(hasAcceleration:Boolean = true):void 
		{
			//super.FindDes(hasAcceleration);
			var Des:Point = new Point();
			var des:Point = new Point();
			if (kind == MAIN && auxiliaryFish)
			{
				var x:Number = Ultility.PosScreenToLake(0, 0).x;
				Des.x = Ultility.RandomNumber(x, x + img.stage.stageWidth);
				do
				{
					Des.y = CurPos.y + Ultility.RandomNumber( -150, 150);
				}				
				while (	(Des.y < SwimingArea.top || Des.y + auxiliaryFish.deltaY < SwimingArea.top) || 
						(Des.y > SwimingArea.bottom || Des.y + auxiliaryFish.deltaY > SwimingArea.bottom));
				rateDeep = -(Math.random() - curDeep) / Math.abs(Des.x - CurPos.x);		
				PrepareMoving(Des, -1, hasAcceleration);
				
				//if(auxiliaryFish)
				//{
					des.x = Des.x + auxiliaryFish.deltaX;
					des.y = Des.y + auxiliaryFish.deltaY;					
					auxiliaryFish.rateDeep = rateDeep;
					auxiliaryFish.PrepareMoving(des, -1, hasAcceleration);
				//}
			}
		}
		
		public function PlayGame():void 
		{
			if(Emotion == OCEAN_HAPPY_OK_CLICK)
			{
				if(kind == MAIN)
				{
					GuiMgr.getInstance().GuiGameOceanHappy.SetInfo(this);
				}
				else 
				{
					GuiMgr.getInstance().GuiGameOceanHappy.SetInfo(this.mainFish);
				}
				ShowGame();
			}
			else 
			{
				//PrgWaitClick
				var prg:ProgressBar = new ProgressBar("prgWaitClick", "Gift", 0, 0, false, true);
				aboveContent.addChild(prg);
			}
		}
		
		protected function addPrgContent(percent:Number = 0):void 
		{
			//super.addRareContent();
			if (PrgWaitClick == null)
			{
				PrgWaitClick = new ProgressBar ("prgWaitClick", "EmoHappy", 0, 0, false, true);
				PrgWaitClick.setStatus((GameLogic.getInstance().CurServerTime - LastPlayMiniGame) / cycle);
				PrgWaitClick.mouseEnabled = false;
				PrgWaitClick.mouseChildren = false;
				aboveContent.addChild(PrgWaitClick);
				updateAttachContent();
			}
			else 
			{
				if(PrgWaitClick.imgBg)	aboveContent.removeChild(PrgWaitClick.imgBg);
				aboveContent.removeChild(PrgWaitClick.img);
				PrgWaitClick = null;
				PrgWaitClick = new ProgressBar ("prgWaitClick", "EmoHappy", 0, 0, false, true);
				PrgWaitClick.setStatus(percent);
				PrgWaitClick.mouseEnabled = false;
				PrgWaitClick.mouseChildren = false;
				if(PrgWaitClick.imgBg)	aboveContent.addChild(PrgWaitClick.imgBg);
				aboveContent.addChild(PrgWaitClick.img);
				updateAttachContent();
			}
		}
		
		public function ShowGame():void 
		{
			GuiMgr.getInstance().GuiGameOceanHappy.Show(Constant.GUI_MIN_LAYER, 2);
		}
		
		override public function RefreshEmotion():void 
		{
			if (EmoImg != null)
			{
				EmoImg.ClearImage();
				EmoImg.MyFish = null;
			}
			EmoImg = null;
			
			var scale:Number = 0.8;
			switch(Emotion)
			{				
				case OCEAN_HAPPY_OK_CLICK:
					if (kind == MAIN)
					{
						SetSpeed(0.5, 3);
						EmoImg = new EmotionImg(aboveContent , "Gift");
					}
					break;
				case IDLE:
					SetSpeed(0.5, 3);
					break;
			}
			if (EmoImg != null)
			{
				//EmoImg.img.y = -40;
				//EmoImg.img.x = -15;
				EmoImg.SetMyFishOceanHappy(this);
			}		
		}
		
		override public function UpdateFish():void 
		{
			//super.UpdateFish();
			if (kind == MAIN)
			{
				//Update trạng thái di chuyển của cá
				switch(State)
				{
					case FS_IDLE:
						break;
					case FS_SWIM:
						Swim();
						break;
				}	
				
				//Update các content khác đi kèm theo cá
				aboveContent.x = underContent.x = img.x;
				aboveContent.y = underContent.y = img.y;
				
				//Update trạng thái cảm xúc của cá
				UpdateEmotion();
				
				if (!PrgWaitClick)
				{
					if (GameLogic.getInstance().CurServerTime - LastPlayMiniGame < cycle)
					{
						PrgWaitClick = new ProgressBar ("prgWaitClick", "prgAreaSea", 0, 0, true, true);
						aboveContent.addChild(PrgWaitClick);
					}
				}
				else 
				{
					if (GameLogic.getInstance().CurServerTime - LastPlayMiniGame >= cycle)
					{
						aboveContent.removeChild(PrgWaitClick);
						PrgWaitClick = null;
					}
					else 
					{
						if ((GameLogic.getInstance().CurServerTime - LastPlayMiniGame) / cycle > PrgWaitClick.GetStatus() + 0.01)
						{
							PrgWaitClick.setStatus((GameLogic.getInstance().CurServerTime - LastPlayMiniGame) / cycle);
						}
					}
				}
			}
		}
		override public function updateAttachContent():void 
		{
			//super.updateAttachContent();
			if (PrgWaitClick)
			{
				if(kind == MAIN)
				{
					PrgWaitClick.x = auxiliaryFish.deltaX / 2 - PrgWaitClick.img.width / 2;
					PrgWaitClick.y = auxiliaryFish.deltaY / 2 - PrgWaitClick.img.height / 2;
				}
			}
		}
		override public function UpdateEmotion():void 
		{
			switch (Emotion) 
			{
				case IDLE:
					if (CanClick()) 
					{
						SetEmotion(OCEAN_HAPPY_OK_CLICK);
					}
				break;
				case OCEAN_HAPPY_OK_CLICK:
					if(kind == MAIN)
					{
						EmoImg.CurPos.x = (auxiliaryFish.deltaX) / 2 + 15;
						EmoImg.CurPos.y = (auxiliaryFish.deltaY) / 2 + 45;
					}
				break;
			}
			return;
		}
		private function CanClick():Boolean 
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime - LastPlayMiniGame >= cycle)	return true;
			else 	return false;
		}
		override public function Swim(speedFish:int = -1):void 
		{
			super.Swim(speedFish);
			if (kind == MAIN)
			{
				//super.Swim(speedFish);
				UpdateObject();		
				auxiliaryFish.UpdateObject();
				
				updateShadow();
				auxiliaryFish.updateShadow();
				
				var temp:Point = CurPos.subtract(DesPos);
				if (speedFish == -1)
				{
					if (temp.length <= changeSpeedDistance)
					{
						curSpeed -= 0.12;
						if (curSpeed <= 1) 
						{
							curSpeed = 1;
						}
						auxiliaryFish.curSpeed = curSpeed;
					}
					else
					{
						curSpeed += 0.15;
						if (curSpeed >= realMaxSpeed) 
						{
							curSpeed = realMaxSpeed;
						}
						auxiliaryFish.curSpeed = curSpeed;
					}
				}
				else 	
				{
					curSpeed = 2 - ChangCurSpeed;
					auxiliaryFish.curSpeed = curSpeed;
				}
				SpeedVec.normalize(curSpeed);
				auxiliaryFish.SpeedVec.normalize(auxiliaryFish.curSpeed);
				
				CheckSwimingArea();
				
				if (ReachDes) 
				{
					FindDes();
					auxiliaryFish.FindDes();
				}
				
				//if (State == FS_HERD) realMaxSpeed = GameLogic.getInstance().user.FishKing.realMaxSpeed;
				//if(State == FS_HERD) 	realMaxSpeed = GameLogic.getInstance().user.FishKing.realMaxSpeed;
				//if (chatbox)
				//{
					//chatbox.x = this.img.x;
					//chatbox.y = this.img.y - 20;
				//}
				if (chatbox)
				{
					chatbox.x = this.img.x;
					chatbox.y = this.img.y - 20;
				}
			}
			else 
			{
				SwimTo(mainFish.CurPos.x +deltaX, mainFish.CurPos.y +deltaY);
			}
		}
		
		override public function CanCare():Boolean 
		{
			//return super.CanCare();
			//if (GameController.getInstance().typeFishWorld == Constant.OCEAN_HAPPY) 
			//{
				//return true;
			//}
			//else 
			//{
				//return false;
			//}
			return false;
		}
		
		// các hàm không dùng đến
		{
			override public function AcceptGift():void 
			{
				return;
			}
			
			override public function OnDragOver(obj:Object):void 
			{
				return;
				super.OnDragOver(obj);
			}
			
			override public function ChangePeriodEvent(period:int):void 
			{
				return;
			}
			
			override public function CheckFishUpLevel():void 
			{
				return;
			}
			
			override public function EatFood(nFood:Number):void 
			{
				return;
			}
			
			override public function EatMore():Number 
			{
				return 0;
			}
			
			override public function FollowFood(food:Food):void 
			{
				return;
			}
		
			override public function Full():Number 
			{
				return 1;
			}
			
			
			override public function GetLifeTime():Number 
			{
				return HarvestTime;
			}
			
			override public function GetPeriod():int 
			{
				return GROWTH_UP;
			}
			
			override public function GetValue():Number 
			{
				return 0;
			}
			
			override public function Growth():Number 
			{
				return 1;
			}
			
			override public function SetBlink(time:Number):void 
			{
				return;
			}
			
			override public function UpdateHavestTime():void 
			{
				return;
			}
			
			override public function collectBalloon(isSendData:Boolean = true, isAddMoney:Boolean = true, isMagnet:Boolean = false):void 
			{
				//super.collectBalloon(isSendData, isAddMoney, isMagnet);
				return;
			}
			
			override public function getAuraColor():int 
			{
				return 0;
			}
			
			override public function getExp(isGift:Boolean = false):int 
			{
				return 0;
			}
			
			override public function gushBalloon():void 
			{
				return;
			}
			
			override public function initBalloon():void 
			{
				return;
			}
			
			override public function updateGushBall():void 
			{
				return;
			}
		}
	}

}