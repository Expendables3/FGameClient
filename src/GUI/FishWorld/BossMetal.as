package GUI.FishWorld 
{
	import Logic.BaseObject;
	import adobe.utils.CustomActions;
	import com.greensock.motionPaths.RectanglePath2D;
	import com.greensock.plugins.BezierPlugin;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GUI.component.ProgressBar;
	import GUI.FishWar.FishWar;
	import GUI.FishWar.GUIReviveFishSoldier;
	import GUI.FishWorld.Network.SendAttackBoss;
	import GUI.FishWorld.Network.SendAttackWorld;
	import GUI.FishWorld.Network.SendLoadOcean;
	import GUI.GUIFeedWall;
	import GUI.GUIFishStatus;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.ExplodeEmit;
	import particleSys.myFish.GhostEmit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BossMetal extends BaseObject 
	{
		public static const ITEM_TYPE:String = "Boss";
		public static const SEPARATE:String = "_";
		
		public static const GOLD:String = "Gold";
		public static const NORMAL:String = "Normal";
		
		public static const IDLE:String = "Idle";
		public static const ATTACK:String = "Attack";
		public static const SHOCK:String = "Shock";
		public static const DEAD:String = "Dead";
		public static const SHIELD:String = "Shield";
		
		
		public static const ATTACK_NORMAL:int = 0;
		public static const ATTACK_CRITICAL:int = 1;
		public static const ATTACK_MISS:int = 2;
		
		public static const BOSS_STATE_IDLE_NORMAL:int = 0;
		public static const BOSS_STATE_ATTACK_NORMAL:int = 1;
		public static const BOSS_STATE_DEAD_NORMAL:int = 2;
		public static const BOSS_STATE_SHIELD:int = 3;
		public static const BOSS_STATE_HURT_GOLD:int = 4;
		//public static const BOSS_STATE_ATTACK_GOLD:int = 4;
		//public static const BOSS_STATE_IDLE_GOLD:int = 5;
		
		public const DIRECTION_RIGHT:int = 1;
		public const DIRECTION_X:int = 0;
		public const DIRECTION_Y:int = 0;
		
		public var aboveContent:Sprite = new Sprite();					//Layer add những conent đi kèm cá mà nằm dưới content cá
		
		public static const BOSS_STATE_HORN_BREAKED_0:int = 0;
		public static const BOSS_STATE_HORN_BREAKED_1:int = 1;
		public static const BOSS_STATE_HORN_BREAKED_2:int = 2;
		public static const BOSS_STATE_HORN_BREAKED_3:int = 3;
		public static const BOSS_STATE_HORN_BREAKED_4:int = 4;
		
		public const STATE_GO_IDLE:int = 0;
		public const STATE_GO_STANBY:int = 2;
		public const STATE_GO_RUN:int = 1;
		
		public static const ATTACK_LOSE:int = 0;
		public static const ATTACK_WIN:int = 1;
		
		public static const ID_TACTIC_BOSS:int = 0;
		public static const ID_TACTIC_ME:int = 1;
		
		public static const STATE_NOT_SEND_SERVER:int = -1;
		public static const STATE_WAITING_SERVER:int = 0;
		public static const STATE_HAD_SERVER:int = 1;
		public static const STATE_PROCESSED_SERVER:int = 2;
		
		public static const IS_SUB_BOSS:int = 0;
		public static const IS_BOSS:int = 1;
		
		public var directionX:int = 1;
		public var directionY:int = 1;
		public var vtocX:Number = 1;
		public var vtocY:Number = 1;
		public var StateGo:Number = 1;
		public var isPreparingAttackWithBoss:Boolean = false;
		
		public var NumFrameWaitWhenBossDeed:int = 0;
		public var MaxFrameWaitWhenBossDeed:int = 600;
		public var StateWaitDataServer:int = -1;
		public var data_Server:Object;
		
		public var CurLabelAttack:String = "";
		
		public var objAllBonus:Object;
		public var arrScene:Array;
		public var arrSceneBackUp:Array;
		//public var arrFishSoldierUpdate:Array;
		
		public var isFinishAttackOfBoss:Boolean = false;
		public var isFinishAttackOfSolider:Boolean = false;
		public var isLoadContentok:Boolean = true;
		public var isAttacking:Boolean = false;
		public var isBossLoose:Boolean = false;
		public var isBossWinServer:Boolean = false;
		public var numFrameEf:int = -1;
		public var NumFramePlay:int = 200;
		public var ArrChildHide:Array = [];
		public var NumChildMovie:int = 7;
		public var curDeep:Number = Math.random();
		public var State:int = BOSS_STATE_SHIELD;
		public var NextState:int = BOSS_STATE_SHIELD;
		
		public var numSubBossHave:int = 4;
		public var numSubBossDie:int = 0;
		
		public var numHornBreaked:int = 0;
		public var idOceanSea:int = 1;	// Biển Kim có id là 1
		public var IdBoss:int;			// Id của con boss
		public var IsBoss:int = IS_SUB_BOSS;			// Id của con boss
		public var arrMaxHpSolider:Array = [];			// Máu tối đa của cá đánh
		public var MaxHp:int;			// Máu tối đa của boss
		public var CurHp:Number;			// Máu hiện tại của boss
		public var isSetCurHP:Boolean = false;
		public var Attack:int;			// công của boss
		public var Defend:int;			// thủ của boss
		
		public var arrFishSolider:Array;
		public var arrIdFishAttack:Array = [];
		public var arrFishSoliderWar:Array;
		public var numFishSoldierFinishEff:int = 0;
		
		//public var basePos:Point;
		public var mov:MovieClip;
		
		public var curPercentGetGift:int = 0;
		public var numFrameWait:int = 0;
		
		public var isStopMovWhenDead:Boolean = false;
		public var isStartWaitEffParticle:Boolean = false;
		public var NumWaitEffParticle:int = 0;
		
		public var stanbyPos:Point = new Point();
		
		//Particle
		public var explodeEmit:ExplodeEmit = null;
		
		public function BossMetal(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			aboveContent.cacheAsBitmap = true;
			this.ClassName = "BossMetal";
		}
		
		public function Init(posX:int, posY:int):void 
		{
			SetDeep(curDeep);
			SetPos(posX, posY);
			//StateGo = STATE_GO_RUN;
			SetMovingState(STATE_GO_RUN);
			ReachDes = true;
			SetHornInfo();
			isStopMovWhenDead = false;
		}
		
		public function SetStanbyPos(stbPos:Point):void 
		{
			stanbyPos = stbPos;
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
			var t:Transform = img.transform;
			var c:ColorTransform = new ColorTransform(0.4+0.6*(1-deep), 0.4+0.6*(1-deep), 0.8+0.2*(1-deep), 1);
			img.transform.colorTransform = c;
		}
		
		public function SetMovingState(MoveState:int):void 
		{
			StateGo = MoveState;
		}
		
		public function ResetAll():void 
		{
			//Giải phóng particle
			if (explodeEmit)
			{
				explodeEmit.destroy();
				explodeEmit = null;		
			}
			isAttacking = false;
			GameLogic.getInstance().isAttacking = false;
			Destructor();
			GuiMgr.getInstance().GuiMainFishWorld.prgBossArmorMetal = null;
			GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthMetal = null;
			ClearPrg();
			
		}
		
		public function ClearPrg():void 
		{
			GuiMgr.getInstance().GuiMainFishWorld.RemoveAllProgressBar();
		}
		public function SetStateBoss(bossState:int):void
		{
			if (bossState == State)
			{
				if(State != BOSS_STATE_DEAD_NORMAL && State != BOSS_STATE_HURT_GOLD && State != BOSS_STATE_SHIELD)
				{
					PlayCurState();
				}
				return;
			}
			
			ClearImage();
			State = bossState;
			switch(bossState)
			{
				//case BOSS_STATE_ATTACK_GOLD:
					//LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + ATTACK + SEPARATE + GOLD);
					//break;
				case BOSS_STATE_ATTACK_NORMAL:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + ATTACK + SEPARATE + NORMAL);
					break;
				case BOSS_STATE_DEAD_NORMAL:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + DEAD + SEPARATE + NORMAL);
					break;
				case BOSS_STATE_SHIELD:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + SHIELD);
					break;
				case BOSS_STATE_HURT_GOLD:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + SHOCK + SEPARATE + GOLD);
					break;
				//case BOSS_STATE_IDLE_GOLD:
					//LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + IDLE + SEPARATE + GOLD);
					//break;
				case BOSS_STATE_IDLE_NORMAL:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + IDLE + SEPARATE + NORMAL);
					break;
			}
		}
		
		public function SetHornInfo():void 
		{
			numHornBreaked = Math.max(Math.floor(5 - CurHp / MaxHp * 5), 0);
		}
		
		/**
		 * Boss đi đến vị trí có tọa độ pos với vận tốc là vanToc
		 * @param	pos
		 * @param	vanToc
		 */
		public function GotoPos(pos:Point, vanToc:Number = 5):void 
		{
			if (DesPos == null)	DesPos = new Point();
			if (CurPos == null)	CurPos = new Point();
			DesPos.x = pos.x;
			DesPos.y = pos.y;
			// Xac dinh huong theo truc X
			if ((DesPos.x - CurPos.x) == 0)
			{
				directionX = DIRECTION_X;
			}
			else
			{
				directionX = Math.abs(DesPos.x - CurPos.x) / (DesPos.x - CurPos.x)
			}
			
			// Xac dinh huong theo truc Y
			if ((DesPos.y - CurPos.y) == 0)
			{
				directionY = DIRECTION_Y;
			}
			else
			{
				directionY = Math.abs(DesPos.y - CurPos.y) / (DesPos.y - CurPos.y)
			}
			
			var posDirection:Point = GetRotationXZ();
			img.rotationX = posDirection.x;
			img.rotationZ = posDirection.y;
			
			vtocX = 1 + Math.random() * 4;
			vtocY = Math.abs((DesPos.y - CurPos.y) / ((DesPos.x - CurPos.x) / vtocX));
			if (vtocX > vtocY)
			{
				vtocY = vtocY * (vanToc / vtocX);
				vtocX = vanToc;
			}
			else 
			{
				vtocX = vtocX * (vanToc / vtocY);
				vtocY = vanToc;
			}
			ReachDes = false;
		}
		
		/**
		 * Hàm cho con cá bơi lung tung
		 */
		private function randomPosBoss():void 
		{
			if (StateGo == STATE_GO_IDLE)	return;
			if (CurPos == null)	return;
			var a:int;		// Gia tốc
			var v:int;		// Vận tốc
			if (Math.abs(CurPos.x - stanbyPos.x) > 2)
			{
				SpeedVec.x = (CurPos.x - stanbyPos.x) / Math.abs(CurPos.x - stanbyPos.x) * Math.abs(CurPos.x - stanbyPos.x) / 7;
				SpeedVec.y = 0;
			}
			else if (CurPos.y <= stanbyPos.y + 7 && SpeedVec.y > 0)
			{
				SpeedVec.y = Math.random() * 0.3 + 0.2;
				SpeedVec.x = 0;
			}
			else if (CurPos.y >= stanbyPos.y - 7)
			{
				SpeedVec.y = -(Math.random() * 0.3 + 0.2);
				SpeedVec.x = 0;
			}
			else
			{
				SpeedVec.y = -SpeedVec.y;
				SpeedVec.x = 0;
			}
			CurPos.y += SpeedVec.y;
			CurPos.x -= SpeedVec.x;
			SetPos(CurPos.x, CurPos.y);
		}
		
		public function GotoPosNew(pos:Point):void 
		{
			stanbyPos = pos;
		}
		
		private function randomPosBossOld():void 
		{
			var boundXRight:Number = (Constant.MAX_WIDTH + Constant.STAGE_WIDTH) / 2 + 100;
			var boundXLeft:Number = (Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2 + 200;
			var boundYUp:Number = 200;
			var boundYDown:Number = 450;
			// Nếu boss đang trong trạng thái hình ảnh là idle thì mới cho chạy
			if (State != BOSS_STATE_SHIELD && State != BOSS_STATE_IDLE_NORMAL)	return;
			if (StateGo == STATE_GO_IDLE)	return;
			if (CurPos == null)	return;
			if(ReachDes)
			{
				var vtocMax:Number = 3;
				ReachDes = false;
				DesPos = new Point();
				DesPos.y = boundXLeft + Math.random() * (boundXRight - boundXLeft);
				DesPos.x = boundYUp + (boundYDown - boundYUp) * Math.random();
				var rateXY:Number = Math.abs((DesPos.y - CurPos.y) / (DesPos.x - CurPos.x));
				while (!CheckSwimmingArea(DesPos)) 
				{
					DesPos.x = boundXLeft + Math.random() * (boundXRight - boundXLeft);
					DesPos.y = boundYUp + (boundYDown - boundYUp) * Math.random();
				}
				// Xac dinh huong theo truc X
				if ((DesPos.x - CurPos.x) == 0)
				{
					directionX = DIRECTION_X;
				}
				else
				{
					directionX = Math.abs(DesPos.x - CurPos.x) / (DesPos.x - CurPos.x)
				}
				
				// Xac dinh huong theo truc Y
				if ((DesPos.y - CurPos.y) == 0)
				{
					directionY = DIRECTION_Y;
				}
				else
				{
					directionY = Math.abs(DesPos.y - CurPos.y) / (DesPos.y - CurPos.y)
				}
				
				var posDirection:Point = GetRotationXZ();
				img.rotationX = posDirection.x;
				img.rotationZ = posDirection.y;
				
				vtocX = 0.2 + Math.random() * 2.8;
				vtocY = Math.abs((DesPos.y - CurPos.y) / ((DesPos.x - CurPos.x) / vtocX));
				if (vtocX > vtocY && vtocX > vtocMax)
				{
					vtocY = vtocY * vtocMax / vtocX;
					vtocX = vtocMax;
				}
				if (vtocY > vtocX && vtocY > vtocMax)
				{
					vtocX = vtocX * vtocMax / vtocY;
					vtocY = vtocMax;
				}
			}
			else 
			{
				SetPos(CurPos.x + vtocX * directionX, CurPos.y + vtocY * directionY);
				var delta:Number = Math.sqrt(vtocX * vtocX + vtocY * vtocY + 4);
				var nowDelta:Number = CurPos.subtract(DesPos).length;
				
				if (nowDelta < delta)
				{
					ReachDes = true;
					if (isPreparingAttackWithBoss)
					{
						mov.rotationX = 0;
						mov.rotationZ = 0;
						SetMovingState(STATE_GO_IDLE);
					}
				}
			}
		}
		/**
		 * Hàm lấy góc quay tương ứng của con cá
		 * @return
		 */
		public function GetRotationXZ():Point
		{
			if(directionX != DIRECTION_X)
			{
				var tanAlphaR:Number = (DesPos.y - CurPos.y) / (DesPos.x - CurPos.x)
				var alphaD:Number = Math.atan(tanAlphaR) / Math.PI * 180;
				if(alphaD != 0)
				{
					alphaD = Math.abs(alphaD) / alphaD * Math.min(Math.abs(alphaD), 20);
				}
				if (directionX == DIRECTION_RIGHT)
				{
					alphaD = 180 + alphaD;
				}
			}
			else 
			{
				alphaD = directionY * 20;
			}
			if (Math.abs(alphaD) < 90)
			{
				return new Point( 0, alphaD);
			}
			else 
			{
				return new Point( -180, alphaD);
			}
		}
		/**
		 * Hàm thực hiện kiểm tra xem vị trí pos có nằm trong vùng được phép bơi của con cá không
		 * @param	pos
		 * @return
		 */
		private function CheckSwimmingArea(pos:Point):Boolean 
		{
			var boundXRight:Number = (Constant.MAX_WIDTH + Constant.STAGE_WIDTH) / 2 + 100;
			var boundXLeft:Number = (Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2 + 300;
			var boundYUp:Number = 200;
			var boundYDown:Number = 450;
			//if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				boundXLeft = (Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2 + Constant.STAGE_WIDTH / 2 - 50;
				boundXRight = (Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2 + Constant.STAGE_WIDTH + 100;
			}
			if (pos.x - img.width / 2 < boundXLeft)	return false;
			if (pos.x + img.width / 2 > boundXRight)	return false;
			if (pos.y - img.height / 2 < boundYUp)	return false;
			if (pos.y - img.height / 2 > boundYDown)	return false;
			return 	true;
		}
		/**
		 * Thực hiện các action sau khi load được hình ảnh
		 */
		override public function OnLoadResComplete():void 
		{
			InitBaseData();
			mov = img as MovieClip;
			if(State != BOSS_STATE_DEAD_NORMAL && State != BOSS_STATE_HURT_GOLD && State != BOSS_STATE_SHIELD)
			{
				PlayCurState();
			}
			if ((State == BOSS_STATE_ATTACK_NORMAL) && !isAttacking)
			{
				isAttacking = true;
			}
			img.scaleX = 0.8;
			img.scaleY = 0.8;
		}
		/**
		 * Thực hiện chọn play con boss tương ứng với state
		 */
		private function PlayCurState():void 
		{
			if (!isLoadContentok)	return;
			var i:int = 0;
			var subMov:Sprite;
			for (i = 0; i < NumChildMovie; i++) 
			{
				subMov = mov.getChildByName("Child" + i) as Sprite;
				subMov.visible = true;
			}
			var stateBoss:int = getCurrentHornInfo();
			
			var arrChildHideIdle:Array = ArrChildHide[stateBoss];
			if (State == BOSS_STATE_HURT_GOLD)
			{
				arrChildHideIdle = ArrChildHide[(stateBoss - 1)];
			}
			for (i = 0; arrChildHideIdle && i < arrChildHideIdle.length; i++)
			{
				var item:int = arrChildHideIdle[i];
				subMov = mov.getChildByName("Child" + item) as Sprite;
				subMov.visible = false;
			}
		}
		
		public function isStateGold():Boolean
		{
			if (GameLogic.getInstance().user.arrSubBossMetal && GameLogic.getInstance().user.arrSubBossMetal.length > 0)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		public function getCurrentHornInfo():int 
		{
			if(!isStateGold())
			{
				return Math.max(Math.floor(4 - CurHp / MaxHp * 4), 0);
			}
			else 
			{
				return Math.min(4 - GameLogic.getInstance().user.arrSubBossMetal.length, 3);
			}
		}
		
		public function getHornInfo():int 
		{
			return numHornBreaked;
		}
		
		/**
		 * Hàm thực hiện khởi tạo id các layer bị ẩn đi
		 */
		private function InitBaseData():void 
		{
			ArrChildHide = [];
			var ChildeHideElement:Array = [];
			// 4 trạng thái gãy 0, 1, 2, 3 sừng
			ChildeHideElement = [];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 4, 6];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 2, 4, 6];
			ArrChildHide.push(ChildeHideElement);
		}
		
		/**
		 * Lấy mảng chứa đội hình của cá
		 * @param	indexTactic
		 * @param	isMyFishes
		 * @return
		 */
		public static function GetTactic(indexTactic:int, isMyFishes:Boolean = true):Array
		{
			var arr:Array = [];
			var arrElement:Array = [];
			
			// Thế trận 1: các con cá của mình xếp thành 3 hàng 2 cột, 1 bên
			var tactic:Array = [];
			var tacticBoss:Array = [];
			var posBaseBoss:Point = new Point(Constant.MAX_WIDTH / 2 + 300, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 50);
			tacticBoss.push(posBaseBoss);
			tacticBoss.push(new Point(posBaseBoss.x - 220, posBaseBoss.y - 150));
			tacticBoss.push(new Point(posBaseBoss.x - 180, posBaseBoss.y - 50));
			tacticBoss.push(new Point(posBaseBoss.x - 180, posBaseBoss.y + 50));
			tacticBoss.push(new Point(posBaseBoss.x - 220, posBaseBoss.y + 150));
			arrElement.push(tacticBoss);
			
			var posBaseSolider:Point = new Point(Constant.MAX_WIDTH / 2 + 50, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 20);
			tactic.push(posBaseSolider);
			tactic.push(new Point(posBaseSolider.x, posBaseSolider.y - 100));
			tactic.push(new Point(posBaseSolider.x, posBaseSolider.y + 100));
			tactic.push(new Point(posBaseSolider.x - 90, posBaseSolider.y + 100));
			tactic.push(new Point(posBaseSolider.x - 90, posBaseSolider.y - 100));
			tactic.push(new Point(posBaseSolider.x - 90, posBaseSolider.y));
			arrElement.push(tactic);
			arr.push(arrElement);
			return arr[indexTactic];
		}
		
		/**
		 * Thực hiện trở về tại cá
		 */
		private function ComBackMap():void 
		{
			GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
		}
		
		override public function OnReloadRes():void 
		{
			super.OnReloadRes();
			Init(CurPos.x, CurPos.y);
			img.mouseChildren = false;
		}
		
		private function CheckBossWin():Boolean
		{
			return isBossWinServer;
		}
		
		/**
		 * Hàm chuẩn bị: các con cá còn sức khỏe vào đánh, cá con cá không còn sức khỏe thì đứng ngoài, boss về vị trí; gửi gói tin lên lấy kịch bản về
		 * @param	ArrFishSolider	:	Mảng các con cá có thể đem đi thế giới cá
		 * @param	idTactic		:	Loại Thế trận của các con cá khi đánh boss
		 */
		public function PreStartAttack(idTactic:int = 0):void 
		{
			var ArrFishSolider:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
			GameLogic.getInstance().user.UpdateEnergy(- EnergyCost);
			// Cập nhật mảng các con cá tham chiến với con boss này
			arrFishSolider = ArrFishSolider;
			arrFishSoliderWar = Ultility.GetFishSoldierCanWar();
			// Gửi gói tin đánh boss lên để lấy kịch bản về
			var fightWorld:SendAttackBoss = new SendAttackBoss(FishWorldController.GetSeaId(), IdBoss);
			Exchange.GetInstance().Send(fightWorld);
			StateWaitDataServer = STATE_WAITING_SERVER;	// Xét trạng thái hiện tại là đang chờ dữ liệu server trả về
			// Lấy vị trí đội hình các con cá
			var i:int = 0;
			var arrPosTactic:Array = GetTactic(idTactic);
			isPreparingAttackWithBoss = true;
			//GotoPosNew(new Point(arrPosTactic[ID_TACTIC_BOSS][0].x - 150, arrPosTactic[ID_TACTIC_BOSS][0].y));	// Boss đến vị trí của boss
			// Các con cá lính của mình đến vị trí của mình. Nếu không đến được thì sẽ bơi ở vùng mép bên tay trái
			var idTacticForAFish:int = 0;
			arrMaxHpSolider = [];
			// Các con cá có thể đánh boss bơi lại vị trí có thể đánh
			for (i = 0; i < arrFishSoliderWar.length; i++)
			{
				var fishSoldierInArr:FishSoldier = arrFishSoliderWar[i];
				// Lưu lại máu max của các con cá trong mảng cá tham chiến để sau khi đánh boss sẽ được reset lại
				var vitalityFishSolider:int = fishSoldierInArr.Vitality + fishSoldierInArr.bonusEquipment.Vitality + fishSoldierInArr.VitalityPlus;
				arrMaxHpSolider.push(vitalityFishSolider);
				fishSoldierInArr.SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
				fishSoldierInArr.SwimTo(arrPosTactic[ID_TACTIC_ME][idTacticForAFish].x, arrPosTactic[ID_TACTIC_ME][idTacticForAFish].y, 20, true);
				fishSoldierInArr.GuiFishStatus.ShowHPBar(fishSoldierInArr, vitalityFishSolider, arrMaxHpSolider[i]);
				idTacticForAFish++;
			}
		}
		
		public function SetDataServer(dataServer:Object):void 
		{
			// Lưu lại vào data các quà tặng mà user nhận được
			curPercentGetGift = 0;
			objAllBonus = dataServer.Bonus;
			// Lưu lại vào data kịch bản
			arrScene = dataServer.Scene;
			arrSceneBackUp = [];
			for (var k:int = 0; k < arrScene.length; k++) 
			{
				arrSceneBackUp.push(arrScene[k]);
			}
			if (dataServer.isWin == 0)
			{
				isBossWinServer = true;
			}
			else 
			{
				isBossWinServer = false;
				GuiMgr.getInstance().GuiFinalKillBoss.InitGui(objAllBonus);
			}
			//trace("Server trả về _ isBossWinServer = ", isBossWinServer)
			//trace("Trước khi cập nhật dataServer: ");
			var j:int = 0;
			var i:int = 0;
			Ultility.UpdateFishSoldier(dataServer.MySoldier, dataServer.MyEquipment.SoldierList, GameLogic.getInstance().user.FishSoldierActorMine);
			arrFishSoliderWar = Ultility.GetFishSoldierCanWar();
			var arrPosTactic:Array = GetTactic(0);
			GotoPos(new Point(arrPosTactic[ID_TACTIC_BOSS][0].x - 200, arrPosTactic[ID_TACTIC_BOSS][0].y), 7);	// Boss đến vị trí của boss
			// Các con cá lính của mình đến vị trí của mình. Nếu không đến được thì sẽ bơi ở vùng mép bên tay trái
			var idTacticForAFish:int = 0;
			arrMaxHpSolider = [];
			// Các con cá có thể đánh boss bơi lại vị trí có thể đánh
			for (i = 0; i < arrFishSoliderWar.length; i++)
			{
				var fishSoldierInArr:FishSoldier = arrFishSoliderWar[i];
				// Lưu lại máu max của các con cá trong mảng cá tham chiến để sau khi đánh boss sẽ được reset lại
				var vitalityFishSolider:int = fishSoldierInArr.Vitality + fishSoldierInArr.bonusEquipment.Vitality + fishSoldierInArr.VitalityPlus;
				arrMaxHpSolider.push(vitalityFishSolider);
				fishSoldierInArr.SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
				fishSoldierInArr.SwimTo(arrPosTactic[ID_TACTIC_ME][idTacticForAFish].x, arrPosTactic[ID_TACTIC_ME][idTacticForAFish].y, 20, true);
				fishSoldierInArr.GuiFishStatus.ShowHPBar(fishSoldierInArr, vitalityFishSolider, arrMaxHpSolider[i]);
				fishSoldierInArr.isChoose = true;
				idTacticForAFish++;
			}
			//for (j = 0; j < arrFishSoliderWar.length; j++) 
			//{
				//trace("Con cá có Id: " + arrFishSoliderWar[j].Id + " có máu lúc sau là: " + arrFishSoliderWar[j].Vitality);
			//}
			if (arrFishSoliderWar.length <= 0) 
			{
				//trace("arrFishSoliderWar.length = " + arrFishSoliderWar.length);
				var strShow:String;
				strShow = Localization.getInstance().getString("Tooltip74");
				GuiMgr.getInstance().GuiMessageBox.ShowOK(strShow, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);	
				GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
				return;
			}
			arrScene.splice(0, 1);
			StateWaitDataServer = STATE_HAD_SERVER;
		}
		/**
		 * Kiểm tra xem đã kết thúc kịch bản chưa
		 * @return
		 */
		public function CheckFinishAttack():Boolean
		{
			var result:Boolean = false;
			if (arrScene.length <= 1)
			{
				result = true;
			}
			return result;
		}
		
		/**
		 * Hàm cập nhật các eff của boss khi tất cả cùng kết thúc eff
		 */
		public function UpdateFishSoldierAfterAttacked(isAttackFinal:Boolean = false):void
		{
			var obj:Object = arrScene[0];
			var txtFormat:TextFormat;
			var fishSoldierElement:FishSoldier;
			var isFindOK:Boolean = false;
			var sp:Sprite;
			// KIểm tra xem có con cá nào tham gia đánh nhau không
			for (var i:int = 0; i < arrFishSoliderWar.length; i++) 
			{
				isFindOK = false;
				fishSoldierElement = arrFishSoliderWar[i] as FishSoldier;
				for (var s:String in obj.Vitality.Attack)
				{
					if ( s == fishSoldierElement.Id.toString() && 
						obj.Vitality.Attack[s] < (fishSoldierElement.Vitality + fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus))
					{
						isFindOK = true;
						break;
					}
				}
				if (isFindOK)	break;
			}
			// Nếu không có thì không cần cập nhật
			if (!isFindOK)	return;
			var allVitalityFish:int = (fishSoldierElement.Vitality + fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus);
			if(obj.Status.Defence != null)
			{
				if (obj.Status.Defence == ATTACK_CRITICAL)
				{
					sp = ResMgr.getInstance().GetRes("EffTxtChiMang") as Sprite;
					sp.scaleX = sp.scaleY = 0.6;
					EffectMgr.getInstance().flyBack(sp, fishSoldierElement.aboveContent, new Point(0, 0), new Point( -150, 0), new Point( -50, 0), 0.4, 0.3);
					
					txtFormat = new TextFormat("Arial", 36, 0xff0000, true);
					txtFormat.align = "center";
					EffectMgr.getInstance().textBack("-" + (allVitalityFish - obj.Vitality.Attack[fishSoldierElement.Id.toString()]), fishSoldierElement.aboveContent,
						new Point(0, 0), new Point( 0, -100), new Point( 0, -50), 1, 0.5, txtFormat);
				}
				else if (obj.Status.Defence == ATTACK_NORMAL)
				{
					txtFormat = new TextFormat("Arial", 24, 0xff0000, true);
					txtFormat.align = "center";
					EffectMgr.getInstance().textBack("-" + (allVitalityFish - obj.Vitality.Attack[fishSoldierElement.Id.toString()]), fishSoldierElement.aboveContent,
						new Point(0, 0), new Point( 0, -100), new Point( 0, -50), 1, 0.5, txtFormat);
				}
				else 
				{
					sp = ResMgr.getInstance().GetRes("EffTxtTruot") as Sprite;
					sp.scaleX = sp.scaleY = 0.6;
					EffectMgr.getInstance().flyBack(sp, fishSoldierElement.aboveContent, new Point(0, 0), new Point( -150, 0), new Point( -50, 0), 0.4, 0.3);
				}
			}
			
			fishSoldierElement.Vitality = obj.Vitality.Attack[fishSoldierElement.Id.toString()] - (fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus);
			allVitalityFish = (fishSoldierElement.Vitality + fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus);
			GameLogic.getInstance().AddPrgToProcess(fishSoldierElement.GuiFishStatus.prgHP, 
				allVitalityFish / arrMaxHpSolider[arrFishSoliderWar.indexOf(fishSoldierElement)], Constant.TYPE_PRG_HP);
			if ((fishSoldierElement.Vitality + fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus) == 0)
			{
				fishSoldierElement.SwimTo(fishSoldierElement.standbyPos.x, fishSoldierElement.standbyPos.y, 20);
			}
		}
		
		/**
		 * Hàm thực hiện sau khi đánh boss Thua và kết thúc eff
		 */
		public function FinalAttackBossWin():void 
		{
			numFishSoldierFinishEff = 0;
			isAttacking = false;
			GameLogic.getInstance().isAttacking = false;
			SetMovingState(STATE_GO_RUN);
			GuiMgr.getInstance().GuiRegenerating.initGUI(arrFishSoliderWar);
		}
		
		/**
		 * Thực hiện attack cuối cùng
		 */
		public function FinalAttack():void
		{
			var arrLogic:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			//UpdateFishSoldierAfterAttacked();
			StateWaitDataServer = STATE_NOT_SEND_SERVER;
			var i:int = 0;
			var j:int = 0;
			var item:FishSoldier
			
			for (i = 0; i < GameLogic.getInstance().user.arrSubBossMetal.length; i++)
			{
				var subBossMetal:SubBossMetal = GameLogic.getInstance().user.arrSubBossMetal[i];
				subBossMetal.SetMovingState(Fish.FS_STANDBY);
			}
			//UpdateStateBossDuringWar();
			// Cập nhật lại sức khỏe cho tất cả các mảng base bên dưới, hiện tại là chưa cập nhật
			if (CheckBossWin())
			{
				SetHornInfo();
				if(GameLogic.getInstance().user.arrSubBossMetal.length > 0)
				{
					SetStateBoss(BOSS_STATE_SHIELD);
				}
				else
				{
					SetStateBoss(BOSS_STATE_IDLE_NORMAL);
				}
				for (i = 0; i < arrFishSoliderWar.length; i++) 
				{
					item = arrFishSoliderWar[i];
					item.Health = Math.max(int(item.Health - item.MaxHealth / 2), 0);
					item.UpdateHealth(0);
					
					for (j = 0; j < arrLogic.length; j++) 
					{
						if (item.Id == (arrLogic[j] as FishSoldier).Id)
						{
							(arrLogic[j] as FishSoldier).Health = item.Health;
						}
					}
				}
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffLoseBoss", null, 
					Constant.STAGE_WIDTH / 2 + 50, 250, false, false, null, FinalAttackBossWin);
				
			}
			else 
			{
				for (i = 0; i < arrFishSoliderWar.length; i++) 
				{
					item = arrFishSoliderWar[i];
					item.Health = Math.max(int(item.Health - item.AttackPoint), 0);
					item.UpdateHealth(0);
					
					for (j = 0; j < arrLogic.length; j++) 
					{
						if (item.Id == (arrLogic[j] as FishSoldier).Id)
						{
							(arrLogic[j] as FishSoldier).Health = item.Health;
						}
					}
				}
				SetStateBoss(BOSS_STATE_DEAD_NORMAL);
				//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HOANG_SO, "Tua Rua");
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EfffKillBoss", null, 
					Constant.STAGE_WIDTH / 2 + 50, 250, false, false, null);// , FinishBossLose);
			}
			GameLogic.getInstance().bonusFishWorld = objAllBonus["100"];
			GameLogic.getInstance().dropAllGiftFishWorld();
			// Cập nhật lại item gắn kèm vào con cá vào cập nhật lại máu cho con cá
			UpdateVitalityAllFishSoldier();
			UpdateStateAllFishSoldier();
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
			{
				GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
			}
			for (var k:int = 0; k < arrFishSoliderWar.length; k++) 
			{
				var itemFS:FishSoldier = arrFishSoliderWar[k];
				if (itemFS != null && (itemFS is FishSoldier))
				{
					itemFS.SwimTo(itemFS.standbyPos.x, itemFS.standbyPos.y, 10);
				}
			}
		}
		
		/**
		 * Cập nhật lại cho tất cả các con cá: Vùng bơi, movingState, guiFishStatus.
		 */
		public function UpdateStateAllFishSoldier():void 
		{	
			var fs:FishSoldier;
			var i:int = 0;
			for (i = 0; i < arrFishSoliderWar.length; i++)
			{
				fs = arrFishSoliderWar[i] as FishSoldier;
				fs.SetMovingState(Fish.FS_SWIM);
				fs.GuiFishStatus.ShowHPBar(fs, 0, 0, false);
				// Cập nhật đồ đạc
				fs.SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
			}
			UpdateItemAttached();
			UpdateGemEffectVisibility();
		}
		
		/**
		 * Cập nhật effect gem cho các con cá
		 */
		public function UpdateGemEffectVisibility():void
		{
			for (var i:int = 0; i < arrFishSoliderWar.length; i++) 
			{
				var item:FishSoldier = arrFishSoliderWar[i];
				if (item.GemEffect)
				{
					item.aboveContent.removeChild(item.GemEffect);
					item.GemEffect = null;
					item.addGemEffect();
				}
			}
		}
		
		/**
		 * Cập nhật Gem và các buffitem vào trong 2 mảng FishSoldierActorMine và MyFishSoldierArr
		 */
		public function UpdateItemAttached():void
		{
			var i:int;
			var j:int;
			var s:String;
			var fs:FishSoldier;
			var fishSolider:FishSoldier;
			var fsLogic:FishSoldier;
			var arrTemp:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			// Cập nhật đan cho các con cá của mình đem đi tấn công
			for (j = 0; j < arrFishSoliderWar.length; j++)
			{
				fishSolider = arrFishSoliderWar[j] as FishSoldier;
				for (i = fishSolider.BuffItem.length - 1; fishSolider.BuffItem && i >= 0; i--)
				{
					if (fishSolider.BuffItem[i].Turn > 1)
					{
						fishSolider.BuffItem[i].Turn -= 1;
					}
					else
					{
						fishSolider.BuffItem.splice(i, 1);
					}
				}
				
				// Đan bạn bè buff cho nhà mình cũng được cập nhật
				if (fishSolider.UserBuff && fishSolider.UserBuff["Element"])
				{
					if (fishSolider.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)])
					{
						delete(fishSolider.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)]);
					}
					
					for (s in fishSolider.UserBuff["Elements"])
					{
						if (fishSolider.UserBuff["Elements"][s][GameLogic.getInstance().user.GetMyInfo().Id])
						{
							delete(fishSolider.UserBuff["Elements"][s][GameLogic.getInstance().user.GetMyInfo().Id]);
						}
					}
				}
				
				// Cập nhật thông tin cho con cá trong mảng logic tương ứng
				for ( i = 0; i < arrTemp.length; i++)
				{
					fsLogic = arrTemp[i];
					if (fsLogic.Id == fishSolider.Id)
					{
						fsLogic.BuffItem = fishSolider.BuffItem;
						fsLogic.UserBuff = fishSolider.UserBuff;
						break;
					}
				}
			}
			
			// Tìm con cá lính trong mySoldierARr tương ứng
			for (j = 0; j < arrFishSoliderWar.length; j++)
			{
				fishSolider = arrFishSoliderWar[j] as FishSoldier;
				// Cập nhật các gem đang đc buff trong cá mình và cá diễn viên
				// Cá mình
				for (s in fishSolider.GemList)
				{
					if(fishSolider.GemList && fishSolider.GemList[s] && fishSolider.GemList[s][0])
					{
						if (fishSolider.GemList[s][0].Turn == 1)
						{
							delete(fishSolider.GemList[s]);
						}
						else
						{
							fishSolider.GemList[s][0].Turn -= 1;
						}				
					}
				}
				
				// Cập nhật thông tin cho con cá trong mảng logic tương ứng
				for ( i = 0; i < arrTemp.length; i++)
				{
					fsLogic = arrTemp[i];
					if (fsLogic.Id == fishSolider.Id)
					{
						fsLogic.GemList = fishSolider.GemList;
						break;
					}
				}
			}
		}
		
		/**
		 * Cập nhật lại máu cho tất cả các con cá
		 */
		public function UpdateVitalityAllFishSoldier():void 
		{	
			var fs:FishSoldier;
			var i:int = 0;
			for (i = 0; i < arrFishSoliderWar.length; i++)
			{
				fs = arrFishSoliderWar[i] as FishSoldier;
				fs.Vitality = arrMaxHpSolider[i] -(fs.bonusEquipment.Vitality + fs.VitalityPlus);
				//trace("Máu của con cá có Id: " + fs.Id + " là: " + fs.Vitality);
			}
		}
		
		public function FinishBossLose():void 
		{
			numFishSoldierFinishEff = 0;
			isAttacking = false;
			isBossLoose = true;
			GameLogic.getInstance().isAttacking = false;
			isStartWaitEffParticle = true;
			//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HOANG_SO, "Tua Rua");
		}
		
		/**
		 * Bắt đầu thực hiện các effect tấn công lẫn nhau
		 */
		public function StartAttack():void 
		{	
			if(isLoadContentok)
			{
				isAttacking = true;
				// Nếu là bước tấn công cuối cùng thì thực hiện finalAttack() - có xử lý thêm 1 số công đoạn khác
				if (arrScene.length == 0)	
				{
					FinalAttack();
					return;
				}
				// Nếu chưa phải là final-hit thì thực hiện đánh qua lại giữa các con với boss
				StateWaitDataServer = STATE_PROCESSED_SERVER;
				var obj:Object = arrScene[0];
				//if(GameLogic.getInstance().user.arrSubBossMetal.length > 0)
				//{
					//SetStateBoss(BOSS_STATE_ATTACK_GOLD);
				//}
				//else 
				//{
					SetStateBoss(BOSS_STATE_ATTACK_NORMAL);
				//}
				SetHornInfo();
				numFishSoldierFinishEff = 0;
				ShowEffSoldier();
			}
			else
			{
				arrScene.splice(0, arrScene.length);
				FinalAttack();
			}
		}
		
		/**
		 * Thực hiện tấn công - cập nhật thường xuyên khi boss đang trong trạng thái tấn công
		 */
		private function ProcessAttack():void 
		{
			if (isLoadContentok)
			{
				if(mov)
				{
					// Nếu đang show eff tấn công
					if(State == BOSS_STATE_ATTACK_NORMAL)
					{
						// Nếu kết thúc eff và các con cá nhà mình đã kết thúc lượt đánh
						// thì thực hiện cập nhật trừ máu cho con cá bị boss đánh
						// và xóa đi phần tử đã được thực hiện trong kịch bản (phần tử đầu tiên)
						if(mov.currentFrame == mov.totalFrames)
						{
							if (numFishSoldierFinishEff >= arrFishSoliderWar.length)
							{
								// Nếu là final hit thì thực hiện hàm Final Attack
								// Còn nếu không thì thực hiện tiếp lượt đánh tiếp theo
								
								arrScene.splice(0, 1);	
								if (!CheckFinishAttack())	
								{
									UpdateFishSoldierAfterAttacked();
									var n:int = Math.min(Math.floor(1 + Math.random() * 3), 3); 
									SetHornInfo();
									numFishSoldierFinishEff = 0;
									ShowEffSoldier();
								}
								else 
								{
									FinalAttack();
								}
							}
							else // Nếu các con cá nhà mình chưa kết thức lượt đánh thì quay lai play tiếp
							{
								mov.gotoAndPlay(1);
							}
						}
					}
					else // Nếu đang ở trạng thái IDLE
					{
						// Nếu như kịch bản đã hết thì thực hiện hàm kết thúc
						if( !isAttacking)
						{
							if (arrScene.length <= 1)
							{
								arrScene.splice(0, arrScene.length);
								FinalAttack();
							}
							else
							{
								if (numFishSoldierFinishEff >= arrFishSoliderWar.length)
								{
									arrScene.splice(0, 1);
									numFishSoldierFinishEff = 0;
									StartAttack();
								}
							}
						}
					}
				}
			}
			else
			{
				arrScene.splice(0, arrScene.length);
				FinalAttack();
			}
		}
		
		/**
		 * Xử lý các param sau khi đánh xong
		 * @param	fishSoldierElement
		 */
		private function FinishEffSolider():void 
		{
			// Do đã check con cá có máu > 0 mới được thực hiện eff nên trong này chỉ care xem nó là chí mạng, thường hay trượt mà thôi
			// Nếu con cá không có trong mảng cá lính đem đi đánh boss thì return lại
			var isHaveFishSoldier:Boolean = false;
			var fishSoldierElement:FishSoldier;
			for (var i:int = 0; i < arrFishSoliderWar.length; i++) 
			{
				fishSoldierElement = arrFishSoliderWar[i];
				if (fishSoldierElement.Id == arrIdFishAttack[0])
				{
					isHaveFishSoldier = true;
					break;
				}
			}
			if (!isHaveFishSoldier)	
			{
				return;
			}
			// Cập nhật biến đếm số con cá đã thực hiện eff (các con cá không đánh được tự được coi là đã thực hiện eff rồi)
			numFishSoldierFinishEff++;
			
			// Thực hiện các Effect có tác dụng về mặt hiển thị
			// Tác dụng lên con Boss
			// Hiển thị eff critical nếu có
			var obj:Object = arrScene[0];
			var txtFormat:TextFormat;
			var deltaPos:Point = new Point(85 - Math.random() * 30, 50 - 35 - Math.random() * 30)
			// Nếu sau lượt tấn công có lớn hơn không (chưa thua)
			var s:Sprite;
			if (obj.Status.Attack[arrIdFishAttack[0].toString()] == ATTACK_CRITICAL)
			{
				s = ResMgr.getInstance().GetRes("EffTxtChiMang") as Sprite;
				s.scaleX = s.scaleY = 0.6;
				EffectMgr.getInstance().flyBack(s, this.img, new Point(0, 0), new Point( 150, 0), new Point( 50, 0), 0.4, 0.3);
				
				txtFormat = new TextFormat("Arial", 36, 0xff0000, true);
				txtFormat.align = "center";
				EffectMgr.getInstance().textBack("-" + int(obj.Vitality.Defence.ListAtt[arrIdFishAttack[0].toString()]).toString(), img,
					new Point(deltaPos.x, deltaPos.y), new Point( deltaPos.x, deltaPos.y - 100), new Point( deltaPos.x, deltaPos.y - 50), 1, 0.5, txtFormat);
			}
			else if (obj.Status.Attack[arrIdFishAttack[0].toString()] == ATTACK_NORMAL)
			{
				txtFormat = new TextFormat("Arial", 24, 0xff0000, true);
				txtFormat.align = "center";
				EffectMgr.getInstance().textBack("-" + int(obj.Vitality.Defence.ListAtt[arrIdFishAttack[0].toString()]).toString(), img,
					new Point(deltaPos.x, deltaPos.y), new Point( deltaPos.x, deltaPos.y - 100), new Point( deltaPos.x, deltaPos.y - 50), 1, 0.5, txtFormat);
			}
			else 
			{
				s = ResMgr.getInstance().GetRes("EffTxtTruot") as Sprite;
				s.scaleX = s.scaleY = 0.6;
				EffectMgr.getInstance().flyBack(s, this.img, new Point(0, 0), new Point( 150, 0), new Point( 50, 0), 0.4, 0.3);
				//EffectMgr.getInstance().textBack("Trượt", fishSoldierElement.img, new Point(50, 0),
					//new Point( 200, 0), new Point( 150, 0), 1, 0.5);
			}
			// Cập nhật lại máu cho hit đánh này
			CurHp = Math.max(CurHp - obj.Vitality.Defence.ListAtt[arrIdFishAttack[0].toString()], 0);
			//trace("CurHp = " + CurHp);
			//trace("arrIdFishAttack[0] = " + arrIdFishAttack[0]);
			// Nếu tất cả các con cá lính đã tấn công xong thì cập nhật lại máu cho boss
			if (numFishSoldierFinishEff >= arrFishSoliderWar.length)
			{
				CurHp = obj.Vitality.Defence.Left;
			}
			arrIdFishAttack.splice(0, 1);
		}
		
		/**
		 * Hàm thực hiện các eff đánh nhau của các con cá lính
		 */
		private function ShowEffSoldier():void 
		{
			if (arrScene[0].attackFirst != null)
			{
				arrScene.splice(0, 1);
			}
			var i:int = 0;
			var objForSub:Object = arrScene[0];
			var objForSubOld:Object = arrSceneBackUp[arrSceneBackUp.length - arrScene.length - 1];
			var isFindOK:Boolean = false;
			var fishSoldierElementForSub:FishSoldier;
			var idFishSoldierElementForSub:int;
			
			for (var s2:String in objForSub.Vitality.Attack) 
			{
				isFindOK = false;
				for (var s1:String in objForSubOld.Vitality.Attack) 
				{
					if (s1 == s2)
					{
						if (objForSub.Vitality.Attack[s2] < objForSubOld.Vitality.Attack[s1])
						{
							isFindOK = true;
						}
					}
				}
				if(isFindOK)
				{
					idFishSoldierElementForSub = int(s1);
					break;
				}
			}
			for (i = 0; i < arrFishSoliderWar.length; i++) 
			{
				fishSoldierElementForSub = arrFishSoliderWar[i] as FishSoldier;
				if (fishSoldierElementForSub.Id == idFishSoldierElementForSub)
				{
					break;
				}
			}
			
			for (i = 0; i < GameLogic.getInstance().user.arrSubBossMetal.length; i++)
			{
				var subBossMetal:SubBossMetal = GameLogic.getInstance().user.arrSubBossMetal[i];
				var subPos:Point = subBossMetal.CurPos.subtract(fishSoldierElementForSub.CurPos);
				var alpha:Number = Math.atan(subPos.y / subPos.x) / Math.PI * 180;
				subBossMetal.img.rotation = alpha;
				subBossMetal.SetMovingState(Fish.FS_ATTACK);
			}
			for (i = 0; i < arrFishSoliderWar.length; i++) 
			{
				var obj:Object = arrScene[0];
				var fishSoldierElement:FishSoldier = arrFishSoliderWar[i] as FishSoldier;
				if(fishSoldierElement.Vitality > 0)
				{
					arrIdFishAttack.push(fishSoldierElement.Id);
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffWar" + fishSoldierElement.Element, 
						null, fishSoldierElement.CurPos.x, fishSoldierElement.CurPos.y, false, false, null, function():void{FinishEffSolider()});
				}
				else 
				{
					numFishSoldierFinishEff++;
				}
			}
		}
		
		public function showGuiGift():void 
		{
			isStartWaitEffParticle = false;
			NumWaitEffParticle = 0;
			GuiMgr.getInstance().GuiFinalKillBoss.Show(Constant.GUI_MIN_LAYER, 1);
		}
		
		public function Update():void 
		{
			// đang ở trạng thái chờ đánh boss
			if (isPreparingAttackWithBoss)
			{
				// Boss đến vị trí của mình và đã nhận, xử lý 
				//if (StateGo == STATE_GO_IDLE)
				{
					if(StateWaitDataServer == STATE_HAD_SERVER)
					{
						// Nếu tất cả các con cá khỏe mạnh chưa đến vị trí thì bỏ qua
						for (var i:int = 0; i < arrFishSoliderWar.length; i++) 
						{
							var fish_Solider:FishSoldier = arrFishSoliderWar[i] as	FishSoldier;
							if (!fish_Solider.ReachDes)
							{
								break;
							}
							// Nếu tất cả đã đến vị trí thì thực hiện tấn công
							if(i + 1 == arrFishSoliderWar.length)
							{
								isPreparingAttackWithBoss = false;
								StartAttack();
							}
						}
					}
				}
			}
			
			switch (State) 
			{
				case BOSS_STATE_ATTACK_NORMAL:
				//case BOSS_STATE_ATTACK_GOLD:
					ProcessAttack();
				break;
				//case  BOSS_STATE_IDLE_GOLD:
				case  BOSS_STATE_IDLE_NORMAL:
					if (isAttacking)
					{
						ProcessAttack();
					}
				break;
				//case BOSS_STATE_ATTACK_GOLD:
					//
				//break;
				case BOSS_STATE_DEAD_NORMAL:
					if(isLoadContentok && !isStopMovWhenDead)
					{
						if (mov.currentFrame == mov.totalFrames)
						{
							mov.stop();
							isStopMovWhenDead = true;
						}
					}
					
					if (NumFrameWaitWhenBossDeed < MaxFrameWaitWhenBossDeed)
					{
						NumFrameWaitWhenBossDeed ++;
						if ( mov && mov.alpha < 0.06 && mov.alpha > 0.00000000001)
						{
							//Particle boss nổ
							if (explodeEmit)
							{
								explodeEmit.destroy();
								explodeEmit = null;						
							}
							explodeEmit = new ExplodeEmit(LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER));
							var pos:Point = Ultility.PosLakeToScreen(CurPos.x, CurPos.y);
							explodeEmit.setPos(pos.x, pos.y);					
					
							mov.alpha = 0;
							FinishBossLose();
						}
						else if (mov && mov.alpha > 0.055) 
						{
							mov.alpha -= 0.005;
						}
					}
					//else if (NumFrameWaitWhenBossDeed == MaxFrameWaitWhenBossDeed)
					//{
						//NumFrameWaitWhenBossDeed ++;
						// Trở về Bản đồ
						//ComBackMap();
					//}
					
				break;
			}
	
			if (mov && StateGo != STATE_GO_IDLE)	randomPosBoss();
			
			//Update particle boss chet
			if (explodeEmit)
			{
				explodeEmit.updateEmitter();
				
			}
			
			// Chờ particle
			if (isStartWaitEffParticle)
			{
				NumWaitEffParticle++;
				if (NumWaitEffParticle >= 150)
				{
					showGuiGift();
				}
			}
		}
	}

}