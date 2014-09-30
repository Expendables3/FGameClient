package Logic 
{
	import adobe.utils.ProductManager;
	import com.adobe.utils.IntUtil;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.Knob;
	import com.flashdynamix.utils.SWFProfiler;
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.TweenMax;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.EventMagicPotions.NetworkPacket.UseHerbPotion;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.FishEquipmentMask;
	import GUI.FishWar.FishWar;
	import GUI.FishWar.FishWings;
	import GUI.FishWar.GUIChooseEquipment;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.ForestWorld.Thicket;
	import GUI.FishWorld.GUIFishWarBoss;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import GUI.GUIFishStatus;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendGetBonusSoldier;
	import NetworkPacket.PacketSend.SendGetDailyBonus;
	import NetworkPacket.PacketSend.SendLevelUpSoldier;
	import NetworkPacket.PacketSend.SendUpdateExpiredSoldier;
	import NetworkPacket.PacketSend.SendUseGem;
	import NetworkPacket.PacketSend.SendUseItemSoldier;
	/**
	 * Lớp cá bộ đội dùng để chọi
	 * @author longpt
	 */
	public class FishSoldier extends Fish 
	{
		private var txtFieldName:TextField;
		
		public static const ELEMENT_NONE:int = 0;
		public static const ELEMENT_METAL:int = 1;
		public static const ELEMENT_WOOD:int = 2;
		public static const ELEMENT_EARTH:int = 3;
		public static const ELEMENT_WATER:int = 4;
		public static const ELEMENT_FIRE:int = 5;
		
		public static const EFFECT_ITEM:int = 1;
		public static const EFFECT_GEM:int = 2;
		
		public static const MAX_BUFF_WOOD:int = 3;
		
		public static const ACTOR_NONE:int = 0;
		public static const ACTOR_MINE:int = 1;
		public static const ACTOR_THEIRS:int = 2;
		
		public static const SOLDIER_TYPE_GIFT:int = 3;
		public static const SOLDIER_TYPE_HIRE:int = 2;
		public static const SOLDIER_TYPE_MIX:int = 1;
		
		public static const LON_BINHBET:int = 1;
		public static const LON_BINHNHI:int = 2;
		public static const LON_BINHNHAT:int = 3;
		public static const LON_HASI:int = 4;
		public static const LON_TRUNGSI:int = 5;
		public static const LON_THUONGSI:int = 6;
		
		public static const WAR:String = "War";
		public static const WEAK:String = "Weak";
		public static const REWARD:String = "Reward";
		public static const REVIVE:String = "Stun";
		public static const DEAD:String = "Dead";	
		
		public static const STATUS_INSTORE:int = 0;
		public static const STATUS_HEALTHY:int = 1;
		public static const STATUS_REVIVE:int = 2;
		public static const STATUS_DEAD:int = 3;
		
		public static const EquipListName:Array = ["Helmet", "Body", "Weapon"];
		
		// Các thuộc tính cấp độ
		public var Rank:int;
		public var RankPoint:Number;
		public var MaxRankPoint:Number;
		
		public var RecipeType:Object;
		
		// Thuộc tính chiến đấu
		public var Health:int;
		public var MaxHealth:int;
		public var LastHealthTime:int;
		public var IsDie:Boolean = false;
		
		// STatus: 0:trong kho
		// 1: khoe
		// 2: lam sang
		// 3: chet
		public var Status:int;
		
		public var Bonus:Array = [];
		public var BuffItem:Array = [];
		
		public var GemList:Object;
		public var UserBuff:Object;
		
		public var Damage:int;
		public var DamagePlus:int;
		public var Defence:int;
		public var Critical:int;
		public var CriticalPlus:int;
		public var isResistance:Boolean;
		public var DefencePlus:int;
		public var Vitality:int;
		public var VitalityPlus:int;
		
		public var HealthRegenCooldown:int;
		
		public var Element:int;
		public var SoldierType:int;		// 2: Thích sát ngư 1: Võ lâm ngư 3: Được tặng
		public var SpecialSkill:Array = [];
		public var TimeLeft:int;
		public var LifeTime:int;
		
		public var AttackPoint:int;
		public var isChoose:Boolean = false;
		public var isActor:int = 0;
		
		public var isReadyToFight:Boolean = false;
		public var isHpRecharging:Boolean = false;
		
		// Hệ số lon
		public var Rate:Number;
		
		public var fallPos:Point = new Point();
		public var standbyPos:Point = new Point();;
		
		public var AlmostDieTime:int = -3 * 24 * 60 * 60;
		
		// Effect khi được búp gem
		public var GemEffect:Sprite;
		public var EffectType:int;	// Kim moc...
		
		// Equipment
		public var EquipmentList:Object;
		public var bonusEquipment:Object;
		
		// Update trạng thái bảo vệ
		public var NumDefendFail:int;
		public var LastTimeDefendFail:Number;
		public var MaxTimeFail:int;
		
		// Thoi gian check de remove effect level up
		public var levelUpTime:Number; //timestamp;
		
		public var Diary:Array = [];
		public var OnLoadResCompleteFunction:Function = null;
		
		public var rankPointBefore:int = 0;
		public var countPreStartDie:int = 0;
		public var countRandomRotation:int = 0;
		
		public var isSubBoss:Boolean = false;
		
		public var nameSoldier:String = "";
		public var lastTimeChangeName:Number;
		
		// Check xem có đang biến hình hay không (= 0 tức là ko biến hình)
		//public var TransformName:String = "";
		
		//Ngu mach
		public var meridianRank:int = 1;	//Cap ngu mach 1-13
		public var meridianPosition:int;	//Vi tri mach 0-10
		public var meridianPoint:int;	//Diem mach

		public var timeToTraining:int = 0;

		public var meridianVitality:int;
		public var meridianDamage:int;
		public var meridianCritical:int;
		public var meridianDefence:int;
		
		private var reputation:Image;
		private var ctnQuart:Container;
		public var reputationLevel:int = 0;
		public var bonusReputation:Object;
		
		// Trung Linh Thach
		public var QuartzList:Object;
		public var bonusQuartz:Object;

		public function FishSoldier(parent:Object = null, imgName:String = "", isToBitMap:Boolean = false) 
		{
			super(parent, imgName, isToBitMap);
			this.ClassName = "FishSoldier";
			
			UpdateBonusReputation();
		}
		
		public override function Init(x:int, y:int):void
		{
			Dragable = true;			
			Eated = 0;
			SetDeep(curDeep);		
			if(Ultility.IsInMyFish())
			{
				if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)//đang ở trong liên đấu
				{
					SetSwimingArea(new Rectangle(-500, GameController.getInstance().GetLakeTop() - 170, Constant.MAX_WIDTH + 2000, Constant.HEIGHT_LAKE + 500));
				}
				else {
					SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40));
				}
			}
			else 
			{
				//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD - 40));
				SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
			}
			HarvestTime = ConfigJSON.getInstance().getFishHarvest(FishTypeId, FishType, this);
			EggTime = ConfigJSON.getInstance().getEggTime(FishTypeId);
			SetPos(x, y);
			
			if (y < SwimingArea.top)
			{
				SetMovingState(FS_FALL);
			}
			else if (!isInRightSide)
			{	
				SetMovingState(FS_SWIM);
				FindDes(false);
				//trace("FindDes trong FishSoldier.Init()");
			}	
			RefreshImg();
		}
		
		private function UpdateEquipment():void
		{
			var i:int;
			var s:String;
			var quartId:int;
			var quartType:String;
			var obj:Object = { "QWhite":1, "QGreen":2, "QYellow":3, "QPurple":4, "QVIP":5 };
			for (s in EquipmentList)
			{
				for (i = 0; i < EquipmentList[s].length; i++)
				{
					ChangeEquipment(EquipmentList[s][i]);
				}
				
				if (obj[s] != null &&  EquipmentList[s].length > 0 && obj[s] > quartId)
				{
					quartId = obj[s];
					quartType = s;
				}
			}
			
			if (ctnQuart != null)
			{
				ctnQuart.ClearComponent();
			}
			if (quartType != null)
			{
				var maxId:int;
				for (i = 0; i < EquipmentList[quartType].length; i++)
				{
					if (EquipmentList[quartType][i]["ItemId"] > maxId)
					{
						maxId = EquipmentList[quartType][i]["ItemId"];
					}
				}
				var numStar:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[quartType][maxId]["Star"];				
				if(ctnQuart == null)
				{
					ctnQuart = new Container(aboveContent, "", 0, 0);
					ctnQuart.LoadRes("");
				}
				ctnQuart.ClearComponent();
				for (i = 0; i < numStar; i++)
				{
					ctnQuart.AddImage("", "Ic" + quartType.substring(1, quartType.length) + "Star", (i-numStar/2) * 17,-64);
				}
				aboveContent.addChild(ctnQuart.img);
			}
		}
		
		/**
		 * Update lại vị trí các content đi kèm khi cá quay đầu
		 */
		public override function updateAttachContent():void
		{			
			if (GemEffect != null)
			{
				GemEffect.x = OrientX * GetGemEffectPosition().x;
			}
		}
		
		/**
		 * Hàm cho cá bơi dập dềnh cho cá nhà bạn
		 */
		public function StandBy():void
		{
			var a:int;		// Gia tốc
			var v:int;		// Vận tốc
			
			if (SwimingArea.width == 0 && SwimingArea.height == 0)
			{
				return;
			}
			
			// Cập nhật bóng theo
			updateShadow();
			
			// Quay đầu về phía địch
			if (isActor == ACTOR_MINE)
			{
				OrientX = 1;
			}
			else
			{
				OrientX = -1;
			}
			
			//if (OrientX > 0)
			//{
				//OrientX = - 1;
			//}
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
				if (State != FS_WAR) 
				{
					if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR || 
						GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
					{	
						if (OnLoadResCompleteFunction != null)
						{
							OnLoadResCompleteFunction = null;
						}
						
						// Fix desPos.x để cá lính quay đầu theo hướng
						if (isActor == ACTOR_MINE
							|| (isActor == ACTOR_NONE && Ultility.IsInMyFish() && !GameLogic.getInstance().user.IsViewer()))
						{
							if(Ultility.IsInMyFish())
							{
								DesPos.x = Constant.MAX_WIDTH;
							}
							else
							{
								if (standbyPos != null)
								{
									DesPos.x = standbyPos.x + 5;
								}
							}
							img.rotation = 0;
							flipX(1);
						}
						else
						{
							if(Ultility.IsInMyFish())
							{
								DesPos.x = 0;
							}
							else
							{
								if (standbyPos != null)
								{
									DesPos.x = standbyPos.x - 5;
								}
							}
							//DesPos.x = 0;
							img.rotation = 0;
							flipX( -1);
							
							// Nếu là cá vừa được đánh thì tìm lại cá được chọn cho chắc
							if (isChoose && Ultility.IsInMyFish())
							{
								UpdateFishInCombat();
							}
						}
						isInRightSide = true;
						SetMovingState(FS_STANDBY);
						if (!GuiFishStatus.IsVisible)
						GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
						
						if (Ultility.IsKillBoss())
						{
							flipX(1);
						}
					}
					else if(GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)	// chỉ từ thế giới mộc đi là có thêm game mode này
					{
						if(!Ultility.IsKillBoss())
						{
							FindDes();
							//trace("FindDes trong Swim()");
						}
						else 
						{
							//if (!Ultility.IsInMyFish())
							//{
								//trace("đang ở thế giới cá và chưa được bật Gamemode");
							//}
							SwimTo(standbyPos.x, standbyPos.y, 20);
						}
					}
					// Xử lý trong thế giới cá, từ thế giới mộc trở đi
					else
					{
						if (OnLoadResCompleteFunction != null)
						{
							OnLoadResCompleteFunction = null;
						}
						// Fix desPos.x để cá lính quay đầu theo hướng
						if (isActor == ACTOR_MINE)
						{
							DesPos.x = Constant.MAX_WIDTH;
							if (standbyPos != null)
							{
								DesPos.x = standbyPos.x + 5;
							}
							img.rotation = 0;
							flipX(1);
						}
						else
						{
							DesPos.x = 0;
							if (standbyPos != null)
							{
								DesPos.x = standbyPos.x - 5;
							}
							img.rotation = 0;
							flipX( -1);
						}
						
						var arrFishSoldierWorld:Array = [];
						arrFishSoldierWorld = GameLogic.getInstance().user.FishSoldierActorMine;
						var iForFishWorld:int = 0;
						var countForFishWorld:int = 0;
						var fsw:FishSoldier;
						var itemFishMine:FishSoldier;
						
						switch (GameLogic.getInstance().gameState)
						{
							case GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_1:
							{
								for (iForFishWorld = 0; iForFishWorld < arrFishSoldierWorld.length; iForFishWorld++) 
								{
									fsw = arrFishSoldierWorld[iForFishWorld] as FishSoldier;
									switch (GuiMgr.getInstance().GuiMainForest.TypeSwim) 
									{
										case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_UP:
											fsw.SwimTo(fsw.standbyPos.x + 530, fsw.standbyPos.y + 70, 10);
										break;
										case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_RIGHT:
											fsw.SwimTo(fsw.standbyPos.x + 180, fsw.standbyPos.y - 60, 10);
										break;
										case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_DOWN:
											fsw.SwimTo(fsw.standbyPos.x + 270, fsw.standbyPos.y + 140, 10);
										break;
									}
								}
								GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_2);
							}
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_2:
							{
								for (iForFishWorld = 0; iForFishWorld < arrFishSoldierWorld.length; iForFishWorld++) 
								{
									fsw = arrFishSoldierWorld[iForFishWorld] as FishSoldier;
									if (fsw.ReachDes)
									{
										countForFishWorld ++;
										fsw.SetMovingState(FS_IDLE);
										switch (GuiMgr.getInstance().GuiMainForest.TypeSwim) 
										{
											case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_UP:
												fsw.SetPos(fsw.standbyPos.x - 400, fsw.standbyPos.y);
												GuiMgr.getInstance().GuiMainForest.InitBackground(
															Constant.ID_FISH_WORLD_BACKGROUND_4_ROUND_1);
											break;
											case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_RIGHT:
												fsw.SetPos(fsw.standbyPos.x, fsw.standbyPos.y + 400);
												GuiMgr.getInstance().GuiMainForest.InitBackground(
															Constant.ID_FISH_WORLD_BACKGROUND_4_ROUND_2);
											break;
											case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_DOWN:
												fsw.SetPos(fsw.standbyPos.x, fsw.standbyPos.y - 400);
												GuiMgr.getInstance().GuiMainForest.InitBackground(
															Constant.ID_FISH_WORLD_BACKGROUND_4_ROUND_3);
											break;
										}
									}
								}
								if (countForFishWorld >= arrFishSoldierWorld.length)
								{
									GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_IN);
									GuiMgr.getInstance().GuiFogInForestWold.Show();
									GuiMgr.getInstance().GuiMainForest.Hide();
									GuiMgr.getInstance().GuiMainForest.isClickGotoSea = false;
								}
								countForFishWorld = 0;
							}
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_PRE_CREATE_WAR:
							{
								if (isActor == ACTOR_MINE)
								{
									SetMovingState(FS_STANDBY);
								}
								else
								{
									flipX(1);
								}
								
								if (CheckReachDesAll(GameLogic.getInstance().user.FishSoldierActorMine))
								{
									//GuiMgr.getInstance().GuiMainForest.MonsterRightGreen.SetEmotion(WAR);
								}
							}
							break
							case GameState.GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_NO_REACHDES:
							{
								if(isActor == ACTOR_MINE)
								{
									SetMovingState(FS_STANDBY);
								}
								if (CheckReachDesAll(GameLogic.getInstance().user.FishSoldierActorMine))
								{
									GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_REACHDES);
									if(!(GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen[0] as Fish).IsHide)
									{
										(GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen[0] as FishSoldier).SetEmotion(WAR);
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_PRE_CREATE_WAR);
									}
								}
							}
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_GET_GIFT:
								if(isActor == ACTOR_MINE)
								{
									GuiMgr.getInstance().GuiBackMainForest.ShowEffGetGift();
									GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_NEXT_GET_GIFT);
								}
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_TO_GET_GIFT:
							{
								SetMovingState(FS_STANDBY);
								if (	CheckReachDesAll(GameLogic.getInstance().user.FishSoldierActorMine) && isActor == ACTOR_MINE)
								{
									DesPos.x = 0;
									if (standbyPos != null)
									{
										DesPos.x = standbyPos.x - 5;
									}
									img.rotation = 0;
									flipX( 1);
									GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_GET_GIFT);
									//(GuiMgr.getInstance().GuiMainForest.arrMonsterGift[0] as FishSoldier).Show();
									(GuiMgr.getInstance().GuiMainForest.arrMonsterGift[0] as FishSoldier).SetMovingState(FS_IDLE);;
									(GuiMgr.getInstance().GuiMainForest.arrMonsterGift[0] as FishSoldier).SetEmotion(WAR);
								}
							}
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_SET_QUEUE_FS_NO_REACHDES:
							{
								if(isActor != ACTOR_MINE)
								{
									DesPos.x = 0;
									if (standbyPos != null)
									{
										DesPos.x = standbyPos.x - 5;
									}
									img.rotation = 0;
									flipX( 1);
									var isReachDesFishWorld:Boolean = true;
									var arrMonsterDownGreen:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
									for (iForFishWorld = 0; iForFishWorld < arrMonsterDownGreen.length; iForFishWorld++) 
									{
										fsw = arrMonsterDownGreen[iForFishWorld] as FishSoldier;
										if (!fsw.ReachDes)
										{
											isReachDesFishWorld = false;
											break;
										}
									}
									if (isReachDesFishWorld)
									{
										for (iForFishWorld = 0; iForFishWorld < GameLogic.getInstance().user.FishSoldierActorMine.length; iForFishWorld++) 
										{
											itemFishMine = GameLogic.getInstance().user.FishSoldierActorMine[iForFishWorld];
											itemFishMine.SwimTo(itemFishMine.standbyPos.x, itemFishMine.standbyPos.y, 10);
										}
									}
								}
								else
								{
									// Hiển thị Gui chứa thứ tự các con cần đánh
									if(CheckReachDesAll(arrFishSoldierWorld))
									{
										GuiMgr.getInstance().GuiChooseSerialAttack.Show();
										GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_SET_QUEUE_FS_REACHDES);
									}
								}
								SetMovingState(FS_STANDBY);
							}
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS_WIN:
							{
								if(this.isActor != FishSoldier.ACTOR_MINE)
								{
									switch (FishWorldController.GetRound()) 
									{
										case Constant.OCEAN_FOREST_ROUND_1:
											UpdateRound1ForestSeaWin();
											break;
										case Constant.OCEAN_FOREST_ROUND_2:
											UpdateRound2ForestSeaWin();
											break;
										case Constant.OCEAN_FOREST_ROUND_3:
											UpdateRound3ForestSeaWin();
											break;
									}
								}
								else
								{
									//this.SetEmotion(WAR);
									this.ReachDes = false;
									this.isInRightSide = true;
									SetMovingState(FS_STANDBY);
									this.GuiFishStatus.ShowStatusWar(this);
									switch (FishWorldController.GetRound()) 
									{
										case Constant.OCEAN_FOREST_ROUND_2:
											GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
											break;
									}
								}
								break;
							}
							case GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS:
							{
								if(this.isActor != FishSoldier.ACTOR_MINE)
								{
									switch (FishWorldController.GetRound()) 
									{
										case Constant.OCEAN_FOREST_ROUND_1:
											UpdateRound1ForestSea();
										break;
										case Constant.OCEAN_FOREST_ROUND_2:
											UpdateRound2ForestSea();
											break;
										case Constant.OCEAN_FOREST_ROUND_3:
											UpdateRound3ForestSea(false);
											break;
									}
									
								}
								else
								{
									//this.SetEmotion(WAR);
									this.ReachDes = false;
									SetMovingState(FS_STANDBY);
									this.isInRightSide = true;
									this.GuiFishStatus.ShowStatusWar(this);
								}
								break;
							}
							case GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_NO_REACHDES:
							{
								if(GuiMgr.getInstance().GuiMainForest != null)
								{
									if(!(this is Thicket) && isActor && isActor == ACTOR_MINE)
									{
										var i:int = 0;
										ReachDes = false;
										SetMovingState(FS_STANDBY);
										if (CheckReachDesAll(arrFishSoldierWorld))	
										{
											GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_REACHDES);
										}
									}
								}
							}
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_PRE_ATTACK:
							break;
							case GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR:
								
							break;
							case GameState.GAMESTATE_IDLE:
							{
								isInRightSide = true;
								SetMovingState(FS_STANDBY);
								if (!GuiFishStatus.IsVisible)
									GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
							}
							break;
						}
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
					if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
					{
						if (LeagueController.getInstance().destructFish)
						{
							LeagueInterface.getInstance().deleteHisFish();
							LeagueController.getInstance().destructFish = false;
						}
					}
				}
				else
				{
					if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
					{
						SetEmotion(IDLE);
						isReadyToFight = true;
						GameLogic.getInstance().isAttacking = true;
						//trace("1 con vao vi tri: ", this.Id, this.LakeId);
					}
					else if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST) 
					{
						if (GameLogic.getInstance().gameState != GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS
							&&GameLogic.getInstance().gameState != GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS_WIN)
						{
							SetEmotion(IDLE);
							isReadyToFight = true;
							GameLogic.getInstance().isAttacking = true;
						}
					}
					else if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
					{
						//bơi đến chỗ đánh nhau
						
						isReadyToFight = true;
						GameLogic.getInstance().isAttacking = true;
						
					}
					else
					{
						if (!isSubBoss && ((!Ultility.IsInMyFish() && Emotion != WEAK) || Ultility.IsInMyFish())) 
						{
							SetEmotion(IDLE);
						}
						
						if (GameLogic.getInstance().user.CurSoldier[1] is FishSoldier || GameLogic.getInstance().user.CurSoldier[1] is SubBossMetal
							|| GameLogic.getInstance().user.CurSoldier[1] is SubBossIce)
						{
							//if (!isReadyToFight)
							//{
								//GuiFishStatus.ShowHPBar(this, this.Vitality, this.Vitality);
							//}
							// Các cờ được bật lên để các con cá thực hiên kịch bản server trả về
							GameLogic.getInstance().isAttacking = true;
							isReadyToFight = true;
						}
						else
						{
							if(Ultility.IsInMyFish())
							{
								if (img.visible)
									img.visible = false;
								
								if (aboveContent.visible)
									aboveContent.visible = false;
								
								if (GuiFishStatus.IsVisible)
									GuiFishStatus.img.visible = false;
							}
						}
					}
				}
			}
			if (chatbox && img != null)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
			
			// Thiết lập vùng bay của các loại cá khác nhau
			if(!Ultility.IsKillBoss() && GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
			{
				CheckWarPosition2();
			}
		}
		
		
		public function UpdateRound1ForestSeaWin():void 
		{
			//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, standbyPos.x - 100, standbyPos.y);
			var i:int = 0;
			var arrThicket:Array = GuiMgr.getInstance().GuiMainForest.arrThicketUpRed;
			var arrMonster:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed;
			for (i = 0; i < arrThicket.length; i++) 
			{
				var itemThicket:Thicket = arrThicket[i];
				itemThicket.Destructor();
			}
			arrThicket.splice(0, arrThicket.length);
			for (i = 0; i < arrMonster.length; i++) 
			{
				var itemMonsterRed:FishSoldier = arrMonster[i];
				itemMonsterRed.Destructor();
			}
			arrMonster.splice(0, arrMonster.length);
			//Show Eff chien thang vong neu co
			//GuiMgr.getInstance().GuiMainForest.Show(Constant.OBJECT_LAYER);
			//GuiMgr.getInstance().GuiMainForest.InitBackground(Constant.ID_FISH_WORLD_BACKGROUND_4);
			//if (GuiMgr.getInstance().GuiBackMainForest.IsVisible)
			//{
				//GuiMgr.getInstance().GuiBackMainForest.Hide();
			//}
			//GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
			GuiMgr.getInstance().GuiGetPiece.Show(Constant.GUI_MIN_LAYER, 1);
			GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true;
		}
		public function UpdateRound1ForestSea():void 
		{
			//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, standbyPos.x - 100, standbyPos.y);
			this.GuiFishStatus.Hide();
			this.Hide();
			var arrIndex1:Array = [];
			for (var iForFishWorld:int = 0; iForFishWorld < GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition.length; iForFishWorld++) 
			{
				(GuiMgr.getInstance().GuiMainForest.arrThicketUpRed[iForFishWorld] as Thicket).SetEmotion(Fish.IDLE);
				arrIndex1.push(iForFishWorld);
			}
			var index3:int = Math.floor(Math.random() * arrIndex1.length);
			var thicket3:Thicket = GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition[arrIndex1[index3]];
			arrIndex1.splice(index3, 1);
			var index4:int = Math.floor(Math.random() * arrIndex1.length);
			var thicket4:Thicket = GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition[arrIndex1[index4]];
			arrIndex1.splice(0, arrIndex1.length);
			GuiMgr.getInstance().GuiMainForest.Swap(thicket3, thicket4);
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
			GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true;
		}
		
		public function UpdateRound2ForestSea():void 
		{
			//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, standbyPos.x - 100, standbyPos.y);
			this.SetMovingState(FS_STANDBY);
			this.ReachDes = false;
			this.SetEmotion(FishSoldier.WAR);
			this.GuiFishStatus.ShowStatusWar(this);
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
			GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
			GuiMgr.getInstance().GuiRegenerating.initGUI([GameLogic.getInstance().user.CurSoldier[0]], true);
			GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true;
		}
		public function UpdateRound2ForestSeaWin():void 
		{
			//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, standbyPos.x - 100, standbyPos.y);
			var imgDisable:Image = GuiMgr.getInstance().GuiBackMainForest.ctnMainRound2.GetImage(
						GuiMgr.getInstance().GuiBackMainForest.IMG_DEITY_MAIN_FOREST + this.Id.toString());
			//Ultility.SetEnableSprite(imgDisable.img, false);
			var obj:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3].Monster;
			var posEff:Point = imgDisable.img.localToGlobal(new Point());
			posEff = GuiMgr.getInstance().GuiBackMainForest.img.globalToLocal(posEff);
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "LoadingForestWorld_EffShowQuit", null, posEff.x - 40, posEff.y + 80);
			for (var i:String in obj["2"]) 
			{
				if (obj["2"][i] && obj["2"][i].Id == this.Id)
				{
					obj["2"][i] = null;
					break;
				}
			}
			this.Destructor();
			GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen.splice(
					0, GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen.length);
			GameLogic.getInstance().UpdateDataRound2Forest();
			GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true;
			GuiMgr.getInstance().GuiBackMainForest.isCanClickDeity = true;
		}
		public function UpdateRound3ForestSea(isHaveEff:Boolean = true):void 
		{
			ReachDes = false;
			if(isHaveEff)
 			{
				GameLogic.getInstance().efRound3ForestSea = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, this.CurPos.x - 100, this.CurPos.y, false,
					false, null, _UpdateRound3ForestSea);
				this.img.visible = false;
			}
			else
			{
				this.img.visible = false;
				_UpdateRound3ForestSea(false);
			}
			if (this.GuiFishStatus.IsVisible)	this.GuiFishStatus.Hide();
		}
		
		//private var countNumEffHoiSinh:int = 0;
		public function _UpdateRound3ForestSea(isMeWin:Boolean = true):void 
		{
			var thisId:int = this.Id;
			this.SetPos(this.standbyPos.x, this.standbyPos.y);
			this.img.visible = true;
			this.SetMovingState(FS_STANDBY);
			this.ReachDes = false;
			//this.SetEmotion(FishSoldier.WAR);
			this.GuiFishStatus.ShowStatusWar(this);
			// Khởi tạo lại 5 răn
			var objConf:Object = ConfigJSON.getInstance().GetItemList("SeaMonster")["4"]["3"];
			var objMonsterAll:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3].Monster
			var objMonster:Object = objMonsterAll[String(Constant.OCEAN_FOREST_ROUND_3)];
			var arrMonsterYellow:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
			var arrMonsterYellowData:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownYellowData;
			var arrSerialAttack:Array = GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack;
			if (this.Id != 6)	// Neu danh con boss thua thi khong bi hoi sinh
			{
				if(arrSerialAttack.indexOf(this.Id) > 0)
				{
					GuiMgr.getInstance().GuiChooseSerialAttack.Hide();
					var arrEff:Array = [];
					for (var m:int = 1; m <= GuiMgr.getInstance().GuiMainForest.MAX_MONSTER_YELLOW_DOWN; m++) 
					{
						arrEff.push(0);
						for (var n:int = 0; n < arrMonsterYellowData.length; n++) 
						{
							if (int(arrMonsterYellowData[n].Element) == m && int(arrMonsterYellowData[n].Id) != 6)
							{
								arrEff[arrEff.length - 1] = 1;
								break;
							}
						}
					}
					if(isMeWin)
					{
						arrEff[this.Element - 1] = 0;
					}
					
					arrMonsterYellowData.splice(0, arrMonsterYellowData.length);
					var objBase:Object = objMonster["6"];
					for (var i:int = 1; i < GuiMgr.getInstance().GuiMainForest.MAX_MONSTER_YELLOW_DOWN; i++) 
					{
						var item:Object = new Object();
						for (var l:String in objBase) 
						{
							item[l] = objBase[l];
						}
						
						var itemConf:Object = objConf[i.toString()];
						for (var j:String in itemConf) 
						{
							item[j] = itemConf[j];
						}
						item.Id = item.Element;
						item.IsBoss = null;
						arrMonsterYellowData.push(item);
						
						objMonster[String(item.Id)] = item;
					}
					arrMonsterYellowData.push(objBase);
					
					var k:int = 0;
					for (k = 0; k < arrMonsterYellow.length; k++) 
					{
						(arrMonsterYellow[k] as FishSoldier).Destructor();
					}
					arrMonsterYellow.splice(0, arrMonsterYellow.length);
					GuiMgr.getInstance().GuiFogInForestWold.ReInitMonsterSeaDownYellow();
					for (k = 0; k < arrMonsterYellow.length; k++) 
					{
						if(arrMonsterYellow[k].Id != 6)
						{
							if(arrEff[(arrMonsterYellow[k] as FishSoldier).Element - 1] == 0)
							{
								GameLogic.getInstance().countNumEffHoiSinh ++;
								EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffHoiSinh",
									null, (arrMonsterYellow[k] as FishSoldier).standbyPos.x, (arrMonsterYellow[k] as FishSoldier).standbyPos.y, false,
									false, null, UpdateAfterShowEffHoiSinh);
							}
						}
						else
						{
							(arrMonsterYellow[k] as FishSoldier).SetEmotion(IDLE);
						}
					}
					var isChange:Boolean = false;
					var arrSequence:Array = GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack;
					if (GameLogic2.objDataSequenceGreenDown != null)
					{
						var objS:Object = GameLogic2.objDataSequenceGreenDown;
						var o:String;
						var numEleMent:int = 0;
						for (o in GameLogic2.objDataSequenceGreenDown.Sequence) 
						{
							numEleMent++;
						}
						//for (o in GameLogic2.objDataSequenceGreenDown.Sequence) 
						//{
							//var ele:int = GameLogic2.objDataSequenceGreenDown.Sequence[o];
							if (numEleMent == 5)	// Nếu mình thắng và số lượng con phải đánh là 5 thì khởi tạo lại
							{
								GuiMgr.getInstance().GuiMainForest.objSequenceGreenDown = GameLogic2.objDataSequenceGreenDown.Sequence;
								GuiMgr.getInstance().GuiMainForest.objHideGreenDown = GameLogic2.objDataSequenceGreenDown.ArrHide;
								GuiMgr.getInstance().GuiChooseSerialAttack.StartProcessChooseSerial(GameLogic2.objDataSequenceGreenDown);
								GameLogic2.objDataSequenceGreenDown = null
								//break;
							}
						//}
					}
					
					GuiMgr.getInstance().GuiChooseSerialAttack.Show();
					GuiMgr.getInstance().GuiChooseSerialAttack.isCanChooseSerial = false;
					GuiMgr.getInstance().GuiChooseSerialAttack.btnGet.SetDisable();
					GuiMgr.getInstance().GuiChooseSerialAttack.ShowNewSequence();
					
					if (GameLogic.getInstance().countNumEffHoiSinh <= 0)
					{
						GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
						GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
						GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true; 
						GameLogic.getInstance().efRound3ForestSea = null;
					}
					
				}
				else
				{
					GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
					GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
					GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true; 
					GameLogic.getInstance().efRound3ForestSea = null;
				}
			}
			else
			{
				GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
				GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
				GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true; 
				GameLogic.getInstance().efRound3ForestSea = null;
			}
		}
		
		private function UpdateAfterShowEffHoiSinh():void 
		{
			GameLogic.getInstance().countNumEffHoiSinh--;
			if (GameLogic.getInstance().countNumEffHoiSinh <= 0)
			{
				GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
				GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
				GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true; 
				GameLogic.getInstance().efRound3ForestSea = null;
			}
		}
		
		public function UpdateRound3ForestSeaWin():void 
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffShowQuit", null, this.CurPos.x - 100, this.CurPos.y);
			var arr1:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
			var objData:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3].Monster[GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_DOWN.toString()];
			var arrData:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownYellowData;
			for (var j:int = 0; j < arr1.length; j++) 
			{
				var monsterYellow:FishSoldier = arr1[j];
				if (monsterYellow.Id == this.Id) 
				{
					for (var i:int = 0; i < arrData.length; i++) 
					{
						var item:Object = arrData[i];
						if (item.Id == monsterYellow.Id)
						{
							arrData.splice(i, 1);
							break;
						}
					}
					delete(objData[monsterYellow.Id.toString()]);
					monsterYellow.Destructor();
					arr1.splice(j, 1);
					if(GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack.length > 0)
					{
						if(this.Element == GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack[0])
						{
							GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttack.splice(0, 1);
							GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttackRandom.splice(GuiMgr.getInstance().GuiChooseSerialAttack.arrSerialAttacked.length, 1);
						}
						if (arr1.length == 1)
						{
							(arr1[0] as FishSoldier).SetEmotion(FishSoldier.WAR);
						}
					}
					if(arr1.length > 0)
					{
						Ultility.SetEnableSprite(GuiMgr.getInstance().GuiChooseSerialAttack.ctnMain.GetImage(
							GuiMgr.getInstance().GuiChooseSerialAttack.IMG_SERIAL + 
							(GuiMgr.getInstance().GuiMainForest.MAX_MONSTER_YELLOW_DOWN - arr1.length)).img, false);
					}
					break;
				}
			}
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
			GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true;
			if(arr1.length <= 0)
			{
				//Show Eff chien thang vong neu co
				//GuiMgr.getInstance().GuiMainForest.Show(Constant.OBJECT_LAYER);
				//GuiMgr.getInstance().GuiMainForest.InitBackground(Constant.ID_FISH_WORLD_BACKGROUND_4);
				//if(GuiMgr.getInstance().GuiChooseSerialAttack.IsVisible)
				//{
					//GuiMgr.getInstance().GuiChooseSerialAttack.Hide();
				//}
				//if (GuiMgr.getInstance().GuiBackMainForest.IsVisible)
				//{
					//GuiMgr.getInstance().GuiBackMainForest.Hide();
				//}
				//GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
				GuiMgr.getInstance().GuiGetPiece.Show(Constant.GUI_MIN_LAYER, 1);
			}
			else 
			{
				GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
			}
		}
		
		public function Round3ComeBackForestSea():void 
		{
			//GuiMgr.getInstance().GuiMainForest.Show(Constant.OBJECT_LAYER);
			//GuiMgr.getInstance().GuiMainForest.InitBackground(Constant.ID_FISH_WORLD_BACKGROUND_4);
			//if(GuiMgr.getInstance().GuiChooseSerialAttack.IsVisible)
			//{
				//GuiMgr.getInstance().GuiChooseSerialAttack.Hide();
			//}
			//if (GuiMgr.getInstance().GuiBackMainForest.IsVisible)
			//{
				//GuiMgr.getInstance().GuiBackMainForest.Hide();
			//}
			//GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
			GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
		}
		
		public function Round2ComeBackForestSea():void 
		{
			var obj1:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3];
			GuiMgr.getInstance().GuiMainForest.objEffYellowRight = null;
			GuiMgr.getInstance().GuiMainForest.MonsterRightGreenData = null;
			obj1.currentMonster = null;
			// tro ve map ban do chinh cua the gioi Moc
			GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
		}
		
		public function Round1ComeBackForestSea():void 
		{
			//GuiMgr.getInstance().GuiMainForest.Show(Constant.OBJECT_LAYER);
			//GuiMgr.getInstance().GuiMainForest.InitBackground(Constant.ID_FISH_WORLD_BACKGROUND_4);
			//if (GuiMgr.getInstance().GuiBackMainForest.IsVisible)
			//{
				//GuiMgr.getInstance().GuiBackMainForest.Hide();
			//}
			//GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
			
			GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
			GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true;
		}
		
		public function CheckReachDesAll(arr:Array):Boolean
		{
			var isReachDesAll:Boolean = true;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:FishSoldier = arr[i] as FishSoldier;
				if (item.ReachDes == false)
				{
					isReachDesAll = false;
					break;
				}
			}
			return isReachDesAll;
		}
		
		public override function ChangeDir(curPos:Point, desPos:Point, turnSpeed:Number = 0):void
		{
			if (img == null)	return;
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
			
			// Nếu có effect Gem thì cho quay theo chiều của con cá
			var dob:DisplayObject = aboveContent.getChildByName("GemEffect");
			if (dob)
			{
				dob.rotation = dir;
			}
			
			//dob = aboveContent.getChildByName("ChooseEffect");
			//if (dob)
			//{
				//dob.rotation = dir;
			//}
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
			
			if ((chatbox && GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
				|| (Health <= AttackPoint))
			{
				chatbox.Hide();
			}
			
			if (txtFieldName != null && aboveContent.contains(txtFieldName))
			{
				aboveContent.removeChild(txtFieldName);
			}
			
		}
		
		/**
		 * Hàm thiết lập khả năng di chuyển của các con cá khi chuyển chế độ WAR/NORMAL
		 * Khi bật chế độ WAR	:	Các con cá lính của mình sẽ CHỈ được di chuyển ở nửa bên trái màn hình
		 * Khi bật chế độ WAR	:	Tất cả các con cá của bạn sẽ CHỈ được di chuyển ở nửa bên phải màn hình
		 * Khi bật chế độ NORMAL:	Các con cá lính của mình sẽ chạy và biến mất, các con cá của bạn bơi bình thường
		 */
		public override function CheckWarPosition():void
		{
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR && Health >= AttackPoint)
			{
				if (isActor == ACTOR_MINE)
				{
					if (!isInRightSide && (CurPos.x - img.width / 2 ) >= (Constant.MAX_WIDTH / 2 - img.stage.width / 2))
					{
						isInRightSide = true;
						if (Ultility.IsInMyFish()) 
						{
							SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2 - img.stage.width / 2, GameController.getInstance().GetLakeTop() + 30, img.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 80));
						}
						else 
						{
							SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
							//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH / 2, Constant.HEIGHT_LAKE_FISH_WORLD - 80));
						}
						if (!isReadyToFight)
						GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
					}
				}
				else // (isActor == ACTOR_THEIRS)
				{
					//if (!isInRightSide && (CurPos.x - img.width / 2) >= (Constant.MAX_WIDTH / 2) && (CurPos.x + img.width / 2) <= (Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2))
					if (!isInRightSide && standbyPos == CurPos)
					{
						isInRightSide = true;
						//SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop() + 30, Main.imgRoot.stage.width / 2, Constant.HEIGHT_LAKE - 80));
						
						if (Ultility.IsInMyFish()) 
						{
							SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop() + 30, 280, Constant.HEIGHT_LAKE - 80));
						}
						else 
						{
							SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2, 0, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
							//SetSwimingArea(new Rectangle(Constant.STAGE_WIDTH / 2, GameController.getInstance().GetLakeTop() + 60, Constant.STAGE_WIDTH / 2, Constant.HEIGHT_LAKE_FISH_WORLD - 100));
						}
						if (!isReadyToFight)
						GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
						//SetMovingState(FS_STANDBY);
						
						// Fix desPos.x để cá lính quay đầu sang trái
						//DesPos.x = Constant.MAX_WIDTH / 2 - 1;
						//SetMovingState(FS_IDLE);
						//flipX( -1);
					}
				}
				
			}
			else if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR ||
					(GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR && Health < AttackPoint))
			{
				if (Health < AttackPoint && isActor == ACTOR_NONE && GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
				{
					return;
				}
				
				if (isInRightSide)
				{
					var index:int;
					//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
					if (isActor == FishSoldier.ACTOR_MINE)
					{
						if ((CurPos.x + img.width / 2) <= (Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2))
						{
							index = GameLogic.getInstance().user.FishSoldierActorMine.indexOf(this);
							GameLogic.getInstance().user.FishSoldierActorMine[index].Clear();
							GameLogic.getInstance().user.FishSoldierActorMine.splice(index, 1);
							
							if (GameLogic.getInstance().user.FishSoldierActorMine.length == 0)
							{
								if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
								GameController.getInstance().UseTool("Peace");
							}
							else
							{
								var next:FishSoldier = FindBestSoldier(GameLogic.getInstance().user.GetMyInfo().MySoldierArr, true);
								for (var i:int = 0; i < GameLogic.getInstance().user.FishSoldierActorMine.length; i++)
								{
									var s:FishSoldier = GameLogic.getInstance().user.FishSoldierActorMine[i] as FishSoldier;
									if (next.Id == s.Id)
									{
										s.isChoose = true;
										GameLogic.getInstance().user.CurSoldier[0] = s;
										break;
									}
								}
							}
						}
					}
					else if (isActor == FishSoldier.ACTOR_THEIRS)
					{
						if ((CurPos.x - img.width / 2) > (Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2))
						{
							index = GameLogic.getInstance().user.FishSoldierActorTheirs.indexOf(this);
							GameLogic.getInstance().user.FishSoldierActorTheirs[index].Clear();
							GameLogic.getInstance().user.FishSoldierActorTheirs.splice(index, 1);
						}
					}
					else
					{
						if (Ultility.IsInMyFish()) 
						{
							SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
						}
						else 
						{
							SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
							//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD - 80));
						}
						isInRightSide = false;
						GuiFishStatus.Hide();
					}
				}
			}
		}

		public function CheckWarPosition1():void
		{
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR || GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
			{
				if (isActor == ACTOR_MINE)
				{
					if (!isInRightSide && (CurPos.x - img.width / 2 ) >= (Constant.MAX_WIDTH / 2 - img.stage.width / 2))
					{
						if (OnLoadResCompleteFunction != null)
						{
							OnLoadResCompleteFunction = null;
							//trace("OnLoadResCompleteFunction -> null o FishSoldier.CheckWarPosition1 ActorMine");
						}
						
						isInRightSide = true;
						if(Ultility.IsInMyFish())
						{							
							SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2 - img.stage.width / 2, GameController.getInstance().GetLakeTop() 
								+ 30, img.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 80));
						}
						else 
						{
							//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH / 2, Constant.HEIGHT_LAKE_FISH_WORLD - 80));
							SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
						}
						GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
					}
				}
				else // (isActor == ACTOR_THEIRS)
				{
					if (!isInRightSide && standbyPos == CurPos)// && State != FS_WAR)
					{
						if (OnLoadResCompleteFunction != null)
						{
							OnLoadResCompleteFunction = null;
							//trace("OnLoadResCompleteFunction -> null o FishSoldier.CheckWarPosition1 ActorTheirs");
						}
						
						isInRightSide = true;
						if(Ultility.IsInMyFish())
						{
							SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop() + 30, 
								280, Constant.HEIGHT_LAKE - 80));
						}
						else 
						{
							//SetSwimingArea(new Rectangle(Constant.STAGE_WIDTH / 2, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH / 2, Constant.HEIGHT_LAKE_FISH_WORLD - 80));
							SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
						}
						if (!isReadyToFight)
						GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
					}
				}
				
			}
			else
			{				
				if (isInRightSide)
				{
					var index:int;
					if (isActor == FishSoldier.ACTOR_MINE)
					{
						// Nếu là cá lính nhà mình thì chờ đi qua hết màn hình rồi xóa đi
						if ((CurPos.x + img.width / 2) <= (Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2))
						{
							index = GameLogic.getInstance().user.FishSoldierActorMine.indexOf(this);
							GameLogic.getInstance().user.FishSoldierActorMine[index].Clear();
							GameLogic.getInstance().user.FishSoldierActorMine.splice(index, 1);
						}
					}
					else if (isActor == FishSoldier.ACTOR_THEIRS)
					{
						// Nếu là cá lính nhà bạn nhưng ở hồ khác thì chờ đi qua hết màn hình rồi xóa đi
						if ((CurPos.x - img.width / 2) > (Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2))
						{
							index = GameLogic.getInstance().user.FishSoldierActorTheirs.indexOf(this);
							GameLogic.getInstance().user.FishSoldierActorTheirs[index].Clear();
							GameLogic.getInstance().user.FishSoldierActorTheirs.splice(index, 1);
						}
					}
					else
					{
						if(Ultility.IsInMyFish())
						{
							SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, 
								Constant.HEIGHT_LAKE - 80));
						}
						else 
						{
							//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, 
								//Constant.HEIGHT_LAKE_FISH_WORLD - 80));
							SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
						}
						isInRightSide = false;
						GuiFishStatus.Hide();
					}
				}
			}
		}
		
		public function CheckWarPosition2():void
		{
			//if (!Ultility.IsInMyFish())	
				//return;
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR
				|| GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
			{
				if (standbyPos == CurPos)
				{
					if (OnLoadResCompleteFunction != null)
					{
						OnLoadResCompleteFunction = null;
						//trace("OnLoadResCompleteFunction -> null o FishSoldier.CheckWarPosition2");
					}
					
					if (!isReadyToFight)
					{
						GuiFishStatus.ShowStatus(this, GUIFishStatus.WAR_INFO);
					}
				}
			}
			else
			{				
				if (isInRightSide)
				{
					var index:int;
					if (isActor == FishSoldier.ACTOR_MINE)
					{
						// Nếu là cá lính nhà mình thì chờ đi qua hết màn hình rồi xóa đi
						if ((CurPos.x + img.width / 2) <= (Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2))
						{
							index = GameLogic.getInstance().user.FishSoldierActorMine.indexOf(this);
							GameLogic.getInstance().user.FishSoldierActorMine[index].Clear();
							GameLogic.getInstance().user.FishSoldierActorMine.splice(index, 1);
						}
					}
					else if (isActor == FishSoldier.ACTOR_THEIRS)
					{
						// Nếu là cá lính nhà bạn nhưng ở hồ khác thì chờ đi qua hết màn hình rồi xóa đi
						if ((CurPos.x - img.width / 2) > (Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2))
						{
							index = GameLogic.getInstance().user.FishSoldierActorTheirs.indexOf(this);
							GameLogic.getInstance().user.FishSoldierActorTheirs[index].Clear();
							GameLogic.getInstance().user.FishSoldierActorTheirs.splice(index, 1);
						}
					}
					else
					{
						if(Ultility.IsInMyFish())
						{
							SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, 
								Constant.HEIGHT_LAKE - 80));
						}
						else 
						{
							//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, 
								//Constant.HEIGHT_LAKE_FISH_WORLD - 80));
							SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
						}
						isInRightSide = false;
						GuiFishStatus.Hide();
					}
				}
			}
		}
		
		public function UpdateBonusReputation():void
		{
			if (!bonusReputation) 
			{
				bonusReputation = new Object();
			}
			bonusReputation["Damage"] = 0;
			bonusReputation["Critical"] = 0;
			bonusReputation["Vitality"] = 0;
			bonusReputation["Defence"] = 0;
			
			if (!GameLogic.getInstance().user.IsViewer())
			{
				if (FishWorldController.GetSeaId() >= 1)
				{
					if (isActor == ACTOR_MINE)
					{
						reputationLevel = GameLogic.getInstance().user.getReputationLevel();
					}
				}
				else
				{
					reputationLevel = GameLogic.getInstance().user.getReputationLevel();
				}
			}
			else
			{
				if (isActor == ACTOR_MINE)
				{
					reputationLevel = GameLogic.getInstance().user.getReputationLevel();
				}
				else// if (isActor == ACTOR_THEIRS)
				{
					reputationLevel = GameLogic.getInstance().user.getReputationLevel(false);
				}
			}
			
			var fameLevel:int = 0;
			if (reputationLevel > 0)
			{
				fameLevel = reputationLevel;
			}
			if(fameLevel > 0)
			{
				var buffConf:Object = ConfigJSON.getInstance().getItemInfo("ReputationBuff");
				bonusReputation["Damage"] = buffConf[fameLevel]["Damage"];
				bonusReputation["Defence"] = buffConf[fameLevel]["Defence"];
				bonusReputation["Critical"] = buffConf[fameLevel]["Critical"];
				bonusReputation["Vitality"] = buffConf[fameLevel]["Vitality"];
			}			
		}
		
		public function UpdateBonusEquipment():void
		{
			var s:String;
			if (!bonusEquipment) 
			{
				bonusEquipment = new Object();
			}
			for (s in bonusEquipment)
			{
				delete(bonusEquipment[s]);
			}
			
			bonusEquipment["Damage"] = 0;
			bonusEquipment["Critical"] = 0;
			bonusEquipment["Vitality"] = 0;
			bonusEquipment["Defence"] = 0;
			
			// Cá bot ở TGC thì ko cập nhật đồ đạc
			if (!Ultility.IsInMyFish() && isActor == ACTOR_NONE)
			{
				return;
			}
			
			
			var bonusPercent:Number = 0;
			var sealDamage:Number = 0;
			var sealCritical:Number = 0;
			var sealVitality:Number = 0;
			var sealDefence:Number = 0;
			var rowActive:int;
			if (EquipmentList != null && EquipmentList["Seal"] != null)
			{
				var equip:FishEquipment = EquipmentList["Seal"][0] as FishEquipment;
				rowActive= Ultility.getActiveRowSeal(equip, this);
			}
			if (rowActive != 0)
			{
				var configSeal:Object = ConfigJSON.getInstance().GetItemList("Wars_Seal");
				configSeal = configSeal[equip.Rank][equip.Color];
				
				for (var k:int = 1; k <= rowActive; k++)
				{
					var config:Object = configSeal[k];
					
					if(config["Damage"] != null)
					{
						sealDamage += config["Damage"];
					}
					if(config["Critical"] != null)
					{
						sealCritical +=  config["Critical"];
					}
					if(config["Vitality"] != null)
					{
						sealVitality += config["Vitality"];
					}
					if(config["Defence"] != null)
					{
						sealDefence += config["Defence"];
					}
					
					if (config["TotalPercent"] != null)
					{
						bonusPercent = config["TotalPercent"];
					}
				}
			}
			
			var type:String;
			var i:int;
			for (type in EquipmentList)
			{
				for (i = 0; i < EquipmentList[type].length; i++)
				{
					if (EquipmentList[type][i].Durability <= 0)	continue;
					
					if (type != "Seal")
					{
						if (type == "QWhite" || type == "QGreen" || type == "QYellow" || type == "QPurple" || type == "QVIP")
						{
							var dataStore:Object = GameLogic.getInstance().user.loadFunctionQuartz(EquipmentList[type][i].ItemId, EquipmentList[type][i].Type, EquipmentList[type][i].Level);
							bonusEquipment["Damage"] += dataStore.Damage * dataStore.OptionDamage;
							bonusEquipment["Critical"] += dataStore.Critical  *dataStore.OptionCritical;
							bonusEquipment["Vitality"] += dataStore.Vitality * dataStore.OptionVitality;
							bonusEquipment["Defence"] += dataStore.Defence * dataStore.OptionDefence;
						}
						else
						{
							bonusEquipment["Damage"] += EquipmentList[type][i].Damage + Math.ceil(EquipmentList[type][i].Damage*bonusPercent/100);
							bonusEquipment["Critical"] += EquipmentList[type][i].Critical + Math.ceil(EquipmentList[type][i].Critical*bonusPercent/100);
							bonusEquipment["Vitality"] += EquipmentList[type][i].Vitality+ Math.ceil(EquipmentList[type][i].Vitality*bonusPercent/100);
							bonusEquipment["Defence"] += EquipmentList[type][i].Defence + Math.ceil(EquipmentList[type][i].Defence*bonusPercent/100);
						}
						if (EquipmentList[type][i].bonus)
						{
							for (var j:int = 0; j < EquipmentList[type][i].bonus.length; j++)
							{
								for (s in EquipmentList[type][i].bonus[j])
								{
									if (type == "QWhite" || type == "QGreen" || type == "QYellow" || type == "QPurple" || type == "QVIP")
									{
										bonusEquipment[s] += EquipmentList[type][i].bonus[j][s];
									}
									else
									{
										bonusEquipment[s] += EquipmentList[type][i].bonus[j][s] + Math.ceil(EquipmentList[type][i].bonus[j][s]*bonusPercent/100);
									}
								}
							}
						}
					}
				}
			}
			
			bonusEquipment["Damage"] += sealDamage;
			bonusEquipment["Critical"] +=  sealCritical;
			bonusEquipment["Vitality"] +=  sealVitality;
			bonusEquipment["Defence"] +=  sealDefence;
		}
		
		public function WareEquipment(isWare:Boolean, eq:FishEquipment):void
		{
			if (isWare)
			{
				GameLogic.getInstance().user.UpdateEquipmentToStore(eq, false);
				EquipmentList[eq.Type].push(eq);
			}
			else
			{
				for (var Type:String in EquipmentList)
				{
					for (var i:int = 0; i < EquipmentList[Type].length; i++)
					{
						if (EquipmentList[Type][i].Id == eq.Id)
						{
							EquipmentList[Type].splice(i, 1);
							break;
						}
					}
				}
				GameLogic.getInstance().user.UpdateEquipmentToStore(eq);
			}
		}
		
		public override function RefreshImg():void
		{
			ClearImage();
			if (EquipmentList && EquipmentList["Mask"] && EquipmentList["Mask"][0] && EquipmentList["Mask"][0].TransformName != "")
			{
				LoadRes(EquipmentList["Mask"][0].TransformName);
				EquipmentEffect(this.img, EquipmentList["Mask"][0].Color);
			}
			else
			{
				//trace("RefreshImg Emotion== " + Emotion);
				switch(Emotion)
				{
					case WEAK:
					case REVIVE:
						LoadRes(ItemType +  FishTypeId + "_" + AgeState + "_" + SAD);
						break;
					case WAR:
					case REWARD:
						if(FishWorldController.GetSeaId() != Constant.OCEAN_FOREST_ROUND_4)
						{
							LoadRes(ItemType +  FishTypeId + "_" + AgeState + "_" + IDLE);
						}
						else if(isActor != ACTOR_MINE)
						{
							switch (FishWorldController.GetRound()) 
							{
								case Constant.SEA_ROUND_1:
									if (isSubBoss)	LoadRes("ForestWorldMonsterRedUp_Idle");
									else LoadRes("ForestWorldBossRedUp_Idle");
								break;
								case Constant.SEA_ROUND_2:
									LoadRes("ForestWorldBossRound2_" + Id + "_Idle");
								break;
								case Constant.SEA_ROUND_3:
									if (isSubBoss)	LoadRes("ForestWorldSnakeNormal_" + Element + "_Idle");
									else LoadRes("ForestWorldSnakeBoss_Idle");
								break;
								case Constant.SEA_ROUND_4:
									LoadRes("ForestWorldBossGetGift");
								break;
							}
						}
						break;
					case DEAD:
						if (this.ImgName != "FishGrave")
							LoadRes("FishGrave");
						break;
					default:
						if(FishWorldController.GetSeaId() != Constant.OCEAN_FOREST_ROUND_4)
						{
							LoadRes(ItemType +  FishTypeId + "_" + AgeState + "_" + Emotion);
						}
						else if(isActor != ACTOR_MINE)
						{
							switch (FishWorldController.GetRound()) 
							{
								case Constant.SEA_ROUND_1:
									if (isSubBoss)	LoadRes("ForestWorldMonsterRedUp_Idle");
									else LoadRes("ForestWorldBossRedUp_Idle");
								break;
								case Constant.SEA_ROUND_2:
									LoadRes("ForestWorldBossRound2_" + Id + "_Idle");
								break;
								case Constant.SEA_ROUND_3:
									if (isSubBoss)	LoadRes("ForestWorldSnakeNormal_" + Element + "_Idle");
									else LoadRes("ForestWorldSnakeBoss_Idle");
								break;
								case Constant.SEA_ROUND_4:
									LoadRes("ForestWorldBossGetGift");
								break;
							}
						}
						else
						{
							LoadRes(ItemType +  FishTypeId + "_" + AgeState + "_" + Emotion);
						}
						break;
				}
				
				if (SoldierType == SOLDIER_TYPE_MIX)
				{
					UpdateEquipment();
				}
			}
			
			img.scaleX = OrientX*Scale;
			img.scaleY = Scale;
			
			sortContentLayer();			

			if(LeagueController.getInstance().mode!=LeagueController.IN_LEAGUE)
			addGemEffect();
			
			//Add bóng
			var isDeadFish:Boolean = (Emotion == DEAD);
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
			
			//Add effect Ngoc An
			if (EquipmentList && EquipmentList["Seal"] && EquipmentList["Seal"][0])
			{
				var activeRowSeal:int = Ultility.getActiveRowSeal(EquipmentList["Seal"][0], this);
				if (activeRowSeal > 0)
				{
					if(wings != null && wings.img != null && img.contains(wings.img))
					{
						img.removeChild(wings.img);
					}
					var wingName:String =  "Wings" + EquipmentList["Seal"][0]["Rank"] + activeRowSeal;
					if (EquipmentList["Seal"][0].Color >= 5)
					{
						wingName =  "Wings" + EquipmentList["Seal"][0]["Rank"] + 6;
					}
					wings = new FishWings(this.img, wingName);
					wings.img.mouseEnabled = false;
					wings.img.mouseChildren = false;
					if (img != null && img.contains(wings.img))
					{
						img.setChildIndex(wings.img, 0);
					}
					
					switch(Element)
					{
						case 4:
						case 2:
						case 1:
							//wings.y = -30;
							wings.img.y = -30;
							//wings.x = 16;
							wings.img.x = 16;
							break;
						case 3:
							//wings.y = -40;
							wings.img.y = -40;
							//wings.x = -16;
							wings.img.x = -16;
							break;
						case 5:
							//wings.y = -25;
							wings.img.y = -25;
							//wings.x = 20;
							wings.img.x = 20;
							break;
					}
					//img.addChild(wings.img);
				}
			}
			
			//Tên cá
			if (FishWorldController.GetSeaId() != Constant.OCEAN_FOREST || 
				(FishWorldController.GetSeaId() == Constant.OCEAN_FOREST &&
				isActor == ACTOR_MINE)) 
			{
				if (nameSoldier == null || nameSoldier == "")
				{
					nameSoldier = "Tiểu " + Ultility.GetNameElement(Element) + " Ngư";
				}
				if (nameSoldier.length > 15)
				{
					nameSoldier = nameSoldier.substr(0, 11) + "...";
				}
				txtFieldName = new TextField();
				txtFieldName.text = nameSoldier;
				txtFieldName.mouseEnabled = false;
				txtFieldName.autoSize = TextFieldAutoSize.CENTER;
				txtFieldName.maxChars = 16;
				txtFieldName.height = 30;
				var txtFormat:TextFormat = new TextFormat("arial", 14, 0xffffff, true);
				txtFormat.align = "center";
				txtFieldName.setTextFormat(txtFormat);	
				var outline:GlowFilter = new GlowFilter();
				outline.blurX = outline.blurY = 3.5;
				outline.strength = 8;
				outline.color = 0x000000;
				var arr:Array = [];
				arr.push(outline);
				txtFieldName.antiAliasType = AntiAliasType.ADVANCED;
				txtFieldName.filters = arr;
						
				txtFieldName.x = -40;
				txtFieldName.y = -60;
				aboveContent.addChild(txtFieldName);
			}
			
			// Uy danh
			updateReputation();
		}
		
		public function updateReputation():void 
		{
			var fameLevel:int = 0;
			if (reputationLevel > 0)
			{
				fameLevel = reputationLevel;
			}
			else if (!GameLogic.getInstance().user.IsViewer())
			{
				if (FishWorldController.GetSeaId() >= 1)
				{
					if (isActor == ACTOR_MINE)
					{
						fameLevel = GameLogic.getInstance().user.getReputationLevel();
					}
				}
				else
				{
					fameLevel = GameLogic.getInstance().user.getReputationLevel();
				}
			}
			else
			{
				if (isActor == ACTOR_MINE)
				{
					fameLevel = GameLogic.getInstance().user.getReputationLevel();
				}
				else// if (isActor == ACTOR_THEIRS)
				{
					fameLevel = GameLogic.getInstance().user.getReputationLevel(false);
				}
			}
			if (fameLevel > 1)
			{
				if (reputation && reputation.img && reputation.img.parent)
				{				
					aboveContent.removeChild(reputation.img);
					reputation = null;
				}
				reputation = new Image(aboveContent, "fameTitle" + (fameLevel), 0, -55, true, ALIGN_LEFT_TOP, true);
				reputation.img.mouseEnabled = false;
				reputation.img.mouseChildren= false;
				if(fameLevel <= 9)
				{
					reputation.SetScaleXY(0.7);
				}
				txtFieldName.x = 0;
				
				//var minh:int = reputation.img.width + txtFieldName.width;
				//reputation.SetPos(minh / 2);
			}
			UpdateBonusReputation();
		}
		
		public override function OnFinishDrag():Boolean
		{
			GameLogic.getInstance().CountHerd = 0;
			ChangeLayerAttachConent(Constant.OBJECT_LAYER);
			this.SetMovingState(FS_SWIM);
			this.SetHighLight( -1);
			dragingFish = null;
			
			if (GuiMgr.getInstance().GuiMain.MovedFishLake >= 0)
			{
				return GuiMgr.getInstance().GuiMain.ChangeLakeSoldier(GuiMgr.getInstance().GuiMain.MovedFishLake, this);
			}
			if (img.x > SwimingArea.right || img.x < SwimingArea.left || 
				img.y < SwimingArea.top || img.y > SwimingArea.bottom)
					return false;
					
			return true;
		}		
		
		/**
		 * Set thông tin bổ sung cho cá lính
		 */
		public function SetSoldierInfo(newRank:int = 0):void
		{
			var cfg:Object = ConfigJSON.getInstance().GetFishRankInfo(Rank);
			// Nếu update lại khi cá lên cấp thì cộng thêm Dmg
			if (newRank != 0)
			{
				while (Rank < newRank)
				{
					RankPoint -= MaxRankPoint;
					Rank++;
					cfg = ConfigJSON.getInstance().GetFishRankInfo(Rank);
					//trace("SetSoldierInfo RateDamage== " + cfg.RateDamage + " |Damage== " + Damage);
					Damage += Math.ceil(cfg.RateDamage * Damage);
					Defence += Math.ceil(cfg.RateDefence * Defence);
					Critical += Math.ceil(cfg.RateCritical * Critical);
					Vitality += Math.ceil(cfg.RateVitality * Vitality);
					MaxRankPoint = cfg["PointRequire"];
					
				}
				MaxHealth = cfg["MaxHealth"];
				MaxRankPoint = cfg["PointRequire"];
				HealthRegenCooldown = cfg["RegenTime"];
				AttackPoint = cfg["AttackPoint"];
				Rate = cfg["Rate"];
				MaxTimeFail = cfg["TurnDefend"];
				
				// Lên cấp chỉ là lên cấp cá của mình lên cập nhật vào mảng MySoldierArr
				for (var i:int = 0; i < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; i++)
				{
					if (GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i].Id == this.Id)
					{
						var fPointer:FishSoldier = GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i];
						fPointer.Rank = this.Rank;
						fPointer.RankPoint = this.RankPoint;
						
						fPointer.MaxHealth = this.MaxHealth;
						fPointer.MaxRankPoint = this.MaxRankPoint;
						fPointer.HealthRegenCooldown = this.HealthRegenCooldown;
						fPointer.AttackPoint = this.AttackPoint;
						fPointer.Rate = this.Rate;
						fPointer.MaxTimeFail = this.MaxTimeFail;
						
						fPointer.Damage = this.Damage;
						fPointer.Defence = this.Defence;
						fPointer.Critical = this.Critical;
						fPointer.Vitality = this.Vitality;
					}
				}
			}
			
			
			MaxHealth = cfg["MaxHealth"];
			MaxRankPoint = cfg["PointRequire"];
			HealthRegenCooldown = cfg["RegenTime"];
			AttackPoint = cfg["AttackPoint"];
			Rate = cfg["Rate"];
			MaxTimeFail = cfg["TurnDefend"];
		
			AlmostDieTime = -1 * ConfigJSON.getInstance().GetItemList("Param").ClinicalTime;
			
			//if (Status == STATUS_HEALTHY || Status == STATUS_REVIVE)
			{
				CheckHealth();
			}
			UpdateBonusReputation();
		}
		
		public override function SetEmotion(emotion:String):void
		{
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
			if (State != FS_STANDBY || !isInRightSide)
				PrepareMoving(DesPos);
			RefreshImg();
		}
		
		/**
		 * Set thông tin đồ đạc
		 */
		public function SetEquipmentInfo(obj:Object):void
		{
			var s:String;
			if (!EquipmentList)
			{
				EquipmentList = new Object();
			}
			else
			{
				for (s in EquipmentList)
				{
					delete(EquipmentList[s]);
				}
			}
			
			for (var k:int = 0; k < FishEquipment.EquipmentTypeList.length; k++)
			{
				s = FishEquipment.EquipmentTypeList[k];
				EquipmentList[s] = new Array();
			}
			
			for (s in obj)						// type 
			{
				if (s != "Mask")
				{
					for (var s1:String in obj[s])	// Id
					{
						var eq:FishEquipment = new FishEquipment();
						eq.SetInfo(obj[s][s1]);
						eq.SetFishOwn(this);
						EquipmentList[s].push(eq);
					}
				}
				else if (s == "QWhite")
				{
					trace("");
				}else
				{
					for (var s2:String in obj[s])	// Id
					{
						var mask:FishEquipmentMask = new FishEquipmentMask();
						mask.SetInfo(obj[s][s2]);
						//if (mask.FishOwn == null || img)
						//if (img)
						{
							mask.SetFishOwn(this);
						}
						EquipmentList[s].push(mask);
					}
				}
			}
			
			UpdateBonusEquipment();
		}
		
		/**
		 * Check cá còn chiến đấu đc hay ko trả về 0 -> 1
		 * @return
		 */
		//public function IsHealthy():Number
		//{
			//return Health / MaxHealth;
			//return Health;
		//}
		
		public function IsHealthy():Boolean
		{
			if (GameLogic.getInstance().user.IsViewer() && Health >= AttackPoint)
			{
				return true;
			}
			else if (!GameLogic.getInstance().user.IsViewer() && Health >= 2 * AttackPoint)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * Check cá đã ở trạng thái vật vờ chờ chết hay chưa
		 * @param	isUpdate	co gui goi tin len server hay ko
		 * @return
		 */
		public function CheckStatus(isUpdate:Boolean = true):int
		{
			var deltaT:int = 5;
			
			if (!Ultility.IsInMyFish() && isActor != ACTOR_MINE && img)
			{
				return STATUS_HEALTHY;
			}
			var CurStatus:int = Status;
			/*var time:Number = GameLogic.getInstance().CurServerTime;
			TimeLeft = OriginalStartTime + LifeTime - GameLogic.getInstance().CurServerTime + deltaT;

			if (TimeLeft > 0)
			{
				Status = STATUS_HEALTHY;
			}
			else if (TimeLeft > AlmostDieTime)
			{
				if (SoldierType != SOLDIER_TYPE_MIX)
				{
					//Status = STATUS_DEAD;
				}
				else
				{
					Status = STATUS_REVIVE;
				}
			}
			else
			{
				Status = STATUS_REVIVE;
				//Status = STATUS_DEAD;
			}
			
			//if ((CurStatus != Status) && (CurStatus != 0) && isUpdate && img && img.visible)
			if ((CurStatus != Status) && (CurStatus != 0) && isUpdate)
			{
				var uId:String;
				// Gửi gói tin update trạng thái
				if (isActor == ACTOR_MINE)
				{
					uId = GameLogic.getInstance().user.GetMyInfo().Id + "";
				}
				else
				{
					uId = GameLogic.getInstance().user.Id + "";
				}
				var up:SendUpdateExpiredSoldier = new SendUpdateExpiredSoldier(Id, LakeId, uId);
				Exchange.GetInstance().Send(up);
			}*/
			
			// Cởi đồ ra nếu nó còn mặc
			if (Status == STATUS_DEAD && SoldierType == SOLDIER_TYPE_MIX)
			{
				UnWareAllEquipment();
			}
			
			return Status;
		}
		
		/**
		 * Cởi hết đồ cá lính ra cho vào kho
		 */
		public function UnWareAllEquipment():void
		{
			var i:int;
			var s:String;
			for (s in EquipmentList)
			{
				for (i = EquipmentList[s].length - 1; i >= 0; i--)
				{
					if (!GameLogic.getInstance().user.IsViewer() || isActor == ACTOR_MINE)
					{
						GameLogic.getInstance().user.UpdateEquipmentToStore(EquipmentList[s][i], true);
					}
					EquipmentList[s].splice(i, 1);
				}
			}
		}

		public override function Growth():Number
		{
			// Luôn luôn lớn
			return 1;
		}
		
		public override function FollowFood(food:Food):void
		{
			
		}
		
		/**
		 * Add cái effect khi dc búp gem
		 */
		public function addGemEffect(isOverride:Boolean = false, isInLake:Boolean = true):void
		{
			if (!isOverride && GemEffect != null)	return;
			if (!GemList) return;
			
			for (var s:String in GemList)
			{
				if (!GemList[s][0])	continue;
				if (GemList[s][0]["Turn"] && GemList[s][0]["Turn"] > 0)
				{
					// Nếu đã add Effect rồi
					if (GemEffect != null && EffectType == parseInt(s))
					{
						return;
					}
					
					if (GemEffect != null && GemEffect.parent != null)
					{
						GemEffect.parent.removeChild(GemEffect);
						GemEffect = null;
					}
					
					GemEffect =  ResMgr.getInstance().GetRes("EffBuffGem") as Sprite;
					GemEffect.blendMode = BlendMode.LIGHTEN;
					GemEffect.scaleX = GemEffect.scaleY = 0.6;
					GemEffect.transform.colorTransform = ColorTransformGemEffect(parseInt(s));
					var delta:Point = GetGemEffectPosition();
					GemEffect.x = delta.x;
					GemEffect.y = delta.y;
					GemEffect.mouseEnabled = false;
					GemEffect.mouseChildren = false;
					GemEffect.name = "GemEffect";
					//if(isInLake)
					//{
						aboveContent.addChild(GemEffect);	
					//}
					//else 
					if(!isInLake)
					{
						GuiMgr.getInstance().GuiFishWarBoss.GetImage(GUIFishWarBoss.IMG_CUR_FISH_SOLDIER).img.addChild(GemEffect);
					}
					updateAttachContent();	
				}
			}
		}
		
		/**
		* Hàm sắp xếp cá lính theo thứ tự:
		* - Đối với các cá còn sức khỏe: Các cá có lực chiến cao ở đầu mảng
		* - Các cá có cùng lực chiến: sắp xếp theo thứ tự thuộc tính ưu tiên
		* @param	arr		Mảng cá lính cần sắp xếp
		* @param	doubleAttackPoint	tính theo 2 attackpoint hay atkpoint
		* @param	byDmg	Sắp xếp theo Atk hay Def
		* @return	Mảng cá còn sức chiến đấu đã sắp xếp
		*/
		public static function SortFishSoldier(arr:Array, doubleAttackPoint:Boolean = true, byDmg:Boolean = true):Array
		{
			var arrReturn:Array = [];
			var ftemp:FishSoldier;
			var i:int;
			var j:int;
			
			for (i = 0; i < arr.length; i++)
			{
				var fsoldier:FishSoldier = arr[i];
				fsoldier.UpdateHavestTime();
				if(Ultility.IsInMyFish())
				{
					if (fsoldier.Status == STATUS_HEALTHY)
					{
						if (doubleAttackPoint && fsoldier.Health >= (2 * fsoldier.AttackPoint))
						{
							arrReturn.push(arr[i]);
						}
						else if (!doubleAttackPoint && fsoldier.Health >= fsoldier.AttackPoint)
						{
							arrReturn.push(arr[i]);
						}
					}
				}
				else 
				{
					if (fsoldier.Status == STATUS_HEALTHY)
					{
						// Nếu như sức khỏe không đủ thì không cho đi
						if (doubleAttackPoint && fsoldier.Health >= (2 * fsoldier.AttackPoint))
						{
							arrReturn.push(arr[i]);
						}
						else if (!doubleAttackPoint && fsoldier.Health >= fsoldier.AttackPoint)
						{
							arrReturn.push(arr[i]);
						}
					}
				}
			}
			
			var bestSoldier:FishSoldier = arrReturn[0];
			var bestId:int = 0;
			if (arrReturn[bestId])
			{
				for (i = 0; i < arrReturn.length; i++)
				{
					if (arrReturn[bestId].Rank < arrReturn[i].Rank)
					{
						bestId = i;
						continue;
					}
					else if (arrReturn[bestId].Rank == arrReturn[i].Rank)
					{
						if (arrReturn[bestId].RankPoint < arrReturn[i].RankPoint)
						{
							bestId = i;
							continue;
						}
						else if (arrReturn[bestId].RankPoint == arrReturn[i].RankPoint)
						{
							if (arrReturn[bestId].Id < arrReturn[i].Id)
							{
								bestId = i;
								continue;
							}
						}
					}
				}
				
				if (bestId != 0)
				{
					ftemp = arrReturn[0];
					arrReturn[0] = arrReturn[bestId];
					arrReturn[bestId] = ftemp;
				}
			}
			
			//for (i = 0; i < arrReturn.length; i++)
			//{
				//for (j = i + 1; j < arrReturn.length; j++)
				//{
					//var fi:FishSoldier = arrReturn[i];
					//var fj:FishSoldier = arrReturn[j];
					//var totalDmgI:int = fi.Damage + fi.bonusEquipment.Damage + fi.DamagePlus;
					//var totalDmgJ:int = fj.Damage + fj.bonusEquipment.Damage + fj.DamagePlus;
					//var totalDefI:int = fi.Defence + fi.bonusEquipment.Defence + fi.DefencePlus;
					//var totalDefJ:int = fj.Defence + fj.bonusEquipment.Defence + fj.DefencePlus;
					//
					//if (arrReturn[i].Rank < arrReturn[j].Rank)
					//{
						//ftemp = arrReturn[i];
						//arrReturn[i] = arrReturn[j];
						//arrReturn[j] = ftemp;
						//continue;
					//}
					//
					//if (arrReturn[i].RankPoint < arrReturn[j].RankPoint)
					//{
						//trace("chuyen " + fi.Id + " sang " + fj.Id);
						//ftemp = arrReturn[i];
						//arrReturn[i] = arrReturn[j];
						//arrReturn[j] = ftemp;
						//continue;
					//}
					//
					//if (arrReturn[i].Id < arrReturn[j].Id)
					//{
						//ftemp = arrReturn[i];
						//arrReturn[i] = arrReturn[j];
						//arrReturn[j] = ftemp;
						//continue;
					//}
				//}
			//}
			return arrReturn;
		}
		
		public static function FindBestSoldier(arr:Array, isDouble:Boolean = true):FishSoldier
		{
			var a:Array = SortFishSoldier(arr, isDouble);
			
			if (a[0])
			{
				return a[0];
			}
			return null;
		}
		
		/**
		 * Cập nhật điểm chiến công của cá lính!
		 * @param	num:	điểm chiến công
		 */
		public function UpdateKillMarkPoint(num:Number):void
		{
			RankPoint += num;
			if (RankPoint < 0) 
			{
				RankPoint == 0;
			}
			if (RankPoint >= MaxRankPoint)
			{
				if (SoldierType != SOLDIER_TYPE_HIRE)
				{
					var cfg:Object = ConfigJSON.getInstance().GetFishRankInfo(Rank + 1);
					if (!cfg)	return;
					
					if (img)	// Chặn những con cá ở trong mảng logic gửi gói tin lên (duplicate)
					{
						// Gửi gói tin lên lon
						//var UpLon:SendLevelUpSoldier = new SendLevelUpSoldier(Id, LakeId);
						//Exchange.GetInstance().Send(UpLon);
						
						// Add effect lên lon
						var dob:DisplayObject = aboveContent.addChild(ResMgr.getInstance().GetRes("EffLevelUp") as Sprite);
						dob.name = "EffLevelUp";
						levelUpTime = GameLogic.getInstance().CurServerTime;
						
						// Rung màn hình
						GameController.getInstance().shakeScreen(10, 2, 20, false);
						
						// Feed tường
						GuiMgr.getInstance().GuiFeedWall.ShowFeed("UpRankSoldier", Localization.getInstance().getString("FishSoldierRank" + Rank));
						
						// Cập nhật info mới theo cấp mới
						SetSoldierInfo(Rank+1);
					}
				}
				else
				{
					//RankPoint = MaxRankPoint;
				}
			}
		}
		
		public function UpdateHealth(num:int):void
		{
			Health += num;
			if (Health < 0)
			{
				Health = 0;
			}
			if (Health > MaxHealth)
			{
				Health = MaxHealth;
			}
			
			// Nếu đủ sức khỏe thì bỏ cái emo hết SK đi
			if (isActor == ACTOR_MINE)
			{
				if (Health >= 2 * AttackPoint)
				{
					SetEmotion(IDLE);
				}
			}
			else
			{
				if (Health >= AttackPoint)
				{
					SetEmotion(IDLE);
				}
			}
			
			// Nếu con cá này chưa dc chọn để đánh nhau nhưng nó vừa hồi máu -> check xem có đổi con cá mạnh nhất hay ko
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
			{
				return;
			}
			if (isActor == ACTOR_MINE)
			{
				// Nếu là cá lính mà mình sang, trong trường hợp hồi máu đủ mà chưa có con cá nào dc select -> select con này luôn
				if (Health >= 2 * AttackPoint && num > 0)
				{
					//if (Emotion == WEAK)
					//{
						//SetEmotion(IDLE);
					//}
					
					//if ((!GameLogic.getInstance().user.CurSoldier[0] 
						//|| GameLogic.getInstance().user.CurSoldier[0].Health < GameLogic.getInstance().user.CurSoldier[0].AttackPoint 
						//|| GameLogic.getInstance().user.CurSoldier[0].Status != STATUS_HEALTHY))
					if (!GameLogic.getInstance().user.CurSoldier[0])
					{
						GameLogic.getInstance().user.CurSoldier[0] = this;
						GameLogic.getInstance().user.CurSoldier[0].isChoose = true;
					}
				}
				//else 
				//{
					//if (Status == STATUS_REVIVE)
					//{
						//SetEmotion(REVIVE);
					//}
					//else if (Health < 2 * AttackPoint)
					//{
						//SetEmotion(WEAK);
					//}
				//}
			}
			else
			{
				if (Health >= AttackPoint && GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR && img)
				{
					UpdateFishInCombat();
				}
			}
			
			//if (Health <= AttackPoint && GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR && isActor != ACTOR_MINE && img != null)
			//{
				//UpdateFishInCombat();
			//}
		}
		
		override public function UpdateFish():void 
		{
			super.UpdateFish();
			CheckStatus(false);
			CheckMask();
			
			// Check thời gian để xóa effect lên cấp cá đi
			if (aboveContent.getChildByName("EffLevelUp"))
			{
				var mv:MovieClip = aboveContent.getChildByName("EffLevelUp") as MovieClip;
				if (mv.currentFrame == mv.totalFrames)
				{
					aboveContent.removeChild(aboveContent.getChildByName("EffLevelUp"));
				}
				//if (GameLogic.getInstance().CurServerTime > levelUpTime + 5)
				//{
					//aboveContent.removeChild(aboveContent.getChildByName("EffLevelUp"));
				//}
			}
			
			// Fill lại máu cho cá lính
			//if (this && this.GuiFishStatus && this.GuiFishStatus.prgHP 
				//&& this.GuiFishStatus.prgHP.GetStatus() <= 0)
			//{
				//isHpRecharging = true;
			//}
			//if (isHpRecharging)
			//{
				//this.GuiFishStatus.prgHP.setStatus(Math.min(this.GuiFishStatus.prgHP.GetStatus() + 0.01, 1));
				//GameLogic.getInstance().SetColorPrg(this.GuiFishStatus.prgHP, this.GuiFishStatus.prgHP.GetStatus(), Constant.TYPE_PRG_HP);
				//if (this.GuiFishStatus.prgHP.GetStatus() >= 1)
				//{
					//isHpRecharging = false;
				//}
			//}
		}
		
		public function CheckHealth():void
		{
			if (Health < MaxHealth)
			{
				var hptime:int = Math.max(GameLogic.getInstance().CurServerTime - LastHealthTime, 0);
				var hprg:int = Math.floor(hptime / HealthRegenCooldown);
				if (hprg != 0)
				{
					UpdateHealth(hprg);
					LastHealthTime += hprg * HealthRegenCooldown;
				}
			}
		}
		
		/**
		 * Nhận phần thưởng def hồ thành công
		 */
		public function GetRewards():void
		{
			var sendMsg: SendGetBonusSoldier = new SendGetBonusSoldier(Id, GameLogic.getInstance().user.CurLake.Id);
			Exchange.GetInstance().Send(sendMsg);
			var maxExp:int;
			var maxHonour:int;
			var configMax:Object = ConfigJSON.getInstance().getItemInfo("DefenceSoldier", Rank);
			maxExp = configMax["LimitExp"];
			maxHonour = configMax["LimitRank"];
			var i: int = 0;
			for (i = 0; i < Bonus.length; i++ )
			{
				var mat:FallingObject;
				var j: int;
				var obj: Object = Bonus[i] as Object;
				
				switch (obj["ItemType"])
				{
					case "Rank":
						if(obj["Num"] < maxHonour)
						{
							UpdateKillMarkPoint(obj["Num"]);
						}
						else
						{
							UpdateKillMarkPoint(maxHonour);
						}
						break;
					case ("Material"):
					case ("EnergyItem"):
						for (j = 0; j < obj["Num"]; j++ )
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + obj["ItemId"], CurPos.x, CurPos.y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						if (GuiMgr.getInstance().GuiStore.IsVisible)
						{
							GuiMgr.getInstance().GuiStore.Hide();
							//GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);
						}
						break;
					case "Money":
						EffectMgr.getInstance().fallFlyMoney(CurPos.x, CurPos.y, obj["Num"]);
						break;
					case "Exp":
						if(obj["Num"] < maxExp)
						{
							EffectMgr.getInstance().fallFlyXP(CurPos.x, CurPos.y, obj["Num"], true);
						}
						else
						{
							EffectMgr.getInstance().fallFlyXP(CurPos.x, CurPos.y, maxExp, true);
						}
						break;
				}
			}
			
			if (Bonus.length > 0)
			{
				SetEmotion(HAPPY);
			}
			else
			{
				SetEmotion(IDLE);
			}
			Bonus.splice(0, Bonus.length);
			Diary.splice(0, Diary.length);
			SetHighLight( -1);
			//SetMovingState(FS_SWIM);
		}
		
		public function fallSoldier():void
		{
			if (CurPos.y < fallPos.y)
			{
				SetPos(fallPos.x, fallPos.y);
			}
		}
		
		/**
		 * Hồi máu cho cá lính bằng gem thủy
		 */
		public function UseWaterGem(level:int):void
		{
			//var ItemId:int = GuiMgr.getInstance().GuiStoreSoldier.curItemId;
			var ItemId:int = GuiMgr.getInstance().GuiStore.curItemId;
			var hp:int = ConfigJSON.getInstance().GetItemList("Gem")[level][ELEMENT_WATER];
			if (Element == ELEMENT_WATER)
			hp = 2 * hp;
			var user:User = GameLogic.getInstance().user;
			var i:int;
			
			UpdateHealth(hp);
			LastHealthTime = GameLogic.getInstance().CurServerTime;
			
			// Nếu là cá của mình, update vào MySoldierArr
			if (!user.IsViewer() || (user.IsViewer() && isActor == ACTOR_MINE))
			{
				for (i = 0; i < user.GetMyInfo().MySoldierArr.length; i++)
				{
					if (user.GetMyInfo().MySoldierArr[i].Id == Id)
					{
						user.GetMyInfo().MySoldierArr[i].UpdateHealth(hp); 
						user.GetMyInfo().MySoldierArr[i].LastHealthTime = GameLogic.getInstance().CurServerTime;
						break;
					}
				}
			}
			else
			{
				for (i = 0; i < user.FishSoldierAllArr.length; i++)
				{
					if (user.FishSoldierAllArr[i].Id == Id)
					{
						user.FishSoldierAllArr[i].UpdateHealth(hp);
						user.FishSoldierAllArr[i].LastHealthTime = GameLogic.getInstance().CurServerTime;
					}
				}
			}
			if(Ultility.IsInMyFish())
			{
				GuiFishStatus.ShowStatus(this, GUIFishStatus.RECOVER_HEALTH);
			}
		}
		
		/**
		 * Hàm add thông số vào cá khi sử dụng gem
		 */
		public function processBuffGem(isInLake:Boolean = true):void
		{
			if (!isInRightSide && GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				return;
			}
			
			var posStart:Point;
			var posEnd:Point;
			var arrS:Array;
			// Nếu là cá đã thành mộ thì ko làm j dc cả
			if (Status == STATUS_REVIVE)
			{
				posStart = img.localToGlobal(new Point(0, 0));
				posEnd = new Point(posStart.x, posStart.y - 100);
				Ultility.ShowEffText(Localization.getInstance().getString("FishWarMsg30"), img, posStart, posEnd);
				SetHighLight( -1);
				return;
			}
			
			if (Status != STATUS_HEALTHY)
			{
				SetHighLight( -1);
				return;
			}
			
			// Nếu buff cho cá ở TGC thì hiển thị thông báo ko búp dc
			if (isActor == ACTOR_NONE && !Ultility.IsInMyFish() && isInLake)
			{
				GameLogic.getInstance().MouseTransform("");
				var str:String = Localization.getInstance().getString("Message38");
				posStart = img.localToGlobal(new Point(0, 0));
				posEnd = new Point(posStart.x, posStart.y - 100);
				Ultility.ShowEffText(str, img, posStart, posEnd);
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg26"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			var i:int;
			var j:int;
			var s:String;
			var a:Array = GameLogic.getInstance().curItemUsed.split("$");
			var cfg:Object = ConfigJSON.getInstance().GetItemList("Gem");
			var myId:int = GameLogic.getInstance().user.GetMyInfo().Id;

			var curNum:int = 0;
			var weakestId:int = 0;
			var isBuffed:Boolean = false;
			if (GemList[a[1]])
			{
				// Nếu đã buff gem này vào cá rồi -> lấy thông tin số gem đã buff và Id gem yếu nhất
				curNum = GemList[a[1]].length;
				for (j = 0; j < GemList[a[1]].length; j++)
				{
					if (weakestId > GemList[a[1]][j])
					{
						weakestId = GemList[a[1]][j];
					}
				}
			}
			else
			{
				// Nếu chưa buff thì khởi tạo
				GemList[a[1]] = new Array();
				curNum = 0;
			}
			
			if (UserBuff)
			{
				// Kiểm tra mình đã buff vào cá này chưa
				var lastDate:Date = new Date(UserBuff["LastTimeUsed"] * 1000);
				var curDate:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
				
				if (lastDate.day == curDate.day && lastDate.month == curDate.month && lastDate.fullYear == curDate.fullYear)
				{
					if (UserBuff["Elements"] && UserBuff["Elements"][a[1]])
						if (UserBuff["Elements"][a[1]][myId])
						{
							isBuffed = true;
						}
				}
			}
			
			// Nếu buff gem thủy mà mình full HP rồi
			//if (int(a[1]) == ELEMENT_WATER && Health >= MaxHealth)
			//{
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg12"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				//return;
			//}
			
			// Không sử dụng được Mộc Đan với cá nhà mình
			if(isInLake && int(a[1]) == ELEMENT_WOOD)
			{
				if ((!GameLogic.getInstance().user.IsViewer() || isActor == ACTOR_MINE))
				{
					s = Localization.getInstance().getString("FishWarMsg8");
					GuiMgr.getInstance().GuiMessageBox.ShowOK(s, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					//SetMovingState(FS_SWIM);
					SetHighLight( -1);
					return;
				}
			}
			
			// Một số hệ ko thể sử dụng gem này
			if (!CheckCounter(Element, int(a[1])))
			{
				s = Localization.getInstance().getString("FishWarMsg5");
				s = s.replace("@Type", Localization.getInstance().getString("Element" + a[1]));
				s = s.replace("@Element", Localization.getInstance().getString("Element" + Element));
				arrS = s.split(" ");
				s = "";
				for (var k:int = 0; k < arrS.length; k++) 
				{
					s = s + arrS[k] + " ";
					if (k == 5)
					{
						s = s + "\n";
					}
				}
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				var parentObj:DisplayObject = GuiMgr.getInstance().GuiFishWarBoss.img;
				Ultility.ShowEffText(s, parentObj, posStart, posEnd);
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(s, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				//SetMovingState(FS_SWIM);
				SetHighLight( -1);
				return;
			}
			
			// Nếu người chơi đã buff vào cá này rồi  và còn turn
			if (isBuffed && int(a[1]) != ELEMENT_WOOD)
			{
				s = Localization.getInstance().getString("FishWarMsg4");
				s = s.replace("@Type", Localization.getInstance().getString("Element" + a[1]));
				GuiMgr.getInstance().GuiMessageBox.ShowOK(s, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				//SetMovingState(FS_SWIM);
				SetHighLight( -1);
				return;
			}
			
			// Nếu là wood -> kiểm tra đã trừ đủ 50% chưa -> Nếu đủ thì ko cho buff
			//if (int(a[1]) == ELEMENT_WOOD)
			//{
				//UpdateCombatSkill();
				//if (DamagePlus < 0 && Math.abs(DamagePlus) >= Math.ceil(Damage/2))
				//{
					//s = Localization.getInstance().getString("FishWarMsg7");
					//GuiMgr.getInstance().GuiMessageBox.ShowOK(s, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					//SetMovingState(FS_SWIM);
					//SetHighLight( -1);
					//return;
				//}
			//}
			
			// Nếu đã buff đủ
			if (curNum >= Constant.GEM_MAX_PER_ELEMENT)// && weakestId >= int(a[2]) && int(a[1]) != ELEMENT_WOOD)
			{
				s = Localization.getInstance().getString("FishWarMsg3");
				s = s.replace("@Type", Localization.getInstance().getString("Element" + a[1]));
				arrS = s.split(" ");
				s = "";
				for (var kMoc:int = 0; kMoc < arrS.length; kMoc++) 
				{
					s = s + arrS[kMoc] + " ";
					if (kMoc == 6)
					{
						s = s + "\n";
					}
				}
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				Ultility.ShowEffText(s, GuiMgr.getInstance().GuiFishWarBoss.img, posStart, posEnd);
				//SetMovingState(FS_SWIM);
				SetHighLight( -1);
				return;
			}
			
			if (!isBuffed)
			{
				if (UserBuff.length == 0)
				{
					UserBuff = new Object();
					UserBuff["Elements"] = new Object();
					UserBuff["Elements"][a[1]] = new Object();
					UserBuff["Elements"][a[1]]["" + myId] = 0;
					UserBuff["LastTimeUsed"] = GameLogic.getInstance().CurServerTime;
				}
			}
			
			// Gửi gói sử dụng item lên
			var cmd:SendUseGem = new SendUseGem(LakeId, Id, GameLogic.getInstance().user.Id);
			if (isActor == ACTOR_MINE)
			{
				cmd.UserId = GameLogic.getInstance().user.GetMyInfo().Id;
			}
			cmd.SetListGem(int(a[1]), int(a[2]), GuiMgr.getInstance().GuiStore.curItemId);
			Exchange.GetInstance().Send(cmd);
			
			// Cập nhật vào GemList
			if (curNum == Constant.GEM_MAX_PER_ELEMENT)
			{
				// Nếu đã đủ số gem buff vào người cá -> loại bớt gem có thông số thấp nhất
				for (j = 0; j < GemList[a[1]].length; j++)
				{
					if (GemList[a[1]][j] == weakestId)
					{
						GemList[a[1]].splice(j, 1);
						break;
					}
				}
			}
			
			// Gem thủy thì ko cần ghi vào gemlist vì nó sẽ có tác dụng ko theo turn
			//if (int(a[1]) != ELEMENT_WATER)
			{
				var object:Object = new Object();
				object["GemId"] = int(a[2]);
				object["Turn"] = cfg[a[2]]["Turn"];
				GemList[a[1]].push(object);
			}
			
			// Cập nhật UserBuff
			if (isActor != ACTOR_MINE && GameLogic.getInstance().user.IsViewer())
			{
				if (!UserBuff["Elements"])	UserBuff["Elements"] = new Object();
				if (!UserBuff["Elements"][a[1]])
				{
					UserBuff["Elements"][a[1]] = new Object();
					UserBuff["Elements"][a[1]]["" + myId] = 0;
				}
				UserBuff["Elements"][a[1]]["" + myId] += 1;
			}
			
			// Update vào kho
			UpdateStoreItem("Gem$" + a[1] + "$" + a[2], GuiMgr.getInstance().GuiStore.curItemId);
			
			GameLogic.getInstance().user.pearlMgr.usePearlInMyLake(a[1],GuiMgr.getInstance().GuiStore.curItemId, 1, a[2]);
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)	GuiMgr.getInstance().GuiMainFishWorld.UpdateStore();
			
			// Nếu là cá fake -> Cập nhật vào mảng cá thật
			// Nếu ở nhà mình -> buff cá mình -> Cập nhật vào mảng MySoldierArr
			if (!GameLogic.getInstance().user.IsViewer())
			{
				UpdateFishGemList(Id, GameLogic.getInstance().user.GetMyInfo().MySoldierArr, GemList, UserBuff);
			}
			// Nếu ở nhà bạn có các trường hợp: là cá lính nhà bạn hoặc là cá ảo của 1 trong 2 users
			else
			{
				switch (isActor)
				{
					case ACTOR_NONE:
					case ACTOR_THEIRS:
						// Cá ảo nhà bạn
						UpdateFishGemList(Id, GameLogic.getInstance().user.FishSoldierAllArr, GemList, UserBuff);
						break;
					case ACTOR_MINE:
						// Cá ảo nhà mình
						UpdateFishGemList(Id, GameLogic.getInstance().user.GetMyInfo().MySoldierArr, GemList, UserBuff);
						break;
				}
			}
			
			//if (parseInt(a[1]) == ELEMENT_WATER)
			//{
				//UseWaterGem(parseInt(a[2]));
			//}
			
			UpdateCombatSkill();
			if(isInLake)
			{
				if (isActor == ACTOR_NONE && !GameLogic.getInstance().user.IsViewer())
				{
					SetEmotion(HAPPY);
				}
				//SetMovingState(FS_STANDBY);
				ShowEffect(int(a[1]), CurPos);
			}
			
			addGemEffect(true, isInLake);
		}
		
		/**
		 * Hàm sử dụng lọ thảo dược
		 */
		public function processBuffHerbPotion():void
		{
			if (!isInRightSide && GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				return;
			}
			
			var a:Array = GameLogic.getInstance().curItemUsed.split("_");
			
			// Update số lần búp vào con cá
			var eventInfo:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo;
			if (!eventInfo["UseHerbPotion"])
			{
				eventInfo["UseHerbPotion"] = new Object();
			}
			
			if (!eventInfo["UseHerbPotion"][a[1]])
			{
				eventInfo["UseHerbPotion"][a[1]] = 0;
			}
			
			if (!eventInfo["LastTimeUse"])
			{
				eventInfo["LastTimeUse"] = 0;
			}
			
			//var maxUse:int = ConfigJSON.getInstance().GetItemList("HerbPotion")[a[1]].MaxUse;
			//if (eventInfo["UseHerbPotion"][a[1]] >= maxUse)
			//{
				//var p:Point = new Point(137 + 320, 157);
				//var strAnnounce:String = "Đã hết số lần sử dụng " + Localization.getInstance().getString("HerbPotion" + a[1]) + " trong ngày";
				//Ultility.ShowEffText(strAnnounce, this.img, p, new Point(p.x, p.y - 20), new TextFormat("arial", 18, 0xffff00, true), 1, 0x000000);
				//return;
			//}
			
			//eventInfo["UseHerbPotion"][a[1]] += 1;
			
			if (Status != STATUS_HEALTHY)
			{
				SetHighLight( -1);
				return;
			}
			
			// không buff vào dc cá nhà bạn
			if (GameLogic.getInstance().user.IsViewer() && isActor != ACTOR_MINE)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg22"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			GuiMgr.getInstance().GuiSelectNumberHerb.InitData(int(a[1]), LakeId, Id);
			return;
		}
		
		/**
		 * Hàm add thông số vào cá khi sử dụng item
		 */
		public function processBuffItem():void
		{
			if (!isInRightSide && GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				return;
			}
			
			if (Status != STATUS_HEALTHY)
			{
				SetHighLight( -1);
				return;
			}
			// không buff vào dc cá nhà bạn
			if (GameLogic.getInstance().user.IsViewer() && isActor != ACTOR_MINE)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg22"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			var a:Array = GameLogic.getInstance().curItemUsed.split("_");
			var buffList:Array = BuffItem;
			var cfg:Array = ConfigJSON.getInstance().GetBuffItemList();
			cfg = cfg.concat(ConfigJSON.getInstance().getItemInfo("RecoverHealthSoldier", -1));
			var i:int;
			var j:int;
			var str:String ;
			
			// Tính số lượng item này đã dc buff vào con cá
			var curNum:int = 0;
			for (i = 0; i < buffList.length; i++)
			{
				if (buffList[i].ItemId == int(a[1]) && buffList[i].ItemType == a[0])
				{
					curNum = buffList[i].Num;
					break;
				}
			}
			
			// Nếu chưa buff lần nào -> khởi tạo object item này trong fish.BuffItem
			if (i == buffList.length)
			{
				var o:Object = new Object();
				o.ItemType = a[0];
				o.ItemId = int(a[1]);
				o.Num = 0;
			}
			
			for (j = 0; j < cfg.length; j ++)
			{
				if (cfg[j].Id == int(a[1]) && cfg[j].Type == a[0])
				{
					if (i == buffList.length)
					{
						o.Turn = cfg[j].Turn;
						buffList.push(o);
					}
					break;
				}
			}
			
			// Nếu búp vào cá nhà bạn
			if (GameLogic.getInstance().user.IsViewer() && isActor != ACTOR_MINE)
			{
				str = Localization.getInstance().getString("FishWarMsg6");
				GuiMgr.getInstance().GuiMessageBox.ShowOK(str, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				//SetMovingState(FS_SWIM);
				SetHighLight( -1);
				return;
			}
			
			// Nếu đã búp đủ
			if (curNum >= cfg[j].MaxTimes)
			{
				str = Localization.getInstance().getString("FishWarMsg1");
				str = str.replace("@times@", String(cfg[j].MaxTimes));
				GuiMgr.getInstance().GuiMessageBox.ShowOK(str, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				//SetMovingState(FS_SWIM);
				SetHighLight( -1);
				return;
			}
			
			// Gửi gói sử dụng item lên
			var cmd:SendUseItemSoldier = new SendUseItemSoldier(LakeId, Id);
			cmd.SetItemList(cfg[j].Type, cfg[j].Id, 1, cfg[j].Turn);
			Exchange.GetInstance().Send(cmd);
			
			// Update kho
			UpdateStoreItem(cfg[j].Type, cfg[j].Id);
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)	GuiMgr.getInstance().GuiMainFishWorld.UpdateStore();
			
			// Cập nhật vào cá trong hồ
			buffList[i].Num += 1;
			
			// Nếu ở nhà mình -> buff cá mình -> Cập nhật vào mảng MySoldierArr
			if (!GameLogic.getInstance().user.IsViewer())
			{
				UpdateFishBuffItem(Id, GameLogic.getInstance().user.GetMyInfo().MySoldierArr, BuffItem);
			}
			// Nếu ở nhà bạn có các trường hợp: là cá lính nhà bạn hoặc là cá ảo của 1 trong 2 users
			else
			{
				switch (isActor)
				{
					case ACTOR_NONE:
					case ACTOR_THEIRS:
						// Cá ảo nhà bạn
						UpdateFishBuffItem(Id, GameLogic.getInstance().user.FishSoldierAllArr, BuffItem);
						break;
					case ACTOR_MINE:
						// Cá ảo nhà mình
						UpdateFishBuffItem(Id, GameLogic.getInstance().user.GetMyInfo().MySoldierArr, BuffItem);
						break;
				}
			}
			
			UpdateCombatSkill();
			
			if (!GameLogic.getInstance().user.IsViewer() && isActor == ACTOR_NONE)
			{
				SetEmotion(Fish.HAPPY);
			}
			//SetMovingState(FS_STANDBY);
			ShowEffect(Element, CurPos);
		}
		
		/**
		 * Hàm set thông tin buff item vào con cá trong mảng a có ID là Id
		 * @param	Id
		 * @param	a
		 * @param	BuffItem
		 */
		private function UpdateFishBuffItem(Id:int, a:Array, BuffItem:Array):void
		{
			var i:int = 0;
			for (i = 0; i < a.length; i++)
			{
				if (Id == a[i].Id)
				{
					a[i].BuffItem = BuffItem;
				}
			}
		}
		
		/**
		 * Hàm set thông tin GemList vào con cá trong mảng a có Id là Id
		 * @param	Id
		 * @param	a
		 * @param	GemList
		 */
		private function UpdateFishGemList(Id:int, a:Array, GemList:Object, UserBuff:Object):void
		{
			var i:int = 0;
			for (i = 0; i < a.length; i++)
			{
				if (Id == a[i].Id)
				{
					a[i].GemList = GemList;
					a[i].UserBuff = UserBuff;
				}
			}
		}
		
		private function UpdateStoreItem(ItemType:String, ItemId:int, Num:int = -1):void
		{
			//if (GuiMgr.getInstance().GuiStoreSoldier.IsVisible)
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				//GuiMgr.getInstance().GuiStoreSoldier.UpdateStore(ItemType, ItemId, Num);
				GuiMgr.getInstance().GuiStore.UpdateStore(ItemType, ItemId, Num);
			}
			else
			{
				GameLogic.getInstance().user.UpdateStockThing(ItemType, ItemId, Num);
			}
			
			// Nếu item này đã hết
			if (GameLogic.getInstance().user.GetStoreItemCount(ItemType, ItemId) == 0)
			{
				if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
				{
					GameLogic.getInstance().MouseTransform("");
				}
				else
				{
					GameLogic.getInstance().BackToIdleGameState();
				}
			}
		}
		
		/**
		 * Hàm Update DamagePlus và Critical...
		 */
		public function UpdateCombatSkill():void
		{
			DamagePlus = 0;
			CriticalPlus = 0;
			DefencePlus = 0;
			VitalityPlus = 0;
			isResistance = false;
			
			
			var i:int = 0;
			var j:int = 0;
			var s:String;
			var o:Object;
			var cfg:Array;
			
			// Các item buff
			for (i = 0; BuffItem && i < BuffItem.length; i++)
			{
				o = BuffItem[i];
				cfg = ConfigJSON.getInstance().GetBuffItemList();
				switch (o.ItemType)
				{
					case "Samurai":
						for (j = 0; j < cfg.length; j++)
						{
							if (cfg[j].Type == o.ItemType && cfg[j].Id == o.ItemId)
							break;
						}
						DamagePlus += o.Num * cfg[j].Num;
						break;
					case "Resistance":
						isResistance = true;
						break;
				}
			}
			
			// Các gem buff
			// Hỏa: 	tăng lực chiến	x2 Hỏa,		x0 Thủy
			// Thủy: 	hồi sức khỏe	x2 Thủy, 	x0 Thổ
			// Mộc:		giảm lực chiến	x2 Thổ,		x0 Mộc
			// Thổ:		tăng thủ		x2 Thổ,		x0 Mộc
			// Kim:		tăng Crit		x2 Kim,		x0 Hỏa
			for (s in GemList)
			{
				var config:Object;
				config = ConfigJSON.getInstance().GetItemList("Gem");
				for (i = 0; i < GemList[s].length; i++)
				{
					var value:Number = config[GemList[s][i]["GemId"]][s];
					switch (int(s))
					{
						case ELEMENT_METAL:
							if (Element == ELEMENT_METAL)
							{
								CriticalPlus += 2 * value;
							}
							else
							{
								CriticalPlus += value;
							}
							break;
						case ELEMENT_WOOD:
							if (Element == ELEMENT_EARTH)
							{
								DamagePlus += 2 * value;
							}
							else
							{
								DamagePlus += value;
							}
							break;
						case ELEMENT_EARTH:
							// Tỷ lệ def gem
							if (Element == ELEMENT_EARTH)
							{
								DefencePlus += 2 * value;
							}
							else
							{
								DefencePlus += value;
							}
							break;
						case ELEMENT_WATER:
							// Hồi phục máu cho cá
							if (Element == ELEMENT_WATER)
							{
								VitalityPlus += 2 * value;
							}
							else
							{
								VitalityPlus += value;
							}
							break;
						case ELEMENT_FIRE:
							if (Element == ELEMENT_FIRE)
							{
								DamagePlus += 2 * value;
							}
							else
							{
								DamagePlus += value;
							}
							break;
					}
				}
			}
			
			if (DamagePlus <0 && Math.abs(DamagePlus) >  Math.ceil(Damage / 2))
			{
				DamagePlus = -Math.ceil(Damage / 2);
			}
		}
		
		/**
		 * Hàm kiểm tra có buff dc gem vào cá hay ko
		 * @return
		 */
		public function CheckCounter(myElement:int, gemElement:int):Boolean
		{
			switch (gemElement)
			{
				case ELEMENT_METAL:
					if (myElement == ELEMENT_FIRE)
					{
						return false;
					}
					break;
				case ELEMENT_WOOD:
					if (GameLogic.getInstance().user.IsViewer() && isActor == ACTOR_MINE)
					{
						return false;
					}
					if (myElement == ELEMENT_WOOD)
					{
						return false;
					}
					break;
				case ELEMENT_EARTH:
					if (myElement == ELEMENT_WOOD)
					{
						return false;
					}
					break;
				case ELEMENT_WATER:
					if (myElement == ELEMENT_EARTH)
					{
						return false;
					}
					break;
				case ELEMENT_FIRE:
					if (myElement == ELEMENT_WATER)
					{
						return false;
					}
					break;
			}
			return true;
		}
		
		/**
		 * Hàm hiển thị effect khi búp vào cá
		 */
		public function ShowEffect(Element:int, Pos:Point):void
		{
			var d:DisplayObject = ResMgr.getInstance().GetRes("EffAnNgoc") as DisplayObject;
			var colorTransform:ColorTransform = ColorTranformInfo(Element);
			
			d.transform.colorTransform = colorTransform;
			var child:Sprite = new Sprite();
			child.addChild(d);
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER)) as ImgEffectFly;
			eff.SetInfo(Pos.x, Pos.y, Pos.x + 1, Pos.y + 1, 1, -0.03);
		}
		
		/**
		 * Hàm đổi màu effect ăn ngọc từ effect Thủy
		 * @param	IdElement
		 * @return
		 */
		public function ColorTranformInfo(IdElement:int):ColorTransform
		{
			switch (IdElement)
			{
				case ELEMENT_METAL:
					return new ColorTransform(1, 1, 1, 1, 239, 0, -254);
					break;
				case ELEMENT_WOOD:
					return new ColorTransform(1, 1, 1, 1, -42, 255, -255);
					break;
				case ELEMENT_EARTH:
					return new ColorTransform(1, 1, 1, 1, 255, -255, -43);
					break;
				case ELEMENT_WATER:
					return new ColorTransform();
					break;
				case ELEMENT_FIRE:
					return new ColorTransform(0, 0, 0, 1, 255, 5, 0);
					break;
			}
			return new ColorTransform();
		}
		
		public function ColorTransformGemEffect(IdElement:int):ColorTransform
		{
			switch(IdElement)
			{
				case ELEMENT_METAL:
					return new ColorTransform(1, 1, 1, 1, 255, 50, -200);
					break;
				case ELEMENT_WOOD:
					return new ColorTransform(1, 1, 1, 1, 0, 255, -200);
					break;
				case ELEMENT_EARTH:
					return new ColorTransform(1, 1, 1, 1, 120, -200, -150);
					break;
				case ELEMENT_WATER:
					return new ColorTransform();
					break;
				case ELEMENT_FIRE:
					return new ColorTransform(1, 1, 1, 1, 255, -150, -150);
					break;
			}
			return new ColorTransform();
		}
		
		/**
		 * Hàm tạo bóng tỏa cho image
		 * @author	longpt
		 * @param	color	: màu muốn glow
		 * @param	blurx	: tỏa theo x
		 * @param	blury	: tỏa theo y
		 * @param	alpha	: độ trong suốt 0 -> 1
		 */
		public function GlowingEff(mv:MovieClip, blurx:int, blury:int, alpha:Number, strength:Number, color:int = 0x00ffff, quality:int = BitmapFilterQuality.HIGH):void
		{
			var glow:GlowFilter = new GlowFilter();
			glow.blurX = blurx;
			glow.blurY = blury;
			glow.color = color;			
			glow.alpha = alpha;
			glow.strength = strength;
			glow.quality = quality;
			mv.filters = [glow];
		}
		
		/**
		 * Hàm tạo nhòe cho image
		 * @author	longpt
		 * @param	color
		 * @param	blurx
		 * @param	blury
		 * @param	quality
		 */
		public function BluringEff(mv:MovieClip, blurx:int, blury:int, quality:int = BitmapFilterQuality.LOW):void
		{
			var blur:BlurFilter = new BlurFilter();
			blur.blurX = blurx;
			blur.blurY = blury;
			blur.quality = quality;
			mv.filters = [blur];
		}
		
		/**
		 * Hàm trả về vị trí của effect buff gem đối với từng con cá
		 * @param	id
		 */
		public function GetGemEffectPosition():Point
		{
			switch (FishTypeId)
			{
				case 300:
					return new Point(-25, 0);
				case 301:
					return new Point(-5, -10);
				case 302:
					return new Point(0, 10);
				case 303:
					return new Point(-15, -5);
				case 304:
					return new Point(19, 11);
				case 305:
					return new Point(0, 0);
				case 306:
					return new Point(0, 0);
				case 307:
					return new Point(0, 0);
				
				case 320:
					return new Point(0, 0);
				case 330:
					return new Point(0, 0);
				case 340:
					return new Point(0, 0);
				case 350:
					return new Point(0, 0);
				case 360:
					return new Point(10, 0);
			}
			return new Point(0, 0);
		}
		
		/**
		 * Đổi vũ khí trang bị
		 */
		public function ChangeEquipment(eq:FishEquipment):void
		{
			var resName:String = eq.imageName;// + "_Shop";
			var Type:String = eq.Type;
			var Color:int = eq.Color;
			
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(img, Type);
			
			if (child != null)
			{
				var mv:MovieClip = child as MovieClip;
				var item:DisplayObject = mv.getChildByName(Type);
				
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				
				eq.loadComp = function f():void
				{
					if (!child || !child.parent || !eq || !eq.img)
					{
						return;
					}
					var dob:DisplayObject = child.parent.addChildAt(eq.img, index);
					dob.name = Type;
					EquipmentEffect(dob, Color);
					
					child.parent.removeChild(child);
				}
				eq.loadRes(resName);
			}
		}
		
		public static function EquipmentEffect(dob:DisplayObject, color:int):void
		{
			if (color == FishEquipment.FISH_EQUIP_COLOR_GREEN)
			{
				TweenMax.to(dob, 0.1, { glowFilter: { color:0x00ff00, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
			}
			else if (color == FishEquipment.FISH_EQUIP_COLOR_GOLD)
			{
				TweenMax.to(dob, 0.1, { glowFilter: { color:0xffff00, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
			}
			else if (color == FishEquipment.FISH_EQUIP_COLOR_PINK)
			{
				TweenMax.to(dob, 0.1, { glowFilter: { color:0x9900ff, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
			}
			else if (color == FishEquipment.FISH_EQUIP_COLOR_VIP || color == FishEquipment.FISH_EQUIP_COLOR_6)
			{
				//if (dob.name == "Weapon")
				//{
					EquipmentLight(dob);
				//}
				//else
				//{
					//TweenMax.to(dob, 0.1, { glowFilter: { color:0xffffff, alpha:1, blurX:10, blurY:10, strength:2 }} );
				//}
			}
			//else if (color == FishEquipment.FISH_EQUIP_COLOR_6)
			//{
				//TweenMax.to(dob, 0.1, { glowFilter: { color:0xff0000, alpha:1, blurX:10, blurY:10, strength:2 }} );
			//}
		}
		
		public static function EquipmentLight(dob:DisplayObject):void
		{
			var c:ColorTransform = new ColorTransform(0.9, 0.9, 0.9, 1, 255, 99, 0, 0);
			//var c:ColorTransform = new ColorTransform(0.9, 0.9, 0.9, 1, 255, 255, 255, 0);
			dob.transform.colorTransform = c;
			
			var filter:Array = [];
			var glow:GlowFilter = new GlowFilter(0xff9900, 1, 5, 5, 1.7, BitmapFilterQuality.HIGH);
			filter.push(glow);
			
			dob.filters = filter;
		}
		
		public override function UpdateEmotion():void
		{
			// Update trạng thái cảm xúc của cá
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR &&
				GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
			{
				switch(Emotion)
				{
					case HAPPY:
					case LOVE:
					case WAR:
						if (GameLogic.getInstance().CurServerTime > EmoLifeTime && isActor == ACTOR_NONE)
						{
							//switch (CheckStatus())
							switch (Status)
							{
								case STATUS_HEALTHY:
									// Khỏe mạnh
									// Set state hiện tại của cá lính trưởng thành
									if(Ultility.IsInMyFish())
									{
										if (IsHealthy())
										{
											// Nếu cá có quà do def thành công -> Hiển thị emo quà
											if (Diary != null && Diary.length > 0 && !GameLogic.getInstance().user.IsViewer())
											{
												SetEmotion(REWARD);
											}
											else
											{
												SetEmotion(IDLE);
											}
										}
										else
										{
											SetEmotion(WEAK);
										}
									}
									else 
									{
										if(GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
										{
											SetEmotion(IDLE);
										}
									}
									break;
								case STATUS_REVIVE:
									if (isActor == ACTOR_NONE)
									 //Lâm sàng
									SetEmotion(REVIVE);
									break;
								case STATUS_DEAD:
									// Chết
									// Loadres thành mồ
									GameLogic.getInstance().user.FishSoldierExpired.push(this);
									SetEmotion(DEAD);
									
									var ind:int = GameLogic.getInstance().user.FishSoldierArr.indexOf(this);
									if (ind != -1)
									{
										GameLogic.getInstance().user.FishSoldierArr.splice(ind, 1);
									}
									
									 //Xóa khỏi mảng FishSoldierAllArr và MySoldierArr
									if (GameLogic.getInstance().user.IsViewer())
									{
										 //Nhà mình
										for (var k:int = 0; k < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; k++)
										{
											if (Id == GameLogic.getInstance().user.GetMyInfo().MySoldierArr[k].Id)
											{
												GameLogic.getInstance().user.GetMyInfo().MySoldierArr.splice(k, 1);
												break;
											}
										}
									}
									else
									{
										 //Nhà bạn
										for (var j:int = 0; j < GameLogic.getInstance().user.FishSoldierAllArr.length; j++)
										{
											if (Id == GameLogic.getInstance().user.FishSoldierAllArr[j].Id)
											{
												GameLogic.getInstance().user.FishSoldierAllArr.splice(j, 1);
												break;
											}
										}
									}
									
									// Trừ số lượng cá trong hồ
									GameLogic.getInstance().user.CurLake.NumSoldier -= 1;
									GameLogic.getInstance().user.NumSoldier -= 1;
									break;
							}
						}
						break;
				}
			}
			else if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
			{
				
			}
			else // FISH_WAR
			{
				if (isChoose)
				{
					if (isActor == ACTOR_MINE)
					{
						if (Health >= 2 * AttackPoint && Status == STATUS_HEALTHY)
						{
							var ChooseEffect:Sprite;
							if (GuiFishStatus.img)
							ChooseEffect = GuiFishStatus.img.getChildByName("ChooseEffect") as Sprite;
							if (!ChooseEffect)
							{
								ChooseEffect = ResMgr.getInstance().GetRes("EffChooseFish") as Sprite;
								ChooseEffect.scaleY = 0.4;
								ChooseEffect.y = img.height / 2;
								ChooseEffect.name = "ChooseEffect";
								if (GuiFishStatus.img)
								GuiFishStatus.img.addChild(ChooseEffect);
							}
							return;
						}
						
						UpdateFishInCombat(true);
					}
					else if (isInRightSide && img.visible && !isReadyToFight)
					{
						if (Health >= AttackPoint && Status == STATUS_HEALTHY)
						{
							SetEmotion(WAR);
							return;
						}
						
						UpdateFishInCombat();
					}
				}
				else if(GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
				{
					if (GuiFishStatus.img)
					{
						var ChooseEffect1:Sprite;
						ChooseEffect1 = GuiFishStatus.img.getChildByName("ChooseEffect") as Sprite;
						if (ChooseEffect1)
						{
							GuiFishStatus.img.removeChild(ChooseEffect1);
						}
					}
					if(Ultility.IsInMyFish())
					{
						if (Emotion == WAR && isInRightSide && isActor != ACTOR_MINE)
						{
							SetEmotion(IDLE);
							SetMovingState(FS_STANDBY);
						}
						
						if (State != FS_IDLE)
						{
							if (Emotion == WEAK)	return;
							if (Status == STATUS_REVIVE)
							{
								SetEmotion(REVIVE);
							}
							else if ((Health < 2 * AttackPoint && isActor == ACTOR_MINE) || (Health < AttackPoint && isActor != ACTOR_MINE))
							{
								SetEmotion(WEAK);
							}
						}
					}
					else
					{
						if (isActor == ACTOR_NONE)
						{
							SetEmotion(WAR);
						}
						else if(isActor == ACTOR_MINE)
						{
							if (Emotion == WAR && isInRightSide && isActor != ACTOR_MINE)
							{
								SetEmotion(IDLE);
								SetMovingState(FS_STANDBY);
							}
							
							if (State != FS_IDLE)
							{
								if (Emotion == WEAK)	return;
								if (Status == STATUS_REVIVE)
								{
									SetEmotion(REVIVE);
								}
								else if ((Health < 2 * AttackPoint && isActor == ACTOR_MINE) || (Health < AttackPoint && isActor != ACTOR_MINE))
								{
									SetEmotion(WEAK);
								}
							}
						}
					}
					
				}
				else
				{
					if (GuiFishStatus.img)
					{
						var ChooseEffect2:Sprite;
						ChooseEffect2 = GuiFishStatus.img.getChildByName("ChooseEffect") as Sprite;
						if (ChooseEffect2)
						{
							GuiFishStatus.img.removeChild(ChooseEffect2);
						}
					}
					// Nếu như con cá hết sức khỏe thì hiện emotion hết sức khỏe, không thì để idle
					if (Health >= 2 * AttackPoint && Status == STATUS_HEALTHY)
					{
						SetEmotion(IDLE);
					}
					else if (Health < 2 * AttackPoint && Status == STATUS_HEALTHY)
					{
						SetEmotion(WEAK);
					}
				}
			}
		}
		
		public override function OnMouseOutFish():void
		{			
			SetHighLight( -1);
			if (isInRightSide)
			{
				SetMovingState(FS_STANDBY);
			}
			else
			{
				SetMovingState(FS_SWIM);
			}
			GameInput.getInstance().ViewFishInfo(this, false);
		}
		
		public override function processChooseFishWar():void
		{
			if (this is SubBossIce && (this as SubBossIce).PreDie)	
				return;
			if (GameInput.getInstance().lastAttackTime >= GameLogic.getInstance().CurServerTime - Exchange.GetInstance().TIMEOUT / 1000)
			{
				return;
			}
			
			if (GameLogic.getInstance().user.FishSoldierActorMine.length == 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg13"));
				return;
			}
			
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)	return;
			
			if (Emotion != FishSoldier.WAR)
			{
				if (Status == STATUS_REVIVE)
				{
					Chatting("Revive", 3000, 1);
					return;
				}
				
				// Cho cá lảm nhảm đánh cá lính đê
				Chatting("Refuse", 3000, 1);
				return;
			}
			
			var mySoldier:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			if (mySoldier != null) mySoldier.updateReputation();
			if (!mySoldier)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg25"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			// Nếu ko đủ tiền thì cũng ko cho đánh					
			var theirFList:Array = GameLogic.getInstance().user.GetFishArr();
			var moneyR:int = 0;
			if (Ultility.IsInMyFish())
				for (var i:int = 0; i < theirFList.length; i++)
				{
					if (theirFList[i].AgeState != OLD) continue;
					var cfg:Object = ConfigJSON.getInstance().getItemInfo("Fish", theirFList[i].FishTypeId);
					var trustPrice:int = cfg.TrustPrice;
					
					var thisTotal:int = Math.ceil(trustPrice * Constant.MAX_PERCENT_GOLD_CAN_GET / 100);
					var thisLeft:int = thisTotal - theirFList[i].MoneyAttacked;
					thisLeft = Math.max(thisLeft, 0);
					
					var MoneyRequire:int = Math.ceil(Number(mySoldier.Damage / 1000) * mySoldier.Rate * trustPrice);
					if (thisLeft < MoneyRequire)
					{
						MoneyRequire = thisLeft;
					}
					moneyR += MoneyRequire;
				}
			//GameLogic.getInstance().user.MoneyRequire = moneyR;
			if (GameLogic.getInstance().user.GetMyInfo().Money < moneyR)
			{
				var str:String = Localization.getInstance().getString("FishWarMsg16");
				str = str.replace("@Money@", Ultility.StandardNumber(moneyR));
				GuiMgr.getInstance().GuiMessageBox.ShowOK(str, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			var energyCost:int = ConfigJSON.getInstance().getEnergyForAttack(mySoldier.Rank);// ConfigJSON.getInstance().getItemInfo("RankPoint", mySoldier.Rank).AttackEnergy;//Math.floor(mySoldier.Damage / 20);
			if (!Ultility.IsInMyFish() && (!Ultility.IsKillBoss() || (Ultility.IsKillBoss() && isSubBoss)))
			{
				energyCost =  ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillMonster");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillMonster"];
			}
			
			if (energyCost > GameLogic.getInstance().user.GetEnergy())
			{
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 1);
				return;
			}
			
			if (mySoldier.Health < Constant.MIN_HEALTH_SOLDIER)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg9"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
			{
				GuiMgr.getInstance().GuiInfoWarInWorld.ShowDisableScreen(0.01);
			}
			
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			
			GuiMgr.getInstance().GuiFishWar.Init(mySoldier, this);
			
			
		}
		
		/**
		 * Cập nhật trạng thái trận đấu:
		 * Con cá nào đang được chọn để chọi
		 * Hàm này được gọi khi kết thúc 1 combat
		 */
		public function UpdateFishInCombat(mySoldier:Boolean = false):void
		{
			var bestSoldier:FishSoldier;
			var i:int = 0;
			var fs:FishSoldier;		//pointer đến best soldier
			var soldierInLake:Array;// = GameLogic.getInstance().user.GetFishSoldierArr();
			var soldierOtherlake:Array;// = GameLogic.getInstance().user.FishSoldierActorTheirs;
			
			
			if (mySoldier)
			{
				//bestSoldier = FindBestSoldier(GameLogic.getInstance().user.GetMyInfo().MySoldierArr, true);
				bestSoldier = FindBestSoldier(GameLogic.getInstance().user.FishSoldierActorMine, true);
				soldierInLake = GameLogic.getInstance().user.FishSoldierActorMine;
				soldierOtherlake = [];
			}
			else
			{
				bestSoldier = FindBestSoldier(GameLogic.getInstance().user.FishSoldierAllArr, false);
				soldierInLake = GameLogic.getInstance().user.GetFishSoldierArr();
				soldierOtherlake = GameLogic.getInstance().user.FishSoldierActorTheirs;
			}
			
			if (bestSoldier)
			{
				for (i = 0; i < soldierInLake.length; i++)
				{
					if (soldierInLake[i].Id == bestSoldier.Id)
					{
						fs = soldierInLake[i] as FishSoldier;
						break;
					}
				}
				if (!fs)
				{
					for (i = 0; i < soldierOtherlake.length; i++)
					{
						if (soldierOtherlake[i].Id == bestSoldier.Id)
						{
							fs = soldierOtherlake[i] as FishSoldier;
							break;
						}
					}
				}
			}
			
			if (mySoldier)
			{
				if (GameLogic.getInstance().user.CurSoldier[0])
				{
					GameLogic.getInstance().user.CurSoldier[0].isChoose = false;
					GameLogic.getInstance().user.CurSoldier[0] = null;
				}
				
				if (fs)
				{
					GameLogic.getInstance().user.CurSoldier[0] = fs;
					GameLogic.getInstance().user.CurSoldier[0].isChoose = true;
				}
				
				if (Status == STATUS_REVIVE)
				{
					SetEmotion(REVIVE);
				}
				else if (Health < 2 * AttackPoint)
				{
					SetEmotion(WEAK);
				}
				isChoose = false;
				if (fs)
				{
					fs.isChoose = true;
				}
				else
				{
					//GameController.getInstance().UseTool("Peace");
				}
			}
			else
			{
				if (GameLogic.getInstance().user.CurSoldier[1] is FishSoldier)
				{
					GameLogic.getInstance().user.CurSoldier[1] = fs;
				}
				if (Status == STATUS_REVIVE)
				{
					SetEmotion(REVIVE);
				}
				else if (Health < AttackPoint)
				{
					SetEmotion(WEAK);
				}
				isChoose = false;
				if (fs)
				{
					fs.isChoose = true;
				}
				else
				{
					//// Nếu nhà bạn bè ko còn cá thường và cá lính cũng đã hết sức khỏe thì hiện GUI thông báo và trở về nhà
					if (GameLogic.getInstance().user.GetFishArr().length == 0 && Ultility.IsInMyFish())
					{
						var str:String = Localization.getInstance().getString("FishWarMsg20");
						str = str.replace("@Name@", GameLogic.getInstance().user.Name);
						GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(str, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
				}
			}
		}
		
		public override function CheckSwimingArea():void
		{
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST)
			{
				return;
			}
			//if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS ||
				//GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			/*if (!Ultility.IsInMyFish())
				return;*/
			//if (isActor == ACTOR_THEIRS)
			//{
				//trace("Tren trai: " + SwimingArea.topLeft);
				//trace("Duoi phai: " + SwimingArea.bottomRight);
			//}
			var flagX:Boolean = false;
			var flagY:Boolean = false;
			if(CurPos.x <= SwimingArea.left + img.width/2)
			{
				//if (Id == 111)
				//{
					//trace("CurPos.x <= SwimingArea.left + img.width/2");
				//}
				SetPos(SwimingArea.left + img.width/2, CurPos.y);
				if (OrientX < 0)
				{
					flagX = true;
				}
			}
			if (CurPos.x >= SwimingArea.right - img.width/2)
			{
				//if (Id == 111)
				//{
					//trace("CurPos.x >= SwimingArea.right - img.width/2");
				//}
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
				//if (Id == 111)
				//{
					//trace("flagX == true");
				//}
				GoBack();
				//trace("GOback");
			}
			
			if (flagY == true)
			{
				if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR && State == FS_WAR)
				{
					SwimTo(DesPos.x, CurPos.y, realMaxSpeed, true);
				}
				else if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_NORMAL)
				{
					FindDes();
					//trace("FindDes trong CheckSwimingArea");
				}
			}
			//if (Id == 111)
			//{
				//trace ("Id con ca sinh bug " + Id);
				//trace ("Despos " + DesPos);
				//trace ("Standbypos " + standbyPos);
			//}
		}
		
		override public function OnReloadRes():void 
		{
			super.OnReloadRes();
			if (wings != null && img.contains(wings.img))
			{
				img.setChildIndex(wings.img, 0);
			}
		}
		
		public override function OnLoadResComplete():void
		{
			if (wings != null && img.contains(wings.img))
			{
				img.setChildIndex(wings.img, 0);
			}
			if (OnLoadResCompleteFunction != null)
			{
				OnLoadResCompleteFunction();
				OnLoadResCompleteFunction = null;
				//trace("OnLoadResCompleteFunction -> null o FishSoldier.OnLoadResComplete");
			}
		}
		
		// Hàm check có được bảo vệ hay không
		public function CheckProtected():Boolean
		{
			var curDay:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var lastDay:Date = new Date(LastTimeDefendFail * 1000);
			if (curDay.month != lastDay.month || curDay.day != lastDay.day || curDay.fullYear != lastDay.fullYear)
			{
				NumDefendFail = 0;
			}
			
			if (NumDefendFail < MaxTimeFail && Rank > 2)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function CheckMask():void
		{
			if (EquipmentList && EquipmentList.Mask && EquipmentList.Mask[0] && img)
			{
				EquipmentList.Mask[0].UpdateTime();
			}
		}
		
		public function DropGiftHerb(lucky:Array, herbId:int, num:int):void
		{
			var allGift:Array = [];
			
			var j:int;
			var txtFormat:TextFormat;
			var sureGift:Object = ConfigJSON.getInstance().GetItemList("HerbPotion")[herbId]["Sure"];
			
			var objMoneyExp:Object = new Object();
			objMoneyExp["exp"] = 0;
			objMoneyExp["money"] = 0;
			
			for (var s:String in sureGift)
			{
				// Cho quà rơi ra
				var mat:FallingObject;
				
				var obj2:Object = sureGift[s] as Object;
				var obj1:Object = new Object();
				for (var ss:String in obj2)
				{
					obj1[ss] = obj2[ss];
				}
				obj1["Num"] = obj1["Num"] * num;
				/*switch (obj1["ItemType"])
				{
					case "Rank":
						UpdateKillMarkPoint(obj1["Num"]);
						if (obj1["Num"] > 0)
						{
							txtFormat = new TextFormat("Arial", 24, 0x06C417, true);
							txtFormat.align = "center";
							//EffectMgr.getInstance().textFly("+" + obj1["Num"] + " chiến công", p, txtFormat, myFish.aboveContent);
							
							var o:Object = new Object();
							o.str = "+" + obj1["Num"] + " Chiến công";
							o.txtFormat = txtFormat;
							o.pos = new Point(0, -50);
							o.parent = this;
							o.LastEffectTime = GameLogic.getInstance().CurServerTime;
							GameLogic.getInstance().EffectInFishList.push(o);
						}
						break;
					case "Exp":
						objMoneyExp["exp"] = obj1["Num"];
						break;
					case "Money":
						objMoneyExp["money"] = obj1["Num"];
						break;
				}*/
				allGift.push(obj1);
			}
			
			//EffectMgr.getInstance().fallExpMoney(objMoneyExp["exp"], objMoneyExp["money"], new Point (this.img.x, this.img.y), 1, 50);
			//GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + objMoneyExp["exp"]);
			//GameLogic.getInstance().user.UpdateUserMoney(objMoneyExp["money"]);
			
			for (var i:int = 0; i < lucky.length; i++)
			{
				/*switch (lucky[i].ItemType)
				{
					case "Money":
						//EffectMgr.getInstance().fallExpMoney(0, lucky[i].Num, this.CurPos, 1, 1000);
						GameLogic.getInstance().user.UpdateUserMoney(lucky[i].Num);
						break;
					case "Material":
					case "EnergyItem":
						for (j = 0; j < lucky[i].Num; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), lucky[i].ItemType + lucky[i].ItemId, this.img.x, this.img.y);
							mat.ItemType = lucky[i].ItemType;
							mat.ItemId = lucky[i].ItemId;
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						
						// Cập nhật vào kho
						if (GuiMgr.getInstance().GuiStore.IsVisible)
						{
							GuiMgr.getInstance().GuiStore.UpdateStore(lucky[i]["ItemType"], lucky[i]["ItemId"], lucky[i]["Num"]);
						}
						else
						{
							GameLogic.getInstance().user.UpdateStockThing(lucky[i]["ItemType"], lucky[i]["ItemId"], lucky[i]["Num"]);
						}
						break;
					default:
						GameLogic.getInstance().user.GenerateNextID();
						// GuiMgr.getInstance().GuiAnnounceGotGift.showEquipment(lucky[i], 1, Localization.getInstance().getString(lucky[i].Type + lucky[i].Rank));
						
						mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), lucky[i].Type + lucky[i].Rank + "_Shop", this.img.x, this.img.y);
						mat.ItemType = lucky[i].Type;
						mat.ItemId = lucky[i].Rank;
						mat.getDesToFly = function():Point
						{
							var po:Point = new Point(GuiMgr.getInstance().GuiTopInfo.FishWarCtn.img.x, GuiMgr.getInstance().GuiTopInfo.FishWarCtn.img.y);
							po = GuiMgr.getInstance().GuiTopInfo.img.localToGlobal(po);
							po.x += 104;
							po.y -= 11;
							return po;
						}
						//Tên đồ
						var txtName:TextField = new TextField();
						txtName.text = Localization.getInstance().getString(lucky[i].Type + lucky[i].Rank);
						txtFormat = new TextFormat("arial", 15, 0xffffff, true);
						switch(lucky[i].Color)
						{
							case 1:
								txtFormat.color = 0xffffff;
								break;
							case 2:
								txtFormat.color = 0x00ff00;
								break;
							case 3:
								txtFormat.color = 0xffff00;
								break;
						}
						txtFormat.align = "center";
						
						var outline:GlowFilter = new GlowFilter();
						outline.blurX = outline.blurY = 3.5;
						outline.strength = 8;
						outline.color = 0x000000;
						switch (lucky[i].Color)
						{
							case FishEquipment.FISH_EQUIP_COLOR_GREEN:
								outline.color = 0x00ff00;
								break;
							case FishEquipment.FISH_EQUIP_COLOR_GOLD:
								outline.color = 0xffff00;
								break;
							case FishEquipment.FISH_EQUIP_COLOR_PINK:
								outline.color = 0x9900ff;
								break;
						}
						var arr:Array = [];
						arr.push(outline);
						txtName.antiAliasType = AntiAliasType.ADVANCED;
						txtName.filters = arr;
						
						txtName.setTextFormat(txtFormat);
						txtName.autoSize = "center";
						txtName.x = 0;
						txtName.y = -30;
						mat.img.addChild(txtName);
						GameLogic.getInstance().user.fallingObjArr.push(mat);
						break;
				}*/
				
				allGift.push(lucky[i]);
			}
			
			SetMovingState(FS_SWIM);
			SetHighLight( -1);
			
			// Hiện bảng tổng kết
			GuiMgr.getInstance().GuiGetGiftUseHerb.InitAll(allGift, true);
		}
		public function clone():FishSoldier
		{
			var fs:FishSoldier = new FishSoldier(Parent, ImgName);
			for (var itm:String in this)
			{
				try {
					fs[itm] = this[itm];
				}
				catch (err:Error)
				{
					trace("Error khi clone lại : " + this);
				}
			}
			return fs;
		}
		
		public function getTotalDamage():int
		{
			if (LeagueController.getInstance().mode != LeagueController.IN_LEAGUE)
			{
				//trace("getTotalDamage() tren Damage== " + Damage);
				//trace("getTotalDamage() tren OptionDamage== " + bonusEquipment["OptionDamage"] + " |bonusEquipment== " + bonusEquipment["Damage"]);
				//trace("getTotalDamage() tren meridianDamage== " + meridianDamage + " |bonusReputation== " + bonusReputation["Damage"]);
				return Damage + bonusEquipment["Damage"] + DamagePlus + meridianDamage + bonusReputation["Damage"];
			}
			else
			{
				//trace("getTotalDamage() duoi OptionDamage== " + bonusEquipment["OptionDamage"] + " |bonusEquipment== " + bonusEquipment["Damage"]);
				//trace("getTotalDamage() duoi meridianDamage== " + meridianDamage + " |bonusReputation== " + bonusReputation["Damage"]);
				return Damage + bonusEquipment["Damage"] + meridianDamage + bonusReputation["Damage"];
			}
		}
		
		public function getTotalCritical():int
		{
			if (LeagueController.getInstance().mode != LeagueController.IN_LEAGUE)
			{
				return Critical + bonusEquipment["Critical"] + CriticalPlus + meridianCritical + bonusReputation["Critical"];
			}
			else
			{
				return Critical + bonusEquipment["Critical"] + meridianCritical + bonusReputation["Critical"];
			}
		}
		
		public function getTotalDefence():int
		{
			if (LeagueController.getInstance().mode != LeagueController.IN_LEAGUE)
			{
				return Defence + bonusEquipment["Defence"] + DefencePlus + meridianDefence + bonusReputation["Defence"];
			}
			else
			{
				return Defence + bonusEquipment["Defence"] + meridianDefence + bonusReputation["Defence"];
			}
		}
		
		public function getTotalVitality():int
		{
			if (LeagueController.getInstance().mode != LeagueController.IN_LEAGUE)
			{
				return Vitality + bonusEquipment["Vitality"] + VitalityPlus + meridianVitality + bonusReputation["Vitality"];
			}
			else
			{
				return Vitality + bonusEquipment["Vitality"] + meridianVitality + bonusReputation["Vitality"];
			}
		}
		
		public function updateRankPoint(dRankPoint:int):void 
		{
			RankPoint += dRankPoint;
			
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("RankPoint");
			var max:int=-1;
			for (var str:String in cfg) {
				if (max < int(str)) {
					max = int(str);
				}
			}
			if (Rank == max) {
				return;
			}
			var maxRankHere:int;
			var objHere:Object;
			for (var i:int = Rank; i <= max; i++) 
			{
				objHere = cfg[i.toString()];
				
				maxRankHere = objHere["PointRequire"];
				if (RankPoint >= maxRankHere) {
					//tăng rank + công + thủ + chí mạng + máu
					if (Rank == 20) {
						break;
					}
					Rank++;
					//trace("updateRankPoint RateDamage== " + cfg[Rank.toString()]["RateDamage"] + " |Damage== " + Damage);
					Damage += Math.ceil(cfg[Rank.toString()]["RateDamage"] * Damage);
					Defence += Math.ceil(cfg[Rank.toString()]["RateDefence"] * Defence);
					Critical += Math.ceil(cfg[Rank.toString()]["RateCritical"] * Critical);
					Vitality += Math.ceil(cfg[Rank.toString()]["RateVitality"] * Vitality);
					RankPoint -= maxRankHere;
				}
				else {
					break;
				}
			}
			
			MaxHealth = cfg[Rank.toString()]["MaxHealth"];
			//Health = MaxHealth;
			MaxRankPoint = cfg[Rank.toString()]["PointRequire"];
			HealthRegenCooldown = cfg[Rank.toString()]["RegenTime"];
			AttackPoint = cfg[Rank.toString()]["AttackPoint"];
			Rate = cfg[Rank.toString()]["Rate"];
			MaxTimeFail = cfg[Rank.toString()]["TurnDefend"];
			MaxRankPoint = cfg[Rank.toString()]["PointRequire"];
			
		}
		
		public function getJudgedPoint():int
		{
			var reputation:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			var config:Object = ConfigJSON.getInstance().GetItemList("ReputationBuff");
			var reputationDamage:Number = 0;
			var reputationCritical:Number = 0;
			var reputationDefence:Number = 0;
			var reputationVitality:Number = 0;
			
			if(config[reputation] != null)
			{
				config = config[reputation];
				reputationDamage = config["Damage"];
				reputationCritical= config["Critical"];
				reputationDefence= config["Defence"];
				reputationVitality= config["Vitality"];
			}
			
			var damageP:int = Damage + bonusEquipment["Damage"] + meridianDamage + reputationDamage;
			var criticalP:int = Critical + bonusEquipment["Critical"] + meridianCritical + reputationCritical ;
			var defenceP:int = Defence + bonusEquipment["Defence"] + meridianDefence + reputationDefence;
			var vitalityP:int = Vitality + bonusEquipment["Vitality"] + meridianVitality + reputationVitality;
			return Math.ceil(damageP + criticalP + defenceP + vitalityP / 3);
		}
		
	}
}













