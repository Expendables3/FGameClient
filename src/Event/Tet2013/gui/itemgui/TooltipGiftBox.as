package Event.Tet2013.gui.itemgui 
{
	import Data.ConfigJSON;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class TooltipGiftBox extends BaseGUI 
	{
		private var _idGift:int;
		private var _listGift:Array;
		public function set IdGift(val:int):void { _idGift = val; }
		public function TooltipGiftBox(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "TooltipGiftBox";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				var tfTip:TextField = AddLabel("", 43, 8, 0x003300, 0);
				var fm:TextFormat = new TextFormat("Arial", 14);
				tfTip.defaultTextFormat = fm;
				tfTip.text = "Phần thưởng nhận được";
				_listGift = [];
				var data:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift")["PointGift"][_idGift];
				var itGift:AbstractItemGift;
				var gift:AbstractGift;
				var info:Object;
				var x:int = 12;
				for (var i:String in data)
				{
					info = data[i];
					gift = AbstractGift.createGift(info["ItemType"]);
					gift.setInfo(info);
					itGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "TooltipGiftBox_ImgSlot", x, 33, true);
					itGift.setPosBuff(0, -10);
					itGift.initData(gift);
					
					itGift.drawGift();
					itGift.addNum(10, 43, 13, 0xffff00);
					_listGift.push(itGift);
					x += 74;
				}
			}
			LoadRes("TooltipGiftBox_Theme");
		}
		override public function ClearComponent():void 
		{
			if (_listGift)
			{
				for (var i:int = 0; i < _listGift.length; i++)
				{
					var itGift:AbstractItemGift = _listGift[i];
					itGift.Destructor();
				}
				_listGift.splice(0, _listGift.length);
			}
			super.ClearComponent();
		}
	}

}






























