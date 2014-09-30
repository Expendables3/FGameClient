package GUI.component 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import Data.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import GUI.FishWorld.Boss;
	import GUI.FishWorld.BossMgr;
	import GUI.GuiMgr;
	import GUI.GUIReceiveGift;
	import Logic.FishSoldier;
	import Logic.FishSpartan;
	import Logic.GameLogic;
	import Logic.Ultility;
	import com.greensock.*;
	/**
	 * ...
	 * @author ducnh
	 */
	public class Image extends EventDispatcher
	{
		public static const ALIGN_LEFT_TOP:String = "LeftTop";
		public static const ALIGN_LEFT_CENTER:String = "LeftCenter";
		public static const ALIGN_LEFT_BOTTOM:String = "LeftBottom";
		public static const ALIGN_CENTER_TOP:String = "CenterTop";
		public static const ALIGN_CENTER_CENTER:String = "CenterCenter";
		public static const ALIGN_CENTER_BOTTOM:String = "CenterBottom";
		public static const ALIGN_RIGHT_TOP:String = "RightTop";
		public static const ALIGN_RIGHT_CENTER:String = "RightCenter";
		public static const ALIGN_RIGHT_BOTTOM:String = "RightBottom";
		
		
		/**Tên class của đối tượng*/
		public var ClassName:String;
		public var HelperName:String = "";
		public var ImgAlign:String = ALIGN_LEFT_TOP;
		private var IsCenter:Boolean = false;
		public var img:Sprite;
		public var ImgName:String = "";
		public var Parent:Object = null;
		public var CurPos:Point = new Point();
		private var imgLinkAge:Boolean = true;
		private var StopFrame:int = - 1;
		protected var Width:int = 0;
		protected var Height:int = 0;
		private var BoundWidth:int = 0;
		private var BoundHeight:int = 0;
		private var BoundPos:Point = null;
		public var setImgInfo:Function = null;
		public var toBmp:Boolean = false;
		protected var maxBmpFrame:int;
		protected var curBmpFrame:int;
		public var BmpArray:Vector.<BitmapData>;
		public var BmpPos:Vector.<Rectangle>;
		public var ImageId:String;

		public function Image(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "")
		{
			if (parent == null)
			{
				return;
			}
			this.ImageId = ImageId;
			ClassName = "Image";
			Parent = parent;
			ImgAlign = imgAlign;
			CurPos.x = x;
			CurPos.y = y;
			imgLinkAge = isLinkAge;
			setImgInfo = SetInfo;
			toBmp = toBitmap;
			if (imgName != "")
			{
				LoadRes(imgName, isLinkAge);
			}	
			if (this.img)
			{
				this.img.tabChildren = false;
			}
		}
		
		// Currently served only in GetDailyGift gui, consider rewrite it for other uses.
		public function FlipX(ScaleX:Number, Time:Number, CenterX:Number, Delay:Number = 0, CallBack:Function = null):void
		{
			if (img == null)
			{
				return;
			}
			if (ScaleX == 0)
				img.scaleX = 1;
			else if (ScaleX == 1)
				img.scaleX = 0;
				
			if (CallBack != null)
			{
				TweenLite.to(img, Time, { x:(img.x + CenterX), delay:Delay, scaleX:ScaleX , onComplete : CallBack } );
			}
			else
			{
				TweenLite.to(img, Time, { x:(img.x + CenterX), delay:Delay, scaleX:ScaleX} );
			}	
		}
		
		public function LoadRes(imgName:String, isLinkAge:Boolean = true):void
		{
			if (CurPos == null)
			{
				CurPos = new Point();
			}
			if (img != null)
			{
				if (Parent != null && img.parent == Parent)
				{
					Parent.removeChild(img);
				}
			}
			img = null;
			ImgName = imgName;
			if (imgName != "")
			{
				var eventName:String;
				if (isLinkAge)
				{
					eventName = ResMgr.getInstance().FindUrl(ImgName);
				}
				else
				{
					eventName = ImgName;
				}	
				ResMgr.getInstance().addEventListener(eventName, reLoadRes);
				ResMgr.getInstance().addEventListener("err" + eventName, OnLoadResErr);
				var tg:Sprite = ResMgr.getInstance().GetRes(imgName, isLinkAge, toBmp) as Sprite;
				if (tg != null)//,. && (imgName.search("Boss") >= 0 && (tg is MovieClip)))
				{
					img = tg;
					if (toBmp)
					{
						BmpArray = ResMgr.getInstance().GetBmpArray(imgName);
						BmpPos = ResMgr.getInstance().GetBmpPos(imgName);
					}
					
					OnLoadResComplete();
					if (this is FishSoldier)
					{
						//trace("OnLoadResComplete o LoadRes");
					}
				}
				else
				{
					// Test load động - longpt
					if (this is BaseGUI)
					{
						(this as BaseGUI).IsVisible = false;
						GuiMgr.getInstance().GuiWaitingContent.Init((this as BaseGUI).ClassName);
					}
				}
			}
			else
			{
				img = new Sprite();
			}
			
			if (img == null)
			{
				img = new Sprite();
			}
			else
			{
				if (toBmp)
				{
					maxBmpFrame = BmpArray.length;
					//trace("frame " + (img as MovieClip).totalFrames);
					
					
					var test:MovieClip = img as MovieClip;
					//var testBitmap:Bitmap = test.getChildAt(0);
					//testBitmap.ca
					//if ((img as MovieClip).totalFrames == 1)
					//test.addFrameScript(1, function ():void { trace("a"); } );
					
					img.addEventListener(Event.ENTER_FRAME, onEnterFrame);
					curBmpFrame = 0;
					test.gotoAndPlay(0);
				}
			}
			Parent.addChild(img);
			
			SetAlign(ImgAlign);		
			OnLoadRes();
			if (setImgInfo != null && !GuiMgr.getInstance().GuiWaitingContent.IsVisible)
			{
				setImgInfo();
				//setImgInfo = null;
			}
			if(img)
			{
				img.cacheAsBitmap = true;
			}
		}
		
		protected function onEnterFrame(e:Event):void 
		{
			if (img == null)
			{
				return;
			}
			
			if (maxBmpFrame == 1)
				return;
				
			var test:MovieClip = img as MovieClip;
			var testBitmap:Bitmap = test.getChildAt(0) as Bitmap;
			if (testBitmap == null)
			{
				return;
			}
			
			curBmpFrame++;
			if (curBmpFrame >= maxBmpFrame)
			{
				curBmpFrame = 0;
			}

			testBitmap.bitmapData = BmpArray[curBmpFrame];
			testBitmap.x = BmpPos[curBmpFrame].x;
			testBitmap.y = BmpPos[curBmpFrame].y;
		}

		public function SetSize(width:int, height:int):void
		{
			Width = width;
			Height = height;
			img.width = width;
			img.height = height;
		}
		
		public function FitRect(width:int, height:int, pos:Point = null):void
		{
			if (img == null)
			{
				//trace("FitRect: img = null");
				return;
			}
			
			if (width <= 0 || height <= 0)
			{
				return;
			}
			
			BoundWidth = width;
			BoundHeight = height;
			BoundPos = pos;
			
			var imgx:Sprite = new Sprite();
			imgx.graphics.beginFill(0xFFCC00);
			imgx.graphics.drawRect(0, 0, width, height);
			imgx.graphics.endFill();
			if (pos != null)
			{
				imgx.x = pos.x;
				imgx.y = pos.y;
			}
			//img.parent.addChildAt(imgx, 0);
			var tempScaleX:Number = img.scaleX;
			var tempScaleY:Number = img.scaleY;
			
			var scale:Number = 1;
			if (img.width > width)
			{
				scale = width / img.width;
			}
			img.scaleX = img.scaleY = scale;
			
			if (img.height > height)
			{			
				scale  *= (height / img.height);
			}
			img.scaleX = img.scaleY = scale;
			
			img.scaleX *= tempScaleX;
			img.scaleY *= tempScaleY;
			
			if (BoundPos != null)
			{
				var bound:Rectangle = img.getBounds(img.parent);
				var dx:int = BoundPos.x - bound.left;
				var dy:int = BoundPos.y - bound.top;
				img.x += dx;
				img.x += (width - bound.width) / 2;
				img.y += dy;
				img.y += (height - bound.height) / 2;
			}
		}
	
		
		public function GoToAndStop(frame:int):void
		{
			StopFrame = frame;
			var m:MovieClip = img as MovieClip;
			if (m != null)
			{
				m.gotoAndStop(frame);
			}
		}
		
		public function GoToAndPlay(frame:int):void
		{
			StopFrame = -1;
			var m:MovieClip = img as MovieClip;
			if (m != null)
			{
				m.gotoAndPlay(frame);
			}
		}
		
		public function ClearEvent():void
		{
			var eventName:String;
			if (imgLinkAge)
			{
				eventName = ResMgr.getInstance().FindUrl(ImgName);
			}
			else
			{
				eventName = ImgName;
			}
			ResMgr.getInstance().removeEventListener(eventName, reLoadRes);
			ResMgr.getInstance().removeEventListener("err" + eventName, OnLoadResErr);
		}
		
		private function reLoadRes(e:Event):void
		{	
			var tmpScaleX:Number = 1;
			var scaleY:Number = 1;
			var mouseChild:Boolean = true;
			var mouseEnable:Boolean = true;
			if (img != null)	
			{
				tmpScaleX = img.scaleX;
				scaleY = img.scaleY;
				mouseChild = img.mouseChildren;
				mouseEnable = img.mouseEnabled;
			}
			
			OnBeforeReloadRes();
			//var OldIndexChild:int = Parent.getChildIndex(img);
			var OldIndexChild:int = 0;
			if (img != null && img.parent != null) 
			{
				OldIndexChild = img.parent.getChildIndex(img);
				//Parent.removeChild(img);
				img.parent.removeChild(img);
			}
			else if(img == null)
			{
				OldIndexChild = 1;
			}
			
			img = null;
			var tg:Sprite = ResMgr.getInstance().GetRes(ImgName, imgLinkAge, toBmp) as Sprite;
			if (tg != null)
			{
				img = tg;
				if (toBmp)
				{
					BmpArray = ResMgr.getInstance().GetBmpArray(ImgName);
					BmpPos = ResMgr.getInstance().GetBmpPos(ImgName);
				}				
			}
			
			if (img == null)
			{
				//trace("error at BaseObject:reLoadRes");
			}
			else
			{
				SetAlign(ImgAlign);
				//try {
					Parent.addChildAt(img, OldIndexChild);				
					img.scaleX = tmpScaleX;
					img.scaleY = scaleY;
					img.mouseEnabled = mouseEnable;
					img.mouseChildren = mouseChild;
					if (Width != 0 && Height != 0)
					{
						img.width = Width;
						img.height = Height;
					}
					
					FitRect(BoundWidth, BoundHeight, BoundPos);
					
					if (StopFrame >= 0)
					{
						var m:MovieClip = img as MovieClip;
						m.gotoAndStop(StopFrame);
					}
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}				
		
				if (toBmp)
				{
					maxBmpFrame = BmpArray.length;
					//trace("frame " + (img as MovieClip).totalFrames);
					
					
					var test:MovieClip = img as MovieClip;
					//var testBitmap:Bitmap = test.getChildAt(0);
					//testBitmap.ca
					//if ((img as MovieClip).totalFrames == 1)
					//test.addFrameScript(1, function ():void { trace("a"); } );
					
					img.addEventListener(Event.ENTER_FRAME, onEnterFrame);
					curBmpFrame = 0;
					test.gotoAndPlay(0);
				}
				
				OnReloadRes();
				OnLoadResComplete();
				if (this is FishSoldier)
				{
					//trace("OnLoadResComplete o ReloadRes");
				}
				if (setImgInfo != null)
				{
					setImgInfo();
					//setImgInfo = null;
				}
				
			}
			try
			{
				img.cacheAsBitmap = true;
			}
			catch (e:Error)
			{
				trace("Cant cacheAsBitmat ", ImgName);
				//throw new Error("imgName: " + ImgName);
			}
			ClearEvent();
			
		}
		
		public function SetScaleX(scale:Number):void
		{
			if (img != null)
			{
				img.scaleX = scale;
			}
		}
		
		public function SetScaleY(scale:Number):void
		{
			if (img != null)
			{
				img.scaleY = scale;
			}
		}
		
		public function SetScaleXY(scale:Number):void
		{
			if (img != null)
			{
				img.scaleX = scale;
				img.scaleY = scale;
			}
		}
		
		public virtual function OnLoadResComplete():void
		{
		
		}
		
		public virtual function OnLoadRes():void
		{
		
		}
		
		public virtual function OnBeforeReloadRes():void
		{
		
		}
		
		public virtual function OnReloadRes():void
		{
			
			
			//var c:ColorTransform;
			//c = img.transform.colorTransform;
			//
			//c = new ColorTransform();
			//c.color = 0xFF0000;
			//ChangeColor(c, "Fin");
			//c = new ColorTransform(0.0, 1.0, 1.0, 1);
			//ChangeColor(c, "Eye");
			//c = new ColorTransform(1.0, 1.0, 0.0, 1, 0, 0, 0);
			//ChangeColor(c, "Body");
		}
		
		public virtual function OnLoadResErr(e:Event):void
		{
			trace("ImgName Fail:", ImgName);
			if (img == null)
			{
				img = new Sprite();
			}
			
			if (Width <= 1)
			{
				Width = 30;
			}
			if (Height <= 1)
			{
				Height = 30;
			}
			
			img.graphics.clear();
			// @quangvh
			// Xử lý khi không load được hình ảnh nếu cần thiết
			if(ImgName.search("Boss0") >= 0)
			{
				(BossMgr.getInstance().BossArr[0] as Boss).isLoadContentSuccess = false;
				(BossMgr.getInstance().BossArr[0] as Boss).LoadRes("BossDefault");
			}
			else if (ImgName.search("Boss1") >= 0)
			{
				GameLogic.getInstance().user.bossMetal.isLoadContentok = false;
				GameLogic.getInstance().user.bossMetal.LoadRes("BossDefault");
			}
			else if (ImgName.search("Boss2") >= 0) 
			{
				GameLogic.getInstance().user.bossIce.isLoadContentok = false;
				GameLogic.getInstance().user.bossIce.LoadRes("BossDefault");
			}
			else
			{
				img.graphics.beginFill(0x65ffff);
				img.graphics.drawRect(0, 0, Width, Height);
				img.graphics.endFill();
				img.width = Width;
				img.height = Height;
				SetAlign(ImgAlign);
				ClearEvent();
			}
		}
		
		public function SetAlign(imgAlign:String):void
		{
			if (img == null || CurPos == null)
			{
				//trace("Error at SetAlign: img = null" );
				return;
			}
			
			var x:Number = CurPos.x;
			var y:Number = CurPos.y;
			var kq:Point = new Point();
			var w:int = img.width;
			var h:int = img.height;
			ImgAlign = imgAlign;
			
			switch(ImgAlign)
			{
				case ALIGN_LEFT_TOP:
					kq.x = x;
					kq.y = y;
					break;
				case ALIGN_LEFT_CENTER:
					kq.x = x;
					kq.y = y - h / 2;
					break;
				case ALIGN_LEFT_BOTTOM:
					kq.x = x;
					kq.y = y - h;
					break;
				case ALIGN_CENTER_TOP:
					kq.x = x - w / 2;
					kq.y = y;
					break;
				case ALIGN_CENTER_CENTER:
					kq.x = x - w / 2;
					kq.y = y - h / 2;
					break;
				case ALIGN_CENTER_BOTTOM:
					kq.x = x - w / 2;
					kq.y = y - h;
					break;
				case ALIGN_RIGHT_TOP:
					kq.x = x - w;
					kq.y = y;
					break;
				case ALIGN_RIGHT_CENTER:
					kq.x = x - w;
					kq.y = y - h / 2;
					break;
				case ALIGN_RIGHT_BOTTOM:
					kq.x = x - w;
					kq.y = y - h;
					break;
				default:
					break;
			}
			
			img.x = kq.x;
			img.y = kq.y;
			CurPos.x = x;
			CurPos.y = y;
		}
		
		
		public function SetPos(x:Number, y:Number):void	
		{
			if (CurPos == null)	CurPos = new Point();
			CurPos.x = x;
			CurPos.y = y;
			SetAlign(ImgAlign);
		}
		
		public function IncrePosY(y:int):void
		{
			CurPos.y += y;
			SetAlign(ImgAlign);
		}
		
		public function SetPosY(y:int):void
		{
			CurPos.y = y;
			SetAlign(ImgAlign);
		}
		
		
		public virtual function Destructor():void
		{
			ClearEvent();
			img = null;
			CurPos = null;
		}
		
		// test thu vu doi mau
		public function ChangeColor(Color:ColorTransform, Key:String):void
		{
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(img, Key + i);
			while (child != null)
			{
				child.transform.colorTransform = Color;
				i++;
				child = Ultility.findChild(img, Key + i);
			}
		}
		
		public function get currentFrame():int
		{
			var m:MovieClip = (MovieClip)(img);
			if (m != null)
			{
				return m.currentFrame;
			}
			return 0;
		}
		
		public function get totalFrames():int
		{
			var m:MovieClip = (MovieClip)(img);
			if (m != null)
			{
				return m.totalFrames;
			}
			return 0;
		}
		
	}

}