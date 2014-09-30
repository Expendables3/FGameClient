package Event.EventNoel.NoelLogic 
{
	import Data.ConfigJSON;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class FishNoelInfo extends FishAbstractInfo 
	{
		private var _idTeam:int;
		private var _speed:int;
		private var _bonusIndex:int = 0;
		private static var numFishDie:int = 0;
		public function FishNoelInfo(fishType:String, fishId:int) 
		{
			_fishType = fishType;
			_fishId = fishId;
		}
		override public function getImageName():String 
		{
			return _fishType + _fishId + "_1";
		}
		
		override public function updateBlood(dBlood:int):Boolean 
		{
			_blood += dBlood;
			return _blood > 0;
		}
		
		public function get IdTeam():int { return _idTeam; }
		public function set IdTeam(value:int):void { _idTeam = value; }
		public function get BonusIndex():int { return _bonusIndex; }
		
		public function set BonusIndex(value:int):void 
		{
			_bonusIndex = value;
		}
		
		public function isDie():Boolean
		{
			return _blood <= 0;
		}
		
		override public function setInfo(data:Object):void 
		{
			for (var itm:String in data)
			{
				this[itm] = data[itm];
			}
		}
		
		override public function getMaxBlood():int 
		{
			var maxBlood:int = ConfigJSON.getInstance().getItemInfo("Noel_Fish")[_fishType][_fishId]["Blood"];
			return maxBlood;
		}
		
		override public function destructor():void 
		{
			super.destructor();
		}
		
		/**
		 * lấy về tập quà của con cá
		 * @return
		 */
		override public function getListGift():Array 
		{
			var gifts:Array = [];
			var info:AbstractGift;
			var i:String;
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("Noel_Bonus")["Fish"][_fishType][_fishId];//phần thưởng cố định
			for (i in cfg)
			{
				info = AbstractGift.createGift(cfg[i]["ItemType"]);
				info.setInfo(cfg[i]);
				gifts.push(info);
			}
			switch(_fishType)
			{
				case "FishBoss":
				case "FishFast":
					cfg = ConfigJSON.getInstance().getItemInfo("Noel_Bonus")["NoelItem"][_fishType][_fishId];//phần thưởng khi giết con boss
					for (i in cfg)
					{
						info = AbstractGift.createGift(cfg[i]["ItemType"]);
						info.setInfo(cfg[i]);
						gifts.push(info);
					}
					break;
				default:
					if (_bonusIndex > 0)
					{
						cfg = ConfigJSON.getInstance().getItemInfo("Noel_Bonus")["NoelItem"][_fishType][_fishId][_bonusIndex];//phần thưởng khi giết cá thường
						switch(cfg["ItemType"])
						{
							case "Weapon":
								cfg["ItemType"] = "EquipmentChest";
								break;
							//case "Ring":
								//cfg["ItemType"] = "JewelChest";
								//break;
						}
						info = AbstractGift.createGift(cfg["ItemType"]);
						info.setInfo(cfg);
						gifts.push(info);
					}
			}1
			return gifts;
		}
	}

}
































