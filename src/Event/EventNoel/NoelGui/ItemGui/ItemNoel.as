package Event.EventNoel.NoelGui.ItemGui 
{
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import flash.text.TextField;
	import GUI.component.Image;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemNoel extends ItemCollectionEvent 
	{
		private var tfNum:TextField;
		private var imgGift:Image;
		
		public function ItemNoel(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemNoel";
		}
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = 0, heightSlot:int = 0, hasSlot:Boolean = false):void 
		{
			_gift = gift;
		}
		override public function drawGift():void 
		{
			/*ảnh quà*/
			imgGift = AddImage("", _gift.getImageName(), 40, 40);
			/*số lượng*/
			tfNum = AddLabel("", -7, 70, 0xffffff, 1, 0x000000);
			if (_hasNum)
			{
				tfNum.text = "x" + Ultility.StandardNumber(_gift["Num"]);
				tfNum.mouseEnabled = false;
			}
			this.setTooltipText(_gift.getTooltipText());
		}
		override public function refreshTextNum():void 
		{
			if (_hasNum)
			{
				tfNum.text = "x" + Ultility.StandardNumber(_gift["Num"]);
			}
		}
	}
}




















