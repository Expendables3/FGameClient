package GUI.component 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import Logic.Ultility;
	
	import Logic.GameLogic;
	import Data.ResMgr;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class ProgressBar extends Sprite
	{		
		public var img:Sprite;
		public var isCircle:Boolean;
		public var imgBg:Sprite;
		public var PrgID:String;
		public var EventHandler:Container;
		private var square:Sprite = null;
		public var percent:Number;
		private var tooltip:TooltipFormat = null;
		public var TooltipText:String = null;
		public var nextStatus:Number;
		
		public function ProgressBar(id:String, imgName:String, x:int, y:int, haveBg:Boolean = false, IsCircle:Boolean = false) 
		{
			if (haveBg)
			{
				var imgName_bg:String = imgName + "_bg";
			}
			//try {					
				PrgID = id;
				this.x = x;
				this.y = y;
				isCircle = IsCircle;
				if (haveBg)
				{
					imgBg = ResMgr.getInstance().GetRes(imgName_bg) as Sprite
					imgBg.x = 0 - 1;
					imgBg.y = 0 - 1;		
					this.addChild(imgBg);
				}
				
				img = ResMgr.getInstance().GetRes(imgName) as Sprite;
				img.x = 0;
				img.y = 0;
				this.addChild(img);
				
				this.addEventListener(MouseEvent.CLICK, OnClick);
				this.addEventListener(MouseEvent.ROLL_OVER, OnMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT, OnMouseOut);
				this.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
				
				this.percent = -1;
			//}catch (err:Error){
				//GameLogic.getInstance().CatchErr(err);
			//}
		}
		
		public function setTooltip(tip:TooltipFormat):void
		{
			tooltip = tip;
		}
		
		public function setTooltipText(Txt:String):void
		{
			if(tooltip == null)
			{
				tooltip = new TooltipFormat();
			}
			tooltip.text = Txt;
		}
		
		public function SetBackGround(name:String, scaleX:Number = 1, scaleY:Number = 1 ):void
		{
			imgBg = ResMgr.getInstance().GetRes(name) as Sprite
			imgBg.x = img.x - 1;			
			imgBg.y = img.y - 1;
			imgBg.scaleX = scaleX;
			imgBg.scaleY = scaleY;
			this.addChildAt(imgBg, 0);
		}
		
		public function SetPosBackGround(x:int, y:int):void
		{
			imgBg.x = x;
			imgBg.y = y;
		}
		
		public function GetStatus():Number
		{
			return percent;
		}
		
		/**
		 * Hàm cập nhật trạng thái progress bar tăng giảm dần
		 * @param	newStatus
		 * @param	time
		 * @param	IsScaleX
		 */
		public function setStatusProgress(newStatus:Number, time:Number, IsScaleX:Boolean = true, IsRandomStart:Boolean = false):void
		{
			if (percent < 0)	percent = 0;
			if (IsRandomStart)	percent = Ultility.RandomNumber(0, 100) / 100;
			var o:Object = new Object();
			o["end"] = newStatus;
			o["begin"] = percent;
			o["step"] = (newStatus - percent) / time / img.stage.frameRate;
			o["scaleX"] = true;
			o["pb"] = this;
			GameLogic.getInstance().ProgressList.push(o);
		}
		
		public function setStatus(percent:Number, IsScaleX:Boolean = true):void
		{
			if (percent < 0 || this.img == null)
			{
				return;
			}
			if (percent > 1)
			{
				percent = 1;
			}
			if (this.percent == percent)
			{
				return;
			}
			this.percent = percent;			
			
			if (square != null)
			{
				square.parent.removeChild(square);
				square = null;
			}
			
			square = new Sprite();
			square.graphics.beginFill(0xFF0000);	
			if (isCircle)
			{
				var x1:Number;
				var y1:Number;
				square.graphics.moveTo(img.width / 2, img.height / 2);
				
				square.graphics.lineTo(img.width / 2, -img.height / 2);
				if (percent <= 0.25)
				{
					x1 = img.width / 2 + Math.sin(percent * 2 * Math.PI) * img.width;
					y1 = img.height / 2 - Math.cos(percent * 2 * Math.PI) * img.height;
					square.graphics.lineTo(x1, -img.height / 2);
					square.graphics.lineTo(x1, y1);
					square.graphics.lineTo(img.width / 2, img.height / 2);
				}
				else 
				{
					square.graphics.lineTo(3 * img.width / 2, -img.height / 2);
					square.graphics.lineTo(3 * img.width / 2, img.height / 2);
					if(percent <= 0.5)
					{
						x1 = img.width / 2 + Math.cos((percent - 0.25) * 2 * Math.PI) * img.width;
						y1 = img.height / 2 + Math.sin((percent - 0.25) * 2 * Math.PI) * img.height;
						square.graphics.lineTo(x1, y1);
						square.graphics.lineTo(img.width / 2, img.height / 2);
					}
					else 
					{
						square.graphics.lineTo(3 * img.width / 2, 3 * img.height / 2);
						square.graphics.lineTo(img.width / 2, 3 * img.height / 2);
						if(percent <= 0.75)
						{
							x1 = img.width / 2 - Math.sin((percent - 0.5) * 2 * Math.PI) * img.width;
							y1 = img.height / 2 + Math.cos((percent - 0.5) * 2 * Math.PI) * img.height;
							square.graphics.lineTo(x1, y1);
							square.graphics.lineTo(img.width / 2, img.height / 2);
						}
						else 
						{
							square.graphics.lineTo(-img.width/2, 3 * img.height / 2);
							square.graphics.lineTo(-img.width/2, img.height / 2);
							if (percent <= 1)
							{								
								x1 = img.width / 2 - Math.cos((percent - 0.75) * 2 * Math.PI) * img.width;
								y1 = img.height / 2 - Math.sin((percent - 0.75) * 2 * Math.PI) * img.height;
								square.graphics.lineTo(x1, y1);
								square.graphics.lineTo(img.width / 2, img.height / 2);
							}
							else 
							{
								square.graphics.lineTo(-img.width / 2, -img.height / 2);
								square.graphics.lineTo(img.width / 2, -img.height / 2);
								square.graphics.lineTo(img.width / 2, img.height / 2);
							}
						}
					}
				}
			}
			else 
			{
				square.graphics.drawRect(0, 0, img.width, img.height);
				if (IsScaleX)
				{
					square.scaleX = percent;
				}
				else
				{				
					square.scaleY = percent;
					square.y += (img.height - square.height);
				}
				img.scaleY = img.scaleX = 1
			}
			square.alpha = 0;
			img.addChild(square);
			img.mask = square;
		}
		
		public function RemoveAllEvent():void
		{
			this.removeEventListener(MouseEvent.CLICK, OnClick);
			this.removeEventListener(MouseEvent.ROLL_OVER, OnMouseOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, OnMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
		}
		
		private function OnClick(event:MouseEvent):void
		{
			
		}
		
		private function OnMouseOver(event:MouseEvent):void
		{
			if (EventHandler == null) return;
			
			//if (TooltipText != null)
			//{				
				//Tooltip.getInstance().ShowNewToolTip(TooltipText, event.stageX, event.stageY+10);
			//}
			
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().showNewToolTip(tooltip, this);				
			}
		}
		
		private function OnMouseOut(event:MouseEvent):void
		{
			if (EventHandler == null) return;
			
			//if (TooltipText != null)
			//{
				//Tooltip.getInstance().ClearTooltip();
			//}
			
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().clearToolTip();
			}
		}
		
		
		private function OnMouseMove(event:MouseEvent):void
		{
			
		}
		
		public function setVisible(visible:Boolean):void
		{
			img.visible = visible;
			if (imgBg)
				imgBg.visible = visible;
		}
	}

}