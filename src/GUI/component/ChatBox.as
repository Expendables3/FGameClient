package GUI.component 
{
	import com.adobe.utils.StringUtil;
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatBox extends Sprite 
	{
		public var img:Sprite;
		public var text:String;
		public var IsShow:Boolean;
		public var textfield:TextField;
		public var format:TextFormat;
		public var ContentImg: String = "imgThinkContent";
		
		private var ArrowOffsetX:int = 12;
		private var ArrowOffsetY:int = 12; 
		private var CurveOffset:int = 6;
		private var MaxWidth:int = 140;
		private var Parent:Object;
		private var TimeOut:Timer = null;
		
		
		public function ChatBox() 
		{
			IsShow = false;
			textfield = new TextField();
			format = new TextFormat();
			img = new Sprite();
			
			this.addChild(img);
			this.mouseChildren = false;
			this.mouseEnabled = false;			
			Parent = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
		}
		
		public function Show(st:String, timeout:Number = 5000, txtFormat:TextFormat = null):void
		{	
			st = StringUtil.trim(st);
			if (IsShow || st == "")
			{
				return;
			}
			Parent.addChild(this);
			IsShow = true;			
			
			if (txtFormat == null)
			{
				format.font = "Arial";
				format.size = 12;
				format.color = "0x0047A6";
				format.bold = true;
				format.align = "center";
			}
			else
			{
				format = txtFormat;				
			}
			var txtWidth:int = GetTextWidth(st);
			var txtHeight:int = GetTextHeight(st);
			
			// ve hinh da giac bao
			var posThink:Point = DrawPolygon(img.x, img.y, txtWidth, txtHeight);
			
			// Định dạng textfield
			textfield.text = st;
			textfield.defaultTextFormat = format;
			textfield.setTextFormat(format);
			textfield.autoSize = TextFieldAutoSize.CENTER;			
			textfield.wordWrap = true;
			textfield.width = txtWidth;
			textfield.height = txtHeight;
			//textfield.x = - textfield.textWidth / 2;
			//textfield.y = - textfield.textHeight/2 - txtHeight - txtHeight/6;
			textfield.x = -txtWidth/2;
			textfield.y = posThink.y - txtHeight / 8 - 10 + 2;
			textfield.mouseEnabled = false;
			img.addChild(textfield);
			//textfield.border = true;
			
			if (timeout > 0)
			{
				TimeOut = new Timer(timeout, 1);
				TimeOut.addEventListener(TimerEvent.TIMER, ProcessTimeOut);
				TimeOut.start();
			}
		}
		
		public function Hide():void
		{
			if (!IsShow && GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				return;
			}
			if (this.parent == Parent)
			{
				Parent.removeChild(this);				
			}
			IsShow = false;
			TimeOut = null;			
		}
		
		public function ProcessTimeOut(e:TimerEvent):void
		{
			if (TimeOut != null)
			{
				TimeOut.removeEventListener(TimerEvent.TIMER, ProcessTimeOut);
			}			
			Hide();
		}
		
		private function GetTextWidth(text:String):int
		{
			var Txt:TextField = new TextField();
			Txt.text = text;
			Txt.setTextFormat(format);
			Txt.wordWrap = true;
			Txt.autoSize = TextFieldAutoSize.CENTER;			
			Txt.width = MaxWidth;	//250	117
			
			return Txt.textWidth + ArrowOffsetX// + 20;
		}
		
		private function GetTextHeight(text:String):int
		{
			var Txt:TextField = new TextField();
			Txt.text = text;
			Txt.setTextFormat(format);			
			Txt.wordWrap = true;
			Txt.autoSize = TextFieldAutoSize.CENTER;
			Txt.width = MaxWidth;
			
			return Txt.textHeight + ArrowOffsetY// + 20;
		}
		
		private function DrawPolygon(x:int, y:int, iWidth:int, iHeight:int, alpha:Number = 0.7):Point
		{	
			while (img.numChildren > 0)
			{
				img.removeChildAt(0);
			}
			var imgThink:Sprite = ResMgr.getInstance().GetRes("imgThink") as Sprite;
			var imgThinkContent:Sprite = ResMgr.getInstance().GetRes(ContentImg) as Sprite;			
			
			img.addChild(imgThink);
			img.addChildAt(imgThinkContent, 0);			
			imgThinkContent.width = iWidth + (iWidth/6);
			imgThinkContent.height = iHeight + (iHeight / 4);			
			//imgThinkContent.x = 5;
			imgThinkContent.y = -imgThink.height - imgThinkContent.height / 2 - 3;
			
			var pos:Point = new Point();
			pos.x = imgThinkContent.x;
			pos.y = imgThinkContent.y;
			return pos;
			//img.graphics.clear();
			//img.graphics.lineStyle(1, 0x0085FF);
			//img.graphics.beginFill(0xffffff, alpha);	
			/*
			 ************************************
			 * 									*
			 * 									*
			 * 									*
			 * 									*
			 **************	  *******************
			                * 
			 */
			//img.graphics.moveTo(x, y);
			//img.graphics.drawEllipse(x, y, 7, 5);
			//img.graphics.drawEllipse(x + 10, y - 8, 10, 8);
			//img.graphics.drawEllipse(x + 20 - iWidth/2 - (iWidth/6), y - 14 - iHeight - (iHeight/6), iWidth + (iWidth/6), iHeight + (iHeight/6));
			//img.graphics.lineTo(x - ArrowOffsetX, y - ArrowOffsetY);
			//img.graphics.lineTo(x - iWidth/2, y - ArrowOffsetY);
			//img.graphics.lineTo(x - iWidth/2, y - ArrowOffsetY - iHeight);
			//img.graphics.lineTo(x + iWidth/2, y - ArrowOffsetY - iHeight);
			//img.graphics.lineTo(x + iWidth/2, y - ArrowOffsetY);
			//img.graphics.lineTo(x + ArrowOffsetX, y - ArrowOffsetY);
			//img.graphics.lineTo(x, y);
			//img.graphics.drawRoundRect(x, y, iWidth, iHeight, 10, 10);
		
			//img.graphics.endFill();
		}
		
	}

}