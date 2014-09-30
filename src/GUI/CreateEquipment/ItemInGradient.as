package GUI.CreateEquipment 
{
	import Data.Localization;
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
	public class ItemInGradient extends Container 
	{
		public var itemType:String;
		public var rank:int;
		private var _num:int;
		private var _numRequire:int;
		private var numLabel:TextField;
		
		public function ItemInGradient(parent:Object, imgName:String = "Ingradient_Bg", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function initIngradient(labelValue:String, _itemType:String, _rank:int= 0, fontSize:int = 12):void
		{
			itemType = _itemType;
			rank = _rank;
			num = int(labelValue);
			var imageName:String;
			var name:String;
			imageName = itemType;
			name = Localization.getInstance().getString(itemType);
			var image:Image = AddImage("", imageName, 0, 0, true, ALIGN_LEFT_TOP);
			image.FitRect(70, 70, new Point( -5, 0));
			if (rank != 0)
			{
				var imageRank:Image = AddImage("", "Number_" + rank, -5, 0, true, ALIGN_LEFT_TOP);
				imageRank.FitRect(20, 20, new Point( 21, 22));
				name += " cấp " + rank;
			}
			if (labelValue == null)
			{
				labelValue = "0";
			}
			numLabel = AddLabel(labelValue, 5, 2, 0xffffff, 2, 0x000000);
			var txtFormat:TextFormat = new TextFormat("arial", fontSize, 0xffffff, true);
			numLabel.setTextFormat(txtFormat);
			numLabel.defaultTextFormat = txtFormat;
			numLabel.wordWrap = true;
			numLabel.width = 50;
			
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = name;
			setTooltip(tooltip);
		}
		
		public function get numRequire():int 
		{
			return _numRequire;
		}
		
		public function set numRequire(value:int):void 
		{
			_numRequire = value;
			numLabel.text = Ultility.StandardNumber(num) + "/" + Ultility.StandardNumber(numRequire);
			if (num < numRequire)
			{
				numLabel.textColor = 0xff0000;
			}
			else
			{
				numLabel.textColor = 0xffffff;
			}
		}		
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			if (numRequire != 0)
			{
				numLabel.text = Ultility.StandardNumber(num) + "/" + Ultility.StandardNumber(numRequire);
				if (num < numRequire)
				{
					numLabel.textColor = 0xff0000;
				}
				else
				{
					numLabel.textColor = 0xffffff;
				}
			}
		}
	}

}