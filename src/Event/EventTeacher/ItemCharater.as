package Event.EventTeacher 
{
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemCharater extends ItemCollectionEvent 
	{
		private var btnBackGround:Button;
		private var imgBackGround:ButtonEx;
		private var tfNum:TextField;
		private var imgGift:ButtonEx;
		public function ItemCharater(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemCharater";
		}
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = 0, heightSlot:int = 0, hasSlot:Boolean = false):void 
		{
			_gift = gift;
		}
		
		override public function drawGift():void 
		{
			/*ảnh quà*/
			btnBackGround = AddButton("", "GuiCollectionTeacher_BtnSlotChar" + _gift.ItemType + _gift.ItemId, 0, 0);
			imgBackGround = AddButtonEx("","GuiCollectionTeacher_ImgSlotChar" + _gift.ItemType +  _gift.ItemId, 0, -5);
			/*số lượng*/
			var xNum:int = getXNum(); //_gift.ItemType == "Combo" ? 240 : -7;
			var yNum:int = getYNum();// _gift.ItemType == "Combo" ? 60 : 70;
			tfNum = AddLabel("", xNum, yNum, 0x000000, 1);
			var fm:TextFormat = new TextFormat("Arial", 14);
			tfNum.defaultTextFormat = fm;
			tfNum.text = "x" + Ultility.StandardNumber(_gift["Num"]);
			tfNum.mouseEnabled = false;
			/*tooltip*/
			this.setTooltipText(_gift.getTooltipText());
		}
		
		private function getXNum():int 
		{
			switch(_gift.ItemType)
			{
				case "Combo":
					return 100;
				default:
					break;
			}
			return 3;
		}
		private function getYNum():int 
		{
			switch(_gift.ItemType)
			{
				case "Combo":
					return 93;
				default:
					break;
			}
			return 75;
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














