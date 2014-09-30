package GUI.ChampionLeague.LogicLeague 
{
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.GuiMgr;
	/**
	 * đối tượng cái nút bên ngoài GuiTopInfo
	 * @author HiepNM2
	 */
	public class League 
	{
		static public const STATE_OK:int = 1;
		static public const STATE_NO_SOLDIER:int = -1;
		static public const STATE_NO_LEVEL:int = 0;
		
		private var _league:ButtonEx;		//reference đến cái nút liên đấu bên ngoài guitopinfo
		private var _state:int;
		public function League() 
		{
			//_league = GuiMgr.getInstance().GuiTopInfo.btnLeague;
			_league = GuiMgr.getInstance().guiFrontScreen.btnSeriesFighting;
		}
		
		public function get State():int 
		{
			return _state;
		}
		
		public function set State(value:int):void 
		{
			_state = value;
			switch(value)
			{
				case STATE_NO_LEVEL:
				case STATE_NO_SOLDIER:
					_league.SetVisible(false);
				break;
				default:
					_league.SetVisible(true);
			}
		}
		
	}

}