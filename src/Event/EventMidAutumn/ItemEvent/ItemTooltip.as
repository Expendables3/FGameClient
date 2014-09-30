package Event.EventMidAutumn.ItemEvent 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.TooltipText.GuiTooltipTextAbstact;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemTooltip extends GuiTooltipTextAbstact 
	{
		private var _fmName:TextFormat;
		private var _fmUsage:TextFormat;
		private var _fmSource:TextFormat;

		private var tfName:TextField;
		private var tfUsage:TextField;
		private var tfSource:TextField;
		private var pos:Point;
		
		private const posPaperBurn:Point = new Point(500, 340);
		private const posGasCan:Point = new Point(490, 398);
		private const posSpaceCraft:Point = new Point(470, 360);
		private const posPropeller:Point = new Point(490, 170);
		
		private var ySource:int;
		public function ItemTooltip(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemTooltip";
			_themeName = "EventMidAutumn_TooltipTheme";
			_lineName = "EventMidAutumn_TooltipLineChar";
			_fmName = new TextFormat("Arial", 14, 0xFFFF00);
			_fmUsage = new TextFormat("Arial", 12, 0xFFFFFF);
			_fmSource = new TextFormat("Arial", 12, 0x00FF00, false, true);
		}
		
		override protected function onInitGui():void 
		{
			SetPos(pos.x, pos.y);
		}
		
		override protected function drawName():void 
		{
			//vẽ tên
			var x:int = img.width / 2 - 43;
			var y:int = 6;
			tfName = AddLabel(_tooltip.Name, x, y, 0x000000);
			tfName.setTextFormat(_fmName);
			//vẽ đường kẻ
			AddImage("", "EventMidAutumn_LineTip", 66, 30, true, ALIGN_LEFT_TOP);
		}
		
		override protected function drawUsage():void 
		{
			tfUsage = AddLabel(_tooltip.Usage, 5, 35, 0x000000, 0);
			tfUsage.setTextFormat(_fmUsage);
			ySource = tfUsage.y + tfUsage.height + 10;
		}
		
		
		override protected function drawSource():void 
		{
			tfSource = AddLabel(_tooltip.Source, 5, ySource, 0x000000, 0);
			tfSource.setTextFormat(_fmSource);
		}
		
		public function setType(type:String, id:int):void
		{
			_tooltip = new TooltipTextEvent();
			if (type != "SpaceCraft")
			{
				_themeName = "EventMidAutumn_TooltipPaperBurn";
			}
			pos = this["pos" + type];
			_tooltip.Name = Localization.getInstance().getString("EventMidAutumn_Name" + type + id);
			_tooltip.Usage = Localization.getInstance().getString("EventMidAutumn_Usage" + type + id);
			if (type != "Propeller")
			{
				var repl:int = ConfigJSON.getInstance().getItemInfo("MidMoon_MoveItem")[type][id]["MoveStep"];
				_tooltip.Usage = _tooltip.Usage.replace("@Distance@", repl);
			}
			_tooltip.Source = Localization.getInstance().getString("EventMidAutumn_Source" + type + id);
			
		}
	}

	
}






















