package Event.EventMidAutumn.ItemEvent 
{
	import Logic.BaseObject;
	
	/**
	 * Siêu nhân bay qua
	 * @author HiepNM2
	 */
	public class ItemSuperFarm extends BaseObject 
	{
		
		public function ItemSuperFarm(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "";
		}
		
	}

}