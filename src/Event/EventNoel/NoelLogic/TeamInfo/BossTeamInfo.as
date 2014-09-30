package Event.EventNoel.NoelLogic.TeamInfo 
{
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class BossTeamInfo extends RoundBossTeamsInfo 
	{
		
		public function BossTeamInfo(type:int) 
		{
			super(type);
		}
		override public function init(data:Object):void 
		{
			var info:FishAbstractInfo;
			_oFish = new Object();
			_numFish = 1;
			info = FishAbstractInfo.createFishInfo(data["FishType"], data["FishId"]);
			info.setInfo(data);
			_oFish[info.Id] = info;
		}
	}

}