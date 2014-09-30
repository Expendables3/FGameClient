package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendAttackWorld extends BasePacket 
	{
		public var IdSoldier:int;		// id con cá ho nha minh dem di tan cong
		public var SeaId:int;			// id bien minh di tan con
		public var LakeId: int;			// id ho cua con ca
		public var ItemList:Array;		// danh sach cac item buff them
		public var IdMonster:int;		// id cua quai vat
		
		public function SendAttackWorld(obj:Object) 
		{
			ID = Constant.CMD_ATTACK_OCEAN_SEA;
			URL = "FishWorldService.acttackMonster";
			IdSoldier = obj["IdSoldier"];
			SeaId = obj["SeaId"];
			LakeId = obj["LakeId"];
			IdMonster = obj["IdMonster"];
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