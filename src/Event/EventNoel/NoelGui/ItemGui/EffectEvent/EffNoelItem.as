package Event.EventNoel.NoelGui.ItemGui.EffectEvent 
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import Logic.LogicGift.AbstractGift;
	import Logic.MotionObject;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class EffNoelItem extends MotionObject 
	{
		private var _gift:AbstractGift;
		private var _tfNum:TextField;
		public function EffNoelItem(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, Num:int=0,data:Object=null) 
		{
			_gift = data as AbstractGift;
			super(parent, imgName, x, y, isLinkAge, imgAlign, Num);
			ClassName = "EffNoelItem";
		}
		override public function OnLoadResComplete():void 
		{
			if (_tfNum == null)
			{
				var fm:TextFormat = new TextFormat("Arial", 12, 0xffffff, true);
				_tfNum = new TextField();
				_tfNum.autoSize = TextFieldAutoSize.LEFT;
				_tfNum.defaultTextFormat = fm;
				_tfNum.text = Ultility.StandardNumber(_gift["Num"]);
				var outline:GlowFilter = new GlowFilter();
				outline.blurX = outline.blurY = 3.5;
				outline.strength = 8;
				outline.color = 0x000000;
				var arr:Array = [];
				arr.push(outline);
				_tfNum.antiAliasType = AntiAliasType.ADVANCED;
				_tfNum.filters = arr;
				img.addChild(_tfNum);
				if (_gift.ItemType != "Material")
				{
					_tfNum.x = (img.width - _tfNum.width) / 2;
					_tfNum.y = img.height;
				}
				else
				{
					_tfNum.x = (0 - _tfNum.width) / 2;
					_tfNum.y = img.height / 2;
				}
				
				
			}
		}
		override public function removeSelf():void 
		{
			img.removeChild(_tfNum);
			_tfNum = null;
			super.removeSelf();
		}
	}

}




















