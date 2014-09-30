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
	public class ItemIngradientRequire extends Container 
	{
		private var _num:int;
		private var _numRequire:int;
		private var numBg:Image;
		private var numLabel:TextField;
		private var name:String;
		public var itemType:String;
		public var rank:int;
		
		public function ItemIngradientRequire(parent:Object, imgName:String = "Ingradient_Bg", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			numBg = AddImage("", "GuiCreateEquipment_Num_Bg", 31, 74);
		}
		
		public function initIngradient(_itemType:String, _rank:int= 0):void
		{
			itemType = _itemType;
			rank = _rank;
			
			var imageName:String;
			imageName = itemType;
			name = Localization.getInstance().getString(itemType);
			var image:Image = AddImage("", imageName, 0, 0, true, ALIGN_LEFT_TOP);
			image.FitRect(60, 60, new Point( 3, 0));
			if (rank != 0)
			{
				var imageRank:Image = AddImage("", "Number_" + rank, -5, 0, true, ALIGN_LEFT_TOP);
				imageRank.FitRect(20, 20, new Point( 21, 21));
				name += " cấp " + rank;
			}
			
			numLabel = AddLabel("", 11 - 28 - 33, 66, 0xffffff, 1, 0x000000);
			var txtFormat:TextFormat = new TextFormat("arial", 12, 0xffffff, true);
			numLabel.setTextFormat(txtFormat);
			numLabel.defaultTextFormat = txtFormat;
			//numLabel.wordWrap = true;
			numLabel.width = 70;
			
			var tooltip:TooltipFormat = new TooltipFormat();
			var to:String;
			switch(itemType)
			{
				case "Iron":
					to = "Dùng chế tạo vũ khí, áo giáp, mũ";
					break;
				case "Jade":
					to = "Dùng chế tạo trang sức";
					break;
				case "SoulRock":
					to = "Dùng chế tạo trang bị cấp " + rank;
					break;
				case "SixColorTinh":
					to = "Dùng chế tạo trang bị ở Tầng Thần";
					break;
				case "PowerTinh":
					to = "Dùng chế tạo trang bị";
					break;
			}
			tooltip.htmlText = "<font color='#ff0000'>" + name + "</font>\n" + to;
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
			var tooltip:TooltipFormat = new TooltipFormat();
			var from:String;
			switch(itemType)
			{
				case "Iron":
					from = "Có được từ tách vũ khí, áo giáp, mũ";
					break;
				case "Jade":
					from = "Có được từ tách trang sức";
					break;
				case "SoulRock":
					from = "Có được từ tách trang bị cấp " + rank;
					break;
				case "SixColorTinh":
					from = "May mắn có được khi tách đồ";
					break;
				case "PowerTinh":
					from = "Nạp hoặc may mắn có được khi tách trang bị";
					break;
			}
			tooltip.htmlText = "<font color='#ff0000'>" + name + "</font>\n" + from;
			setTooltip(tooltip);
		}		
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			numLabel.text = Ultility.StandardNumber(num);
			if (numRequire != 0)
			{
				numLabel.appendText("/" + Ultility.StandardNumber(numRequire));
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