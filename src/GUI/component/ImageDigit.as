package GUI.component 
{
	import Data.ResMgr;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Logic.Ultility;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ImageDigit extends Image 
	{
		private var _number:int;
		private var _family:String;
		private var _parentGui:String;
		private var tooltip:TooltipFormat = null;
		public function ImageDigit(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "ImageDigit";
		}
		public function set number(value:int):void 
		{
			_number = value;
		}
		public function set family(value:String):void 
		{
			_family = value;
		}
		public function set parentGui(value:String):void 
		{
			_parentGui = value;
		}
		
		public function changeNumberToImage():void
		{
			var szNumber:String = Ultility.StandardNumber(_number);// _number.toString();
			var i:int;
			var c:String;
			var res:Sprite;
			var name:String = "";
			var x:int = 0, y:int = 0;
			for (i = 0; i < szNumber.length; i++)
			{
				name =  _parentGui + "_" + _family;
				c = szNumber.substr(i, 1);
				if (c == ",")
				{
					c = "Comma";
					y = 13;
				}
				else
				{
					c = "No" + c;
					y = 0;
				}
				name += c;
				res = ResMgr.getInstance().GetRes(name) as Sprite;
				img.addChild(res);
				res.x = x;
				res.y = y;
				x += distance(c);
			}
			addAllEvent();
		}
		
		private function distance(c:String):Number 
		{
			var fam:String = _family.toUpperCase();
			var name:String = fam + "_" + c.toUpperCase();
			var df:DefineFont = DefineFont.getInstance();
			return df.getWidth(name) + df.getDistance(name);
		}
		
		override public function Destructor():void 
		{
			for (var i:int = 0; i < img.numChildren; i++)
			{
				var r:DisplayObject = img.getChildAt(i);
				img.removeChild(r);
				r = null;
			}
			img.parent.removeChild(img);
			//Parent.removeChild(img);
			removeAllEvent();
			super.Destructor();
			
		}
		
		public function setTooltip(tip:TooltipFormat):void
		{
			tooltip = tip;
		}
		
		private function addAllEvent():void
		{
			img.addEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.addEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
		}
		
		public function removeAllEvent():void
		{
			img.removeEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.removeEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
		}
		
		private function OnButtonMouseOver(e:Event):void 
		{
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().showNewToolTip(tooltip, img);
			}
		}
		private function OnButtonMouseOut(e:Event):void 
		{
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().clearToolTip();
			}
		}
		
	}

}


















