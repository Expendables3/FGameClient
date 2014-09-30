package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GameControl.GameController;
	import GUI.GUIFishStatus;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SubBossMetal extends FishSoldier 
	{
		public function SubBossMetal(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			this.ClassName = "SubBossMetal";
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
					randomRotation();
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
		private function PreStartEffDie():void 
		{
			if (countPreStartDie == 0)
			{
				//var subPos:Point = CurPos.subtract(GameLogic.getInstance().user.bossMetal.CurPos);
				var subPos:Point = CurPos.subtract(GameLogic.getInstance().user.bossMetal.CurPos);
				var alpha:Number = 180 + Math.atan(subPos.y / subPos.x) / Math.PI * 180;
				img.rotation = alpha;
				countPreStartDie ++;
				GameLogic.getInstance().user.bossMetal.SetStateBoss(BossMetal.BOSS_STATE_HURT_GOLD);
			}
			else if(countPreStartDie < 15)
			{
				countPreStartDie++
			}
			else 
			{
				GameLogic.getInstance().user.arrSubBossMetal.splice(GameLogic.getInstance().user.arrSubBossMetal.indexOf(this), 1);
				if(GameLogic.getInstance().user.arrSubBossMetal.length > 0)
				{
					GameLogic.getInstance().user.bossMetal.SetStateBoss(BossMetal.BOSS_STATE_SHIELD);
				}
				else 
				{
					GameLogic.getInstance().user.bossMetal.SetStateBoss(BossMetal.BOSS_STATE_IDLE_NORMAL);
				}
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "Bolt_Explode", null, CurPos.x, CurPos.y, false, false, null, processAffterExplode);
				countPreStartDie = 0;
			}
		}
		private function processAffterExplode():void 
		{
			ClearImage();
			Destructor();
			GameLogic.getInstance().AddPrgToProcess(GuiMgr.getInstance().GuiMainFishWorld.prgBossArmorMetal, GameLogic.getInstance().user.arrSubBossMetal.length * 0.25);
			if (GameLogic.getInstance().user.arrSubBossMetal.length  <= 0)
			{
				GameLogic.getInstance().user.bossMetal.GotoPosNew(new Point(GameLogic.getInstance().user.bossMetal.CurPos.x - 150, GameLogic.getInstance().user.bossMetal.CurPos.y));
			}
		}
		private function randomRotation():void 
		{
			var Ro:Number;
			if (countRandomRotation >= 9)
			{
				Ro = 25 * (2 * Math.random() - 1);
				img.rotation = Ro;
				countRandomRotation = 0;
			}
			else 
			{
				countRandomRotation++;
			}
		}
	}

}