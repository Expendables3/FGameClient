package GUI.component 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;	
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.filters.GlowFilter;
	import Logic.GameLogic;
	import Sound.SoundMgr;
	import com.greensock.*;
	/**
	 * sinh ra 1 cái nút trên GUI
	 * @author ducnh
	 */
	public class Button 
	{
		public var HelperName:String = "";
		public var img:SimpleButton = null;
		public var ButtonID:String;
		public var EventHandler:Container;
		public var TooltipText:String = null;
		public var text:TextField = null;
		private var UpState:DisplayObject = null;
		private var OverState:DisplayObject = null;
		public var enable:Boolean;
		public var ClassName:String;
		private var tooltip:TooltipFormat = null;		
		public function Button(btnID:String, res:SimpleButton, x:int, y:int)
		{
			img = res;
			img.addEventListener(MouseEvent.CLICK, OnButtonClick);
			img.addEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.addEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
			img.addEventListener(MouseEvent.MOUSE_MOVE, OnButtonMouseMove);
			img.x = x;
			img.y = y;
			ButtonID = btnID;
			UpState = img.upState;
			OverState = img.overState;
			enable = true;
			img.tabEnabled = false;
			ClassName = "Button";
		}
		
		// Currently served only in GetDailyGift gui, consider rewrite it for other uses.
		public function FlipX(ScaleX:Number, Time:Number, CenterX:Number, Delay:Number = 0, CallBack:Function = null):void
		{
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
		
		public function setTooltip(tip:TooltipFormat):void
		{
			tooltip = tip;
		}
		
		public function clearTooltip():void
		{
			tooltip = null;
		}
		
		public function setTooltipText(Txt:String):void
		{
			if(tooltip == null)
			{
				tooltip = new TooltipFormat();
			}
			tooltip.text = Txt;
		}
		
		public function SetDisable():void
		{
			//img.mouseEnabled = false;
			enable = false;
			
			var elements:Array =
			[0.43, 0.43, 0.43, 0, 0,
			0.43, 0.43, 0.43, 0, 0,
			0.43, 0.43, 0.43, 0, 0,
			0, 0, 0, 1, 0];

			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
			img.filters = [colorFilter];
			
		}
		
		public function SetEnable(IsEnable:Boolean = true):void
		{
			if (!IsEnable)
			{
				//img.mouseEnabled = false;
				enable = false;
			
				var elements:Array =
				[0.43, 0.43, 0.43, 0, 0,
				0.43, 0.43, 0.43, 0, 0,
				0.43, 0.43, 0.43, 0, 0,
				0, 0, 0, 1, 0];

				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				img.filters = [colorFilter];
			}
			else
			{
				enable = true;
				img.mouseEnabled = true;
				img.filters = null;
			}
		}
		
		public function RemoveAllEvent():void
		{
			img.removeEventListener(MouseEvent.CLICK, OnButtonClick);
			img.removeEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.removeEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
			img.removeEventListener(MouseEvent.MOUSE_MOVE, OnButtonMouseMove);
		}
		
		private function OnButtonClick(event:MouseEvent):void
		{
			if (enable)
			{
				var sound:Sound = SoundMgr.getInstance().getSound("Click") as Sound;
				if (sound != null)
				{
					try
					{
						sound.play();
					}
					catch (e:*)
					{
						trace("Lỗi play sound");
					}
				}
				if (EventHandler == null) return;
				var bt:Button = event.currentTarget as Button;
				if (event.target == img)
				{
					if(bt==null)
					{
						EventHandler.OnButtonClick(event, ButtonID);
					}
					else
					{
						EventHandler.OnButtonClick(event, bt.ButtonID);
					}
				}
			}
		}
		
		private function OnButtonMouseMove(event:MouseEvent):void
		{
			if (EventHandler == null) return;
			
			//if (TooltipText != null)
			//{
				//if (event.target == img)
				//{
					//Tooltip.getInstance().ShowNewToolTip(TooltipText, event.stageX, event.stageY);
				//}
			//}
			
		}
		
		private function OnButtonMouseOut(event:MouseEvent):void
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
			
			
			if (event.target == img)
			{
				EventHandler.OnButtonOut(event, ButtonID);
			}
		}
		
		
		private function OnButtonMouseOver(event:MouseEvent):void
		{
			if (EventHandler == null) return;
			if (event.target == img)
			{
				EventHandler.OnButtonMove(event, ButtonID);
			}
			
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().showNewToolTip(tooltip, img);
			}
		}
		
		/**
		 * Đăt vị trí cho đối tượng
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 */
		public function SetPos(x:int, y:int):void
		{
			img.x = x;
			img.y = y;
		}
		//h: tra ve vi tri Button
		public function GetPos(): Point
		{
			var point: Point = new Point();
			point.x = img.x;
			point.y = img.y;
			return point;
		}
		
		public function SetText(st:String):void
		{
			if ((img == null) || (img.parent == null))
			{
				//trace("Button::SetText() display object = null");
				return;
			}
	
			
			text = new TextField();
			text.text = st;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.align = TextFormatAlign.CENTER;
			text.setTextFormat(txtFormat);
			//text.border = true;
			
			text.width = img.width;
			text.height = text.textHeight + 7;
				
			text.y = img.y - text.textHeight/2;
			text.x = img.x - img.width / 2;
			text.mouseEnabled = false;
			//try{
				img.parent.addChild(text);
			//}catch (err:Error){
				//GameLogic.getInstance().CatchErr(err);
			//}
		}
		
		public function SetVisible(IsVisible:Boolean):void
		{
			if (img != null)
			{
				img.visible = IsVisible;
			}
		}
		
		public function SetHighLight(color:Number = 0x00FF00):void
		{
			if (color < 0)
			{
				img.filters = null;
				return;
			}
			
			var glow:GlowFilter = new GlowFilter(color, 1, 4, 4, 8);
			img.filters = [glow];
		}
		
		/**
		 * 
		 * @param	isFocus			cờ trạng thái, true là có focus, false là không focus
		 * @param	isHasImgFocus	Có ảnh khi focus không. Nếu có thì nút sẽ ẩn đi và ảnh focus sẽ được hiện lên.
		 * 							Ngược lại nút sẽ không ẩn đi mà chọn trạng thái down của nút làm trạng thái focus.
		 * 							Chú ý, ảnh focus phải được add ở cùng vị trí với nút và nằm dưới layer của nút để khi nút ẩn đi, ảnh sẽ hiện lên
		 */
		public function SetFocus(isFocus:Boolean, isHasImgFocus:Boolean = true):void
		{
			img.mouseEnabled = !isFocus;
			if (!isFocus)
			{
				img.upState = UpState;
				img.overState = OverState;
				img.visible = true;
				return;
			}
			
			img.upState = img.downState;
			img.overState = img.downState;
			if(isHasImgFocus)
				img.visible = false;
		}
	}

}