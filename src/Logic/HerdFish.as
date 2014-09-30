package Logic 
{
	import adobe.utils.ProductManager;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author tuan
	 */
	public class HerdFish
	{
		public var FishPos:Array = [];
		public function HerdFish() 
		{
			
		}		
		
		public function GenerateHerdFish(boundFish:Rectangle):void
		{
			var pos:Point = new Point();
			var t:Number;
			var x:int, y:int;
			for (var i:int = 0; i < 10; i++ )
			{
				x = i * boundFish.width;
				t = (i * boundFish.height) / 2;
				for (var j:int = 0; j <= i; j ++ )
				{
					y = j * boundFish.height - t;
					pos = new Point(x, y);
					FishPos.push(pos);
				}				
			}
		}
		
		public function SetPosHerdFish(x:int, y:int):void
		{
			var p:Sprite = new Sprite();
			var dx:int = x ;
			var dy:int = y ;
			for (var i:int = 0; i < FishPos.length; i++ )
			{
				FishPos[i].x += dx;
				FishPos[i].y += dy;
				//p = new Sprite();
				//p.graphics.beginFill(0);
				//p.graphics.drawCircle(0, 0, 3);
				//p.graphics.endFill();				
				//LayerMgr.getInstance().GetLayer(Constant.TopLayer).addChild(p);
				//p.x = FishPos[i].x;
				//p.y = FishPos[i].y;
			}
		}		
	}
}