package Event.EventNoel.NoelGui.ItemGui 
{
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import flash.text.TextField;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemHunt extends ItemCollectionEvent 
	{
		private var btnBackGround:Button;
		private var imgBackGround:ButtonEx;
		private var tfNum:TextField;
		private var imgGift:ButtonEx;
		public function ItemHunt(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemHunt";
		}
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = 0, heightSlot:int = 0, hasSlot:Boolean = false):void 
		{
			_gift = gift;
		}
		
		override public function drawGift():void 
		{
			/*ảnh quà*/
			btnBackGround = AddButton("", "GuiExchangeNoelGift_Btn" + _gift.ItemType + _gift.ItemId, 0, 0);
			imgBackGround = AddButtonEx("","GuiExchangeNoelGift_Img" + _gift.ItemType +  _gift.ItemId, 0, -5);
			/*số lượng*/
			tfNum = AddLabel("", -7, 70, 0xffffff, 1, 0x000000);
			tfNum.text = "x" + Ultility.StandardNumber(_gift["Num"]);
			tfNum.mouseEnabled = false;
			/*tooltip*/
			this.setTooltipText(_gift.getTooltipText());
		}
		override public function refreshTextNum():void 
		{
			tfNum.text = "x" + Ultility.StandardNumber(_gift["Num"]);
		}
		
		public function setButtonMode(isButton:Boolean = true):void
		{
			btnBackGround.img.visible = isButton;
			imgBackGround.img.visible = !isButton;
		}
	}

}