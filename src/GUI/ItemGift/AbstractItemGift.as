package GUI.ItemGift 
{
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import GUI.component.Container;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class AbstractItemGift extends Container 
	{
		protected const WSLOT:int = 75;//kích thước mặc định của 1 slot
		protected const HSLOT:int = 78;
		
		protected var _gift:AbstractGift;
		protected var _hasSlot:Boolean;
		protected var _slotName:String;
		protected var wSlot:int;
		protected var hSlot:int;

		protected var _xNum:int = -13;
		protected var _yNum:int = 65;
		protected var _hasNum:Boolean = true;
		protected var _hasTooltipText:Boolean = true;		//có tooltip text hay không
		protected var _hasTooltipImg:Boolean = true;		//có tooltip kiểu content hay không
		protected var _dx:int = 0;
		protected var _dy:int = 0;
		protected var _hasLock:Boolean = true;
		/**************************           setter            *********************************/
		public function set xNum(value:int):void
		{
			_xNum = value;
		}
		public function set yNum(value:int):void
		{
			_yNum = value;
		}
		public function set hasNum(value:Boolean):void 
		{
			_hasNum = value;
		}
		public function set hasLock(value:Boolean):void 
		{
			_hasLock = value;
		}
		
		public function set hasTooltipText(value:Boolean):void 
		{
			_hasTooltipText = value;
		}
		public function set hasTooltipImg(value:Boolean):void 
		{
			_hasTooltipImg = value;
		}
		/****************************      hàm tạo         ***************************/
		public function AbstractItemGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "AbstractItemGift";
		}
		/**
		 * tạo ra itemGift dựa vào Type mà quyết định sẽ tạo ra item gì (Normal hay Special hay ...)
		 * @param	type : loại muốn tạo ra
		 * @param	parent : đối tượng mà chứa đối tượng này (là 1 container cha)
		 * @param	imageBgName : ảnh BG
		 * @param	x : vị trí x với parent
		 * @param	y : vị trí y với parent
		 * @param	hasBgSpecial : có bg slot cho special hay không (biến này áp dụng với itemSpecialGift
		 * @return : trả về đối tượng được tạo ra
		 */
		public static function createItemGift(type:String, parent:Object, imageBgName:String = "KhungFriend", x:int = 0, y:int = 0, hasBgSpecial:Boolean = false):AbstractItemGift
		{
			switch(type)
			{
				case "Weapon":
				case "Armor":
				case "Helmet":
				case "Ring":
				case "Necklace":
				case "Belt":
				case "Bracelet":
				case "Mask":
				case "Seal":
				case "JewelChest":
				case "EquipmentChest":
				case "AllChest":
					var iName:String = imageBgName;
					if (!hasBgSpecial)
					{
						iName = "KhungFriend";
					}
					return new ItemSpecialGift(parent, iName, x, y);
				break;
				case "NoelItem":
					return ItemCollectionEvent.createItemEvent(type, parent, imageBgName, x, y);
				case "QWhite":
				case "QGreen":
				case "QYellow":
				case "QPurple":
				case "QVIP":
					return new ItemQuad(parent, "KhungFriend", x, y);
				default:
					return new ItemNormalGift(parent, imageBgName, x, y);
			}
		}
		
		/********************************     hàm thuần ảo       **************************************/
		public virtual function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = WSLOT, heightSlot:int = HSLOT, hasSlot:Boolean = false):void{}
		public virtual function drawGift():void{}
		public virtual function transform(data:Object = null):void{}
		public virtual function refreshTextNum():void { };
		public virtual function fitRect(x:int, y:int, w:int, h:int):void{};
		public virtual function stretchRect(x:int, y:int, w:int, h:int):void{};
		public virtual function setPosBuff(dx:int, dy:int):void { };
		public virtual function addNum(x:int, y:int, size:int, color:int):void { };
		public virtual function getGiftInfo():AbstractGift { return _gift; };
		public virtual function setHasBackGroundColor(val:Boolean):void { };
		/******************************     hàm chức năng   ******************************************/
	}
}












