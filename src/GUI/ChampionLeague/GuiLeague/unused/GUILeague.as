package GUI.ChampionLeague.GuiLeague.unused 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.ChampionLeague.GuiLeague.itemGui.ItemPlayer;
	import GUI.ChampionLeague.GuiLeague.TableRankGift;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.ChampionLeague.PackageLeague.SendGetStatusLeague;
	import GUI.component.Button;
	import GUI.FishWar.ItemSoldier;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * GUI liên đấu : thuộc vào họ gui vẽ sau khi nhận dữ liệu từ server về
	 * @author HiepNM2
	 */
	public class GUILeague extends GUIGetStatusAbstract 
	{
		
		//const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_CHOOSE_SOLDIER:String = "idBtnChooseSoldier";
		private const ID_BTN_TOP_TEN:String = "idBtnTopTen";
		private const ID_BTN_BUYCARD:String = "idBtnBuycard";
		
		// gui
		private var btnClose:Button;
		private var btnChooseSoldier:Button;
		private var btnTop:Button;
		private var itemSoldier:ItemSoldier;
		private var _tableRankGift:TableRankGift;
		private var tfNumCard:TextField;
		private var tfTimeUpdate:TextField;
		// logic
		
		public function GUILeague(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUILeague";
			/*khởi tạo luôn các thông số của base*/
			_imgThemeName = "GuiLeague_Theme";
			_urlService = "LeagueService.getStatusLeague";
			_idPacket = Constant.CMD_GET_STATUS_LEAGUE;
		}
		
		/**
		 * khởi tạo gui trước khi nhận dữ liệu về
		 */
		override protected function onInitGuiBeforeServer():void 
		{
			btnClose = AddButton(ID_BTN_CLOSE, "BtnThoat", 700, 0);
			btnChooseSoldier = AddButton(ID_BTN_CHOOSE_SOLDIER, "GuiLeague_BtnChooseSoldier", 120, 260);
			btnTop = AddButton(ID_BTN_TOP_TEN, "GuiLeague_BtnTop", 117, 521);
		}
		
		/**
		 * khởi tạo dữ liệu logic cho feature liên đấu
		 * @param	data1 : dữ liệu server trả về
		 */
		override protected function onInitData(data1:Object):void 
		{
			LeagueMgr.getInstance().initDataFromStatusPacket(data1);
		}
		
		/**
		 * khởi tạo gui sau khi nhận dữ liệu về
		 */
		override protected function onInitGuiAfterServer():void 
		{
			//vẽ con cá với soldierId nhận về
			itemSoldier = new ItemSoldier(this, null, 125, 90, true);
			itemSoldier.soldier = LeagueMgr.getInstance().getChooseSoldier();
			//vẽ bảng quà với rank nhận về
			//_tableRankGift = new TableRankGift(this.img, "KhungFriend", 0, 0);
			_tableRankGift = new TableRankGift(this.img, "GuiLeague_CtnRankGift", 0, 0);
			
			_tableRankGift.rank = LeagueMgr.getInstance().MyPlayer.Rank;
			_tableRankGift.SetPos(13, 303);
			//vẽ danh sách player với listplayer nhận về
			
			addAllPlayer();
			//vẽ bảng ngư lệnh với numCard nhận về và nút mua ngư lệnh
			AddImage("", "GuiLeague_CtnNumCard", 511, 518);
			tfNumCard = AddLabel("0", 510, 505, 0xffffff, 1, 0x000000);
			tfNumCard.text = Ultility.StandardNumber(LeagueMgr.getInstance().NumCard);
			AddButton(ID_BTN_BUYCARD, "GuiLeague_BtnBuy", 590, 512);
			//vẽ thời gian cập nhật gui
			
		}
		
		/**
		 * cập nhật gui tại thời điểm curtime
		 * @param	curTime : thời điểm cập nhật
		 */
		override protected function onUpdateGui(curTime:Number):void 
		{
			
		}
		
		private function addAllPlayer():void 
		{
			var PlayerArr:Array = LeagueMgr.getInstance().ListPlayer;
			var x:int = 433, y:int = 58;
			for (var i:int = 0; i < PlayerArr.length; i++) {
				var player:Player = PlayerArr[i] as Player;
				addPlayer(player, x, y);
				y += 63;
			}
		}
		
		private function addPlayer(player:Player, x:int, y:int):void 
		{
			//var itemPlayer:ItemPlayer = new ItemPlayer(this.img, "KhungFriend", x, y);
			var itemPlayer:ItemPlayer = new ItemPlayer(this.img, "GuiLeague_CtnPlayer", x, y);
			itemPlayer.EventHandler = this;
			itemPlayer.initData(player);
			itemPlayer.drawItem();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_CHOOSE_SOLDIER:
					if (IsInitFinish) 
					{
						trace("show gui choose soldier");
					}
					else {
						trace("chưa khởi tạo xong");
					}
				break;
				case ID_BTN_TOP_TEN:
					if (IsInitFinish) {
						trace("show top tenth player");
					}else {
						trace("chưa khởi tạo xong");
					}
				break;
				case ItemPlayer.CMD_FIGHT_CARD:
					var uId:int = int(data[1]);
					trace("tấn công nhà người bạn có id = " + uId);
					//var victim:Player = LeagueMgr.getInstance().getPlayerById(uId);
					//var me:Player = LeagueMgr.getInstance().MyPlayer;
					//FakeServerMgr.getInstance().ProcessWar(me, victim);
					//FightingMgr.getInstance().activeGui = this;
				break;
				case ID_BTN_BUYCARD:
					trace("Mua 1 ngư lệnh");
				break;
			}
		}
	}

}

























