package Logic{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Data.ResMgr;
	import flash.display.Stage;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import GameControl.HelperMgr;
	import GUI.component.ChatBox;
	import GUI.component.Image;
	import flash.filters.GlowFilter;
	
	/**
	* Lớp đối tượng cơ bản nằm ở mức cao nhất, khi tạo các lớp mới nên kế thừa lớp này
	* <br>Khi kế thừa lớp này, các lớp con sẽ có một số tính chất:</br>
	* <br> - Load tài nguyên</br>
	* <br> - Di chuyển tới một vị trí mới</br>
	* <br> - Kéo thả</br>
	* <br> - Thiết lập vị trí</br>
	* <br> - Chuyển đổi layer</br>
	* <br> - Phát sinh các sự kiện trong GameInput</br>
	*/
	 public class BaseObject extends Image {
		 
		public static const OBJ_STATE_IDLE:int = 1;
		public static const OBJ_STATE_EDIT:int = 2;
		public static const OBJ_STATE_USE:int = 3;
		public static const OBJ_STATE_BUY:int = 3;
		 
		/**Layer hiện tại của đối tượng, Layer thấp nhất là layer 0, Không có layer âm*/
		public var iLayer:int = 0;
		
		/**Id của đối tượng*/
		//public var IdObject:String;
		
		/**Content của đối tượng*/
		//public var img:Sprite = new Sprite;
		
		public var DesPos:Point = null;
		//protected var CurPos:Point = new Point();
		public var SpeedVec:Point = null;
		public var Dragable:Boolean = false;
		public var ReachDes:Boolean = false;
		public var ObjectState:int = OBJ_STATE_IDLE;
		
		// bien luu lai vi tri truoc khi drag
		protected var OldDragX:int;
		protected var OldDragY:int;
		protected var OldDragScaleX:Number;
		protected var OldDragScaleY:Number;
		public var IsDraging:Boolean = false;
		
		// Các textfield hiện trên đối tượng
		public var chatbox:ChatBox = new ChatBox();
 
		/**
		* Khởi tạo đối tượng
		* @param iLayer Layer mà đối tượng sẽ thuộc về
		**/
		public function BaseObject(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "BaseObject";
			DesPos = new Point();
			SpeedVec = new Point();
		}
		
		public function SetClassName(className:String):void
		{
			ClassName = className;
		}
		 
		public function SetInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
		
		public  function GetPos():Point
		{
			return CurPos;
		}
		
		public virtual function SetHighLight(color:Number = 0x00FF00):void
		{
			if (img == null)
			{
				return;
			}
			
			if (color < 0)
			{
				img.filters = null;
				return;
			}
			
			var glow:GlowFilter = new GlowFilter(color, 1, 5, 5, 5);
			img.filters = [glow];
		}

		
		/**
		 * Cho phép đối tượng có thể kéo thả
		 * @param
		 * <br> = true thì được phép kéo thả </br>
		 * <br> = fale thì không được phép kéo thả </br>
		 **/
		public function SetDragable(dragable:Boolean):void
		{
			Dragable = dragable;
		}
		
		/**
		 * Cho phép đối tượng có thể kéo thả
		 * @param x tọa độ theo phương x của điểm đích
		 * @param y tọa độ theo phương y của điểm đích
		 * @param speed tốc độ di chuyển của đối tượng (trên mỗi frame)
		 **/
		public function MoveTo(x:int, y:int, speed:Number):void
		{
			ReachDes = false;
			DesPos.x = x;
			DesPos.y = y;
			SpeedVec = DesPos.subtract(new Point(CurPos.x, CurPos.y));
			SpeedVec.normalize(speed);
		}
		
		
		/**
		 * Cập nhật trạng thái, vị trí đối tượng mỗi frame. Phương thức này phải được gọi trong vòng lặp frame
		 **/
		public function UpdateObject():void
		{
			if (ReachDes)
			{
				return;
			}
				
			var temp:Point = CurPos.subtract(DesPos);
			if ( temp.length <= SpeedVec.length)
			{
				ReachDes = true;
				return;
			}
				
			CurPos = CurPos.add(SpeedVec);
			this.img.x = CurPos.x;
			this.img.y = CurPos.y;			
		}
		
		
		/**
		 * Đối tượng chuyển từ layer hiện tại sang layer mới
		 * @param newILayer Layer đích mà đối tượng sẽ chuyển sang
		 **/
		public function ChangeLayer(newILayer:int):void
		{
			var layer:Object = LayerMgr.getInstance().GetLayer(newILayer);
			if (Parent == layer)
			{
				return;
			}
				
			if ((layer != null) && (Parent != null) && (img != null) && (img.parent != null))
			{
				img.parent.removeChild(img);				
				layer.addChild(img);
				iLayer = newILayer;
				Parent = layer;
			}
			
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
		
		
		 /**
		 * Add tất cả các sự kiện input từ bàn phím
		 **/
		 public function addAllEvent():void
		 {
			if (img == null)
				return;
				
			img.mouseChildren = true;
			img.mouseEnabled = true;
			
			//event cho img
			img.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			img.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
			img.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);			
			img.addEventListener(MouseEvent.CLICK, OnMouseClick);
			img.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			img.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			img.addEventListener(MouseEvent.ROLL_OVER, OnMouseOver);
			img.addEventListener(MouseEvent.ROLL_OUT, OnMouseOut);

		 }
		 
		 public function removeAllEvent():void
		 {
			 if (img == null)
				return;
				
			img.mouseChildren = false;
			img.mouseEnabled = false;
			
			//event cho img
			img.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			img.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
			img.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			img.removeEventListener(MouseEvent.CLICK, OnMouseClick);
			img.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			img.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			img.removeEventListener(MouseEvent.ROLL_OVER, OnMouseOver);
			img.removeEventListener(MouseEvent.ROLL_OUT, OnMouseOut);
			
			ClearEvent();
		 }
		 
		 public function ClearImage():void
		 {
			removeAllEvent();
			
			// clear helper
			if (HelperName != "")
			{
				HelperMgr.getInstance().ClearHelper(HelperName);
			}
			
			if (Parent != null && img != null && img.parent == Parent)
			{
				Parent.removeChild(img);
				img = null;
			}
			if (chatbox)
			{
				chatbox.Hide();
			}
			
		 }
		 
		 public function GetHeight():int
		 {
			return img.height;
		 }
		 
		 public function GetWidth():int
		 {
			 return img.width;
		 }
		 
		 ////////////////////////////Input////////////////////////////////////////////////		
		 /**
		 * Bắt sự kiện ấn bàn phím
		 * @param event thông tin về sự kiện
		 **/
		private function OnKeyDown(event:KeyboardEvent):void
		{
			GameInput.getInstance().OnKeyDownObject(event, this); 
		}
		 
		private function OnKeyUp(event:KeyboardEvent):void
		{
			GameInput.getInstance().OnKeyUpObject(event, this); 
		}
		 
		private function OnMouseMove(event:MouseEvent):void
		{
			GameInput.getInstance().onMouseMoveObject(event, this);
			if (img == null) return;
			dragTo(img.x, img.y);			
		}
	
		
		public virtual function OnMouseClick(event:MouseEvent):void
		{
			GameInput.getInstance().OnMouseClickObject(event, this);
		}
		
		public virtual function OnMouseOver(event:MouseEvent):void 
		{
			GameInput.getInstance().OnMouseOverObject(event, this);
		}
		
		public virtual function OnMouseOut(event:MouseEvent):void
		{
			GameInput.getInstance().OnMouseOutObject(event, this);
		}
		
		private function OnMouseDown(event:MouseEvent):void
		{
			GameInput.getInstance().OnMouseDownObject(event, this);

			if (Dragable)
			{
				if (event.currentTarget == img)
				{
					if (OnStartDrag())
					{
						ChangeLayer(Constant.ACTIVE_LAYER);
						OldDragX = img.x;
						OldDragY = img.y;
						OldDragScaleX = img.scaleX;
						OldDragScaleY = img.scaleY;
						//this.img.startDrag();
						IsDraging = true;
					}
				}
			}
		}
		 
		public function dragTo(x:int, y:int):void
		{
			if (IsDraging)
			{
				SetPos(x, y);
				OnDragOver(img.dropTarget);
			}
		}
		
		private function OnMouseUp(event:MouseEvent):void
		{
			GameInput.getInstance().OnMouseUpObject(event, this);			
			//finisDrag();			
		}
		
		public function finisDrag():void
		{
			if (Dragable)
			{
				ChangeLayer(Constant.OBJECT_LAYER);
				//this.img.stopDrag();
				IsDraging = false;
				if (!OnFinishDrag())
				{
					SetPos(OldDragX, OldDragY);
					img.scaleX = OldDragScaleX;
					img.scaleY = OldDragScaleY;
				}
			}
		}
		
		
		public override function Destructor():void
		{
			ClearImage();
			DesPos = null;
			SpeedVec = null;
			CurPos = null;
			OnDestructor();
		}
		
		public virtual function OnDestructor():void
		{
			
		}
		
		public virtual function OnStartDrag():Boolean
		{
			return true;
		}
		
		public virtual function OnFinishDrag():Boolean
		{
			return true;
		}
		
		public virtual function OnDragOver(obj:Object):void
		{
		}
		
		public virtual function convert2Bmp():void
		{		
			var mouseChild:Boolean = img.mouseChildren;
			var mouseEnable:Boolean = img.mouseEnabled;
			var OldIndexChild:int = Parent.getChildIndex(img);
			var scaleX:Number = img.scaleX;
			var scaleY:Number = img.scaleY;

			var region:Rectangle =  img.getBounds(img);
			var mat:Matrix = new Matrix(1,0,0,1, -region.x, -region.y);
			var bmpData:BitmapData = new BitmapData(region.width, region.height, true, 0);
			bmpData.draw(img, mat);
			var bmp:Bitmap = new Bitmap(bmpData);
			mat = new Matrix(1, 0, 0, 1, region.x, region.y);
			bmp.transform.matrix = mat;
			var x:Number = img.x;
			var y:Number = img.y;			
			
			
			ClearImage();
			img = new Sprite();
			img.addChild(bmp);
			SetPos(x, y);

			Parent.addChildAt(img, OldIndexChild);				
			img.mouseEnabled = mouseEnable;
			img.mouseChildren = mouseChild;
			img.scaleX = scaleX;
			img.scaleY = scaleY;
			if (Width != 0 && Height != 0)
			{
				img.width = Width;
				img.height = Height;
			}
			addAllEvent();
			//FitRect(BoundWidth, BoundHeight, BoundPos);
		}
		
	}
}