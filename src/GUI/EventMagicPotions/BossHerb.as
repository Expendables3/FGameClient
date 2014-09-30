package GUI.EventMagicPotions 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import Event.EventMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.Image;
	import GUI.EventMagicPotions.NetworkPacket.AttackHerbBoss;
	import GUI.FishWar.FishWar;
	import GUI.GUIFishStatus;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.FallingObject;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.LayerMgr;
	import Logic.Ultility;
	/**
	 * Boss Thảo Dược
	 * @author longpt
	 */
	public class BossHerb extends FishSoldier
	{
		public static const EMO_HURT:String = "EmoHurt";
		public static const EMO_ATTACK:String = "EmoAttack";
		public static const EMO_IDLE:String = "EmoIdle";
		public static const EMO_DEAD:String = "EmoDead";
		public static const EMO_HAPPY:String = "EmoHappy";
		
		public static const ITEM_TYPE:String = "Boss";
		public static const TIME_LIVE:int = 3600;
		
		// Trạng thái
		public static const IDLE:String = "Idle";
		public static const ATTACK:String = "Attack";
		public static const SHOCK:String = "Shock";
		public static const DEAD:String = "Dead";
		public static const SHIELD:String = "Shield";
		
		// Kiểu attack
		public static const ATTACK_NORMAL:int = 0;
		public static const ATTACK_CRITICAL:int = 1;
		public static const ATTACK_MISS:int = 2;
		
		public static var CooldownBoss:int = 0;
		
		public var tooltipBossHerb:TooltipBossHerb;
		public var CurHour:int;
		
		public var EnemyList:Array = [];
		
		public var isWin:Boolean;
		public var lucky:Object;
		
		public var CooldownMine:Number;
		public var CooldownTheirs:Number;
		
		public var LastAtkTheirs:Number;
		public var LastAtkMine:Number;
		
		public var HPMine:Object;
		public var curHPMine:Object;
		public var MaxHPMine:Object;
		
		public var HPTheirs:int;
		public var curHPTheirs:int;
		public var MaxHPTheirs:int;
		
		public var curHitMine:int = 1;
		public var curHitTheirs:int = 1;
		
		public var DmgMine:Object;
		public var DmgTheirs:int;
		
		// Status của hít đó (trúng, trượt)
		public var hitStatusMine:Object;
		public var hitStatusTheirs:int;
		
		public var isCritMine:Object = new Object();
		public var isCritTheirs:Boolean = false;
		
		public var isFinish:Boolean;
		
		public var enemyHitId:int;
		
		public var data:Object;
		
		public var attackerStack:Array = [];
		
		public var ResControl:MovieClip;
		
		public var isTurnBoss:Boolean;
		
		public var startBossAtkTime:Number;
		public var bossCastingTime:Number = 1.2;
		
		public var isHetMauCaTeam:Boolean;
		
		//public var APos:Point;
		//public var BPos:Point;
		//
		//public var CurPosGo:String;
		
		public var Mask:MovieClip;
		public var Hole:Image;
		
		public function BossHerb(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			this.ClassName = "BossHerb";
			
			tooltipBossHerb = new TooltipBossHerb(this, this.aboveContent, "ImgFrameFriend");
		}
		
		public override function Init(x:int, y:int):void
		{
			Dragable = false;			
			Eated = 0;
			SetDeep(curDeep);
			SetSwimingArea(new Rectangle(Constant.MAX_WIDTH/2 - Main.imgRoot.stage.width/2, GameController.getInstance().GetLakeTop(), Main.imgRoot.stage.width, Constant.HEIGHT_LAKE - 40));
			SetPos(x, y);
			SetMovingState(FS_SWIM);
			FindDes(false);
			RefreshImg();
		}
		
		public override function RefreshImg():void
		{
			ClearImage();
			switch(Emotion)
			{
				case EMO_ATTACK:
					LoadRes("BossHerb_Attack");
					break;
				case EMO_DEAD:
					LoadRes("BossHerb_Dead");
					break;
				case EMO_HAPPY:
					LoadRes("BossHerb_Happy");
					break;
				case EMO_HURT:
					LoadRes("BossHerb_Hurt");
					break;
				case EMO_IDLE:
					LoadRes("BossHerb_Idle");
					break;
				default:
					LoadRes("BossHerb_Idle");
					break;
			}
			
			img.scaleX = OrientX*Scale;
			img.scaleY = Scale;
			
			sortContentLayer();			

			addGemEffect();
			
			//Add bóng
			if (shadow == null)
			{
				shadow = ResMgr.getInstance().GetRes("FishShadow") as Sprite;				
				Parent.addChild(shadow);
				shadow.x = img.x;
				shadow.y = GameController.getInstance().GetLakeBottom() - curDeep * SHADOW_SCOPE;
				shadow.scaleY = 0.7;
			}
			
			if (Mask)
			{
				this.img.mask = Mask;
			}
		}
		
		public override function UpdateEmotion():void
		{
			//SetEmotion(WAR);
		}
		
		public override function Swim(speedFish:int = -1):void
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
			
			if (ReachDes)
			{
				if (Mask || Hole)
				{
					this.img.mask = null;
					LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).removeChild(Mask);
					Mask = null;
					LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).removeChild(Hole.img);
					Hole = null;
				}
				
				if (State != FS_WAR) 
				{
					if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
					{
						// Fix desPos.x để cá lính quay đầu theo hướng
						DesPos.x = 0;
						img.rotation = 0;
						flipX( -1);
						
						isInRightSide = true;
						if (!GuiFishStatus.IsVisible)
						GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
					}
					else
					{
						FindDes();
					}

					if(Ultility.IsKillBoss())
					{
						if (Status == STATUS_REVIVE)
						{
							SetEmotion(REVIVE);
						}
						else if (Health < 2 * AttackPoint)
						{
							SetEmotion(WEAK);
						}
					}
				}
				else
				{
					SetEmotion(IDLE);
					GameLogic.getInstance().isAttacking = true;
					isReadyToFight = true;
					flipX( -1);
				}
			}
			
			CheckWarPositionBossHerb();
		}
		
		private function CheckWarPositionBossHerb():void
		{
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_BOSS)
			{
				if ((CurPos.x - img.width / 2) >= (Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2))
				{
					this.Destructor();
					GameLogic.getInstance().user.bossHerb = null;
				}
			}
			else if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
			{
				if (ReachDes)
				{
					SetMovingState(FS_STANDBY);
					tooltipBossHerb.GetButtonEx(TooltipBossHerb.BTN_CARE).img.visible = true;
					tooltipBossHerb.GetButtonEx(TooltipBossHerb.BTN_RAPE).img.visible = true;
				}
			}
		}
		
		public function OnClick():void
		{
			/*GameLogic.getInstance().user.FishSoldierActorMine.splice(0, GameLogic.getInstance().user.FishSoldierActorMine.length);
			var mySoldierList:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			if (mySoldierList.length == 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg13"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}*/
			
			
			
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_BOSS)
			{
				if (tooltipBossHerb)
				{
					tooltipBossHerb.img.visible = true;
				}
				else
				{
					tooltipBossHerb = new TooltipBossHerb(this, this.aboveContent, "ImgFrameFriend");
				}
			}
			else
			{
				
			}
		}
		
		public function SendCareBoss():Boolean
		{
			// Check energy
			var cfgE:int = ConfigJSON.getInstance().GetItemList("Event").MagicPotion.EnergyCare;
			if (GameLogic.getInstance().user.GetEnergy() < cfgE)
			{
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
				return false;
			}
			
			SetEmotion(EMO_HAPPY);
			
			// UpdateEnergy
			GameLogic.getInstance().user.UpdateEnergy( -cfgE);
			
			// Cmd
			var cmd:AttackHerbBoss = new AttackHerbBoss(true);
			Exchange.GetInstance().Send(cmd);
			
			return true;
		}
		
		public function ProcessCareBoss():void
		{
			// Rơi quà
			var mat:FallingObject;
			var cfg:Object = ConfigJSON.getInstance().GetItemList("HerbBossReward").Care.Sure;
			for (var s:String in cfg)
			{
				switch (cfg[s].ItemType)
				{
					case "Exp":
						EffectMgr.getInstance().fallExpMoney(cfg[s].Num, 0, this.CurPos, 1, 1);
						break;
					case "RankPointBottle":
					case "Herb":
						// Cho quà rơi ra
						for (var j:int = 0; j < cfg[s].Num; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER),  cfg[s]["ItemType"] + cfg[s]["ItemId"], this.img.x, this.img.y);
							mat.ItemType = cfg[s]["ItemType"];
							mat.ItemId = cfg[s]["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						GuiMgr.getInstance().GuiStore.UpdateStore(cfg[s].ItemType, cfg[s].ItemId, cfg[s].Num);
						break;
				}
			}
			
			// Về trạng thái hòa bình
			posA = standbyPos;
			posB = new Point(standbyPos.x - 100, standbyPos.y);
			AtoBTime = 5;
			SetMovingState(FS_A_TO_B);
			
			// IsFail
			GameLogic.getInstance().user.GetMyInfo().EventInfo.IsFail = false;
		}
		
		public function SendAttackBoss():Boolean
		{
			// Check xem có ngư thủ ok ko
			EnemyList = [];
			EnemyList = EnemyList.concat(GameLogic.getInstance().user.FishSoldierArr);
			EnemyList = EnemyList.concat(GameLogic.getInstance().user.FishSoldierActorMine);
			
			var i:int;
			var isCanFight:Boolean = false;
			for (i = 0; i < EnemyList.length; i++)
			{
				if (EnemyList[i].Health > 0 && EnemyList[i].Status == STATUS_HEALTHY)
				{
					isCanFight = true;
				}
				else
				{
					EnemyList.splice(i, 1);
					i--;
				}
			}
			
			if (!isCanFight)
			{
				if (EnemyList.length == 0)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg13"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg19"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				}
				return false;
			}
			
			// Check energy
			var cfgE:int = ConfigJSON.getInstance().GetItemList("Event").MagicPotion.EnergyAttack;
			if (GameLogic.getInstance().user.GetEnergy() < cfgE)
			{
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
				return false;
			}
			
			// UpdateEnergy
			GameLogic.getInstance().user.UpdateEnergy( -cfgE);
			
			// Cmd
			var cmd:AttackHerbBoss = new AttackHerbBoss(false);
			Exchange.GetInstance().Send(cmd);
			
			return true;
		}
		
		public function ProcessAttackBoss(Scene:Object, isWin:Boolean, Lucky:Object):void
		{
			GuiMgr.getInstance().GuiCover.Show(Constant.GUI_MIN_LAYER, 1);
			this.isWin = isWin;
			this.lucky = Lucky;
			this.data = Scene;
			
			InitCombatData(Scene);
			
			this.tooltipBossHerb.SetVisible(false);
			this.SwimTo(CurPos.x - 20, CurPos.y, 10, true);
			
			for (var i:int = 0; i < EnemyList.length; i++)
			{
				//EnemyList[i].SwimTo(EnemyList[i].CurPos.x + 170, EnemyList[i].CurPos.y, 10, true);
				EnemyList[i].SwimTo(EnemyList[i].standbyPos.x + 170, EnemyList[i].standbyPos.y, 10, true);
				trace("standbyPos: ", EnemyList[i].standbyPos.x, EnemyList[i].standbyPos.y);
				trace("isInRightSide = " + EnemyList[i].isInRightSide);
			}
		}
		
		public override function OnReloadRes():void
		{
			Init(CurPos.x, CurPos.y);
			img.mouseChildren = false;
		}
		
		public function CheckCombat():void
		{
			var isReadyAll:Boolean = true;
			var i:int;
			if (this.isReadyToFight)
			{
				for (i = 0; i < EnemyList.length; i++)
				{
					if (EnemyList[i].isReadyToFight == false)
					{
						isReadyAll = false;
						break;
					}
				}
			}
			else
			{
				isReadyAll = false;
			}
			
			if (isReadyAll && GameLogic.getInstance().isAttacking)
			{
				//CombatForReal();
				CombatForReal1();
			}
		}
		
		// Kịch bản server trả về
		public function InitCombatData(data:Object):void
		{
			var i:int;
			var s:String;
			
			// Cooldown như nhau
			CooldownMine = CooldownTheirs = 3;
			
			// Xác định mình hay bạn đánh trước, LastTimeAtk ngẫu nhiên
			if (data[0].attackFirst == 0)
			{
				// Mình đánh sau
				LastAtkTheirs = GameLogic.getInstance().CurServerTime - CooldownTheirs;
				//LastAtkMine = LastAtkTheirs + Math.random() + 0.5 - CooldownMine;	// Thời gian đánh sau ngẫu nhiên từ 0.5 đến 1.5s;
				LastAtkMine = LastAtkTheirs + 3;
				
				isTurnBoss = true;
			}
			else
			{
				// Mình đánh trước
				LastAtkMine = GameLogic.getInstance().CurServerTime - CooldownMine;
				//LastAtkTheirs = LastAtkMine + Math.random() + 0.5 - CooldownTheirs;	// Thời gian đánh sau ngẫu nhiên từ 0.5 đến 1.5s;
				LastAtkTheirs = LastAtkMine + 3;
				
				isTurnBoss = false;
			}
			
			// Máu ban đầu
			
			HPMine = new Object();
			curHPMine = new Object();
			MaxHPMine = new Object();
			
			for (s in data[0].Vitality.Attack)
			{
				HPMine[s] = curHPMine[s] = MaxHPMine[s] = data[0].Vitality.Attack[s];
			}
			
			HPTheirs = curHPTheirs = MaxHPTheirs = data[0].Vitality.Defence.Left;
		}
		
		public function CombatForReal1():void
		{
			if (isFinish)	return;
			
			if (isHetMauCaTeam || HPTheirs <= 0 || (curHitMine >= data.length && curHitTheirs >= data.length))
			{
				isFinish = true;
				GameLogic.getInstance().isAttacking = false;
				FightResult();
				return;
			}
			
			if (isTurnBoss)
			{
				if (Emotion != EMO_ATTACK)
				{
					SetEmotion(EMO_ATTACK);
					startBossAtkTime = GameLogic.getInstance().CurServerTime;
				}
				
				if (startBossAtkTime + bossCastingTime < GameLogic.getInstance().CurServerTime)
				{
					for (var s:String in data[curHitTheirs].Vitality.Attack)
					{
						DmgTheirs = int(curHPMine[s] - data[curHitTheirs].Vitality.Attack[s]);
						if (DmgTheirs > 0)
						{
							enemyHitId = int(s);
							break;
						}
					}
					hitStatusTheirs = data[curHitTheirs].Status.Defence;
					if (hitStatusTheirs == FishWar.HIT_CRIT)
					{
						isCritTheirs = true;
					}
					HPUpdate(true);
					UpdateFishInEnemyList();
					isTurnBoss = false;
					curHitTheirs++;
				}
			}
			else
			{
				if (Emotion != EMO_HURT)
				{
					SetEmotion(EMO_HURT);
					trace(ImgName);
					
					DmgMine = new Object();
					//curHitMine++;
					
					if (data[curHitMine].Vitality.Defence.ListAtt)
					{
						for (s in data[curHitMine].Vitality.Defence.ListAtt)
						{	
							DmgMine[s] = data[curHitMine].Vitality.Defence.ListAtt[s];
						}
					}
					else
					{
						for (s in data[curHitMine].Vitality.Defence.ListAtt)
						{	
							DmgMine[s] = 0;
						}
					}
					
					hitStatusMine = new Object();
					isCritMine = new Object();
					for (s in data[curHitMine].Status.Attack)
					{
						hitStatusMine[s] = data[curHitMine].Status.Attack[s];
					}
					
					if (hitStatusMine[s] == FishWar.HIT_CRIT)
					{
						isCritMine[s] = true;
					}
					
					attackerStack = [];
					for (var i:int = 0; i < EnemyList.length; i++)
					{
						var effName:String = "";
						if (EnemyList[i].EquipmentList.Mask[0])
						{
							effName = "EffWarMask";
						}
						else
						{
							effName = "EffWar" + EnemyList[i].Element;
						}
						attackerStack.push(EnemyList[i].Id);
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, effName, null, EnemyList[i].img.x, EnemyList[i].img.y, false, false, null, function():void { HPUpdate(false) } );
					}
					curHitMine++;
				}
			}
		}
		
		public function CombatForReal():void
		{
			/*// Kiểm soát hiển thị boss
			if (ResControl != null)
			{
				if (ResControl.currentFrame == ResControl.totalFrames)
				{
					if (this.ImgName == "BossHerb_Attack")
					{
						HPUpdate(true);
						trace("update mau ca linh");
						curHitTheirs++;
					}
					LoadRes("BossHerb_Idle");
					flipX( -1);
					ResControl = null;
				}
			}*/
			
			var s:String;
			var i:int;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			
			if (curTime > LastAtkMine + CooldownMine && curHitMine < data.length)
			{
				DmgMine = new Object();
				//curHitMine++;
				
				if (data[curHitMine].Vitality.Defence.ListAtt)
				{
					for (s in data[curHitMine].Vitality.Defence.ListAtt)
					{	
						DmgMine[s] = data[curHitMine].Vitality.Defence.ListAtt[s];
					}
				}
				else
				{
					for (s in data[curHitMine].Vitality.Defence.ListAtt)
					{	
						DmgMine[s] = 0;
					}
				}
				
				hitStatusMine = new Object();
				isCritMine = new Object();
				for (s in data[curHitMine].Status.Attack)
				{
					hitStatusMine[s] = data[curHitMine].Status.Attack[s];
				}
				
				if (hitStatusMine[s] == FishWar.HIT_CRIT)
				{
					isCritMine[s] = true;
				}
				Attack(false);
				LastAtkMine = curTime;				
			}
			
			if (curTime <= LastAtkTheirs + CooldownTheirs && curHitTheirs < data.length)
			{
				
			}
			else if (curTime > LastAtkTheirs + CooldownTheirs && curHitTheirs < data.length)
			{
				//curHitTheirs++;
				for (s in data[curHitTheirs].Vitality.Attack)
				{
					DmgTheirs = int(curHPMine[s] - data[curHitTheirs].Vitality.Attack[s]);
					if (DmgTheirs > 0)
					{
						enemyHitId = int(s);
						break;
					}
				}
				hitStatusTheirs = data[curHitTheirs].Status.Defence;
				if (hitStatusTheirs == FishWar.HIT_CRIT)
				{
					isCritTheirs = true;
				}
				Attack(true);
				LastAtkTheirs = curTime;
			}
			
			if (LastAtkMine < curTime-5 && LastAtkTheirs < curTime - 5)
			{
				if (isFinish)	return;
				isFinish = true;
				GameLogic.getInstance().isAttacking = false;
				FightResult();
			}
		}
		
		public function Attack(isMine:Boolean):void
		{
			/*if (isFinish)	return;
			
			var effName:String = "";
			// Add Effect chém gió
			if (isMine)
			{
				LoadRes("BossHerb_Attack");
				ResControl = this.img as MovieClip;
				flipX( -1);
			}
			else
			{
				var i:int;
				for (i = 0; i < EnemyList.length; i++)
				{
					if (EnemyList[i].EquipmentList.Mask[0])
					{
						effName = "EffWarMask";
					}
					else
					{
						effName = "EffWar" + EnemyList[i].Element;
					}
					attackerStack.push(EnemyList[i].Id);
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, effName, null, EnemyList[i].img.x, EnemyList[i].img.y, false, false, null, function():void { HPUpdate(false) } );
				}
				curHitMine++;
				trace(curHitMine);
				
				if (ImgName == "BossHerb_Attack")
				{
					LoadRes("BossHerb_Hurt");
					HPUpdate(true);
				}
				flipX( -1);
				ResControl = this.img as MovieClip;
			}*/
		}
		
		public function FightResult():void
		{
			var et:SwfEffect;
			if ((isWin == 1) || (isWin == 2))
			{
				et = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishWarWin", null, 420, 300, false, false, null, DropGift);
				SetEmotion(EMO_DEAD);
				
			}
			else
			{
				et = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishWarLose", null, 420, 300, false, false, null, DropGift);
			}
		}
		
		public function HPUpdate(isAttacked:Boolean):void
		{
			var s:Sprite;
			var i:int;
			// Effect trượt
			if (isAttacked)
			{
				var victim:FishSoldier;
				for (i = 0; i < EnemyList.length; i++)
				{
					if (EnemyList[i].Id == enemyHitId)
					{
						victim = EnemyList[i];
						break;
					}
				}
				
				if (victim != null)
				switch (hitStatusTheirs)
				{
					case FishWar.HIT_MISS:
						s = ResMgr.getInstance().GetRes("EffTxtTruot") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, victim.aboveContent, new Point(0, 0), new Point( -150, 0), new Point( -50, 0), 0.4, 0.3);
						break;
					case FishWar.HIT_CRIT:
						s = ResMgr.getInstance().GetRes("EffTxtChiMang") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, victim.aboveContent, new Point(0, 0), new Point( -150, 0), new Point( -50, 0), 0.4, 0.3);
						break;
				}
			}
			else
			{
				switch (hitStatusMine)
				{
					case FishWar.HIT_MISS:
						s = ResMgr.getInstance().GetRes("EffTxtTruot") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, this.aboveContent, new Point(0, 0), new Point(150, 0), new Point(50, 0), 0.4, 0.3);
						break;
					case FishWar.HIT_CRIT:
						s = ResMgr.getInstance().GetRes("EffTxtChiMang") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, this.aboveContent, new Point(0, 0), new Point(150, 0), new Point(50, 0), 0.4, 0.3);
						break;
				}
			}
			
			// Trừ máu
			if (isAttacked)
			{
				if (victim != null)
				{
					if (isCritTheirs)
					{
						HPEffect( -DmgTheirs, victim, true);
						isCritTheirs = false;
					}
					else
					{
						HPEffect( -DmgTheirs, victim);
					}
					HPMine[victim.Id] -= DmgTheirs;
				}
			}
			else
			{
				//for (i = 0; i < EnemyList.length; i++)
				//{
					//if (isCritMine[EnemyList[i].Id])
					if (isCritMine[attackerStack[0]])
					{
						//HPEffect( -DmgMine[EnemyList[i].Id], this as FishSoldier, true);
						HPEffect( -DmgMine[attackerStack[0]], this as FishSoldier, true);
						attackerStack.splice(0, 1);
						isCritMine[attackerStack[0]] = false;
					}
					else
					{
						//HPEffect( -DmgMine[EnemyList[i].Id], this as FishSoldier);
						HPEffect( -DmgMine[attackerStack[0]], this as FishSoldier);
						attackerStack.splice(0, 1);
					}
					if (DmgMine[attackerStack[0]])
					{
						HPTheirs -= DmgMine[attackerStack[0]];
					}
					//break;
				//}
				//trace(HPTheirs);
				//SetEmotion(EMO_IDLE);
				isTurnBoss = true;
			}
			
			if (isFinish)	return;
			isHetMauCaTeam = true;
			for (var k:int = 0; k < EnemyList.length; k++)
			{
				if (curHPMine[EnemyList[k].Id] > 0)
				{
					isHetMauCaTeam = false;
					break;
				}
			}
			if (isHetMauCaTeam || HPTheirs <= 0 || (curHitMine >= data.length && curHitTheirs >= data.length))
			{
				isFinish = true;
				GameLogic.getInstance().isAttacking = false;
				FightResult();
			}
		}
		
		public function HPEffect(num:int, fish:FishSoldier, isCrit:Boolean = false):void
		{
			var curHP:int;
			var HP:int;
			if (!(fish is BossHerb))
			{
				curHP = curHPMine[fish.Id] + num;
				curHPMine[fish.Id] += num;
				HP = MaxHPMine[fish.Id];
				trace(curHP, HP, "alo alo");
			}
			else
			{
				curHP = curHPTheirs + num;
				curHPTheirs += num;
				HP = MaxHPTheirs;
				//trace(curHP, HP);
			}
			if (fish.GuiFishStatus.IsVisible && fish.GuiFishStatus.prgHP && fish.GuiFishStatus.prgHP.img)
			{
				GameLogic.getInstance().AddPrgToProcess(fish.GuiFishStatus.prgHP, curHP / HP, Constant.TYPE_PRG_HP);
			}
			else 
			{
				fish.GuiFishStatus.ShowHPBar(fish, curHP, HP);
			}
			var child:Sprite = new Sprite();
			var str:String = num.toString();
			var txtFormat:TextFormat;
			
			if (isCrit)
			{
				txtFormat= new TextFormat("Arial", 52, 0xff0000);
			}
			else
			{
				txtFormat= new TextFormat("Arial", 26, 0xff0000);
			}
			txtFormat.align = "center";
			
			//if (fish is BossHerb)
			{
				EffectMgr.getInstance().textFly(str, new Point(0, -100) , txtFormat, fish.aboveContent, 0, -40, 3);
			}
			//else
			//{
				//var o:Object = new Object();
				//o.str = str;
				//o.txtFormat = txtFormat;
				//o.pos = new Point(0, -100);
				//o.parent = fish;
				//o.LastEffectTime = GameLogic.getInstance().CurServerTime;
				//GameLogic.getInstance().EffectInFishList.push(o);
			//}
		}
		
		public function UpdateFishInEnemyList():void
		{
			for (var i:int = 0; i < EnemyList.length; i++)
			{
				var id:int = EnemyList[i].Id;
				if (!HPMine[id] || HPMine[id] <= 0)
				{
					var f:FishSoldier = EnemyList[i] as FishSoldier;
					//if (f.isActor == ACTOR_MINE)
					//{
						//f.SwimTo(0, f.img.y, 10);
					//}
					//else
					{
						f.SwimTo(f.standbyPos.x, f.standbyPos.y, 10);
					}
					
					EnemyList.splice(i, 1);
					i--;
				}
			}
		}
		
		public function DropGift():void
		{
			if (!isWin)
			{
				GameController.getInstance().UseTool("ByeByeBoss");
				GameLogic.getInstance().user.GetMyInfo().EventInfo.IsFail = true;
				return;
			}
			
			var s:String;
			var j:int;
			
			// Rơi quà
			var mat:FallingObject;
			var cfg:Object = ConfigJSON.getInstance().GetItemList("HerbBossReward").Attack.Sure;
			for (s in cfg)
			{
				switch (cfg[s].ItemType)
				{
					case "Exp":
						EffectMgr.getInstance().fallExpMoney(cfg[s].Num, 0, this.CurPos, 1, 1);
						break;
					case "RankPointBottle":
					case "Herb":
						// Cho quà rơi ra
						for (j = 0; j < cfg[s].Num; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER),  cfg[s]["ItemType"] + cfg[s]["ItemId"], this.img.x, this.img.y);
							mat.ItemType = cfg[s]["ItemType"];
							mat.ItemId = cfg[s]["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						
						GuiMgr.getInstance().GuiStore.UpdateStore(cfg[s].ItemType, cfg[s].ItemId, cfg[s].Num);
						break;
				}
			}
			
			if (lucky)
			{
				switch(lucky.ItemType)
				{
					case "Exp":
						EffectMgr.getInstance().fallExpMoney(lucky.Num, 0, this.CurPos, 1, 1);
						break;
					case "Material":
						for (j = 0; j < lucky.Num; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER),  lucky["ItemType"] + lucky["ItemId"], this.img.x, this.img.y);
							mat.ItemType = lucky["ItemType"];
							mat.ItemId = lucky["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						break;
					default:
						// Equipment
						GuiMgr.getInstance().guiCongratulation.showReward(lucky.Type + lucky.Rank + "_Shop", 1, Localization.getInstance().getString(lucky.Type + lucky.Rank));
						GameLogic.getInstance().user.GenerateNextID();
						break;
				}
			}
			
			GameController.getInstance().UseTool("ByeByeBoss");
			GameLogic.getInstance().user.GetMyInfo().EventInfo.IsFail = false;
			
			/*// Show GUI kết quả
			var arr:Array = [];
			for (s in cfg)
			{
				arr.push(cfg[s]);
			}
			if (lucky)
			{
				arr.push(lucky);
			}*/
			
			
			//GuiMgr.getInstance().GuiCongratKillBossHerb.InitData(arr);
		}
		
		public override function AtoB():void
		{
			super.AtoB();
			if (AtoBTime <= 0)
			{
				GameController.getInstance().UseTool("ByeByeBoss");
			}
		}
		
		public static function CheckBossHerbRealTime():void
		{
			if (EventMgr.CheckEvent("MagicPotion") == EventMgr.CURRENT_IN_EVENT)
			{
				// Check Boss thao duoc
				if (GameLogic.getInstance().CheckBossHerbVisibility() && !GameLogic.getInstance().user.IsViewer() && Ultility.IsInMyFish())
				{
					GameLogic.getInstance().user.InitBossHerb();
					if (!GuiMgr.getInstance().GuiCountdownBossHerb.IsVisible)
					{
						GuiMgr.getInstance().GuiCountdownBossHerb.Show(Constant.GUI_MIN_LAYER, 0);
					}
				}
				else
				{
					//if (GameLogic.getInstance().user.bossHerb)
					//{
						//GameLogic.getInstance().user.bossHerb.Destructor();
						//GameLogic.getInstance().user.bossHerb = null;
					//}
				}
				
				if (!GameLogic.getInstance().CheckBossHerbVisibility() && !GameLogic.getInstance().user.IsViewer() && Ultility.IsInMyFish())
				{
					if (!GuiMgr.getInstance().GuiCountdownBossHerb.IsVisible)
					{
						GuiMgr.getInstance().GuiCountdownBossHerb.Show(Constant.GUI_MIN_LAYER, 0);
					}
				}
				else
				{
					if (GuiMgr.getInstance().GuiCountdownBossHerb.IsVisible)
					{
						GuiMgr.getInstance().GuiCountdownBossHerb.Hide();
					}
				}
			}
			else
			{
				if (GameLogic.getInstance().user.bossHerb)
				{
					GameLogic.getInstance().user.bossHerb.Destructor();
					GameLogic.getInstance().user.bossHerb = null;
				}
			}
		}
	}

}