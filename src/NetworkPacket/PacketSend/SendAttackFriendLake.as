package NetworkPacket.PacketSend 
{
	import GUI.EventMagicPotions.QuestHerbMgr;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendAttackFriendLake extends BasePacket 
	{
		public var FishId:int;
		public var SoldierLakeId:int;
		public var FriendId: int;
		public var FriendLakeId:int;
		public var ItemList:Array;
		public var VictimId:int;
		
		public function SendAttackFriendLake(obj:Object) 
		{
			ID = Constant.CMD_ATTACK_FRIEND_LAKE;
			URL = "FishService.attackFriendLake";
			FishId = obj["myFishId"];
			SoldierLakeId = obj["myLakeId"];
			FriendId = obj["theirId"];
			FriendLakeId = obj["theirLake"];
			ItemList = obj["Item"];
			VictimId = obj["VictimId"];
			IsQueue = false;
		}
		
		public function SetItemList(a:Array):void
		{
			ItemList = [];
			
			// M?t s? item du?c g?i kèm lên khi ch?i: BuffExp, BuffMoney
			for (var i:int = 0; i < a.length; i++)
			{
				if ((a[i]["Type"] == "BuffExp" || a[i]["Type"] == "BuffMoney" || a[i]["Type"] == "BuffRank") && a[i]["Used"] > 0)
				{
					var o:Object = new Object();
					o.ItemType = a[i].Type;
					o.ItemId = a[i].Id;
					o.Num = a[i].Used;
					ItemList.push(o);
				}
			}
		}
	}

}