package GUI.FishWorld 
{
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
	import flash.events.Event;
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
	import Logic.BaseObject;
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
	public class Boss extends BaseObject 
	{
		public static const ITEM_TYPE:String = "Boss"
		public static const SEPARATE:String = "_";
		
		public static const ATTACK_NORMAL:int = 0;
		public static const ATTACK_CRITICAL:int = 1;
		public static const ATTACK_MISS:int = 2;
		
		public static const BOSS_STATE_IDLE:int = 0;
		public static const BOSS_STATE_ATTACK:int = 1;
		public static const BOSS_STATE_HURT:int = 2;
		public static const BOSS_STATE_DEAD:int = 3;
		
		public const DIRECTION_RIGHT:int = 1;
		public const DIRECTION_X:int = 0;
		public const DIRECTION_LEFT:int = -1;
		public const DIRECTION_UP:int = -1;
		public const DIRECTION_Y:int = 0;
		public const DIRECTION_DOWN:int = 1;
		
		public var aboveContent:Sprite = new Sprite();					//Layer add những conent đi kèm cá mà nằm dưới content cá
		
		public static const BOSS_STATE_HORN_BREAKED_0:int = 0;
		public static const BOSS_STATE_HORN_BREAKED_1:int = 1;
		public static const BOSS_STATE_HORN_BREAKED_2:int = 2;
		public static const BOSS_STATE_HORN_BREAKED_3:int = 3;
		public static const BOSS_STATE_HORN_BREAKED_4:int = 4;
		public static const BOSS_STATE_HORN_BREAKED_5:int = 5;
		
		public const STATE_GO_IDLE:int = 0;
		public const STATE_GO_RUN:int = 1;
		
		public static const IDLE:String = "Idle";
		public static const ATTACK:String = "Attack";
		public static const HURT:String = "Hurt";
		public static const DEAD:String = "Dead";
		
		public static const ATTACK_LOSE:int = 0;
		public static const ATTACK_WIN:int = 1;
		//public static const ATTACK_CRITICAL:int = 2;
		
		public static const STATE_NOT_SEND_SERVER:int = -1;
		public static const STATE_WAITING_SERVER:int = 0;
		public static const STATE_HAD_SERVER:int = 1;
		public static const STATE_PROCESSED_SERVER:int = 2;
		
		// Các biến cần lưu trữ
		private var timerBossLoose:Timer = null;
		
		public var directionX:int = 1;
		public var directionY:int = 1;
		public var vtocX:Number = 1;
		public var vtocY:Number = 1;
		public var StateGo:Number = 1;
		public var isPreparingAttackWithBoss:Boolean = false;
		//public var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
		
		public var NumFrameWaitWhenBossDeed:int = 0;
		public var MaxFrameWaitWhenBossDeed:int = 600;
		public var StateWaitDataServer:int = -1;
		public var data_Server:Object;
		
		public var CurLabelAttack:String = "";
		
		public var objAllBonus:Object;
		public var arrScene:Array;
		//public var arrFishSoldierUpdate:Array;
		
		public var isFinishAttackOfBoss:Boolean = false;
		public var isFinishAttackOfSolider:Boolean = false;
		public var isLoadContentSuccess:Boolean = true;
		public var isAttacking:Boolean = false;
		public var isBossLoose:Boolean = false;
		public var isBossWinServer:Boolean = false;
		public var numFrameEf:int = -1;
		public var NumFramePlay:int = 200;
		public var ArrChildHide:Array = [];
		public var NumChildMovie:int = 15;
		public var curDeep:Number = Math.random();
		public var State:int = BOSS_STATE_IDLE;
		public var NextState:int = BOSS_STATE_IDLE;
		public var numHornHave:int = 5;
		public var idOceanSea:int = 0;
		public var numHornBreaked:int = 0;
		public var IdBoss:int;			// Máu tối đa của cá đánh
		public var MaxHpSolider:Array = [];			// Máu tối đa của cá đánh
		public var arrMaxHpSolider:Array = [];			// Máu tối đa của cá đánh
		public var MaxHp:int;			// Máu tối đa của boss
		public var CurHp:Number;			// Máu hiện tại của boss
		public var isSetCurHP:Boolean = false;
		public var isGenArr:Boolean = false;
		public var isLoadContentOK:Boolean = false;
		public var Attack:int;			// Máu hiện tại của boss
		public var Defend:int;			// Máu hiện tại của boss
		public var SubHpTotalBoss:int;	// Lượng máu bị trừ trong 1 hit của boss
		public var SubHpTotalSoldier:int;	// Lượng máu bị trừ trong 1 hit của cá đem đi đánh
		public var SubBossArr:Array = [];
		public var SubSoliderArr:Array = [];
		
		public var ArrCurHpBoss:Array = [];
		public var ArrCurHpSoldier:Array = [];
		
		public var arrFishSolider:Array;
		public var arrIdFishAttack:Array = [];
		public var arrFishSoliderWar:Array;
		public var numFishSoldierFinishEff:int = 0;
		
		public var stateEffBossAttack:int = 0;
		public const STATE_EFF_ATTACK_NO_PLAY:int = 0;
		public const STATE_EFF_ATTACK_START_PLAY:int = 1;
		public const STATE_EFF_ATTACK_FINISH_PLAY:int = 2;
		
		public const STATE_ATTACK_MISS:int = 0;
		public const STATE_ATTACK_OK:int = 1;
		public const STATE_ATTACK_CRITICAL:int = 2;
		
		public var basePos:Point;
		public var mov:MovieClip;
		public var isReSetSubHpArr:Boolean = false;
		
		public var curPercentGetGift:int = 0;
		public var isWaitToComeBackMap:Boolean = false;
		public var numFrameWait:int = 0;
		
		public var isStartWaitEffParticle:Boolean = false;
		public var NumWaitEffParticle:int = 0;
		
		//Particle
		public var explodeEmit:ExplodeEmit = null;
		
		public function Boss(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			aboveContent.cacheAsBitmap = true;
			this.ClassName = "Boss";
		}
		
		public function Init(posX:int, posY:int):void 
		{
			SetDeep(curDeep);
			SetPos(posX, posY);
			//StateGo = STATE_GO_RUN;
			SetMovingState(STATE_GO_RUN);
			ReachDes = true;
			SetHornInfo();
			basePos = new Point(posX, posY);
		}
		
		public function SetHornInfo():void 
		{
			numHornBreaked = Math.max(Math.floor(5 - CurHp / MaxHp * 5), 0);
		}
		
		public function getCurrentHornInfo():int 
		{
			return Math.max(Math.floor(5 - CurHp / MaxHp * 5), 0);
		}
		
		public function getHornInfo():int 
		{
			return numHornBreaked;
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
		
		override public function OnReloadRes():void 
		{
			super.OnReloadRes();
			Init(CurPos.x, CurPos.y);
			img.mouseChildren = false;
		}
		
		//override public function OnLoadResErr(e:Event):void 
		//{
			//if (img == null)
			//{
				//img = new Sprite();
			//}
			//
			//if (Width <= 1)
			//{
				//Width = 100;
			//}
			//if (Height <= 1)
			//{
				//Height = 100;
			//}
			//
			//img.graphics.clear();
			//img.graphics.beginFill(0x65ffff);
			//img.graphics.drawRect(0, 0, Width, Height);
			//img.graphics.endFill();
			//img.width = Width;
			//img.height = Height;
			//SetAlign(ImgAlign);
			//ClearEvent();
		//}
		
		override public function OnLoadResComplete():void 
		{
			InitBaseData();
			mov = img as MovieClip;
			if(State != BOSS_STATE_DEAD)
			{
				PlayCurState();
			}
			if (State == BOSS_STATE_ATTACK && !isAttacking)
			{
				isAttacking = true;
			}
			img.scaleX = 0.8;
			img.scaleY = 0.8;
		}
		
		override public function ClearImage():void 
		{
			//super.ClearImage();
			removeAllEvent();
			
			if (mov && mov.parent)	mov.parent.removeChild(mov);
			mov = null;
			if (Parent != null && img != null && img.parent == Parent)
			{
				Parent.removeChild(img);
				img = null;
			}
		}
		
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
			//switch (directionX) 
			//{
				//case DIRECTION_LEFT:
					//switch (directionY) 
					//{
						//case DIRECTION_UP:
							//return new Point(0, 45);
						//break;
						//case DIRECTION_DOWN:
							//return new Point(0, -45);
						//break;
						//case DIRECTION_Y:
							//return new Point(0, 0);
						//break;
					//}
				//break;
				//case DIRECTION_RIGHT:
					//switch (directionY) 
					//{
						//case DIRECTION_UP:
							//return new Point(-180, 135);
						//break;
						//case DIRECTION_DOWN:
							//return new Point(-180, -135);
						//break;
						//case DIRECTION_Y:
							//return new Point(-180, 180);
						//break;
					//}
				//break;
				//case DIRECTION_X:
					//switch (directionY) 
					//{
						//case DIRECTION_UP:
							//return new Point(0, 90);
						//break;
						//case DIRECTION_DOWN:
							//return new Point(0, -90);
						//break;
						//case DIRECTION_Y:
							//return new Point(0, 0);
						//break;
					//}
				//break;
			//}
			//return new Point(0, 0);
		}
		
		public function SetMovingState(MoveState:int):void 
		{
			StateGo = MoveState;
		}
		
		public function SetStateBoss(bossState:int):void
		{
			if (bossState == State)
			{
				if(State != BOSS_STATE_DEAD)
				{
					PlayCurState();
				}
				return;
			}
			
			ClearImage();
			State = bossState;
			NextState = NextState;
			isLoadContentOK = false;
			switch(bossState)
			{
				case BOSS_STATE_ATTACK:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + ATTACK);
					break;
				case BOSS_STATE_DEAD:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + DEAD);
					break;
				case BOSS_STATE_HURT:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + HURT);
					break;
				case BOSS_STATE_IDLE:
					LoadRes(ITEM_TYPE + idOceanSea + SEPARATE + IDLE);
					break;
			}
			//trace("State = " + State + " && bossState = " + bossState);
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
		
		public function showGuiGift():void 
		{
			isStartWaitEffParticle = false;
			NumWaitEffParticle = 0;
			GuiMgr.getInstance().GuiFinalKillBoss.Show(Constant.GUI_MIN_LAYER, 1);
		}
		
		public function UpdateBoss():void 
		{
			// đang ở trạng thái chờ đánh boss
			if (isPreparingAttackWithBoss)
			{
				//trace("isPreparingAttackWithBoss = " + isPreparingAttackWithBoss);
				// Boss đến vị trí của mình và đã nhận, xử lý 
				if (StateGo == STATE_GO_IDLE)
				{
					//trace("ReachDes = " + ReachDes);
					//trace("StateGo = " + StateGo);
					if(StateWaitDataServer == STATE_HAD_SERVER)
					{
						//trace("StateWaitDataServer = " + StateWaitDataServer);
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
				case BOSS_STATE_ATTACK:
					ProcessAttack();
				break;
				case  BOSS_STATE_IDLE:
					if (isAttacking)
					{
						ProcessAttack();
					}
				break;
				case BOSS_STATE_HURT:
					if (mov.currentLabel == "End")
					{
						if(getHornInfo() < 5)
							SetStateBoss(BOSS_STATE_ATTACK);
						else
						{
							//trace("FinalAttack 473");
							FinalAttack();
						}
					}
				break;
				case BOSS_STATE_DEAD:
				
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
	
			if (mov && mov.totalFrames <= mov.currentFrame)
			{
				FinishEffBoss();
			}
			
			if (mov)	randomPosBoss();
			
			//Update particle boss chet
			if (explodeEmit)
			{
				explodeEmit.updateEmitter();
				
			}
			
			// Chờ particle
			if (isStartWaitEffParticle)
			{
				NumWaitEffParticle++;
				if (NumWaitEffParticle >= 300)
				{
					showGuiGift();
				}
			}
		}
		/**
		 * Thực hiện trở về tại cá
		 */
		private function ComBackMap():void 
		{
			GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
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
			BossMgr.getInstance().BossArr.splice(BossMgr.getInstance().BossArr.indexOf(this), 1);
			
			ClearPrg();
			
		}
		
		public function ClearPrg():void 
		{
			GuiMgr.getInstance().GuiMainFishWorld.arrPrgBossHealth.splice(0, 
				GuiMgr.getInstance().GuiMainFishWorld.arrPrgBossHealth.length);
			
			GuiMgr.getInstance().GuiMainFishWorld.RemoveAllProgressBar();
		}
		/**
		 * Thực hiện tấn công - cập nhật thường xuyên khi boss đang trong trạng thái tấn công
		 */
		private function ProcessAttack():void 
		{
			if (isLoadContentSuccess)
			{
				if(mov)
				{
					// Nếu đang show eff tấn công
					if(State == BOSS_STATE_ATTACK)
					{
						// Nếu kết thúc eff và các con cá nhà mình đã kết thúc lượt đánh
						// thì thực hiện cập nhật trừ máu cho con cá bị boss đánh
						// và xóa đi phần tử đã được thực hiện trong kịch bản (phần tử đầu tiên)
						if(mov.currentLabel == "End")
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
									//trace("FinalAttack 600");
									FinalAttack();
								}
							}
							else // Nếu các con cá nhà mình chưa kết thức lượt đánh thì quay lai play tiếp
							{
								mov.gotoAndPlay(CurLabelAttack);
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
								//trace("FinalAttack 618");
								FinalAttack(!isBossWinServer);
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
		 * Thực hiện attack cuối cùng
		 */
		public function FinalAttack(isShowBonus:Boolean = true):void
		{
			var arrLogic:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			//UpdateFishSoldierAfterAttacked();
			StateWaitDataServer = STATE_NOT_SEND_SERVER;
			var i:int = 0;
			var j:int = 0;
			var item:FishSoldier
			//UpdateStateBossDuringWar();
			// Cập nhật lại sức khỏe cho tất cả các mảng base bên dưới, hiện tại là chưa cập nhật
			if (CheckBossWin())
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
				SetStateBoss(BOSS_STATE_DEAD);
				//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_KILL_BOSS_HOANG_SO, "Tua Rua");
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EfffKillBoss", null, 
					Constant.STAGE_WIDTH / 2 + 50, 250, false, false, null, FinishBossLose);
			}
			if(isShowBonus)
			{
				GameLogic.getInstance().bonusFishWorld = objAllBonus["100"];
				//trace("Rơi quà 100");
				GameLogic.getInstance().dropAllGiftFishWorld();
			}
			// Cập nhật lại item gắn kèm vào con cá vào cập nhật lại máu cho con cá
			UpdateVitalityAllFishSoldier();
			UpdateStateAllFishSoldier();
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
			{
				GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
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
			var obj:Object = arrScene[0];
			var txtFormat:TextFormat;
			var fishSoldierElement:FishSoldier;
			var isFindOK:Boolean = false;
			var sp:Sprite;
			for (var i:int = 0; i < arrFishSoliderWar.length; i++) 
			{
				isFindOK = false;
				fishSoldierElement = arrFishSoliderWar[i] as FishSoldier;
				//for (var s:String in obj.Vitality.Defence.ListAtt)
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
			//if (fishSoldierElement.Vitality == 0)
			if ((fishSoldierElement.Vitality + fishSoldierElement.bonusEquipment.Vitality + fishSoldierElement.VitalityPlus) == 0)
			{
				fishSoldierElement.SwimTo(fishSoldierElement.standbyPos.x, fishSoldierElement.standbyPos.y, 20);
				//trace("Con cá bơi về vị trí có Id là: " + fishSoldierElement.Id);
			}
		}
		
		/**
		 * Hàm chuẩn bị: các con cá còn sức khỏe vào đánh, cá con cá không còn sức khỏe thì đứng ngoài, boss về vị trí; gửi gói tin lên lấy kịch bản về
		 * @param	ArrFishSolider	:	Mảng các con cá có thể đem đi thế giới cá
		 * @param	idTactic		:	Loại Thế trận của các con cá khi đánh boss
		 */
		public function PreStartAttack(ArrFishSolider:Array, idTactic:int = 0):void 
		{
			var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
			GameLogic.getInstance().user.UpdateEnergy(- EnergyCost);
			// Cập nhật mảng các con cá tham chiến với con boss này
			arrFishSolider = ArrFishSolider;
			arrFishSoliderWar = Ultility.GetFishSoldierCanWar();
			// Gửi gói tin đánh boss lên để lấy kịch bản về
			var fightWorld:SendAttackBoss = new SendAttackBoss(FishWorldController.GetSeaId());
			Exchange.GetInstance().Send(fightWorld);
			StateWaitDataServer = STATE_WAITING_SERVER;	// Xét trạng thái hiện tại là đang chờ dữ liệu server trả về
			// Lấy vị trí đội hình các con cá
			var i:int = 0;
			var arrPosTactic:Array = GetTactic(idTactic);
			isPreparingAttackWithBoss = true;
			GotoPos(arrPosTactic[0], 7);	// Boss đến vị trí của boss
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
				idTacticForAFish++;
				fishSoldierInArr.SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
				fishSoldierInArr.SwimTo(arrPosTactic[idTacticForAFish].x, arrPosTactic[idTacticForAFish].y, 20, true);
				//fishSoldierInArr.standbyPos = arrPosTactic[idTacticForAFish];
				fishSoldierInArr.GuiFishStatus.ShowHPBar(fishSoldierInArr, vitalityFishSolider, arrMaxHpSolider[i]);
			}
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
		 * Hàm trả kiểm tra con cá fish có đủ điều kiện tham chiến với boss không
		 * @param	fish
		 * @return
		 */
		private function CheckCanAttack(fish:FishSoldier):Boolean
		{
			for (var i:int = 0; i < arrFishSoliderWar.length; i++) 
			{
				var item:FishSoldier = arrFishSoliderWar[i];
				if (item.Id == fish.Id)
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * Lấy mảng chứa đội hình của cá
		 * @param	indexTactic
		 * @return
		 */
		private function GetTactic(indexTactic:int):Array
		{
			var arr:Array = [];
			
			// Thế trận 1: các con cá của mình xếp thành 3 hàng 2 cột, 1 bên
			var tactic:Array = [];
			var posBaseSolider:Point = new Point(Constant.MAX_WIDTH / 2 - 50, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 20);
			var posBaseBoss:Point = new Point(Constant.MAX_WIDTH / 2 + 100, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2);
			tactic.push(posBaseBoss);
			tactic.push(posBaseSolider);
			tactic.push(new Point(posBaseSolider.x, posBaseSolider.y - 100));
			tactic.push(new Point(posBaseSolider.x, posBaseSolider.y + 100));
			tactic.push(new Point(posBaseSolider.x - 90, posBaseSolider.y + 100));
			tactic.push(new Point(posBaseSolider.x - 90, posBaseSolider.y - 100));
			tactic.push(new Point(posBaseSolider.x - 90, posBaseSolider.y));
			arr.push(tactic);
			
			// Thế kim tự tháp	3 cột (1, 3, 5)
			tactic = new Array();
			posBaseBoss = new Point(Constant.MAX_WIDTH / 2 + 150, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 20);
			posBaseSolider = new Point(Constant.MAX_WIDTH / 2 - 50, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 20);
			tactic.push(posBaseBoss);
			tactic.push(posBaseSolider);
			tactic.push(new Point(posBaseSolider.x - 70, posBaseSolider.y - 70));
			tactic.push(new Point(posBaseSolider.x - 70, posBaseSolider.y));
			tactic.push(new Point(posBaseSolider.x - 70, posBaseSolider.y + 70));
			tactic.push(new Point(posBaseSolider.x - 140, posBaseSolider.y));
			tactic.push(new Point(posBaseSolider.x - 140, posBaseSolider.y - 70));
			arr.push(tactic);
			
			// Thế bao vây
			tactic = new Array();
			posBaseBoss = new Point(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 20);
			posBaseSolider = new Point(Constant.MAX_WIDTH / 2 - 200, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 20);
			posBaseSolider = new Point(Constant.MAX_WIDTH / 2 + 200, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 20);
			tactic.push(posBaseBoss);
			tactic.push(posBaseSolider);
			tactic.push(new Point(posBaseSolider.x - 100, posBaseSolider.y - 70));
			tactic.push(new Point(posBaseSolider.x - 100, posBaseSolider.y + 70));
			tactic.push(new Point(posBaseSolider.x + 100, posBaseSolider.y + 70));
			tactic.push(new Point(posBaseSolider.x + 100, posBaseSolider.y - 70));
			arr.push(tactic);
			
			return arr[indexTactic];
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
		
		public function SetDataServer(dataServer:Object):void 
		{
			// Lưu lại vào data các quà tặng mà user nhận được
			curPercentGetGift = 0;
			objAllBonus = dataServer.Bonus;
			// Lưu lại vào data kịch bản
			arrScene = dataServer.Scene;
			if (dataServer.isWin == 0)
			{
				isBossWinServer = true;
			}
			else 
			{
				isBossWinServer = false;
				GuiMgr.getInstance().GuiFinalKillBoss.InitGui(objAllBonus);
			}
			trace("Server trả về _ isBossWinServer = ", isBossWinServer)
			//trace("Trước khi cập nhật dataServer: ");
			var j:int = 0;
			var i:int = 0;
			//for (j = 0; j < arrFishSoliderWar.length; j++) 
			//{
				//trace("Con cá có Id: " + arrFishSoliderWar[j].Id + " có máu lúc trước là: " + arrFishSoliderWar[j].Vitality);
			//}
			Ultility.UpdateFishSoldier(dataServer.MySoldier, dataServer.MyEquipment.SoldierList, GameLogic.getInstance().user.FishSoldierActorMine);
			arrFishSoliderWar = Ultility.GetFishSoldierCanWar();
			var arrPosTactic:Array = GetTactic(0);
			GotoPos(arrPosTactic[0], 7);	// Boss đến vị trí của boss
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
				idTacticForAFish++;
				fishSoldierInArr.SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
				fishSoldierInArr.SwimTo(arrPosTactic[idTacticForAFish].x, arrPosTactic[idTacticForAFish].y, 20, true);
				fishSoldierInArr.GuiFishStatus.ShowHPBar(fishSoldierInArr, vitalityFishSolider, arrMaxHpSolider[i]);
				fishSoldierInArr.isChoose = true;
			}
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
		
		public function UpdateParamAllFishSoldier(fs:Object):void 
		{
			var i:int = 0;
			// Logic
			var arr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			for (i = 0; i < arr.length; i++) 
			{
				var itemLogic:FishSoldier = arr[i];
				if (itemLogic.Id == fs.Id)
				{
					updateParamAFishSoldierLogic(fs, itemLogic);
					break;
				}
			}
			// Hiển thị
			for (i = 0; i < arrFishSolider.length; i++) 
			{
				var item:FishSoldier = arrFishSolider[i];
				if (item.Id == fs.Id)
				{
					updateParamAFishSoldierShow(fs, item);
					break;
				}
			}
		}
		
		private function updateParamAFishSoldierShow(fsOri:Object, fsDes:FishSoldier):void 
		{
			fsDes.SetInfo(fsOri);
			fsDes.SetEquipmentInfo(fsOri.Equipment);
			fsDes.SetSoldierInfo();
			fsDes.RefreshImg();
		}
		
		private function updateParamAFishSoldierLogic(fsOri:Object, fsDes:FishSoldier):void 
		{
			fsDes.SetInfo(fsOri);
			fsDes.SetEquipmentInfo(fsOri.Equipment);
			fsDes.SetSoldierInfo();
		}
		
		public function InitItemUsed(List:Array):Array
		{
			var i:int;
			var j:int;
			var SupportList:Array = ConfigJSON.getInstance().GetBuffItemList();
			for (i = 0; i < SupportList.length; i++)
			{
				var num:int = GameLogic.getInstance().user.GetStoreItemCount(SupportList[i]["Type"], SupportList[i]["Id"]);
				SupportList[i]["Count"] = num;
				SupportList[i]["Used"] = 0;
			}
			if(List)
			{
				for (i = 0; i < List.length; i++)
				{
					for (j = 0; j < SupportList.length; j++)
					{
						if (List[i].ItemType == SupportList[j].Type && List[i].ItemId == SupportList[j].Id)
						{
							SupportList[j].Used = List[i].Num;
						}
					}
				}
			}
			return SupportList;
		}
		/**
		 * Bắt đầu thực hiện các effect tấn công lẫn nhau
		 */
		public function StartAttack():void 
		{	
			if(isLoadContentSuccess)
			{
				isAttacking = true;
				// Nếu là bước tấn công cuối cùng thì thực hiện finalAttack() - có xử lý thêm 1 số công đoạn khác
				if (arrScene.length == 0)	
				{
					//trace("FinalAttack 1467");
					FinalAttack();
					return;
				}
				// Nếu chưa phải là final-hit thì thực hiện đánh qua lại giữa các con với boss
				StateWaitDataServer = STATE_PROCESSED_SERVER;
				var obj:Object = arrScene[0];
				SetStateBoss(BOSS_STATE_ATTACK);
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
		
		public function FinishEffBoss():void 
		{
			 //Bỏ phần tử đầu tiên đi và hiện eff trừ máu
			//if (!isReSetSubHpArr)
			//{
				//
			//}
			//SubBossArr.splice(0, 1);
			//
			 //Sau đó nếu như máu chưa trừ hết thì play tiếp eff
			//if (SubBossArr && SubBossArr.length > 0)
			//{
				//PlayRandomAttack();
			//}
		}
		
		public function UpdateStateBossDuringWar():void 
		{
			if (numHornBreaked != getCurrentHornInfo())
			{
				SetHornInfo();
				SetStateBoss(BOSS_STATE_HURT);
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
			var deltaPos:Point = new Point(15 - Math.random() * 30, 0 - 35 - Math.random() * 30)
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
		
		private function randomPosBoss():void 
		{
			if (State != BOSS_STATE_IDLE)	return;
			if (StateGo == STATE_GO_IDLE)	return;
			if(ReachDes)
			{
				var vtocMax:Number = 3;
				ReachDes = false;
				DesPos = new Point();
				DesPos.x = Math.random() * Constant.STAGE_WIDTH;
				DesPos.y = CurPos.x + Math.random() * 100;
				var rateXY:Number = Math.abs((DesPos.y - CurPos.y) / (DesPos.x - CurPos.x));
				while (!CheckSwimmingArea(DesPos)) 
				{
					DesPos.y = Math.random() * Constant.STAGE_HEIGHT;
					DesPos.x = Math.random() * Constant.STAGE_WIDTH + (Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2;
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
				
				vtocX = 1 + Math.random() * 4;
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
		
		private function CheckSwimmingArea(pos:Point):Boolean 
		{
			var boundXRight:Number = (Constant.MAX_WIDTH + Constant.STAGE_WIDTH) / 2;
			var boundXLeft:Number = (Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2;
			var boundYUp:Number = 100;
			var boundYDown:Number = 450;
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
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
		 * Hàm thực hiện các eff đánh nhau của các con cá lính
		 */
		private function ShowEffSoldier():void 
		{
			for (var i:int = 0; i < arrFishSoliderWar.length; i++) 
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
		
		private function CheckBossWin():Boolean
		{
			trace("Lúc check _ isBossWinServer = ", isBossWinServer)
			return isBossWinServer;
		}
		
		public function DeleteFishSolider():void 
		{	
			var fs:FishSoldier;
			var i:int = 0;
			for (i = 0; i < GameLogic.getInstance().user.FishSoldierActorMine.length; i++)
			{
				fs = GameLogic.getInstance().user.FishSoldierActorMine[i] as FishSoldier;
				if(fs.Vitality <= 0)
				{
					fs.Destructor();
					GameLogic.getInstance().user.FishSoldierActorMine.splice(i, 1);	
					i--;
				}
				else 
				{
					fs.SetMovingState(Fish.FS_SWIM);
					fs.GuiFishStatus.ShowSoldierStatus(fs);
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
		
		/**
		 * Effect trừ HP cá
		 * @param	num	
		 */
		public function HealthEffect(num:int, fs:FishSoldier):void
		{
			var child:Sprite = new Sprite();
			var str:String = "-" + num.toString();
			var txtFormat:TextFormat = new TextFormat(null, 20, 0x00ff00);	// Màu điểm sức khỏe 0xF79347
			txtFormat.bold = true;
			txtFormat.align = "left";
			txtFormat.font = "Arial";
			child.addChild(Ultility.CreateSpriteText(str, txtFormat, 6, 0, false));		
			var eff:ImgEffectFly;
			var pos:Point;
			pos = fs.aboveContent.localToGlobal(new Point(0, 0));
			eff = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, fs.aboveContent) as ImgEffectFly;
			eff.SetInfo(pos.x + 20, pos.y -90, pos.x + 20, pos.y - 90 + 30, 3);
		}
		private function PlayHurt(NumHurtBreaked:int):void 
		{
			
		}
		private function PlayCurState():void 
		{
			if (!isLoadContentSuccess)	return;
			var i:int = 0;
			for (i = 0; i < NumChildMovie; i++) 
			{
				subMov = mov.getChildByName("Child" + i) as Sprite;
				subMov.visible = true;
			}
			var stateBoss:int = getCurrentHornInfo();
			var arrChildHideIdle:Array = ArrChildHide[stateBoss];
			if (State == BOSS_STATE_HURT)
			{
				arrChildHideIdle = ArrChildHide[(stateBoss - 1)];
			}
			var subMov:Sprite;
			for (i = 0; arrChildHideIdle && i < arrChildHideIdle.length; i++)
			{
				var item:int = arrChildHideIdle[i];
				subMov = mov.getChildByName("Child" + item) as Sprite;
				subMov.visible = false;
			}
		}
		
		public function GenNumFramePlay(HpSubBoss:int, HpSubSolider:int, DamageSoldier:int):int
		{
			var damgeBase:int = 10;
			var rateHpBase:int = 20;	// tỷ lệ HP base ứng với base frame play
			var baseFrame:Number = 5;	// base dựa trên lực attack là 10
			baseFrame = baseFrame * (damgeBase / DamageSoldier);
			
			var n:Number = rateHpBase * baseFrame * HpSubBoss * HpSubBoss / HpSubSolider;
			n = Math.min(n, 1800);
			return int(n);
		}
		
		private function InitBaseData():void 
		{
			var ChildeHideElement:Array = [];
			// 5 trạng thái gãy 0, 1, 2, 3, 4 sừng
			ChildeHideElement = [0, 1, 3, 4, 5, 6, 7, 12, 13];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [0, 1, 4, 5, 6, 7, 8, 12, 13];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [2, 5, 6, 7, 8, 9, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [2, 6, 7, 8, 9, 10, 12, 14];
			ArrChildHide.push(ChildeHideElement);
			ChildeHideElement = [2, 8, 9, 10, 11, 14];
			ArrChildHide.push(ChildeHideElement);
		}
	}

}