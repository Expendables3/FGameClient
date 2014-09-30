package Event.EventIceCream 
{
	import Event.EventMgr;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MachineMakeCream extends BaseObject 
	{
		
		public function MachineMakeCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			this.ClassName = "MachineMakeCream";
		}
		
		public function Init():void 
		{
			SetPos(750, 500);
			(img as MovieClip).gotoAndStop(1);
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			MouseClick();
		}
		
		public function MouseClick():void 
		{
			if (GuiMgr.getInstance().GuiStore.IsVisible)	GuiMgr.getInstance().GuiStore.Hide();
			if(EventMgr.CheckEvent("IceCream") == EventMgr.CURRENT_IN_EVENT)
			{
				GuiMgr.getInstance().GuiMainEventIceCream.CheckShowGuiGetGift();
				if (!GuiMgr.getInstance().GuiGetGiftDaily.IsVisible && 
					!GuiMgr.getInstance().GuiIntroHelpEventIceCream.IsVisible)
				{
					GuiMgr.getInstance().GuiMainEventIceCream.Show(Constant.GUI_MIN_LAYER, 3);
				}
			}
			else
			{
				if (this != null)
				{
					var posStart:Point;
					var posEnd:Point;
					var txtFormat:TextFormat;
					var str:String;
					posStart = GameInput.getInstance().MousePos;
					posEnd = new Point(posStart.x, posStart.y - 100);
					txtFormat = new TextFormat(null, 14, 0xFF0000);
					txtFormat.align = "center";
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					str = "Đã hết thời gian diễn ra event ~,~";
					Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
					this.Destructor();
				}
			}
		}
		override public function OnMouseOver(event:MouseEvent):void 
		{
			(img as MovieClip).gotoAndStop(2);
			img.buttonMode = true;
			SetHighLight();
		}
		
		override public function OnMouseOut(event:MouseEvent):void 
		{
			(img as MovieClip).gotoAndStop(1);
			img.buttonMode = false;
			SetHighLight( -1);
		}
	}

}