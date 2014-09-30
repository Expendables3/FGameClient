package GUI.MateFish 
{
	import Data.ConfigJSON;
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
	public class ItemMaterial extends Container 
	{
		public var id:int;
		private var _num:int;
		private var textFieldNum:TextField;
		public var materialImage:Image;
		
		public function ItemMaterial(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemMaterial";
		}
		
		public function initItemMaterial(_id:int, _num:int):void
		{
			LoadRes("GuiMateFish_Material_Bg");
			materialImage = AddImage("", Ultility.GetNameMatFromType(_id), 27, 0, true, ALIGN_LEFT_TOP);
			textFieldNum = AddLabel(_num.toString(), -50, 10, 0xffffff, 2, 0x26709C);
			
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Material", _id);
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = obj["Name"];
			var txtFormatMat:TextFormat = new TextFormat();
			txtFormatMat.bold = true;			
			txtFormatMat.color = 0xF37621;
			tooltip.setTextFormat(txtFormatMat);
			setTooltip(tooltip);
			img.buttonMode = true;
			this.FitRect(60, 60, new Point(0, 0));
			id = _id;
			num = _num;
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			textFieldNum.text = value.toString();
		}
		
	}

}