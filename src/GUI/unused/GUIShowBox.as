package GUI.unused 
{
	import flash.display.FrameLabel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import Logic.GameLogic;
	import Logic.GameState;
	/**
	 * ...
	 * @author Hien
	 */
	public class GUIShowBox extends BaseGUI
	{
		public static const MSGBOX_CANCEL:String = "1";
		
		public static const MSGBOX_OK:String = "0";
		
		private var Msg:String = "";
		private var IsOK:Boolean = true;
		private var IsCancel:Boolean = true;
		public var X: int;
		public var Y: int;
		public function GUIShowBox(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIShowBox";
		}
		
		public function ShowOK(msg:String,x: int = 200, y: int = 200):void
		{
			Msg = msg;
			IsOK = true;
			IsCancel = false;
			X = x;
			Y = y;
			//super.Show(Constant.TopLayer - 1, 2);
			super.Show(Constant.GUI_MIN_LAYER, 2);
		}
		
	
		public function ShowOkCancel(msg:String,x: int = 200, y: int = 200):void
		{
			Msg = msg;
			IsOK = true;
			IsCancel = true;
			X = x;
			Y = y;
			//super.Show(Constant.TopLayer - 1, 2);
			super.Show(Constant.GUI_MIN_LAYER, 2);
		}
		
		
		public override function InitGUI() :void
		{
			LoadRes("GUI_MessageBox");
			
			if (IsOK && IsCancel)
			{
				AddButton(MSGBOX_OK, "ButtonOK", 55, 160, this);
				AddButton(MSGBOX_CANCEL, "ButtonCancel", 145, 160, this);
			}
			else if (IsOK && !IsCancel)
			{
				AddButton(MSGBOX_OK, "ButtonOK", 100, 160, this);
			}
			
			var lbl:TextField = AddLabel(Msg, 100, 40);
			var format:TextFormat = new TextFormat(null, 18);
			lbl.setTextFormat(format);
			lbl.width = 220;
			lbl.multiline = true;
			lbl.wordWrap = true;
			lbl.x = 30;
			lbl.y = 40;
			
			SetPos(X,Y);
		}
		
		//public override function SetPos(x: int, y: int): Point
		//{
			//
		//}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			Hide();
			GameLogic.getInstance().OnMessageBox(buttonID);
		}
		
		
	}

}