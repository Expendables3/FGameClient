package Event.EventNoel.NoelLogic.TeamInfo 
{
	/**
	 * Thông tin của những team thuộc vòng Boss
	 * @author HiepNM2
	 */
	public class RoundBossTeamsInfo extends TeamAbstractInfo 
	{
		
		public function RoundBossTeamsInfo(type:int) 
		{
			super(type);
		}
		
		static public function createTeamInfo(numFish:int):RoundBossTeamsInfo 
		{
			switch(numFish)
			{
				case 1:
					return new BossTeamInfo(BOSS);
				default:
					return new CircleTeamInfo(CIRCLE);
			}
		}
	}

}