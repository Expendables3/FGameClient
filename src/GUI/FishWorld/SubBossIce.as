package GUI.FishWorld 
{
	import Data.ConfigJSON;
	import flash.geom.Point;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SubBossIce extends FishSoldier 
	{
		public var PreDie:Boolean = false;
		public var isPreComeBack:Boolean = false;
		public function SubBossIce(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			this.ClassName = "SubBossIce";
		}
		
		override public function RefreshImg():void 
		{ 
			sortContentLayer();		
		}
		override public function UpdateFish():void 
		{
			//super.UpdateFish();
			if (!img)	return;
			
			aboveContent.x = underContent.x = img.x;
			aboveContent.y = underContent.y = img.y;
			
			UpdateEmotion();
			switch (State) 
			{
				case FS_IDLE:
				case FS_STANDBY:
					(this as FishSoldier).StandBy();
				break;
				case FS_SWIM:
					Swim();
					break;
				case FS_PRE_DEAD:
					PreStartEffDie();
				break;
			}
			if (GuiFishStatus.IsVisible)
			{				
				GuiFishStatus.SetPos(CurPos.x, CurPos.y);
			}	
		}
		
		private function PreStartEffDie():void 
		{
			LoadRes("SubBoss2_Loose");
			SwimTo(CurPos.x + 300, CurPos.y, 7);
			OrientX = -1;
			PreDie = true;
		}
		
		override public function Swim(speedFish:int = -1):void 
		{
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
			
			if (chatbox)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
			
			if (ReachDes)
			{
				if (!isSubBoss && ((!Ultility.IsInMyFish() && Emotion != WEAK) || Ultility.IsInMyFish())) 
				{
					SetEmotion(IDLE);
				}
				
				if (GameLogic.getInstance().user.CurSoldier[1] is SubBossIce)
				{
					// Các cờ được bật lên để các con cá thực hiên kịch bản server trả về
					if(!isPreComeBack)
					{
						GameLogic.getInstance().isAttacking = true;
						isReadyToFight = true;
					}
					else
					{
						GameLogic.getInstance().isAttacking = false;
						isReadyToFight = false;
						SetEmotion(WAR);
						isPreComeBack = false;
						SetMovingState(FS_STANDBY);
					}
				}
				
				if (PreDie)
				{
					GameLogic.getInstance().user.arrSubBossIce.splice(GameLogic.getInstance().user.arrSubBossIce.indexOf(this), 1);
					Destructor();
					var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
					var arrTactic:Array = BossIce.GetTactic(0);
					var dataBoss:Object = GameLogic.getInstance().user.arrBossDataIce[0];
					var boss_Ice:BossIce = new BossIce(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Boss2_Idle_1");
					boss_Ice.SetStateBoss(BossIce.BOSS_STATE_IDLE);
					boss_Ice.IsBoss = dataBoss.IsBoss;
					var configBoss:Object = objAllSea[FishWorldController.GetSeaId().toString()][FishWorldController.GetRound()];
					boss_Ice.IdBoss = dataBoss.Id;
					boss_Ice.CurHp = dataBoss.Vitality;
					boss_Ice.isSetCurHP = true;
					boss_Ice.MaxHp = configBoss[boss_Ice.IdBoss.toString()].Vitality;
					boss_Ice.Attack = dataBoss.Damage;
					boss_Ice.Defend = dataBoss.Defence;
					boss_Ice.Init(arrTactic[BossMetal.ID_TACTIC_BOSS][0].x, arrTactic[BossMetal.ID_TACTIC_BOSS][0].y);
					boss_Ice.SetStanbyPos(arrTactic[BossMetal.ID_TACTIC_BOSS][0]);
					GameLogic.getInstance().user.bossIce = boss_Ice;
					
					GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthIce = GuiMgr.getInstance().GuiMainFishWorld.AddProgress(
						GuiMgr.getInstance().GuiMainFishWorld.PRG_HEALTH_BOSS, 
						"PrgHpBossIce", 620, -440, GuiMgr.getInstance().GuiMainFishWorld, true);
					GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthIce.SetPosBackGround( -41, -30)
					GameLogic.getInstance().user.arrBossDataIce.splice(0, 1);
					GameLogic.getInstance().isAttacking = false;
				}
			}
		}
		
		override public function StandBy():void 
		{
			
			var a:int;		// Gia tốc
			var v:int;		// Vận tốc
			
			if (SwimingArea.width == 0 && SwimingArea.height == 0)
			{
				return;
			}
			
			OrientX = -1;
			
			if (CurPos.y <= standbyPos.y + 7 && SpeedVec.y > 0)
			{
				SpeedVec.y = Math.random() * 0.3 + 0.2;
				
			}
			else if (CurPos.y >= standbyPos.y - 7)
			{
				SpeedVec.y = -(Math.random() * 0.3 + 0.2);
			}
			else
			{
				SpeedVec.y = -SpeedVec.y;
			}
			CurPos.y += SpeedVec.y;
			SetPos(CurPos.x, CurPos.y);
			
		}
		
		override public function SetMovingState(movState:int):void 
		{
			super.SetMovingState(movState);
			if (State != FS_ATTACK && State != FS_IDLE && State != FS_STANDBY && State != FS_PRE_DEAD)
			{
				State = FS_STANDBY;
			}
		}
		
		override public function OnMouseOutFish():void 
		{
			SetHighLight( -1);
			GameInput.getInstance().ViewFishInfo(this, false);
			if (State != FS_PRE_DEAD)
			{
				if (isInRightSide)
				{
					SetMovingState(FS_STANDBY);
				}
				else
				{
					SetMovingState(FS_SWIM);
				}
			}
		}
		
		override public function UpdateEmotion():void 
		{
			super.UpdateEmotion();
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR || GameLogic.getInstance().isAttacking)
			{
				SetEmotion(Fish.IDLE);
			}
			else 
			{
				SetEmotion(FishSoldier.WAR);
			}
		}
		
		override public function flipX(orient:int, rightnow:Boolean = true):void 
		{
			//super.flipX(orient, rightnow);
		}
	}

}