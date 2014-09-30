package GUI.Event8March 
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import NetworkPacket.PacketSend.SendSeekGroupUpTime;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUISeekTime extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idbtnClose";
		private const ID_BTN_SEEK:String = "idbtnSeek";
		private const ID_BTN_WAIT:String = "idbtnWait";
		private var _timer:Timer;
		private var _countTime:int;
		private var labelTime:TextField;
		private var prgTime:ProgressBar;
		private var _format:TextFormat;
		public var pressSeek:Boolean;
		private var _percent:Number;
		private var isReceiveData:Boolean;
		private var hasTimer:Boolean;
		
		private var _parent:CoralTree;
		
		public function GUISeekTime(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUISeekTime";
		}
		override public function InitGUI():void 
		{
			LoadRes("EventNoel_PopUpSeek");
			isReceiveData = false;
			AddButton(ID_BTN_CLOSE, "BtnThoat", 285, -5);
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
			
			if (_parent.SpeedUpNum < _parent.SpeedUpLimit && !_parent.isUnLimitLevel)
			{
				AddImage("", "EventNoel_ImgSpeech1", 170, 72);
				AddButton(ID_BTN_WAIT, "EventNoel_BtnWait", 105, 160);
				AddButton(ID_BTN_SEEK, "EventNoel_BtnSeek", 187, 160);
				AddLabel(_parent.PriceToSeek.toString(), 210, 160,0xFFFFFF,1,0x000000);
				pressSeek = false;
				initTime();
				initProgressBar();
			}
			else
			{
				hasTimer = false;
				//var tf:TextField = AddLabel("Bạn đã tua thời gian\n       đủ " + _parent.SpeedUpLimit + " lần", 90, 42, 0x325169);
				//var tf:TextField = AddLabel("Cây đã đạt đến cảnh giới", 90, 42, 0x325169);
				var tf:TextField = AddLabel("Bạn đã hết số lần tua trong ngày", 105, 55, 0x325169);
				tf.scaleX = 1.2;
				tf.scaleY = 1.2;
				AddButton(ID_BTN_WAIT, "EventNoel_BtnWait", 150, 160);
			}
			var parentTree:Layer = _parent.Parent as Layer;
			var posTree:Point = _parent.CurPos;
			posTree = parentTree.localToGlobal(posTree)
			
			SetPos(posTree.x - 320, 170);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
				case ID_BTN_WAIT:
					Hide();
				break;
				case ID_BTN_SEEK:
					seekTime();
				break;
			}
		}
		private function seekTime():void
		{
			if (GameLogic.getInstance().user.GetZMoney() < _parent.PriceToSeek)
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
			else
			{
				//_parent.isSeeking = true;
				var pk:SendSeekGroupUpTime = new SendSeekGroupUpTime();
				Exchange.GetInstance().Send(pk);
				GameLogic.getInstance().user.UpdateUserZMoney( 0 - _parent.PriceToSeek, true);
				pressSeek = true;
				_parent.SpeedUpNum++;
				_timer.delay = 50;
				GetButton(ID_BTN_SEEK).SetDisable();
				GetButton(ID_BTN_CLOSE).SetDisable();
				GetButton(ID_BTN_WAIT).SetDisable();
			}
		}
		
		public function seekTimeComp():void
		{
			/*thực hiện update progess bar cho chạy từ điểm hiện tại đến 100%*/
			isReceiveData = true;
			
			if (pressSeek && prgTime.GetStatus() >= 1)
			{
				_parent.hasSeek = true;
				Hide();
			}
		}
		
		/**
		 * thêm vào thời gian đếm ngược chạy trên đầu cây hoa
		 */
		private function initTime():void
		{
			_format = new TextFormat();
			_format.align = "center";
			_format.size = 16;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime - _parent.LastCareTime;
			var strTime:String = "Đợi để chăm sóc\n";
			
			if (remainTime >= _parent.MaxTimeCare)
			{
				hasTimer = false;
				strTime = "Tưới nước để thu hoạch";
			}
			else
			{
				hasTimer = true;
				_countTime = (int)(_parent.MaxTimeCare- remainTime);
				strTime += convertToTime(_countTime);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				_timer.start();
			}
			var cap:int = _parent.Level / 2 + 1;
			labelTime = AddLabel(strTime, 340, 350 - _parent.heightTree[cap] - 85, 0xFFFFFF, 1, 0x000000);
			labelTime.setTextFormat(_format);
		}
		private function onTimer(event:TimerEvent):void
		{
			
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime - _parent.LastCareTime;
			var timeCountMax:Number;
			var subTime:int;
			if (pressSeek)
			{
				if (_percent + 0.055 > 1 && isReceiveData)
				{
					_parent.hasSeek = true;
					if (_parent.SpeedUpNum <= _parent.SpeedUpLimit)
					{
						_timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
					}
					Hide();
					return;
				}
				_percent += 0.055;
				//timeCountMax = _parent.MaxTimeCare - remainTime;
				subTime = (int)(0.055 * _countTime / (1 - _percent));
				_countTime-= subTime;
				//_countTime-= (int)((_parent.MaxTimeCare - remainTime)/70);
			}
			else
			{
				_countTime--;
				_percent = remainTime / _parent.MaxTimeCare;
			}
			labelTime.text = "Đợi để chăm sóc\n" + convertToTime(_countTime);
			labelTime.setTextFormat(_format);
			prgTime.setStatus(_percent);
		}
		private function onTimerComp(event:TimerEvent):void
		{
			_timer.stop();
			if (hasTimer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
		}
		override public function Hide():void 
		{
			//_parent.isSeeking = false;
			if (_parent.SpeedUpNum <= _parent.SpeedUpLimit)
			{
				_timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
			
			super.Hide();
		}
		
		private function convertToTime(time:int):String
		{
			if (time <= 0) 
				return "00:00:00";
			var h:int = time / 3600;
			var dH:int = time % 3600;
			var m:int = dH / 60;
			var dM:int = dH % 60;
			var s:int = dM;
			var sh:String = (h < 10)?"0" + h:h.toString();
			var sm:String = (m < 10)?"0" + m:m.toString();
			var ss:String = (s < 10)?"0" + s:s.toString();
			return sh + ":" + sm + ":" + ss;
		}
		
		private function initProgressBar():void
		{
			AddImage("", "EventNoel_Clock_bg", 374, 292);
			prgTime = AddProgress("idprg", "EventNoel_PrgClock", 344, 284);
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime - _parent.LastCareTime;
			_percent = remainTime / _parent.MaxTimeCare;
			prgTime.setStatus(_percent);
		}
		
		public function init(tree:CoralTree):void
		{
			_parent = tree;
		}
	}
}