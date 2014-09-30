package Event.Factory.FactoryLogic 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.Image;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.MotionObject;
	import Logic.Ultility;
	/**
	 * Các hàm tiện ích của event
	 * @author HiepNM2
	 */
	public class EventUtils 
	{
		
		public function EventUtils() 
		{
			
		}
		/**
		 * 
		 * @param	type
		 * @param	iLayer
		 * @param	imageName
		 * @param	xsrc
		 * @param	ysrc
		 * @param	ydestFall
		 * @param	xdestFly
		 * @param	ydestFly
		 * @param	finishFallFly 		hàm sau khi fly xong
		 * @param	numParam			số lượng (là param của hàm)
		 * @param	indexFunction		chỉ số hàm (dùng để xác định khi fallfly trong vòng for)
		 */
		static public function effFallFly(type:String, iLayer:int, imageName:String, xsrc:int, ysrc:int, ydestFall:int, xdestFly:int, ydestFly:int, finishFallFly:Function = null, numParam:int = 0, indexFunction:int = 1,data:Object=null):void
		{
			var motion:MotionObject = MotionObject.createObject(type, iLayer, imageName, xsrc, ysrc, 0, data);
			//motion.OnLoadResComplete = function():void { };
			EffectMgr.getInstance().motionArr.push(motion);
			motion.fall(ydestFall, 4, 1);
			motion.finishMotion = function():void { complete(motion.MotionState) };
			function complete(motionState:int):void
			{
				if (motion.img == null) return;
				switch(motionState)
				{
					case MotionObject.MOTION_FALL:
						//Bay lượn
						var pos:Point = layerToScreen(motion.CurPos.x, motion.CurPos.y, iLayer);
						var dir:int = pos.x < 300 ? 1 : -1;
						pos =layerToScreen(xdestFly, ydestFly, iLayer);
						motion.curve(pos.x, pos.y, dir, 0, 8);
						motion.desPosOnStage = new Point(xdestFly, ydestFly);
						break;
					case MotionObject.MOTION_CURVE:
						motion.roomOut(0.2, 1.7, -0.04);
						break;
					case MotionObject.MOTION_ROOM_OUT:
						motion.removeSelf();
						EffectMgr.getInstance().motionArr.splice(EffectMgr.getInstance().motionArr.indexOf(motion), 1);		
						if (finishFallFly != null)
						{
							finishFallFly(numParam, indexFunction);
						}
						break;
				}
			}
		}
		
		static public function layerToScreen(x:int, y:int, iLayer:int):Point
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			var pos:Point;				
			pos = new Point(x, y);
			pos = layer.localToGlobal(pos);
			return pos;
		}
		
		/**
		 * 
		 * @param	pSrc : điểm mút (tâm xoay)
		 * @param	pStart : điểm bắt đầu
		 * @param	dAlpha : góc xoay (đơn vị radian)
		 * @return tọa độ điểm xoay đến
		 */
		static public function rotateVector(pSrc:Point, pStart:Point, dAlpha:Number):Point
		{
			var vectorStart:Point = pStart.subtract(pSrc);
			var alphaStart:Number;						//góc tạo bởi vectorStart và trục Ox
			alphaStart = Math.atan2(vectorStart.y, vectorStart.x);
			var alpha:Number = alphaStart + dAlpha;		//góc tạo bởi vectorDir và trục Ox
			var vectorDir:Point = new Point(Math.cos(alpha), Math.sin(alpha));//vector chỉ phương của vector đích
			vectorDir.normalize(vectorStart.length);
			return pSrc.add(vectorDir);
		}
		
		/**
		 * lấy góc hợp bởi 2 vector chung 1 gốc
		 * @param	pSrc : gốc
		 * @param	pStart : mút 1
		 * @param	pDes : mút 2
		 * @return góc (radian)
		 */
		static public function calculateAlpha(pSrc:Point, pStart:Point, pDes:Point):Number
		{
			var vectorStart:Point = pStart.subtract(pSrc);
			var alpha1:Number = Math.atan2(vectorStart.y, vectorStart.x);
			var vectorDes:Point = pDes.subtract(pSrc);
			var alpha2:Number = Math.atan2(vectorDes.y, vectorDes.x);
			return (alpha2 - alpha1);
		}
		
		public static function effText(parent:Sprite, img1:Sprite, dx1:int, dy1:int, dx2:int,dy2:int,color:Object = 0xffff00, str:String = "",OutLine:Number=1, OutLineColor:int=0x000000, speed:Number=1, FadeSpeed:Number=-0.05, isEmbedFont:Boolean=false):void
		{
			var posStart:Point = new Point(img1.x + dx1, img1.y + dy1);
			posStart  = parent.localToGlobal(posStart);
			var posEnd:Point = new Point(img1.x + dx2, img1.y + dy2);
			posEnd = parent.localToGlobal(posEnd);
			var fm:TextFormat = new TextFormat("Arial", 16,color,true);
			fm.align = "center";
			Ultility.ShowEffText(str, null, posStart, posEnd, fm,OutLine,OutLineColor,speed,FadeSpeed,isEmbedFont);
		}
		public static function checkInShocksNoel():Boolean
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			if (!event["KeepLogin"]) return false;//không có event
			var beginTime:Number = event["KeepLogin"].BeginTime;
			var endTime:Number = event["KeepLogin"].ExpireTime - 100;//cho hết trước 1 ngày
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime >= beginTime && curTime <= endTime)
			{
				return true;
			}
			return false;
		}
		/*********************************************** các hàm xử lý cây object ***********************************/
		/**
		 * batch a item to tree
		 * @param	list : list of items
		 * @param	num : num of item
		 * @param	... args : properties of item -> string
		 */
		public static function batchToTree(list:Object, num:int, ... args):void
		{
			var index:String;
			var temp:Object;
			if (list == null)
			{
				list = new Object();
			}
			for (var i:int = 0; i < args.length - 1; i++)
			{
				index = args[i];
				temp = list[index];
				if (temp == null)
				{
					temp = new Object();
				}
			}
			index = args[i];
			temp = list[index];
			if (temp == null)
			{
				temp = 0;
			}
			temp += num;
		}
		
		/**
		 * thuật toán duyệt cây object và xử lý vết lưu lại từ gốc -> lá
		 * @param	tree : cay can duyet
		 * @param	marks : vet luu lai tu goc -> la
		 * @param	processMarks : ham xu ly vet
		 */
		static public function exploreTree(tree:Object, marks:Array, processMarks:Function):void
		{
			for (var key:String in tree)
			{
				var value:Object = tree[key];
				marks.push(key);
				if (value is int)//nếu là lá
				{
					processMarks(marks, value);//xử lý vết từ gốc -> lá
				}
				else//nếu là cây con -> duyệt tiếp cây con
				{
					exploreTree(value, marks, processMarks);
				}
				marks.pop();
			}
		}
		/**
		 * hủy cây
		 * @param	tree
		 */
		static public function destructTree(tree:Object):void 
		{
			for (var key:String in tree)
			{
				var value:Object = tree[key];
				destructTree(value);
				delete(tree[key]);
			}
		}
		
		static public function countObjElement(obj:Object):int
		{
			var ret:int = 0;
			for (var i:String in obj)
			{
				ret++;
			}
			return ret;
		}
		static public function getArrayFromObjectElement(obj:Object):Array
		{
			var list:Array = [];
			for (var i:String in obj)
			{
				list.push(int(i));
			}
			return list;
		}
		static public function getMaxElementFormObject(obj:Object):Number
		{
			var max:Number = int.MIN_VALUE;
			for (var i:String in obj)
			{
				if (max < Number(i))
				{
					max = Number(i);
				}
			}
			return max;
		}
	}

}
















