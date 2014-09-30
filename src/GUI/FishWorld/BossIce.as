package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.FishWorld.Network.SendAttackBoss;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.ExplodeEmit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BossIce extends BaseObject 
	{
		public static const ITEM_TYPE:String = "Boss";
		public static const IDLE:String = "Idle";
		public static const ATTACK:String = "Attack";
		public static const HURT:String = "Hurt";
		public static const DEAD:String = "Dead";
		
		public const STATE_GO_IDLE:int = 0;
		public const STATE_GO_STANBY:int = 2;
		public const STATE_GO_RUN:int = 1;
		
		public static const BOSS_STATE_IDLE:int = 0;
		public static const BOSS_STATE_ATTACK:int = 1;
		public static const BOSS_STATE_DEAD:int = 3;
		public static const BOSS_STATE_HURT:int = 2;
		
		public static const BOSS_ICE_NAME:String = "Boss2";
		public static const BOSS_HURT_NAME:String = "Cutoff";
		public static const BOSS_IDLE_NAME:String = "Idle";
		public static const BOSS_ATTACK_NAME:String = "Attack";
		public static const SEPERANT:String = "_";
		
		public const DIRECTION_RIGHT:int = 1;
		public const DIRECTION_X:int = 0;
		public const DIRECTION_Y:int = 0;
		
		public static const ID_TACTIC_BOSS:int = 0;
		public static const ID_TACTIC_ME:int = 1;
		
		public static const ATTACK_NORMAL:int = 0;
		public static const ATTACK_CRITICAL:int = 1;
		public static const ATTACK_MISS:int = 2;
		
		public static const STATE_NOT_SEND_SERVER:int = -1;
		public static const STATE_WAITING_SERVER:int = 0;
		public static const STATE_HAD_SERVER:int = 1;
		public static const STATE_PROCESSED_SERVER:int = 2;
		
		public static const IS_SUB_BOSS:int = 0;
		public static const IS_BOSS:int = 1;
		
		public var aboveContent:Sprite = new Sprite();					//Layer add những conent đi kèm cá mà nằm dưới content cá
		
		public var objAllBonus:Object;
		public var arrScene:Array;
		public var arrSceneBackUp:Array;
		public var arrFishSolider:Array;
		public var arrIdFishAttack:Array = [];
		public var arrFishSoliderWar:Array;
		public var arrMaxHpSolider:Array = [];			// Máu tối đa của cá đánh
		
		public var isFinishAttackOfBoss:Boolean = false;
		public var isFinishAttackOfSolider:Boolean = false;
		public var isLoadContentok:Boolean = true;
		public var isAttacking:Boolean = false;
		public var isBossLoose:Boolean = false;
		public var isBossWinServer:Boolean = false;
		public var isPreparingAttackWithBoss:Boolean = false;
		public var isStopMovWhenDead:Boolean = false;
		public var isStartWaitEffParticle:Boolean = false;
		public var isSetCurHP:Boolean = false;
		public var isCreateNewBoss:Boolean = false;
		
		public var curDeep:Number = Math.random();
		public var StateGo:Number = 1;
		public var State:int = -1;
		public var MaxFrameInState:int = 0;
		public var countFramePlay:int = 0;
		public var IdFrameMaxInState:int = 0;
		public var stanbyPos:Point = new Point();
		public var idOceanSea:int = 2;	// Biển Băng có id là 2
		public var numHornBreaked:int = 0;
		public var MaxHp:int;			// Máu tối đa của boss
		public var CurHp:Number;			// Máu hiện tại của boss
		public var directionX:int = 1;
		public var directionY:int = 1;
		public var vtocX:Number = 1;
		public var vtocY:Number = 1;
		public var curPercentGetGift:int = 0;
		public var numFrameWait:int = 0;
		public var numFishSoldierFinishEff:int = 0;
		public var StateWaitDataServer:int = STATE_NOT_SEND_SERVER;
		public var IsBoss:int = IS_SUB_BOSS;			// Id của con boss
		public var NumWaitEffParticle:int = 0;
		public var NumFrameWaitWhenBossDeed:int = 0;
		public var MaxFrameWaitWhenBossDeed:int = 600;
		public var IdBoss:int;			// Id của con boss
		public var Attack:int;			// công của boss
		public var Defend:int;			// thủ của boss
		
		//Particle
		public var explodeEmit:ExplodeEmit = null;
		
		//public var basePos:Point;
		public var mov:MovieClip;
		public var arrMov:Array = [];
		public var arrMovOrigional:Array = [];
		public var arrIndexMov:Array = [];
		
		public var ArrChildHide:Array = [];
		public var ArrChildHideBase:Array = [];
		public var NumChildMovie:int = 15;
		public var BmpArraySub:Vector.<BitmapData>;
		public var BmpPosSub:Vector.<Rectangle>;
		
		public function BossIce(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = true) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			aboveContent.cacheAsBitmap = true;
			this.ClassName = "BossIce";
			isCreateNewBoss = false;
		}
		
		public function Init(posX:int, posY:int):void 
		{
			SetDeep(curDeep);
			SetPos(posX, posY);
			SetMovingState(STATE_GO_RUN);
			ReachDes = true;
			SetHornInfo();
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
			GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthIce = null;
			ClearPrg();
			
		}
		
		public function ClearPrg():void 
		{
			GuiMgr.getInstance().GuiMainFishWorld.RemoveAllProgressBar();
		}
		
		public function SetStateBoss(bossState:int, stateBoss:int = -1):void
		{
			if (bossState == State)
			{
				return;
			}
			
			State = bossState;
			if(stateBoss == -1)
			{
				stateBoss = getCurrentHornInfo();
			}
			toBmp = false;
			switch (bossState) 
			{
				case BOSS_STATE_ATTACK:
					toBmp = true;
					LoadRes(BOSS_ICE_NAME + SEPERANT + BOSS_ATTACK_NAME + SEPERANT + stateBoss);
				break;
				case BOSS_STATE_HURT:
					LoadRes(BOSS_ICE_NAME + SEPERANT + BOSS_HURT_NAME + SEPERANT + (stateBoss));
				break;
				case BOSS_STATE_IDLE:
					LoadRes(BOSS_ICE_NAME + SEPERANT + BOSS_IDLE_NAME + SEPERANT + stateBoss);
				break;
			}
		}
		
		public function SetHornInfo():void 
		{
			numHornBreaked = Math.max(Math.floor(6 - CurHp / MaxHp * 6), 0);
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
		
		public function GotoPosNew(pos:Point):void 
		{
			stanbyPos = pos;
		}
		/**
		 * Thực hiện chọn play con boss tương ứng với state
		 */
		private function PlayCurState():void 
		{	
			if (!isLoadContentok)	return;
			//var name:String = "Boss2_" + State;
			//var img:Sprite = FishWorldController.ConvertToBitMap(mov, name) as Sprite;
			//BmpArraySub = FishWorldController.GetBmpArray(name);
			//BmpPosSub = FishWorldController.GetBmpPos(name);
			//maxBmpFrame = BmpArraySub.length;
			//img = imgTwo;
			//var test:MovieClip = img as MovieClip;
			//img.addEventListener(Event.ENTER_FRAME, onEnterFrameSub);
			//curBmpFrame = 0;
			//test.gotoAndPlay(0);
		}
			
		protected function onEnterFrameSub(e:Event):void 
		{
			if (img == null)
			{
				return;
			}
			
			if (maxBmpFrame == 1)
				return;
				
			var test:MovieClip = img as MovieClip;
			var testBitmap:Bitmap = test.getChildAt(0) as Bitmap;
			if (testBitmap == null)
			{
				return;
			}
			
			curBmpFrame++;
			if (curBmpFrame >= maxBmpFrame)
			{
				curBmpFrame = 0;
			}

			testBitmap.bitmapData = BmpArraySub[curBmpFrame];
			testBitmap.x = BmpPosSub[curBmpFrame].x;
			testBitmap.y = BmpPosSub[curBmpFrame].y;
		}

		public function getCurrentHornInfo():int 
		{
			var arr:Array = GameLogic.getInstance().user.arrBossDataIce;
			return Math.max(5 - arr.length, 1);
		}
		
		public function getHornInfo():int 
		{
			return numHornBreaked;
		}
		
		/**
		 * Hàm thực hiện khởi tạo id các layer bị ẩn đi
		 * Chú ý, index = 0 là của con boss khi chết
		 * sau đó với mỗi bước nhảy thì index tăng thêm 5
		 */
		private function InitBaseData():void 
		{
			var ChildeHideElement:Array = [];
			var ChildeHideBaseElement:Array = [];
			if(ArrChildHideBase.length <= 0)
			{
				ArrChildHideBase = [];
				ChildeHideBaseElement = [0, 1, 2, 3, 4, 5];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [6, 7, 8, 9, 10, 11, 12, 13, 14];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [15, 16, 17, 18, 19, 20, 21, 22, 23];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [36, 37, 38, 39, 40, 41];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [53, 54, 55, 56, 57, 58];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [59, 60, 61, 62, 63, 64, 65, 66];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [78, 79, 80, 81, 82];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [83, 84, 85, 86, 87, 88, 89, 90];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [103, 104, 105, 106, 107, 108];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [109, 110, 111, 112, 113, 114, 115];
				ArrChildHideBase.push(ChildeHideBaseElement);
				ChildeHideBaseElement = [116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127];
				ArrChildHideBase.push(ChildeHideBaseElement);
			}
			
			
			ArrChildHide = [];
			// trạng thái Boss chết - index = 0
			ChildeHideElement = [0, 3, 4, 5, 6, 8, 9, 11, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			// 5 trạng thái Idle
			ChildeHideElement = [1, 2, 3, 5, 7, 8, 10, 11, 13, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [1, 2, 3, 5, 7, 8, 10, 11, 13, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 3, 5, 6, 8, 10, 11, 13, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 3, 5, 6, 8, 10, 11, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 3, 4, 5, 6, 8, 10, 11, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			// 5 trạng thái Attack
			ChildeHideElement = [1, 2, 3, 5, 6, 7, 10, 11, 13, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 2, 5, 6, 8, 10, 11, 13, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 3, 5, 6, 8, 10, 11, 12, 13];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 3, 4, 6, 8, 10, 11, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 3, 4, 5, 6, 8, 9, 10, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			// 5 trạng thái Hurt
			ChildeHideElement = [1, 2, 3, 5, 6, 8, 10, 11, 13, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 3, 5, 6, 8, 10, 11, 13, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 3, 5, 6, 8, 10, 11, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 3, 4, 5, 6, 8, 10, 11, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 3, 4, 5, 6, 8, 9, 11, 12, 14];
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
			//var posBaseBoss:Point = new Point(Constant.MAX_WIDTH / 2 + 300, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 150);
			var posBaseBoss:Point = new Point(650, 440);
			tacticBoss.push(posBaseBoss);
			tacticBoss.push(new Point(850, 440));
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
		
		/**
		 * Thực hiện các action sau khi load được hình ảnh
		 */
		override public function OnLoadResComplete():void 
		{
			InitBaseData();
			mov = img as MovieClip;
			{
				//PlayCurState();
			}
		}
		
		override public function OnReloadRes():void 
		{
			super.OnReloadRes();
			if(CurPos != null)
			{
				Init(CurPos.x, CurPos.y);
				//Init(0,0);
			}
			else
			{
				var arrTactic:Array = GetTactic(0);
				Init(arrTactic[BossMetal.ID_TACTIC_BOSS][0].x, arrTactic[BossMetal.ID_TACTIC_BOSS][0].y);
				//Init(0, 0);
			}
			img.mouseChildren = false;
		}
		
		private function CheckBossWin():Boolean
		{
			return isBossWinServer;
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
			if (arrFishSoliderWar.length <= 0) 
			{
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
			if (arrScene.length < 1)
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
			var obj:Object = arrSceneBackUp[arrSceneBackUp.length - 1 - arrScene.length];
			var objOld:Object = arrSceneBackUp[arrSceneBackUp.length - 2 - arrScene.length];
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
						obj.Vitality.Attack[s] < objOld.Vitality.Attack[s])
					{
						isFindOK = true;
						break;
					}
				}
				if (isFindOK)	break;
			}
			// Nếu không có thì không cần cập nhật
			if (!isFindOK)	return;
			//var allVitalityFish:int = (fishSoldierElement.Vitality + fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus);
			var allVitalityFish:int = objOld.Vitality.Attack[s];
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
			//allVitalityFish = (fishSoldierElement.Vitality + fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus);
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
			StateWaitDataServer = STATE_NOT_SEND_SERVER;
			var i:int = 0;
			var j:int = 0;
			var item:FishSoldier;
			numFishSoldierFinishEff = 0;
			
			// Cập nhật lại sức khỏe cho tất cả các mảng base bên dưới, hiện tại là chưa cập nhật
			if (CheckBossWin())	// Nếu mình thua
			{
				SetHornInfo();
				SetStateBoss(BOSS_STATE_IDLE);
				
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
				CurHp = 0;
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
				if(GameLogic.getInstance().user.arrBossDataIce.length == 0)
				{
					SetStateBoss(BOSS_STATE_HURT);
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EfffKillBoss", null, 
						Constant.STAGE_WIDTH / 2 + 50, 250, false, false, null);// , FinishBossLose);
				}
				else
				{
					SetStateBoss(BOSS_STATE_HURT);
				}
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
		
		public function UpdateNewDataBossIce():void 
		{
			if(GameLogic.getInstance().user.arrBossDataIce.length > 0)
			{
				isCreateNewBoss = false;
				var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
				var arrTactic:Array = BossIce.GetTactic(0);
				var dataBoss:Object = GameLogic.getInstance().user.arrBossDataIce[0];
				IsBoss = dataBoss.IsBoss;
				var configBoss:Object = objAllSea[FishWorldController.GetSeaId().toString()][FishWorldController.GetRound()];
				IdBoss = dataBoss.Id;
				CurHp = dataBoss.Vitality;
				isSetCurHP = true;
				MaxHp = configBoss[IdBoss.toString()].Vitality;
				Attack = dataBoss.Damage;
				Defend = dataBoss.Defence;
				SetStanbyPos(arrTactic[BossMetal.ID_TACTIC_BOSS][0]);
				//SetStanbyPos(new Point());
				GameLogic.getInstance().user.arrBossDataIce.splice(0, 1);
				//PlayCurState();
				isAttacking = false;
				GameLogic.getInstance().isAttacking = false;
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
			}
		}
		
		public function FinishBossLose():void 
		{
			numFishSoldierFinishEff = 0;
			isAttacking = false;
			isBossLoose = true;
			GameLogic.getInstance().isAttacking = false;
			isStartWaitEffParticle = true;
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
				SetHornInfo();
				SetStateBoss(BOSS_STATE_ATTACK);
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
					if(State == BOSS_STATE_ATTACK)
					{
						// Nếu kết thúc eff và các con cá nhà mình đã kết thúc lượt đánh
						// thì thực hiện cập nhật trừ máu cho con cá bị boss đánh
						// và xóa đi phần tử đã được thực hiện trong kịch bản (phần tử đầu tiên)
						if(curBmpFrame == maxBmpFrame - 1)
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
									//mov.gotoAndPlay(1);
								}
								else 
								{
									FinalAttack();
								}
							}
							//else // Nếu các con cá nhà mình chưa kết thức lượt đánh thì quay lai play tiếp
							//{
								//mov.gotoAndPlay(1);
							//}
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
			var deltaPos:Point = new Point(15 - Math.random() * 30 + 350, 180 - 35 - Math.random() * 30)
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
			//trace("Máu của con boss sau từng hit của tung con cá nhà mình là: " + CurHp);
			// Nếu tất cả các con cá lính đã tấn công xong thì cập nhật lại máu cho boss
			if (numFishSoldierFinishEff >= arrFishSoliderWar.length)
			{
				CurHp = obj.Vitality.Defence.Left;
			}
			//trace("Máu của con boss sau tat cac hít của nhà mình là: " + CurHp);
			arrIdFishAttack.splice(0, 1);
		}
		
		/**
		 * Hàm thực hiện các eff đánh nhau của các con cá lính
		 */
		private function ShowEffSoldier():void 
		{
			//if (arrScene[0].attackFirst != null)
			//{
				//arrScene.splice(0, 1);
			//}
			var i:int = 0;
			var objForSub:Object = arrScene[0];
			var objForSubOld:Object = arrSceneBackUp[arrSceneBackUp.length - arrScene.length - 1];
			var isFindOK:Boolean = false;
			var fishSoldierElementForSub:FishSoldier;
			var idFishSoldierElementForSub:int;
			
			for (i = 0; i < arrFishSoliderWar.length; i++) 
			{
				var obj:Object = arrScene[0];
				var fishSoldierElement:FishSoldier = arrFishSoliderWar[i] as FishSoldier;
				if(obj.Vitality.Attack[fishSoldierElement.Id.toString()] > 0)
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
			if(!GuiMgr.getInstance().GuiFinalKillBoss.IsVisible)	GuiMgr.getInstance().GuiFinalKillBoss.Show(Constant.GUI_MIN_LAYER, 1);
		}
		
		public function Update():void 
		{
			// đang ở trạng thái chờ đánh boss
			if (isPreparingAttackWithBoss)
			{
				// Boss đến vị trí của mình và đã nhận, xử lý 
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
			
			switch (State) 
			{
				case BOSS_STATE_HURT:
					//if(curBmpFrame == (maxBmpFrame - 1))
					if(mov.currentFrame == (maxBmpFrame))
					{
						var stateBoss:int = getCurrentHornInfo();
						if(stateBoss == 5)
						{
							mov.stop();
							SetStateBoss(BOSS_STATE_DEAD);
						}
						else if (stateBoss < 5 && curBmpFrame == (maxBmpFrame - 1)) 
						{
							SetStateBoss(BOSS_STATE_IDLE, getCurrentHornInfo() + 1);
						}
						isCreateNewBoss = true;
					}
					
				break;
				case BOSS_STATE_ATTACK:
					ProcessAttack();
				break;
				case  BOSS_STATE_IDLE:
					if (isAttacking)
					{
						ProcessAttack();
					}
				break;
				case BOSS_STATE_DEAD:
					if (NumFrameWaitWhenBossDeed < MaxFrameWaitWhenBossDeed)
					{
						NumFrameWaitWhenBossDeed ++;
						if ( mov && mov.alpha < 0.005)
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
						else
						{
							mov.alpha -= 0.005;
						}
					}
					
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
		
	}

}