package Event.Factory.FactoryGui.ItemGui 
{
	import Event.EventNoel.NoelGui.ItemGui.ItemBullet;
	import Event.EventNoel.NoelGui.ItemGui.ItemCandy;
	import Event.EventNoel.NoelGui.ItemGui.ItemHunt;
	import Event.EventNoel.NoelGui.ItemGui.ItemNoel;
	import Event.EventTeacher.ItemCharater;
	import Event.EventTeacher.ItemTeacherEvent;
	import GUI.ItemGift.AbstractItemGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemCollectionEvent extends AbstractItemGift 
	{
		
		public function ItemCollectionEvent(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemCollectionEvent";
		}
		public static function createItemEvent(type:String, 
												parent:Object, 
												imageBgName:String = "KhungFriend", 
												x:int = 0, 
												y:int = 0):ItemCollectionEvent
		{
			switch(type)
			{
				case "Candy":
					return new ItemCandy(parent, imageBgName, x, y);
				case "Bullet":
					return new ItemBullet(parent, imageBgName, x, y);
				case "NoelItem":
					return new ItemNoel(parent, imageBgName, x, y);
				case "ColPItem":
					return new ItemTeacherEvent(parent, imageBgName, x, y);
				case "ColPGGift":
				case "Combo":
					return new ItemCharater(parent, imageBgName, x, y);
			}
			return null;
		}
		
		public virtual function refreshTextNumEvent():Boolean { return false; }
	}

}
















