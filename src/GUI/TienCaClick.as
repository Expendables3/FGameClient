package GUI 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Effect.ImgEffectBlink;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ChatBox;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendClickMermaid;
	/**
	 * ...
	 * @author ...
	 */
	public class TienCaClick extends BaseGUI
	{
		private const BTN_CLICK:String = "BtnClick";	
		private const BTN_NHO_BAN:String = "BtnNhoBan";	
		private const PRG_PROCESSING:String = "PrgProcessing";				
		private const PRG_CLICK_STATUS:String = "PrgClickStatus";				
		
		private var clickInterval:int = 3600 * 8;
		private var nhoBanInterval:int = 1800;	
		 
		private var prgClickStatus:ProgressBar;
		private var prgProcessing:ProgressBar;
		private var btnClick:Button;
		private var btnNhoBan:Button;
		private var lastTimeNhoBan:Number = 0;
		private var lastTimeClick:Number = 0;
		
		public var isProcessed:Boolean;
		public var bonus:Object;
		
		public static var isNewTienCa:Boolean = false;
		public static var tienCaNew:String = "TienCaNew";
		
		public function TienCaClick(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "TienCaClick";				
		}
		
		public override function InitGUI():void
		{		
			LoadRes("Tiencaom7");
			SetPos(500, 590);
			bonus = null;
			var toolFmt:TooltipFormat = new TooltipFormat();
			var ev:Object = ConfigJSON.getInstance().getEventInfo("SaveMermaid");
			var evInfo:Object = GameLogic.getInstance().user.GetMyInfo().event["SaveMermaid"];
			if (ev != null && evInfo != null)
			{
				clickInterval = ev["TimePeriod"];
				nhoBanInterval = ev["TimeFeed"];
				var num:int = evInfo["NumCurrent"];
				var maxNum:int = ev["LimitedClick"];			
				toolFmt.text = "Số người đã click: " + num + " / " + maxNum;
				lastTimeClick = evInfo["LastTimeClick"];
			}		
			
			
			
			//Thanh trạng thái thể hiện số lần đã click
			prgClickStatus = AddProgress(PRG_CLICK_STATUS, "PrgClickStatus", -65, 0, this, true);
			prgClickStatus.setStatus(num / maxNum);	
			prgClickStatus.setTooltip(toolFmt);			
			
			//Thanh xử lý chạy chạy khi ấn vào nút click
			prgProcessing = AddProgress(PRG_PROCESSING, "PrgProcessing", -50,  -220, this, true);
			prgProcessing.setStatus(0);	
			prgProcessing.setVisible(false);
			
			//Button click
			btnClick = AddButton(BTN_CLICK, "BtnClick", -60, -50, this);
			toolFmt = new TooltipFormat();
			btnClick.setTooltip(toolFmt);	
			btnClick.setTooltipText("Click để giải cứu tiên cá");
			//Button nhờ bạn
			btnNhoBan = AddButton(BTN_NHO_BAN, "BtnNhoBan", 10, -50, this);
			toolFmt = new TooltipFormat();
			btnNhoBan.setTooltip(toolFmt);
			btnNhoBan.setTooltipText("Nhờ bạn bè giải cứu tiên cá");	
			
			
			//Khoi tạo thời gian nhờ bạn
			//Nếu đã nhờ rùi, thì thời gian nhờ bạn sẽ được lấy từ shareObject
			lastTimeNhoBan = 0;
			var userId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var key:String = "HelpClick" + userId;
			var so:SharedObject = SharedObject.getLocal(key);
			if (so.data.lastTimeNhoBan != null)				
			{
				lastTimeNhoBan = so.data.lastTimeNhoBan;
			}					
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var so:SharedObject;
			switch(buttonID)
			{
				case BTN_CLICK:
					btnClick.SetDisable();
					var timeClick:Number = GameLogic.getInstance().user.GetMyInfo().event["SaveMermaid"]["LastTimeClick"];
					if (isNaN(timeClick)) 
					{
						timeClick = 0;
					}
					var curTime:Number = GameLogic.getInstance().CurServerTime;
					if (int(curTime - timeClick) >= clickInterval)
					{						
						isProcessed = false;						
						var cmd:SendClickMermaid = new SendClickMermaid();						
						Exchange.GetInstance().Send(cmd);	
						prgProcessing.setVisible(true);						
					}

					break;				
				case BTN_NHO_BAN:
					//Show feed len tuong
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_CLICK);		
					
					var userId:int = GameLogic.getInstance().user.GetMyInfo().Id;
					var key:String = "HelpClick" + userId;
					so = SharedObject.getLocal(key);
					so.data.lastTimeNhoBan = lastTimeNhoBan = GameLogic.getInstance().CurServerTime;
					break;
			}
		}
		
		public function update():void
		{
			if (!IsVisible)
				return;
				
			if (prgProcessing.img.visible)
			{
				prgProcessing.setStatus(prgProcessing.percent + 0.02);
				if (prgProcessing.percent >= 1)
				{
					prgProcessing.setVisible(false);
					prgProcessing.setStatus(0);
					isProcessed = true;
					if (bonus != null)
					{
						dropBonus();
					}
				}
			}
			
			//Check thoi gian click
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var time:Number = curTime - lastTimeClick;
			if (time <= clickInterval)//Nếu chưa đủ thời gian để click lần tiếp theo
			{
				if (btnClick.enable == true)
				{
					btnClick.SetDisable();	
					btnClick.clearTooltip();
					var toolFmt:TooltipFormat = new TooltipFormat();
					btnClick.setTooltip(toolFmt);	
				}
				else
				{
					var hour:int = (clickInterval - time) / 3600;
					var m:int = (clickInterval - time) % 3600;
					var minute:int = m / 60;
					var second:int = m % 60;
					btnClick.setTooltipText("Còn " + hour + " giờ " + minute + " phút " + second + " giây để click giải cứu tiên cá tiếp");	
				}
				
			}
			else//Đủ thời gian để click lần tiếp
			{
				if (btnClick.enable == false)
				{
					btnClick.SetEnable();
					btnClick.clearTooltip();
					toolFmt = new TooltipFormat();
					btnClick.setTooltip(toolFmt);
					btnClick.setTooltipText("Click để giải cứu tiên cá");	
				}				
			}
			
			
			//Check thoi gian nho ban
			time = curTime - lastTimeNhoBan;
			if (time <= nhoBanInterval)//Nếu chưa đủ thời gian để nhờ bạn
			{
				if (btnNhoBan.enable == true)
				{
					btnNhoBan.SetDisable();		
					btnNhoBan.clearTooltip();
					toolFmt = new TooltipFormat();
					btnNhoBan.setTooltip(toolFmt);	
				}
				else
				{
					hour = (nhoBanInterval - time) / 3600;
					m = (nhoBanInterval - time) % 3600;
					minute = m / 60;
					second = m % 60;
					btnNhoBan.setTooltipText("Còn " + hour + " giờ " + minute + " phút " + second + " giây");	
				}
			}
			else//Đã đủ thời gian để nhờ bạn
			{
				if (btnNhoBan.enable == false)
				{
					btnNhoBan.SetEnable();
					btnNhoBan.clearTooltip();
					toolFmt = new TooltipFormat();
					btnNhoBan.setTooltip(toolFmt);
					btnNhoBan.setTooltipText("Nhờ bạn bè giải cứu tiên cá");
				}
			}
			
			
		}
		
		
		//Xử lý data từ server trả về khi gửi gói tin SendClickMermaid
		public function setInfo(Data:Object):void
		{
			//Thông tin phần thưởng
			bonus = Data["Bonus"];
			if (isProcessed)
			{
				dropBonus();
			}	
			
			var timeClick:Number = GameLogic.getInstance().user.GetMyInfo().event["SaveMermaid"]["LastTimeClick"];
			if (isNaN(timeClick)) 
			{
				timeClick = 0;
			}
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (int(curTime - timeClick) >= clickInterval)
			{						
				GameLogic.getInstance().user.GetMyInfo().event["SaveMermaid"]["NumCurrent"] = Data["NumCurrent"];
				
				//Update lại trạng thái của thành click
				var num:int = GameLogic.getInstance().user.GetMyInfo().event["SaveMermaid"]["NumCurrent"];
				var maxNum:int = ConfigJSON.getInstance().getEventInfo("SaveMermaid")["LimitedClick"];
				prgClickStatus.setStatus(num / maxNum);
				prgClickStatus.setTooltipText("Số người đã click: " + num + " / " + maxNum);						
			}
			//Thoi diem click lan cuoi cung
			lastTimeClick = GameLogic.getInstance().CurServerTime;			
		}
		
		public function dropBonus():void
		{
			if (bonus == null || isProcessed == false)
				return;
				
			//Trong bonus data server tra ve, phan tu 0 la tien, phan tu 1 la Exp;
			EffectMgr.getInstance().fallExpMoneyClickEvent( bonus[1].Num, bonus[0].Num);
			
			
			//Check hoan thanh event
			var num:int = GameLogic.getInstance().user.GetMyInfo().event["SaveMermaid"]["NumCurrent"];
			var maxNum:int = ConfigJSON.getInstance().getEventInfo("SaveMermaid")["LimitedClick"];
			if (num >= maxNum)
			{			
				var so:SharedObject = SharedObject.getLocal("FeedClick");
				if (!so.data.feeded)			
				{
					//GuiMgr.getInstance().GuiFinishEventClick.Show(Constant.GUI_MIN_LAYER, 2);
					isNewTienCa = true;
					so.data.feeded = true;
				}		
			}
		}
	}
}