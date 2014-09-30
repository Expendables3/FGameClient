package GUI.component 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ducnh
	 */
	public class ScrollBar 
	{
		private static const STATE_INC:String = "inc";
		private static const STATE_DEC:String = "dec";
		
		public var img:Sprite;
		public var scrollImage:Sprite = null;
		private var btnInc:SimpleButton;
		private var btnDec:SimpleButton;
		public var btnBar:Sprite;
		public var bar:Sprite;
		private var icon:Sprite;
		public var EventHandler:Container;
		public var id:String;
		public var speed:Number = 0.1;
		private var percent:Number = 0;
		private var state:String = "";
		private var isDrag:Boolean = false;
		private var count:int = 0;
		private var dy:int;
		private var _enable:Boolean = true;
		
		private var scrollW:int;
		private var scrollH:int;
		private var scBar:Sprite;
		public var numChild:int;
		
		public function ScrollBar(image:Sprite) 
		{
			img = image;
			img.addEventListener(Event.ENTER_FRAME, update);
			
			bar = img.getChildByName("bar") as Sprite;
			bar.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			
			btnInc = img.getChildByName("button_inc") as SimpleButton;
			addMouseEvent(btnInc);
			
			btnDec = img.getChildByName("button_dec") as SimpleButton;
			addMouseEvent(btnDec);
			
			
			icon = img.getChildByName("icon") as Sprite;
			addMouseEvent(icon);
			
			// goi cai btn voi icon lai
			btnBar = new Sprite();
			var tg:Sprite = img.getChildByName("button_bar") as Sprite;
			tg.x = 0;
			tg.y = 0;
			btnBar.addChild(tg);
			icon.y = (tg.height - icon.height) / 2;
			icon.x = (tg.width - icon.width) / 2;
			btnBar.addChild(icon);
			img.addChild(btnBar);
			addMouseEvent(btnBar);
			//btnBar.x = bar.x+2;
			btnBar.y = bar.y;
			
			
			setPercent(0);
		}
		
		public function destructor():void
		{
			removeMouseEvent(btnInc);
			removeMouseEvent(btnDec);
			removeMouseEvent(btnBar);
			removeMouseEvent(icon);
			img.removeEventListener(Event.ENTER_FRAME, update);
			bar.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			
			bar.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			
			img.parent.removeChild(img);
			img = null;
			bar = null;
			btnInc = null;
			btnDec = null;
			btnBar = null;
		}
		
		public function set height(value:int):void
		{
			var d:Number = value - bar.height;
			bar.height = value;
			btnInc.y += d;
		}
		
		public function get height():int
		{
			return bar.height;
		}
		
		/**
		 * đặt đối tượng sẽ bị scroll
		 * @param	image đối tượng bị scroll
		 * @param	width chiều rộng vùng scroll (vùng nhìn thấy chứ ko phải là image.width)
		 * @param	height chiều dài vùng scroll (vùng nhìn thấy chứ ko phải là image.height)
		 */
		public function setScrollImage(image:Sprite, viewWidth:int, viewHeight:int):void
		{
			scrollImage = image;
			//btnBar.height = bar.height * (1 - (numItem - numShow) / numItem);
			scrollW = viewWidth;
			scrollH = viewHeight;
			height = viewHeight;
			numChild = scrollImage.numChildren;
			imageResize();
		}
		
		private function imageResize():void 
		{
			if (scrollImage.height <= 0) 
			{
				return;
			}
			var tg:DisplayObject = btnBar.getChildByName("button_bar");
			tg.height = getBtnBarHeight();
			icon.y = tg.y + (tg.height - icon.height) / 2;
			setPercent(percent);
		}
		
		public function getScrollCurrentPercent():Number
		{
			return percent;
		}
		
		public function getBtnBarHeight():Number
		{
			var height:Number;
			if (scrollImage.height <= scrollH)
			{
				height = bar.height;
			}
			else
			{
				height = bar.height * (1 - (scrollImage.height - scrollH) / scrollImage.height);
			}
			return height;
		}
		
		private function updatePercentByBar():void
		{
			var minY:int = bar.y;
			var maxY:int = bar.y + bar.height - btnBar.height;
			var tg:Number = (btnBar.y - minY) / (maxY - minY);
			setPercent(tg);
			onChange();
		}
		
		public function setScrollPos(dy:int):void
		{
			btnBar.y = dy;
			updatePercentByBar();
		}
		
		private function update(e:Event):void 
		{
			if (this.img == null)
			{
				return;
			}			
			if (isDrag)
			{
				updatePercentByBar();
			}
			if (count > 0)
			{
				count--;
				return;
			}
			if (numChild != scrollImage.numChildren)
			{
				imageResize();
			}
			switch (state)
			{
				case STATE_INC:
					updatePercent(speed, true);
					break;
				case STATE_DEC:
					updatePercent(-speed, true);
					break;
			}
		}
		
		private function addMouseEvent(btn:DisplayObject):void
		{
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			btn.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
		}
		
		private function removeMouseEvent(btn:DisplayObject):void
		{
			btn.removeEventListener(MouseEvent.CLICK, onButtonClick);
			btn.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			btn.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
		}
		
		public function setPercent(value:Number, updateBar:Boolean = false):void
		{	
			if (btnBar == null)
			{
				return;
			}
			var tg:Number = value;
			if (tg < 0)
			{
				tg = 0;
			}
			if (tg > 1)
			{
				tg = 1;
			}
			
			var minY:int = bar.y;
			var maxY:int = bar.y + bar.height - btnBar.height;
			// update vi tri bar
			percent = tg;
			if (updateBar)
			{
				btnBar.y = minY + (maxY - minY) * percent;
			}
			//icon.y = btnBar.y + (btnBar.height - icon.height) / 2;
			onChange();
		}
		
		private function updatePercent(d:Number, updateBar:Boolean = false):void
		{
			var tg:Number = percent + d;
			if (tg < 0)
			{
				tg = 0;
			}
			if (tg > 1)
			{
				tg = 1;
			}
			if (scrollImage.height < scrollH)
			{
				return;
			}
			setPercent(tg, updateBar);
			onChange();
		}
		
		public function get visible():Boolean
		{
			return img.visible;
		}
		public function set visible(value:Boolean):void
		{
			img.visible = value;
		}
		
		public function set enable(value:Boolean):void
		{
			if (!value)
			{
				//img.mouseEnabled = false;
				_enable = false;
			
				var elements:Array =
				[0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0, 0, 0, 1, 0];

				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				img.filters = [colorFilter];
				img.mouseEnabled = false;
			}
			else
			{
				_enable = true;
				img.mouseEnabled = true;
				img.filters = null;
			}
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			switch (e.target)
			{
				case btnInc:
					updatePercent(speed, true);
					break;
				case btnDec:
					updatePercent(-speed, true);
					break;
				case btnBar:
					break;
			}

		}

		private function onButtonMouseDown(e:MouseEvent):void 
		{
			if (e.currentTarget == btnBar)
			{
				img.stage.addEventListener(MouseEvent.MOUSE_UP, unDrag);
				dy = e.localY;
				isDrag = true;
				var r:Rectangle = new Rectangle(btnBar.x, bar.y, 0, bar.height - btnBar.height);
				btnBar.startDrag(false, r);
			}
			switch (e.target)
			{
				case btnInc:
					state = STATE_INC;
					count = 10;
					break;
				case btnDec:
					state = STATE_DEC;
					count = 10;
					break;
				case bar:
					var minY:int = bar.y;
					var maxY:int = bar.y + bar.height - btnBar.height;
					var tg:Number = e.localY;
					if (tg < minY)
					{
						tg = minY;
					}
					if (tg > maxY)
					{
						tg = maxY;
					}
					btnBar.y = tg;
					updatePercentByBar();
					break;
			}
		}
		
		private function unDrag(e:MouseEvent):void 
		{
			isDrag = false;
			if (img)
			{
				img.stage.removeEventListener(MouseEvent.MOUSE_UP, unDrag);
				btnBar.stopDrag();
			}
		}
		
		private function onButtonMouseUp(e:MouseEvent):void 
		{
			state = "";
			isDrag = false;
			
		}
		
		private function onChange():void
		{
			// update scrollImage
			if (scrollImage)
			{
				var tg:Number = (scrollImage.height - scrollH) / scrollImage.height;
				tg *= percent;
				if (scrollImage.height >= scrollH)
				{
					scrollImage.y = -tg * scrollImage.height;
				}
				else
				{
					scrollImage.y = 0;
				}
			}
			
			if (EventHandler == null) return;
			EventHandler.OnScrollBarChange(id, percent);
		}
	}

}