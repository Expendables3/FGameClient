package GUI.MateFish 
{
	import Data.ConfigJSON;
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.component.Container;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemFormula extends Container 
	{
		private var txtNum:TextField;
		public var itemType:String;
		public var itemId:int;
		private var _num:int;
		
		public var fishA:Object;
		public var fishB:Object;
		public var config:Object;
		
		public var imageFormula:Image;
		
		public var canUse:Boolean = false;
		
		public function ItemFormula(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemFormula";
		}
		
		public function initFormula(_itemType:String, _itemId:int, _num:int):void
		{
			if (imageFormula != null)
			{
				RemoveImage(imageFormula);
			}
			LoadRes("");
			itemType = _itemType;
			itemId = _itemId;
			imageFormula = AddImage("", itemType + "_" + itemId, 0, 0);
			if (itemType == null)
			{
				trace(itemType + "_" + itemId);
			}
			imageFormula.FitRect(50, 50, new Point(0, -20));
			txtNum = AddLabel("", -50, 8, 0xffffff, 2, 0x000000);
			num = _num;
			
			var config:Object = ConfigJSON.getInstance().getItemInfo(itemType, itemId);
			fishA = config["Fish_1"];
			fishB = config["Fish_2"];
			this.config = config;
			
			img.buttonMode = true;
			//this.FitRect(60, 60, new Point(0, 0));
		}
		
		public static function checkFormula(fish1:Object, fish2:Object, fishA:Object, fishB:Object):Boolean
		{
			if ((fishA["FishType"] == fish1["FishType"] && fishA["FishTypeId"] == fish1["FishTypeId"] && fishB["FishType"] == fish2["FishType"] && fishB["FishTypeId"] == fish2["FishTypeId"])
				|| (fishA["FishType"] == fish2["FishType"] && fishA["FishTypeId"] == fish2["FishTypeId"] && fishB["FishType"] == fish1["FishType"] && fishB["FishTypeId"] == fish1["FishTypeId"]))
			{
				return true;
			}
			return false;
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			if(value != 0)
			{
				txtNum.text = value.toString();
			}
			else
			{
				txtNum.text = "";
			}
		}
	}

}