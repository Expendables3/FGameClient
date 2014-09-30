package GUI.EventNationalCelebration 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemGift extends Container 
	{
		private var imageObject:Image;
		private var numTextField:TextField;
		private var xNumTextField:TextField;
		private var _num:int;
		private var _xNum:int;
		public var itemType:String;
		public var itemId:int;
		public var id:int;//loai qua
		
		public function ItemGift(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "ImgBgGiftNormal", x, y, isLinkAge, imgAlign);
		}
		
		public function initItem(_itemType:String, _itemId:int, _xNum:int, _num:int):void
		{
			var p:Point = getPos(_itemType, _itemId);
			imageObject = AddImage("", getImgName(_itemType, _itemId), p.x, p.y);
			imageObject.FitRect(63, 63, new Point(0, 0));
			if (_itemType == "Firework")
			{
				imageObject.SetScaleXY(0.6);
			}
			xNumTextField = AddLabel("", 0, 0, 0xFFF100, 0, 0x603813);
			numTextField = AddLabel("", -42, 38, 0xffffff, 2, 0x603813);
			numTextField.defaultTextFormat = (new TextFormat("arial", 17));
			itemType = _itemType;
			itemId = _itemId;
			num = _num;
			xNum = _xNum;
		}
		
		public static function getImgName(itemType:String, itemId:int):String
		{
			switch(itemType)
			{
				case "Exp":
					return "ImgEXP";
				case "Money":
					return "IcGold";
				case "Material":
					return Ultility.GetNameMatFromType(itemId);
				case "BabyFish":
					return "Fish" + itemId + "_Old_Idle";
				case "Spiderman":
				case "Batman":
				case "Sparta":
				case "Swat":
				case "Ironman":
				case "Santa":
					return itemType;
				default:
					return itemType + itemId;
			}
			return "";
		}
		
		public static function getPos(itemType:String, itemId:int):Point
		{
			switch(itemType)
			{
				case "Firework":
					return new Point(85, 85);
					break;
				case "Exp":
					return new Point(30, 27);
					break;
				case "Money":
					return new Point(30, 27);
					break;
				case "EnergyItem":
					return new Point(31, 27);
					break;
				case "Material":
					return new Point(50, 42);
					break;
				case "BabyFish":
					return new Point(60, 45);
					break;
			}
			return new Point(40, 45);
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		private function getName():String
		{
			switch(itemType)
			{
				case "Santa":
					return "Ông Cá Noel";
				case "Exp":
					return "Kinh nghiệm";
				case "Money":
					return "Tiền vàng";
				case "EnergyItem":
					if(itemId == 5)
					{
						return "Bình năng lượng đầy";
					}
					return "Bình năng lượng";
				case "Material":
					if(itemId == 6)
					{
						return "Ngư thạch cấp 6";
					}
					else if (itemId == 7)
					{
						return "Ngư thạch cấp 7";
					}
					return "Ngư thạch";
				case "RebornMedicine":
					if(itemId == 3)
					{
						return "Thuốc hồi sinh 7 ngày";
					}
					return "Thuốc hồi sinh";
			}
			return "itemName";
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			numTextField.text = Ultility.StandardNumber(value);
			if (_num <= 0)
			{
				this.enable = false;
			}
			else
			{
				this.enable = true;
			}
			var tooltipFormat:TooltipFormat = new TooltipFormat();
			tooltipFormat.htmlText = getName() + "\n <font color = '#ff0000'>(còn " + value + " giải trong ngày). </font>";
			this.setTooltip(tooltipFormat);
		}
		
		public function get xNum():int 
		{
			return _xNum;
		}
		
		public function set xNum(value:int):void 
		{
			_xNum = value;
			xNumTextField.text = "x"+ Ultility.StandardNumber(value);
		}
		
	}

}