package GUI.component 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import Sound.SoundMgr;
	
	/**
	 * sinh ra 1 cái nút trên GUI
	 * @author ducnh
	 */
	public class ButtonEx extends Image
	{
		public var isEnable:Boolean = true;
		public var ButtonID:String;
		public var EventHandler:Container;
		public var TooltipText:String = null;
		private var IsMouseOver:Boolean = false;
		private var tooltip:TooltipFormat = null;
		
		public function ButtonEx(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ButtonEx";
			img.buttonMode = true;
		}
		
		public function SetBtnInfo(btnID:String):void
		{			
			ButtonID = btnID;
		}
		
		public override function Destructor():void
		{
			removeAllEvent();
			EventHandler = null;
		}
		
		public function setTooltip(tip:TooltipFormat):void
		{
			tooltip = tip;
		}
		
		public function setTooltipText(text:String):void
		{
			if(tooltip == null)
			{
				tooltip = new TooltipFormat();
			}
			tooltip.text = text;
		}
		
		public function SetBlink(IsBlink:Boolean):void
		{
			if(img != null)
			{
				var m:MovieClip = img.getChildAt(0) as MovieClip;
				if (!m) return;
				if (IsBlink)
				{
					m.gotoAndStop("Blink");
				}
				else
				{
					m.gotoAndStop("Normal");
				}
			}
		}
		
		//h: tra ve vi tri Button
		public function GetPos(): Point
		{
			var point: Point = new Point();
			point.x = img.x;
			point.y = img.y;
			return point;
		}
		
		public function SetHighLight(color:Number = 0x00FF00):void
		{
			if (color < 0)
			{
				img.filters = null;
				return;
			}
			
			var glow:GlowFilter = new GlowFilter(color, 1, 4, 4, 8);
			img.filters = [glow];
		}
		
		public function SetDisable():void
		{
			img.mouseEnabled = false;
			
			var elements:Array =
			[0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0, 0, 0, 1, 0];

			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
			img.filters = [colorFilter];
		}
		public function SetDisable2():void
		{
			//img.mouseEnabled = false;
			isEnable = false;
			img.removeEventListener(MouseEvent.CLICK, OnButtonClickNone);
			img.removeEventListener(MouseEvent.CLICK, OnButtonClick);
			
			var elements:Array =
			[0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0, 0, 0, 1, 0];

			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
			img.filters = [colorFilter];
		}
		public function OnButtonClickNone(event:MouseEvent):void
		{
			
		}
		public function SetEnable(IsEnable:Boolean):void
		{
			if (!IsEnable)
			{
				img.mouseEnabled = false;
				removeAllEvent();
				
				var elements:Array =
				[0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0, 0, 0, 1, 0];

				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				img.filters = [colorFilter];
			}
			else
			{
				addAllEvent();
				img.mouseEnabled = true;
				isEnable = true;
				img.filters = null;
			}
		}
		
		public function SetVisible(IsVisible:Boolean):void
		{
			if (img != null)
			{
				img.visible = IsVisible;
			}
		}
		
		public function addAllEvent():void
		{
			img.addEventListener(MouseEvent.CLICK, OnButtonClick);
			img.addEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.addEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
			img.addEventListener(MouseEvent.MOUSE_MOVE, OnButtonMouseMove);
			img.addEventListener(MouseEvent.MOUSE_DOWN, OnButtonMouseDown);
		}
		
		public function removeAllEvent():void
		{
			img.removeEventListener(MouseEvent.CLICK, OnButtonClick);
			img.removeEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.removeEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
			img.removeEventListener(MouseEvent.MOUSE_MOVE, OnButtonMouseMove);
			img.removeEventListener(MouseEvent.MOUSE_DOWN, OnButtonMouseDown);
			
			ClearEvent();
		}
		
		public override function OnLoadRes():void
		{
			addAllEvent();
		}
		
		
		public override function OnBeforeReloadRes():void
		{
			removeAllEvent();
		}
		
		
		public override function OnReloadRes():void
		{
			addAllEvent();
		}
		
		private function OnButtonClick(event:MouseEvent):void
		{
			if (EventHandler == null) return;
			
			var imgExt:MovieClip  = img as MovieClip;
			imgExt.gotoAndPlay("MouseOut");
			IsMouseOver = false;
			var sound:Sound = SoundMgr.getInstance().getSound("Click") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			if (event.currentTarget == img)
			{
				EventHandler.OnButtonClick(event, ButtonID);
			}
		}
		
		private function OnButtonMouseOver(event:MouseEvent):void
		{
			setStateMouseOver();
			
			if (EventHandler == null) return;
			
			//if (TooltipText != null)
			//{
				//if (event.currentTarget == img)
				//{
					//Tooltip.getInstance().ShowNewToolTip(TooltipText, event.stageX, event.stageY);
					//Tooltip.getInstance().SetTimeOut(1000);
				//}
			//}
			
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().showNewToolTip(tooltip, img);
			}
			
			if (event.target == img)
			{
				EventHandler.OnButtonMove(event, ButtonID);
			}
		}
		
		private function OnButtonMouseOut(event:MouseEvent):void
		{
			setStateMouseOut();
			
			if (EventHandler == null) return;
			
			//if (TooltipText != null)
			//{
				//Tooltip.getInstance().ClearTooltip();
			//}
			
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().clearToolTip();
				//ActiveTooltip.getInstance().showNewToolTip(tooltip, img);
			}
			
			if (event.target == img)
			{
				EventHandler.OnButtonOut(event, ButtonID);
			}
		}
		
		private function OnButtonMouseMove(event:MouseEvent):void
		{
			if (EventHandler == null) return;
			
			//if (TooltipText != null)
			//{
				//if (event.target == img)
				//{
					//Tooltip.getInstance().ShowNewToolTip(TooltipText, event.stageX, event.stageY);
					//Tooltip.getInstance().SetTimeOut(2000);
				//}
			//}
		}
		
		private function OnButtonMouseDown(event:MouseEvent):void
		{
			var imgExt:MovieClip  = img as MovieClip;
			imgExt.gotoAndPlay("MouseDown");
		}
		
		public function setStateMouseOver():void
		{
			if (!IsMouseOver)
			{
				var imgExt:MovieClip  = img as MovieClip;
				imgExt.gotoAndPlay("MouseOver");
				IsMouseOver = true;
			}
		}
		
		public function setStateMouseOut():void
		{
			if (IsMouseOver)
			{
				var imgExt:MovieClip  = img as MovieClip;
				imgExt.gotoAndPlay("MouseOut");
				IsMouseOver = false;
			}
		}
	}

}