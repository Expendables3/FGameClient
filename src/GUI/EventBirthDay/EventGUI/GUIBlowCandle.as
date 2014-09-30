package GUI.EventBirthDay.EventGUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ProgressBar;
	import GUI.EventBirthDay.EventLogic.BirthdayCandleInfo;
	import GUI.EventBirthDay.EventPackage.SendBlowFastCandle;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.MyUserInfo;
	import Logic.User;
	
	/**
	 * GUI này dùng để thổi và tua cho nến tắt luôn
	 * @author HiepNM2
	 */
	public class GUIBlowCandle extends BaseGUI 
	{
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const ID_BTN_WAIT:String = "idBtnWait";
		static public const ID_BTN_BLOWFAST:String = "idBtnBlowfast";
		static public const NORMALTIME:Number = 1;
		static public const FASTTIME:Number = 0.05;
		
		// gui
		private var _tfTime:TextField;
		private var _prgTime:ProgressBar;
		private var _format:TextFormat;
		private var btnBlow:Button;
		private var btnWait:Button;
		private var btnClose:Button;
		// logic
		private var _candle:BirthdayCandleInfo;
		private var _timeGui:Number;						//thời điểm hiện của gui
		private var virtualTime:Number;						//thời điểm của gui fake khi chạy ở chế độ thổi nến
		private var hasUpdate:Boolean = false;				//có update gui hay không
		private var inBlow:Boolean = false;					//trong trạng thái thổi nến
		
		
		private function get Id():int {
			return _candle.ItemId;
		}
		
		public function GUIBlowCandle(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIBlowCandle";
			_format = new TextFormat();
			_format.align = TextFormatAlign.CENTER;
			_format.size = 16;
		}
		
		override public function InitGUI():void 
		{
			LoadRes("EventBirthday_GUIBlowCandle");
			if (Id != 1)
			{
				SetPos(_candle.Position.x - 590, 150);
			}
			else
			{
				SetPos(_candle.Position.x - 500, 150);
			}
			_timeGui = GameLogic.getInstance().CurServerTime;
			inBlow = false;
			virtualTime = _timeGui;
			
			addBgr();
			initTime();
			initProgressbar();
		}
		
		public function initData(candle:BirthdayCandleInfo):void 
		{
			_candle = candle;
		}
		
		private function addBgr():void 
		{
			btnClose = AddButton(ID_BTN_CLOSE, "BtnThoat", 280, -24);
			var tf:TextField;
			if (_candle.BlowNum < _candle.BlowLimit)
			{
				hasUpdate = true;
				tf = AddLabel("Bạn có thể thổi để châm lại nến", 77, 52, 0xffffff, 1, 0x000000);
				tf.scaleX = tf.scaleY = 1.2;
				btnWait = AddButton(ID_BTN_WAIT, "EventBirthday_BtnWait", 29, 138);
				btnBlow = AddButton(ID_BTN_BLOWFAST, "EventBirthday_BtnBlowFast", 129, 138);
				AddLabel(_candle.BlowZMoney.toString(), 163, 138, 0xffffff, 1, 0x000000);
			}
			else
			{
				hasUpdate = false;
				tf = AddLabel("Bạn đã hết số lần thổi trong ngày", 79, 52, 0xffffff, 1, 0x000000);
				tf.scaleX = 1.2;
				tf.scaleY = 1.2;
				btnWait = AddButton(ID_BTN_WAIT, "EventBirthday_BtnWait", 105, 138);
			}
		}
		
		private function initProgressbar():void 
		{
			if (!_candle.canBurn(_timeGui))
			{
				AddImage("", "EventBirthday_Clock_bg", 350, 128);
				_prgTime = AddProgress("idPrgTime", "EventBirthday_PrgClock", 320, 120);
				var percent:Number = _candle.countRemain(_timeGui) / _candle.FireTime;
				_prgTime.setStatus(percent);
			}
		}
		
		private function initTime():void 
		{
			var strTime:String = "Đợi để châm nến\n";
			if (_candle.canBurn(_timeGui))
			{
				hasUpdate = false;
				strTime = "Châm nến để nhận thưởng";
			}
			else
			{
				hasUpdate = true;
				strTime += _candle.getRemainTime(_timeGui);
			}
			_tfTime = AddLabel(strTime, 300, 60, 0xFFFFFF, 1, 0x000000);
			_tfTime.setTextFormat(_format);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
				case ID_BTN_WAIT:
					hasUpdate = false;
					Hide();
				break;
				case ID_BTN_BLOWFAST:
					blowCandleFast();
				break;
			}
		}
		
		private function blowCandleFast():void 
		{
			var _user:User = GameLogic.getInstance().user;
			var myMoney:int = _user.GetZMoney();
			var priceToBlow:int = _candle.BlowZMoney;
			if (myMoney < priceToBlow)
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
			else
			{
				inBlow = true;
				_candle.BlowNum++;
				_user.UpdateUserZMoney(0 - _candle.BlowZMoney, true);
				
				var pk:SendBlowFastCandle = new SendBlowFastCandle(Id);
				Exchange.GetInstance().Send(pk);
				
				btnClose.SetDisable();
				btnWait.SetDisable();
				btnBlow.SetDisable();
			}
		}
		
		public function updateGUI():void 
		{
			if (hasUpdate)
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				var tickcount:Number = curTime - _timeGui;
				if (inBlow)
				{
					if (tickcount >= FASTTIME)
					{
						virtualTime += _candle.IntevalTime;
						updateTime(virtualTime);
						_timeGui = curTime;
					}
				}
				else
				{
					if (tickcount >= NORMALTIME)
					{
						updateTime(curTime);
						_timeGui = curTime;
					}
				}
			}
		}
		
		
		
		private function updateTime(time:Number):void 
		{
			if (_candle.canBurn(time))//có thể thắp nến
			{
				_candle.Blowed = true;
				hasUpdate = false;
				Hide();
				var me:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
				var birthdayCandle:BirthdayCandle = me["birthdayCandle" + Id];
				
				birthdayCandle.effectBlow();
				//birthdayCandle.removeFire();
			}
			else
			{
				_tfTime.text = "Đợi để châm nến\n" + _candle.getRemainTime(time);
				_tfTime.setTextFormat(_format);
				var percent:Number = _candle.countRemain(time) / _candle.FireTime;
				_prgTime.setStatus(percent);
			}
		}
	}

}


































