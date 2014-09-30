package GUI.component 
{
	import Data.ResMgr;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import Logic.Layer;
	import Logic.LayerMgr;
	/**
	 * lớp tooltip di chuột qua thì hiện
	 * @author ducnh
	 */
	public class ActiveTooltip
	{
		private static var instance:ActiveTooltip;
		private static const ACTIVE_TIP_WIDTH:int = 150;
		
		private var img:Sprite = null;
		private var arrow:Sprite = null;
		private var txt:TooltipFormat = null;
		private var CurObj:Object = null;
		private var IsShow:Boolean = false;
		private var CountDownShow:int = 0;
		private var CountDownHide:int = 0;
		private var Color:ColorTransform = new ColorTransform(0.9, 1.0, 0.6);
		
		public static function getInstance():ActiveTooltip
		{
			if(instance == null)
			{
				instance = new ActiveTooltip();
			}
				
			return instance;
		}
		
		public function ActiveTooltip() 
		{
			var Parent:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
			Parent.mouseChildren = false;
			Parent.mouseEnabled = false;
			
			arrow = ResMgr.getInstance().GetRes("Arrow") as Sprite;
			arrow.transform.colorTransform = Color;
			arrow.mouseChildren = false;
			arrow.mouseEnabled = false;
			
			img = ResMgr.getInstance().GetRes("ActiveTipFrame") as Sprite;
			img.transform.colorTransform = Color;
			img.mouseChildren = false;
			img.mouseEnabled = false;
			
			//var txtFormat:TextFormat = new TextFormat("Arial");
			//txt = new TextField();
			//txt.defaultTextFormat = txtFormat;
			//txt.mouseEnabled = false;
			//txt.wordWrap = true;
			//txt.width = ACTIVE_TIP_WIDTH;
			//txt.autoSize = TextFieldAutoSize.CENTER;

		}
		
		public function setCountDownHide(count: int):void
		{
			CountDownHide = count;
		}
		
		public function setCountShow(count: int):void
		{
			CountDownShow = count;
		}
		
		public function showNewToolTip(tip:TooltipFormat, obj:Object):void
		{
			clearToolTip();
			var Parent:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
			
			// Quangvh
			var left:int = -(obj.stage.stageWidth - Constant.STAGE_WIDTH)/2 + 10;
			var top:int = -(obj.stage.stageHeight - Constant.STAGE_HEIGHT) / 2 + 10;
			
			CountDownShow = 10;
			CountDownHide = 240;
			txt = tip;
			IsShow = true;
			CurObj = obj;
			
			// hiem tooltip ra
			Parent.addChild(img);
			Parent.addChild(txt);
			Parent.addChild(arrow);
			img.visible = false;
			txt.visible = false;
			arrow.visible = false;
	
			// cap nhat kich thuoc
			var Offset:int = 7;
			txt.width = txt.textWidth + 10;
			var w:int = txt.width + 2* Offset;
			var h:int = txt.textHeight + 2 * Offset;
			img.scaleX = w / 100;
			img.scaleY = h / 100;
			var r:Rectangle;// = img.getBounds(img.parent);
			
			
			// cap nhat vi tri
			var r1:Rectangle = obj.getBounds(obj.stage);
			img.x = r1.left + r1.width / 2 - img.width / 2 ;// arrow.width;
			img.y = r1.top - img.height - 10;
			
			// can chinh lai vi tri
			arrow.rotationZ = 0;
			r = img.getBounds(img.parent);
			var dx:int = 0;
			var dy:int = 0;
			var ArrowType:int = 0;
			// theo X
			//if (r.left <= 10)
			//{
				//img.x += 10 - r.left;
			//}
			// theo X
			if (r.left <= left)
			{
				img.x += left - r.left;
			}
			if (r.right >= Parent.stage.stageWidth-10)
			{
				img.x += -(r.right - Parent.stage.stageWidth + 10);
			}
			// theo Y
			if (r.top < 300)
			{
				if(r1.bottom >= 0)
				{
					img.y = r1.bottom + arrow.height/2;
				}
				else
				{
					img.y = r1.bottom - arrow.height/2;
				}
			}
			r = img.getBounds(img.parent);
			arrow.x = r1.left + r1.width/2;
			if (arrow.x < r.left + 30)
			{
				arrow.x = r.left + 30;
			}
			if (arrow.x > r.right - 30)
			{
				arrow.x = r.right - 30;
			}
			if (r.right < Parent.stage.stageWidth - 10)
			{
				if (img.y != r1.bottom + arrow.height/2)
				{
					arrow.y = r.bottom - 1;	
				}
				else
				{
					arrow.y = r.top +1;
					arrow.rotationZ = 180;
					arrow.x += 10;
				}
			}
			else
			{
				if (img.y != r1.bottom + arrow.height/2)
				{
					arrow.y = r.bottom - 1;
				}
				else
				{
					arrow.y = r.top+1;
					arrow.rotationZ = 180;
					arrow.x += 10;
				}
			}
			
			txt.x = r.left + Offset;
			txt.y = r.top + Offset / 2;
		}
		
		public function clearToolTip():void
		{
			if (IsShow)
			{
				var Parent:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
				Parent.removeChild(img);
				Parent.removeChild(txt);
				Parent.removeChild(arrow);
				CurObj = null;
				IsShow = false;
				CountDownHide = 0;
				CountDownShow = 0;
				txt = null;
			}
		}
		
		public function update():void
		{
			if ((CurObj != null) && (CurObj.parent != null))
			{
				if (CountDownShow > 0)
				{
					CountDownShow--;
					if (CountDownShow <= 0)
					{
						txt.visible = true;
						img.visible = true;
						arrow.visible = true;
						var Parent:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
					}
				}
				if (CountDownHide > 0)
				{
					CountDownHide--;
					if (CountDownHide <= 0)
					{
						clearToolTip();
					}
				}
			}
			else
			{
				clearToolTip();
			}
		}
	}

}