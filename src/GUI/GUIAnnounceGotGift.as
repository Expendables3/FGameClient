package GUI 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	import Logic.Ultility;
	
	/**
	 * Show phan thuong len
	 * @author longpt
	 */
	public class GUIAnnounceGotGift extends BaseGUI 
	{
		public static const BTN_GET_GIFT:String = "BtnGetGift";
		static public const BTN_CLOSE:String = "btnClose";
		private var imageGift:Image;
		private var textField:TextField;
		private var itemType:String;
		private var itemId:int;
		private var itemNum:int;
		private var message:String;
		
		private var imageName:String;
		private var feedFunction:Function;
		private var equip:Object;
		
		private var isEquip:Boolean = false;
		
		public function GUIAnnounceGotGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiAnnounceGotGift";
		}
		
		public override function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 500 - 155, 44);
				textField = AddLabel("Bạn nhận được", 145, 100, 0x0c6298);
				var format:TextFormat = new TextFormat("Arial", 20, 0x0c6298, true);
				textField.defaultTextFormat = format;
				if (message != "")
				{
					textField.text = message;
				}
				SetPos(220, 100);
				
				if (isEquip)
				{
					if (equip.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
					{
						AddImage("", FishEquipment.GetBackgroundName(equip.Color), 162, 135, true, ALIGN_LEFT_TOP);
					}
				}
				
				imageGift = AddImage("", imageName, 0, 0);
				imageGift.FitRect(60, 60, new Point(165, 140));
				
				if (itemNum > 0)
				{
					var label:TextField = AddLabel("x" + Ultility.StandardNumber(itemNum), 165, 140, 0, 0, 0x26709c);
					var txtFormat:TextFormat = new TextFormat("Arial", 15, 0xffffff, true);
					label.setTextFormat(txtFormat);
					AddButton(BTN_GET_GIFT, "BtnNhanThuong", 130, 245);
				}
				else
				{
					AddButton(BTN_GET_GIFT, "BtnFeed", 150, 245);
				}
			}
			LoadRes("GuiCongratulation_Theme");
		}
		
		public function showGUI(itemType:String, itemId:int, itemNum:int, message:String = ""):void
		{
			this.itemType = itemType;
			this.itemId = itemId;
			this.itemNum = itemNum;
			this.message = message;
			
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			Hide();
		}
		
		public function showEquipment(gift:Object, _num:int, _message:String, _feedFunction:Function = null):void
		{
			isEquip = true;
			message = _message;
			equip = gift;
			itemNum = _num;
			feedFunction = _feedFunction;
			imageName = gift.Type + gift.Rank + "_Shop";
			Show(Constant.GUI_MIN_LAYER, 3);
		}
	}

}