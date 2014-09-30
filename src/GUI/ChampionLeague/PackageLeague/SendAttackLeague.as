package GUI.ChampionLeague.PackageLeague 
{
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.LogicLeague.Player;
	import NetworkPacket.BasePacket;
	
	/**
	 * gói dữ liệu đánh nhau trong liên đấu
	 * @author HiepNM2
	 */
	public class SendAttackLeague extends BasePacket 
	{
		//các thuộc tính gửi lên, tạm thời để giống đánh nhà bạn
		//public var FishId:int;
		//public var SoldierLakeId:int;
		//public var FriendId: int;
		//public var FriendLakeId:int;
		//public var ItemList:Array;
		//public var VictimId:int;
		
		public var FightRank:int;
		public function SendAttackLeague(rank:int) 
		{
			URL = "OccupyService.occupy";//tạm thời
			ID = Constant.CMD_ATTACK_IN_LEAGUE;
			FightRank = rank;
			//FishId = me.SoldierId;
			//SoldierLakeId = LeagueMgr.getInstance().getSoldierById(me.SoldierId).LakeId;
			//FriendId = victim.Id;
			//FriendLakeId = 1;//tạm thời
			//ItemList = [];
			//VictimId = victim.SoldierId;
			
			IsQueue = false;
		}
	}

}