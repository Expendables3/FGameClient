package GUI.FishWar 
{
	import com.adobe.utils.IntUtil;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.BitmapEffect;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventLuckyMachine.EventLuckyMachineMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.ProgressBar;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.ForestWorld.Thicket;
	import GUI.FishWorld.Network.SendLoadOcean;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import GUI.GUIFishStatus;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.FallingObject;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendAttackFriendLake;
	import Sound.SoundMgr;
	/**
	 * ...
	 * @author longpt
	 */
	public class FishWar extends BaseObject
	{
		public static const HIT_NORM:int = 0;
		public static const HIT_CRIT:int = 1;
		public static const HIT_MISS:int = 2;
		
		public var FishList:Array = [];
		public var AtkTime:int;
		public var ResultTime:int;
		public var NumCombo:int;
		public var isEnd:Boolean;
		public var myFish:FishSoldier;
		public var theirFish:Fish;
		public var posX:int;
		public var posY:int;
		
		public var IsWin:int = -1;
		public var FishWarResult:Array = [];
		
		public var NumAtkMine:int = 0;
		public var NumAtkTheirs:int = 0;
		
		public var NumCritMine:int = 0;
		public var NumCritTheirs:int = 0;
		
		public var CooldownMine:Number;
		public var CooldownTheirs:Number;
		
		public var DmgMine:int;
		public var DmgTheirs:int;
		
		public var HPMine:int;
		public var HPTheirs:int;
		
		public var curHPMine:int;
		public var curHPTheirs:int;
		
		public var MaxHPMine:int;
		public var MaxHPTheirs:int;
		
		public var TimeCostMine:Number = 0;
		public var TimeCostTheirs:Number = 0;
		
		public var LastAtkMine:Number = 0;
		public var LastAtkTheirs:Number = 0;
		
		public var isFinish:Boolean;
		public var isCritMine:Boolean = false;
		public var isCritTheirs:Boolean = false;
		
		// Lượt đánh thứ mấy của mình? Tính theo mảng server trả về
		public var curHitMine:int = 1;
		public var curHitTheirs:int = 1;
		
		// Status của hít đó (trúng, trượt)
		public var hitStatusMine:int;
		public var hitStatusTheirs:int;
		
		// Dữ liệu server trả về
		public var data:Array;
		
		public var fishSoldier:FishSoldier;	// Con cá lính của mình trong mảng mySoldierArr
		
		public function FishWar(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			this.ClassName = "FishWar";
		}
		
		// Kịch bản server trả về
		public function InitCombatData1():void
		{
			data = GameLogic.getInstance().FishWarScene;
			
			// Cooldown như nhau
			CooldownMine = CooldownTheirs = 1.5;
			
			// Xác định mình hay bạn đánh trước, LastTimeAtk ngẫu nhiên
			if (data[0].attackFirst == 0)
			{
				// Mình đánh sau
				LastAtkTheirs = GameLogic.getInstance().CurServerTime - CooldownTheirs;
				//LastAtkMine = LastAtkTheirs + Math.random() + 0.5 - CooldownMine;	// Thời gian đánh sau ngẫu nhiên từ 0.5 đến 1.5s;
				LastAtkMine = LastAtkTheirs + 0.75;
			}
			else
			{
				// Mình đánh trước
				LastAtkMine = GameLogic.getInstance().CurServerTime - CooldownMine;
				//LastAtkTheirs = LastAtkMine + Math.random() + 0.5 - CooldownTheirs;	// Thời gian đánh sau ngẫu nhiên từ 0.5 đến 1.5s;
				LastAtkTheirs = LastAtkMine + 0.75;
			}
			
			// Máu ban đầu
			HPMine = curHPMine = MaxHPMine = data[0].Vitality.Attack[myFish.Id];
			HPTheirs = curHPTheirs = MaxHPTheirs = data[0].Vitality.Defence.Left;
		}
		
		// Kịch bản tự sướng ở client
		public function InitCombatData():void
		{
			AtkTime = 0;
			ResultTime = -1;
			
			// Cập nhật lại thông số cá
			myFish.UpdateCombatSkill();
			var theirs:FishSoldier = theirFish as FishSoldier;
			theirs.UpdateCombatSkill();
			if (Ultility.IsInMyFish())
			{
				DmgTheirs = theirs.Damage + theirs.bonusEquipment.Damage + theirs.DefencePlus + theirs.DamagePlus;
				curHPTheirs = HPTheirs = MaxHPTheirs = theirs.Vitality + theirs.bonusEquipment.Vitality + theirs.VitalityPlus;
			}
			else 
			{
				DmgTheirs = theirs.Damage;
				curHPTheirs = HPTheirs = MaxHPTheirs = theirs.Vitality;
			}
			curHPMine = HPMine = MaxHPMine = myFish.Vitality + myFish.bonusEquipment.Vitality + myFish.VitalityPlus;
			DmgMine = myFish.Damage + myFish.bonusEquipment.Damage + myFish.DamagePlus;
			
			if (IsWin == 0)		// thua
			{
				NumAtkTheirs = Math.ceil(HPMine / DmgTheirs);
				if (NumAtkTheirs > 3)
				{
					NumCritTheirs = Ultility.RandomNumber(0, Math.floor(NumAtkTheirs / 2));
					NumAtkTheirs -= NumCritTheirs;
				}
				CooldownTheirs = 1;
				//TimeCostTheirs = NumAtkTheirs * CooldownTheirs;
				
				NumAtkMine = Math.ceil(HPTheirs / DmgMine);
				if (NumAtkMine > 3)
				{
					NumCritMine = Ultility.RandomNumber(0, Math.floor(NumAtkMine / 2));
					NumAtkMine -= NumCritMine;
				}
				CooldownMine = CooldownTheirs;
				//TimeCostMine = NumAtkMine * CooldownMine;
				
				// Tính cooldown cho chuẩn
				if (NumAtkTheirs > 1 && NumAtkMine > 1)
				{
					TimeCostTheirs = (NumAtkTheirs - 1 ) * CooldownTheirs;
					TimeCostMine = (NumAtkMine - 1) * CooldownMine;
					
					while (TimeCostTheirs + 1.5>= TimeCostMine)
					{
						CooldownMine += 0.25;
						TimeCostMine = (NumAtkMine - 1) * CooldownMine;
					}
				}
				else
				{
					// Nếu mình thua mà mình chỉ đánh 1 hit là bạn hết máu -> phải để đánh sau
					if (NumAtkMine == 1 && NumAtkTheirs > 1)
					{
						TimeCostTheirs = (NumAtkTheirs - 1) * CooldownTheirs;
						LastAtkMine = GameLogic.getInstance().CurServerTime + TimeCostTheirs;
					}
					else if (NumAtkMine == 1 && NumAtkTheirs == 1)
					{
						TimeCostTheirs = CooldownTheirs;
						LastAtkTheirs = GameLogic.getInstance().CurServerTime + TimeCostTheirs;
					}
				}
			}
			else				// thắng
			{
				NumAtkMine = Math.ceil(HPTheirs / DmgMine);
				if (NumAtkMine > 3)
				{
					NumCritMine = Ultility.RandomNumber(0, Math.floor(NumAtkMine / 2));
					NumAtkMine -= NumCritMine;
				}
				CooldownMine = 1;
				
				NumAtkTheirs = Math.ceil(HPMine / DmgTheirs);
				if (NumAtkTheirs > 3)
				{
					NumCritTheirs = Ultility.RandomNumber(0, Math.floor(NumAtkTheirs / 2));
					NumAtkTheirs -= NumCritTheirs;
				}
				CooldownTheirs = CooldownMine;
				
				// Tính cooldown cho chuẩn
				if (NumAtkTheirs > 1 && NumAtkMine > 1)
				{
					TimeCostMine = (NumAtkMine - 1) * CooldownMine;
					TimeCostTheirs = (NumAtkTheirs - 1) * CooldownTheirs;
					
					while (TimeCostTheirs <= TimeCostMine + 1.5)
					{
						CooldownTheirs += 0.25;
						TimeCostTheirs = (NumAtkTheirs - 1) * CooldownTheirs;
					}
				}
				else
				{
					// Nếu bạn thua mà mình chỉ đánh 1 hit là mình hết máu -> phải để đánh sau
					if (NumAtkTheirs == 1 && NumAtkMine > 1)
					{
						TimeCostMine = (NumAtkMine - 1) * CooldownMine;
						LastAtkTheirs = GameLogic.getInstance().CurServerTime + TimeCostMine;
					}
					else if (NumAtkMine == 1 && NumAtkTheirs == 1)
					{
						TimeCostMine = CooldownMine;
						LastAtkTheirs = GameLogic.getInstance().CurServerTime + TimeCostMine;
					}
				}
				
			}
			
			//trace("Dmg cua minh: " + DmgMine);
			//trace("Dmg cua ban: " + DmgTheirs);
			//trace("HP minh: " + MaxHPMine);
			//trace("HP ban: " + MaxHPTheirs);
			//trace("So luot danh cua minh: " + NumAtkMine);
			//trace("So luot danh cua ban: " + NumAtkTheirs);
			//trace("So luot crit cua minh: " + NumCritMine);
			//trace("So luot crit cua ban: " + NumCritTheirs);
		}
		
		public function SetFishes(mine:FishSoldier, theirs:Fish):void
		{
			myFish = mine;
			theirFish = theirs;
			posX = myFish.img.x;
			posY = myFish.img.y;
			
			SetPos(posX, posY);
		}
		
		public function CreateBattle():void
		{
			AtkTime = 0;
			ResultTime = 10;
			NumCombo = 5;
			isEnd = false;
			var i:int;
			var s:String;
			
			FishWarResult = GameLogic.getInstance().FishWarBonus;
			IsWin = GameLogic.getInstance().IsWin;
			
			if(myFish.ghostEmit != null)
			{
				myFish.ghostEmit.destroy();
				myFish.ghostEmit = null;
			}
			//theirFish.ghostEmit.destroy();
			//theirFish.ghostEmit = null;
			
			// Tăng số lần đánh hồ này
			if (Ultility.IsInMyFish())
			{
				var lakeAtkInfo:Object = GameLogic.getInstance().user.GetMyInfo().Attack;
				var theirId:String = GameLogic.getInstance().user.Id.toString();
				var theirLake:String = GameLogic.getInstance().user.CurLake.Id.toString();
				// Chưa ai đánh gì cả
				if (!lakeAtkInfo.LastTimeAttack)
				{
					lakeAtkInfo.LastTimeAttack = GameLogic.getInstance().CurServerTime;
					lakeAtkInfo["FriendLake"] = new Object();
					lakeAtkInfo["FriendLake"][theirId] = 1;
				}
				else
				{
					lakeAtkInfo.LastTimeAttack = GameLogic.getInstance().CurServerTime;
					if (lakeAtkInfo["FriendLake"][theirId])
					{
						lakeAtkInfo["FriendLake"][theirId] += 1;
					}
					else
					{
						lakeAtkInfo["FriendLake"][theirId] = 1;
					}
				}
			}
			
			
			// Chưa ai đánh gì cả
			//if (!lakeAtkInfo.LastTimeAttack)
			//{
				//lakeAtkInfo.LastTimeAttack = GameLogic.getInstance().CurServerTime;
				//lakeAtkInfo.FriendLake = new Object();
				//lakeAtkInfo.ListAttack[String(myId)] = 1;
			//}
			//else
			//{
				//lakeAtkInfo.LastTimeAttack = GameLogic.getInstance().CurServerTime;
				//if (lakeAtkInfo.ListAttack[String(myId)])
				//{
					//lakeAtkInfo.ListAttack[String(myId)] += 1;
				//}
				//else
				//{
					//lakeAtkInfo.ListAttack[String(myId)] = 1;
				//}
			//}
			
			// Nếu là cá lính -> effect đánh nhau trừ máu
			if (theirFish is FishSoldier)
			{
				isFinish = false;
				//InitCombatData();
				InitCombatData1();
				myFish.GuiFishStatus.ShowHPBar(myFish, HPMine, MaxHPMine);
				theirFish.GuiFishStatus.ShowHPBar(theirFish as FishSoldier, HPTheirs, MaxHPTheirs);
				GameLogic.getInstance().isAttacking = true;
				
				CombatForReal();
			}
			else
			{
				var sound:Sound = SoundMgr.getInstance().getSound("FightNormal");
				if (sound != null)
				{
					sound.play();
				}
				// Effect khói
				FightEffect();
			}
			
			// Xóa các item hết hạn sử dụng ở cả mảng cá của mình và cá diễn viên
			//UpdateItemAttached();
		}
		
		/**
		 * Thể hiện kịch bản từ server trả về
		 */
		public function CombatForReal1():void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime > LastAtkMine + CooldownMine && curHitMine < data.length && !GameLogic.getInstance().isWinNowByBolt)
			{
				//curHitMine++;
				if (data[curHitMine].Vitality.Defence.ListAtt)
				{
					DmgMine = data[curHitMine].Vitality.Defence.ListAtt[myFish.Id];
				}
				else
				{
					DmgMine = 0;
				}
				hitStatusMine = data[curHitMine].Status.Attack[myFish.Id];
				if (hitStatusMine == HIT_CRIT)
				{
					isCritMine = true;
				}
				Attack(false);
				LastAtkMine = curTime;				
			}
			
			if (curTime > LastAtkTheirs + CooldownTheirs && curHitTheirs < data.length && !GameLogic.getInstance().isWinNowByBolt)
			{
				//curHitTheirs++;
				DmgTheirs = int(curHPMine - data[curHitTheirs].Vitality.Attack[myFish.Id]);
				hitStatusTheirs = data[curHitTheirs].Status.Defence;
				if (hitStatusTheirs == HIT_CRIT)
				{
					isCritTheirs = true;
				}
				Attack(true);
				LastAtkTheirs = curTime;
			}
			
			if ((LastAtkMine < curTime-5 && LastAtkTheirs < curTime - 5) ||  GameLogic.getInstance().isWinNowByBolt)
			{
				if (isFinish)	return;
				isFinish = true;
				GameLogic.getInstance().isWinNowByBolt = false;
				GameLogic.getInstance().isAttacking = false;
				GameLogic.getInstance().user.CurSoldier[0].isReadyToFight = false;
				GameLogic.getInstance().user.CurSoldier[1].isReadyToFight = false;
				FightResult();
			}
		}
		
		public function CombatForReal():void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime > LastAtkMine + CooldownMine && NumAtkMine > 0)
			{
				//trace("so luot crit cua minh: ---------" + NumCritMine);
				if (NumCritMine >= Ultility.RandomNumber(1, NumAtkMine) && NumCritMine > 0)
				{
					isCritMine = true;
					NumCritMine--;
					
				}
				Attack(false);
				LastAtkMine = curTime;
				NumAtkMine--;
			}
			
			if (curTime > LastAtkTheirs + CooldownTheirs && NumAtkTheirs > 0)
			{
				//trace("so luot crit cua ban: -------" + NumCritTheirs);
				if (NumCritTheirs >= Ultility.RandomNumber(1, NumAtkTheirs) && NumCritTheirs > 0)
				{
					isCritTheirs = true;
					NumCritTheirs--;
					
				}
				Attack(true);
				LastAtkTheirs = curTime;
				NumAtkTheirs--;
			}
		}
		
		public function Attack(isMine:Boolean):void
		{
			if (isFinish)	return;
			
			var soundName:String = "Fight";
			if (isMine)
			{
				soundName += (theirFish as FishSoldier).Element;
			}
			else
			{
				soundName += myFish.Element;
			}
			
			var sound:Sound = SoundMgr.getInstance().getSound(soundName);
			if (sound != null)
			{
				sound.play();
			}
			
			var effName:String = "";
			// Add Effect chém gió
			if (isMine)
			{
				var ef:SwfEffect;
				//var arrNameEff:Array;
				if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST || 
					(GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST && 
					(FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_4)))
				{
					if ((theirFish as FishSoldier).EquipmentList.Mask[0])
					{
						effName = "EffWarMask";
					}
					else
					{
						effName = "EffWar" + (theirFish as FishSoldier).Element;
					}
				}
				else
				{
					effName = theirFish.ImgName.replace("Idle", "Attack");
					theirFish.img.visible = false;
				}
				ef = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, effName, null, theirFish.CurPos.x, theirFish.CurPos.y, false, false, null, function():void { HPUpdate(true) });
				if (theirFish.img && theirFish.img.visible)	
					ef.img.rotation = 180;
			}
			else
			{
				if (myFish.EquipmentList.Mask[0])
				{
					effName = "EffWarMask";
				}
				else
				{
					effName = "EffWar" + myFish.Element;
				}
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, effName, null, myFish.CurPos.x, myFish.CurPos.y, false, false, null, function():void { HPUpdate(false) });
				//EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, effName, myFish.CurPos.x, myFish.CurPos.y, false, false, function():void { HPUpdate(false) } );
			}
		}
		
		public function HPUpdate(isAttacked:Boolean):void
		{
			var s:Sprite;
			// Effect trượt
			if (isAttacked)
			{
				switch (hitStatusTheirs)
				{
					case HIT_MISS:
						s = ResMgr.getInstance().GetRes("EffTxtTruot") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, myFish.aboveContent, new Point(0, 0), new Point( -150, 0), new Point( -50, 0), 0.4, 0.3);
						break;
					case HIT_CRIT:
						s = ResMgr.getInstance().GetRes("EffTxtChiMang") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, myFish.aboveContent, new Point(0, 0), new Point( -150, 0), new Point( -50, 0), 0.4, 0.3);
						break;
				}
				if (theirFish.img.visible == false && FishWorldController.GetRound() != Constant.OCEAN_FOREST_ROUND_3 &&
					FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)	
					theirFish.img.visible = true;
			}
			else
			{
				switch (hitStatusMine)
				{
					case HIT_MISS:
						s = ResMgr.getInstance().GetRes("EffTxtTruot") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, (theirFish as FishSoldier).aboveContent, new Point(0, 0), new Point(150, 0), new Point(50, 0), 0.4, 0.3);
						break;
					case HIT_CRIT:
						s = ResMgr.getInstance().GetRes("EffTxtChiMang") as Sprite;
						s.scaleX = s.scaleY = 0.6;
						EffectMgr.getInstance().flyBack(s, (theirFish as FishSoldier).aboveContent, new Point(0, 0), new Point(150, 0), new Point(50, 0), 0.4, 0.3);
						break;
				}
			}
			
			// Trừ máu
			if (isAttacked)
			{//mình bị trừ máu
				if (isCritTheirs)
				{
					HPEffect( -DmgTheirs, myFish, true);
					isCritTheirs = false;
				}
				else
				{
					HPEffect( -DmgTheirs, myFish);
				}
				HPMine -= DmgTheirs;
			}
			else
			{//bạn bị trừ máu
				if (isCritMine)
				{
					HPEffect( -DmgMine, theirFish as FishSoldier, true);
					isCritMine = false;
				}
				else
				{
					HPEffect( -DmgMine, theirFish as FishSoldier);
				}
				HPTheirs -= DmgMine;
			}
			
			if (isAttacked)
			{
				curHitTheirs++;
			}
			else
			{
				curHitMine++;
			}
			
			if (isFinish)	return;
			if (HPMine <= 0 || HPTheirs <= 0 || (curHitMine >= data.length && curHitTheirs >= data.length))
			{
				isFinish = true;
				GameLogic.getInstance().isAttacking = false;
				if(GameLogic.getInstance().user.CurSoldier[0])	GameLogic.getInstance().user.CurSoldier[0].isReadyToFight = false;
				if(GameLogic.getInstance().user.CurSoldier[1])	GameLogic.getInstance().user.CurSoldier[1].isReadyToFight = false;
				FightResult();
				
			}
			//if (theirFish.img.visible == false && isAttacked == true)	
				//theirFish.img.visible = true;
		}
		
		public function FightEffect():void
		{
			AtkMgr();
			AtkMgr();
			AtkMgr();
			AtkMgr();
		}
		
		public function AtkMgr():void
		{
			if (ResultTime < 0 && !isEnd)
			{
				FightResult();
				isEnd = true;
				return;
			}
			if (GameLogic.getInstance().IsWin != 2)
			{
				var prob:Number = Ultility.RandomNumber(1, 2);
				switch (prob)
				{
					case 1:
						HitAtk();
						break;
					case 2:
						MissAtk();
						break;
					default:
						 //do nothing
						break;
				}
			}
			else if (GameLogic.getInstance().IsWin == 2)
			{
				AtkTime = 1;
				ResultTime = 0;
				CritAtk();
				CritAtk();
			}
		}
		
		public function HitAtk(next:int = 0):void
		{
			var child:Sprite = new Sprite();
			var pos:Point = new Point(350, Ultility.RandomNumber(250, 380));
			var d:DisplayObject = ResMgr.getInstance().GetRes("EffFishWarTrung") as DisplayObject;
			d.rotation = Ultility.RandomNumber( -45, 45);
			d.scaleX = d.scaleY = 0.5;
			child.addChild(d);
			if (ResultTime >= 0)
			{
				var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), AtkMgr) as ImgEffectFly;
				eff1.SetInfo(posX, posY, posX + Ultility.RandomNumber(-20 , 20), posY + Ultility.RandomNumber(-20 , 20), 3);
				ResultTime--;
			}
		}
		
		public function MissAtk():void
		{
			var child:Sprite = new Sprite();
			var pos:Point = new Point(350, Ultility.RandomNumber(250, 380));
			var d:DisplayObject = ResMgr.getInstance().GetRes("EffFishWarTruot") as DisplayObject;
			d.rotation = Ultility.RandomNumber( -45, 45);
			d.scaleX = d.scaleY = 0.5;
			child.addChild(d);
			if (ResultTime >= 0)
			{
				var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), AtkMgr) as ImgEffectFly;
				eff1.SetInfo(posX, posY, posX + Ultility.RandomNumber(-20 , 20), posY + Ultility.RandomNumber(-20 , 20), 3);
				ResultTime--;
			}
		}
		
		public function CritAtk():void
		{
			var child:Sprite = new Sprite();
			var pos:Point = new Point(350, Ultility.RandomNumber(250, 380));
			var d:DisplayObject;
			if (NumCombo > 0)
			{
				d = ResMgr.getInstance().GetRes("EffFishWarTrung") as DisplayObject;
				d.rotation = Ultility.RandomNumber( -45, 45);
				child.addChild(d);
				var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null, AtkMgr) as ImgEffectFly;
				eff1.SetInfo(posX, posY, posX + Ultility.RandomNumber(-20 , 20), posY + Ultility.RandomNumber(-20 , 20), 3);
				NumCombo--;
			}
			else if (NumCombo >= -1)
			{
				d = ResMgr.getInstance().GetRes("EffFishWarChiMang") as DisplayObject;
				d.rotation = Ultility.RandomNumber( -45, 45);
				child.addChild(d);
				var efff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null, AtkMgr) as ImgEffectFly;
				efff1.SetInfo(posX, posY, posX + Ultility.RandomNumber(-20 , 20), posY + Ultility.RandomNumber(-20 , 20), 3); 
				NumCombo--;
			}
		}
		
		public function FightResult():void
		{
			if ((AtkTime != 0) && (IsWin != 2) && !GameLogic.getInstance().isWinNowByBolt)
			{
				FightEffect();
				--AtkTime;
			}
			else 
			{
				var et:SwfEffect;
				if ((IsWin == 1) || (IsWin == 2))
				{
					if(LeagueController.getInstance().mode==LeagueController.IN_HOME)
						UpdateFriendsStatus(IsWin + 1);
					et = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishWarWin", null, 420, 300, false, false, null, DropGift);
					//EffectMgr.getInstance().AddBitmapEffect(Constant.GUI_MIN_LAYER, "EffFishWarWin", 420, 300, false, false, DropGift);
				}
				else
				{
					if(LeagueController.getInstance().mode==LeagueController.IN_HOME)
						UpdateFriendsStatus(IsWin + 1);
					et = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishWarLose", null, 420, 300, false, false, null, DropGift);
					//EffectMgr.getInstance().AddBitmapEffect(Constant.GUI_MIN_LAYER, "EffFishWarLose", 420, 300, false, false, DropGift);
				}
				//et.img.scaleX = 1.3;
				//et.img.scaleY = 1.3;
				ResultTime = -1;
				//if (theirFish.img.visible == false)	
					//theirFish.img.visible = true;
			}
			
		}
		
		/**
		 * Hàm xử lý trừ phần thưởng khi thua
		 */
		public function UpdateGiftPenalty():void
		{
			if (IsWin > 0)	return;		// Nếu không thua ko bị phạt
			
			var Penalty:Object = GameLogic.getInstance().FishWarPenalty;
			var s:String;
			var txtFormat:TextFormat;
			var o:Object;
			for (s in Penalty)
			{
				switch (s)
				{
					case "MoneyGet":
						GameLogic.getInstance().user.UpdateUserMoney( -Penalty[s]);
						if (Penalty[s] > 0)
						{
							txtFormat = new TextFormat("Arial", 24, 0xffff00, true);
							txtFormat.align = "center";
							
							o = new Object();
							o.str = "-" + Penalty[s] + " Vàng";
							o.txtFormat = txtFormat;
							o.pos = new Point(0, -50);
							o.parent = myFish;
							o.LastEffectTime = GameLogic.getInstance().CurServerTime;
							GameLogic.getInstance().EffectInFishList.push(o);
							
							// Hiện Pop up
							var textShow:String = Localization.getInstance().getString("FishWarMsg32");
							textShow = textShow.replace("@Value@", Penalty[s] + "");
							GuiMgr.getInstance().GuiMessageBox.ShowOK(textShow, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						}
						break;
					case "RankLost":
						myFish.UpdateKillMarkPoint( -Penalty[s]);
						if (Penalty[s] > 0)
						{
							//var p:Point = new Point(0, -50);
							txtFormat = new TextFormat("Arial", 24, 0x06C417, true);
							txtFormat.align = "center";
							//EffectMgr.getInstance().textFly("-" + Penalty[s] + " chiến công", p, txtFormat, myFish.aboveContent);
							
							o = new Object();
							o.str = "-" + Penalty[s] + " Chiến công";
							o.txtFormat = txtFormat;
							o.pos = new Point(0, -50);
							o.parent = myFish;
							o.LastEffectTime = GameLogic.getInstance().CurServerTime;
							GameLogic.getInstance().EffectInFishList.push(o);
						}
						break;
				}
			}
		}
		
		/**
		 * Quà cáp rơi ra nếu thắng (thua cũng có thể rơi)
		 */ 
		public function DropGift():void
		{
			//Rơi quà thế giới cá
			if(!Ultility.IsInMyFish())
			{
				GameLogic.getInstance().dropAllGiftFishWorld();
				//return;
			}
			//quà sau khi đánh nhau xong trong liên đấu
			else if(LeagueController.getInstance().mode==LeagueController.IN_LEAGUE)
			{
				LeagueMgr.getInstance().completeFight();
			}
			else
			{
				var Result:Array = GameLogic.getInstance().FishWarBonus;
				if (Result.length != 0)
				{
					var objMoneyExp:Object = new Object();
					objMoneyExp["exp"] = 0;
					objMoneyExp["money"] = 0;
					for (var i:int = 0; i < Result.length; i++)
					{
						// Cho quà rơi ra
						var mat:FallingObject;
						var j:int;
						var obj1:Object = Result[i] as Object;
						
						switch (obj1["ItemType"])
						{
							case "Rank":
								myFish.UpdateKillMarkPoint(obj1["Num"]);
								UpdateTheirFishRankPoint(obj1["Num"]);
								if (obj1["Num"] > 0)
								{
									//var p:Point = new Point(0, -50);
									var txtFormat:TextFormat = new TextFormat("Arial", 24, 0x06C417, true);
									txtFormat.align = "center";
									//EffectMgr.getInstance().textFly("+" + obj1["Num"] + " chiến công", p, txtFormat, myFish.aboveContent);
									
									var o:Object = new Object();
									o.str = "+" + obj1["Num"] + " Chiến công";
									o.txtFormat = txtFormat;
									o.pos = new Point(0, -50);
									o.parent = myFish;
									o.LastEffectTime = GameLogic.getInstance().CurServerTime;
									GameLogic.getInstance().EffectInFishList.push(o);
								}
								break;
							case "Exp":
								objMoneyExp["exp"] = obj1["Num"];
								break;
							case "Money":
								objMoneyExp["money"] = obj1["Num"];
								// Update số gold mất vào con cá
								UpdateMoneyAttacked(obj1["Num"]);
								break;
							case "Gem":
								//AddGemListObjShare(obj1);
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj1["ItemType"] + "_" + obj1["Element"] + "_" + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								
								// Cập nhật vào kho
								GuiMgr.getInstance().GuiStore.UpdateStore(obj1.ItemType + "$" + obj1.Element + "$" + obj1.ItemId, obj1.Day, obj1.Num);
								break;
							case "Draft":
							case "Paper":
							case "GoatSkin":
							case "Blessing":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj1["ItemType"] + "_" + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								
								// Cập nhật vào kho
								GuiMgr.getInstance().GuiStore.UpdateStore(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
								break;
							case "Material":
							case "EnergyItem":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								
								// Cập nhật vào kho
								if (GuiMgr.getInstance().GuiStore.IsVisible)
								{
									GuiMgr.getInstance().GuiStore.UpdateStore(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
								}
								else
								{
									GameLogic.getInstance().user.UpdateStockThing(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
								}
								break;
							case "ItemCollection":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									
									mat.getDesToFly = function():Point
									{
										var pos:Point = GuiMgr.getInstance().guiAnoucementCollection.getPosById(obj1["ItemId"]);
										return pos;
									}
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								
								//Hiện thông báo hoàn thành bộ sưu tập
								GameLogic.getInstance().checkAnoucementCollection(obj1["ItemId"]);
								GuiMgr.getInstance().GuiStore.UpdateStore(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
								break;
							case "Event_8_3_Flower":
								//cập nhật vào kho
								GameLogic.getInstance().user.UpdateStockThing(obj1["ItemType"], 
																				obj1["ItemId"], 
																				obj1["Num"]);
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
							break;
							case "Arrow":
								//cập nhật vào kho
								GameLogic.getInstance().user.UpdateStockThing(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "GUIGameEventMidle8_" + obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
							break;
							case "Event":
								for (var jj:String in obj1)
								{
									var obj2:Object = obj1[jj];
									//cập nhật vào kho
									GameLogic.getInstance().user.UpdateStockThing(obj2["ItemType"], obj2["ItemId"], obj2["Num"]);
									for (j = 0; j < obj2["Num"]; j++)
									{
										mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "GUIGameEventMidle8_" + obj2["ItemType"] + obj2["ItemId"], posX, posY);
										mat.ItemType = obj2["ItemType"];
										mat.ItemId = obj2["ItemId"];
										mat.setWaitingTime(3);
										mat.getDesToFly = function():Point
										{
											var pos1:Point = GuiMgr.getInstance().GuiMainFishWorld.btnMapOcean.GetPos();
											return pos1;
										}
										GameLogic.getInstance().user.fallingObjArr.push(mat);
									}
								}
							break;
							case "BirthDayItem":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								BirthDayItemMgr.getInstance().setNum(obj1["ItemId"],obj1["Num"]);
							break;
							case "IceCreamItem":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventIceCream_Item" + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
							break;
							case "Island_Item":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "IslandItem" + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								GuiMgr.getInstance().GuiStore.UpdateStore(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
							break;
							case "Balls":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Ic_" + obj1["ItemId"] + "Ball", posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
							break;
							case "HalItem":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventHalloween_" + obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								HalloweenMgr.getInstance().updateRockStore(obj1["ItemId"], obj1["Num"]);
								break;
							//case "ColPItem":
							case "Candy":
							//case "PaperBurn":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventNoel_" + obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								//GuiMgr.getInstance().guiFrontEvent.updateNumItemEvent(obj1["ItemType"], obj1["Num"]);
								EventSvc.getInstance().updateItem(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
							break;
							case "Ticket":
								for (j = 0; j < obj1["Num"]; j++)
								{
									mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventLuckyMachine_" + obj1["ItemType"] + obj1["ItemId"], posX, posY);
									mat.ItemType = obj1["ItemType"];
									mat.ItemId = obj1["ItemId"];
									mat.setWaitingTime(3);
									GameLogic.getInstance().user.fallingObjArr.push(mat);
								}
								EventLuckyMachineMgr.getInstance().updateTicket(obj1["Num"]);
							break;
							
						}
					}
					
					EffectMgr.getInstance().fallExpMoney(objMoneyExp["exp"], objMoneyExp["money"], new Point (posX, posY), 1, 50);
				}
			}
			
			// Nếu nó thua thì trừ tiền + rank... (server trả về)
			UpdateGiftPenalty();
			UpdateOtherInfo();
			
			//  Nếu như có sự kiện ngư chiến -> cập nhật thông tin số trận đánh liên tục
			if (GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"] && theirFish is FishSoldier)
			{
				var obj:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"];
				obj.WinTotal += 1;
			}
		}
		
		public function UpdateTheirFishRankPoint(num:int):void
		{
			var fs:FishSoldier = theirFish as FishSoldier;
			
			if (!fs.CheckProtected())
			{
				fs.UpdateKillMarkPoint( -num);
			
				// Add Effect
				var txtFormat:TextFormat = new TextFormat("Arial", 24, 0x06C417, true);
				txtFormat.align = "center";
				var o:Object = new Object();
				o.str = "-" + num + " Chiến công";
				o.txtFormat = txtFormat;
				o.pos = new Point(0, -50);
				o.parent = fs;
				o.LastEffectTime = GameLogic.getInstance().CurServerTime;
				GameLogic.getInstance().EffectInFishList.push(o);
			}
			
			fs.LastTimeDefendFail = GameLogic.getInstance().CurServerTime;
			fs.NumDefendFail = fs.NumDefendFail +1;
		}
		
		/**
		 * Update một số các thông số khác
		 */
		public function UpdateOtherInfo():void
		{
			GameLogic.getInstance().isFighting = false;
			// Nếu có quest đánh nhau thì show kết quả
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);		
				questArr.splice(0, 1);
			}
				
			if (theirFish is FishSoldier)
			{
				if ((theirFish as FishSoldier).OnLoadResCompleteFunction != null)
				{
					(theirFish as FishSoldier).OnLoadResCompleteFunction = null;
				}
			}
			
			if (GuiMgr.getInstance().GuiFriends.IsVisible)
			{
				GuiMgr.getInstance().GuiFriends.ShowFriend(GuiMgr.getInstance().GuiFriends.page);
			}
			
			// Xóa các item hết hạn sử dụng ở cả mảng cá của mình và cá diễn viên
			UpdateItemAttached();
			// Update hiển thị
			UpdateGemEffectVisibility();
			
			FishChatting(IsWin);
			
			//IsWin = -1;

			GameLogic.getInstance().isAttacking = false;
			GameLogic.getInstance().fw.Destructor();
			GameLogic.getInstance().fw = null;
			theirFish.img.visible = true;
			theirFish.isInRightSide = false;
			theirFish.aboveContent.visible = true;
			myFish.img.visible = true;
			myFish.aboveContent.visible = true;
			if(myFish.GuiFishStatus.img)
			myFish.GuiFishStatus.img.visible = true;
			myFish.isInRightSide = false;
			myFish.isReadyToFight = false;
			
			if(Ultility.IsInMyFish())	// Đánh ở nhà bạn
			{
				if (myFish.Health <= 0)
					myFish.isInRightSide = true;
				GuiMgr.getInstance().GuiInfoFishWar.HideDisableScreen(true);
				if (GuiMgr.getInstance().GuiMain) 
				{
					var num:int = parseInt(GuiMgr.getInstance().GuiMain.txtCombatCount.text);
					if (num <= 0)
					{
						myFish.isInRightSide = true;
						theirFish.isInRightSide = true;
						
						// Nếu ko đánh dc nữa thì hòa bình
						GameController.getInstance().UseTool("Peace");
					}
					else
					{
						// Nếu còn đánh dc tiếp
						myFish.SwimTo(myFish.standbyPos.x, myFish.standbyPos.y, 10);
						//theirFish.SwimTo(Constant.MAX_WIDTH / 2 + 300, theirFish.img.y, 10);
						
						if (theirFish.FishType != Fish.FISHTYPE_SOLDIER)
						{
							theirFish.SwimTo(Constant.MAX_WIDTH / 2 + 300, theirFish.img.y, 10);
						}
						else
						{
							theirFish.SwimTo((theirFish as FishSoldier).standbyPos.x, (theirFish as FishSoldier).standbyPos.y, 10);
							(theirFish as FishSoldier).isReadyToFight = false;
						}
					}
				}
				
				// Trừ sức khỏe cá
				if(LeagueController.getInstance().mode==LeagueController.IN_HOME)
					UpdateFishesHealth();				
				
				// Cập nhật đồ đạc
				UpdateItemDurability();
				
				myFish.GuiFishStatus.ShowHPBar(myFish, 0, 0, false);
				if (theirFish is FishSoldier)
				theirFish.GuiFishStatus.ShowHPBar(theirFish as FishSoldier, 0, 0, false);
			}
			else	// Đánh ở thế giới cá
			{
				FishWorldController.CheckStopEffEnvironment();
				myFish.SwimTo(myFish.standbyPos.x, myFish.standbyPos.y, 10);
				
				// Trừ sức khỏe cá
				UpdateFishesHealth();
				myFish.GuiFishStatus.ShowHPBar(myFish, 0, 0, false);
				
				var arrThicket:Array;
				var arrMonster:Array;
				var i:int = 0;
				if (IsWin > 0)	
				{
					if (!Ultility.IsKillBoss()) 
					{
						if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)
						{
							switch (FishWorldController.GetRound()) 
							{
								case Constant.OCEAN_FOREST_ROUND_1:
								{
									// Cập nhật state của game để xác định trạng thái là thắng hay thua
									if((theirFish as FishSoldier).isSubBoss == false)
									{
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS_WIN);
										GuiMgr.getInstance().GuiMapOcean.arrListOcean[FishWorldController.GetSeaId() - 1].Monster[
														FishWorldController.GetRound().toString()] = new Object();
									}
									else 
									{
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS);
									}
									theirFish.SwimTo((theirFish as FishSoldier).standbyPos.x, (theirFish as FishSoldier).standbyPos.y, 7);
									EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, theirFish.CurPos.x - 100, theirFish.CurPos.y);
									// Nếu hết bụi rậm rồi thì quay lại bản đồ chính và hiện GUI chúc mừng bạn nhận được quà lên
									
									break;
								}
								case Constant.OCEAN_FOREST_ROUND_2:
								{
									//theirFish.SwimTo((theirFish as FishSoldier).standbyPos.x, (theirFish as FishSoldier).standbyPos.y, 7);
									(theirFish as FishSoldier).UpdateRound2ForestSeaWin();
									GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS_WIN);
									EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, 
											(theirFish as FishSoldier).standbyPos.x - 100, (theirFish as FishSoldier).standbyPos.y);
									break;
								}
								case Constant.OCEAN_FOREST_ROUND_3:
								{
									var arrSerialAttack:Array = GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack;
									for (var j:int = 0; j < arrSerialAttack.length; ) 
									{
										if (arrSerialAttack[0] == 0)
										{
											arrSerialAttack.splice(0, 1);
										}
										else
										{
											break;
										}
									}
									if (arrSerialAttack.indexOf((theirFish as FishSoldier).Element) <= 0
										|| GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack.length <= 0)
									{
										(theirFish as FishSoldier).UpdateRound3ForestSeaWin();
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS_WIN);
									}
									else
									{
										(theirFish as FishSoldier).UpdateRound3ForestSea();
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS);
									}
									break;
								}
								case Constant.OCEAN_FOREST_ROUND_4:
								{
									break;
								}
							}
						}
						else
						{
							theirFish.Clear();
							theirFish.Destructor();
							GuiMgr.getInstance().GuiMapOcean.UpdateFishSoldier(theirFish as FishSoldier);
						}
					}
					else
					{
						GuiMgr.getInstance().GuiMapOcean.UpdateFishSoldier(theirFish as FishSoldier);
						switch (FishWorldController.GetSeaId()) 
						{
							case Constant.OCEAN_METAL:
								var subBossMetal:SubBossMetal = theirFish as SubBossMetal;
								subBossMetal.SetMovingState(Fish.FS_PRE_DEAD);
							break;
							case Constant.OCEAN_ICE:
								var subBossIce:SubBossIce = theirFish as SubBossIce;
								subBossIce.SetMovingState(Fish.FS_PRE_DEAD);
							break;
						}
						var indexTheirFish:int = GameLogic.getInstance().user.FishSoldierArr.indexOf(theirFish);
						GameLogic.getInstance().user.FishSoldierArr.splice(indexTheirFish, 1);
					}
					var index:int = GameLogic.getInstance().user.FishSoldierArr.indexOf(theirFish);
					GameLogic.getInstance().user.FishSoldierArr.splice(index, 1);
					if(FishWorldController.GetSeaId() != Constant.OCEAN_FOREST)
					{
						GuiMgr.getInstance().GuiMapOcean.UpdateFishSoldier(theirFish as FishSoldier);
					}
					//myFish.Health -= 1;
					//myFish.Vitality = MaxHPMine;
					if(myFish.Health > 0)
					{
						myFish.isReadyToFight = true;
					}
					else
					{
						myFish.isReadyToFight = false;
					}
					// Kết thúc vòng
					if ((FishWorldController.GetSeaId() != Constant.OCEAN_FOREST) && 
						(GameLogic.getInstance().user.FishSoldierArr == null || GameLogic.getInstance().user.FishSoldierArr.length == 0))
					{
						if(FishWorldController.GetRound() + 1 <= 4)
						{
							NewRound();
							var isRoundBoss:Boolean = false;
							//FishWorldController.SetRound(FishWorldController.GetRound() + 1);
							var arrChild:Array = new Array();
							if(FishWorldController.GetRound() < 4)
							{
								arrChild.push("ImgNumberRound" + FishWorldController.GetRound());
							}
							else
							{
								arrChild.push("ImgNumberRoundBoss");
								isRoundBoss = true;
							}
							EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffRoundWorld", arrChild, Constant.STAGE_WIDTH / 2 + 50, 150, false, false, null, 
									//function():void{GuiMgr.getInstance().GuiMainFishWorld.ProcessToWar(true)});
									function():void{KillBoss(isRoundBoss)});
						}
					}
				}
				else 
				{
					if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)
					{
						GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS);
						switch (FishWorldController.GetRound()) 
						{
							case Constant.SEA_ROUND_1:
								(theirFish as FishSoldier).UpdateRound1ForestSea();
							break;
							case Constant.SEA_ROUND_2:
								(theirFish as FishSoldier).UpdateRound2ForestSea();
							break;
							case Constant.SEA_ROUND_3:
									var arrSerialAttack1:Array = GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack;
									for (var j1:int = 0; j1 < arrSerialAttack1.length; ) 
									{
										if (arrSerialAttack1[0] == 0)
										{
											arrSerialAttack1.splice(0, 1);
										}
										else
										{
											break;
										}
									}
									if ((theirFish as FishSoldier).Element == arrSerialAttack1[0])
									{
										(theirFish as FishSoldier).UpdateRound3ForestSea(false);
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS);
									}
									else
									{
										(theirFish as FishSoldier).UpdateRound3ForestSea(false);
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS);
									}
									break;
									//theirFish.SwimTo((theirFish as FishSoldier).standbyPos.x, (theirFish as FishSoldier).standbyPos.y, 10);
							break;
						}
					}
					else 
					{
						if (theirFish is SubBossIce)
						{
							(theirFish as SubBossIce).isPreComeBack = true;
						}
						theirFish.SwimTo((theirFish as FishSoldier).standbyPos.x, (theirFish as FishSoldier).standbyPos.y, 10);
					}
					(theirFish as FishSoldier).isReadyToFight = false;
					if ((theirFish as FishSoldier).GuiFishStatus.IsVisible)	
						(theirFish as FishSoldier).GuiFishStatus.ShowHPBar(theirFish as FishSoldier, 0, 0, false);
				}
				// Cập nhật đồ đạc
				UpdateItemDurability();	
				
				//myFish.Vitality = MaxHPMine;
				if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
				FishWorldController.CheckShowEffEnvironment();
			}
			
			// Check xem còn đồ cần gia hạn không, nếu không thì ẩn cái nút đi
			if(GuiMgr.getInstance().GuiMain)
			GuiMgr.getInstance().GuiMain.CheckButtonExtendVisible(GameLogic.getInstance().user.IsViewer());
			
			IsWin = -1;
		}
		
		public function KillBoss(isRoundBoss:Boolean):void 
		{			
			if(isRoundBoss)
			{
				var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
				GameLogic.getInstance().SetMode(GameMode.GAMEMODE_WAR);
				GuiMgr.getInstance().GuiMainFishWorld.ProcessToWar();
				
			}
			else 
			{
				GuiMgr.getInstance().GuiMainFishWorld.ProcessToWar(true);
			}
		}
		
		private function NewRound():void 
		{
			if (FishWorldController.waveEmit)
			{
				FishWorldController.waveEmit.destroy();
				FishWorldController.waveEmit = null;
			}
			// Xóa những con cá đã hiện ở round trước đi.
			var i:int = 0;
			GuiMgr.getInstance().GuiInfoWarInWorld.canShowImgEnviroment = true;
			GameLogic.getInstance().ShowFish();
			for (i = 0; i < GameLogic.getInstance().user.FishArr.length; i++)
			{
				var fish:Fish = GameLogic.getInstance().user.FishArr[i] as Fish;
				fish.Destructor();
			}
			GameLogic.getInstance().user.FishArr.splice(0, GameLogic.getInstance().user.FishArr.length);
			
			GuiMgr.getInstance().GuiMapOcean.initFish(FishWorldController.GetSeaId(), true);
			GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
			GuiMgr.getInstance().GuiInfoWarInWorld.Hide();
			GameLogic.getInstance().SetMode(GameMode.GAMEMODE_NORMAL);
			
			// Xóa mảng cá lính đi của mình đi xâm chiếm
			var fs:FishSoldier;
			for (i = 0; i < GameLogic.getInstance().user.FishSoldierActorMine.length; i++)
			{
				fs = GameLogic.getInstance().user.FishSoldierActorMine[i] as FishSoldier;
				fs.Destructor();
			}
			GameLogic.getInstance().user.FishSoldierActorMine.splice(0, GameLogic.getInstance().user.FishSoldierActorMine.length);
			//GameLogic.getInstance().
			if(GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
			IsWin = -1;
		}
		
		/**
		 * Cập nhật sức khỏe của cả 2 con cá
		 * Effect trừ sức khỏe cá mình
		 */
		public function UpdateFishesHealth():void
		{
			var i:int;
			var str:String;
			var curLakeSoldier:Array = GameLogic.getInstance().user.FishSoldierArr;				// Cá lính nhà bạn (hồ hiện tại)
			var fs:FishSoldier;
			
			for (i = 0; i < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; i++)
			{
				fs = GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i] as FishSoldier;
				if (fs.Id == myFish.Id)
				{
					break;
				}
			}
			
			var subHealth:Number;
			if (IsWin == 0)
			{
				// Nếu như thua: Cá mình bị trừ 2*AttackPoint, cá bạn ko bị trừ HP
				if(Ultility.IsInMyFish())
				{
					subHealth = -myFish.AttackPoint * 2;
				}
				else 
				{
					subHealth = -myFish.MaxHealth / 2;
					GuiMgr.getInstance().GuiRegenerating.initGUI([fs], (theirFish as FishSoldier).isSubBoss);
				}
				myFish.UpdateHealth(subHealth);
				HealthEffect(subHealth, myFish);
				fs.UpdateHealth(subHealth);
			}
			else
			{
				// Nếu như thắng: Cá mình bị trừ AttackPoint, cá bạn bị trừ AttackPoint
				subHealth = -myFish.AttackPoint;
				myFish.UpdateHealth(subHealth);
				HealthEffect(subHealth, myFish);
				fs.UpdateHealth(subHealth);
			}
		}
		
		public static function RemoveFishSoldierInWorld(fs:FishSoldier, isReChooseFish:Boolean = true):void 
		{
			if (Ultility.IsInMyFish())		return;
			//if (fs.Health < fs.AttackPoint * 2)
			{
				var j:int = 0;
				var arrMyFishSoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
				for (j = 0; j < arrMyFishSoldier.length; j++) 
				{
					if (fs.Id == arrMyFishSoldier[j].Id)
					{
						(arrMyFishSoldier[j] as FishSoldier).Health = fs.Health;
						fs.isChoose = false;
						(arrMyFishSoldier[j] as FishSoldier).isChoose = false;
						break;
					}
				}
				
				var arrFishSoldierActorMine:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				for (j = 0; j < arrFishSoldierActorMine.length; j++) 
				{
					if (fs.Id == arrFishSoldierActorMine[j].Id)
					{
						arrFishSoldierActorMine[j].Clear();
						arrFishSoldierActorMine.splice(j, 1);
						//haveFsRemove = true;
						break;
					}
				}
				if (GameLogic.getInstance().user.FishSoldierActorMine.length == 0)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg13"));
				}
				else
				{
					var next:FishSoldier = FishSoldier.FindBestSoldier(GameLogic.getInstance().user.FishSoldierActorMine, true);
					GameLogic.getInstance().user.CurSoldier[0] = next;
					if(next)	next.isChoose = true;
				}
			}
		}
		
		public function HPEffect(num:int, fish:FishSoldier, isCrit:Boolean = false):void
		{
			//HiepNM2 check trường hợp đối với liên đấu.
			//if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			//{
				//thực hiện trừ máu vào thanh progress bar ở phía trên.
				//var isMe:Boolean = fish.isActor == FishSoldier.ACTOR_MINE ? true : false;
				//var strMe:String = isMe ? "Tôi" : "Hắn";
				//trace("trừ " + num + " máu của " + strMe);
				//LeagueInterface.getInstance().updatePrgBlood(num, isMe);
				//return;
			//}
			var curHP:int;
			var HP:int;
			if (fish.isActor == FishSoldier.ACTOR_MINE)
			{
				curHP = curHPMine + num;
				curHPMine += num;
				//HP = HPMine;
				HP = MaxHPMine;
			}
			else
			{
				curHP = curHPTheirs + num;
				curHPTheirs += num;
				//HP = HPTheirs;
				HP = MaxHPTheirs;
			}
			
			if(fish.GuiFishStatus.IsVisible && fish.GuiFishStatus.prgHP && fish.GuiFishStatus.prgHP.img)
			{
				
				GameLogic.getInstance().AddPrgToProcess(fish.GuiFishStatus.prgHP, curHP / HP, Constant.TYPE_PRG_HP);
				//trace(curHP, HP);
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
			
			//txtFormat.bold = true;
			//txtFormat.align = "left";
			//txtFormat.font = "Arial";
			//child.addChild(Ultility.CreateSpriteText(str, txtFormat, 6, 0, false));		
//
			//var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, fish.GuiFishStatus.img) as ImgEffectFly;
			//var HPBar:ProgressBar = fish.GuiFishStatus.GetProgress(GUIFishStatus.GUI_FISHINFO_HP);
			//eff.SetInfo(HPBar.img.x, HPBar.img.y + 90, HPBar.img.x, HPBar.img.y + 60, 3);
			
			//var p:Point = new Point(0, -50);
			//EffectMgr.getInstance().textFly("-" + str + " máu", p, null, fish.aboveContent);
			
			var o:Object = new Object();
			o.str = str;
			o.txtFormat = txtFormat;
			o.pos = new Point(0, -100);
			o.parent = fish;
			o.LastEffectTime = GameLogic.getInstance().CurServerTime;
			GameLogic.getInstance().EffectInFishList.push(o);
			/*tru mau trong lien dau*/
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				//thực hiện trừ máu vào thanh progress bar ở phía trên.
				var isMe:Boolean = fish.isActor == FishSoldier.ACTOR_MINE ? true : false;

				LeagueInterface.getInstance().updatePrgBlood2(isMe, curHP, HP);
				//GameLogic.getInstance().AddPrgToProcess(fish.GuiFishStatus.prgHP, curHP / HP, Constant.TYPE_PRG_HP);
			}
		}
		
		/**
		 * Effect trừ HP cá
		 * @param	num	
		 */
		public function HealthEffect(num:int, fish:FishSoldier):void
		{
			var o:Object = new Object();
			o.str = num + " Sức khỏe";
			o.txtFormat = null;
			o.pos = new Point(0, -50);
			o.parent = fish;
			o.LastEffectTime = GameLogic.getInstance().CurServerTime;
			GameLogic.getInstance().EffectInFishList.push(o);
			
			//var p:Point = new Point(0, -50);
			//EffectMgr.getInstance().textFly("-" + num + " Sức khỏe", p, null, fish.aboveContent);
			//-------------
			//var child:Sprite = new Sprite();
			//var str:String = num.toString();
			//var txtFormat:TextFormat = new TextFormat(null, 26, 0xffff00);
			//txtFormat.bold = true;
			//txtFormat.align = "left";
			//txtFormat.font = "Arial";
			//child.addChild(Ultility.CreateSpriteText(str, txtFormat, 6, 0, false));		
//
			//var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, fish.aboveContent) as ImgEffectFly;
			//eff.SetInfo(0, 0, 0, 0 + 30, 3);
		}
		
		/**
		 * Lảm nhảm sau khi có kết quả
		 * @param	IsWin
		 */
		public function FishChatting(IsWin:int):void
		{
			var winner:Fish;
			var loser:Fish;
			if (IsWin <= 0)
			{
				winner = theirFish;
				loser = myFish;
			}
			else
			{
				winner = myFish;
				loser = theirFish;
			}
			
			winner.Chatting(Constant.CHAT_WIN, 3000, 3);
			loser.Chatting(Constant.CHAT_LOSE, 3000, 3);
		}
		
		/**
		 * Cập nhật thông tin bạn bè (đánh thắng thua)
		 */
		public function UpdateFriendsStatus(isWin:int):void
		{
			var o:Object = GameLogic.getInstance().user.GetMyInfo().Avatar;
			if (o == null)
			o = new Object();
			o[GameLogic.getInstance().user.Id] = isWin;
		}
		
		public function UpdateItemAttached():void
		{
			var i:int;
			var s:String;
			for (i = myFish.BuffItem.length - 1; i >= 0; i--)
			{
				if (myFish.BuffItem[i].Turn > 1)
				{
					myFish.BuffItem[i].Turn -= 1;
				}
				else
				{
					myFish.BuffItem.splice(i, 1);
				}
			}
			
			// Tìm con cá lính trong mySoldierARr tương ứng
			for (i = 0; i < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; i++)
			{
				fishSoldier = GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i];
				if (fishSoldier.Id == myFish.Id)
				{
					//fishSoldier.BuffItem == myFish.BuffItem;
					break;
				}
			}
			
			// Cập nhật các gem đang đc buff trong cá mình và cá diễn viên
			// Cá mình
			for (s in myFish.GemList)
			{
				if(myFish.GemList[s] && myFish.GemList[s][0])
				{
					if (myFish.GemList[s][0].Turn == 1)
					{
						delete(myFish.GemList[s]);
						//delete(fishSoldier.GemList[s]);
					}
					else
					{
						myFish.GemList[s][0].Turn -= 1;
						//fishSoldier.GemList[s][0].Turn = myFish.GemList[s][0].Turn;
					}				
				}
			}
			
			if (myFish.UserBuff["Element"])
			{
				if (myFish.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)])
				{
					delete(myFish.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)]);
				}
				
				for (s in myFish.UserBuff["Elements"])
				{
					if (myFish.UserBuff["Elements"][s][GameLogic.getInstance().user.GetMyInfo().Id])
					{
						delete(myFish.UserBuff["Elements"][s][GameLogic.getInstance().user.GetMyInfo().Id]);
					}
				}
			}				
			
			// Nếu hết các gem buff thì hủy aura đi, nếu hết 1 aura thì thay bằng aura của gem khác
			
			
			// Cập nhật lại thông số
			//myFish.UpdateCombatSkill();
			
			// Cá họ
			if (theirFish.FishType == Fish.FISHTYPE_SOLDIER)
			{
				var tfish:FishSoldier = theirFish as FishSoldier;
				for (s in tfish.GemList)
				{
					if (tfish.GemList[s][0])
					{
						if (tfish.GemList[s][0].Turn == 1)
						{
							delete(tfish.GemList[s]);
						}
						else
						{
							tfish.GemList[s][0].Turn -= 1;
						}
					}
				}
			
				if (tfish.UserBuff && tfish.UserBuff["Elements"])
				{
					if (tfish.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)])
					{
						delete(tfish.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)]);
					}
				}
				
				if (tfish.BuffItem)
				{
					for (i = tfish.BuffItem.length - 1; i >= 0; i--)
					{
						if (tfish.BuffItem[i].Turn > 1)
						{
							tfish.BuffItem[i].Turn -= 1;
						}
						else
						{
							tfish.BuffItem.splice(i, 1);
						}
					}
				}
				
				//if (tfish.isActor == FishSoldier.ACTOR_THEIRS)
				//{
					//for (i = 0; i < GameLogic.getInstance().user.FishSoldierAllArr.length; i++)
					//{
						//var f:FishSoldier = GameLogic.getInstance().user.FishSoldierAllArr[i] as FishSoldier;
						//if (f.Id == tfish.Id)
						//{
							//for (s in f.GemList)
							//{
								//if (tfish.GemList[s][0])
								//{
									//if (f.GemList[s][0].Turn == 1)
									//{
										//delete(f.GemList[s]);
									//}
									//else
									//{
										//f.GemList[s][0].Turn -= 1;
									//}
								//}
							//}
							//if (f.UserBuff["Elements"])
							//{
								//if (f.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)])
								//{
									//delete(f.UserBuff["Elements"][String(FishSoldier.ELEMENT_WOOD)]);
								//}
							//}
							//
							//for (i = f.BuffItem.length - 1; i >= 0; i--)
							//{
								//if (f.BuffItem[i].Turn > 1)
								//{
									//f.BuffItem[i].Turn -= 1;
								//}
								//else
								//{
									//f.BuffItem.splice(i, 1);
								//}
							//}
							//break;
						//}
					//}
				//}
			}
		}
		
		public function UpdateGemEffectVisibility():void
		{
			if (myFish.GemEffect)
			{
				myFish.aboveContent.removeChild(myFish.GemEffect);
				myFish.GemEffect = null;
				myFish.addGemEffect();
			}
			
			if (theirFish is FishSoldier)
			{
				var fs:FishSoldier = theirFish as FishSoldier;
				if (fs.GemEffect)
				{
					fs.aboveContent.removeChild(fs.GemEffect);
					fs.GemEffect = null;
					fs.addGemEffect();
				}
			}
		}
		
		private function UpdateMoneyAttacked(num:int):void
		{
			if (theirFish is FishSoldier)
			{
				var theirFList:Array = GameLogic.getInstance().user.GetFishArr();
				for (var i:int = 0; i < theirFList.length; i++)
				{
					var cfg:Object = ConfigJSON.getInstance().getItemInfo("Fish", theirFList[i].FishTypeId);
					var trustPrice:int = cfg.TrustPrice;
					
					var thisTotal:int = trustPrice * Constant.MAX_PERCENT_GOLD_CAN_GET / 100;
					var thisLeft:int = thisTotal - theirFList[i].MoneyAttacked;
					thisLeft = Math.max(thisLeft, 0);
					
					var MoneyLost:int = Math.ceil(Number(myFish.Damage / 1000) * myFish.Rate * trustPrice);
					if (thisLeft < MoneyLost)
					{
						MoneyLost = thisLeft;
					}
					trace(MoneyLost);
					theirFList[i].MoneyAttacked += MoneyLost;
				}
			}
			else
			{
				theirFish.MoneyAttacked += num;
			}
		}
		
		public function UpdateItemDurability():void
		{
			var i:int;
			var mySoldierInfo:FishSoldier;		// Con cá trong mảng mysoldierarr;
			var theirSoldierInfo:FishSoldier;	// Con cá trong mảng FishSoldierAllArr;
			var mySoldierArr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var theirSoldierArr:Array = GameLogic.getInstance().user.FishSoldierAllArr;
			
			var cfg:Object = ConfigJSON.getInstance().GetItemList("Param");
			var dur:int = cfg.EquipmentDurability;
			
			// Lấy con cá tương ứng ở mảng MySoldierArr
			for (i = 0; i < mySoldierArr.length; i++)
			{
				if (myFish.Id == mySoldierArr[i].Id)
				{
					mySoldierInfo = mySoldierArr[i];
					break;
				}
			}
			
			var j:int;
			// Cập nhật ở cá diễn viên của mình
			for (var s:String in myFish.EquipmentList)
			{
				if (s != "Mask")
				for (j = 0; j < myFish.EquipmentList[s].length; j++)
				{
					if (myFish.EquipmentList[s][j])
					{
						var eq:FishEquipment = myFish.EquipmentList[s][j];
						eq.UpdateDurability( -1 / dur);
						//mySoldierInfo.EquipmentList[s][j].UpdateDurability( -1 / dur);
					}
				}
			}
			
			if (theirFish is FishSoldier)
			{
				var fs:FishSoldier = theirFish as FishSoldier;
				
				// Lấy con cá tương ứng ở mảng FishSoldierAllArr
				if (fs.isActor != FishSoldier.ACTOR_THEIRS)
				{
					for (i = 0; i < theirSoldierArr.length; i++)
					{
						if (fs.Id == theirSoldierArr[i].Id)
						{
							theirSoldierInfo = theirSoldierArr[i];
							break;
						}
					}
				}
				
				for (s in fs.EquipmentList)
				{
					if (s != "Mask")
					for (j = 0; j < fs.EquipmentList[s].length; j++)
					{
						if (fs.EquipmentList[s][j])
						{
							var eq1:FishEquipment = fs.EquipmentList[s][j];
							eq1.UpdateDurability( -1 / dur);
							//if (theirSoldierInfo && theirSoldierInfo.EquipmentList 
								//&& theirSoldierInfo.EquipmentList[s] && theirSoldierInfo.EquipmentList[s][j])
							//{
								//theirSoldierInfo.EquipmentList[s][j].UpdateDurability( -1 / dur);
							//}
						}
					}
				}
			}
		}
	}

}