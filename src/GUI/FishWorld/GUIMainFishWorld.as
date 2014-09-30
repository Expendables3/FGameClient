package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.LoadingBar;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.ForestWorld.Thicket;
	import GUI.FishWorld.Network.SendLoadOcean;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.FishWorld.GUITooltipMainWorld;
	import Logic.Balloon;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.FishSpartan;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.StockThings;
	import Logic.Ultility;
	import Logic.User;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMainFishWorld extends BaseGUI 
	{
		// Các tham số config vị trí
		// Nút dùng trong kho
		private const BTN_GREEN_X:int = 20;
		private const BTN_GREEN_Y:int = 85;
		
		public var arrPrgBossHealth:Array = [];
		
		public var prgBossHealthIce:ProgressBar = null;
		
		public var prgBossHealthMetal:ProgressBar = null;
		public var prgBossArmorMetal:ProgressBar = null;
		
		private const GUI_STORE_BTN_SUPPORT:String = "Support";
		private const GUI_STORE_BTN_GEM:String = "Gem";
		private static const MaxSlot:int = 5;
		//private static const LowY:int = -29;
		private static const LowY:int = -8;
		//private static const HighY:int = -29;
		private static const HighY:int = -8;
		private static const SlotX0:int = 257;
		private static const SlotY0:int = 28;
		private static const SlotScale:Number = 1;
		private static const SlotDx:int = 5;
		
		public var imgBackground:Image;
		public var iconLogoFishWorld:Image;
		public var listFishInOcean:ListBox;
		public var level:int;
		public var oldLevel:int;
		public var oldScore:int;
		public var score:int;
		public var scoreToLevelUp:int;
		public var oldScoreToLevelUp:int;
		public const PRG_HEALTH_BOSS:String = "PrgHealthPointBoss_";
		public const PRG_ARMOR_BOSS:String = "PrgHealthPointBoss_";
		public const CTN_FISH_SOLDIER:String = "ctnFishSoldier_";
		public const BTN_BACK_FISH_SOLDIER_LIST:String = "btnBackPage";
		public const BTN_NEXT_FISH_SOLDIER_LIST:String = "btnNextPage";
		public const BTN_COME_BACK_MAP:String = "btnComeBackMap";
		//public const BTN_WAR:String = "BtnWar";
		public const GUI_MAIN_BTN_INVENTORY:String = "btnInventory";
		public const GUI_MAIN_BTN_SHOP:String = "btnShop";
		public const IMG_FISH_SOLDIER:String = "imgFishSoldier_";
		public const IMG_TYPE_OCEAN:String = "IcFishWorld_";
		public var btnMapOcean: Button;		
		public var btnExMapOcean: ButtonEx;		
		public var objAllFormula:Object;
		
		public var txtLevel:TextField;
		public var txtScore:TextField;
		public var txtHealthBoss:TextField;
		
		//Fake du lieu
		private var arrMixFormula:Array;
		private var arrFishSoldierUnlock:Array;
		
		public var numFishInOcean:int;
		public var arrFishType:Array;
		
		// Kho dành cho cá lính
		public var CurrentStore:String = GUI_STORE_BTN_SUPPORT; 
		private var MaxPage:int = 1;
		public var CurrentPage:int = 0;
		public var btnSupport:Button;
		public var btnGem:Button;
		
		public var imgSupport:Image;
		public var imgGem:Image;
		
		// Khoảng bay của cá lính nhà mình
		public var MySoldierRectangle:Rectangle; // = new Rectangle(Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2, GameController.getInstance().GetLakeTop() + 110, Main.imgRoot.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 150);
		// Khoảng bay của cá lính nhà bạn
		public var TheirSoldierRectangle:Rectangle; // = new Rectangle(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop() + 110, 280, Constant.HEIGHT_LAKE - 150);		
		// Khoảng bay của cá nông dân nhà bạn (ofcourse)
		public var TheirFishRectangle:Rectangle; // = new Rectangle(Constant.MAX_WIDTH / 2 + 200, GameController.getInstance().GetLakeTop() + 110, Main.imgRoot.stage.width / 2 - 200, Constant.HEIGHT_LAKE - 150);			
		// Khoảng bay lúc tự do
		public var DefaultRectangle:Rectangle; // = new Rectangle(0, GameController.getInstance().GetLakeTop() + 110, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 150);
		
		public var theirSoldierPos:Array = new Array();
		public var mySoldierPos:Array = new Array();
		
		public function GUIMainFishWorld(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMainFishWorld";
		}
		
		public function UpdateGuiInfo():void 
		{
			var i:int = 0;
			for (i = 0; arrPrgBossHealth && i < arrPrgBossHealth.length; i++) 
			{
				var prg:ProgressBar = arrPrgBossHealth[i] as ProgressBar;
				var status:Number = prg.GetStatus();
				var boss:Boss = BossMgr.getInstance().BossArr[i];
				if (status > boss.CurHp / boss.MaxHp)
				{
					prg.setStatus(Math.max((status - 0.05), 0));
					//txtHealthBoss.text = (int(prg.GetStatus() * boss.MaxHp)).toString();
					boss.UpdateStateBossDuringWar();
				}
				else 
				{
					prg.setStatus(boss.CurHp / boss.MaxHp);
					//txtHealthBoss.text = "Máu " + (int(prg.GetStatus() * boss.MaxHp)).toString();
				}
				
				if (boss.objAllBonus)
				{
					if (boss.curPercentGetGift < 100 && prg.GetStatus() * 100 < 95 - boss.curPercentGetGift)
					{
						boss.curPercentGetGift += 5;
						//trace("boss.curPercentGetGift = " + boss.curPercentGetGift);
						//trace("prg.GetStatus() = " + prg.GetStatus());
						GameLogic.getInstance().bonusFishWorld = boss.objAllBonus[boss.curPercentGetGift.toString()];
						GameLogic.getInstance().dropAllGiftFishWorld();
					}
				}
				//trace("txtHealthBoss.text" + txtHealthBoss.text);
			}
			
			if (prgBossHealthMetal && prgBossHealthMetal.img)
			{
				var statusMetal:Number = prgBossHealthMetal.GetStatus();
				var bossMetal:BossMetal = GameLogic.getInstance().user.bossMetal;
				if (statusMetal > bossMetal.CurHp / bossMetal.MaxHp)
				{
					prgBossHealthMetal.setStatus(statusMetal - 0.01);
				}
				else 
				{
					prgBossHealthMetal.setStatus(bossMetal.CurHp / bossMetal.MaxHp);
				}
				
				if (bossMetal.objAllBonus)
				{
					if (bossMetal.curPercentGetGift < 100 && prgBossHealthMetal.GetStatus() * 100 < 95 - bossMetal.curPercentGetGift)
					{
						bossMetal.curPercentGetGift += 5;
						GameLogic.getInstance().bonusFishWorld = bossMetal.objAllBonus[bossMetal.curPercentGetGift.toString()];
						GameLogic.getInstance().dropAllGiftFishWorld();
					}
				}
			}
			
			if (prgBossHealthIce && prgBossHealthIce.img)
			{
				var statusIce:Number = prgBossHealthIce.GetStatus();
				var bossIce:BossIce = GameLogic.getInstance().user.bossIce;
				if (statusIce > bossIce.CurHp / bossIce.MaxHp)
				{
					prgBossHealthIce.setStatus(Math.max(statusIce - 0.05, 0));
					//trace("prgBossHealthIce.GetStatus() = " + prgBossHealthIce.GetStatus());
				}
				else 
				{
					prgBossHealthIce.setStatus(bossIce.CurHp / bossIce.MaxHp);
					//trace("prgBossHealthIce.GetStatus() = " + prgBossHealthIce.GetStatus());
				}
				
				if (bossIce.objAllBonus)
				{
					if (bossIce.curPercentGetGift < 100 && prgBossHealthIce.GetStatus() * 100 < 95 - bossIce.curPercentGetGift)
					{
						bossIce.curPercentGetGift += 5;
						GameLogic.getInstance().bonusFishWorld = bossIce.objAllBonus[bossIce.curPercentGetGift.toString()];
						GameLogic.getInstance().dropAllGiftFishWorld();
					}
				}
				if (prgBossHealthIce.GetStatus() < 0.000005 && bossIce.isCreateNewBoss)
				{
					bossIce.UpdateNewDataBossIce();
				}
			}
		}
		
		public function AddProgressBoss(boss:Boss):ProgressBar 
		{
			var prg:ProgressBar = AddProgress(PRG_HEALTH_BOSS, "PrgHpBoss", 620, -440, this, true);
			prg.SetPosBackGround( -41, -30)
			prg.setStatus(1);
			var format:TextFormat = new TextFormat();
			//txtHealthBoss = AddLabel(boss.CurHp.toString(), 683, -440, 0xFFFFFF, 1, 0x26709C);
			//txtHealthBoss.wordWrap = true;
			//txtHealthBoss.defaultTextFormat = format;	
			//txtHealthBoss.setTextFormat(format);
			return prg;
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("");
			SetPos(0, Constant.STAGE_HEIGHT - 128);
			//InitData();
			
			//imgBackground = AddImage("", "ImgBgGUIMainFishWorld" + GameController.getInstance().typeFishWorld, 0, -27, true, ALIGN_LEFT_TOP);
			imgBackground = AddImage("", "ImgBgGUIMainFishWorld", 0, 0, true, ALIGN_LEFT_TOP);
		
			//AddButton(BTN_COME_BACK_MAP, "BtnMapOcean", 700, - Constant.STAGE_HEIGHT + 128, this);
			//AddButtonEx(BTN_WAR, "BtnWar", 420, 0, this);
			AddButton(GUI_MAIN_BTN_SHOP, "BtnShopWorld", 168, 32, this);
			
			ClearStoreComponent();
			InitStore(CurrentStore, 0);
			
			//btnMapOcean = AddButton(BTN_COME_BACK_MAP, "BtnMapOcean", 660, -35, this);
			
			btnExMapOcean = AddButtonEx(BTN_COME_BACK_MAP, "BtnExMapOcean", 660, 0, this);
			//AddImage("", "IcMoi", 670, -35, true, ALIGN_LEFT_TOP);
			var tt:TooltipFormat;
			tt = new TooltipFormat();
			//tt.text = "Trở về bản đồ\nThế giới cá";
			tt.text = Localization.getInstance().getString("TooltipFishWorld2");
			btnExMapOcean.setTooltip(tt);
			
			//imgBackground = AddImage("", "IcFishWorld_" + GameController.getInstance().typeFishWorld.toString(), 0, 0, true, ALIGN_LEFT_TOP);
		}
		
		public function InitData():void 
		{
			
		}
		
		public function CheckCanCatchEventMouse():Boolean 
		{
			var canCatchMouse:Boolean = true;
			var gameState:int = GameLogic.getInstance().gameState;
			trace("gameState = ",gameState);
			switch (FishWorldController.GetSeaId()) 
			{
				case Constant.OCEAN_FOREST:
					if (gameState == GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_TO_GET_GIFT ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_REACHDES ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_PRE_CREATE_WAR ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_SET_QUEUE_FS_REACHDES ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_REACHDES ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS_WIN ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS ||
						gameState == GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER ||
						gameState == GameState.GAMESTATE_OTHER_BUFF_SOLDIER ||
						gameState == GameState.GAMESTATE_IDLE)
					{
						canCatchMouse = true;
					}
					else 
					{
						canCatchMouse = false;
					}
				break;
			}
			return canCatchMouse;
		}
		
		public function CheckCanCatchEventMouseRecoverHelth():Boolean 
		{
			var canCatchMouse:Boolean = true;
			var gameState:int = GameLogic.getInstance().gameState;
			trace("gameState = ",gameState);
			switch (FishWorldController.GetSeaId()) 
			{
				case Constant.OCEAN_FOREST:
					if (gameState == GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_1 ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_2 ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_IN ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_NO_REACHDES ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_SET_QUEUE_FS_NO_REACHDES ||
						gameState == GameState.GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_NO_REACHDES)
					{
						canCatchMouse = false;
					}
					else 
					{
						canCatchMouse = true;
					}
				break;
			}
			return canCatchMouse;
		}
		
		public function ComeBackMap():void 
		{
			if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)
			{
				GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
			}
			GameController.getInstance().typeFishWorld = Constant.TYPE_MAP;
			if (GuiMgr.getInstance().GuiChooseSerialAttack.IsVisible)	GuiMgr.getInstance().GuiChooseSerialAttack.Hide();
			if (GuiMgr.getInstance().GuiFishWarBoss.IsVisible)	GuiMgr.getInstance().GuiFishWarBoss.Hide();
			if (GuiMgr.getInstance().GuiIntroOcean.IsVisible)	GuiMgr.getInstance().GuiIntroOcean.Hide();
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	GuiMgr.getInstance().GuiInfoWarInWorld.Hide();
			if (GuiMgr.getInstance().GuiMainForest.IsVisible)	GuiMgr.getInstance().GuiMainForest.Hide();
			if (!Ultility.IsInMyFish())
			{
				if(!Ultility.IsKillBoss())
				{
					if (GameLogic.getInstance().isAttacking)		return;
				}
				else 
				{
					if (BossMgr.getInstance().BossArr && BossMgr.getInstance().BossArr.length > 0)
					{
						if ( BossMgr.getInstance().BossArr[0].isAttacking)
						{
							return;
						}
						else 
						{
							BossMgr.getInstance().BossArr[0].ResetAll();
						}
					}
					
					var i:int = 0;
					if (GameLogic.getInstance().user.bossMetal)
					{
						GameLogic.getInstance().user.bossMetal.ResetAll();
						GameLogic.getInstance().user.bossMetal.Destructor();
						GameLogic.getInstance().user.bossMetal = null;
					}
					
					if (GameLogic.getInstance().user.arrSubBossMetal && GameLogic.getInstance().user.arrSubBossMetal.length > 0)
					{
						for (i = 0; i < GameLogic.getInstance().user.arrSubBossMetal.length; i++) 
						{
							(GameLogic.getInstance().user.arrSubBossMetal[i] as SubBossMetal).Destructor();
						}
						GameLogic.getInstance().user.arrSubBossMetal.splice(0, GameLogic.getInstance().user.arrSubBossMetal.length);
					}
					
					if (GameLogic.getInstance().user.bossIce)
					{
						GameLogic.getInstance().user.bossIce.ResetAll();
						GameLogic.getInstance().user.bossIce.Destructor();
						GameLogic.getInstance().user.bossIce = null;
					}
					
					if (GameLogic.getInstance().user.arrSubBossIce && GameLogic.getInstance().user.arrSubBossIce.length > 0)
					{
						for (i = 0; i < GameLogic.getInstance().user.arrSubBossIce.length; i++) 
						{
							(GameLogic.getInstance().user.arrSubBossIce[i] as SubBossIce).Destructor();
						}
						GameLogic.getInstance().user.arrSubBossIce.splice(0, GameLogic.getInstance().user.arrSubBossIce.length);
					}
					
				}
			}
			if (FishWorldController.waveEmit)
			{
				FishWorldController.waveEmit.destroy();
				FishWorldController.waveEmit = null;
			}
			//for (var i:int = 0; i < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; i++) 
			//{
				//var item:FishSoldier = GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i];
				//item.IsDie = false;
			//}
			var cmd:SendLoadOcean = new SendLoadOcean();
			Exchange.GetInstance().Send(cmd);
			GameLogic.getInstance().isAttacking = false;
			var obj:Object = ResMgr.getInstance().bmpList;
			for (var jStr:String in obj) 
			{
				if (jStr.search("Boss") >= 0) 
				{
					var objElement:BitmapMovie = obj[jStr];
					for (var j:int = 0; j < objElement.bmpList.length; j++) 
					{
						var itemBitMapData:BitmapData = objElement.bmpList[j];
						itemBitMapData.dispose();
					}
					objElement.bmpList.splice(0, objElement.bmpList.length);
					objElement.bmpPos.splice(0, objElement.bmpPos.length);
					objElement.bmpSize.splice(0, objElement.bmpSize.length);
					objElement.bmpCenterPos.splice(0, objElement.bmpCenterPos.length);
					delete(obj[jStr]);
				}
			}
			var k:int = 0;
			switch (GameLogic.getInstance().gameMode) 
			{
				case GameMode.GAMEMODE_WORLD_FOREST:
					for (k = 0; k < GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen.length; k++) 
					{
						var itemMonsterDownYellow:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen[k];
						itemMonsterDownYellow.Destructor();
					}
					GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed.splice(0, GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed.length);
					for (k = 0; k < GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed.length; k++) 
					{
						var itemMonsterUpRed:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed[k];
						itemMonsterUpRed.Destructor();
					}
					GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed.splice(0, GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed.length);
					for (k = 0; k < GuiMgr.getInstance().GuiMainForest.arrThicketUpRed.length; k++) 
					{
						var itemThicketUpRed:Thicket = GuiMgr.getInstance().GuiMainForest.arrThicketUpRed[k];
						itemThicketUpRed.Destructor();
					}
					GuiMgr.getInstance().GuiMainForest.arrThicketUpRed.splice(0, GuiMgr.getInstance().GuiMainForest.arrThicketUpRed.length);
					for (k = 0; k < GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition.length; k++) 
					{
						var itemThicketUpRed1:Thicket = GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition[k];
						itemThicketUpRed1.Destructor();
					}
					GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition.splice(0, GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition.length);
				break;
			}
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (!CheckCanCatchEventMouse()) 
			{
				return;
			}
			//super.OnButtonClick(event, buttonID);
			var oldPage:int;
			var str:String;
			switch (buttonID) 
			{
				case BTN_COME_BACK_MAP:
					str = Localization.getInstance().getString("FishWorldMsg2");
					str = str.replace("@ItemName", GetNameOceanById(FishWorldController.GetSeaId()));
					GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWorldConfirm(str, "Đồng ý", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					//ProcessGotoWorld();
				break;
				case GUI_MAIN_BTN_SHOP:
					GuiMgr.getInstance().GuiShop.CurrentShop = "Support";
					GuiMgr.getInstance().GuiShop.curPage = 0;
					GameController.getInstance().UseTool("Shop");
				break;
				case BTN_BACK_FISH_SOLDIER_LIST:
					if (CurrentPage > 0)
					{
						ClearStoreComponent();
						InitStore(CurrentStore, CurrentPage - 1);
					}
				break;
				
				case BTN_NEXT_FISH_SOLDIER_LIST:
					if (CurrentPage < MaxPage - 1)
					{
						ClearStoreComponent();
						InitStore(CurrentStore, CurrentPage + 1);
					}
				break;
				
				case GUI_STORE_BTN_GEM:
				case GUI_STORE_BTN_SUPPORT:
					ChangeTab(buttonID);
				break;
				//case BTN_WAR:
					//ProcessToWar();
					//break;
				default:
					if(buttonID.search("Use") >= 0)
					{
						useItem(buttonID);
					}
				break;
			}
		}
		
		public static function GetNameOceanById(id:int):String
		{
			switch (id) 
			{
				case 1:
					return "Biển Hoang Sơ";
				break;
			}
			return "?????"
		}
		
		private function useItem(buttonID:String):void 
		{
			var act:String = buttonID.split("_")[0];
			var type:String = buttonID.split("_")[1];
			var Id:int = buttonID.split("_")[2];
			switch (type) 
			{
				case "RecoverHealthSoldier":
					//GameLogic.getInstance().curItemUsed = type + "_" + Id + "_" + "1";
					GuiMgr.getInstance().GuiStore.useToolRecoverHealthSoldier(Id);
				break;
				case "Samurai":
					GuiMgr.getInstance().GuiStore.useToolSamurai(Id);
				break;
				case "StoreRank":
					//GuiMgr.getInstance().GuiStore.useToolRecoverHealthSoldier(Id);
				break;
				case "BuffMoney":
				case "BuffExp":
				case "BuffRank":
					//GuiMgr.getInstance().GuiStore.useToolResistance(Id);
				break;
				default:
					if (type.search("Gem") != -1 && Id != 0)
					{
						GuiMgr.getInstance().GuiStore.useGem(type, Id);
					}
					break;
			}
		}
		public function UpdateStore():void
		{
			ClearStoreComponent();
			InitStore(CurrentStore, CurrentPage);
		}
		
		/**
		 * 
		 * @param	isInWorld	:	Có đang trong thế giới cá không
		 */
		public function ProcessToWar(isInWorld:Boolean = false):void 
		{
			var arrChild:Array = [];
			var arrtemp:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			if (arrtemp == null || arrtemp.length <= 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWorldMsg3"));
				return;
			}
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
				return;
			if(FishWorldController.GetRound() == 4)
			{
				GuiMgr.getInstance().GuiInfoWarInWorld.initAllGUI(FishWorldController.GetRound(), true);
			}
			else 
			{
				GuiMgr.getInstance().GuiInfoWarInWorld.initAllGUI(FishWorldController.GetRound());
			}
			GameLogic.getInstance().SetMode(GameMode.GAMEMODE_WAR);
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_NORMAL);
			
			if(!isInWorld)
			{
				if(FishWorldController.GetRound() < 4)
				{
					arrChild.push("ImgNumberRound" + FishWorldController.GetRound());
				}
				else
				{
					arrChild.push("ImgNumberRoundBoss");
				}
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffRoundWorld", arrChild, Constant.STAGE_WIDTH / 2 + 50, 150);
			}
			
			var i:int;
			var posX:int;
			var posY:int;
			var fishArr:Array;
			var fs:FishSoldier;
			
			// Chuyển trạng thái
			if (SoundMgr.getInstance().IsPlayBg)
			{
				SoundMgr.getInstance().playBgMusic(SoundMgr.MUSIC_WAR);
			}
			
			// Cá thường => ẩn đi
			GameLogic.getInstance().HideFish();
			
			// Tính các tọa độ cá nhà bạn bơi ra
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 100, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 30);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x + 80, p1.y - 70);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x + 80, p1.y + 70);
			theirSoldierPos.push(p3);
			var p4:Point = new Point(p1.x + 160, p1.y);
			theirSoldierPos.push(p4);
			var p5:Point = new Point(p1.x + 160, p1.y + 100);
			theirSoldierPos.push(p5);
			var p6:Point = new Point(p1.x + 160, p1.y - 100);
			theirSoldierPos.push(p6);
			
			// Tính các tọa độ cá nhà mình bơi ra
			mySoldierPos.splice(0, mySoldierPos.length);
			var p7:Point = new Point(Constant.MAX_WIDTH / 2 - 100, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 30);
			mySoldierPos.push(p7);
			var p8:Point = new Point(p7.x - 85, p7.y - 70);
			mySoldierPos.push(p8);
			var p9:Point = new Point(p7.x - 85, p7.y + 70);
			mySoldierPos.push(p9);
			var p10:Point = new Point(p7.x - 170, p7.y);
			mySoldierPos.push(p10);
			var p11:Point = new Point(p7.x - 170, p7.y + 100);
			mySoldierPos.push(p11);
			var p12:Point = new Point(p7.x - 170, p7.y - 100);
			mySoldierPos.push(p12);
			
			// Xóa mảng lưu trữ dữ liệu 2 con cá đánh nhau đi
			GameLogic.getInstance().user.CurSoldier.splice(0, GameLogic.getInstance().user.CurSoldier.length);
			// Cá lính nhà ta sang xâm chiếm
			var actorList:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			actorList.splice(0, actorList.length);
			//fishArr = FishSoldier.SortFishSoldier(GameLogic.getInstance().user.GetMyInfo().MySoldierArr, true);	// Mảng các con cá trong của nhà mình và còn sức khỏe
			fishArr = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;	// Mảng các con cá trong của nhà mình và còn sức khỏe
			for (i = 0; i < fishArr.length; i ++)
			{
				if (fishArr[i].Status == FishSoldier.STATUS_HEALTHY && !fishArr[i].IsDie)
				{
					fs = fishArr[i] as FishSoldier;
					var name:String = Fish.ItemType + fishArr[i].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var f:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name);
					GameController.getInstance().SetInfo(f, fs, FishSoldier.ACTOR_MINE);
					posX = 70;
					posY = GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / (fishArr.length + 1) * (i + 1);
					
					f.Init(posX, posY);
					//f.Init(0, 150);
					
					//posX = mySoldierPos[i].x;
					//posY = mySoldierPos[i].y;
					f.standbyPos = mySoldierPos[i];
					//f.SwimTo(posX, posY, 20);
					f.SwimTo(f.standbyPos.x, f.standbyPos.y, 20);
					
					
					if (f.Status == FishSoldier.STATUS_REVIVE)
					{
						f.SetEmotion(FishSoldier.REVIVE);
					}
					else if (f.Health < 2 * f.AttackPoint)
					{
						f.SetEmotion(FishSoldier.WEAK);
					}
					
					//trace(f.State);
					
					f.OnLoadResCompleteFunction = function():void
					{
						this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
					}
					
					if (GameLogic.getInstance().user.CurSoldier[0] == null && f.Health >= 2 * f.AttackPoint)
					{
						f.isChoose = true;
						GameLogic.getInstance().user.CurSoldier[0] = f;
					}
					actorList.push(f);
				}
			}
			// Cá lính cũng vào vị trí
			if(!Ultility.IsKillBoss())
			{
				fishArr = GameLogic.getInstance().user.FishSoldierArr;	// Mang tất cả cá lính nhà bạn
				for (i = 0; i < fishArr.length; i++)
				{
					if (fishArr[i].Status == FishSoldier.STATUS_HEALTHY)
					{
						fs = fishArr[i] as FishSoldier;
						//posX = theirSoldierPos[i].x;
						//posY = theirSoldierPos[i].y;
						//fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD));
						fs.SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
						
						fs.standbyPos = theirSoldierPos[i];
						//fs.SwimTo(posX, posY, 10);
						fs.SwimTo(fs.standbyPos.x, fs.standbyPos.y, 10);
						fs.OnLoadResCompleteFunction = function():void
						{
							this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
						}
					}
				}
				//if (FishWorldController.CheckHaveEnvironment())
				//{
					//FishWorldController.ShowEffForFishArrInIceWorld(fishArr);
				//}
			}
			else 
			{
				for (var j:int = 0; j < BossMgr.getInstance().BossArr.length; j++) 
				{
					var boss:Boss = BossMgr.getInstance().BossArr[j];
					boss.GotoPos(new Point(Constant.STAGE_WIDTH / 2 + 100, 450), 10);
					var arrFishSoldierBoss:Array = Ultility.GetFishSoldierCanWar();
					for (var k:int = 0; k < arrFishSoldierBoss.length; k++) 
					{
						//(arrFishSoldierBoss[k] as FishSoldier).SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 110, Constant.STAGE_WIDTH / 2,
							//Constant.HEIGHT_LAKE_FISH_WORLD - 150));
						(arrFishSoldierBoss[k] as FishSoldier).SetSwimingArea(new Rectangle(-50, 0, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + GameController.getInstance().GetLakeTop()));
					}
				}
			}	
		}
		
		public function InitRound():void 
		{
			if(FishWorldController.GetRound() + 1 <= 4)
			{
				var isRoundBoss:Boolean = false;
				NewRound();
				if (FishWorldController.GetRound() >= 4)
				{
					isRoundBoss = true;
				}
				KillBoss(isRoundBoss);
			}
			else
			{
				GuiMgr.getInstance().GuiMapOcean.Show(Constant.GUI_MIN_LAYER, 1);
			}
		}
		
		private function KillBoss(isRoundBoss:Boolean):void 
		{			
			if(isRoundBoss)
			{
				var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
				//if(Ultility.GetFishSoldierCanWar().length > 0)
				//{
					GuiMgr.getInstance().GuiMainFishWorld.ProcessToWar();
				//}
				//else 
				//{
					//GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWorldMsg1"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				//}
			}
			else 
			{
				GuiMgr.getInstance().GuiMainFishWorld.ProcessToWar(true);
			}
		}
		
		private function NewRound():void 
		{
			// Xóa những con cá đã hiện ở round trước đi.
			var i:int = 0;
			GameLogic.getInstance().ShowFish();
			for (i = 0; i < GameLogic.getInstance().user.FishArr.length; i++)
			{
				var fish:Fish = GameLogic.getInstance().user.FishArr[i] as Fish;
				fish.Clear();
				fish.Destructor();
			}
			GameLogic.getInstance().user.FishArr.splice(0, GameLogic.getInstance().user.FishArr.length);
			for (i = 0; i < GameLogic.getInstance().user.FishSoldierArr.length; i++)
			{
				var fishS:FishSoldier = GameLogic.getInstance().user.FishSoldierArr[i] as FishSoldier;
				fishS.Clear();
				fishS.Destructor();
			}
			GameLogic.getInstance().user.FishSoldierArr.splice(0, GameLogic.getInstance().user.FishSoldierArr.length);
			
			GuiMgr.getInstance().GuiMapOcean.initFish(FishWorldController.GetSeaId(), true);
			if(GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
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
			
			
		}
		
		public function StartKillBoss():void 
		{
			//trace("Đã vào hàm startKillBoss - GuiMainFishworld");
			for (var j:int = 0; j < BossMgr.getInstance().BossArr.length; j++) 
			{
				var boss:Boss = BossMgr.getInstance().BossArr[j];
				boss.PreStartAttack(GameLogic.getInstance().user.FishSoldierActorMine);
				//var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
				//GameLogic.getInstance().user.SetEnergy(GameLogic.getInstance().user.GetEnergy() - EnergyCost);
			}
			if (GameLogic.getInstance().user.bossMetal != null)
			{
				GameLogic.getInstance().user.bossMetal.PreStartAttack();
			}
			if (GameLogic.getInstance().user.bossIce != null)
			{
				GameLogic.getInstance().user.bossIce.PreStartAttack();
			}
		}
		
		public function ChangeTab(buttonID:String):void 
		{	
			if (buttonID == CurrentStore)
			{
				return;
			}
			ClearStoreComponent();
			InitStore(buttonID, 0);
		}
		
		public function ClearStoreComponent():void 
		{
			if (Parent == null) 
			{
				return;
			}
			
			var i:int;
			// all label
			for (i = 0; i < LabelArr.length; i++)
			{
				img.removeChild(LabelArr[i]);
			}
			LabelArr.splice(0, LabelArr.length);
			
			// all textbox
			for (i = 0; i < TextBoxArr.length; i++)
			{
				var txt:TextBox = TextBoxArr[i] as TextBox;
				txt.RemoveAllEvent();
				img.removeChild(txt.textField);
				txt.textField = null;
			}
			TextBoxArr.splice(0, TextBoxArr.length);
		
			// all container
			for (i = 0; i < ContainerArr.length; i++)
			{
				var container:Container = ContainerArr[i] as Container;
				
				container.Destructor();
			}
			ContainerArr.splice(0, ContainerArr.length);
		}
		
		public function InitStore(Type:String, page:int):void 
		{
			CurrentStore = Type;
			
			// lay danh sach cac slot
			var i:int;
			var ItemList:Array = GameLogic.getInstance().user.GetStore(Type);
			if (Type == "Support")	// Nếu đang ở tab hỗ trợ
			{
				for (i = 0; i < ItemList.length; i++)
				{
					if (ItemList[i]["ItemType"] == "Dice")
					{
						ItemList.splice(i, 1);
						i--;
					}
				}
				
				if (FishWorldController.GetSeaId() == Constant.SEA_ROUND_4 
					&& GuiMgr.getInstance().GuiMainForest.arrMonsterGift.length <= 0)	// và đang ở biển mộc thì cập nhật các miếng đã thu được
				{
					var objMore:Object = new Object();
					objMore.Id = 0;
					objMore.ItemType = "LoadingForestWorld_ImgForestWorld";
					objMore.Num = 1;
					ItemList.push(objMore);
					
					if(GuiMgr.getInstance().GuiMainForest.arrMonsterUpRedData.length == 0)
					{
						objMore = new Object();
						objMore.Id = 1;
						objMore.ItemType = "LoadingForestWorld_ImgForestWorld";
						objMore.Num = 1;
						ItemList.push(objMore);
					}
					
					
					if(GuiMgr.getInstance().GuiMainForest.MonsterRightGreenData == null)
					{
						objMore = new Object();
						objMore.Id = 2;
						objMore.ItemType = "LoadingForestWorld_ImgForestWorld";
						objMore.Num = 1;
						ItemList.push(objMore);
					}
					
					if(GuiMgr.getInstance().GuiMainForest.arrMonsterDownYellowData.length == 0)
					{
						objMore = new Object();
						objMore.Id = 3;
						objMore.ItemType = "LoadingForestWorld_ImgForestWorld";
						objMore.Num = 1;
						ItemList.push(objMore);
					}
				}
			}
			
			// Nếu là kho Gem thì lược bớt Phế và Tán không show ra
			if (Type == "Gem")
			{
				for (i = ItemList.length - 1; i >= 0; i--)
				{
					var GemType:int = int(ItemList[i].ItemType.split("$")[2]);
					if (ItemList[i].Id <= 0 || GemType == 0)
					{
						ItemList.splice(i, 1);
					}
				}
			}
			
			if (ItemList.length <= 0)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 30, 0x707070);
				var txt:TextField = AddLabel(Localization.getInstance().getString("GUILabel1") , 400, 50);
				txt.setTextFormat(txtFormat);
			}
			
			// so page toi da
			MaxPage = Math.ceil(ItemList.length / MaxSlot);
			CurrentPage = page;
			InitStoreButton();
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}
			
			// them cac thanh phan GUI
			var vt:int = CurrentPage * MaxSlot;	//Tổng số slot của n-1 trang trước
			var nItem:int = MaxSlot;	//Số slot lẻ ra ở trang hiện tại
			if (vt + nItem >= ItemList.length)
			{
				nItem = ItemList.length - vt;
			}
			InitStoreSlot(nItem);

			var obj:Object;
			for (i = vt; i < vt + nItem; i++)
			{	
				var container:Container = ContainerArr[i - vt] as Container;	
				var st:StockThings = new StockThings();
				st.SetInfo(ItemList[i]);
				obj = ConfigJSON.getInstance().getItemInfo(st.ItemType, st.Id);
				container.IdObject = "Use_" + obj["type"] + "_"  + obj[ConfigJSON.KEY_ID];
				DrawItem(container, obj, st.Num);
			}
		}
		
		// Update State Các button
		private function InitStoreButton():void
		{	
			var icon:Sprite = ResMgr.getInstance().GetRes( "ImgBgGUIStore") as Sprite;
			var w:int = icon.width ;
			var h:int = icon.height;
				
			// cac tab
			btnSupport = AddButton(GUI_STORE_BTN_SUPPORT, "BtnTabSupport", 300 - 120, LowY, this, INI.getInstance().getHelper("helper24"));
			btnGem = AddButton(GUI_STORE_BTN_GEM, "BtnTabGem", 410 - 120, LowY, this);
			
			imgSupport = AddImage(GUI_STORE_BTN_SUPPORT, "ImgTabSupport", 300 + 49 - 120, LowY + 15);
			imgGem = AddImage(GUI_STORE_BTN_GEM, "ImgTabGem", 410 + 49 - 120, LowY + 15);
			
			imgSupport.img.visible = false;
			imgGem.img.visible = false;
			
			UpdateCurrentTab(CurrentStore);
			
			var btnNext:Button = AddButton(BTN_NEXT_FISH_SOLDIER_LIST, "BtnNext", 715, 55, this);
			var btnBack:Button = AddButton(BTN_BACK_FISH_SOLDIER_LIST, "BtnPrev", 135, 55, this);
			
			UpdateStateButton();
		}
		
		public function UpdateStateButton():void 
		{
			var btnNext:Button = GetButton(BTN_NEXT_FISH_SOLDIER_LIST);
			var btnBack:Button = GetButton(BTN_BACK_FISH_SOLDIER_LIST);
			if (MaxPage > 1)
			{
				if (CurrentPage == 0)
				{
					btnBack.SetDisable();
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetDisable();
				}
			}
			else
			{
				btnBack.SetDisable();
				btnNext.SetDisable();
			}
		}
		
		private function UpdateCurrentTab(buttonID:String):void
		{
			btnSupport.img.y = HighY;
			btnSupport.SetFocus(false);
			btnGem.img.y = HighY;
			btnGem.SetFocus(false);
			
			imgSupport.img.visible = false;
			imgGem.img.visible = false;
			
			switch (buttonID)
			{
				case GUI_STORE_BTN_SUPPORT:
					btnSupport.SetVisible(false);
					imgSupport.img.visible = true;
					break;
				case GUI_STORE_BTN_GEM:
					btnGem.SetVisible(false);
					imgGem.img.visible = true;
					break;
			}
		}
		
		public function InitStoreSlot(nSlot:int):void
		{
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotFishWorld") as Sprite;
			var w:int = icon.width * SlotScale;
			var h:int = icon.height * SlotScale;
			
			var i:int;
			var container:Container;
			for (i = 0; i < nSlot; i++)
			{
				if (i >= MaxSlot)
				{
					break;
				}
				container = AddContainer("", "CtnSlotFishWorld", SlotX0 + i * w + i * SlotDx, SlotY0, true, this);
				container.SetScaleX(SlotScale);
				container.SetScaleY(SlotScale);
			}
		}
		
		private function DrawItem(container:Container, obj:Object, num:int):void
		{
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotFishWorld") as Sprite;
			var w:int = icon.width * SlotScale - 10;
			var h:int = icon.height * SlotScale - 10;
			var img1:Image;
			var st:String ;
			var tooltip:TooltipFormat;
			var fmt:TextFormat;
			var str:String ;
			var _format:TextFormat ;
			_format = new TextFormat();
			_format.color = 0xFF0000;
			_format.size = 14;
			_format.bold = true;
			var iEnd:int;
			switch (obj["type"])
			{
				case "Draft":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					// tooltip
					tooltip = new TooltipFormat();
					st = obj[ConfigJSON.KEY_NAME] + "\nĐể lai ra cá lính";
					tooltip.text = st;
					//fmt = new TextFormat()
					//fmt.color = 0xff0000;
					//tooltip.setTextFormat(fmt, st.indexOf("("), st.indexOf(")") + 1);
					container.setTooltip(tooltip);
					break;
				}
				case "Ginseng":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					// tooltip
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString(obj["type"] + obj["Id"]);
					tooltip.text = tooltip.text.replace("@Value@", int(obj.Expired / (3600 * 24)) + "");
					container.setTooltip(tooltip);
					break;
				case "Samurai":
				case "BuffExp":
				case "BuffMoney":
				case "BuffRank":
				case "StoreRank":
				case "Resistance":
				case "RecoverHealthSoldier":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					// tooltip
					tooltip = new TooltipFormat();
					//tooltip.text = Localization.getInstance().getString("BuffItem" + obj["type"] + obj["Id"]);;
					tooltip.text = Localization.getInstance().getString(obj["type"] + obj["Id"]);
					tooltip.text = tooltip.text.replace("@Value@", obj["Num"] + "");
					container.setTooltip(tooltip);
					break;
				case "ItemCollection":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					// tooltip
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString("ItemCollection" + obj["Id"]);
					container.setTooltip(tooltip);
					break;
				default:
					if (obj["type"].search("Gem") != -1)
					{
						img1 = DrawOther(container, obj);
						img1.FitRect(w - 5, h - 5, new Point(10, 5));
						tooltip = new TooltipFormat();
						var aa:Array = obj["type"].split("$");
						str = Localization.getInstance().getString(aa[0] + aa[1]);
						
						str = str.replace("@Type@", Localization.getInstance().getString("GemType" + aa[2]));
						
						str = str.replace("@Rank@", "cấp " + aa[2]);
						
						var config:Object = ConfigJSON.getInstance().GetItemList("Gem");
						var value:int = config[aa[2]][aa[1]];
						str = str.replace("@value@", String(value));
						str = str.replace("@day@", obj["Id"]);
						tooltip.text = str;
						container.setTooltip(tooltip);
						break;
					}
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					// tooltip
					tooltip = new TooltipFormat();
					tooltip.text = obj[ConfigJSON.KEY_NAME];
					container.setTooltip(tooltip);
					break;
				}
			
			var txtFormat:TextFormat = new TextFormat("Arial", 16);
			var txt:TextField = container.AddLabel(num.toString(), 3, 2, 0xFFFFFF, 0, 0x26709C);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat(txtFormat);
		}
		
		private function DrawOther(container:Container, obj:Object):Image
		{
			var img1:Image;
			var imgName:String;
			var fmt:TextFormat = new TextFormat();
			imgName = getImgName(obj);//obj["type"] + obj[ConfigJSON.KEY_ID];
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
			
			var btn:Button;
			switch (obj["type"])
			{
				case "RecoverHealthSoldier":
				case "Samurai":
				case "Resistance":
				case" StoreRank":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					//btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", BTN_GREEN_X, BTN_GREEN_Y, this);
					btn = container.AddButton("", "Btngreen", BTN_GREEN_X, BTN_GREEN_Y, this);
					btn.img.width = 48;
					btn.img.height = 24;
					container.AddLabel("Dùng", -5, 63).setTextFormat(fmt);
					break;
				case "BuffRank":
				case "BuffExp":
				case "BuffMoney":
					break;
				default:
					var a:Array = obj["type"].split("$");
					if (a[0] == "Gem" && int(a[2]) != 0 && obj["Id"] != 0)
					{
						fmt = new TextFormat();
						fmt.bold = true;
						fmt.color = 0x000000;
						//btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", BTN_GREEN_X, BTN_GREEN_Y, this);
						btn = container.AddButton("", "Btngreen", BTN_GREEN_X, BTN_GREEN_Y, this);
						btn.img.width = 48;
						btn.img.height = 24;
						container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
						break;
					}
					break;
			}
			return img1;
		}
		
		private function getImgName(obj:Object): String
		{
			var image_Name_return:String = obj["type"] + obj[ConfigJSON.KEY_ID];
			switch (obj["type"])
			{
				// Dùng cho các loại công thức lai
				case "Draft":
					return obj["type"] + "_" + obj["Elements"];
				default:
					if (obj["type"].search("Gem") != -1)
					{
						var a:Array = obj["type"].split("$");
						//var distance:int = (parseInt(a[2]) - Constant.GEM_START_DOMAIN) % Constant.GEM_DISTANCE_DOMAIN;
						//image_Name_return = "Gem_" + a[1] + "_" + String(int(a[2]) - distance);
						image_Name_return = "Gem_" + a[1] + "_" + a[2];
					}					
					return image_Name_return;
			}
		}
	}

}