package GUI.Collection 
{
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemCollection extends Container 
	{
		static public const BTN_BUY:String = "btnBuy";
		public var itemId:int;
		public var itemType:String;
		private var txtNum:TextField;
		private var _num:int;
		private var _numRequire:int;
		
		public var forAnoucement:Boolean = false;
		
		public function ItemCollection(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "", x, y, isLinkAge, imgAlign);
			LoadRes("");
			AddImage("", "Num_Bg", 13 + 48, 100);
			txtNum = AddLabel("3/3", 10, 90, 0xffffff, 1);//, 0x26709C);
			txtNum.defaultTextFormat = new TextFormat("arial", 17);
		}
		
		public function initItemCollection(_itemType:String, _itemId:int, _numRequire:int):void
		{
			itemType = _itemType;
			itemId = _itemId;
			numRequire = _numRequire;
			num = 0;
			
			var item:Image = AddImage("", itemType + itemId, 60, 75, true, ALIGN_LEFT_TOP);			
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("TipItemCollection" + itemId);
			this.setTooltip(tooltip);
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			txtNum.text = value + "/" + numRequire;
			
			if (num >= numRequire)
			{
				//this.enable = true;
				txtNum.textColor = 0x00ff00;
			}
			else
			{
				//this.enable = false;
				txtNum.textColor = 0xff0000;
			}
			
			if (forAnoucement)
			{
				txtNum.text = value.toString();
				this.enable = true;
				txtNum.textColor = 0x00ff00;
			}
		}
		
		public function get numRequire():int 
		{
			return _numRequire;
		}
		
		public function set numRequire(value:int):void 
		{
			_numRequire = value;
			txtNum.text = num + "/" + value;
		}
	}

}