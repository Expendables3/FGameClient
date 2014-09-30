package GUI.FishWar 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import GUI.component.Image;
	
	/**
	 * Cánh cá
	 * @author longpt
	 */
	public class FishWings extends Image 
	{
		
		public function FishWings(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "")
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, true, SetInfo);
			(img as Sprite).mouseEnabled = false;
		}
		 
		protected override function onEnterFrame(e:Event):void 
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
				if (maxBmpFrame > 11)
				{
					curBmpFrame = 11; // Hard code vụ cánh vẫy
				}
				else
				{
					curBmpFrame = 1;
				}
			}
			testBitmap.bitmapData = BmpArray[curBmpFrame];
			testBitmap.x = BmpPos[curBmpFrame].x;
			testBitmap.y = BmpPos[curBmpFrame].y;
			
			img.mouseEnabled = false;
			img.mouseChildren = false;
		}
	}

}