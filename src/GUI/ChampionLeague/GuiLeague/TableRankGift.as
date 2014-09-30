package GUI.ChampionLeague.GuiLeague 
{
	import Data.ConfigJSON;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.GuiLeague.itemGui.ItemTopGift;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.ChampionLeague.PackageLeague.SendGetGiftLeague;
	import GUI.ChampionLeague.PackageLeague.SendRefreshBoard;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import GUI.GUINoneAbstract.GUINoneAbstract;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * Bảng thông tin người chơi.
	 * @author HiepNM2
	 */
	public class TableRankGift extends GUINoneAbstract 
	{
		private const CMD_RECEIVE:String = "cmdReceive";
		private const ID_BTN_TOP:String = "idBtnTop";
		// logic
		private var _rank:int;
		
		// gui
		private var _topGift:ItemTopGift;			//quà của người chơi
		private var _tfRank:TextField;
		private var _tfTime:TextField;
		private var _tfNotice:TextField;
		private var _tfTextRT:TextField;
		private var _format:TextFormat;
		private var btnTop:Button;
		public var isClickTop:Boolean = false;
		private var curSecond:int = -1;
		private var isSystemRefresh:Boolean = false;
		public var timeGui:Number = 0;
		public var preTimeRefresh:Number = 0;
		
		public function TableRankGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "TableRankGift";
			ShiftFromInitGui = true;		//cho kéo gui ngay sau khi initgui
			_xScr = _xDes = 0;
			_yScr = -480;
			_yDes = -225;
			_xGui = 200;
			_yGui = 28;
			_wMask = 305;
			_hMask = 290;
			_themeName = "GuiLeague_GuiRankPlayerTheme";
			_bgName = "GuiLeague_CtnRankGift";
			_format = new TextFormat("arial", 12);
		}
		
		override protected function onInitGui():void 
		{
			_rank = LeagueMgr.getInstance().MyPlayer.Rank;
			drawTable();
		}
		
		public function get rank():int 
		{
			return _rank;
		}
		
		public function set rank(value:int):void 
		{
			_rank = value;
		}
		
		private function drawTable():void 
		{
			if (_rank >= 1 && _rank <= 1000) 
			{
				_topGift = new ItemTopGift(ctnBg.img, "GuiLeague_CtnGift", 62, 319);
				_topGift.EventHandler = this;
				_topGift.top = LeagueMgr.getInstance().getTop(_rank);
				_topGift.RockIndex = 5;
			}
			else 
			{
				ctnBg.AddLabel("Không có\nphần\nthưởng", 28, 301, 0xffff00, 1, 0x000000);
			}
			var strRank:String;
			if (_rank > 1000) {
				strRank = "> 1000";
			}
			else {
				strRank = Ultility.StandardNumber(_rank);
			}
			_tfRank = ctnBg.AddLabel("Hạng hiện tại: " + strRank, 120, 303, 0xffffff, 0);
			_tfTextRT = ctnBg.AddLabel("Thời gian nhận : ", 120, 320, 0xffffff, 0);
			_tfTime = ctnBg.AddLabel("00 : 00 : 00", 197, 320, 0xffffff);
			var h:int = LeagueMgr.getInstance().getConfigHour();
			var m:int = LeagueMgr.getInstance().getConfigMinute();
			var sH:String = h < 10 ? "0" + h : h.toString();
			var sM:String = m < 10 ? "0" + m : m.toString();
			var strTime:String = sH + ":" + sM;
			_tfNotice = ctnBg.AddLabel("Phần thưởng sẽ trao vào lúc " +strTime + " hàng ngày", 20, 367, 0xffffff, 0);
			_tfNotice.defaultTextFormat = 
			_tfRank.defaultTextFormat = _tfTextRT.defaultTextFormat = _format;
		}
		
		override public function Destructor():void 
		{
			_topGift.Destructor();
			super.Destructor();
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_TOP:
					if (LeagueInterface.getInstance().IsGotoLegueOk)
					{
						if (!isClickTop)
						{
							isClickTop = true;
							GuiMgr.getInstance().guiTopPlayer.Show(Constant.GUI_MIN_LAYER, 5);
						}
					}
				break;
				case CMD_RECEIVE:
					
				break;
			}
		}
		
		/**
		 * coolDown đến thời điểm nhận giải
		 * @param	curTime : thời điểm hiện tại
		 */
		public function updateTable2(curTime:Number):void 
		{
			var configTime:Number = LeagueMgr.getInstance().TimeForGetGift;
			if (configTime <= 0)
			{
				return;
			}
			var waitTime:int = configTime - curTime;
			//check xem đến giờ refresh bảng xếp hạng chưa
			if (curTime > configTime - 2 * 60)
			{
				if (!isSystemRefresh)
				{
					//gửi gói tin refresh bảng xếp hạng lên
					isSystemRefresh = true;
					var refresh:SendRefreshBoard = new SendRefreshBoard(false);
					Exchange.GetInstance().Send(refresh);
				}
			}
			//if (waitTime < -20)
			if (waitTime < 0)
			{
				var myPlayer:Player = LeagueMgr.getInstance().MyPlayer;
				if (myPlayer.Rank >= 1 && myPlayer.Rank <= 1000)
				{
					LeagueController.getInstance().isWaitReponseGift = true;
					var pk:SendGetGiftLeague = new SendGetGiftLeague();
					Exchange.GetInstance().Send(pk);
				}
				var sTime:String = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["TimeEndInDay"];
				LeagueMgr.getInstance().TimeForGetGift = LeagueController.convertToUnixTime(curTime, sTime, true);
				isSystemRefresh = false;
			}
			else 
			{
				var h:int = int(waitTime / 3600);
				var dh:int = waitTime % 3600;
				var m:int = int(dh / 60);
				var dm:int = dh % 60;
				var s:int = dm;
				var sh:String = h < 10 ? "0" + h : h.toString();
				var sm:String = m < 10 ? "0" + m : m.toString();
				var ss:String = s < 10 ? "0" + s : s.toString();
				if(_tfTime!=null)
					_tfTime.text = sh + " : " + sm + " : " + ss;
			}
			timeGui = curTime;
			
			
		}
		
		public function refreshOk():void 
		{
			var r:int = LeagueMgr.getInstance().MyPlayer.Rank;
			if (r != _rank)
			{
				_rank = r;
				_topGift.Destructor();
				ctnBg.ClearComponent();
				drawTable();
				onFinishShowGui();
			}
		}
		
		public function autoRefresh(curTime:Number):void 
		{
			preTimeRefresh = curTime;
			
		}
		override protected function onAfterHideGui():void 
		{
			isClickTop = false;
		}
		override protected function onFinishShowGui():void 
		{
			btnTop = ctnBg.AddButton(ID_BTN_TOP, "GuiLeague_BtnTop", 90, 394);
			btnTop.EventHandler = this;
		}
	}

}





















