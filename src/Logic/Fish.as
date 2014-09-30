package  Logic
{
	import adobe.utils.CustomActions;
	import com.adobe.utils.IntUtil;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import com.greensock.TweenMax;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.ColorCorrection;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	import flash.events.*;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishWings;
	import GUI.FishWorld.FishWorldController;
	import GUI.GUIFishStatus;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import NetworkPacket.PacketReceive.GetInitRun;
	import NetworkPacket.PacketSend.SendAttackFriendLake;
	import NetworkPacket.PacketSend.SendCollectMoney;
	import NetworkPacket.PacketSend.SendFishUpLevel;
	import particleSys.myFish.GhostEmit;
	import particleSys.sample.StarEmit;
	
	import particleSys.sample.MusicEmit;
	import particleSys.sample.MusicStarEmit;
	import Sound.SoundMgr;
	import NetworkPacket.PacketSend.SendFishChangeLake;
	import NetworkPacket.PacketSend.SendGetGiftOfFish;
	/**
	 * Lớp cá kế thừa từ lớp BaseObject
	 * @author tuan
	 */
	public class Fish extends BaseObject
	{
		//public var wings:Sprite;
		public var wings:FishWings;
		//Define các hằng số begin
		public static const GROWTH_UP:int = 5;
		public static const RADIUS: int = 150;
		public static const FS_IDLE:int = 0;
		public static const FS_SWIM:int = 1;
		public static const FS_FALL:int = 2;
		public static const FS_RETURN:int = 3;
		public static const FS_HERD: int = 4;
		public static const FS_CHASE:int = 5;
		public static const FS_STANDBY:int = 6;
		public static const FS_WAR:int = 7;
		public static const FS_ATTACK:int = 8;
		public static const FS_PRE_DEAD:int = 9;
		public static const FS_A_TO_B:int = 10;

		public static const EGG:String = "Egg";
		public static const BABY:String = "Baby";
		public static const OLD:String = "Old";
		
		public static const HAMMER:String = "Hammer";
		public static const IDLE:String = "Idle";
		public static const HAPPY:String = "Happy";
		public static const SAD:String = "Sad";
		public static const ILL:String = "Ill";
		public static const LOVE:String = "Love";
		public static const HUNGRY:String = "Hungry";
		public static const GIFT:String = "Gift";
		public static const DOMAIN:String = "domain";
		public static const DOMAIN_1:String = "domain1";
		public static const DOMAIN_2:String = "domain2";
		public static const DOMAIN_3:String = "domain3";
		public static const DOMAIN_4:String = "domain4";
		public static const DOMAIN_5:String = "domain5";
		public static const CANCARE:String = "Cancare";
		public static const ATTACKED:String = "Attacked";
				
		public static const AURA_COLOR_EXP:int = 0x66ffff;
		public static const AURA_COLOR_OTHER:int = 0xff00ff;
		public static const AURA_COLOR_MIX:int = 0x00ff00;
		public static const AURA_COLOR_GOLD:int = 0xffff00;
		
		public static const OPTION_MONEY:String = "Money";
		public static const OPTION_MIX_RARE:String = "MixFish";
		public static const OPTION_MIX_SPECIAL:String = "MixSpecial";
		public static const OPTION_EXP:String = "Exp";
		public static const OPTION_TIME:String = "Time";
		
		public static const FISHTYPE_NORMAL:int 		= 0;
		public static const FISHTYPE_SPECIAL:int 		= 1;
		public static const FISHTYPE_RARE:int 			= 2;
		public static const FISHTYPE_SOLDIER:int		= 3;
		//public static const FISHTYPE_ACTOR_MINE:int		= -1;
		//public static const FISHTYPE_ACTOR_THEIRS:int	= -2;
				
		
		public static var gushBallTime:int 				= 0;				
		public static const ItemType:String = "Fish";		
		public static const HUNGRY_THRESOLD:Number = 0.24;		
		public static const SCALE_BABY:Number = 0.7;// 0.55;
		public static const SCALE_OLD:Number = 1;// 0.85;
		public static const SHADOW_SCOPE:int = 80;		
		
		public static const FISH_LEVEL_REQUIRE_MAX:int = 40;
		//Define các hằng số end
		
		public static var maxFood:int = 0;// INI.getInstance().getGeneralInfo("Fish", "MaxFood");
		public static var AffectTime:int = 0;// INI.getInstance().getGeneralInfo("Food", "AffectTime");
		public static var Terms:int = 0;// INI.getInstance().getGeneralInfo("Fish", "Terms")	
		public var limitedBalloon:int = 0; //Số bong bóng 
		public var moneyBalloon:int = 0;
		
		public var SwimingArea:Rectangle = new Rectangle(0, 0, 0, 0);
		public var State:int = FS_IDLE;
		public var AgeState:String = BABY;
		public var Emotion:String = IDLE;
		public var CenterPos:Point = new Point();
		public var OrientX:int = 1;
		public var Scale:Number = SCALE_BABY;
		
		//Các content đi kèm cá
		public var underContent:Sprite = new Sprite();					//Layer add những conent đi kèm cá mà nằm dưới content cá
		public var aboveContent:Sprite = new Sprite();					//Layer add những conent đi kèm cá mà nằm dưới content cá
		public var effLevelFish:Sprite = null;
		public var effSpecialFish:Sprite = null;
		public var effRareFish:Sprite = null;
		public var EmoBaby:Sprite = null;
		public var musicEmit:MusicEmit;
		public var ghostEmit:GhostEmit;
		//public var starEmit:StarEmit;
		
		public var MinSpeed:Number = 1;
		public var MaxSpeed:Number = 5;
		public var realMaxSpeed:Number = 0;
		public var curSpeed:Number = 0;
		public var SetcurSpeed:Number = 0;
		public var changeSpeedDistance:Number = 0;
		
		public var EmoImg:EmotionImg = null;
		public var EmoLifeTime:Number = 0;
		public var GuiFishStatus:GUIFishStatus = new GUIFishStatus(null, "");
		public var IsHide:Boolean = false;
		public var Period:int = 0;
		public var BlinkNumber:int = 0;
		public var AgeTime:int;
		public var HarvestTime:int;
		public var EggTime:int;
		public var Eated:int;
		public var myFood:Food = null;
		public static var dragingFish:Fish = null;
		
		//Data lay tu server ve
		public var FeedAmount:Number = 0;
		public var FishTypeId:int;						//Loại cá gì: cá mòi, cá voi...
		public var Id:int;								//Id của cá đó trong data base
		public var FishType:int = FISHTYPE_NORMAL;		//Cá thường, cá đặc biệt hay cá quý
		public var LastBirthTime:int;
		public var LastPeriodCare:int;
		public var LastPeriodStim:int
		public var Name:String;
		public var OriginalStartTime:Number;
		public var Sex:int; 							// = 1 là đực, 0 là cái
		public var StartTime:Number;
		public var IsEgg:Boolean = false;
		public var MoneyPocket:int;
		public var TotalBalloon:int;
		public var ThiefList:Array = [];
		public var ColorLevel:int = 0;
		public var ColorEdit:String  = '';
		public var MoneyAttacked:int;
		public var Level:int;							//Level của cá, ban đầu bằng level require, với cá quý cá đặc biệt level này sẽ tăng lên sau mỗi chu kỳ vòng đời
		//public var LevelRequire:int;
		public var RateMate:Object;
		public var RateOption:Object;
		public var LastGetLevelGift:Number;		
		public var LakeId:Number;		
		public var LevelUpGift:Array = [];
		public var PocketStartTime:Number;
		
		// kiem tra ca dau dan
		public var IsFishKing:Boolean = false;
		public var ChangCurSpeed:int = 0;
		public var isCreatePocket:Boolean = false;
		
		//Bóng cá
		public var curDeep:Number = Math.random();
		public var rateDeep:Number = 0;
		protected var shadow:Sprite = null;
		
		public var rateGrowAge:int;
		public var NumUpLevel:int;
		public var isSendLevelUP:Boolean = false;
		public var ViagraUsed:int = 0;
		public var LastTimeViagra:Number;
		
		public var isInRightSide:Boolean = false;			//check xem đến vị trí đánh nhau chưa
		public var Material:Array = [];
		public var numMatUse:int = 0;
		
		// Đi loăng quăng 
		public var posA:Point;		// Điểm A
		public var posB:Point;		// Điểm B
		public var AtoBTime:int;	// Số lần chạy loăng quăng
		
		//Số bong bóng đã nhả
		public var balloonNum:int;
		
		public function Fish(parent:Object = null, imgName:String = "", isToBitMap:Boolean = false)
		{
			super(parent, imgName , 0, 0, true, ALIGN_LEFT_TOP, isToBitMap);
			this.ClassName = "Fish";
			aboveContent.cacheAsBitmap = true;
			aboveContent.mouseEnabled = false;
			underContent.cacheAsBitmap = true;
			IsEgg = false;
			
			RateMate = new Object();
			
			
		}		
		
		public function Init(x:int, y:int):void
		{
			//trace("Init ------")
			Dragable = true;			
			Eated = 0;
			SetDeep(curDeep);		
			if (Ultility.IsInMyFish())
			{
				if(!GameController.getInstance().isSmallBackGround)
				{
					SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
				else
				{
					SetSwimingArea(new Rectangle(275, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
			}
			else 
			{
				//SetSwimingArea(new Rectangle(0, 0, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
				SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
			}
			HarvestTime = ConfigJSON.getInstance().getFishHarvest(FishTypeId, FishType, this);
			// Dành cho cá có tuổi và trưởng thành khác nhau
			//AgeTime = ConfigJSON.getInstance().getFishHarvest(FishTypeId, FishType, this, true);
			EggTime = ConfigJSON.getInstance().getEggTime(FishTypeId);
			//Level = INI.getInstance().getItemInfo(FishTypeId.toString(), ItemType)["levelRequire"];
			
			moneyBalloon = ConfigJSON.getInstance().getItemInfo(ItemType, FishTypeId)["StealOnce"];
			limitedBalloon = ConfigJSON.getInstance().getItemInfo(ItemType, FishTypeId)["MaxSteal"]/ moneyBalloon;
				
			/*//Dung xoa phan nay nhe, vi con dung de debug
			var area:Sprite = new Sprite();
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var rect:Rectangle = new Rectangle(SwimingArea.left + layer.x, SwimingArea.top + layer.y, SwimingArea.width, SwimingArea.height);
			area.graphics.lineStyle(1);
			area.graphics.moveTo(rect.left, rect.top);
			area.graphics.lineTo(rect.right, rect.top);				
			area.graphics.lineTo(rect.right, rect.bottom);
			area.graphics.lineTo(rect.left , rect.bottom);
			area.graphics.lineTo(rect.left, rect.top);
				
			LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.addChild(area);*/
			initConstant();
			SetPos(x, y);
			if (!IsEgg)
			{
				if (y < SwimingArea.top)
				{
					SetMovingState(FS_FALL);
				}
				else
				{	
					SetMovingState(FS_SWIM);
					FindDes(false);
					//trace("FindDes trong Fish.Init");
				}			
			}
			else
			{
				var r:Rectangle = GameController.getInstance().GetDecorateArea();
				SetDeep(1-(CurPos.y + this.img.height - r.top) / (r.height));
			}
			
			if (FishType != FISHTYPE_SOLDIER)
			{
				var obj:Object = ConfigJSON.getInstance().getItemInfo("Fish", FishTypeId);
				if (Level == 0) Level = ConfigJSON.getInstance().getItemInfo("Fish", FishTypeId)["LevelRequire"];
				NumUpLevel = Level - ConfigJSON.getInstance().getItemInfo("Fish", FishTypeId)["LevelRequire"];
				RateMate = ConfigJSON.getInstance().getInfoRateMate(FishTypeId, FishType);	
			}
			
			if (FishType == FISHTYPE_NORMAL)
			{
				LastGetLevelGift = 0;
			}
			
			RefreshImg();
			// Dành cho cá có tuổi và trưởng thành khác nhau
			//if (NumUpLevel > 0 && FishType != FISHTYPE_NORMAL)
			//{
				//HarvestTime = AgeTime;
			//}		
		}
		
		public static function initStaticFish():void
		{
			maxFood = INI.getInstance().getGeneralInfo("Fish", "MaxFood");
			AffectTime = INI.getInstance().getGeneralInfo("Food", "AffectTime");
			Terms = INI.getInstance().getGeneralInfo("Fish", "Terms");			
			gushBallTime = ConfigJSON.getInstance().GetItemList("Param")["PocketTime"];
		}
		
		public function initConstant():void
		{
			
		}		
		
		/**
		 * 
		 */
		
		public override function OnReloadRes():void
		{
			super.OnReloadRes();
			Init(CurPos.x, CurPos.y);
			if (FishType != FISHTYPE_SOLDIER)
			{
				UpdateHavestTime();
			}
			
			img.mouseChildren = false;
			UpdateColor();
		}
		
		
		public override function OnLoadResComplete():void
		{
			super.OnLoadResComplete();
			var mc:MovieClip = img as MovieClip;
			mc.gotoAndPlay(Math.ceil(Math.random() * (mc.totalFrames-1)));		
		}
		
		/**
		 * Set độ sâu cho cá
		 * @param	deep
		 */
		public function SetDeep(deep:Number):void
		{
			if (curDeep == deep)
			{
				return;
			}
			curDeep = deep;			
			//img.scaleX = OrientX*Scale*(0.6 + 0.4 * (1 - deep));
			//img.scaleY = Scale*(0.6 + 0.4 * (1 - deep));
			var t:Transform = img.transform;
			var c:ColorTransform = new ColorTransform(0.4+0.6*(1-deep), 0.4+0.6*(1-deep), 0.8+0.2*(1-deep), 1);
			img.transform.colorTransform = c;
		}
		
		
		/**
		 * 
		 * @param	time
		 */
		public function LevelUp(time:Number):void 
		{
			
		}
		
		/**
		 * Hàm thực hiện khi trời tối
		 * @param	dark
		 */
		public function Blink(dark:Boolean):void
		{
			var c:ColorTransform ;
			if (dark)
			{
				c = new ColorTransform(0.4, 0.4, 0.4, 1);				
			}
			else
			{
				c = new ColorTransform(1, 0.8, 0.3 , 1);
				c.redOffset   = 100;
				c.greenOffset = 100;
				c.blueOffset  = 100;
			}
			img.transform.colorTransform = c;
		}
		
		/**
		 * 
		 * @param	time
		 */
		public function SetBlink(time:Number):void
		{
			var delay:Number = 150;
			BlinkNumber = time * 1000 / delay;
			var timer:Timer = new Timer(delay, BlinkNumber);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			function timerListener (e:TimerEvent):void
			{
				BlinkNumber--;
				if (BlinkNumber % 2 == 0)
				{
					Blink(true);
				}
				else
				{
					Blink(false);
				}
			}
			timer.start();
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
			function timerDone(e:TimerEvent):void
			{
				var c:ColorTransform = new ColorTransform(1, 1, 1, 1);
				img.transform.colorTransform = c;
				timer.removeEventListener(TimerEvent.TIMER, timerListener);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
			}
		}		
			
		// Hàm set tốc độ của cá đầu đàn
		public function SetSpeedHerd(Cur:Number):void
		{
			ChangCurSpeed = 2 - Cur;
		}
		
		// Hàm set tốc độ cá
		public function SetSpeed(Min:Number, Max:Number):void
		{
			MinSpeed = Min;
			MaxSpeed = Max;
		}
		
		// Hàm xét trạng thái phát triển của cá, để set hình dáng của cá
		public function SetAgeState(ageState:String):void
		{
			if (AgeState == ageState)
			{
				return;
			}
			
			// giai đoạn trứng nở thành cá
			// Ngay trước khi trứng nở thành cá (chưa được gán là cá) thì cho bơi
			//if (AgeState == EGG)
			//{
				//SetMovingState(FS_SWIM);
			//}
			
			// Gán lại hình dáng
			AgeState = ageState;			
			if (AgeState == BABY)
			{
				Scale = SCALE_BABY;
			}
			else 
				if ((AgeState == OLD))// && (FishType != FISHTYPE_SOLDIER))
				{
					if (FishType != FISHTYPE_SOLDIER)
					{
						// Quangvh
						Scale = SCALE_OLD + 0.1 * (Math.max(FishTypeId - Constant.FISH_TYPE_START_DOMAIN, 0) % Constant.FISH_TYPE_DISTANCE_DOMAIN);
					}
					else
					{
						// Longpt
						Scale = SCALE_OLD;
					}
				}
				else 
					if (IsEgg)	// Nếu là trứng thì ko đc bơi
					{
						SetMovingState(FS_IDLE);
					}
					
			RefreshImg();
		}
		
		public function SetEmotion(emotion:String):void
		{
			//if (AgeState == EGG)
			//{
				//return;
			//}
			if (Emotion == emotion)
			{				
				return;
			}
			if (State == FS_FALL)
			{
				return; 
			}
			
			if (IsHide)
			{
				return;
			}
			
			Emotion = emotion;			
			RefreshEmotion();
			PrepareMoving(DesPos);
			RefreshImg();
		}
		
		public function RefreshEmotion():void
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
				case HAMMER:
					//EmoImg = new EmotionImg(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) , "ImoHammer");
					EmoImg = new EmotionImg(aboveContent , "ImoHammer");
					break;
				case HAPPY:
					//SetSpeed(3.7, 5);
					SetSpeed(0.5, 3);
					//EmoImg = new EmotionImg(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) , "EmoHappy");
					EmoImg = new EmotionImg(aboveContent , "EmoHappy");
					EmoImg.img.scaleX = EmoImg.img.scaleY = scale;
					EmoLifeTime = GameLogic.getInstance().CurServerTime + 4;
					break;
				case IDLE:
					if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
					{
						SetSpeed(0.5, 3);
					}
					else
					{
						SetSpeed( 5, 10);
					}
					break;
				case SAD:
					SetSpeed(0.5, 1);
					break;
				case ILL:
					SetSpeed(0.1, 0.5);
					//EmoImg = new EmotionImg(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) , "EmoMedicineBox");
					EmoImg = new EmotionImg(aboveContent , "EmoMedicineBox");
					EmoImg.img.scaleX = EmoImg.img.scaleY = scale;
					break;
				case LOVE:
					SetSpeed(3.7, 5);
					//EmoImg = new EmotionImg(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) , "EmoLove");
					EmoImg = new EmotionImg(aboveContent , "EmoLove");
					EmoImg.img.scaleX = EmoImg.img.scaleY = scale;
					EmoLifeTime = GameLogic.getInstance().CurServerTime + 4;					
					break;
				case CANCARE:
					SetSpeed(0.5, 3);
					//EmoImg = new EmotionImg(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) , "EmoCare");
					EmoImg = new EmotionImg(aboveContent , "EmoCare");
					EmoImg.img.scaleX = EmoImg.img.scaleY = scale;
					break;
				case HUNGRY:
					if (!Ultility.IsInMyFish())	break;
					SetSpeed(0.5, 3);
					//EmoImg = new EmotionImg(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) , "EmoFoodBox");
					EmoImg = new EmotionImg(aboveContent , "EmoFoodBox");
					EmoImg.img.scaleX = EmoImg.img.scaleY = scale;					
					break;
				case GIFT:
					SetSpeed(0.5, 3);
					//EmoImg = new EmotionImg(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) , "EmoFoodBox");
					EmoImg = new EmotionImg(aboveContent , "Gift");
					EmoImg.img.scaleX = EmoImg.img.scaleY = scale;	
					break;
				case ATTACKED:
					SetSpeed(0.5, 3);
					EmoImg = new EmotionImg(aboveContent , "EmoAttacked");
					EmoImg.img.scaleX = EmoImg.img.scaleY = scale;	
					break;
				
				case DOMAIN_1:
				case DOMAIN_2:
				case DOMAIN_3:
				case DOMAIN_4:
				case DOMAIN_5:
					SetSpeed(0.5, 3);
					EmoImg = new EmotionImg(aboveContent , Emotion);
					EmoImg.img.scaleX = EmoImg.img.scaleY = 1.2;
				break;
				
				// 4 trạng thái của cá lính
				case FishSoldier.WAR:
					//if (State != FS_WAR)
					//{
						SetSpeed(0.5, 3);
					//}
					EmoImg = new EmotionImg(aboveContent, "EmoWar");
					EmoImg.img.scaleX = EmoImg.img.scaleY = 0.8;
					EmoImg.HelperName = "attackFriendLake";
					HelperMgr.getInstance().SetHelperData(EmoImg.HelperName, EmoImg.img);
					break;
				case FishSoldier.WEAK:
					SetSpeed(0.5, 3);
					EmoImg = new EmotionImg(aboveContent, "EmoWeak");
					EmoImg.img.scaleX = EmoImg.img.scaleY = 1.2;
					break;
				case FishSoldier.REWARD:
					SetSpeed(0.5, 3);
					//EmoImg = new EmotionImg(aboveContent, "EmoReward");
					EmoImg = new EmotionImg(aboveContent, "EmoDiary");
					EmoImg.img.scaleX = EmoImg.img.scaleY = 1.2;
					break;
				case FishSoldier.REVIVE:
					EmoImg = new EmotionImg(aboveContent, "EmoRevive");
					EmoImg.img.scaleX = EmoImg.img.scaleY = 1;
					break;
				case FishSoldier.DEAD:
					//EmoImg = new EmotionImg(aboveContent, "EmoRevive");
					//EmoImg.img.scaleX = EmoImg.img.scaleY = 1;
					break;
			}
			if (EmoImg != null)
			{
				if (Emotion != GIFT && Emotion.search(DOMAIN) < 0)
				{
					if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)
					{
						if (Emotion == FishSoldier.WAR)
						{
							switch(FishWorldController.GetRound())
							{
								case Constant.SEA_ROUND_1:
									EmoImg.img.y = -40;
								break;
								case Constant.SEA_ROUND_2:
									EmoImg.img.y = -100;
									EmoImg.img.x = -20;
								break;
								case Constant.SEA_ROUND_3:
									EmoImg.img.y = -60;
									EmoImg.img.x = -15;
								break;
								case Constant.SEA_ROUND_4:
									EmoImg.img.y = -150;
									EmoImg.img.x = -15;
								break;
							}
						}
					}
					else
					{
						EmoImg.img.y = - 20;
					}
				}
				else
				{
					if (Emotion.search(DOMAIN) >= 0)
					{
						//EmoImg.img.y = -EmoImg.img.height / 2 ;
						//EmoImg.img.x = -EmoImg.img.width / 2;
						EmoImg.img.y = - EmoImg.img.height - 25 * Scale;
						EmoImg.img.x = - EmoImg.img.width / 2;
					}
					else 
					{
						EmoImg.img.y = -40;
						EmoImg.img.x = -15;
					}
				}
				
				EmoImg.SetMyFish(this as Fish);
			}
		}
		
		 public override function ClearImage():void
		 {
			removeAllEvent();
			
			// clear helper
			if (HelperName != "")
			{
				HelperMgr.getInstance().ClearHelper(HelperName);
			}
			
			if (Parent != null && img != null && img.parent == Parent)
			{
				Parent.removeChild(img);
				img = null;
			}
			
			if (chatbox && GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
			{
				chatbox.Hide();
			}
			
			if (effSpecialFish != null && aboveContent.contains(effSpecialFish) && FishType != 1)
			{
				aboveContent.removeChild(effSpecialFish);
			}
		 }
		
		public function RefreshImg():void
		{
			ClearImage();
			if (IsEgg)
			{
				LoadRes("imgEgg");
			}
			else
			{
				var domain:int = 0;
				if (FishTypeId >= Constant.FISH_TYPE_START_DOMAIN)
					domain = (FishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
				switch(Emotion)
				{
					case ILL:
						LoadRes(ItemType +  (FishTypeId - domain) + "_" + AgeState + "_" + SAD);
						var c:ColorTransform = new ColorTransform(0.4, 0.8, 0.6, 1);
						img.transform.colorTransform = c;
						break;
					case LOVE:
						LoadRes(ItemType +  (FishTypeId - domain) + "_" + AgeState + "_" + HAPPY);                                                                                                                                                                                                                                                                                                                                                                     
						break;
					case HUNGRY:
					case CANCARE:
					case ATTACKED:
						LoadRes(ItemType +  (FishTypeId - domain) + "_" + AgeState + "_" + IDLE);
						break;
					case GIFT:
						LoadRes(ItemType +  (FishTypeId - domain) + "_" + AgeState + "_" + IDLE);
						break;
					case DOMAIN_1:
					case DOMAIN_2:
					case DOMAIN_3:
					case DOMAIN_4:
					case DOMAIN_5:
					case FishSoldier.WAR:
						LoadRes(ItemType +  (FishTypeId - domain) + "_" + AgeState + "_" + IDLE);
						break;
					default:
						LoadRes(ItemType +  (FishTypeId - domain) + "_" + AgeState + "_" + Emotion);
						break;
				}
				
				img.scaleX = OrientX*Scale;
				img.scaleY = Scale;
			}
			
			sortContentLayer();			
			
			if(FishType == FISHTYPE_SPECIAL)
			{	
				addSpecialContent();				
				//if (starEmit == null) starEmit = new StarEmit(img.parent);
			}
			else if (FishType == FISHTYPE_RARE)
			{
				addRareContent();
				//Vẽ aura bằng glowFilter
				var cl:int = getAuraColor();
				TweenMax.to(img, 1, { glowFilter: { color:cl, alpha:1, blurX:20, blurY:20, strength:1.5 }} );				
		
				//Đổi màu aura tỏa tỏa
				var str:String = cl.toString(16).split("").reverse().join("");
				var color:Array = new Array(0, 0, 0);
				for (var i:int = 0; i < str.length; i += 2) 
				{
					color[i/2] = parseInt(str.slice(i, i + 2), 16);				
				}	
				if (effRareFish != null)
				{
					effRareFish.transform.colorTransform = new ColorTransform(0, 0, 0, 1, color[2], color[1], color[0]);
				}		
				
				//Khởi tạo emitter huýt sáo
				if (musicEmit == null)
				{
					musicEmit = new MusicEmit(img.parent);		
					//musicEmit.emit = new MusicStarEmit(img.parent);
				}
			}			
			else if (FishType == FISHTYPE_SOLDIER)
			{
				
			}
			
			if (Growth() + NumUpLevel <= 0.5)
			{
				addBabyContent();
			}
			
			//Add bóng
			var isDeadFish:Boolean = (Emotion == FishSoldier.DEAD);
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
			
			UpdateColor();		
		}
		
		/**
		 * Sắp xếp lại các layer conntent của cá gồm: layer nằm dưới cá, layer cá và layer nằm trên cá
		 */
		protected function sortContentLayer():void
		{
			//Add content đi kèm theo cá			
			if (!Parent.contains(underContent)) Parent.addChild(underContent);
			if (!Parent.contains(aboveContent)) Parent.addChild(aboveContent);

			if (Parent.getChildIndex(underContent) > Parent.getChildIndex(aboveContent))
			{
				Parent.swapChildren(underContent, aboveContent);
			}
			
			if (Parent.getChildIndex(img) > Parent.getChildIndex(aboveContent))
			{
				Parent.swapChildren(img, aboveContent);
			}
			
			if (Parent.getChildIndex(img) < Parent.getChildIndex(underContent))
			{
				Parent.swapChildren(img, underContent);
			}			
		}
		
		public function GetMoveArea():Sprite
		{
			var area:Sprite = new Sprite();
			var Pos:Point = new Point();
			Pos.x = CurPos.x < DesPos.x ? CurPos.x: DesPos.x;
			Pos.y = CurPos.y < DesPos.y ? CurPos.y: DesPos.y;
			area.graphics.drawRect(Pos.x - img.width/2, Pos.y - img.height/2, Math.abs(DesPos.x - CurPos.x) + img.width, Math.abs(DesPos.y - CurPos.y) + img.height);
			return area;
		}
		
		public function SetSwimingArea(area:Rectangle):void
		{
			SwimingArea = area;
		}
		
		
		public function SetMovingState(movState:int):void
		{
			if (movState == State)
			{
				return;
			}
			
			State = movState;

			switch(movState)
			{
				case FS_IDLE:
					break;
				case FS_SWIM:				
					break;
				case FS_STANDBY:
					break;
				case FS_FALL:
					var t:int = SwimingArea.top;
					DesPos.y = Ultility.RandomNumber(t + SwimingArea.height / 2, t + 3 * SwimingArea.height / 4);
					SpeedVec.x = Ultility.RandomNumber(-10, 10);
					SpeedVec.y = - 20;
					if (SpeedVec.x < 0)
					{
						flipX(-1);
					}
					State = FS_FALL;
				break;
				case FS_RETURN:
					break;
				case FS_HERD:
					break;
			}
		}
		
		public function SetDirFall(dir:int):void
		{
			if (dir == 1)
			{
				SpeedVec.x = Ultility.RandomNumber(1, 10);
				flipX(1);
			}
			else
			{
				SpeedVec.x = Ultility.RandomNumber(-10, -1);
				flipX(-1);
			}
			updateAttachContent();
		}
		
			
		public function UpdateFish():void
		{	
			// Dành cho cá 
			//var rateAgeGrown:Number = AgeTime / HarvestTime;
			//if (NumUpLevel > 0)
			//{
				//rateAgeGrown = 0;
			//}
			if (IsHide)
			{
				return;
			}
			
			//Update trạng thái di chuyển của cá
			switch(State)
			{
				case FS_IDLE:
					break;
				case FS_STANDBY:
					(this as FishSoldier).StandBy();
					break;
				case FS_A_TO_B:
					AtoB();
					break;
				case FS_WAR:
				case FS_SWIM:
					Swim();
					break;
				case FS_FALL:
					Fall();
					break;
				case FS_RETURN:
					Return();
					break;
				case FS_HERD:
					Swim();
					break;
			}	
			
			//Update các content khác đi kèm theo cá
			if (!img)	return;
			
			aboveContent.x = underContent.x = img.x;
			aboveContent.y = underContent.y = img.y;
			
			//di chuyển chatbox
			if (chatbox)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
			
			if (musicEmit)
			{
				musicEmit.pos.x = img.x + OrientX * img.width / 2
				musicEmit.pos.y = img.y;
				musicEmit.updateEmitter();
				musicEmit.vel = new Point(OrientX*(curSpeed+6), 0);
			}
			
			if (ghostEmit)
			{
				ghostEmit.pos.x = img.x;// + OrientX * img.width / 2;
				ghostEmit.pos.y = img.y;
				ghostEmit.updateEmitter();
				//ghostEmit.vel = new Point(OrientX, 0);
			}
			
			//if (starEmit)
			//{
				//starEmit.pos.x = img.x  + OrientX * img.width / 4;
				//starEmit.pos.y = img.y;
				//starEmit.updateEmitter();				
			//}
			
			//Update trạng thái cảm xúc của cá
			UpdateEmotion();	
			
			// Nếu ở nhà mình & là cá quý, cá đặc biệt & lần nhận quà trước có level thấp hơn level hiện tại
			// Và chưa gửi gói tin yêu cầu quà & giai đoạn phát triển đã đủ để lên level tiếp && cá có level không quá level người chơi là 5
			if(!GameLogic.getInstance().user.IsViewer() && FishType != FISHTYPE_NORMAL && LastGetLevelGift < Level)
				//if (!isSendLevelUP &&  Growth() >= NumUpLevel + rateAgeGrown + 1 && (GameLogic.getInstance().user.Level - (Level)) > -5) 
				if (!isSendLevelUP &&  Growth() > NumUpLevel + 1 && (GameLogic.getInstance().user.Level - (Level)) > -5) 
				{
					// Nếu khởi tạo game thì kiểm tra xem có quà để lên level chưa
					if (LevelUpGift.length == 0)
					{
						CheckFishUpLevel();
					}
					else 
					{
						SetEmotion(GIFT);
						//GameLogic.getInstance().CreatePocket(this);
						isSendLevelUP = true;
					}
				}
			
			// Update giai đoạn của cá
			// Rơi túi tiền cho cả cá quý và cá đặc biệt
			var p:int = GetPeriod();
			if (Growth() + NumUpLevel >= 0.5)
			{
				if (EmoBaby != null)
				{
					aboveContent.removeChild(EmoBaby);
					EmoBaby = null;
				}
			}
			else 
			{
				if (Emotion == IDLE || Emotion.search(DOMAIN) >= 0)
				{
					addBabyContent();
				}
				else 
				{
					if (EmoBaby != null)
					{
						aboveContent.removeChild(EmoBaby);
						EmoBaby = null;
					}
				}
			}
			if (Period != p)
			{
				Period = p;
				ChangePeriodEvent(Period);
				//if (Period == GROWTH_UP && FishType == FISHTYPE_NORMAL)
				//{
					//GameLogic.getInstance().CreatePocket(this);
				//}
			}
			
			//update gui status đi kèm theo cá
			if (GuiFishStatus.IsVisible)
			{				
				GuiFishStatus.SetPos(CurPos.x, CurPos.y);
				if (GuiFishStatus.Type == GUIFishStatus.STATUS_FEED)
				{
					var das:Number = Math.abs(Full());
					//GuiFishStatus.prgFood.setStatus(Math.abs(Full()));
					GuiFishStatus.prgFood.setStatus(das);
					if (GuiFishStatus.Type == GUIFishStatus.STATUS_FEED)
					{
						//GuiFishStatus.prgFood.setStatus(Full());
					}
				}
			}			
			
			updateGushBall();
		}
		
		public function UpdateEmotion():void
		{
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
			{
				//Update trạng thái cảm xúc của cá
				if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
				{
					switch(Emotion)
					{
						case HAPPY:
						case DOMAIN_1:
						case DOMAIN_2:
						case DOMAIN_3:
						case DOMAIN_4:
						case DOMAIN_5:
						case LOVE:
						case FishSoldier.WAR:
							if (GameLogic.getInstance().CurServerTime > EmoLifeTime)
							{
								if (FishType != FISHTYPE_NORMAL && LevelUpGift != null && LevelUpGift.length > 0 && !GameLogic.getInstance().user.IsViewer())
								{
									SetEmotion(GIFT);
								}
								else if (CanCare())
								{
									SetEmotion(CANCARE);
								}
								else
								{
									if(DomainFish() <= 0)
									{
										SetEmotion(IDLE);
									}
									else 
									{
										SetEmotion(DOMAIN + DomainFish());
									}
								}
							}
							break;
						case GIFT:
							if (FishType != FISHTYPE_NORMAL && Growth() < 1)
							{
								if(DomainFish() <= 0)
								{
									SetEmotion(IDLE);
								}
								else 
								{
									SetEmotion(DOMAIN + DomainFish());
								}
							}
							return;
						break;
					}
					// nếu cá chỉ còn no 25% thì chuyển sang trạng thái cần cho ăn
					if (EmoLifeTime < GameLogic.getInstance().CurServerTime)// && Full() < HUNGRY_THRESOLD && LevelUpGift.length <= 0)
					{
						if (Full() < HUNGRY_THRESOLD && LevelUpGift.length <= 0)
							SetEmotion(HUNGRY);
					}
					
				}
				else
				{
					if(Ultility.IsInMyFish())
					{
						var o:Object = GameLogic.getInstance().user.CurSoldier[1];
						if (isInRightSide && (!o || o.FishType != FISHTYPE_SOLDIER))
						{
							if (img.visible)
							{
								SetEmotion(FishSoldier.WAR);
							}
						}
						else
						{
							//SetEmotion(IDLE);
						}
					}
					else 
					{
						if (isInRightSide)
						{
							SetEmotion(FishSoldier.WAR)
						}
					}
				}
			}
			else
			{
				
			}
		}
		
		public function SwimTo(x:int, y:int, speed:Number = -1, isWar:Boolean = false):void
		{
			var Des:Point = new Point();
			
			Des.x = x;
			Des.y = y;
			State = FS_SWIM;
			if (isWar)
			{
				SetMovingState(FS_WAR);
			}
			PrepareMoving(Des, speed, false);
		}
		
		public function FindDes(hasAcceleration:Boolean = true):void
		{
			var Des:Point = new Point();
			var vecto1: Point;	// vecto cho biết hướng chuyển động cua con cá đầu đàn
			var vecto2: Point;	// vecto cho biết hướng chuyển động cua con cá theo sau
			
			if (State == FS_HERD)
			{
				var fishK: Fish = GameLogic.getInstance().user.FishKing as Fish;
				vecto1 = fishK.DesPos.subtract(fishK.CurPos);
				if ((fishK.CurPos.x - CurPos.x) * fishK.SpeedVec.x > 0) 
				{
					Des.x = fishK.DesPos.x;
					Des.y = Ultility.RandomNumber(Math.max(fishK.DesPos.y + 50, SwimingArea.bottom), Math.min(fishK.DesPos.y - 50,SwimingArea.top));
				}
			}
			else
			{
				if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR || GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
				{
					Des.x = Ultility.RandomNumber(SwimingArea.left, SwimingArea.right);
				}
				else
				{
					var x:Number = Ultility.PosScreenToLake(0, 0).x;
					Des.x = Ultility.RandomNumber(x, x + img.stage.stageWidth);
				}
				
				do
				{
					Des.y = CurPos.y + Ultility.RandomNumber( -150, 150);
				}				
				while (	Des.y < SwimingArea.top	|| Des.y > SwimingArea.bottom);
			}			
			rateDeep = -(Math.random() - curDeep) / Math.abs(Des.x - CurPos.x);							
			PrepareMoving(Des, -1, hasAcceleration);			
		}
		
		public function GoBack():void
		{
			var Des:Point = new Point();
			Des.x = CurPos.x - sign(SpeedVec.x) * Ultility.RandomNumber(10, 100);
			do
			{
				Des.y = CurPos.y + Ultility.RandomNumber( -150, 150);
			}
			while (	Des.y < SwimingArea.top	|| Des.y > SwimingArea.bottom);
			PrepareMoving(Des);
		}
		
		protected function PrepareMoving(Des:Point, speed:Number = -1, hasAcceleration:Boolean = true):void
		{
			if (speed > 0)
			{
				realMaxSpeed = speed;	
			}
			else
			{
				realMaxSpeed = Ultility.RandomNumber(MinSpeed, MaxSpeed);
			}
			ChangeDir(CurPos, Des);
			var temp:Number = Des.x - CurPos.x;
			// Hardcode cho truong hop the gioi moc, do chieu boi va nhin cua quai la tu phai qua trai
			// con cac con ca khac la tu trai qua phai
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST && 
				(this as FishSoldier).isActor != FishSoldier.ACTOR_MINE)	
			{
				temp = -temp;
			}
			if (temp > 0){
				flipX(1);
			}
			else{
				flipX( -1);
			}
			updateAttachContent();
			if (hasAcceleration)
			{
				MoveTo(Des.x, Des.y, MinSpeed);
				changeSpeedDistance = 70;//CurPos.subtract(DesPos).length/4;
				curSpeed = 0;
			}
			else
			{
				MoveTo(Des.x, Des.y, realMaxSpeed);
				changeSpeedDistance = 0;
				curSpeed = realMaxSpeed;
			}
			//GameController.getInstance().UpdateFishChildIndex(this);
			
			//if (starEmit != null)
			//{
				//var vel:Point = SpeedVec.clone();
				//vel.normalize(1);
				//starEmit.vel = new Point(-vel.x, vel.y);
			//}
		}		
		
		public function FollowFood(food:Food):void
		{
			myFood = food;
			var Des:Point = new Point();
			Des.x = food.CurPos.x;
			Des.y = food.CurPos.y;
			var speed:int = Ultility.RandomNumber(5, 8);
			PrepareMoving(Des, speed, false);
		}
		
		public function DomainFish():int 
		{
			var domain:int;
			if (FishTypeId < Constant.FISH_TYPE_START_DOMAIN)
			{
				domain = -1;
			}
			else 
			{
				domain = (FishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
			}
			return domain;
		}
		
		public function EatFood(nFood:Number):void
		{
			this.FeedAmount += nFood;
			myFood = null;			
			if (Full() >= HUNGRY_THRESOLD && Emotion == HUNGRY)
			{
				if (FishType != FISHTYPE_NORMAL && LevelUpGift != null && LevelUpGift.length > 0)
				{
					SetEmotion(GIFT);
				}
				else
				{
					if (CanCare())
					{
						SetEmotion(CANCARE);
					}	
					else
					{
						if ((DomainFish() <= 0) || (FishType == FISHTYPE_SOLDIER))
						{
							SetEmotion(IDLE);
						}
						else
						{
							SetEmotion(DOMAIN + DomainFish());
						}
						SetMovingState(FS_SWIM);
					}
				}
			}			
		}
		
		public function GetFishInfo():Array
		{
			var result:Array = [];
			
			//this.FishTypeId = 1;
			//this.Name = "Benh hoan";
			//this.Sex = 1;
			//this.StartTime = 1284508800;
			//this.FeedAmount = 100;			
			
			result["posX"] = this.GetPos().x;
			result["posY"] = this.GetPos().y;
			result["Type"] = this.FishTypeId;
			result[ConfigJSON.KEY_NAME] = this.Name;
			result["Sex"] = this.Sex;
			result["StartTime"] = this.StartTime;
			result["TotalFood"] = this.FeedAmount;
			
			return result;
		}
		
		public function Swim(speedFish:int = -1):void
		{
			if (IsEgg)
			{
				return;
			}
			if (SwimingArea.width == 0 && SwimingArea.height == 0)
			{
				return;
			}
			
			UpdateObject();			
			updateShadow();

			var temp:Point = CurPos.subtract(DesPos);
			if (changeSpeedDistance != 0)
			{
				if(!IsFishKing && State != FS_HERD && speedFish == -1)
					if (temp.length <= changeSpeedDistance)
					{
						curSpeed -= 0.12;
						if (curSpeed <= 1) {curSpeed = 1;}
					}
					else
					{
						curSpeed += 0.15;
						if (curSpeed >= realMaxSpeed) {curSpeed = realMaxSpeed;}
					}
				else 	curSpeed = 2 - ChangCurSpeed;
			}
			SpeedVec.normalize(curSpeed);
			CheckSwimingArea();
			
			if (ReachDes)
			{
				if (State != FS_WAR) 
				{ 
					if (!isInRightSide && GameLogic.getInstance().gameMode != GameMode.GAMEMODE_NORMAL)
					{
						var posX:int;
						var posY:int;
						if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
						{
							posX = Ultility.RandomNumber(GameController.getInstance().TheirFishRectangle.left + img.width + 50, GameController.getInstance().TheirFishRectangle.right - img.width - 50);
							posY = CurPos.y;
							SwimTo(posX, posY, 10);
						}
						else if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
						{
							posX = Ultility.RandomNumber(GameController.getInstance().MyFishRectangle.left + img.width + 50, GameController.getInstance().MyFishRectangle.right - img.width - 50);
							posY = CurPos.y;
							SwimTo(posX, posY, 10);
						}
					}
					else
					{
						FindDes();
					}
				}
				else
				{
					GuiFishStatus.Hide();
					aboveContent.visible = false;
					SetEmotion(IDLE);
					if (img.visible)
						img.visible = false;
				}
			}
			
			if (State == FS_HERD) 	realMaxSpeed = GameLogic.getInstance().user.FishKing.realMaxSpeed;
			if(State == FS_HERD) 	realMaxSpeed = GameLogic.getInstance().user.FishKing.realMaxSpeed;
			if (chatbox && this.img)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
			
			CheckWarPosition();
		}
		
		/**
		 * Cập nhật vị trí của cá trong hồ khi chuyển 2 chế độ WAR/NORMAL
		 */
		public function CheckWarPosition():void
		{
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				if (!isInRightSide && (CurPos.x - img.width / 2 >= (Constant.MAX_WIDTH / 2 + 200) && (CurPos.x + img.width / 2) <= (Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2)))
				{
					isInRightSide = true;
					if(Ultility.IsInMyFish())
					{
						SetSwimingArea(GameController.getInstance().TheirFishRectangle);
					}
					else 
					{
						SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2, 0, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
					}
					SetEmotion(IDLE);
				}
			}
			else if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
			{
				if (!isInRightSide && (CurPos.x + img.width / 2) <= (Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2))
				{
					isInRightSide = true;
					SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 40));	
				}
			}
			else
			{
				if (isInRightSide)
				{
					if(Ultility.IsInMyFish())
					{
						if(!GameController.getInstance().isSmallBackGround)
						{
							SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
						}
						else
						{
							SetSwimingArea(new Rectangle(275, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE - 80));
						}
					}
					else 
					{
						//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 110, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD - 150));
						SetSwimingArea(new Rectangle( -50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
					}
					isInRightSide = false;
				}
			}
		}
		
		// Thả cá
		protected function Fall():void
		{
			SpeedVec.y += 4;
			if (IsEgg)
			{
				var sped:int = Ultility.RandomNumber(2, 5)				
				var des:Point = new Point;
				des.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 15, GameController.getInstance().GetLakeBottom() - 10);
				des.x = Ultility.RandomNumber(180, 570);
				des = Ultility.PosScreenToLake(des.x, des.y);
				
				MoveTo(des.x, des.y, sped);
				SpeedVec.y -= 5;
				if (SpeedVec.y < 2)
				{
					SpeedVec.y = 2;
				}
				CurPos = CurPos.add(SpeedVec);
				this.img.x = CurPos.x;
				this.img.y = CurPos.y;
				if (CurPos.y > Ultility.PosLakeToScreen(des.x, des.y).y)
				{
					State = FS_IDLE;
				}
			}
			else
			{
				updateShadow();
				if (CurPos.y > SwimingArea.top)
				{
					var pos1:Point = Ultility.PosScreenToLake(img.width , CurPos.y);
					var pos2:Point = Ultility.PosScreenToLake(img.stage.stageWidth - img.width, CurPos.y);
					if ( CurPos.y >=DesPos.y)
					{
						ReachDes = true;
						DesPos.y = DesPos.y + Ultility.RandomNumber( -100, -50);
						SwimTo((pos2.x + pos1.x) / 2, DesPos.y);
						return;
					}
					
					if (CurPos.x <= pos1.x|| CurPos.x >= pos2.x)
					{						
						SwimTo((pos2.x + pos1.x) / 2, CurPos.y);
						return;
					}
					
				 	SpeedVec.y -= 4;
					if (SpeedVec.y < 2.5)
						SpeedVec.y = 2.5;
				}
				var temp:Number = CurPos.y;
				CurPos = CurPos.add(SpeedVec);
				this.img.x = CurPos.x;
				this.img.y = CurPos.y;
				
				//Cá chạm mặt nước
				//Tác động lực làm cá rơi chậm đi
				//Effect nước bắn
				if (temp <= SwimingArea.top && CurPos.y >= SwimingArea.top)
				{
					SpeedVec.y = 0.2 * SpeedVec.y;
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffNuocBan", null, CurPos.x + Ultility.RandomNumber(-10, 10), SwimingArea.top);
				}
			}
		}
		
		protected function Return():void
		{
			img.scaleX += OrientX * 0.6;
			
			if (Math.abs(img.scaleX) >= Scale)
			{
				img.scaleX = OrientX * Scale;
				SetMovingState(FS_SWIM);
				return;				
			}		
		}
		
		public function flipX(orient:int, rightnow:Boolean = true):void
		{
			if (!img)
				return;
				
			if (orient == 0)
				return;
		
			if (CurPos.x < SwimingArea.left + img.width/2 || CurPos.x > SwimingArea.right - img.width/2)
				return;
			
			if (rightnow)
			{
				if (orient > 0)
				{
					img.scaleX = Scale;
				}
				else
				{
					img.scaleX = -Scale;
				}
			}
			else
			{
				SetMovingState(FS_RETURN);
			}
			OrientX = orient;
			if (this is FishSoldier && (this as FishSoldier).isActor == FishSoldier.ACTOR_MINE)
			{
				//trace(this.OrientX + " orientX cua con ca linh nha minh");
			}
		}
		
		
		private function sign(x:Number):int
		{
			return (x > 0) ? 1 : ((x < 0) ? -1 : 0);
		}
		
		public function CheckSwimingArea():void
		{
			var flagX:Boolean = false;
			var flagY:Boolean = false;
			
			if(CurPos.x <= SwimingArea.left + img.width/2)
			{
				SetPos(SwimingArea.left + img.width/2, CurPos.y);
				if (OrientX < 0)
				{
					flagX = true;
				}
			}
			if (CurPos.x >= SwimingArea.right - img.width/2)
			{
				SetPos(SwimingArea.right - img.width / 2, CurPos.y);
				if (OrientX > 0)
				{
					flagX = true;
				}
			}					
			
			if (CurPos.y < SwimingArea.top +  img.height/2 && SpeedVec.y < 0)
			{
				SetPos(CurPos.x , SwimingArea.top + img.height/2);
				flagY = true;
			}
			if ( CurPos.y > SwimingArea.bottom - img.height/2 && SpeedVec.y > 0)
			{
				SetPos(CurPos.x , SwimingArea.bottom - img.height/2);
				flagY = true;
			}

			if (flagX == true)
			{
				GoBack();
			}
			if (flagY == true)
			{
				FindDes();
			}
		}
		
		public function ChangeDir(curPos:Point, desPos:Point, turnSpeed:Number = 0):void
		{
			var s:Point = desPos.subtract(curPos);
			var dir:Number = Math.atan2(s.y, s.x) * 180 / Math.PI;
			if (dir < 0)
			{
				dir += 360;
			}
			
			if (dir > 90 && dir < 270)
			{
				dir = (dir + 180) % 360;
			}
			
			
			var delta:int = 20;
			if (dir < 360 - delta && dir >= 270)
			{
				dir = 360 - delta;
			}
			
			if (dir > delta && dir <= 90)
			{
				dir = delta;
			}
			img.rotation = dir;
		}		
		
		
		public static function RandomAgeState():int
		{
			return (Math.round(Ultility.RandomNumber(0, 1)) as int)
		}
		
		public static function getAuraByOption(option:String):int
		{
			var t:int = 0;
			switch(option)
			{
				case OPTION_MONEY:
				{
					t = AURA_COLOR_GOLD;
					break;
				}
				case OPTION_EXP:
				{
					t = AURA_COLOR_EXP;
					break;
				}
				case OPTION_MIX_RARE:
				{
					t = AURA_COLOR_MIX;
					break;
				}
				case OPTION_TIME:
				{
					t = AURA_COLOR_OTHER;
					break;
				}				
			}
			return t;
		}
		
		public function UpdateStartTime():void
		{
			if (IsEgg)
			{
				return;
			}
			
			var HungryTime:Number;
			HungryTime = GameLogic.getInstance().CurServerTime - StartTime - (FeedAmount * AffectTime);
			if (HungryTime > 0)
			{
				StartTime += HungryTime;
			}
		}
		
		/*Muc do tang truong: 0->1
		 * 1: la truong thanh 
		 */		
		public function Growth():Number
		{
			//var HarvestTime:Number = INI.getInstance().getItemInfo(FishTypeId.toString(), ItemType)["HarvestTime"];
			//var HarvestTime:Number = INI.getInstance().getFishHarvest(FishTypeId.toString());		
			var LifeTime:Number = GetLifeTime();
			var growth:Number = 0;		
			if (HarvestTime == 0) return 0;
			if (LifeTime >= 0)
			{
				growth = LifeTime / HarvestTime;
			}
			else
			{
				growth = -(1 + (LifeTime/EggTime) );
			}
			
			return growth + NumUpLevel;
		}
		
		public function CheckFishUpLevel():void 
		{
			var LakeID:int = GameLogic.getInstance().user.CurLake.Id;
			isSendLevelUP = true;
			var CreateGiftForFish:SendFishUpLevel = new SendFishUpLevel(LakeID, Id);
			Exchange.GetInstance().Send(CreateGiftForFish);
		}
		
		public function UpdateFishSpecial():void 
		{
			NumUpLevel ++;
			Level ++;
		}
		
		public function GetLifeTime():Number
		{
			var time:Number = GameLogic.getInstance().CurServerTime;	// Thoi gian lay tu server
			var LifeTime:Number = time - StartTime;		
			var FoodTime:Number;
			if (LifeTime >= 0)
			{
				FoodTime = (FeedAmount * AffectTime);
				if (LifeTime > FoodTime)
				{
					LifeTime = FoodTime;
				}
				
				if (IsEgg)
				{
					if(!GameLogic.getInstance().user.IsViewer())
					{
						SetEmotion(HAMMER);
					}
					LifeTime = 0;
				}
			}
		
			return LifeTime;
		}
		
		// Lấy thời gian đói của cá
		public function HungryTime():Number 
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;			
			//var AffectTime:int = INI.getInstance().getGeneralInfo("Food", "AffectTime");
			var hungryTime:Number = (curTime - StartTime) - FeedAmount * AffectTime;
			return hungryTime;
		}
		
		// Mức độ no của cá, từ 0 -> 1
		public function Full():Number 
		{
			if (IsEgg)
			{
				return 1;
			}
			var result:Number;			
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var FullTime:Number = FeedAmount * AffectTime - (curTime - StartTime);
			
			if (FullTime > maxFood * AffectTime)
			{
				FullTime = maxFood * AffectTime;				
			}
			
			
			if (FullTime > 0.0000000001)	// chưa đói
			{
				result = FullTime / (maxFood * AffectTime);			
			}
			else				// đang đói
			{
				result = 0;
			}			
			return result;
		}
		
		// Kiểm tra xem cá có ăn thêm được hay ko
		public function EatMore():Number
		{
			if (IsEgg)
			{
				return 0;
			}
			var hungry:Number = this.Full();
			//var maxFood:int = INI.getInstance().getGeneralInfo("Fish", "MaxFood");
			
			if (hungry < 0.99)
			{
				return ((1 - hungry) * maxFood);
			}
			else 
			{
				return 0;
			}
		}
		
		
		public function GetPeriod():int
		{				
			var growth:Number = Growth();
			var period:int = Math.ceil(growth * Terms);
			//if(FishType == FISHTYPE_NORMAL)
				if (period == 0)
				{
					if (!IsEgg)
					{
						period = 1;
					}
				}
				else 
				{
					//if (period >= GROWTH_UP || growth == 1)
					{
						//if (NumUpLevel < 1)
						//{
							//period = GROWTH_UP;
						//}
						//else
						//{
						period = period -(Terms * NumUpLevel);
							
						//}
						if ( period >= GROWTH_UP || growth == 1)
								period = GROWTH_UP
					}
				}
			
			return period;
		}
		
		public function GetValue():Number
		{	
			var growth:Number = Growth();
			var Obj:Object = ConfigJSON.getInstance().getItemInfo(ItemType, FishTypeId);
			var priceBuy:Number = Obj["Money"];		
			var interest:Number = Obj["Earning"];
			var pocket:Number = Obj["TotalPocket"];
			var value:Number = priceBuy;
			
			var prd:Number = GetPeriod();
			
			// Tinh tien theo giai doan
			//var moneyRate:Number = ConfigJSON.getInstance().GetMoneyPeriod(FishTypeId, prd);
			//var value:Number = Math.round(price * moneyRate);			
			
			// Tinh tien theo tuoi cua ca
			//value += NumUpLevel * ConfigJSON.getInstance().GetMoneyPeriod(FishTypeId, 5) * price;
			//if (growth >= NumUpLevel + 1)
				//value += (NumUpLevel + 1)*(interest - pocket);
			//else 
			//{
				//if (NumUpLevel < 1)
				//{
					//value = NumUpLevel * (interest - pocket);
				//}
				//else
				//{
					//value += NumUpLevel * (interest - pocket);
				//}
			//}
				
					
			//Cộng tiền màu của cá
			//if (ColorLevel != 0)
			//{
				//var bonus:int = ConfigJSON.getInstance().getFishBonus(FishTypeId, ColorLevel);
				//value += bonus;
			//}
			
			//if (FishType != FISHTYPE_NORMAL && growth >= 1)
			//{
				//value = Obj["MaxValue"];
			//}
			
			if (growth >= 1)
			{
				value = Obj["TrustPrice"];// - MoneyAttacked;
			}
			else
			{
				value = 0;
			}
			
			// Cong tien dua vao option cua ho
			if (GameLogic.getInstance().user.CurLake.Option["Money"] > 0)
			{
				value = value * (1 + Math.min(GameLogic.getInstance().user.CurLake.Option["Money"], Constant.MAX_BUFF_MONEY) / 100);
			}
			
			// Trừ tiền bị tấn công
			value -= MoneyAttacked;
			
			if (value < 0)	value = 0;
			
			return Math.round(value);
		}
		
		public function getExp(isGift:Boolean = false):int
		{
			var Obj:Object = ConfigJSON.getInstance().getItemInfo(ItemType, FishTypeId);
			var ExpFish:Number = Obj["Exp"];
			
			var grow:Number = Growth();
			if (grow < 1) 
			{
				//ExpFish = ExpFish * (int(GetPeriod() / GROWTH_UP));
				ExpFish = 0;
			}
			
			if (GameLogic.getInstance().user.CurLake.Option["Exp"] > 0)
			{
				ExpFish = ExpFish * (1 + Math.min(GameLogic.getInstance().user.CurLake.Option["Exp"], Constant.MAX_BUFF_EXP) / 100);
			}
			// Trừ exp theo level
			//if (FishType == FISHTYPE_NORMAL)
			//{
				//var ObjFishArr:Object = ConfigJSON.getInstance().GetItemInfo(ItemType, -1);
				//var iObjFish:int;
				//var ObjFishEnd:Object;
				//for (iObjFish = 1;; iObjFish++) 
				//{
					//if (ObjFishArr[iObjFish])
					//{
						//ObjFishEnd = ObjFishArr[iObjFish];
					//}
					//else
						//break;
				//}
				//var levelMaxNotAbs:int = Math.min(ObjFishEnd["LevelRequire"],GameLogic.getInstance().user.Level);
				//var deltaExpFish:Number = ExpFish * 0.04 * Math.max((levelMaxNotAbs - Obj["LevelRequire"]), 0);
				//ExpFish = Math.max(ExpFish - deltaExpFish, 1);
			//}
			ExpFish = Math.ceil(ExpFish);
			
			//Nếu có sự kiện nhân đôi
			if (GameLogic.getInstance().isEventDuplicateExp)
			{
				ExpFish *= 2;
			}
			
			return ExpFish;
		}
		
		
		public function CanCare():Boolean
		{
			if (GameLogic.getInstance().user.IsViewer())
			{
				if (LastPeriodCare < Period //&& Full() <= 0.98 
							&& Growth() < 1)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Add những content đi kèm với cá có level từ 1 -> 5
		 */
		private function addLevelFishContent(indexLevel:int):void
		{
			if (effLevelFish == null && (indexLevel > 0 || indexLevel < 6))
			{
				//headRing = ResMgr.getInstance().GetRes("Ring") as Sprite;
				effLevelFish = ResMgr.getInstance().GetRes("EffCaDacBiet" + indexLevel.toString()) as Sprite;
				effLevelFish.scaleX = effSpecialFish.scaleY = 0.6;							
				effLevelFish.y = 0;// -(img.height / 2) - 10;
				effLevelFish.mouseEnabled = false;
				effLevelFish.mouseChildren = false;
				aboveContent.addChild(effLevelFish);	
				updateAttachContent();
			}
				
		}
		
		/**
		 * Add những content đi kèm với cá đặc biệt
		 */
		protected function addSpecialContent():void
		{
			if (effSpecialFish == null)
			{
				//headRing = ResMgr.getInstance().GetRes("Ring") as Sprite;
				effSpecialFish = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				effSpecialFish.scaleX = effSpecialFish.scaleY = 0.6;							
				effSpecialFish.y = 0;// -(img.height / 2) - 10;
				effSpecialFish.mouseEnabled = false;
				effSpecialFish.mouseChildren = false;
				aboveContent.addChild(effSpecialFish);	
				updateAttachContent();
			}
				
		}
		
		/**
		 * Add những content đi kèm với cá bé
		 */
		protected function addBabyContent():void
		{
			if (EmoBaby == null)
			{
				//aura =  ResMgr.getInstance().GetRes("aura") as Sprite;
				EmoBaby =  ResMgr.getInstance().GetRes("ImgPresentBaby") as Sprite;
				EmoBaby.x = - img.width / 2 ;
				//EmoBaby.y = - img.height / 2 - EmoBaby.height / 2;
				EmoBaby.y = - img.height / 2 - EmoBaby.height;
				//aura =  ResMgr.getInstance().GetRes("EffCaQuy") as Sprite;
				//EmoBaby.scaleX = effRareFish.scaleY = 0.6;
				EmoBaby.mouseEnabled = false;
				EmoBaby.mouseChildren = false;
				aboveContent.addChild(EmoBaby);
				updateAttachContent();
			}			
		}
		
		/**
		 * Add những content đi kèm với cá quý
		 */
		protected function addRareContent():void
		{
			if (effRareFish == null)
			{
				/*
				//aura =  ResMgr.getInstance().GetRes("aura") as Sprite;
				effRareFish =  ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				//aura =  ResMgr.getInstance().GetRes("EffCaQuy") as Sprite;
				effRareFish.scaleX = effRareFish.scaleY = 0.6;
				effRareFish.mouseEnabled = false;
				effRareFish.mouseChildren = false;
				aboveContent.addChild(effRareFish);
				updateAttachContent();*/
			}			
		}
		
		/**
		 * 
		 * @param	giftList
		 */
		public function AcceptGift(): void
		{
			UpdateFishSpecial();
			var i: int = 0
			for (i = 0; i < LevelUpGift.length; i++ )
			{
				var mat:FallingObject;
				var j: int;
				var obj: Object = LevelUpGift[i] as Object;
				//trace(obj["ItemType"] + " " + obj["Num"]);
				switch (obj["ItemType"])
				{
					case ("Material"):
					case ("EnergyItem"):
						for (j = 0; j < obj["Num"]; j++ )
						{
							//var pos:Point = Ultility.PosLakeToScreen(CurPos.x, CurPos.y);
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + obj["ItemId"], CurPos.x, CurPos.y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						if (GuiMgr.getInstance().GuiStore.IsVisible)
						{
							GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);
						}
					break;					
					case ("Energy"):
						EffectMgr.getInstance().fallFlyEnergy(CurPos.x, CurPos.y, obj["Num"]);
					break;
				}
			}
			//EffectMgr.getInstance().fallFlyMoney(CurPos.x, CurPos.y, GetValue());
			EffectMgr.getInstance().fallFlyXP(CurPos.x, CurPos.y, getExp(true), true);
			var arrPocket:Array = GameLogic.getInstance().user.PocketArr;
			for (i = 0; i < arrPocket.length; i++) 
			{
				var pocket:Pocket = arrPocket[i];
				if (pocket.fish.Id == this.Id)
				{
					pocket.Collect();
					arrPocket.splice(i, 1);
					pocket.ClearImage();
					break;
				}
			}
			var sendMsg: SendGetGiftOfFish = new SendGetGiftOfFish(Id, GameLogic.getInstance().user.CurLake.Id);
			Exchange.GetInstance().Send(sendMsg);
			
			LevelUpGift = [];
			SetMovingState(FS_SWIM);
			if (DomainFish() > 0)
			{
				SetEmotion(DOMAIN + DomainFish());
				//RefreshEmotion();
			}
		}
		
		/**
		 * Update lại vị trí các content đi kèm khi cá quay đầu
		 */
		public function updateAttachContent():void
		{
			if (effSpecialFish != null)
			{
				effSpecialFish.x = -OrientX * (img.width / 4);
			}
			
			if (EmoBaby != null)
			{
				EmoBaby.x = OrientX * (img.width / 2);
				EmoBaby.rotation = Math.max(OrientX, 0) * 60;
			}
			
			// Là cá lính thì cập nhật cả đồ đạc đi kèm
			if (FishType == FISHTYPE_SOLDIER)
			{
				var fs:FishSoldier = this as FishSoldier;
				
				for (var str:String in fs.EquipmentList)
				{
					//if (fs.EquipmentList[str] != "0")
					//{
						fs.EquipmentList[str].img.x = fs.OrientX * (fs.img.width / 2);
						fs.EquipmentList[str].img.rotation = Math.max(fs.OrientX, 0) * 60;
						//var eq:FishEquipment = EquipmentList[str] as FishEquipment;
						//eq.SetPos(img.x, img.y);
					//}
				}
				//fs.UpdateEquip();
			}
		}
		
		public function ChangeLayerAttachConent(newILayer:int):void
		{
			var layer:Object = LayerMgr.getInstance().GetLayer(newILayer);				
			if ((layer != null) && img != null && img.parent != null)
			{
				aboveContent.parent.removeChild(aboveContent);
				underContent.parent.removeChild(underContent);		
				
				layer.addChild(aboveContent);
				layer.addChild(underContent);
			}			
		}
		
		
		
		public function Clear():void
		{
			if (Sprite(Parent).contains(underContent))
			{
				Sprite(Parent).removeChild(underContent);
			}
			if (Sprite(Parent).contains(aboveContent))
			{
				Sprite(Parent).removeChild(aboveContent);
			}
			
			if (shadow != null && Sprite(Parent).contains(shadow))
			{
				Parent.removeChild(shadow);
				shadow = null;
			}
			if (musicEmit != null)
			{
				musicEmit.destroy();
				musicEmit = null;
			}
			if (ghostEmit != null)
			{
				ghostEmit.destroy();
				ghostEmit = null;
			}
			//if (starEmit != null)
			//{
				//starEmit.destroy();
				//starEmit = null;
			//}
			ClearImage();
			HideEmotion();
			
			if (GuiFishStatus.IsVisible)
			{
				GuiFishStatus.Hide();
			}
		}
		
		public function Hide():void
		{
			if (chatbox)
			{
				chatbox.Hide();
			}
			Clear();
			IsHide = true;			
		}
		
		public function Show():void
		{
			ShowEmotion();		
			RefreshImg();	
			IsHide = false;
		}
		
		public function HideEmotion():void
		{
			if (EmoImg != null)
			{ 
				EmoImg.MyFish = null;
				EmoImg.Destructor();
				EmoImg = null;
			}
		}
		
		public function ShowEmotion():void
		{
			RefreshEmotion();
		}
		
		public function ChangePeriodEvent(period:int):void
		{
			if (IsEgg) return;			
			if (NumUpLevel >= 1)	return;
						
			//Update trạng thái phát triển của cá			
			if (period < 0)
			{
				SetAgeState(EGG);
			}
			else if (period <= 2)
			{				
				SetAgeState(BABY);
			}
			else
			{
				SetAgeState(OLD);				
			}			
			
			//Neu cham soc duoc thi hien emotion len
			if (CanCare())
			{
				SetEmotion(CANCARE);
			}
			else
			{
				if (Period >= GROWTH_UP && Emotion == CANCARE)
				{
					if(DomainFish() <= 0)
					{
						SetEmotion(IDLE);
					}
					else
					{
						SetEmotion(DOMAIN + DomainFish());
					}
				}
			}
		}
		
		public override function OnDestructor():void
		{
			Hide();
			HideEmotion();
			if (musicEmit != null)
			{
				musicEmit.destroy();
				musicEmit = null;
			}
			if (ghostEmit != null)
			{
				ghostEmit.destroy();
				ghostEmit = null;
			}
			//if (starEmit != null)
			//{
				//starEmit.destroy();
				//starEmit = null;
			//}
			if (GuiFishStatus != null)
			{
				GuiFishStatus.Hide();
			}			
		}
		
		override public function SetHighLight(color:Number = 0x00FF00):void 
		{
			super.SetHighLight(color);
			if (EmoImg)
			{
				EmoImg.SetHighLight(color);
			}
			
			//Nếu là cá đặc biệt và bỏ highlight thì set lại aura
			if (color == -1 && img != null && FishType == FISHTYPE_RARE)
			{
				TweenMax.to(img, 1, {glowFilter:{color:getAuraColor(), alpha:1, blurX:20, blurY:20, strength:1.5}});
			}			
		}
		
		
		public function UpdateColor():void
		{
			//ColorLevel = Ultility.RandomNumber(0, 2);
			var a:Array = Config.getInstance().GetFishColor(FishTypeId, ColorLevel);
			var i:int;
			var c:ColorTransform;
			
			for (i = 0; i < a.length; i++)
			{
				var obj:Object = a[i];
				c = new ColorTransform(1, 1, 1, 1, obj["Red"], obj["Green"], obj["Blue"], obj["Alpha"]);
				ChangeColor(c, obj["Key"]);
			}
			
			//Đổi màu cả con cá cho hợp với màu xanh của nước
			c = new ColorTransform(0.90, 0.95, 0.90, 1);
			img.transform.colorTransform = c;
		}
		
		public function getAuraColor():int
		{
			var t:int = 0;
			for (var i:String in RateOption) 
			{
				if (i.match(OPTION_MONEY) && RateOption[i] > 0)
				{
					t = AURA_COLOR_GOLD;
				}
				else if (i.match(OPTION_EXP) && RateOption[i] > 0)
				{
					t = AURA_COLOR_EXP;
				}
				else if (i.match(OPTION_MIX_RARE) && RateOption[i] > 0)
				{
					t = AURA_COLOR_MIX;
				}
				else if (i.match(OPTION_TIME) && RateOption[i] > 0)
				{
					t = AURA_COLOR_OTHER;
				}					
			}
			return t;
		}
		
		/**
		 * @param	event: Sự kiện cá sẽ nói
		 * @param	time: thời gian chatbox tồn tại, đơn vị milisecond, mặc định 5 giây
		 * @param	rate: tỉ lệ xuất hiện câu nói cho mỗi con cá, càng nhỏ càng cao, mặc định 1/20
		 */
		public function Chatting(event:String = "", time:int = 5000, rate:int = 20):void
		{
		//	return;
			// Lải nhải
			if (img == null || IsEgg || IsHide)
			{
				return;
			}
			if (event == "")
			{
				chatbox.Hide();
				return;
			}
			var i:int = Ultility.RandomNumber(1, 15);
			var st:String = Localization.getInstance().getString("Chat" + event + i);
			
			if (Math.round(Ultility.RandomNumber(0, rate)) <= 1)		
			{
				var format: TextFormat = new TextFormat;
				format.font = "Arial";
				format.size = 12;
				if (chatbox.ContentImg == "imgThinkContent2")
				{
					format.color = "0xD71717";
					format.italic = true;
				}
				format.bold = true;
				format.align = "center";
				chatbox.Show(st, time, format);
			}
		}
		
		public override function OnStartDrag():Boolean
		{			
			if (!Ultility.IsInMyFish() || LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)	
				return false;
			if (img.x > SwimingArea.right || img.x < SwimingArea.left || 
				img.y < SwimingArea.top || img.y > SwimingArea.bottom + 80)
			{
				finisDrag();
				return false;
			}
			
			GameLogic.getInstance().CountHerd = 13;
			switch(GameLogic.getInstance().gameState)
			{
				case GameState.GAMESTATE_IDLE:
				{
					if (GameLogic.getInstance().user.IsViewer() || (Emotion == FishSoldier.DEAD))
					{
						return false;
					}
					SetHighLight();
					SetMovingState(FS_IDLE);
					ChangeLayerAttachConent(Constant.ACTIVE_LAYER);
					if (GuiMgr.getInstance().GuiFishInfo.IsVisible)
						GuiMgr.getInstance().GuiFishInfo.Hide();
					dragingFish = this;					
					return true;
				}
				default:
					return false;
			}
		}

		public override function OnFinishDrag():Boolean
		{
			//var a:int = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenHeight;
			//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenWidth, LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenHeight - 80));
			//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenWidth, Constant.HEIGHT_LAKE));
			GameLogic.getInstance().CountHerd = 0;
			ChangeLayerAttachConent(Constant.OBJECT_LAYER);
			this.SetMovingState(Fish.FS_SWIM);
			this.SetHighLight( -1);
			dragingFish = null;
			
			if (GuiMgr.getInstance().GuiMain.MovedFishLake >= 0)
			{
				return GuiMgr.getInstance().GuiMain.ChangeLake(GuiMgr.getInstance().GuiMain.MovedFishLake, this);
			}
			if (img != null)
			{
				if (img.x > SwimingArea.right || img.x < SwimingArea.left || 
					img.y < SwimingArea.top || img.y > SwimingArea.bottom)
						return false;
			}
					
			return true;
		}		
		
		public override function OnDragOver(obj:Object):void
		{
			var i:int = 0;
			var button:Button = null;
			var point: Point;
			var container: Container;
			var arr: Array;
			if (GameLogic.getInstance().user.IsViewer())
			{
				return;
			}
			
			for (i = 0; i < GuiMgr.getInstance().GuiMain.btnLakeArr.length; i++ )
			{
				container = GuiMgr.getInstance().GuiMain.btnLakeArr[i];
				button = container.ButtonArr[0] as Button;
				if (button.img.hitTestPoint(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y))
				{
					point = new Point(55 + i * 45, -11);
					container.img.scaleX = 1.2;
					container.img.scaleY = 1.2;
					container.SetPos(point.x, point.y);
					arr = container.IdObject.split("_");
					GuiMgr.getInstance().GuiMain.MovedFishLake = arr[1];
				}
				else
				{
					if (container.img.scaleX != 1.0)
					{
						point = new Point(55 + i * 45, -11);
						container.img.scaleX = 1.0;
						container.img.scaleY = 1.0;
						container.SetPos(point.x, point.y);
						GuiMgr.getInstance().GuiMain.MovedFishLake = -1;
					}
				}
			}
		}
		
		public function UpdateHavestTime(): void
		{
			//var obj:Object = GameLogic.getInstance().user.CurLake.Option;
			HarvestTime = ConfigJSON.getInstance().getFishHarvest(FishTypeId, FishType, this);
			if(Ultility.IsInMyFish())
			{
				if (FishType != FISHTYPE_SOLDIER)
				{
					var optionTime:Number = 0;
					var lake:Lake = GameLogic.getInstance().user.GetLake(this.LakeId);
					if (lake != null)
					{
						if (lake.Option == null)
						{
							lake.Option = new Object();
						}
						if (!lake.Option.Time)
						{
							lake.Option.Time = 0;
						}
						optionTime = lake.Option.Time;
					}
					HarvestTime = HarvestTime * (1 - Math.min(optionTime, 50) / 100);
				}
			}
			// Dành cho con cá có trưởng thành và tuối khác nhau
			//AgeTime = ConfigJSON.getInstance().getFishHarvest(FishTypeId, FishType,this, true);
			//AgeTime = HarvestTime * (1 - Math.min(GameLogic.getInstance().user.CurLake.Option["Time"], 50) / 100);
			//if (NumUpLevel && NumUpLevel > 0 && FishType != FISHTYPE_NORMAL) 
			//{
				//HarvestTime = AgeTime;
			//}
		}			
		
		/**
		 * Update vị trí bóng của cá theo thông tin 
		 * @param	speed
		 */
		public function updateShadow():void
		{
			if (shadow == null) return;
			shadow.x = img.x;
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				//shadow.y = img.y + img.height;
				//if (img.y<600&&img.y>575)
				//{
					//shadow.y = img.y + 60;
				//}
				//else if(img.y<
				shadow.y = img.y + 60;
				return;
			}
			var lakeBottom:Number = GameController.getInstance().GetLakeBottom();
			curDeep += -(rateDeep * Math.abs(SpeedVec.x));
			if (shadow.y <= img.y + img.height)
			{
				shadow.y = img.y + img.height;
				curDeep = (lakeBottom - shadow.y) / SHADOW_SCOPE;
			}
			if (curDeep >= 1)
			{
				curDeep = 1;
			}
			if (curDeep <= 0)
			{
				curDeep = 0;
			}
			shadow.scaleX = shadow.scaleY = 1.4 - 0.7*curDeep;
			
			shadow.y = lakeBottom - curDeep * SHADOW_SCOPE;			
			
		}
		
		/**
		 * Cập nhật việc nhả bong bóng của cá
		 */
		public function updateGushBall():void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var num:int = (curTime - PocketStartTime) / gushBallTime;
			num = Math.min(num, TotalBalloon);
			num = Math.min(num, limitedBalloon);
			if (num > balloonNum)
			{				
				gushBalloon();						
			}
			else if (num == limitedBalloon)
			{
				if (PocketStartTime < curTime - (limitedBalloon + 1) * gushBallTime)
				{
					PocketStartTime = curTime - (limitedBalloon + 1) * gushBallTime;
				}
			}			
		}
		
		/**
		 * Tính toán số bong bóng của mỗi con cá khi khởi tạo game
		 */
		public function initBalloon():void
		{
			balloonNum = 0;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var numBalloon:int = (curTime - PocketStartTime) / gushBallTime;	
			numBalloon = Math.min(numBalloon, TotalBalloon);
			numBalloon = Math.min(numBalloon, limitedBalloon);
			var bl:Balloon = null;
			for (var i:int = 0; i < numBalloon; i++) 
			{				
				bl = new Balloon(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Balloon");				
				bl.SetPos(Ultility.RandomNumber(400, 1000), 310 + Ultility.RandomNumber(-5, 5));
				bl.setBob(310);
				bl.setMyFish(this);
				GameLogic.getInstance().balloonArr.push(bl);
				balloonNum++;
				TotalBalloon--;				
			}		
		}		
		
		/**
		 * Phun ra 1 quả bóng từ vị trí hiện tại của cá
		 */
		public function gushBalloon():void
		{
			var bl:Balloon = new Balloon(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Balloon");
			bl.SetPos(CurPos.x + OrientX * img.width/2, CurPos.y);
			bl.setBuble(new Point(OrientX * (3 + Math.random() * 3), 0), 310);
			bl.setMyFish(this);
			GameLogic.getInstance().balloonArr.push(bl);
			balloonNum++;
			TotalBalloon--;
			var curTime:Number = GameLogic.getInstance().CurServerTime;			
		}		
		
		public function collectBalloon(isSendData:Boolean = true, isAddMoney:Boolean = true,isMagnet:Boolean=false):void
		{
			balloonNum--;
			if(isAddMoney)
				GameLogic.getInstance().user.UpdateUserMoney(moneyBalloon);
			var curTime:Number = GameLogic.getInstance().CurServerTime;				
			PocketStartTime += gushBallTime;						
			if (isSendData)
			{
				var user:User = GameLogic.getInstance().user;
				var cmd:SendCollectMoney = new SendCollectMoney(user.CurLake.Id, user.Id);
				cmd.isMagnet = isMagnet;
				cmd.AddNew(Id);
				Exchange.GetInstance().Send(cmd);			
			}
			
			//Ghi lại nhật kí
			if(GameLogic.getInstance().user.IsViewer())
				GameLogic.getInstance().log.AddAct(LogInfo.ID_STEAL_MONEY, moneyBalloon);
		}
		
		public function onClickEmotion():void
		{
			switch(Emotion)
			{
				case Fish.HAPPY:
					break;
					
				case Fish.IDLE:
					break;
					
				case Fish.SAD:
					break;
					
				case Fish.ILL:
					GameLogic.getInstance().CureFish(this);
					break;
					
				case Fish.LOVE:					
					break;
					
				case Fish.CANCARE:
					if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
					GameLogic.getInstance().CareFish(this);
					break;
					
				case Fish.HUNGRY:
					//GuiMgr.getInstance().GuiMain.StartFeedFish();
					if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
					GameController.getInstance().UseTool("FeedFish");
					break;
				case Fish.GIFT:
				{
					if(!GameLogic.getInstance().user.IsViewer())
					{
						AcceptGift();
						//fish.SetEmotion(Fish.IDLE);
						//if ((fish.Level - 50 - 1 % 6) == 0)
						if(DomainFish() <= 0)
						{
							SetEmotion(Fish.IDLE);
						}
						else
						{
							SetEmotion(Fish.DOMAIN + DomainFish());
						}
					}
				}
				break;
				
				// Click trạng thái cá lính
				case FishSoldier.REWARD:
					if (Ultility.IsInMyFish() && !GameLogic.getInstance().user.IsViewer())
					{
						GuiMgr.getInstance().guiDiarySolider.showGUI(FishSoldier(this));
						//var fsld: FishSoldier = this as FishSoldier;
						//fsld.GetRewards();
					}
					break;
				case FishSoldier.WEAK:
					// Pop up hồi phục sức khỏe nhanh
					var fs1: FishSoldier = this as FishSoldier;
					//if (Ultility.IsInMyFish() && (!GameLogic.getInstance().user.IsViewer() || fs1.isActor == FishSoldier.ACTOR_MINE))
					if (!GameLogic.getInstance().user.IsViewer() || fs1.isActor == FishSoldier.ACTOR_MINE)
					{
						GuiMgr.getInstance().GuiRecoverHealth.Init(fs1);
					}
					break;
				case FishSoldier.REVIVE:
					// Pop up hồi sinh cá
					var fs: FishSoldier = this as FishSoldier;
					//if (Ultility.IsInMyFish() && (!GameLogic.getInstance().user.IsViewer() || fs.isActor == FishSoldier.ACTOR_MINE))
					if ((!GameLogic.getInstance().user.IsViewer() || fs.isActor == FishSoldier.ACTOR_MINE))
					{
						GuiMgr.getInstance().GuiReviveFishSoldier.Init(fs);
					}
					break;
				case FishSoldier.WAR:
					processChooseFishWar();
					break;
			}
		}
		
		public function processChooseFishWar():void
		{
			if (GameInput.getInstance().lastAttackTime >= GameLogic.getInstance().CurServerTime - Exchange.GetInstance().TIMEOUT / 1000)
			{
				return;
			}
			
			if (!GameLogic.getInstance().user.CurSoldier[0])
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg25"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			var mySoldier:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			var energyCost:int = ConfigJSON.getInstance().getEnergyForAttack(mySoldier.Rank);// ConfigJSON.getInstance().getItemInfo("RankPoint", mySoldier.Rank).AttackEnergy;// Math.floor(mySoldier.Damage / 20);
			if (energyCost > GameLogic.getInstance().user.GetEnergy())
			{
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 1);
				return;
			}
			
			if (Emotion == FishSoldier.WAR)
			{
				 //Chiến cá thường
				if (mySoldier.Health < Constant.MIN_HEALTH_NORMAL)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg9"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
				
				GameLogic.getInstance().user.CurSoldier[1] = this;
				
				var theirFish:Fish = GameLogic.getInstance().user.CurSoldier[1];
				
				//Gửi gói tin oánh nhau lên
				var obj:Object = new Object();
				obj["myFishId"] = mySoldier.Id;
				obj["myLakeId"] = mySoldier.LakeId;
				obj["theirId"] = GameLogic.getInstance().user.Id;
				obj["theirLake"] = GameLogic.getInstance().user.CurLake.Id;
				obj["VictimId"] = theirFish.Id;
				var fight:SendAttackFriendLake = new SendAttackFriendLake(obj);
				Exchange.GetInstance().Send(fight);
				
				// Lưu lại thời gian click gửi gói tin để chặn ko cho gửi nữa
				GameInput.getInstance().lastAttackTime = GameLogic.getInstance().CurServerTime;
			}
			else //if (FishType != FISHTYPE_SOLDIER)
			{
				// Cho cá lảm nhảm đánh cá lính đê
				Chatting("Refuse", 3000, 1);
			}
			
			var a:Array = GameLogic.getInstance().user.CurSoldier;
		}
		
		public function OnMouseOutFish():void
		{
			SetHighLight( -1);
			SetMovingState(Fish.FS_SWIM);
			GameInput.getInstance().ViewFishInfo(this, false);
		}
		
		public function AtoB():void
		{
			if (AtoBTime <= 0)
			{
				SetMovingState(FS_SWIM);
				return;
			}
			
			if (IsEgg)
			{
				return;
			}
			if (SwimingArea.width == 0 && SwimingArea.height == 0)
			{
				return;
			}
			
			if (DesPos.x != posA.x && DesPos.y != posA.y
				&& DesPos.x != posB.x && DesPos.y != posB.y)
			{
				DesPos = posA;
			}
			
			PrepareMoving(DesPos, 10, false);
			
			UpdateObject();			
			updateShadow();
			
			var temp:Point = CurPos.subtract(DesPos);
			if (changeSpeedDistance != 0)
			{
				if(!IsFishKing && State != FS_HERD)
					if (temp.length <= changeSpeedDistance)
					{
						curSpeed -= 0.12;
						if (curSpeed <= 1) {curSpeed = 1;}
					}
					else
					{
						curSpeed += 0.15;
						if (curSpeed >= realMaxSpeed) {curSpeed = realMaxSpeed;}
					}
				else 	curSpeed = 2 - ChangCurSpeed;
			}
			SpeedVec.normalize(curSpeed);
			CheckSwimingArea();
			
			if (ReachDes)
			{
				AtoBTime--;
				if (DesPos == posA)
				{
					DesPos = posB;
				}
				else
				{
					DesPos = posA;
				}
			}
			
			if (State == FS_HERD) 	realMaxSpeed = GameLogic.getInstance().user.FishKing.realMaxSpeed;
			if (State == FS_HERD) 	realMaxSpeed = GameLogic.getInstance().user.FishKing.realMaxSpeed;
			if (chatbox && this.img)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
		}
	}
}
