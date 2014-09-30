package Data 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ducnh
	 */
	public class BitmapMovie 
	{
		//public var bmpList:Array = null; // mảng các bitmapdata của các frame
		public var bmpList:Vector.<BitmapData> = null;
		public var bmpPos:Vector.<Rectangle> = null;
		public var bmpSize:Vector.<Rectangle> = null;
		public var bmpCenterPos:Vector.<Point> = null;
		
		public function BitmapMovie(image:MovieClip) 
		{
			getBitmap(image);
			//image = duplicate();
		}
		
		//public function duplicate():MovieClip
		//{
			//var movie:MovieClip = new MovieClip;
			// add cac frame vao
			//var i:int;
			//var child:MovieClip;
			//for (i = 0; i < 2; i++)
			//{
				//var bmp:Bitmap = new Bitmap (bmpList[0]["bmpData"]);
				//bmp.x = bmpList[0]["x"];
				//bmp.y = bmpList[0]["y"];
				//child = movie.getChildByName("c" + i) as MovieClip;
				//movie.addChild(bmp);
			//}
			//movie.addFrameScript(bmpList.length, function():void { movie.gotoAndPlay(1); } );
			//if (bmpList.length > 1)
			//{
				//movie.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				//movie.addEventListener(Event.RENDER, onRender);
			//}
			//movie.gotoAndPlay(1);
			//return movie;
		//}
		public function duplicate():MovieClip
		{
			var movie:MovieClip = new MovieClip;
			// add cac frame vao
			var i:int;
			//var child:MovieClip;
			//for (i = 0; i < 2; i++)
			{
				var bmp:Bitmap = new Bitmap (bmpList[0]);
				bmp.x = bmpPos[0].x;
				bmp.y = bmpPos[0].y;
				//bmp.scaleX = 0.4;
				//bmp.scaleY = 0.4;
				//child = movie.getChildByName("c" + i) as MovieClip;
				movie.addChild(bmp);
			}
			//movie.addFrameScript(bmpList.length, function():void { movie.gotoAndPlay(1); } );
			//if (bmpList.length > 1)
			//{
				//movie.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				//movie.addEventListener(Event.RENDER, onRender);
			//}
			//movie.gotoAndPlay(1);
			return movie;
		}
		
		//private function getBitmap(image:MovieClip):void
		//{
			//var movie:MovieClip = new MovieClip();
			//var i:int;
			//bmpList = [];
			// tao ra 1 list cac frame bitmap
			//var obj:Object;
			//for (i = 0; i < image.totalFrames; i++)
			//{
				//image.gotoAndStop(i);
				//var region:Rectangle =  image.getBounds(movie);
				//var mat:Matrix = new Matrix(1,0,0,1, -region.x, -region.y);
				//var bmpData:BitmapData = new BitmapData(image.width, image.height, true, 0x00000000);
				//bmpData.draw(image, mat);
				//obj = new Object();
				//obj["bmpData"] = bmpData;
				//obj["x"] = region.x;
				//obj["y"] = region.y;
				//bmpList.push(obj);
			//}
		//}
		private function getBitmap(image:MovieClip):void
		{
			var movie:MovieClip = new MovieClip();
			var i:int;
			bmpList = new Vector.<BitmapData>();
			bmpPos = new Vector.<Rectangle>();
			bmpCenterPos = new Vector.<Point>();
			bmpSize = new Vector.<Rectangle>();
			
			//bmpList.;
			//bmpPos  = [];
			// tao ra 1 list cac frame bitmap
			var obj:Object;
			
			// Tìm kích cỡ lớn nhất:
			var Size:Point = new Point();
			for (i = 0; i < image.totalFrames; i++)
			{
				image.gotoAndStop(i);
				Size.x = Math.ceil(Math.max(image.width, Size.x));
				Size.y = Math.ceil(Math.max(image.height, Size.y));
			}
			
			for (i = 0; i < image.totalFrames; i++)
			{
				image.gotoAndStop(i);
				var region:Rectangle =  image.getBounds(movie);
				region.x = Math.round(region.x);
				region.y = Math.round(region.y);
				var mat:Matrix = new Matrix(image.scaleX, 0, 0, image.scaleY, -region.x, -region.y);
				
				//matrix.translate(-mcRect.x + ((scaledClipWidth - mcRect.width) / 2),
                                     //-mcRect.y + ((scaledClipHeight - mcRect.height) / 2));
									 
				//trace( region.x+" "+ region.y+" "+region.width+" "+region.height);
				var bmpData:BitmapData = new BitmapData(Size.x, Size.y, true, 0x00000000);
				bmpData.lock();
				bmpData.draw(image, mat, null, null, null, true);
				
				bmpData.unlock();
				obj = new Object();
				obj["bmpData"] = bmpData;
				obj["bitmapPos"] = region;
				//obj["x"] = region.x;
				//obj["y"] = region.y;
				bmpList.push(bmpData);
				bmpPos.push(region);
				bmpSize.push(new Rectangle(0, 0, image.width, image.height));
				bmpCenterPos.push(new Point(image.width / 2, image.height / 2));
			}
		}
	}
		
}