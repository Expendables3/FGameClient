package Logic 
{
	import Data.ConfigJSON;
	import Data.INI;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author ducnh
	 */
	public class Lake
	{
		public static const MAX_DIRTY:int = 3;
		
		public var NumFish:int = 0;
		public var NumDecorate:int = 0;
		public var CurCapacity:int = 0;
		public var MaxLevel:int = 0;
		
		public var NumSoldier:int = 0;
		public var CurCapacitySoldier:int = 3; // fix
		
		private var DirtyTime:int = 7200;
		
		// thong tin lay tu database ve
		public var CleanAmount:int = 0;
		public var Id:int;
		public var Level:int = 0;
		public var StartTime:Number;
		public var StarTimeOriginal:Number;
		public var TotalEgg:Number = 0;
		public var Option:Object;
		public var FishList:Object = new Object();
		public var Attack:Object = new Object();
		
		public var LakeLevels:Array = [];
		
		public function Lake(id:int, maxLevel:int, IsUnlock:Boolean) 
		{
			Id = id;
			MaxLevel = maxLevel;
			if (IsUnlock)
			{
				Level = 1;
			}
			
			var i:int;
			
			for (i = 0; i < maxLevel; i++)
			{
				//var tg:Object = INI.getInstance().getLakeInfo(id.toString(), i);
				var tg:Object = ConfigJSON.getInstance().getItemInfo("Lake", Id)[i + 1];
				
				LakeLevels.push(tg);
			}
			
			//DirtyTime = INI.getInstance().getLakeInfo(Id.toString(), 1)["DirtyTime"];
			DirtyTime = ConfigJSON.getInstance().getItemInfo("Lake", Id)[1]["DirtyTime"];
		}
		
		public function SetLevel(level:int):void
		{
			Level = level;
			if (Level <= 0)
			{
				Level = 0;
				CurCapacity = 0;
				//trace("CurCapacity", CurCapacity);
			}
			else
			{
				try 
				{
					CurCapacity = LakeLevels[level - 1]["TotalFish"];
				}
				catch (err:Error)
				{
					//Đoạn này chỉ là kiểm tra lại trong trường hợp server trả về level hồ lớn hơn max level
					//Nếu lớn hơn max level không lấy được dữ liệu trong file config và dẫn tới lỗi truy cập ngoài mảng
					if (level > MaxLevel)
						level = MaxLevel;
					else if (level < 1)
						level = 1;
					Level = level;
					CurCapacity = LakeLevels[level - 1]["TotalFish"];
					//trace("ngoài mảng LakeLevels");
				}
				
			}
		}
		
		public function SetInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
			SetLevel(Level);
		}
		
		public function GetDirtyAmount():int
		{
			var dt:Number = (GameLogic.getInstance().CurServerTime - StartTime)/DirtyTime - CleanAmount;
			if (dt > MAX_DIRTY)
			{
				dt = MAX_DIRTY;
				StartTime = GameLogic.getInstance().CurServerTime - (MAX_DIRTY + CleanAmount) * DirtyTime ;
			}
			if (dt < 0) 
			{
				dt = 0;
			}
			return dt;
		}
		
		public function GetUnlockMoney():int
		{
			if (Level > 0)
			{
				return 0;
			}
			
			return LakeLevels[0]["Money"];
		}
		
		public function GetUnlockExp():int
		{
			if (Level > 0)
			{
				return 0;
			}
			
			return LakeLevels[0]["Exp"];
		}
		
		public function GetUpgradeMoney():int
		{
			if ((Level <= 0) || (Level >= MaxLevel))
			{
				return 0;
			}
			
			return LakeLevels[Level]["Money"];
		}
		
		public function GetUpgradeExp():int
		{
			if (Level <= 0)
			{
				return 0;
			}
			
			return LakeLevels[Level]["Exp"];
		}
		
		public function SetUnlock():void
		{
			CleanAmount = 0;
			Level = 1;
			StartTime = GameLogic.getInstance().CurServerTime;
			CurCapacity = LakeLevels[Level - 1]["TotalFish"];
		}
		
		public function SetUpgrade():void
		{
			Level++;
			CurCapacity = LakeLevels[Level - 1]["TotalFish"];
			
			// tru tien user
			
			// cong exp cho user
		}
	}

}