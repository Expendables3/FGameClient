package Event.Factory.FactoryLogic.ItemInfo 
{
	import Event.EventNoel.NoelLogic.FishNoelInfo;
	/**
	 * info con cá trong event
	 * @author HiepNM2
	 */
	public class FishAbstractInfo 
	{
		protected var _fishType:String;
		protected var _fishId:int;
		protected var _id:int;						//id của con cá
		protected var _blood:int;
		protected var _typeTeam:int;				//đang ở đội hình nào
		public function FishAbstractInfo() 
		{
			
		}
		
		public static function createFishInfo(fishType:String, fishId:int):FishAbstractInfo
		{
			switch(fishType)
			{
				case "FishCommon"://tạo cá thường
					switch(fishId)
					{
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
							return new FishNoelInfo(fishType, fishId);
					}
					break;
				case "FishFast"://tạo cá bơi nhanh
					switch(fishId)
					{
						case 1:
						case 2:
						case 3:
						case 4:
							return new FishNoelInfo(fishType, fishId);
					}
					break;
				case "FishBoss"://tạo boss
					switch(fishId)
					{
						case 1:
						case 2:
						case 3:
						case 4:
							return new FishNoelInfo(fishType, fishId);
					}
					break;
			}
			return new FishAbstractInfo();
		}
		
		public function set FishId(value:int):void { _fishId = value; }
		public function get FishId():int { return _fishId; }
		public function set FishType(value:String):void { _fishType = value; }
		public function get FishType():String { return _fishType; }
		public function get Id():int { return _id; }
		public function set Id(value:int):void { _id = value; }
		public function get TypeTeam():int { return _typeTeam; }
		public function set TypeTeam(value:int):void { _typeTeam = value; }
		public function get Blood():int { return _blood; }
		public function set Blood(val:int):void { _blood = val; }
		
		public virtual function setInfo(data:Object):void { };
		public virtual function getImageName():String { return""; };
		public virtual function updateBlood(dBlood:int):Boolean { return true; }
		public virtual function getMaxBlood():int { return 0; }
		public virtual function getListGift():Array { return []; }
		
		public virtual function destructor():void
		{
			
		}
		
		
	}

}