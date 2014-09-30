package  
{
	import flash.display.Sprite;
	import flash.system.Capabilities;
	/**
	 * Lớp chứa đựng các hằng số của game
	 * @author tuan
	 */
	public class Constant
	{
		static public const FRAME_RATE:int = 30;
		static public const EQUIPMENT_SOURCE_SHOP:int = 1;
		static public const EQUIPMENT_SOURCE_FISHWORLD:int = 2;
		static public const EQUIPMENT_SOURCE_DAILYGIFT:int = 3;
		static public const EQUIPMENT_SOURCE_COLLECTION:int = 4;
		static public const EQUIPMENT_SOURCE_DAILYQUEST:int = 5;
		static public const EQUIPMENT_SOURCE_EVENT:int = 6;
		static public const EQUIPMENT_SOURCE_LUCKYMACHINE:int = 7;
		
		static public const NUM_SOCK_EXCHANGE:int = 10;
		
		public static const DEV_MODE:Boolean = true;
		//public static const DEV_MODE:Boolean = false;
		//public static const Minh_dep_zai:Boolean = true;	// cái này sau này sẽ bỏ, đừng bé nào đụng vào nhoa :D
		
		//public static const tree:int = 1;
		//public static const fish:int = 2;
		public static const eventDataHeader:String = "eventData_";
		public static const DefaultDataID:int = 0;
		
		public static const EmptyLayer:int = -1;		
		
		//Boss server
		static public const CMD_SEND_GET_BONUS_BOSS_SERVER:String = "cmdSendGetBonusBossServer";
		static public const CMD_SEND_ATTACK_BOSS_SERVER:String = "cmdSendAttackBossServer";
		static public const CMD_SEND_GET_INFO_BOSS_SERVER:String = "cmdSendGetInfoBossServer";
		static public const CMD_SEND_RANDOM_DICE:String = "cmdSendRandomDice";
		static public const CMD_SEND_JOIN_ROOM:String = "cmdSendJoinRoom";
		//Cac trang thai mat khau an toan
		public static const PW_STATE_UNAVAILABLE:String = "IsUnavailable";
		public static const PW_STATE_IS_BLOCKED:String = "IsBlocked";
		public static const PW_STATE_NO_PASSWORD:String = "NoPassword";
		public static const PW_STATE_IS_LOCK:String = "IsLock";
		public static const PW_STATE_IS_UNLOCK:String = "IsUnlock";
		public static const PW_STATE_IS_CRACKING:String = "IsCracking";
		static public const CMD_BUY_PASSWORD_FEATURE:String = "cmdBuyPasswordFeature";
		static public const CMD_CANCEL_CRACK_PASSWORD:String = "cmdCancelCrackPassword";
		static public const CMD_SEND_CRACK_PASSWORD:String = "cmdSendCrackPassword";
		static public const CMD_SEND_CHANGE_PASSWORD:String = "cmdSendChangePassword";
		static public const CMD_SEND_SIGN_IN:String = "cmdSendSignIn";
		static public const CMD_SEND_CREATE_PASSWORD:String = "cmdSendCreatePassword";
		static public const CMD_SELL_ITEM:String = "cmdSellItem";
		static public const CMD_GET_LIST_ITEM:String = "cmdGetListItem";
		
		// network packet
		static public const CMD_SEND_AUTO_SEPARATE_EQUIP:String = "cmdSendAutoSeparateEquip";
		static public const CMD_RECIEVE_GIFT_EURO:String = "cmdRecieveGiftEuro";
		static public const CMD_SEND_PREDICTION:String = "cmdSendPrediction";
		static public const CMD_BUY_EURO_BALL:String = "cmdBuyEuroBall";
		static public const CMD_GET_EURO_INFO:String = "cmdGetEuroInfo";
		static public const CMD_SEND_UPGRADDE_MERIDIAN:String = "cmdSendUpgraddeMeridian";
		static public const CMD_BUY_CONFIRM:String = "cmdBuyConfirm";
		static public const CMD_SEND_CHANGE_SOLDIER_NAME:String = "cmdSendChangeSoldierName";
		static public const CMD_BUY_DIAMOND:String = "cmdBuyDiamond";
		static public const CMD_SEND_BUY_ITEM_COLLECTION:String = "cmdSendBuyItemCollection";
		static public const CMD_GET_DIAMOND:String = "cmdGetDiamond";
		static public const CMD_SEND_BUY_ITEM_SHOP_MARKET:String = "cmdSendBuyItemShopMarket";
		static public const CMD_BUY_ITEM:String = "cmdBuyItem";
		static public const CMD_GET_ITEM_BACK:String = "cmdGetItemBack";
		static public const CMD_GET_LIST_SELL:String = "cmdGetListSell";
		static public const CMD_BUY_DISCOUNT:String = "cmdBuyDiscount";
		static public const CMD_BUY_SPIRIT:String = "cmdBuySpirit";
		static public const CMD_CREATE_EQUIP:String = "cmdCreateEquip";
		static public const CMD_GET_INGRADIENT:String = "cmdGetIngradient";
		public static const TEST:String = "TEST_PACKAGE";
		static public const CMD_SEND_SEPARATE_EQUIP:String = "cmdSendSeparateEquip";
		public static const CMD_USE_PETROL:String = "CmdUsePetrol";
		public static const CMD_REQ_DAILY_GIFT:String = "CmdRegDailyGift";
		public static const CMD_INIT_RUN:String = "CmdInitRun";		
		public static const CMD_REFRESH_FRIEND:String = "CmdRefreshFriend";		
		public static const CMD_LOAD_INVENTORY:String = "CmdLoadInventory";
		public static const CMD_LOAD_INVENTORY_SOLDIER:String = "CmdLoadInventorySoldier";
		public static const CMD_BUY_OTHER:String = "CmdBuyOther";
		public static const CMD_BUY_DECORATE:String = "BuyDecorate";
		public static const CMD_BUY_BACKGROUND:String = "BuyBackGround";
		public static const CMD_MOVE_DECORATE:String = "CmdMoveDecorate";
		public static const CMD_SELL_DECORATE:String = "CmdDSellecorate";
		public static const CMD_STORE_ITEM:String = "CmdStoreItem";
		public static const CMD_CREATE_GIFT_FOR_FISH:String = "CmdCreateGiftForFish";
		public static const CMD_BUY_FISH:String = "CmdBuyFish";
		public static const CMD_SELL_FISH:String = "CmdSellFish";
		public static const CMD_MIX_FISH:String = "CmdMixFish";
		public static const CMD_MATE_FISH:String = "CmdMateFish";
		public static const CMD_UNLOCK_SLOT_MATERIAL:String = "CmdUnlockSlotMaterial";
		public static const CMD_UNLOCK_LAKE:String = "CmdUnlockLake";
		public static const CMD_UPGRADE_LAKE:String = "CmdUpgradeLake";
		public static const CMD_SELL_STOCK_THING:String = "CmdSellStockThing";
		public static const CMD_CURE_FISH:String = "CmdCureFish";
		public static const CMD_FEED_FISH:String = "CmdFeedFish";
		public static const CMD_SEND_LETTER:String = "CmdSendLetter";
		public static const CMD_LOAD_MAIL: String = "CmdLoadMail";
		public static const CMD_LOAD_GIFT: String = "CmdLoadGift";
		public static const CMD_SEND_GIFT: String = "CmdSendGift";
		public static const CMD_CLEAN_LAKE:String = "CmdCleanLake";
		public static const CMD_REMOVE_MESSAGE:String = "CmdRemoveMessage";
		public static const CMD_REMOVE_SYSTEM_MESSAGE:String = "CmdRemoveSystemMessage";
		public static const CMD_READ_SYSTEM_MESSAGE:String = "CmdReadSystemMessage";
		public static const CMD_INPUT_CODE:String = "CmdInputCode";
		public static const CMD_LEVEL_UP:String = "CmdLevelUp";
		public static const CMD_FILL_ENERGY:String = "CmdFillEnergy";
		public static const CMD_LEVEL_UP_SKILL_MATERIAL:String = "CmdLevelUpSkillMaterial";
		public static const CMD_PLAY_SLOT_MACHINE:String = "CmdPlaySlotMachine";
		public static const CMD_CARE_FISH:String = "CmdCareFish";
		public static const CMD_ACCEPT_GIFT: String = "CmdAcceptGift";
		public static const CMD_BUY_OPEN_KEY: String = "CmdBuyOpenKey";
		public static const CMD_USE_OPEN_KEY: String = "CmdUseOpenKey";
		public static const CMD_READ_MAIL: String = "CmdReadMail";
		public static const CMD_GET_TOTAL_FISH: String = "CmdGetTotalFish";
		public static const CMD_CHANGE_FISH: String = "CmdChangeFish";
		public static const CMD_FISHING: String = "CmdFishing";
		public static const CMD_FEED_ONWALL: String = "CmdFeedWall";
		public static const CMD_COMPLETE_DAILY_QUEST: String = "CmdCompleteDailyQuest";
		public static const CMD_COMPLETE_SERIES_QUEST: String = "CmdCompleteSeriesQuest";
		public static const CMD_ACCEPT_DAILY_GIFT: String = "CmdAcceptDailyGift";
		public static const CMD_USE_ITEM: String = "CmdUseItem";
		public static const CMD_GET_DAILY_QUEST: String = "CmdGetDailyQuest";
		public static const CMD_GET_DAILY_QUEST_NEW: String = "CmdGetDailyQuestNew";
		public static const CMD_DONE_DAILY_QUEST_BY_XU: String = "CmdDoneByXu";
		public static const CMD_UNLOCK_DAILYQUEST: String = "CmdUnlockDailyQuest";
		public static const CMD_COMPLETE_DAILY_QUEST_NEW: String = "CmdCompleteDailyQuestNew";
		public static const CMD_GET_SERIES_QUEST: String = "CmdGetSeriesQuest";
		public static const CMD_HIT_EGG: String = "CmdHitEgg";
		public static const CMD_STEAL_MONEY: String = "CmdStealMoney";
		public static const CMD_COLLECT_MONEY: String = "CmdCollectMoney";
		public static const CMD_GET_ALL_LOG: String = "CmdGetAllLog";
		public static const CMD_SET_LOG: String = "CmdSetLog";
		public static const CMD_REMOVE_LOG: String = "CmdRemoveLog";
		public static const CMD_USE_BABY_FISH: String = "CmdUseBabyFish";
		public static const CMD_MATERIAL:String = "CmdMaterial";
		public static const CMD_GET_GIFT_OF_FISH: String = "CmdGetGiftOfFish";
		public static const CMD_CHOOSE_AVATAR:String = "CmdChooseAvatar";
		public static const CMD_CREATE_USER:String = "CmdCreateUser";
		public static const CMD_GET_DAILY_FRIEND_BONUS:String = "CmdDailyFriendBonus";
		public static const CMD_GET_DAILY_ENERGY:String = "CmdDailyEnergy";
		public static const CMD_SELL_SPARTA:String = "CmdSellSparta";
		public static const CMD_SELL_CHANGE_LAKE:String = "CmdChangeLakeSparta";
		public static const CMD_UPDATE_SPARTA:String = "CmdUpdateExpired";
		public static const CMD_GET_DAILY_BONUS:String = "CmdGetDailyBonus";
		public static const CMD_RECHOOSE_DAILY_BONUS:String = "CmdRechooseDailyBonus";
		public static const CMD_UPGRADE_SKILL:String = "CmdUpgradeSkill";
		public static const CMD_RESET_DAILYQUEST:String = "CmdResetDailyQuest";
		public static const CMD_RECEIVE_GIFT_ON_FRIEND:String = "CmdReceiveOnFriend";
		public static const CMD_GET_SIGN_KEY:String = "CmdGetSignKey";
		public static const CMD_USE_VIAGRA:String = "CmdUseViagra";
		public static const CMD_BUY_PETROL:String = "CmdBuyPetrol";
		public static const CMD_EXPIRED_ENERGY_MACHINE:String = "CmdExpiredEnergyMachine";
		public static const CMD_SNAPSHOT:String = "CmdSnapshot";
		public static const CMD_EXCHANGEFAIRYDROP:String = "CmdExchangeFairyDrop";
		public static const CMD_GET_BUFF_LAKE:String = "CmdGetBuffLake";
		public static const CMD_BUY_FAIRY_DROP:String = "CmdBuyFairyDrop";
		public static const CMD_OPEN_MAGIC_BAG:String = "CmdOpenMagicBag";
		public static const CMD_OPEN_LIXI:String = "CmdOpenLixi";
		public static const CMD_SEND_CLICK_MERMAID:String = "CmdSendClickMerMaid";
		public static const CMD_OPEN_TRUNK:String = "CmdOpenTrunk";
		public static const CMD_BUY_EVENT:String = "CmdBuyEvent";
		public static const CMD_CHANGE_KEY:String = "CmdChangeKey";
		public static const CMD_ATTACK_FRIEND_LAKE:String = "CmdAttackFriendLake";
		public static const CMD_LOAD_OCEAN_SEA:String = "CmdLoadOceanSea";
		public static const CMD_UNLOCK_OCEAN_SEA:String = "CmdUnlockOceanSea";
		public static const CMD_JOIN_SEA_AGAIN:String = "CmdJoinSeaAgain";
		public static const CMD_GET_SERIAL_ATTACK_FOREST_YELLOW:String = "CmdGetSerialAttackForestYellow";
		public static const CMD_ATTACK_BOSS_FOREST:String = "CmdAttackBossForest";
		public static const CMD_USE_LOTUS:String = "CmdUseLotus";
		public static const CMD_ICE_CREAM_UNLOCK_SLOT:String = "CmdIceCreamUnlockSlot";
		public static const CMD_ICE_CREAM_DELETE_SLOT:String = "CmdIceCreamDeleteSlot";
		public static const CMD_ICE_CREAM_MAKE_RAIN:String = "CmdIceCreamMakeRain";
		public static const CMD_ICE_CREAM_CREATE_ICE_CREAM:String = "CmdIceCreamCreateIceCream";
		public static const CMD_ICE_CREAM_BUY_ITEM:String = "CmdIceCreamBuyItem";
		public static const CMD_ICE_CREAM_BUY_ITEM_BY_DIAMOND:String = "CmdIceCreamBuyItemByDiamond";
		public static const CMD_ICE_CREAM_MAKE_HEAVY_RAIN:String = "CmdIceCreamCreateHeavyRain";
		public static const CMD_ICE_CREAM_HARVEST_ICE_CREAM:String = "CmdIceCreamHaverstIceCream";
		public static const CMD_ICE_CREAM_THEFT_ICE_CREAM:String = "CmdIceCreamTheftIceCream";
		//public static const CMD_JOIN_OCEAN_SEA_AGAIN:String = "CmdJoinOceanSeaAgain";
		public static const CMD_ATTACK_OCEAN_SEA:String = "CmdAttackOceanSea";
		public static const CMD_ATTACK_BOSS_OCEAN_SEA:String = "CmdAttackBossOceanSea";
		public static const CMD_CHOOSE_ROUND_ATTACK:String = "CmdChooseRoundAttack";
		public static const CMD_GET_ALL_SOLDIER:String = "CmdGetAllSoldier";
		public static const CMD_GET_BONUS_SOLDIER:String = "CmdGetBonusSoldier";
		public static const CMD_LEVEL_UP_SOLDIER:String = "CmdLevelUpSoldier";
		public static const CMD_RECOVER_HEALTH_SOLDIER:String = "CmdRecoverHealthSoldier";
		public static const CMD_REBORN_SOLDIER:String = "CmdRebornSoldier";
		public static const CMD_UPDATE_EXPIRED_SOLDIER:String = "CmdUpdateExpiredSoldier";
		public static const CMD_BIOCHEMICAL_SOLDIER:String = "CmdBioChemicalSoldier";
		public static const CMD_CLICK_GRAVE:String = "CmdClickGrave";
		public static const CMD_BUY_SPECIAL_FISH:String = "CmdBuySpecialFish";
		public static const CMD_SEND_GET_GIFT_EVENT_SOLDIER:String = "CmdSendGetGiftEventSoldier";
		public static const CMD_EXCHANGE_STAR:String = "CmdExchangeStar";
		public static const CMD_USE_ITEM_SOLDIER:String = "CmdUseItemSoldier";
		public static const CMD_USE_EQUIPMENT_SOLDIER:String = "CmdUseEquipmentSoldier";
		public static const CMD_EXTEND_EQUIPMENT:String = "CmdExtendEquipment";
		public static const CMD_STORE_EQUIPMENT:String = "CmdStoreEquipment";
		public static const CMD_DELETE_EQUIPMENT:String = "CmdDeleteEquipment";
		public static const CMD_UPDATE_EXPIRED_EQUIPMENT:String = "CmdUpdateExpiredEquipment";
		public static const CMD_UPDATE_EXPIRED_TIME_OF_EQUIPMENT:String = "CmdUpdateExpiredTimeOfEquipment";
		public static const CMD_BUY_EQUIPMENT:String = "CmdBuyEquipment";
		public static const CMD_UNLOCK_SLOT_ENCHANT:String = "CmdUnlockSlotEnchant";
		public static const CMD_ENCHANT_EQUIPMENT:String = "CmdEnchantEquipment";
		public static const CMD_CHANGE_ENCHANT_LEVEL:String = "cmdChangeEnchantLevel";
		public static const CMD_NEXT_MAP:String = "CmdNextMap";
		public static const CMD_GET_EVENT_ON_ROAD:String = "CmdGetEventOnRoad";
		public static const CMD_ANSWER_QUESTION:String = "CmdAnswerQuestion";
		public static const CMD_SEND_BUY_ARROW:String = "CmdBuyArrow";
		public static const CMD_RANDOM_DICE:String = "CmdRandomDice";
		public static const CMD_GO_GO:String = "CmdDiceGo";
		public static const CMD_TELEPORT:String = "CmdTeleport";
		public static const CMD_SEND_BUY_SOLDIER:String = "CmdSendBuySoldier";
		//Event 2-9
		public static const CMD_SEND_GET_GIFT_EVENT_ND:String = "CmdSendGetGiftEventND";
		public static const CMD_SEND_BUY_ICON_ND:String = "CmdSendBuyIconND";
		public static const CMD_SEND_CLICK_GIFT_FIREWORK:String = "CmdSendClickGiftFirework";
		public static const CMD_SEND_MAKE_WISH:String = "CmdSendMakeWish";
		static public const CMD_SEND_EXHANGE_GREEN_SOCK:String = "cmdSendExhangeGreenSock";
		
		// Event Magic Potions
		public static const CMD_SEND_GET_HERB_LIST:String = "CmdSendGetHerbList";
		public static const CMD_SEND_QUICK_DONE_HERB_QUEST:String = "CmdQuickDoneHerbQuest";
		public static const CMD_SEND_DONE_HERB_QUEST:String = "CmdDoneHerbQuest";
		public static const CMD_SEND_GET_NEW_HERB_QUEST:String = "CmdSendGetNewHerbQuest";
		public static const CMD_SEND_EXCHANGE_HERB_ITEM:String = "CmdSendExchangeHerbItem";
		public static const CMD_SEND_ATTACK_HERB_BOSS:String = "CmdAttackHerbBoss";
		public static const CMD_SEND_USE_HERB_POTION:String = "CmdUseHerbPotion";
		public static const CMD_SEND_AUTO_DONE_HERB_QUEST:String = "CmdAutoDoneHerbQuest";
		public static const CMD_SEND_EXCHANGE_HERB_MEDAL:String = "CmdSendExchangeHerbMedal";
		public static const CMD_SEND_REBORN_HERB_BOSS:String = "CmdSendRebornHerbBoss";
		
		// PowerTinhQuest
		public static const CMD_SEND_GET_POWER_TINH_QUEST:String = "CmdSendGetPowerTinhQuest";
		public static const CMD_SEND_EXCHANGE_POWER_TINH:String = "CmdSendExchangePowerTinh";
		
		// GEM
		public static const CMD_USE_GEM:String = "CmdUseGem";
		public static const CMD_UPGRADE_GEM:String = "SendUpgradeGem";
		public static const CMD_RECOVER_GEM:String = "SendRecoverGem";
		public static const CMD_CANCEL_UPGRADE:String = "SendCancelUpgrade";
		public static const CMD_GET_GEM:String = "SendGetGem";
		public static const CMD_QUICK_UPGRADE:String = "SendQuickUpgrade";
		public static const CMD_DELETE_GEM:String = "SendDeleteGem";
		
		//Gia hạn đồ trang trí
		public static const CMD_SEND_EXTEND_DECO:String = "CmdSendExtendDeco";
		public static const CMD_SEND_EXPIRED_DECO:String = "CmdSendExpiredDeco";
		
		public static const CMD_GET_NEW_USER_GIFT_BAG:String = "CmdSendGetNewUserGiftBag"; 
		public static const CMD_FIRST_TIME_LOGIN:String = "SendFirstTimeLogin";
		
		//Offline exp
		public static const CMD_GET_OFFLINE_EXP:String = "CmdGetOfflineExp";
		public static const CMD_SYNC_OFFLINE_EXP:String = "CmdSyncOfflineExp";
		
		//Collection
		static public const CMD_SEND_EXCHANGE_COLLECTION:String = "cmdSendExchangeCollection";
		public static const CMD_ADD_MATERIAL_FISH:String = "addMaterialFish";
		
		//Event
		static public const CMD_SEN_GET_TOP_EVENT_WAR_CHAMPION:String = "cmdSenGetTopEventWarChampion";
		static public const CMD_SEN_GET_REWARD_EVENT_WAR_CHAMPION:String = "cmdSenGetRewardEventWarChampion";
		
		//LuckyMachine
		public static const CMD_SEND_PLAY_LUCKY_MACHINE:String = "cmdplayLuckyMachine";
		public static const CMD_SEND_BUY_TICKET_FOR_LM:String = "cmdbuyTicketForLM";
		public static const CMD_SEND_USE_RANK_POINT_BOTTLE:String = "cmdUseRankPointBottle";
		
		public static const CMD_SEND_CARE_FLOWER:String = "cmdSendCareFlower";
		public static const CMD_SEND_SEEK_GROWUP_FLOWER:String = "cmdSendSeekGrowUpFlower";
		public static const CMD_SEND_OPEN_FLOWERBOX:String = "cmdSendOpenFlowerBox";
		public static const CMD_SEND_BUY_FLOWER:String = "cmdSendBuyFlower";
		public static const CMD_SEND_CHANGE_POINT:String = "cmdChangePointToGetGift";
		
		//event 1st Birthday
		public static const CMD_SEND_BUY_BIRTHDAYITEM:String = "cmdSendBuyBirthDayItem";
		public static const CMD_SEND_OPEN_BIRTHDAYBOX:String = "cmdSendOpenBirthDayBox";
		public static const CMD_SEND_BURN_CANDLE:String = "cmdSendBurnCandle";
		static public const CMD_BLOW_CANDLE:String = "cmdBlowCandle";
		static public const CMD_GET_GIFT_IN_MAGIC_LAMP:String = "cmdGetGiftInMagicLamp";
		
		// tournament		
		static public const CMD_GET_GIFT_TOUR_INFO:String = "cmdGetGiftTourInfo";
		static public const CMD_GET_GIFT:String = "cmdGetGiftTour";
		
		//training tower
		static public const CMD_GET_STATUS_TRAINING:String = "cmdGetStatusTraining";
		static public const CMD_START_TRAININGTOWER:String = "cmdStartTrainingtower";
		static public const CMD_UNLOCK_ROOM:String = "cmdUnlockRoom";
		static public const CMD_GET_GIFT_TRAINING:String = "cmdGetGiftTraining";
		static public const CMD_SPEEDUP_TRAINING:String = "cmdSpeedupTraining";
		static public const CMD_STOP_TRAINING:String = "cmdStopTraining";
		
		//Expedition
		static public const CMD_GET_EXPEDITION_STATUS:String = "cmdGetExpeditionStatus";
		static public const SEND_TEST:String = "sendTest";
		static public const CMD_ROLLING_DICE:String = "cmdRollingDice";		
		static public const CMD_INCREASE_VALUE:String = "cmdIncreaseValue";		
		static public const CMD_DECREASE_HARD:String = "cmdDecreaseHard";		
		static public const CMD_BUY_CARD_EXPEDITION:String = "cmdBuyCardExpedition";
		static public const CMD_COMPLETE_EXPEDITION_QUEST:String = "cmdCompleteExpeditionQuest";				
		//update G
		static public const CMD_UPDATE_G:String = "cmdSendUpdateG";
		// Play tự động 
		static public const CMD_PLAY_FAST:String = "cmdSendPlayFast";
		static public const CMD_GET_GIFT_EVENT_SPRING:String = "cmdSendGetGiftEventSpring";
		
		// liên đấu
		static public const CMD_GET_STATUS_LEAGUE:String = "cmdGetStatusLeague";
		static public const CMD_REFRESH_RANK_BOARD:String = "cmdRefreshRankBoard";
		static public const CMD_ATTACK_IN_LEAGUE:String = "cmdAttackInLeague";
		static public const CMD_CHANGE_SOLDIER_IN_LEAGUE:String = "cmdChangeSoldierInLeague";
		static public const CMD_BUY_CARD:String = "cmdBuyCard";
		static public const CMD_GET_TOP_TEN_PLAYER:String = "cmdGetTopTenPlayer";
		static public const CMD_GET_GIFT_LEAGUE:String = "cmdGetGiftLeague";
		// nạp thẻ lần đầu
		static public const CMD_CHOOSE_ELEMENT:String = "cmdChooseElement";
		static public const CMD_RECEIVE_GIFT_PAY:String = "cmdReceiveGiftPay";
		public static const TYPE_PRG_HP:int = 1;
		
		public static const PUBLIC_KEY:String = "b610ef9d2c67bd7f9c3d2b447372f913";
		
		// Event
		public static const NUM_DAY_START_BUY_EVENT:int = 3;
		
		// background
		public static var MAX_WIDTH:int = 1360;
		public static var MAX_HEIGHT:int = 763;
		
		// Stage
		public static const STAGE_WIDTH:int = 810;
		public static const STAGE_HEIGHT:int = 624;
		
		// layer
		public static const TopLayer:int = 12;
		public static const BACKGROUND_LAYER:int = 0;
		public static const OBJECT_LAYER:int = 1;
		public static const DIRTY_LAYER:int = 2;
		public static const COVER_LAYER:int = 5;
		public static const GUI_MIN_LAYER:int = 6;
		public static const ACTIVE_LAYER:int = 8;
		
		//Chieu cao cua ho (tính cả vùng trang trí)
		public static const TOP_LAKE:int = 300;
		public static const TOP_LAKE_FISH_WORLD:int = 150;
		static public const TOP_SMALL_LAKE:int = 140;
		public static const HEIGHT_LAKE:int = 330;
		public static const HEIGHT_LAKE_FISH_WORLD:int = 480;
		public static const TOP_LAKE_LEAGUE:int = 150;				//thông số hồ trong liên đấu
		//public static const HEIGHT_LAKE_LEAGUE:int = 380;
		public static const HEIGHT_LAKE_LEAGUE:int = 480;
		
		public static const MAX_FISH_MIX:int = 2;
		public static const MAX_MIX_LAKE:int = 1;
		public static const MAX_NUM_RECEIVER:int = 10;
		
		// Các trường hợp lảm nhảm của cá
		public static const CHAT_CLEAN_LAKE:String = "CleanLake";
		public static const CHAT_VISITOR:String = "Visitor";
		public static const CHAT_PLAY_FISH:String = "PlayFish";
		public static const CHAT_NORMAL:String = "Normal";
		public static const CHAT_HUNGRY:String = "Hungry";
		public static const CHAT_SICK:String = "Sick";
		public static const CHAT_FRIENDLY_FEED:String = "FriendlyFeed";
		public static const CHAT_HATCH:String = "Hatch";
		public static const CHAT_WIN:String = "Win";
		public static const CHAT_LOSE:String = "Lose";
		
		// Giá xu của hệ dailyQuest mới
		public static const FINISH_TASK_BY_XU:int = 1;
		public static const UNLOCK_QUEST_BY_XU:int = 10;
		
		// Số loại nguyên liệu lai
		public static const NUM_TYPE_MATERIAL:int = 16;
		public static const NUM_TYPE_MIX_FORMULA:int = 7;
		
		public static const OFF_SERVER:Boolean = false;
		
		public static const FISH_TYPE_DISTANCE_DOMAIN:int = 6;
		public static const FISH_TYPE_START_DOMAIN:int = 44;
		public static const FISH_TYPE_START_SOLDIER:int = 300;
		//public static const FISH_TYPE_START_DOMAIN:int = 39;
		
		public static const FISH_LEVEL_MAX:int = 99;
		public static const FISH_LEVEL_MAX_NOW:int = 79;
		
		public static const MAX_BUFF_EXP:int = 500;
		public static const MAX_BUFF_TIME:int = 50;
		public static const MAX_BUFF_MONEY:int = 50;
		
		// Thế giới cá
		public static const OCEAN_NEUTRALITY:int = 1;
		public static const OCEAN_METAL:int = 2;
		public static const OCEAN_ICE:int = 3;
		public static const OCEAN_FOREST:int = 4;

		public static const OCEAN_FOREST_ROUND_1:int = 1;
		public static const OCEAN_FOREST_ROUND_2:int = 2;
		public static const OCEAN_FOREST_ROUND_3:int = 3;
		public static const OCEAN_FOREST_ROUND_4:int = 4;
		
		// SỐ trận giao chiến / ngày / hồ
		public static const MAX_COMBAT_PER_DAY:int = 5;
		
		// Số ngày còn lại thì được gia hạn trang bị cá lính
		public static const DAY_TO_EXTEND:int = 2;
		
		// Số cá lính nhà bạn tối đa
		public static const MAX_SOLDIER_IN_LAKE:int = 3;
		
		// Số tiền tối đa đánh cá thường rơi ra
		public static const MAX_PERCENT_GOLD_CAN_GET:int = 60;
		
		// Số đồng vàng và kinh nghiệm rơi ra tối đa
		public static const MAX_NUM_DROP:int = 30;
		
		public static const MIN_HEALTH_NORMAL:int = 1;
		public static const MIN_HEALTH_SOLDIER:int = 2;
		
		// Số lần cường hóa
		public static const MAX_ENCHANT_TIMES:int = 9;
		
		// Domain của gem buff cá - longpt
		//public static const GEM_DISTANCE_DOMAIN:int = 3;
		//public static const GEM_START_DOMAIN:int = 1;
		public static const GEM_MAX_PER_ELEMENT:int = 1;
		
		//Gia hạn đồ trang trí
		public static const TIME_CAN_EXTEND:int = 518400;
		public static const TIME_DISAPPEAR:int = 604800;
		public static const NUM_CAN_EXTEND_ALL:int = 5;
		
		// Thời gian delay
		public static const TIME_DELAY:int = 5;
		
		public static const ID_FULL_ENERGY:int = 6;
		public static const ID_DEFAULT_BACKGROUND:int = 1;
		//public static const ID_DEFAULT_BACKGROUND_FROM_SERVER:int = 1;		
		public static const LIMIT_BACKGROUND_NUM:int = 2;
		
		public static const TYPE_MYFISH:int = -1;
		public static const TYPE_MAP:int = -2;
		
		public static const ID_FISH_WORLD_BACKGROUND_1:int = 101;
		public static const ID_FISH_WORLD_BACKGROUND_2:int = 103;
		public static const ID_FISH_WORLD_BACKGROUND_3:int = 104;
		public static const ID_FISH_WORLD_BACKGROUND_4:int = 105;
		public static const ID_FISH_WORLD_BACKGROUND_4_ROUND_1:int = 106;
		public static const ID_FISH_WORLD_BACKGROUND_4_ROUND_2:int = 107;
		public static const ID_FISH_WORLD_BACKGROUND_4_ROUND_3:int = 108;
		public static const ID_FISH_WORLD_BACKGROUND_4_ROUND_4:int = 109;
		static public const ID_LEAGUE_BACKGROUND:int = 201;
		
		// Giới hạn ngư thạch thường
		public static const MAX_NORMAL_MATERIAL:int = 100;
		// Chỉ số của vòng boss
		public static const SEA_ROUND_4:int = 4;
		public static const SEA_ROUND_3:int = 3;
		public static const SEA_ROUND_2:int = 2;
		public static const SEA_ROUND_1:int = 1;
		public static const ROUND_KILL_BOSS:int = 4;
		
		public static const TIME_ZONE_SERVER:int = 7;
		
		public static const CMD_SEND_JOIN_ISLAND:String = "cmdSendJoinIsland";
		public static const CMD_SEND_DIG_LAND:String = "cmdSendDigLand";
		public static const CMD_SEND_EXIT_ISLAND:String = "cmdSendExitIsland";
		public static const CMD_SEND_COLLECT_GIFT:String = "cmdSendCollectGift";
		public static const CMD_SEND_CHANGE_COLLECT:String = "cmdSendChangeCollect";
		public static const CMD_SEND_CHANGE_MEDAL:String = "cmdSendChangeMedal";
		public static const CMD_SEND_AUTO_DIG:String = "cmdSendAutoDig";
		public static const CMD_SEND_IS_LUCKY:String = "cmdSendIsLucky";
		public static const CMD_BUY_ITEM_IN_EVENT:String = "cmdSendBuyItemInEvent";
		public static const CMD_BUY_ITEM_WITH_DIAMOND:String = "cmdSendBuyItemWithDiamond";
		
		static public const SoldierProperties:Array = ["Damage", "Defence", "Critical", "Vitality"];
		
		//Special smithy
		public static const CMD_BREAK_EQUIP:String = "cmdBreakEquip";
		public static const CMD_MAKE_EQUIP:String = "cmdMakeEquip";
		public static const CMD_CANCEL_OPTION:String = "cmdCancelOption";
		public static const CMD_MAKE_OPTION:String = "cmdMakeOption";
		public static const CMD_SAVE_OPTION:String = "cmdSaveOption";
		public static const CMD_GET_HAMMERMAN:String = "cmdGetHammerMan";
		
		//nạp thẻ lần đầu
		static public const CMD_GET_PAY_INFO:String = "cmdGetPayInfo";
		static public const CMD_SEND_GET_ROOM_INFO:String = "cmdSendGetRoomInfo";

		//EventMidAutumn
		static public const CMD_FIRE_LANTERN:String = "cmdFireLantern";
		static public const CMD_BUY_ITEM_EVENT_MIDAUTUMN:String = "cmdBuyItemEventMidautumn";
		static public const CMD_GET_EVENT_INFO:String = "cmdGetEventInfo";
		static public const CMD_EVENT_MIDAUTUMN_USE_FAN:String = "cmdEventMidautumnUseFan";
		static public const CMD_EXCHANGE_COLLECTION_GIFT:String = "cmdExchangeCollectionGift";
		static public const CMD_GET_STORE_MID_AUTUMN:String = "cmdGetStoreMidAutumn";
		static public const CMD_REBORN_LANTERN:String = "cmdRebornLantern";
		static public const CMD_SEND_GET_FINAL_GIFT:String = "cmdSendGetFinalGift";
		
		//EventHalloween
		static public const CMD_GET_STATUS_EVENT_HALLOWEEN:String = "cmdGetStatusEventHalloween";
		static public const CMD_UNLOCK_ROCK:String = "cmdUnlockRock";
		static public const CMD_FAIL_TRICK_TASK:String = "cmdFailTrickTask";
		static public const CMD_UNLOCK_HALLOWEEN:String = "cmdUnlockHalloween";
		static public const CMD_FINISH_AUTO_HALLOWEEN:String = "cmdFinishAutoHalloween";
		static public const CMD_BUY_PACK_HALLOWEEN:String = "cmdBuyPackHalloween";
		static public const CMD_GET_SAVE_POINT_STATUS:String = "cmdGetSavePointStatus";
		static public const CMD_CHOOSE_TRICK_OR_TREAT:String = "cmdChooseTrickOrTreat";
		static public const CMD_EXCHANGE_ACCUMULATION_POINT:String = "cmdExchangeAccumulationPoint";
		
		// reputation
		static public const CMD_SEND_GET_REPUTATION:String = "cmdSendGetReputation";
		static public const CMD_SEND_QUICK_REPUTATION:String = "cmdSendQuickReputation";
		//Event 20/11
		static public const CMD_EXCHANGE_EVENT_CHAR:String = "cmdExchangeEventGift";
		static public const CMD_RECEIVE_COMBO_GIFT:String = "cmdReceiveComboGift";
		static public const CMD_RECEIVE_CHARACTER_GIFT:String = "cmdReceiveCharacterGift";
		static public const CMD_SEND_TEST_GET_ITEM:String = "cmdSendTestGetItem";
		//EventNoel
		static public const CMD_SEND_GO_TO_SEA:String = "cmdGoToSea";
		static public const CMD_RECEIVE_NOEL_FEED:String = "cmdReceiveNoelFeed";
		static public const CMD_SEND_MAKE_BULLET:String = "cmdSendMakeBullet";
		static public const CMD_SEND_FIRE_GUN:String = "cmdSendFireGun";
		static public const CMD_SEND_ROUND_UP:String = "cmdSendRoundUp";
		static public const CMD_GET_KEEP_LOGIN:String = "cmdGetKeepLogin";
		static public const CMD_REVERT_NOEL_DAY_LOGIN:String = "cmdRevertNoelDayLogin";
		static public const CMD_RECEIVE_SHOCKS_GIFT:String = "cmdReceiveShocksGift";
		static public const CMD_OPEN_VIP_TRUNK:String = "cmdOpenVipTrunk";
		static public const CMD_GET_VIP_BOX:String = "cmdGetVipBox";
		
		static public const CMD_SEND_MIX_MATERIAL:String = "cmdSendMixMaterial";
		//Trung Linh Thach
		public static const CMD_GET_SMASH_EGG:String = "cmdGetSmashEgg";
		public static const CMD_ADD_QUARTZ_TO_SOLDIER:String = "cmdAddQuartzToSoldier";
		public static const CMD_BUY_HAMMER:String = "cmdBuyHammer";
		public static const CMD_RECEIVE_BONUS:String = "cmdReceiveBonus";
		public static const CMD_REMOVE_QUARTZ_SOLDIER:String = "cmdRemoveQuartzFromSoldier";
		public static const CMD_SMASH_EGG:String = "cmdSmashEgg";
		public static const CMD_UPGRADE_QUARTZ_SOLDIER:String = "cmdUpgradeQuartz";
		public static const CMD_BUY_DISCOUNT_HAMMER:String = "cmdBuyDiscountHammer";
		static public const CMD_EXCHANGE_POINT_GIFT:String = "cmdExchangePointGift";
		static public const CMD_SEND_FAST_COMPELTE:String = "cmdSendFastCompelte";
		public static var SMASH_EGG_EFF:Boolean = false;
		public static var ITEM_QUARTZ_MAX:int = 500;
		//Event tet2013
		static public const CMD_RECEIVE_ONLINE_GIFT:String = "cmdReceiveOnlineGift";
		static public const CMD_REVERT_DAY_GIFT:String = "cmdRevertDayGift";
		
		public function Constant() 
		{
			
		}
		
	}

}