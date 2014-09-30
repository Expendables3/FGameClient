package GUI.Event8March 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIAwardAfterEvent extends BaseGUI 
	{
		// const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const CMD_RECEIVE:String = "cmdReceive";
		private const ID_PROGRESS:String = "idProgress";
		private const STRCHANGE:String = "Bạn đã đổi @num lần hộp quà đỏ";
		// logic
		private var _parent:GiftBoxAfter;
		// gui
		public var guiChooseElement:GUIChooseElementEvent = new GUIChooseElementEvent(null, "");
		private var tfDouble1:TextField;
		private var tfDouble2:TextField;
		private var tfDouble3:TextField;

		//
		private var prgCountChange:ProgressBar;
		
		// getter and setter
		public function get ParentObject():GiftBoxAfter
		{
			return _parent;
		}
		public function set ParentObject(val:GiftBoxAfter):void
		{
			_parent = val;
		}
		public function GUIAwardAfterEvent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIAwardAfterEvent";
		}
		
		override public function InitGUI():void 
		{
			LoadRes("Event8March_GUIAward");
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			addBgr();
			OpenRoomOut();
		}
		private function addBgr():void
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 643, 18);
			var strNumChange:String = Ultility.StandardNumber(_parent.OpenBoxNum);
			var tf1:TextField = AddLabel(strNumChange, 243, 67, 0x0E6B6A);
			tf1.scaleX = tf1.scaleY = 1.7;
			var x:int = 132, y:int = 290;
			for (var i:int = 1; i <= 3; i++)
			{
				var btn:Button = AddButton(CMD_RECEIVE + "_" + i, "Event8March_BtnReceive", x, y);
				if (_parent.BtnLogicArr[i - 1] == 0)
				{
					btn.SetDisable();
				}
				else if (_parent.BtnLogicArr[i - 1] == 2)
				{
					var tf:TextField = this["tfDouble" + i] = AddLabel("x2", x + 10, y - 5, 0x096791, 1, 0xffffff);
					tf.scaleX = tf.scaleY = 1.5;
					_parent.BtnLogicArr[i - 1] = 2;
				}
				addGift(i- 1, x + 20, y - 100);
				x += 178;
			}
			
			AddImage("", "Event8March_CountChangePgr_bg", 338, 111);
			prgCountChange = AddProgress(ID_PROGRESS, "Event8March_CountChangePgr", 95, 103);
			var countChange:int = _parent.OpenBoxNum;
			var percent:Number = countChange/100;
			prgCountChange.setStatus(percent);
			AddLabel("0", 48, 120, 0x096791, 1, 0xffffff);
			AddLabel("20", 140, 120, 0x096791, 1, 0xffffff);
			AddLabel("50", 287, 120, 0x096791, 1, 0xffffff);
			AddLabel("100", 530, 120, 0x096791, 1, 0xffffff);
			var tooltipText:String = STRCHANGE;
			tooltipText = tooltipText.replace("@num", countChange);
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = tooltipText;
			prgCountChange.EventHandler = this;
			prgCountChange.setTooltip(tip);
			guiChooseElement.ParentObject = this;
		}
		
		private function addGift(index:int, x:int, y:int):void
		{
			var giftArr:Array = _parent.CfgGift;
			var leng:int = giftArr.length;
			//for (var i:int = 0; i < leng; i++)
			//{
				var gift:Object = giftArr[index];
				var special:Object = gift[1];
				var normal :Object = gift[2];
				//add special gift
				var img:Image = AddImage("", "Event_8_3_Eff_GuiCongrate_" + special["Color"], x, y);
				img.SetScaleXY(1.3);
				var imgNameGift:String = special["ItemType"] + "10" + special["Rank"] + "_Shop";
				AddImage("", imgNameGift, x + 10, y + 5);
				//add normal gift
				var img1:Image = AddImage("", normal["ItemType"] + normal["ItemId"], x + 60, y + 89);
				img1.FitRect(40, 45, new Point(x+ 12, y + 43));
				//var tf:TextField = AddLabel("x" + normal["Num"], x, y, 0x096791, 1, 0xffffff);
			//}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var idButton:int;
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case CMD_RECEIVE:
					idButton = (int)(data[1]);
					trace("hiện gui chọn hệ đối với nút nhận số " + idButton);
					guiChooseElement.ChooseId = idButton;
					guiChooseElement.Show(Constant.GUI_MIN_LAYER, 5);
				break;
			}
		}
		public function processReceiveGift(idButton:int):void
		{
			_parent.BtnLogicArr[idButton - 1]--;
			if (_parent.BtnLogicArr[idButton - 1] <= 0)
			{
				var btnReceive:Button = GetButton(CMD_RECEIVE + "_" + idButton);
				if(btnReceive)
					GetButton(CMD_RECEIVE + "_" + idButton).SetDisable();
			}
			else if (_parent.BtnLogicArr[idButton - 1] == 1)
			{
				(this["tfDouble" + idButton] as TextField).visible = false;
			}
			_parent.updateHelper();
		}
	}
}