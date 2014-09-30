package GUI.component 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import GUI.GuiMgr;
	import GUI.GUIWaitingContent;
	import Logic.*;
	
	/**
	 * lớp GUI cơ sở, các GUI khác sau này phát triển sẽ kế thừa cái này (GUIAbout, GUIHlep...)
	 * @author ducnh
	 */
	public class BaseGUI extends Container
	{
		public var iLayer:int;
		private var ModalLevel:int = 0;
		public var IsVisible:Boolean;
		private var SpeedRoom:Number = 0;
		public var IsFinishRoomOut:Boolean;
		protected var Fog:Sprite = null;
		public var IsFullscreen:Boolean;
		public var f:Function = null;
		
		protected var LastX:int;
		protected var LastY:int;
		
		public function BaseGUI(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "BaseGUI";
			if (parent != null)
			{
				InitGUI();
			}
		}
		
		/**
		 * hiển thị cái GUI ra màn hình
		 * @param ilayer layer mà cái GUI này đặt lên
		 * @param ShowModal mức độ hiển thị của cái GUI này (= 0 => các layer thấp hơn ko bị khóa, > 0 => các layer thấp hơn sẽ bị khóa )
		 */
		public virtual function Show(ilayer:int = Constant.GUI_MIN_LAYER, ShowModal:int = 0):void
		{
			this.iLayer = ilayer;
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			ModalLevel = ShowModal;
			IsVisible = true;
			IsFullscreen = false;
			if (ModalLevel < 0)
			{
				ModalLevel = 0;
			}
			if (layer)
			{
				if (iLayer != Constant.EmptyLayer)
				{
					Clear();
				}
				//this.iLayer = ilayer;
				Parent = layer as Sprite;
				if (f != null)
				{
					f(this);
				}
				else
				{
					InitGUI();
				}
			}

			if (ModalLevel > 0)
			{
				switch (ModalLevel)
				{
					case 1:
						ShowDisableScreen(0.01);
						break;
					case 2:
						ShowDisableScreen(0.1);
						break;
					case 3:
						ShowDisableScreen(0.3);
						break;
					case 4:
						ShowDisableScreen(0.5);
						break;
					case 10:
						ShowDisableScreen(1);
						break;
					default:
						ShowDisableScreen(0.6);
						break;
				}
			}
		}
		
		public function OpenMoving(xsrc:int , ysrc:int, xdes:int, ydes:int, speed:Number):void
		{
			if (img == null) return;
			SetPos( xsrc, ysrc);
			MoveTo(xdes, ydes, speed);
			var timer:Timer = new Timer(1, 100);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
			function timerListener (e:TimerEvent):void
			{
				UpdateObject();
			}
			timer.start();
					
			function timerDone(e:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER, timerListener);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
			}
		}
		
		//public function OpenRoomOut(xsrc:int , ysrc:int, speedRoomOut:Number):void
		public function OpenRoomOut(scaleSrc:Number = 0, scaleDes:Number = 1, speedRoomOut:Number = 0.3, isFromCenter:Boolean = true):void
		{
			if (img == null) return;
			if (speedRoomOut <= 0) return;
			
			
			var bound:Rectangle = img.getBounds(img.parent);
			SpeedRoom = speedRoomOut;
			IsFinishRoomOut = false;
			
			//if (img.scaleX != scaleDes)
			{
				img.scaleX = img.scaleY = scaleSrc;
			}
			
			//SetPos( xsrc, ysrc);
			//MoveTo(x , y, 10);
			
			var timer:Timer = new Timer(1, 100);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
			function timerListener (e:TimerEvent):void
			{
				//UpdateObject();
				if (img && img.scaleX < scaleDes)
				{
					img.scaleX += SpeedRoom;					
					img.scaleY += SpeedRoom;
					if(img.scaleX > scaleDes) img.scaleX = img.scaleY = scaleDes + 0.01;
					if (isFromCenter)
					{
						SetPos(bound.x + (bound.width - img.width) / 2, bound.y + (bound.height - img.height) / 2);
					}
				}
				else
				{
					timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));					
				}
				
			}
			timer.start();
			
			
			function timerDone(e:TimerEvent):void
			{
				if (img)
				{
					img.scaleX = img.scaleY = scaleDes;
					if (isFromCenter)
					{
						SetPos(bound.x + (bound.width - img.width) / 2, bound.y + (bound.height - img.height) / 2);
					}
				}
				IsFinishRoomOut = true;				
				timer.removeEventListener(TimerEvent.TIMER, timerListener);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
				EndingRoomOut();
			}
		}
		
		/**
		 * ẩn cái GUI khỏi màn hình
		 * nếu GUI đang ở chế độ ShowModal > 0, thì khi ẩn chế độ này tự mất đi
		 */
		public function Hide():void
		{
			if (iLayer == Constant.EmptyLayer) 
			{
				return;
			}
			
			var clear:Boolean = true;
			
			//Thực hiện effect cửa sổ thu nhỏ dần lại
			//if (IsVisible && SpeedRoom > 0)
			//{
				//clear = false;
				//var bound:Rectangle = img.getBounds(img.parent);
				//var timer:Timer = new Timer(1, 100);
				//timer.addEventListener(TimerEvent.TIMER, timerListener);
				//timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
				//function timerListener (e:TimerEvent):void
				//{
					//if (img.scaleX > 0)
					//{
						//SetPos(bound.x + (bound.width - img.width) / 2, bound.y + (bound.height - img.height) / 2);
						//img.scaleX -= SpeedRoom;
						//img.scaleY -= SpeedRoom;	
					//}
					//else
					//{	
						//timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));							
					//}
				//}
				//timer.start();				
				//
				//function timerDone(e:TimerEvent):void
				//{
					//img.scaleX = img.scaleY = 0;
					//timer.removeEventListener(TimerEvent.TIMER, timerListener);
					//timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
					//Clear();
				//}
			//}		
			
			
			if (ModalLevel > 0)
			{
				HideDisableScreen();
				//var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
				//if (layer)
				//{
					//layer.HideDisableScreen();
				//}
				
			}
			iLayer = Constant.EmptyLayer;
			IsVisible = false;		
			
			OnHideGUI();
			if (clear)
			{
				this.Clear();
			}
		}
		
		/**
		 * hàm ảo để add các component vào GUI như (textbox, button, label...)
		 * khi tạo 1 cái class GUI mới, thì cần viết đè hàm này
		 */
		public virtual function InitGUI():void
		{
		}
		
		public virtual function OnHideGUI():void
		{
		}
		
		public virtual function EndingRoomOut():void
		{
			
		}
		
		/**
		 * Chuyển đổi qua lại thông tin GUI khi fullscreen hoặc ko fullscreen
		 * @param	IsFull
		 * @param	dx: độ dịch chuyển theo phương x
		 * @param	dy: độ dịch chuyển theo phương y
		 * @param	scaleX: phóng to theo phương x
		 * @param	scaleY: phóng to theo phương y
		 */
		public virtual function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void
		{
			IsFullscreen = IsFull;
			if (IsFullscreen)
			{
				LastX = img.x;
				LastY = img.y;
				img.x += dx;
				img.y += dy;
			}
			else
			{
				img.x = LastX;
				img.y = LastY;
			}
		}
		
		/**
		* Cho phép disable các layer nằm dưới đi
		* @param độ phủ của layer lên các layer nằm dưới. Nằm trong khoảng từ 0 -> 1.
		* Càng lớn thì các layer nằm dưới càng bị mờ.
		**/ 
		public function ShowDisableScreen(alpha:Number):void
		{
			var x:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenWidth;
			var y:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenHeight;
			if (Fog == null)
			{
				Fog = new Sprite();
				Fog.graphics.beginFill(0x000000, alpha);
				Fog.graphics.drawRect(-x, -y, 2*x, 2*y);
				Fog.graphics.endFill();
			}
			HideDisableScreen();
			if (img != null)
			{
				var vt:int = img.parent.getChildIndex(img);
				img.parent.addChildAt(Fog, vt);
				img.parent.removeChild(img);
				Fog.addChild(img);
			}
		}
		
		public function AddEventMouseUpFog(f:Function):void 
		{
			if (Fog)
			{
				Fog.addEventListener(MouseEvent.MOUSE_UP, f);
			}
			
		}
		
		public function RemoveEventMouseUpFog(f:Function):void 
		{
			if (Fog)
			{
				Fog.removeEventListener(MouseEvent.MOUSE_UP, f);
			}
		}
		
		/**
		* Bỏ trạng thái disable của các layer nằm dưới đi
		**/ 
		public function HideDisableScreen(isKeepImg:Boolean = false):void
		{
			if ((Fog != null) && (Fog.parent != null))
			{
				if(isKeepImg)
				{
					var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
					var index:int = layer.getChildIndex(Fog);
					Fog.parent.removeChild(Fog);
					layer.addChildAt(img, index);
				}
				else
				{
					Fog.parent.removeChild(Fog);
				}
			}
		}
		
		// kiem tra 1 diem co nam trong GUI ko
		public function IsPointInGUI(x:int, y:int):Boolean
		{
			if (IsVisible)
			{
				return img.hitTestPoint(x, y);
			}
			return false;
		}
		
		public override function OnLoadResComplete():void
		{
			IsVisible = true;
			if (GuiMgr.getInstance().GuiWaitingContent.IsVisible && !(this is GUIWaitingContent))
			{
				GuiMgr.getInstance().GuiWaitingContent.Hide();
			}
			
			var vt:int = -1; 
			if (img.parent)
			{
				vt = img.parent.getChildIndex(img);
			}
			if (vt >= 0 && Fog && !(this is GUIWaitingContent))
			{
				img.parent.removeChild(img);
				Fog.addChild(img);
			}
		}
		
		public override function OnLoadResErr(e:Event):void 
		{
			this.Hide();
			if (GuiMgr.getInstance().GuiWaitingContent.IsVisible)
			{
				GuiMgr.getInstance().GuiWaitingContent.SetText("Tải thất bại");
			}
		}
	}

}