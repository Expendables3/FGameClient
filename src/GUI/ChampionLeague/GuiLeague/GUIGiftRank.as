package GUI.ChampionLeague.GuiLeague 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.component.Image;
	import GUI.GuiGetStatus.SendGetStatus;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * GUI nhận thưởng khi đến thời điểm 10h hàng ngày
	 * @author HiepNM2
	 */
	public class GUIGiftRank extends GUIReceiveMultiGiftAbstract 
	{
		private var _listGift:Array = [];
		public function GUIGiftRank(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGiftRank";
			ThemeName = "GuiLeagueGift_Theme";
			xListBox = 120;
			yListBox = 325;
			numRow = 2;
			//numCol = 6;
			numCol = 5;
			xClose = 691;
			yClose = 51;
			xReceive = 310;
			yReceive = 520;
			dCol = 40;
			dRow = 07;
		}
		
		public function initData(listGift:Array):void {
			_listGift.splice(0, _listGift.length);
			/*clone listGift and copy to _listGift*/
			for (var i:int = 0; i < listGift.length; i++) {
				_listGift.push(listGift[i]);
			}
		}
		
		override public function addTip():void 
		{
			//SetPos(img.x + 295, img.y + 120);
		}
		
		override public function initListGift():void 
		{
			var i:int;
			for (i = 0; i < _listGift.length; i++)
			{
				var gift:AbstractGift = _listGift[i] as AbstractGift;
				addGift(gift);
			}
		}
		
		override public function addGift(gift:AbstractGift):void 
		{
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, 
																			this.img, 
																			_guiName + "_ImgSlot");
			itemGift.initData(gift, "", 66, 69);
			itemGift.yNum = 60;
			itemGift.drawGift();
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
		
		override public function OnHideGUI():void 
		{
			LeagueController.getInstance().isWaitReponseGift = false;
			LeagueMgr.getInstance().hasGiftTop = false;
			/*thực hiện refresh guiRank trong liên đấu*/
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var timeRefreshBySystem:Number = LeagueInterface.getInstance().timeRefreshBySystem;
			if (curTime - timeRefreshBySystem > 5)
			{
				LeagueInterface.getInstance().guiRank.inRefresh = true;
				var pk:SendGetStatus = new SendGetStatus("OccupyService.refreshOccupyingBoard", 
															Constant.CMD_REFRESH_RANK_BOARD);
				Exchange.GetInstance().Send(pk);
				LeagueInterface.getInstance().timeRefreshBySystem = -1;
			}
		}
		/**
		 * thêm vào các thông tin cho phần thưởng: ngày chốt giải, top mấy
		 */
		public function drawTopInfo():void
		{
			var lastGiftRank:int = LeagueMgr.getInstance().lastGiftRank;
			if (lastGiftRank == 0) return;
			var top:int = LeagueMgr.getInstance().getTop(lastGiftRank);
			var strTip:String;
			if (top == 1)
			{
				strTip = "Đương kim vô địch";
			}
			else {
				strTip = "Phần thưởng Top " + top;
			}
			var tfTip:TextField = AddLabel(strTip, 331, 95, 0xffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 20);
			tfTip.setTextFormat(fm);
			var imgTrunk:Image = AddImage("", "GuiLeague_TrunkTop" + top, 445, 255);
			imgTrunk.FitRect(150, 150, new Point(303, 120));
			//thêm vào thời điểm chốt giải
			var lastGiftTime:Number = LeagueMgr.getInstance().LastGiftTime;
			var dateGift:Date = new Date(lastGiftTime * 1000);
			var day:int = int(dateGift.getUTCDate());
			var month:int = int(dateGift.getUTCMonth()) + 1;
			var year:int = int(dateGift.getUTCFullYear());
			var strDate:String = day + " / " + month + " / " + year;
			var tfDate:TextField = AddLabel("Phần thưởng cho ngày: " + strDate, 310, 280, 
											0xffffff, 1, 0x000000);
			fm = new TextFormat("Arial", 14);
			tfDate.setTextFormat(fm);
		}
	}

}



















