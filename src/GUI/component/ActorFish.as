package GUI.component 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * con cá nhảy samba trong gui viễn chinh
	 * @author HiepNM2
	 */
	public class ActorFish extends Container
	{
		//public function ActorFish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		public function ActorFish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ActorFish";
		}
		
		/**
		 * con cá nhảy qua 1 loạt vị trí
		 * @param	listPos : dãy các vị trí nhảy qua
		 */
		public function hop(listPos:Array, fHopComplete:Function = null):void 
		{
			if (listPos.length == 0)//neo đệ quy
			{
				if (fHopComplete != null)
				{
					fHopComplete();//hàm thực hiện sau khi cá nhảy xong
				}
				return;
			}
			var pD:Point = listPos.shift();
			var pM:Point = new Point();
			pM.x = (img.x + pD.x) / 2;
			pM.y = pD.y < img.y ? pD.y - 20 : img.y - 20;
			TweenMax.to(img, 0.08, { bezierThrough:[ { x:pM.x, y:pM.y}, { x:pD.x, y:pD.y} ],
						orientToBezier:false, ease:Expo.easeIn, onComplete:hop,
						onCompleteParams:[listPos, fHopComplete] } );
		}
		/**
		 * con cá trượt qua 1 loạt vị trí
		 * @param	listPos : dãy các vị trí trượt qua
		 */
		public function shift(listPos:Array, fShiftComplete:Function = null):void
		{
			if (listPos.length == 0)//neo đệ quy
			{
				if (fShiftComplete != null)
				{
					fShiftComplete();//hàm thực hiện sau khi cá trượt xong
				}
				return;
			}
			var pD:Point = listPos.shift();
			TweenMax.to(img, 0.08, { bezierThrough:[ { x:pD.x, y:pD.y} ],
						orientToBezier:false, ease:Expo.easeIn, onComplete:shift,
						onCompleteParams:[listPos, fShiftComplete] } );
		}
		
		public function move(listPos:Array, fMoveComp:Function = null):void
		{
			if (listPos.length == 0)
			{
				if (fMoveComp != null)
				{
					fMoveComp();
				}
				return;
			}
			var pD:Point = listPos.shift();
			var pM:Point = new Point();
			
			if (img.y == pD.y)
			{
				if (pD.x > img.x)
				{
					img.rotationY = 180;
				}
				else
				{
					img.rotationY = 0;
				}
				pM.x = (img.x + pD.x) / 2;
				pM.y = pD.y < img.y ? pD.y - 40 : img.y - 40;
				TweenMax.to(img, 0.08, { bezierThrough:[ { x:pM.x, y:pM.y}, { x:pD.x, y:pD.y} ],
						orientToBezier:false, ease:Expo.easeIn, onComplete:move,
						onCompleteParams:[listPos, fMoveComp] } );
			}
			else
			{
				
				TweenMax.to(img, 0.08, { bezierThrough:[ { x:pD.x, y:pD.y} ],
						orientToBezier:false, ease:Expo.easeIn, onComplete:move,
						onCompleteParams:[listPos, fMoveComp] } );
			}
		}
	}

}


















