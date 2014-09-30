package GUI.GUINoneAbstract 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	/**
	 * những gui đặc biệt mà không có nút đóng, không có background...
	 * ẩn hiện = cách xổ xuống, kéo sang
	 * @author HiepNM2
	 */
	public class GUINoneAbstract extends BaseGUI 
	{
		private var isLoadCtnReady:Boolean = false;
		protected var ShiftFromInitGui:Boolean = false;
		protected var _xScr:int;
		protected var _yScr:int;
		protected var _xDes:int;
		protected var _yDes:int;
		protected var _themeName:String;
		protected var _bgName:String;
		protected var ctnBg:Container;
		protected var _xGui:int;
		protected var _yGui:int;
		protected var _wMask:int;
		protected var _hMask:int;
		private var _timer:Timer;
		public function GUINoneAbstract(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUINoneAbstract";
		}
		
		public function initData(xScr:int, yScr:int, xDes:int, yDes:int,
									themeName:String):void
		{
			_xScr = xScr;
			_yScr = yScr;
			_xDes = xDes;
			_yDes = yDes;
			_themeName = themeName;
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(_xGui, _yGui);
				/*b1: tạo mask cho ctnBg*/
				var mask:Sprite = new Sprite();
				mask.graphics.beginFill(0x000000);
				mask.graphics.drawRect(0, 0, _wMask, _hMask);
				mask.graphics.endFill();
				img.addChild(mask);
				mask.visible = false;
				/*b2: add các phần tử vào gui*/
				ctnBg = AddContainer("", _bgName, _xScr, _yScr);
				ctnBg.setImgInfo = function():void
				{
					onInitGui();	//thực hiện add các thứ vào ctnBg hoặc vào gui
					ctnBg.img.mask = mask;
					WaitAndShift();
					isLoadCtnReady = true;
				}
				if (isLoadCtnReady)
				{
					onInitGui();
					ctnBg.img.mask = mask;
					WaitAndShift();
				}
			}
			LoadRes(_themeName);
		}

		
		protected virtual function onInitGui():void 
		{
			
		}
		
		protected virtual function onFinishShowGui():void
		{
			
		}
		/**
		 * kéo gui vào vùng khuất vào hủy gui
		 */
		public function hideGui():void
		{
			onBeforeHideGui();
			TweenMax.to(ctnBg.img, 1, 
							{ 
								x:_xScr, y:_yScr, 
								ease:Back.easeIn,
								onComplete:onFinishTween,
								onCompleteParams:[this]
							} 
						);
			function onFinishTween(myGui:GUINoneAbstract):void
			{
				myGui.Hide();
				onAfterHideGui();
			}
		}
		public function hideGui2():void
		{
			onBeforeHideGui();
			TweenMax.to(ctnBg.img, 1, 
							{ 
								x:_xScr, y:_yScr, 
								onComplete:onFinishTween,
								onCompleteParams:[this]
							} 
						);
			function onFinishTween(myGui:GUINoneAbstract):void
			{
				myGui.Hide();
				onAfterHideGui();
			}
		}
		protected virtual function onBeforeHideGui():void 
		{
			
		}
		/**
		 * sau khi hide gui, thường xử lý logic
		 */
		protected virtual function onAfterHideGui():void 
		{
			
		}
		
		/**
		 * di chuyển ctnBg đến _xDes, _yDes
		 * hàm được gọi khi ctnBg và mọi thứ trên nó đã được load vào ctnBg đầy đủ
		 */
		public function showGui():void
		{
			TweenMax.to(ctnBg.img, 1, 
									{ 
										x:_xDes, y:_yDes,
										ease:Quint.easeInOut,
										onComplete:onFinishShowGui
									} 
								);
		}
		
		private function WaitAndShift():void
		{
			if (ShiftFromInitGui)
			{
				_timer = new Timer(100);//0.1s đủ để cho gui này khởi tạo xong
				_timer.addEventListener(TimerEvent.TIMER, timerListener);
				function timerListener(e:TimerEvent):void 
				{
					
					showGui();
					_timer.removeEventListener(TimerEvent.TIMER, timerListener);
				}
				_timer.start();
			}
		}
	}

}














