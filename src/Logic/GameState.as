package Logic 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class GameState
	{
		public static const GAMESTATE_ERROR:int = -1;
		public static const GAMESTATE_INIT:int = 0;
		public static const GAMESTATE_IDLE:int = 1;
		public static const GAMESTATE_BUY_DECORATE:int = 2;
		public static const GAMESTATE_BUY_FISH:int = 3;
		public static const GAMESTATE_FEED_FISH:int = 4;
		public static const GAMESTATE_MOVE_DECORATE:int = 5;
		public static const GAMESTATE_INFO_DECORATE:int = 6;
		//public static const GAMESTATE_XXX:int = 7;
		public static const GAMESTATE_USE_DECORATE:int = 8;				
		public static const GAMESTATE_UNLOCK_LAKE:int = 9;
		public static const GAMESTATE_UPGRADE_LAKE:int = 10;
		public static const GAMESTATE_CURE_FISH:int = 11;
		public static const GAMESTATE_SELL_FISH:int = 12;
		public static const GAMESTATE_REMOVE_LETTER:int = 13;
		public static const GAMESTATE_EDIT_DECORATE:int = 14;
		public static const GAMESTATE_CARE_FISH:int = 15;
		public static const GAMESTATE_RESET_MATE_FISH:int = 16;
		public static const GAMESTATE_INIVTE_FRIEND:int = 17;
		public static const GAMESTATE_REBORN_XFISH:int = 18;
		public static const GAMESTATE_OPEN_MAGIC_BAG:int = 19;
		public static const GAMESTATE_TREASURE:int = 20;
		public static const GAMESTATE_ADD_MATERIAL_FOR_FISH:int = 21;
		public static const GAMESTATE_BUY_BACKGROUND:int = 22;
				
		public static const GAMESTATE_RECOVER_HEALTH_SOLDIER:int = 23;
		public static const GAMESTATE_PREVIEW_BACKGROUND:int = 24;
		public static const GAMESTATE_OTHER_BUFF_SOLDIER:int = 25;
		public static const GAMESTATE_INCREASE_RANK_POINT:int = 26;
		public static const GAMESTATE_REVIVE_SOLDIER:int = 27;
		public static const GAMESTATE_OPTION_GRAVE:int = 28;
		public static const GAMESTATE_USE_HERB_POTION:int = 29;
		//public static const GAMESTATE_FISHWAR:int = 30;
		
		//Các gameState dành cho thế giới cá
		public static const GAMESTATE_FISHWORLD_NORMAL:int = 100;
		public static const GAMESTATE_FISHWORLD_FOREST_SWIM_1:int = 101;
		public static const GAMESTATE_FISHWORLD_FOREST_SWIM_2:int = 102;
		public static const GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_IN:int = 103;
		public static const GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_NO_REACHDES:int = 1041;
		public static const GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_REACHDES:int = 1042;
		public static const GAMESTATE_FISHWORLD_FOREST_PRE_ATTACK:int = 105;
		public static const GAMESTATE_FISHWORLD_FOREST_WAIT_SET_QUEUE_FS_NO_REACHDES:int = 1061;
		public static const GAMESTATE_FISHWORLD_FOREST_WAIT_SET_QUEUE_FS_REACHDES:int = 1062;
		public static const GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_NO_REACHDES:int = 1071;
		public static const GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_REACHDES:int = 1072;
		public static const GAMESTATE_FISHWORLD_FOREST_PRE_CREATE_WAR:int = 108;
		public static const GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR:int = 109;
		public static const GAMESTATE_FISHWORLD_FOREST_WARRING:int = 110;
		public static const GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS:int = 111;
		public static const GAMESTATE_FISHWORLD_FOREST_COME_BACK_STANBYPOS_WIN:int = 112;
		public static const GAMESTATE_FISHWORLD_FOREST_SWIM_TO_GET_GIFT:int = 113;
		public static const GAMESTATE_FISHWORLD_FOREST_GET_GIFT:int = 114;
		public static const GAMESTATE_FISHWORLD_FOREST_NEXT_GET_GIFT:int = 115;
			
		public function GameState() 
		{
			
		}
		
	}

}