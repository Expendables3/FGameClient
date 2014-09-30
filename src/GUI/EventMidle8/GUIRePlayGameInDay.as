package GUI.EventMidle8 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendGetNextMap;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIRePlayGameInDay extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_REPLAY_BY_G:String = "BtnRePlayByG";
		public const BTN_REPLAY_BY_GOLD:String = "BtnRePlayByGold";
		public var ZMoney:int = 1;
		public var Money:int = 100000;
		public var timeShow:Number;
		private var lastJoinTime:Number;
		private var hour:int;
		private var min:int;
		private var sec:int;
		private var numSecWait:int;
		private var numMinWait:int;
		private var isRequestURejoin:Boolean = false;
		private var txtTimeWait:TextField;
		
		public function GUIRePlayGameInDay(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIRePlayGameInDay";
		}
		
		override public function InitGUI():void 
		{
			timeShow = GameLogic.getInstance().CurServerTime - GuiMgr.getInstance().GuiGameTrungThu.NUM_TIME_DELAY;
			lastJoinTime = GuiMgr.getInstance().GuiGameTrungThu.CreateTime;
			super.InitGUI();
			LoadRes("GUIRePlayGameInDay_ImgBgGUIRePlayGame");
			SetPos((Constant.STAGE_WIDTH - img.width) / 2, (Constant.STAGE_HEIGHT - img.height) / 2);
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 38, 19, this);
			AddButton(BTN_REPLAY_BY_G, "GUIRePlayGameInDay_BtnRePlayByG", 261, 300, this);
			AddButton(BTN_REPLAY_BY_GOLD, "GUIRePlayGameInDay_BtnRePlayByGold", 170, 300, this).SetDisable();
			
			var objMoney:Object = ConfigJSON.getInstance().GetItemList("RefreshRockMazeMap");
			var joinNum:int = (GuiMgr.getInstance().GuiGameTrungThu.JoinNum + 1);
			ZMoney = objMoney[joinNum.toString()]["ZMoney"];
			
			var fm:TextFormat = new TextFormat();
			fm.color = 0xFFFFFF;
			fm.size = 18;
			fm.bold = true;
			fm.align = "center";
			AddLabel(ZMoney.toString(), 315, 296).setTextFormat(fm);
			
			numSecWait = ConfigJSON.getInstance().GetItemList("Param")["MapCoolDown"] + 2;
			numSecWait = numSecWait - (GameLogic.getInstance().CurServerTime - lastJoinTime);
			if (numSecWait <= 0)
			{
				txtTimeWait = AddLabel("00:00:00", 165, 115);
				fm = new TextFormat(null, 16, 0xFFFFFF, true);
				txtTimeWait.setTextFormat(fm);
				txtTimeWait.defaultTextFormat = fm;
				GetButton(BTN_REPLAY_BY_GOLD).SetEnable();
				
				var cmd:SendGetNextMap;
				GetButton(BTN_REPLAY_BY_GOLD).SetDisable();
				GetButton(BTN_REPLAY_BY_G).SetDisable();
				GetButton(BTN_CLOSE).SetDisable();
				cmd = new SendGetNextMap("Money",false);
				Exchange.GetInstance().Send(cmd);
			}
			else
			{
				sec = numSecWait % 60;
				numMinWait = (numSecWait - sec) / 60;
				min = numMinWait % 60;
				hour = numMinWait / 60;
				var strHour:String;
				var strMin:String;
				var strSec:String;
				if (hour < 10)	strHour = "0" + hour.toString();
				else strHour = hour.toString();
				if (min < 10)	strMin = "0" + min.toString();
				else strMin = min.toString();
				if (sec < 10)	strSec = "0" + sec.toString();
				else strSec = sec.toString();
				txtTimeWait = AddLabel(strHour + ":" + strMin + ":" + strSec, 165, 115);
				fm = new TextFormat(null, 16, 0xFFFFFF, true);
				txtTimeWait.setTextFormat(fm);
				txtTimeWait.defaultTextFormat = fm;
				
			}
			
			OpenRoomOut();
		}
		private function CheckNextDay():Boolean
		{
			var bool:Boolean = Ultility.CheckDate(timeShow, GuiMgr.getInstance().GuiGameTrungThu.NUM_TIME_DELAY);
			return !bool;
		}
		
		public function UpdateGUI():void 
		{
			if(!isRequestURejoin)
			{
				var curTimeNow:Number = GameLogic.getInstance().CurServerTime;
				if (curTimeNow - lastJoinTime >= 1)
				{
					if(numSecWait > 0)
					{
						lastJoinTime = int(curTimeNow);
						numSecWait--;
						sec = numSecWait % 60;
						numMinWait = (numSecWait - sec) / 60;
						min = numMinWait % 60;
						hour = numMinWait / 60;			
						var strHour:String;
						var strMin:String;
						var strSec:String;
						if (hour < 10)	strHour = "0" + hour.toString();
						else strHour = hour.toString();
						if (min < 10)	strMin = "0" + min.toString();
						else strMin = min.toString();
						if (sec < 10)	strSec = "0" + sec.toString();
						else strSec = sec.toString();
						txtTimeWait.text = strHour + ":" + strMin + ":" + strSec;
					}
					else if(numSecWait == 0)
					{
						GetButton(BTN_REPLAY_BY_GOLD).SetEnable();
						GetButton(BTN_REPLAY_BY_G).SetDisable();
						numSecWait --;
					}
				}
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var cmd:SendGetNextMap;
			if (CheckNextDay())
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã sang ngày mới\nHãy vào lại sau nhé ^_^");
				Hide();
				return;
			}
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
					if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
					{
						GuiMgr.getInstance().GuiGameTrungThu.Hide();
					}
					GameLogic.getInstance().ShowFish();
				break;
				case BTN_REPLAY_BY_G:
					if(GameLogic.getInstance().user.GetZMoney() >= ZMoney)
					{
						GetButton(BTN_REPLAY_BY_G).SetDisable();
						GetButton(BTN_REPLAY_BY_GOLD).SetDisable();
						GetButton(BTN_CLOSE).SetDisable();
						GameLogic.getInstance().user.UpdateUserZMoney( -ZMoney);
						cmd = new SendGetNextMap("ZMoney",false);
						Exchange.GetInstance().Send(cmd);
					}
					else 
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
				break;
				case BTN_REPLAY_BY_GOLD:
						GetButton(BTN_REPLAY_BY_GOLD).SetDisable();
						GetButton(BTN_REPLAY_BY_G).SetDisable();
						GetButton(BTN_CLOSE).SetDisable();
						//GameLogic.getInstance().user.UpdateUserMoney( -Money);
						cmd = new SendGetNextMap("Money",false);
						Exchange.GetInstance().Send(cmd);
				break;
			}
		}
	}

}