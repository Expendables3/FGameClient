package GUI 
{
	import com.bit101.components.Label;
	import Event.EventHalloween.HalloweenGui.GuiBuyKey;
	import Event.EventHalloween.HalloweenGui.GuiBuyRock;
	import Event.EventHalloween.HalloweenGui.GuiFinishAuto;
	import Event.EventHalloween.HalloweenGui.GuiGiftHalloween;
	import Event.EventHalloween.HalloweenGui.GuiGiftTrunk;
	import Event.EventHalloween.HalloweenGui.GuiHalloween;
	import Event.EventHalloween.HalloweenGui.GuiLockHalloween;
	import Event.EventHalloween.HalloweenGui.GuiSavePoint;
	import Event.EventLuckyMachine.GuiLuckyMachine;
	import Event.EventNoel.NoelGui.GuiBtnControl;
	import Event.EventNoel.NoelGui.GUIDecideElement;
	import Event.EventNoel.NoelGui.GuiExchangeNoelCollection;
	import Event.EventNoel.NoelGui.GuiShocksNoel;
	import Event.EventNoel.NoelGui.GUIVIPTrunk;
	import Event.EventNoel.NoelGui.ItemGui.GuiExchangeNoelItem;
	import Event.EventNoel.NoelGui.GuiGotoHunt;
	import Event.EventNoel.NoelGui.GuiExchangeCandy;
	import Event.EventNoel.NoelGui.GuiGiftEventNoel;
	import Event.EventNoel.NoelGui.GuiHuntFish;
	import Event.EventNoel.NoelGui.ItemGui.GuiFinishRound;
	import Event.EventNoel.NoelGui.ItemGui.GuiReceiveGiftTet;
	import Event.EventNoel.NoelGui.ItemGui.GuiStoreNoel;
	import Event.EventTeacher.GuiChooseElementSavePoint;
	import Event.EventTeacher.GuiCollectionTeacher;
	import Event.EventTeacher.GuiGiftEventTeacher;
	import Event.EventTeacher.GuiGuideTeacher;
	import Event.Factory.FactoryGui.GuiFinishEventAuto;
	import Event.Tet2013.gui.GuiGiftOnline;
	import GUI.ItemGift.GuiTestItem;
	import GUI.MixMaterial.GUIMixMaterial;
	import GUI.MixMaterial.GUIReceiveMaterial;
	import GUI.TrungLinhThach.GUINewItemQuartz;
	import GUI.TrungLinhThach.GUIShowBonusAll;
	import GUI.TrungLinhThach.GUITooltipEgg;
	import GUI.UpgradeEquipment.GUIChooseVIPEquip;
	import GUI.UpgradeEquipment.GUIUpgradeEquip;
	//import Event.EventHalloween.HalloweenGui.GuiTest2;
	import Event.EventHalloween.HalloweenGui.GuiTrickTreat;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiBuyContinue;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiBuyMultiRock;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiChangeMedalEvent;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiChooseElementHalloween;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiGiftSaveHalloween;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiGuideHalloween;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiMessageAuto;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiReceiveEquipment;
	import Event.EventHalloween.HalloweenGui.ItemGui.GuiTrickTask;
	import Event.EventHalloween.HalloweenGui.ItemGui.StoreHalloween;
	import Event.EventIceCream.GUIDestroyIceCream;
	import Event.EventIceCream.GUIGetGiftDaily;
	import Event.EventIceCream.GUIHarvestIceCream;
	import Event.EventIceCream.GUIHelpIceCream;
	import Event.EventIceCream.GUIIntroHelpEventIceCream;
	import Event.EventIceCream.GUIMainEventIceCream;
	import Event.EventIceCream.GUIToolTipIcreCream;
	import Event.EventIceCream.GUIUnlockSlotIceCream;
	import Event.EventMidAutumn.GUIBackGround;
	import Event.EventMidAutumn.GuiEventCollection;
	import Event.EventMidAutumn.GUIFailGift;
	import Event.EventMidAutumn.GUIFinalGift;
	import Event.EventMidAutumn.GuiFrontScreenEvent;
	import Event.EventMidAutumn.GUIGiftStore;
	import Event.EventMidAutumn.GuiGuideEvent;
	import Event.EventMidAutumn.GuiQuickBuyFuel;
	import Event.EventMidAutumn.GuiQuickBuyOneFuel;
	import Event.EventMidAutumn.GuiRebornLantern;
	import Event.TreasureIsland.GUIAutoDigLand;
	import Event.TreasureIsland.GUICollectionGiftToolTip;
	import Event.TreasureIsland.GUICollectionTreasure;
	import Event.TreasureIsland.GUIHelpTreasureIsland;
	import Event.TreasureIsland.GUILandToolTip;
	import Event.TreasureIsland.GUIMessageInEvent;
	import Event.TreasureIsland.GUIMsgTreasure;
	import Event.TreasureIsland.GUIReceiveGiftChangeMedal;
	import Event.TreasureIsland.GUIReceiveTreasure;
	import Event.TreasureIsland.GUITreasureChests;
	import Event.TreasureIsland.GUITreasureIsland;
	import Event.TreasureIsland.GUIChangeMedalVIP;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import GUI.BlackMarket.GUIBuyDiamond;
	import GUI.BlackMarket.GUIChooseNum;
	import GUI.BlackMarket.GUIConfirmBuyItem;
	import GUI.BlackMarket.GUIIntroBetaMarket;
	import GUI.BlackMarket.GUIMarket;
	import GUI.BlackMarket.GUINoDiamond;
	import GUI.BlackMarket.GUISell;
	import GUI.BlackMarket.GUIShopMarket;
	import GUI.BossServer.GUIGiftBossServer;
	import GUI.BossServer.GUIListBoss;
	import GUI.BossServer.GUIMainBossServer;
	import GUI.BossServer.GUITooltipGiftStone;
	import GUI.ChampionLeague.GuiLeague.GUIMainLeague;
	import GUI.ChampionLeague.GuiLeague.GUISelectSoldier;
	import GUI.ChampionLeague.GuiLeague.GUITopPlayer;
	import GUI.ChangeEnchant.ChangeEnchantGui.GuiEnchant;
	import GUI.Collection.GUIAnoucementCollection;
	import GUI.Collection.GUICollection;
	import GUI.Collection.GUICompleteSetCollection;
	import GUI.EnchantEquipment.GUIBuyGodCharm;
	import GUI.Event8March.GUIChangeFlower;
	import GUI.CreateEquipment.GUIBuySpirit;
	import GUI.CreateEquipment.GUIChooseFactory;
	import GUI.CreateEquipment.GUICreateEquipment;
	import GUI.EventBirthDay.EventGUI.GUIBlowCandle;
	import GUI.EventBirthDay.EventGUI.GUIChangeBirthdayGift;
	import GUI.EventBirthDay.EventGUI.GUIMagicLamp;
	import GUI.EventBirthDay.EventGUI.TooltipCandle;
	import GUI.EventEuro.GUIBuyBalls;
	import GUI.EventEuro.GUIChooseElementEuro;
	import GUI.EventEuro.GUIEuroRewards;
	import GUI.EventEuro.GUIEventEuro;
	import GUI.EventEuro.GUIGiftTooltip;
	import GUI.EventEuro.GUIPrediction;
	import GUI.EventEuro.GuiRecieveMedal;
	import GUI.EventLuckyMachine.GUIDigritWheel;
	import GUI.EventLuckyMachine.GUIDigritWheelCongrat;
	import GUI.EventLuckyMachine.GUIGuideLuckyMachine;
	import GUI.EventMagicPotions.GUIAutoMixHerbPotion3.GUIAutoMixHerbPotion3;
	import GUI.EventMagicPotions.GUICongratKillBossHerb;
	import GUI.EventMagicPotions.GUICountdownBossHerb.GUICountdownBossHerb;
	import GUI.EventMagicPotions.GUICover;
	import GUI.EventMagicPotions.GUIGetGiftUseHerb.GUIGetGiftUseHerb;
	import GUI.EventMagicPotions.GUIInfoBossHerb.GUIInfoBossHerb;
	import GUI.EventMagicPotions.GUIQuestHerb.GUIQuestHerb;
	import GUI.EventMagicPotions.GUIQuestHerb.GUITooltipHerb;
	import GUI.EventMagicPotions.GUIQuestHerb.TooltipAutoHerb;
	import GUI.EventMagicPotions.GUIQuestHerbDone.GUIQuestHerbDone;
	import GUI.EventMagicPotions.GUISelectNumHerb.GUISelectNumberHerb;
	import GUI.EventMidle8.GUIAnswerQuestion;
	import GUI.EventMidle8.GUIAutomaticGame;
	import GUI.EventMidle8.GUIChangeGiftEvent;
	import GUI.EventMidle8.GUIChooseElementEventMidle8;
	import GUI.EventMidle8.GUIGameEventMidle8;
	import GUI.EventMidle8.GUIGiftFastGameMid8;
	import GUI.EventMidle8.GUIGiftFinalGameMidle8;
	import GUI.EventMidle8.GUIGiftGame8Fail;
	import GUI.EventMidle8.GUIGiftGameMid8;
	import GUI.EventMidle8.GUIHelpPlayGameMidle8;
	import GUI.DailyEnergy.GUIDailyEnergyBonus;
	import GUI.DailyEnergy.GUIDailyEnergyBonusFinish;
	import GUI.EventMidle8.GUIMessageFinishGame;
	import GUI.EventMidle8.GUIMsg;
	import GUI.EventMidle8.GUIRePlayGameInDay;
	import GUI.EventNationalCelebration.GUIChoseGiftXMas;
	import GUI.EventNationalCelebration.GUICongratulation;
	import GUI.EventNationalCelebration.GUIGetEventGift;
	import GUI.EventNationalCelebration.GUIGiftXMas;
	import GUI.EventNationalCelebration.GUITooltipGiftXMas;
	import GUI.EventNationalCelebration.GUIWish;
	import GUI.EventWarChampion.GUIChooseElement;
	import GUI.EventWarChampion.GUITooltipTopUser;
	import GUI.EventWarChampion.GUIWarChampion;
	import GUI.Expedition.ExpeditionGui.GuiExpedition;
	import GUI.Expedition.ExpeditionGui.GuiReceiveGiftExpedition;
	import GUI.Expedition.ExpeditionGui.GUITest2;
	import GUI.ExtendDeco.GUIExtendDeco;
	import GUI.FirstPay.GuiPayGift;
	import GUI.FishMeridian.GUIMeridian;
	import GUI.FishMeridian.GUIMeridianAchievement;
	import GUI.FishMeridian.GUIMeridianInfo;
	import GUI.FishWar.GUIChooseEquipment;
	import GUI.EnchantEquipment.GUIEnchantEquipment;
	import GUI.FishWar.GUIChooseSolider;
	import GUI.FishWar.GUIDiarySolider;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.FishWar.GUIEventFishWar;
	import GUI.FishWar.GUIEventFishWar2;
	import GUI.FishWar.GUIExchangeStar;
	import GUI.DailyBonus.GUIDailyBonus;
	import GUI.DailyBonus.GUIDailyBonusCongrat;
	import GUI.ExtendEquipment.GUIExtendEquipment;
	import GUI.FishWar.GUIFishWar;
	import GUI.FishWar.GUIFishWarStatistics;
	import GUI.FishWar.GUIInfoFishWar;
	import GUI.FishWar.GUIOptionGrave;
	import GUI.FishWar.GUIRecoverHealth;
	import GUI.FishWar.GUIReviveFishSoldier;
	import GUI.FishWar.GUISoliderInfo;
	import GUI.FishWar.GUIStoreSoldier;
	import GUI.FishWorld.ForestWorld.GUIBackMainForest;
	import GUI.FishWorld.ForestWorld.GUIChooseSerialAttack;
	import GUI.FishWorld.ForestWorld.GUIEffRandomSeaRightGreen;
	import GUI.FishWorld.ForestWorld.GUIFishWarForest;
	import GUI.FishWorld.ForestWorld.GUIFogInForestWold;
	import GUI.FishWorld.ForestWorld.GUIGetPiece;
	import GUI.FishWorld.ForestWorld.GUIInfoForestWorld;
	import GUI.FishWorld.ForestWorld.GUIMainForest;
	import GUI.FishWorld.GUIFinalKillBoss;
	import GUI.FishWorld.GUIFishWarBoss;
	import GUI.FishWorld.GUIGameOceanHappy;
	import GUI.FishWorld.GUIInfoWarInWorld;
	import GUI.FishWorld.GUIIntroOcean;
	import GUI.FishWorld.GUIMainFishWorld;
	import GUI.FishWorld.GUIMapOcean;
	import GUI.FishWorld.GUIMixFormulaInfo;
	import GUI.FishWorld.GUIRegenerating;
	import GUI.FishWorld.GUIRegenerating;
	import GUI.FishWorld.GUIStoreEquipment;
	import GUI.FishWorld.GUIUnlockOcean;
	import GUI.FishWorld.GUIWaitReJoinMap;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.GUIFrontScreen.GUIUserInfo;
	import GUI.GUIGemRefine.GemGUI.GUIGemRefine;
	import GUI.GUIGemRefine.unused.GUIPearlRefine;
	import GUI.Mail.GUINewMail;
	import GUI.Mail.GUIReceiveLetter;
	import GUI.Mail.GUIReplyLetter;
	import GUI.Mail.GUISendLetter;
	import GUI.Mail.SystemMail.View.GUIInputCode;
	import GUI.Mail.SystemMail.View.GUISystemMail;
	import GUI.MainQuest.GUIChooseSoldierQuest;
	import GUI.MainQuest.GUICongratFinishQuest;
	import GUI.MainQuest.GUIIntroduceFeature;
	import GUI.MainQuest.GUIIntroFishWarQuest;
	import GUI.MainQuest.GUIMainQuest;
	import GUI.MainQuest.GUISeriesQuest;
	import GUI.OfflineExperience.GUIReceiveExp;
	import GUI.MateFish.GUIMateFish;
	import GUI.Password.GUIChangePassword;
	import GUI.Password.GuiConfirmCrackPassword;
	import GUI.Password.GUICreatePassword;
	import GUI.Password.GUIDetailLockAction;
	import GUI.Password.GUIPassword;
	import GUI.QuestPowerTinh.GUIQuestPowerTinh;
	import GUI.Reputation.GuiFameInfo;
	import GUI.Reputation.GuiFameUp;
	import GUI.Reputation.GuiReputation;
	import GUI.SpecialSmithy.GuiEquipTooltip;
	import GUI.SpecialSmithy.GUIReceiveMoreEquip;
	import GUI.SpecialSmithy.GUIReceiveOneEquip;
	import GUI.SpecialSmithy.GUISpecialSmithy;
	import GUI.TrainingTower.TrainingGUI.GUITrainingTower;
	import GUI.Tournament.GUITournamentCongratChampion;
	import GUI.Tournament.GUITournamentCongratLoser;
	import GUI.Tournament.GUITournamentReceiveGift;
	import GUI.UnlockEquipment.GUIUnlockEquipment;
	import GUI.unused.GUIInventory;
	import GUI.unused.GUISubInventory;
	import GUI.unused.GUIFriend;
	import GUI.ZingMeWallet.GUIAddZMoney;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import GUI.TrungLinhThach.GUITrungLinhThach;
	import GUI.TrungLinhThach.GUIHammerInfo;
	import GUI.TrungLinhThach.GUIAddHammer;
	import GUI.TrungLinhThach.GuiTrungLinhThachToolTip;
	import GUI.TrungLinhThach.GUIWareRoomLinhThach;
	import GUI.TrungLinhThach.GUILinhThachToolTip;
	import GUI.TrungLinhThach.GUIUpdateLinhThach;
	import GUI.TrungLinhThach.GUIToolBar;
	import GUI.TrungLinhThach.GUIHuongDan;
	import GUI.TrungLinhThach.GUIShowQuartzUser;
	import GUI.TrungLinhThach.GUIBuyHammerSaleOff;
	
	/**
	 * lớp này chỉ để nhóm các biến về GUI lại 1 chỗ để gọi cho tiện mà thôi
	 * @author ducnh
	 */
	public class GuiMgr
	{
		private static var instance:GuiMgr;
		public static var IsFullScreen:Boolean = false;
		
		//public var GuiAbout:GUIAbout = new GUIAbout(null, "");
		//public var GuiHelp:GUIHelp = new GUIHelp(null, "");
		//public var GuiShop:GUIShop = new GUIShop(null, "");
		public var GuiShop:GUIShop = new GUIShop(null, "");
		public var GuiInvetory:GUIInventory = new GUIInventory(null, "");
		public var GuiSubInvetory:GUISubInventory = new GUISubInventory(null, "");
		public var GuiFishInfo:GUIFishInfo = new GUIFishInfo(null, "");
		//public var GuiBuyShop:GUIBuyShop = new GUIBuyShop(null, "");
		public var GuiMain:GUIMain = new GUIMain(null, "");
		public var GuiDecorateInfo:GUIDecorateInfo = new GUIDecorateInfo(null, "");
		public var GuiUpgradeSkill:GUIUpgradeSkill = new GUIUpgradeSkill(null, "");
		public var GuiSkillInfo:GUISkillInfo = new GUISkillInfo(null, "");
		//public var GuiMateFish:GUIMateFish = new GUIMateFish(null, "");
		public var GuiRawMaterials:GUIRawMaterials = new GUIRawMaterials(null, "");
		public var guiMixMaterial:GUIMixMaterial = new GUIMixMaterial(null, "");
		public var guiReceiveMaterial:GUIReceiveMaterial = new GUIReceiveMaterial(null, "");
		public var GuiBuyFish:GUIBuyFish = new GUIBuyFish(null, "");
		//public var GuiLakes:GUILakes = new GUILakes(null, "");
		//public var GuiLetter:GUILetter = new GUILetter(null, "");
		public var GuiSendLetter: GUISendLetter = new GUISendLetter(null, "");
		public var GuiReceiveLetter: GUIReceiveLetter = new GUIReceiveLetter(null, "");
		public var GuiReplyLetter: GUIReplyLetter = new GUIReplyLetter(null,"");
		public var GuiReceiveGift: GUIReceiveGift = new GUIReceiveGift(null, "");		
		//public var GuiFriend: GUIFriend = new GUIFriend(null, "");
		public var GuiGift:GUIGift = new GUIGift(null, "");
		public var GuiGiftSend:GUIGiftSend = new GUIGiftSend(null, "");
		public var GuiMessageBox:GUIMessageBox = new GUIMessageBox(null, "");
		//public var GuiTopInfo:GUITopInfo = new GUITopInfo(null, "");
		public var GuiWaitingData:GUIWaitingData = new GUIWaitingData(null, "");
		//public var GuiBuyDecorate:GUIBuyDecorate = new GUIBuyDecorate(null, "");
		//public var GuiCharacter:GUICharacter = new GUICharacter();
		public var GuiLevelUp:GUILevelUp = new GUILevelUp(null, "");
		//public var GuiChangeLake:GUIChangeLake = new GUIChangeLake(null, "");
		//public var GuiDailyQuest:GUIDailyQuest = new GUIDailyQuest(null, "");
		public var GuiWaitingContent:GUIWaitingContent = new GUIWaitingContent(null, "");
		public var GuiFishing:GUIFishing = new GUIFishing(null, "");
		public var GuiFishingFail:GUIFishingFail = new GUIFishingFail(null, "");
		public var GuiFishingSuccess:GUIFishingSuccess = new GUIFishingSuccess(null, "");
		//public var GuiSeriesQuest:GUISeriesQuest = new GUISeriesQuest(null, "");
		public var GuiFishingCannot:GUIFishingCannot = new GUIFishingCannot(null, "");
		public var GuiSetting:GUISetting = new GUISetting(null, "");
		public var GuiFeedWall:GUIFeedWall = new GUIFeedWall(null, "");
		public var GuiFriends:GUIFriends = new GUIFriends(null, "");	
		public var GuiStore:GUIStore = new GUIStore(null, "");
		public var GuiStoreSoldier:GUIStoreSoldier = new GUIStoreSoldier(null, "");
		public var GuiLog:GUILog = new GUILog(null, "");
		//public var GuiAvatar:GUIAvatar = new GUIAvatar(null, "");
		public var GuiDailyQuestNew:GUIDailyQuestNew = new GUIDailyQuestNew(null, "");
		public var GuiCompleteDailyQuestNew:GUICompleteDailyQuestNew = new GUICompleteDailyQuestNew(null, "");
		public var GuiAnnounce:GUIAnnouncement = new GUIAnnouncement(null, "");
		//public var GuiSecretFishInfo:GUISecretFishInfo = new GUISecretFishInfo(null, "");
		//public var GuiCongrat:GUICongrat = new GUICongrat(null, "");
		//public var GuiWaitFishing:GUIWaitFishing = new GUIWaitFishing(null, "");
		public var GuiExpandLake:GUIExpandLake = new GUIExpandLake(null, "");
		public var GuiUnlockLake:GUIUnlockLake = new GUIUnlockLake(null, "");
		public var GuiTreasureGift:GUITreasureGift = new GUITreasureGift(null, "");
		//public var GuiBuyItem:GUIBuyItem = new GUIBuyItem(null, "");
		public var GuiDailyBonus:GUIDailyBonus = new GUIDailyBonus(null, "");
		public var GuiEnergyMachine:GUIEnergyMachine = new GUIEnergyMachine(null, "");
		public var GuiDailyBonusCongrat:GUIDailyBonusCongrat = new GUIDailyBonusCongrat(null, "");
		public var GuiNapG:GUINapG = new GUINapG(null, "");
		public var GuiSnapshot:GUISnapshot = new GUISnapshot(null, "");
		public var GuiFishWar:GUIFishWar = new GUIFishWar(null, "");
		public var GuiReviveFishSoldier:GUIReviveFishSoldier = new GUIReviveFishSoldier(null, "");
		public var GuiRecoverHealth:GUIRecoverHealth = new GUIRecoverHealth(null, "");
		public var GuiEventFishWar:GUIEventFishWar = new GUIEventFishWar(null, "");
		public var GuiEventFishWar2:GUIEventFishWar2 = new GUIEventFishWar2(null, "");
		public var GuiExchangeStar:GUIExchangeStar = new GUIExchangeStar(null, "");
		public var GuiInfoFishWar:GUIInfoFishWar = new GUIInfoFishWar(null, "");
		public var GuiPreviewBgr:GUIPreviewBgr = new GUIPreviewBgr(null, "");
		public var GuiChooseEquipment:GUIChooseEquipment = new GUIChooseEquipment(null, "");
		public var GuiExtendEquipment:GUIExtendEquipment = new GUIExtendEquipment(null, "");
		public var GuiEquipmentInfo:GUIEquipmentInfo = new GUIEquipmentInfo(null, "");
		public var GuiFishWarStatistics:GUIFishWarStatistics = new GUIFishWarStatistics(null, "");
		public var GuiUnlockEquipment:GUIUnlockEquipment = new GUIUnlockEquipment(null, "");
		public var GuiEnchantEquipment:GUIEnchantEquipment = new GUIEnchantEquipment(null, "");
		public var GuiBuyGodCharm:GUIBuyGodCharm = new GUIBuyGodCharm(null, "");
		public var GuiOptionGrave:GUIOptionGrave = new GUIOptionGrave(null, "");
		
		public var GuiUpgradeSkillMaterial:GUIUpgradeSkillMaterial = new GUIUpgradeSkillMaterial(null, "");
		public var GuiFillEnergy:GUIFillEnergy = new GUIFillEnergy(null, "");
		public var GuiSkillRawMaterialInfo:GUISkillRawMaterialInfo = new GUISkillRawMaterialInfo(null, "");
		
		public var GuiNewMail:GUINewMail = new GUINewMail(null, "");
		public var GuiSystemMail:GUISystemMail = new GUISystemMail(null, "");
		public var GuiInputCode:GUIInputCode = new GUIInputCode(null, "");
		public var GuiFishMachine:GUIFishMachine = new GUIFishMachine(null, "");
		public var GuiGuideFishMac:GUIGuideFishMachine = new GUIGuideFishMachine(null, "");
		
		public var GuiForEffect:GUIForEffect = new GUIForEffect(null, "");
		public var GuiAddEnergy:GUIAddEnergy = new GUIAddEnergy(null, "");		
		public var GuiHelp:GUIHelp = new GUIHelp(null, "");
		
		//Event click tien ca
		public var GuiTienCa:TienCaClick = new TienCaClick(null, "");
		//public var GuiFinishEventClick:GUIFinishEventClick = new GUIFinishEventClick(null, "");
		
		//Event national celebration
		public var guiGetEventGift:GUIGetEventGift = new GUIGetEventGift(null, "");
		public var guiCongratulation:GUICongratulation = new GUICongratulation(null, "");
		public var guiWish:GUIWish = new GUIWish(null, "");
		
		public var guiDailyEnergyBonus:GUIDailyEnergyBonus = new GUIDailyEnergyBonus(null, "");
		public var guiDailyEnergyBonusFinish:GUIDailyEnergyBonusFinish = new GUIDailyEnergyBonusFinish(null, "");
		
		public var GuiAnnounceGotGift:GUIAnnounceGotGift = new GUIAnnounceGotGift(null, "");
		
		//FishWorld
		public var GuiMainFishWorld:GUIMainFishWorld = new GUIMainFishWorld(null, "");
		public var GuiGameOceanHappy:GUIGameOceanHappy = new GUIGameOceanHappy(null, "");
		public var GuiMapOcean:GUIMapOcean = new  GUIMapOcean(null, "");
		public var GuiUnlockOcean:GUIUnlockOcean = new GUIUnlockOcean(null, "");
		public var GuiMixFormulaInfo:GUIMixFormulaInfo = new GUIMixFormulaInfo(null, "");
		public var GuiInfoWarInWorld:GUIInfoWarInWorld = new GUIInfoWarInWorld(null, "");
		public var GuiIntroOcean:GUIIntroOcean = new GUIIntroOcean(null, "");
		public var GuiFishWarBoss:GUIFishWarBoss = new GUIFishWarBoss(null, "");
		public var GuiRegenerating:GUIRegenerating = new GUIRegenerating(null, "");
		public var GuiWaitReJoinMap:GUIWaitReJoinMap = new GUIWaitReJoinMap(null, "");
		public var GuiStoreEquipment:GUIStoreEquipment = new GUIStoreEquipment(null, "");
		public var GuiFinalKillBoss:GUIFinalKillBoss = new GUIFinalKillBoss(null, "");
		public var GuiMainForest:GUIMainForest = new GUIMainForest(null, "");
		public var GuiInfoForestWorld:GUIInfoForestWorld = new GUIInfoForestWorld(null, "");
		public var GuiFogInForestWold:GUIFogInForestWold = new GUIFogInForestWold(null, "");
		public var GuiFishWarForest:GUIFishWarForest = new GUIFishWarForest(null, "");
		public var GuiChooseSerialAttack:GUIChooseSerialAttack = new GUIChooseSerialAttack(null, "");
		public var GuiBackMainForest:GUIBackMainForest = new GUIBackMainForest(null, "");
		public var GuiEffRandomSeaRightGreen:GUIEffRandomSeaRightGreen = new GUIEffRandomSeaRightGreen(null, "");
		public var GuiGetPiece:GUIGetPiece = new GUIGetPiece(null, "");
		// Event Trung thu
		public var GuiAnswerQuestion:GUIAnswerQuestion = new GUIAnswerQuestion(null, "");
		public var GuiGameTrungThu:GUIGameEventMidle8 = new GUIGameEventMidle8(null, "");
		public var GuiChangeGiftEvent:GUIChangeGiftEvent = new GUIChangeGiftEvent(null, "");
		public var GuiGuideGameTrungThu:GUIHelpPlayGameMidle8 = new GUIHelpPlayGameMidle8(null, "");
		public var GuiGiftGameMid8:GUIGiftGameMid8 = new GUIGiftGameMid8(null, "");
		public var GuiGiftFinalGameMid8:GUIGiftFinalGameMidle8= new GUIGiftFinalGameMidle8(null, "");
		public var GuiGiftFastGameMid8:GUIGiftFastGameMid8= new GUIGiftFastGameMid8(null, "");
		public var GuiGiftGame8Fail:GUIGiftGame8Fail = new GUIGiftGame8Fail(null, "");
		public var GuiRePlayGame:GUIRePlayGameInDay = new GUIRePlayGameInDay(null, "");
		public var GuiMessageFinishGame:GUIMessageFinishGame = new GUIMessageFinishGame(null, "");
		public var GuiChooseElementEventMidle8:GUIChooseElementEventMidle8 = new GUIChooseElementEventMidle8(null, "");
		
		//Gia han do trang tri
		public var guiExtendDeco:GUIExtendDeco = new GUIExtendDeco(null, "");
		//Offline nhận kinh nghiệm
		public var guiOfflineExperience:GUIReceiveExp = new GUIReceiveExp(null, "");
		
		//Gui lai cá mới
		public var guiMateFish:GUIMateFish = new GUIMateFish(null, "");
		
		public var guiGiftXMas:GUIGiftXMas = new GUIGiftXMas(null, "");
		public var guiTooltipGiftXMas:GUITooltipGiftXMas = new GUITooltipGiftXMas(null, "");
		public var guiChoseGiftXMas:GUIChoseGiftXMas = new GUIChoseGiftXMas(null, "");
		//Gui collection
		public var guiCollection:GUICollection = new GUICollection(null, "");
		public var guiCompleteCollection:GUICompleteSetCollection = new GUICompleteSetCollection(null, "");
		public var guiAnoucementCollection:GUIAnoucementCollection = new GUIAnoucementCollection(null, "");
		
		public var GuiPearlRefine:GUIPearlRefine = new GUIPearlRefine(null, "");
		public var GuiGemRefine:GUIGemRefine = new GUIGemRefine(null, "");
		
		public var guiChooseSolider:GUIChooseSolider = new GUIChooseSolider(null, "");
		public var guiSoliderInfo:GUISoliderInfo = new GUISoliderInfo(null, "");
		public var guiDiarySolider:GUIDiarySolider = new GUIDiarySolider(null, "");
		
		//Market
		public var guiMarket:GUIMarket = new GUIMarket(null, "");
		public var guiSell:GUISell = new GUISell(null, "");
		public var guiChooseNumber:GUIChooseNum = new GUIChooseNum(null, "");
		public var guiConfirmBuyItem:GUIConfirmBuyItem = new GUIConfirmBuyItem(null, "");
		public var guiShopMarket:GUIShopMarket = new GUIShopMarket(null, "");
		public var guiBuyDiamond:GUIBuyDiamond = new GUIBuyDiamond(null, "");
		public var guiNoDiamond:GUINoDiamond = new GUINoDiamond(null, "");
		public var guiIntroBetaMarket:GUIIntroBetaMarket = new GUIIntroBetaMarket(null, "");
		
		// Feature Quest Tinh lực
		public var GuiQuestPowerTinh:GUIQuestPowerTinh = new GUIQuestPowerTinh(null, "");
		
		//Feature Máy quay sò
		public var guiDigitWheel:GUIDigritWheel = new GUIDigritWheel(null, "");
		public var guiGuideLM:GUIGuideLuckyMachine= new GUIGuideLuckyMachine(null, "");
		public var guiDigritWheelCongrat:GUIDigritWheelCongrat = new GUIDigritWheelCongrat(null, "");
		//Gui event war champion
		public var guiWarChampion:GUIWarChampion = new GUIWarChampion(null, "");
		public var guiChooseElement:GUIChooseElement = new GUIChooseElement(null, "");
		public var guiTooltipTopUser:GUITooltipTopUser = new GUITooltipTopUser(null, "");
		
		//GUI event 8/3
		public var GuiChangeFlower:GUIChangeFlower = new GUIChangeFlower(null, "");
		//Gui che do
		public var guiChooseFactory:GUIChooseFactory = new GUIChooseFactory(null, "");
		public var guiCreateEquipment:GUICreateEquipment = new GUICreateEquipment(null, "");
		public var guiBuySpirit:GUIBuySpirit = new GUIBuySpirit(null, "");
		
		public var guiConfirm:GUIConfirm = new GUIConfirm(null, "");
		
		//GUI chế đồ mới - thợ rèn thần bí
		public var guiSpecialSmithy:GUISpecialSmithy = new GUISpecialSmithy(null, "");
		public var guiReceiveMoreEquip:GUIReceiveMoreEquip = new GUIReceiveMoreEquip(null, "");
		public var guiReceiveOneEquip:GUIReceiveOneEquip = new GUIReceiveOneEquip(null, "");
		public var guiEquipTooltip:GuiEquipTooltip = new GuiEquipTooltip(null, "");
		
		// GUi Event Herb
		public var GuiQuestHerb:GUIQuestHerb = new GUIQuestHerb(null, "");
		public var GuiQuestHerbDone:GUIQuestHerbDone = new GUIQuestHerbDone(null, "");
		public var GuiTooltipHerb:GUITooltipHerb = new GUITooltipHerb(null, "");
		public var GuiCongratKillBossHerb:GUICongratKillBossHerb = new GUICongratKillBossHerb(null, "");
		public var GuiCover:GUICover = new GUICover(null, "");
		public var GuiTooltipAutoHerb:TooltipAutoHerb = new TooltipAutoHerb(null, "");
		public var GuiCountdownBossHerb:GUICountdownBossHerb = new GUICountdownBossHerb(null, "");
		public var GuiInfoBossHerb:GUIInfoBossHerb = new GUIInfoBossHerb(null, "");
		public var GuiSelectNumberHerb:GUISelectNumberHerb = new GUISelectNumberHerb(null, "");
		public var GuiGetGiftUseHerb:GUIGetGiftUseHerb = new GUIGetGiftUseHerb(null, "");
		public var GuiAutoMixHerbPotion3:GUIAutoMixHerbPotion3 = new GUIAutoMixHerbPotion3(null, "");
		
		public var GuiGetGiftAfterEvent:GUIGetGiftAfterEvent = new GUIGetGiftAfterEvent(null, "");
		
		public var GuiAutomaticGame:GUIAutomaticGame = new GUIAutomaticGame(null, "");
		public var GuiMsg_Game:GUIMsg = new GUIMsg(null, "");
		public var guiNewCongratulation:GUINewCongratulation = new GUINewCongratulation(null, "");
		
		//Gioi thieu feature
		public var guiIntroduceFeature:GUIIntroduceFeature = new GUIIntroduceFeature(null, "");
		
		//MainQuest
		public var guiMainQuest:GUIMainQuest = new GUIMainQuest(null, "");
		public var guiChooseSoldierQuest:GUIChooseSoldierQuest = new GUIChooseSoldierQuest(null, "");
		public var guiIntroFishWarQuest:GUIIntroFishWarQuest = new GUIIntroFishWarQuest(null, "");
		public var guiCongratFinishQuest:GUICongratFinishQuest = new GUICongratFinishQuest(null, "");
		
		//event 1st birthday
		public var GuiChangeBirthDayGift:GUIChangeBirthdayGift = new GUIChangeBirthdayGift(null, "");
		public var guiTooltipCandle1:TooltipCandle = new TooltipCandle(null, "");
		public var guiBlowCandle1:GUIBlowCandle = new GUIBlowCandle(null, "");
		public var guiTooltipCandle2:TooltipCandle = new TooltipCandle(null, "");
		public var guiBlowCandle2:GUIBlowCandle = new GUIBlowCandle(null, "");
		public var guiTooltipCandle3:TooltipCandle = new TooltipCandle(null, "");
		public var guiBlowCandle3:GUIBlowCandle = new GUIBlowCandle(null, "");
		public var guiMagicLamp:GUIMagicLamp = new GUIMagicLamp(null, "");
		
		//Event euro
		public var guiEventEuro:GUIEventEuro = new GUIEventEuro(null, "");
		public var guiPrediction:GUIPrediction = new GUIPrediction(null, "");
		public var guiGiftTooltip:GUIGiftTooltip = new GUIGiftTooltip(null, "");
		public var guiEuroRewards:GUIEuroRewards = new GUIEuroRewards(null, "");
		public var guiChooseElementEuro:GUIChooseElementEuro = new GUIChooseElementEuro(null, "");
		public var guiBuyBalls:GUIBuyBalls = new GUIBuyBalls(null, "");
		public var guiRecieveMedal:GuiRecieveMedal = new GuiRecieveMedal(null, "");
		
		public var GuiTrainingTower:GUITrainingTower = new GUITrainingTower(null, "");

		// Event Ice Cream
		public var GuiIntroHelpEventIceCream:GUIIntroHelpEventIceCream = new GUIIntroHelpEventIceCream(null, "");
		public var GuiMainEventIceCream:GUIMainEventIceCream = new GUIMainEventIceCream(null, "");
		public var GuiUnlockSlotIceCream:GUIUnlockSlotIceCream = new GUIUnlockSlotIceCream(null, "");
		public var GuiToolTipIcreCream:GUIToolTipIcreCream = new GUIToolTipIcreCream(null, "");
		public var GuiDestroyIceCream:GUIDestroyIceCream = new GUIDestroyIceCream(null, "");
		public var GuiHarvestIceCream:GUIHarvestIceCream = new GUIHarvestIceCream(null, "");
		public var GuiGetGiftDaily:GUIGetGiftDaily = new GUIGetGiftDaily(null, "");
		public var GuiHelpIceCream:GUIHelpIceCream = new GUIHelpIceCream(null, "");
		
		//Event Treasure Island
		public var guiTreasureIsLand:GUITreasureIsland = new GUITreasureIsland(null, "");
		public var guiMessageInEvent:GUIMessageInEvent = new GUIMessageInEvent(null, "");
		public var guiAutoDigLand:GUIAutoDigLand = new GUIAutoDigLand(null, "");
		public var guiTreasureChests:GUITreasureChests = new GUITreasureChests(null, "");
		public var guiReceiveTreasure:GUIReceiveTreasure = new GUIReceiveTreasure(null, "");
		public var guiCollectionTreasure:GUICollectionTreasure = new GUICollectionTreasure(null, "");
		public var guiLandToolTip:GUILandToolTip = new GUILandToolTip(null, "");
		public var guiHelpTreasureIsland:GUIHelpTreasureIsland = new GUIHelpTreasureIsland(null, "");
		public var guiMsgTreasure:GUIMsgTreasure = new GUIMsgTreasure(null, "");
		public var guiCollectionGiftToolTip:GUICollectionGiftToolTip = new GUICollectionGiftToolTip(null, "");
		public var guiChangeMedalVIP:GUIChangeMedalVIP = new GUIChangeMedalVIP(null, "");
		public var guiReceiveGiftChangeMedal:GUIReceiveGiftChangeMedal = new GUIReceiveGiftChangeMedal(null, "");
		
		//Kinh ngu
		public var guiMeridian:GUIMeridian = new GUIMeridian(null, "");
		public var guiMeridianInfo:GUIMeridianInfo = new GUIMeridianInfo(null, "");
		public var guiMeridianAchievement:GUIMeridianAchievement = new GUIMeridianAchievement(null, "");

		// tournament
		public var guiTournamentCongratLoser:GUITournamentCongratLoser = new GUITournamentCongratLoser(null, "");
		public var guiTournamentCongratChampion:GUITournamentCongratChampion = new GUITournamentCongratChampion(null, "");
		public var guiTournamentReceiveGift:GUITournamentReceiveGift = new GUITournamentReceiveGift(null, "");
		
		// liên đấu Champion League
		public var guiSelectSoldier:GUISelectSoldier = new GUISelectSoldier(null, "");
		public var guiTopPlayer:GUITopPlayer = new GUITopPlayer(null, "");
		public var guiMainLeague:GUIMainLeague = new GUIMainLeague(null, "");
		//Password
		public var guiPassword:GUIPassword = new GUIPassword(null, "");
		public var guiCreatePassword:GUICreatePassword = new GUICreatePassword(null, "");
		public var guiChangePassword:GUIChangePassword = new GUIChangePassword(null, "");
		public var guiDetailLockAction:GUIDetailLockAction = new GUIDetailLockAction(null, "");
		public var guiConfirmCrackPassword:GuiConfirmCrackPassword = new GuiConfirmCrackPassword(null, "");
		
		//BossServer
		public var guiListBoss:GUIListBoss = new GUIListBoss(null, "");
		public var guiMainBossServer:GUIMainBossServer = new GUIMainBossServer(null, "");
		public var guiTooltipGiftStone:GUITooltipGiftStone = new GUITooltipGiftStone(null, "");
		//Expedition
		public var guiExpedition:GuiExpedition = new GuiExpedition(null, "");
		public var GuiTest2:GUITest2 = new GUITest2(null, "");
		public var guiExpeditionGift:GuiReceiveGiftExpedition = new GuiReceiveGiftExpedition(null, "");
		//Nap xu
		public var guiAddZMoney:GUIAddZMoney = new GUIAddZMoney(null, "");
		
		//GUI Top Info
		public var guiUserInfo:GUIUserInfo = new GUIUserInfo(null, "");
		public var guiFrontScreen:GUIFrontScreen = new GUIFrontScreen(null, "");
		public var guiGiftBossServer:GUIGiftBossServer = new GUIGiftBossServer(null, "");
		
		//changeEnchant
		public var guiEnchant:GuiEnchant = new GuiEnchant(null, "");
		//FirstPay
		public var guiPayGift:GuiPayGift = new GuiPayGift(null, "");
		
		//Event MidAutumn
		public var guiFrontEvent:GuiFrontScreenEvent = new GuiFrontScreenEvent(null, "");
		public var guiEventCollection:GuiEventCollection = new GuiEventCollection(null, "");
		public var guiRebornLantern:GuiRebornLantern = new GuiRebornLantern(null, "");
		public var guiBackGround:GUIBackGround = new GUIBackGround(null, "");
		public var guiGiftStore:GUIGiftStore = new GUIGiftStore(null, "");
		public var guiQuickBuyFuel:GuiQuickBuyFuel = new GuiQuickBuyFuel(null, "");
		public var guiQuickBuyOneFuel:GuiQuickBuyOneFuel = new GuiQuickBuyOneFuel(null, "");
		public var guiGuideEvent:GuiGuideEvent = new GuiGuideEvent(null, "");
		public var guiFinalGift:GUIFinalGift = new GUIFinalGift(null, "");
		public var guiFailGift:GUIFailGift = new GUIFailGift(null, "");
		public var guiGiftFromEvent:GuiGiftFromEvent = new GuiGiftFromEvent(null, "");		
		
		// Reputation
		public var guiReputation:GuiReputation = new GuiReputation(null, "");
		public var guiFameInfo:GuiFameInfo = new GuiFameInfo(null, "");
		public var guiFameUp:GuiFameUp = new GuiFameUp(null, "");
		
		//Event Halloween
		public var guiHalloween:GuiHalloween = new GuiHalloween(null, "");
		public var guiBuyRock:GuiBuyRock = new GuiBuyRock(null, "");
		public var guiBuyContinue:GuiBuyContinue = new GuiBuyContinue(null, "");
		public var guiBuyKey:GuiBuyKey = new GuiBuyKey(null, "");
		public var TrunkHalloween:StoreHalloween = new StoreHalloween(null, "");
		public var guiGiftTrunk:GuiGiftTrunk = new GuiGiftTrunk(null, "");
		public var guiTrickTreat:GuiTrickTreat = new GuiTrickTreat(null, "");
		public var guiTrickTask:GuiTrickTask = new GuiTrickTask(null, "");
		public var guiLockHalloween:GuiLockHalloween = new GuiLockHalloween(null, "");
		public var guiFinishAuto:GuiFinishAuto = new GuiFinishAuto(null, "");
		public var guiGiftHalloween:GuiGiftHalloween = new GuiGiftHalloween(null, "");
		public var guiSavePoint:GuiSavePoint = new GuiSavePoint(null, "");
		public var guiMessageAuto:GuiMessageAuto = new GuiMessageAuto(null, "");
		public var guiUserEventInfo:GUIUserInfo = new GUIUserInfo(null, "");
		public var guiGiftSaveHalloween:GuiGiftSaveHalloween = new GuiGiftSaveHalloween(null, "");
		public var guiBuyMultiRock:GuiBuyMultiRock = new GuiBuyMultiRock(null, "");
		public var guiGuideHalloween:GuiGuideHalloween = new GuiGuideHalloween(null, "");
		public var guiChangeMedalEvent:GuiChangeMedalEvent = new GuiChangeMedalEvent(null, "");
		public var guiChooseElementHalloween:GuiChooseElementHalloween = new GuiChooseElementHalloween(null, "");
		//Event Teacher
		public var guiTeacherEvent:GuiCollectionTeacher = new GuiCollectionTeacher(null, "");
		public var guiGiftEventTeacher:GuiGiftEventTeacher = new GuiGiftEventTeacher(null, "");
		public var guiChooseElementSavePoint:GuiChooseElementSavePoint = new GuiChooseElementSavePoint(null, "");
		public var guiGuideTeacher:GuiGuideTeacher = new GuiGuideTeacher(null, "");
		public var guiTestItem:GuiTestItem = new GuiTestItem(null, "");
		
		//Event Trung Linh Thach ThanhNT2
		public var guiTrungLinhThach:GUITrungLinhThach = new GUITrungLinhThach(null, ""); 
		public var guiUserTrungLinhThachInfo:GUIUserInfo = new GUIUserInfo(null, "");
		public var guiHammerInfo:GUIHammerInfo = new GUIHammerInfo(null, "");
		public var guiAddHammer:GUIAddHammer = new GUIAddHammer(null, "");
		public var guiTrungLinhThachToolTip:GuiTrungLinhThachToolTip = new GuiTrungLinhThachToolTip(null, "");
		public var guiWareRoomLinhThach:GUIWareRoomLinhThach = new GUIWareRoomLinhThach(null, "");
		public var guiLinhThachToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
		public var guiUpdateLinhThach:GUIUpdateLinhThach = new GUIUpdateLinhThach(null, "");
		public var guiToolBar:GUIToolBar = new GUIToolBar(null, "");
		public var guiHuongDan:GUIHuongDan = new GUIHuongDan(null, "");
		public var guiShowQuartzUser:GUIShowQuartzUser = new GUIShowQuartzUser(null, ""); 
		public var guiTooltipEgg:GUITooltipEgg = new GUITooltipEgg(null, "");
		public var guiBuyHammerSaleOff:GUIBuyHammerSaleOff = new GUIBuyHammerSaleOff(null, "");
		public var guiShowBonusAll:GUIShowBonusAll = new GUIShowBonusAll(null, "");
		public var guiNewItemQuartz:GUINewItemQuartz = new GUINewItemQuartz(null, "");
		
		public var guiReceiveEquipment:GuiReceiveEquipment = new GuiReceiveEquipment(null, "");
		//public var guiTest2:GuiTest2 = new GuiTest2(null, "");
		
		//EventNoel
		public var guiBtnControl:GuiBtnControl = new GuiBtnControl(null, "");
		public var guiGotoHunt:GuiGotoHunt = new GuiGotoHunt(null, "");
		public var guiExchangeCandy:GuiExchangeCandy = new GuiExchangeCandy(null, "");
		public var guiExchangeNoelItem:GuiExchangeNoelItem = new GuiExchangeNoelItem(null, "");
		public var guiHuntFish:GuiHuntFish = new GuiHuntFish(null, "");
		public var guiGiftEventNoel:GuiGiftEventNoel = new GuiGiftEventNoel(null, "");
		public var guiShocksNoel:GuiShocksNoel = new GuiShocksNoel(null, "");
		public var guiExchangeNoelCollection:GuiExchangeNoelCollection = new GuiExchangeNoelCollection(null, "");
		public var guifinishRound:GuiFinishRound = new GuiFinishRound(null, "");
		public var guiStoreNoel:GuiStoreNoel = new GuiStoreNoel(null, "");
		public var guiFinishEventAuto:GuiFinishEventAuto = new GuiFinishEventAuto(null, "");
		public var guiVIPTrunk:GUIVIPTrunk = new GUIVIPTrunk(null, "");
		public var guiDecideElement:GUIDecideElement = new GUIDecideElement(null, "");
		//event tet2013
		public var guiGiftOnline:GuiGiftOnline = new GuiGiftOnline(null, "");
		public var guiReceiveGiftTet:GuiReceiveGiftTet = new GuiReceiveGiftTet(null, "");
		
		public var guiLuckyMachine:GuiLuckyMachine = new GuiLuckyMachine(null, "");
		
		public var guiUpgradeEquip:GUIUpgradeEquip = new GUIUpgradeEquip(null, "");
		public var guiChooseVIPEquip:GUIChooseVIPEquip = new GUIChooseVIPEquip(null, "");
		public static function getInstance():GuiMgr
		{
			if(instance == null)
			{
				instance = new GuiMgr;
			}
				
			return instance;
		}
		
		public function GuiMgr() 
		{
			
		}
		
		public function UpdateAllGUI():void
		{
			if (guiListBoss.IsVisible)
			{
				guiListBoss.UpdateObject();
			}
			if (guiBackGround.IsVisible)
			{
				guiBackGround.UpdateObject();
			}
			if (guiUserInfo.IsVisible)
			{
				guiUserInfo.UpdateObject();
			}
			if (guiFrontScreen.IsVisible)
			{
				guiFrontScreen.UpdateObject();
			}
			if (guiMeridian.IsVisible)
			{
				guiMeridian.UpdateObject();
			}
			//if (GuiLakes.IsVisible)
			//{
				//GuiLakes.UpdateObject();
			//}
			
			//if (GuiShop.IsVisible)
			//{
				//GuiShop.UpdateObject();
			//}
			
			//if (GuiBuyShop.IsVisible)
			//{
				//GuiBuyShop.UpdateObject();
			//}
			
			//if (GuiTopInfo.IsVisible)
			//{
				//GuiTopInfo.UpdateInfo();
			//}
			
			//if (GuiCharacter.IsVisible)
			//{
				//GuiCharacter.UpdateInfo();
			//}
			if (GuiMain) {
				if (GuiMain.IsVisible)
				{
					GuiMain.UpdateInfo();
				}
			}
			
			if (GuiStore.IsVisible)
			{
				GuiStore.UpdateInfo();
			}
			
			if (GuiBuyFish.IsVisible)
			{
				GuiBuyFish.UpdateInfo();
			}
			
			if (GuiFishWar.IsVisible)
			{
				GuiFishWar.UpdateInfo();
			}
			
			if (GuiGameOceanHappy.IsVisible) 
			{
				GuiGameOceanHappy.update();
			}
			
			if (GuiPearlRefine.IsVisible)
			{
				GuiPearlRefine.UpdateGui();
				
			}
			
			if (guiTreasureIsLand.IsVisible)
			{
				guiTreasureIsLand.UpdateGUI();
			}
			
			if (guiSpecialSmithy.IsVisible)
			{
				guiSpecialSmithy.UpdateGUI();
			}
			if (guiMateFish.IsVisible)
			{
				guiMateFish.UpdateObject();
			}
			
			GuiSnapshot.update();

			if (GuiGameTrungThu.IsVisible)
			{
				GuiGameTrungThu.UpdateGUI();
			}
			
			if (GuiAnswerQuestion.IsVisible)
			{
				GuiAnswerQuestion.UpdateGui();
			}
			if (GuiMainFishWorld.IsVisible)
			{
				GuiMainFishWorld.UpdateGuiInfo();
			}
			if (GuiInfoWarInWorld.IsVisible)
			{
				GuiInfoWarInWorld.UpdateGui();
			}
			if (GuiWaitReJoinMap.IsVisible)
			{
				GuiWaitReJoinMap.UpdateGUI();
			}
			if (GuiRePlayGame.IsVisible)
			{
				GuiRePlayGame.UpdateGUI();
			}
			if (GuiCountdownBossHerb.IsVisible)
			{
				GuiCountdownBossHerb.UpdateGUI();
			}
			if (GuiGemRefine.IsVisible)
			{
				GuiGemRefine.updateGUI();
			}
			if (GuiMapOcean.IsVisible)
			{
				GuiMapOcean.Update();
			}
			if (GuiFogInForestWold.IsVisible)
			{
				GuiFogInForestWold.Update();
			}
			if (GuiChooseSerialAttack.IsVisible)
			{
				GuiChooseSerialAttack.Update();
			}
			if (GuiMainEventIceCream.IsVisible)
			{
				GuiMainEventIceCream.Update();
			}
			if (GuiEffRandomSeaRightGreen.IsVisible)
			{
				GuiEffRandomSeaRightGreen.Update();
			}
			if (GuiInfoForestWorld.IsVisible)
			{
				GuiInfoForestWorld.Update();
			}
			if (GuiBackMainForest.IsVisible)
			{
				GuiBackMainForest.Update();
			}
			/*1st birthday event*/
			for (var i:int = 1; i <= 3; i++)
			{
				var tooltipCandle:TooltipCandle = this["guiTooltipCandle" + i];
				var guiBlowCandle:GUIBlowCandle = this["guiBlowCandle" + i];
				if (tooltipCandle.IsVisible)
				{
					tooltipCandle.updateGUI();
				}
				if (guiBlowCandle.IsVisible)
				{
					guiBlowCandle.updateGUI();
				}
			}
			if (GuiTrainingTower.IsVisible)
			{
				GuiTrainingTower.updateGUI();
			}
			if (guiTrungLinhThach.IsVisible)
			{
				guiTrungLinhThach.updateGUI();
			}
			if (guiPayGift.IsVisible)
			{
				guiPayGift.updateGUI();
			}
			/*EventMidAutumn*/
			if (guiFrontEvent.IsVisible)
			{
				guiFrontEvent.updateGUI();
			}
			if (guiRebornLantern.IsVisible)
			{
				guiRebornLantern.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			
			if (guiQuickBuyFuel.IsVisible)
			{
				guiQuickBuyFuel.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			if (guiQuickBuyOneFuel.IsVisible)
			{
				guiQuickBuyOneFuel.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			
			//cập nhật cho gui viễn chinh
			if (guiExpedition.IsVisible)
			{
				guiExpedition.updateGUI();
			}
			if (guiReputation.IsVisible)
			{
				guiReputation.updateInfo();
			}
			if (guiHalloween.IsVisible)
			{
				guiHalloween.updateGUI();
			}
			if (guiBuyKey.IsVisible)
			{
				guiBuyKey.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			if (guiTrickTreat.IsVisible)
			{
				guiTrickTreat.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			if (guiLockHalloween.IsVisible)
			{
				guiLockHalloween.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			if (guiTeacherEvent.IsVisible)
			{
				guiTeacherEvent.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			if (guiHuntFish.IsVisible)
			{
				guiHuntFish.updateGUI();
			}
			if (guiExchangeCandy.IsVisible)
			{
				guiExchangeCandy.updateGUI(GameLogic.getInstance().CurServerTime);
			}
			if (guiGotoHunt.IsVisible)
			{
				guiGotoHunt.updateGui(GameLogic.getInstance().CurServerTime);
			}
			if (guiExchangeNoelItem.IsVisible)
			{
				guiExchangeNoelItem.updateGui(GameLogic.getInstance().CurServerTime);
			}
			if (guiLuckyMachine.IsVisible)
			{
				guiLuckyMachine.updateGui();
			}
			
		}
		
		public function DoFullScreen(isFull:Boolean):void
		{
			if (GameLogic.getInstance().gameState <= GameState.GAMESTATE_INIT)
			{
				return;
			}
			var nWidth:int =  Constant.STAGE_WIDTH;
			var nHeight:int = Constant.STAGE_HEIGHT;
			var fWidth:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenWidth;// Constant.STAGE_WIDTH_FULL;
			var fHeight:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenHeight;//Constant.STAGE_HEIGHT_FULL;
			var tmpX:int = (fWidth - nWidth) / 2;
			var tmpY:int = (fHeight - nHeight) / 2;
			var scaleX:Number = fWidth / nWidth;
			var scaleY:Number = fHeight / nHeight;
			if (!isFull)
			{				
				scaleX = 1;
				scaleY = 1;
				IsFullScreen = false;
				Main.imgRoot.scrollRect = new Rectangle(0, 0, Constant.STAGE_WIDTH, Constant.STAGE_HEIGHT);
				Main.imgRoot.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			else
			{
				IsFullScreen = true;				
				Main.imgRoot.scrollRect = null;
			}
			
			ProcessBgFullScreen(isFull, tmpX, tmpY, scaleX, scaleY);
			if(GuiMain)
			GuiMain.Fullscreen(isFull, 0, tmpY);
			//GuiTopInfo.Fullscreen(isFull, tmpX, 0, scaleX);
			guiFrontScreen.Fullscreen(isFull, -tmpX, -tmpY, scaleX);
			guiUserInfo.Fullscreen(isFull, -tmpX, -tmpY, scaleX);
			if(GuiSetting.img)
			GuiSetting.Fullscreen(isFull, tmpX, 0);
			if(GuiFriends.img)
			GuiFriends.Fullscreen(isFull, 0, tmpY);
			//if (GameController.getInstance().typeFishWorld == -1) 
			//{
				//GuiMain.Fullscreen(isFull, 0, tmpY);
		
				
				//GuiFriends.Fullscreen(isFull, 0, tmpY);
			//}
			//else 
			//{
				//GuiMainFishWorld.Fullscreen(isFull, 0, tmpY);
				//GuiMainFishWorld.listFishInOcean.updateAllGuiToolTip();
			//}
			
			GuiStore.Fullscreen(isFull, 0, tmpY);	
		}
		
		public function ProcessBgFullScreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void
		{
			var nWidth:int =  Constant.STAGE_WIDTH;
			var nHeight:int = Constant.STAGE_HEIGHT
			var fWidth:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenWidth;
			var fHeight:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenHeight;
			
			var ObjLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			var DirtyLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);
			var CoverLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			var ActiveLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.ACTIVE_LAYER);
			var GUILayer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			var BgWave:Sprite = GameController.getInstance().BgWave;
			var disX:int;
			var disY:int;
			
			if (!IsFull)
			{
				BgLayer.scaleX = 1;
				BgLayer.scaleY = 1;
				BgLayer.x = 0;
				BgLayer.y = 0;
				
				ObjLayer.scaleX = 1;			
				ObjLayer.scaleY = 1;
				ObjLayer.x = 0;
				ObjLayer.y = 0;
				
				DirtyLayer.scaleX = 1;
				DirtyLayer.scaleY = 1;
				DirtyLayer.x = 0;
				DirtyLayer.y = 0;
				
				CoverLayer.scaleX = 1;
				CoverLayer.scaleY = 1;
				CoverLayer.x = 0;
				CoverLayer.y = 0;
				
				ActiveLayer.scaleX = 1;
				ActiveLayer.scaleY = 1;
				ActiveLayer.x = 0;
				ActiveLayer.y = 0;
				
				disX = -(BgLayer.width - nWidth) / 2;
				disY = -(BgLayer.height - nHeight) / 2 - 68;
				GameController.getInstance().PanScreenX(disX);
				GameController.getInstance().PanScreenY(disY);
				return;
			}
			//var rate:Number = fHeight / BgLayer.height;
			var rate:Number = fWidth / BgLayer.width;
			//if (rate < fHeight / BgLayer.height)
			//{
				//rate = fHeight / BgLayer.height;
			//}
			BgLayer.scaleX = rate;
			BgLayer.scaleY = rate;
			BgLayer.x = -dx;
			BgLayer.y = -dy;
			
			ObjLayer.scaleX = rate;
			ObjLayer.scaleY = rate;
			ObjLayer.x = -dx;
			ObjLayer.y = -dy;
			
			DirtyLayer.scaleX = rate;
			DirtyLayer.scaleY = rate;
			DirtyLayer.x = -dx;
			DirtyLayer.y = -dy;
			
			CoverLayer.scaleX = rate;
			CoverLayer.scaleY = rate;
			CoverLayer.x = -dx;
			CoverLayer.y = -dy;
			
			ActiveLayer.scaleX = rate;
			ActiveLayer.scaleY = rate;
			ActiveLayer.x = -dx;
			ActiveLayer.y = -dy;
			
			disX = -(BgLayer.width - fWidth) / 2;
			disY = -(BgLayer.height - fHeight) / 2;
			GameController.getInstance().PanScreenX(disX);
			GameController.getInstance().PanScreenY(disY);
		}
	}

}