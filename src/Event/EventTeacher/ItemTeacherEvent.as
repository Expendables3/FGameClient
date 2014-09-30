package Event.EventTeacher
{
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemTeacherEvent extends ItemCollectionEvent
	{
		private var imgGift:ButtonEx;
		private var imgNumBg:Image;
		private var tfNum:TextField;
		public var maxNum:int;
		
		public function ItemTeacherEvent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemTeacherEvent";
		}
		
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = 0, heightSlot:int = 0, hasSlot:Boolean = false):void
		{
			_gift = gift;
		}
		
		override public function drawGift():void
		{
			var gift:ItemTeacherInfo = _gift as ItemTeacherInfo;
			var xGift:int = getXGift();
			var yGift:int = getYGift();
			imgGift = AddButtonEx("", _gift.getImageName(), xGift, yGift); //vẽ ảnh hoa
			
			imgGift.img.buttonMode = false;
			tfNum = AddLabel("", -4, 84, 0xffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 14);
			if (gift.Num < maxNum)
			{
				fm.color = 0xff0000;
			}
			else
			{
				fm.color = 0xffffff;
			}
			tfNum.defaultTextFormat = fm;
			tfNum.text = Ultility.StandardNumber(gift.Num) + " / " + Ultility.StandardNumber(maxNum);
			
			/*tooltip*/
			imgGift.setTooltipText(gift.getTooltipText());
		}
		
		private function getXGift():int 
		{
			switch(_gift.ItemId)
			{
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
				case 5:
					return 30;
			}
			return 20;
		}
		private function getYGift():int 
		{
			switch(_gift.ItemId)
			{
				case 1:
					break;
				case 2:
					return 36;
				case 3:
					break;
				case 4:
					return 27;
				case 5:
					break;
			}
			return 17;
		}
		
		override public function refreshTextNumEvent():Boolean 
		{
			var fm:TextFormat = new TextFormat("Arial", 14);
			var isEnable:Boolean = false;
			if (_gift["Num"] < maxNum)
			{
				fm.color = 0xff0000;
			}
			else
			{
				isEnable = true;
				fm.color = 0xffffff;
			}
			tfNum.defaultTextFormat = fm;
			tfNum.text = Ultility.StandardNumber(_gift["Num"]) + " / " + Ultility.StandardNumber(maxNum);
			return isEnable;
		}
	}
}














