package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class TooltipSquare extends GUIToolTip 
	{
		private const ID_IMG_ITEM:String = "idImgItem";
		private var _itemType:String;
		private var _itemId:int;
		private var _thick:int;
		private var _x:int;
		private var _y:int;
		
		//private var _timeGui:Number;
		private var _timeLock:Number;
		private var _inUpdate:Boolean = false;
		public function TooltipSquare(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "TooltipSquare";
		}
		override public function InitGUI():void 
		{
			LoadRes("GuiHalloween_TooltipSquare");
			SetPos(_x, _y);
			this.img.mouseEnabled = false;
			_timeLock = GameLogic.getInstance().CurServerTime;
			_inUpdate = true;
			if (_itemType != "Chest" || _itemId != 1)
			{
				var imgItem:Image = AddImage(ID_IMG_ITEM, getItemImageName(), 7, -32);
				imgItem.SetScaleXY(0.8);
				var tfNum:TextField = AddLabel("", -23, -26, 0x000000, 1, 0xfffffff);
				var fm:TextFormat = new TextFormat("Arial", 11);
				tfNum.defaultTextFormat = fm;
				tfNum.text = "x" + _thick.toString();
			}
		}
		public function set Thick(value:int):void
		{
			_thick = value;
		}
		public function set ItemId(value:int):void
		{
			_itemId = value;
		}
		public function set ItemType(value:String):void
		{
			_itemType = value;
		}
		
		public function set X(value:int):void 
		{
			_x = value;
		}

		
		public function set Y(value:int):void 
		{
			_y = value;
		}
		
		private function getItemImageName():String
		{
			switch(_itemType)
			{
				case "End":
					return "GuiHalloween_ImgKey";
				case "Chest":
					switch(_itemId)
					{
						case 2:
							return "GuiHalloween_ImgKey";
						default:
							return "";
					}
					break;
				default:
					return "GuiHalloween_" + _itemType + _itemId;
			}
		}
		
		public function updateTooltip(curTime:Number):void
		{
			if (_inUpdate)
			{
				if (curTime - _timeLock > 4)
				{
					_inUpdate = false;
					Hide();
				}
			}
		}
	}

}














