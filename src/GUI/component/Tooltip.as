package GUI.component 
{
	import flash.display.ActionScriptVersion;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import Logic.*;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * quản lý tooltip (dòng chữ xuất hiện khi đưa chuột qua 1 đối tượng)
	 * @author ducnh
	 */
	public class Tooltip
	{
		private static var instance:Tooltip;	
		
		private var ArrowOffsetX:int = 12;
		private var ArrowOffsetY:int = 12; 
		private var CurveOffset:int = 6;
		public var MaxTipWidth:int = 250;
		
		private var img:Sprite = null;
		private var TooltipText:TextField;
		private var ScreenWidth:int;
		private var ScreenHeight:int;
		private var TimeOut:Timer = null;
		
		public static function getInstance():Tooltip
		{
			if(instance == null)
			{
				instance = new Tooltip();
			}
				
			return instance;
		}
		
		public function Tooltip() 
		{
			//this.ClassName = "Container";	
		}
		
		/**
		 * ẩn tooltip
		 */
		public function ClearTooltip():void
		{
			if (img == null)
			{
				return;
			}
			if (TimeOut != null)
			{
				TimeOut.removeEventListener(TimerEvent.TIMER, ProcessTimeOut);
			}
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer-1);
			if ( layer != null)
			{
				layer.removeChild(img);
				img = null;
			}
		}
		
		/**
		 * hiện tooltip ra
		 * @param tip chữ hiện ra
		 * @param px vị trí x xuât hiện tooltip (tọa độ tuyệt đối)
		 * @param px vị trí y xuât hiện tooltip (tọa độ tuyệt đối)
		 */
		public function ShowNewToolTip(tip:String, px:int, py:int, alpha:Number = 1.0):void
		{
			
			var x:int = px - 2;
			var y:int = py - 2;
			
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer-1);
			if ( layer != null)
			{
				if (img != null)
				{
					layer.removeChild(img);
					img = null;
				}
				img = new Sprite();
				//try {
					layer.addChild(img);
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}
				// find tooltip pos
				ScreenWidth = layer.stage.stageWidth;
				ScreenHeight = layer.stage.stageHeight;
				if (x < 50) 
				{
					x = 50;
				}
				if (x > ScreenWidth - 50)
				{
					x = ScreenWidth - 50;
				}
				
				var width:int = GetTipWidth(tip);
				var height:int = GetTipHeight(tip);
				var rndLength:int = width / 3;// GameLogic.getInstance().randomNumber(width / 4, 3 * width / 4);
				var DrawTooltipPt:Point = FindToolTipPos(rndLength, x, y, width, height);
				img.x = DrawTooltipPt.x;
				img.y = DrawTooltipPt.y;

				// ve hinh da giac bao
				DrawPolygon(x - DrawTooltipPt.x, y - DrawTooltipPt.y, width, height, alpha);
				
				// create text
				var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0047A6, true);
				txtFormat.align = "center";
				TooltipText = new TextField();
				TooltipText.text = tip;
				TooltipText.setTextFormat(txtFormat);
				//TooltipText.width = MaxTipWidth;
				TooltipText.width = width;
				TooltipText.wordWrap = true;
				TooltipText.autoSize = TextFieldAutoSize.CENTER;
				//TooltipText.x = ArrowOffsetX + 8;
				TooltipText.y = ArrowOffsetY + 8;
				TooltipText.mouseEnabled = false;
				//try {
					img.addChild(TooltipText);
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}
				img.mouseChildren = false;				
				img.mouseEnabled = false;
			}
			else
			{
				//trace("BaseObject::LoadRes error add layer");
			}
		}
		
				
		private function GetTipWidth(text:String):int
		{
			var txtFormat:TextFormat = new TextFormat("Arial", 12, null, true);
			txtFormat.align = "center";
			var Txt:TextField = new TextField();
			Txt.text = text;
			Txt.setTextFormat(txtFormat);
			Txt.autoSize = TextFieldAutoSize.CENTER;
			Txt.width = MaxTipWidth;
			Txt.wordWrap = true;
			
			return Txt.textWidth + 2*ArrowOffsetX + 20;
		}
		
		private function GetTipHeight(text:String):int
		{
			var txtFormat:TextFormat = new TextFormat("Arial", 12, null, true);
			txtFormat.align = "center";
			var Txt:TextField = new TextField();
			Txt.text = text;
			Txt.setTextFormat(txtFormat);
			Txt.autoSize = TextFieldAutoSize.CENTER;
			Txt.width = MaxTipWidth;
			Txt.wordWrap = true;
			
			return Txt.textHeight + 2*ArrowOffsetY + 20;
		}
		
		private function DrawPolygon(x:int, y:int, width:int, height:int, alpha:Number):void
		{
			img.graphics.lineStyle(1, 0x0085FF);
			//img.graphics.beginFill(0xF1F9AC);
			img.graphics.beginFill(0xffffff, alpha);
			
			if (y > height / 2)
			{
				img.graphics.moveTo(x, y);
				img.graphics.lineTo(x - ArrowOffsetX, y - ArrowOffsetY);
				
				img.graphics.lineTo(ArrowOffsetX + CurveOffset, height - ArrowOffsetY);
				img.graphics.curveTo(ArrowOffsetX, height - ArrowOffsetY, ArrowOffsetX, height - ArrowOffsetY - CurveOffset);
	
				img.graphics.lineTo(ArrowOffsetX, CurveOffset + ArrowOffsetY);
				img.graphics.curveTo(ArrowOffsetX, ArrowOffsetY, CurveOffset + ArrowOffsetX, ArrowOffsetY);
				
				img.graphics.lineTo(width - ArrowOffsetX - CurveOffset, ArrowOffsetY);
				img.graphics.curveTo(width - ArrowOffsetX, ArrowOffsetY, width - ArrowOffsetX, ArrowOffsetY + CurveOffset);
				
				img.graphics.lineTo(width - ArrowOffsetX, height - ArrowOffsetY - CurveOffset);
				img.graphics.curveTo(width - ArrowOffsetX, height - ArrowOffsetY, width - ArrowOffsetX - CurveOffset, height - ArrowOffsetY);
				
				img.graphics.lineTo(x + ArrowOffsetX, y - ArrowOffsetY);
				img.graphics.lineTo(x, y);
			}
			else
			{		
				img.graphics.moveTo(x, y);
				img.graphics.lineTo(x + ArrowOffsetX, y + ArrowOffsetY);
				img.graphics.lineTo(width - ArrowOffsetX, ArrowOffsetY);
				img.graphics.lineTo(width - ArrowOffsetX, height - ArrowOffsetY);
				img.graphics.lineTo(ArrowOffsetX, height - ArrowOffsetY);
				img.graphics.lineTo(ArrowOffsetX, ArrowOffsetY);
				img.graphics.lineTo(x - ArrowOffsetX, y + ArrowOffsetY);
				img.graphics.lineTo(x, y);
			}
			/*
			
			if (y > height / 2)
			{
				img.graphics.moveTo(x, y);
				img.graphics.lineTo(x - ArrowOffsetX, y - ArrowOffsetY);
				img.graphics.lineTo(ArrowOffsetX, height - ArrowOffsetY);
				img.graphics.lineTo(ArrowOffsetX, ArrowOffsetY);
				img.graphics.lineTo(width - ArrowOffsetX, ArrowOffsetY);
				img.graphics.lineTo(width - ArrowOffsetX, height - ArrowOffsetY);
				img.graphics.lineTo(x + ArrowOffsetX, y - ArrowOffsetY);
				img.graphics.lineTo(x, y);
			}
			else
			{		
				img.graphics.moveTo(x, y);
				img.graphics.lineTo(x + ArrowOffsetX, y + ArrowOffsetY);
				img.graphics.lineTo(width - ArrowOffsetX, ArrowOffsetY);
				img.graphics.lineTo(width - ArrowOffsetX, height - ArrowOffsetY);
				img.graphics.lineTo(ArrowOffsetX, height - ArrowOffsetY);
				img.graphics.lineTo(ArrowOffsetX, ArrowOffsetY);
				img.graphics.lineTo(x - ArrowOffsetX, y + ArrowOffsetY);
				img.graphics.lineTo(x, y);
			}*/
			img.graphics.endFill();
		}
		
		private function FindArrowPos(x:int, y:int, width:int, height:int):Point
		{
			var kq:Point = new Point;
			kq.x = width - 50;
			kq.y = height;
			return kq;
		}
		
		private function FindToolTipPos(ArrowOffset:int, x:int, y:int, width:int, height:int):Point
		{
			var kq:Point = new Point;
			var MinX:int, MaxX:int;
			var MinY:int, MaxY:int;
			// check vuot ra ngoai man hinh voi X
			
			MinX = x - ArrowOffset;
			MaxX = MinX + width;
			
			if (MinX < 10)
			{
				MinX = 10;
				MaxX = MinX + width;
			}
			if (MaxX > ScreenWidth - 10)
			{
				MaxX = ScreenWidth - 10;
				MinX = MaxX - width;
			}
			// check vuot ra ngoai man hinh voi Y
			MinY = y - height;
			MaxY = y;
			
			if (MinY < 10)
			{
				MinY = y;
				MaxY = MinY + height;
			}
			
			return new Point(MinX, MinY);
		}
		
		public function SetTimeOut(time:Number):void
		{
			TimeOut = new Timer(time, 1);
			TimeOut.addEventListener(TimerEvent.TIMER, ProcessTimeOut);
			TimeOut.start();
		}
		
		private function ProcessTimeOut(e:TimerEvent):void
		{
			ClearTooltip();
			if (TimeOut != null)
			{
				TimeOut.removeEventListener(TimerEvent.TIMER, ProcessTimeOut);
			}
		}
		
	}

}