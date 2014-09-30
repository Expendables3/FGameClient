package GUI.ChampionLeague.GuiLeague.itemGui 
{
	import GUI.component.Container;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemRock extends Container 
	{
		static public const TOPPOS:int = 62;
		// logic
		private var _top:int;
		private var _itemGift:ItemTopGift;
		private var specY:Number;
		public var typeRock:int;
		public function ItemRock(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ItemRock";
		}
		
		public function drawRock():void
		{
			var x:int, y:int = -15;
			switch(typeRock) 
			{
				case 1:
					x = 35;
				break;
				case 2:
					x = 40;
				break;
				case 3:
					x = 40;
					y = -13;
				break;
				case 4:
					x = 35;
					y = -11;
				break;
			}
			_itemGift = new ItemTopGift(this.img, "GuiLeague_CtnGift", x, y);
			_itemGift.EventHandler = this;
			_itemGift.top = _top;
			_itemGift.RockIndex = typeRock;
		}
		/**
		 * thực hiện nhấp nhô đá, như sóng nước
		 */
		public function updateRock():void
		{
			if (CurPos.y <= TOPPOS - 7)
			{
				specY = Math.random() * 0.3 + 0.2;
			}
			else if(CurPos.y >= TOPPOS + 7)
			{
				specY = -(Math.random() * 0.3 + 0.2);
			}
			CurPos.y += specY;
			SetPos(CurPos.x, CurPos.y);
		}
		
		public function get Top():int 
		{
			return _top;
		}
		
		public function set Top(value:int):void 
		{
			_top = value;
			drawRock();
		}
		override public function Destructor():void 
		{
			_itemGift.Destructor();
			super.Destructor();
		}
	}

}
















