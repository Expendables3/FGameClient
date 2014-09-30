package GUI.BossServer 
{
	import com.greensock.motionPaths.RectanglePath2D;
	/**
	 * ...
	 * @author dongtq
	 */
	public class SoldierEquipment
	{
		public var Id:int;
		public var Element:int;
		public var Type:String;
		public var Rank:int;
		public var Color:int;
		public var Damage:Number;
		public var Defence:Number;
		public var Critical:Number;
		public var Health:Number;
		public var Vitality:Number;
		public var EnchantLevel:int;
		public var bonus:Object;
		public var StartTime:Number;
		public var Durability:Number;
		public var Source:int;
		public var IsUsed:Boolean;
		public var Author:Object;
		public var InUse:Boolean;
		public var ItemId:int;
		
		public function SoldierEquipment(_data:Object) 
		{
			setData(_data);
		}
		
		public function setData(_data:Object):void
		{
			for (var s:String in _data)
			{
				try
				{
					this[s] = _data[s];
				}
				catch (e:*)
				{
					trace("thieu tt", s);
				}
			}
		}
		
		public function getImgName():String
		{
			return Type + Rank;
			//return Type + "_" + Element + "_" + Rank;
		}
		
	}

}