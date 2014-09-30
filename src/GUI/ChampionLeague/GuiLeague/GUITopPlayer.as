package GUI.ChampionLeague.GuiLeague 
{
	import flash.events.MouseEvent;
	import GUI.ChampionLeague.GuiLeague.itemGui.ItemPlayerTop;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.component.Button;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUITopPlayer extends GUIGetStatusAbstract 
	{
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_NEXTPAGE:String = "idBtnNextpage";
		private const ID_BTN_PREVPAGE:String = "idBtnPrevpage";
		
		private var _listTopPlayer:Array = [];
		private var _listItemPlayer:Array = [];
		private var btnNext:Button;
		private var btnPrev:Button;
		
		public function GUITopPlayer(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUITopPlayer";
			/*khởi tạo luôn các thông số của base*/
			_imgThemeName = "GuiTopLeague_Theme";
			_urlService = "OccupyService.getTop10Occupying";
			//_urlService = "LeagueService.getStatusLeague";//fake
			_idPacket = Constant.CMD_GET_TOP_TEN_PLAYER;
		}
		override protected function onInitGuiBeforeServer():void 
		{
			AddButton(ID_BTN_CLOSE, "GuiTopLeague_BtnClose", 255, 7);
		}
		/**
		 * khởi tạo dữ liệu cho  _listTopPlayer
		 * @param	data1 : danh sách topplayer trả về từ server
		 */
		override protected function onInitData(data1:Object):void 
		{
			_listTopPlayer.splice(0, _listTopPlayer.length);
			for (var str:String in data1["TopOccupying"]) 
			{
				var player:Player = new Player();
				player.setInfo(data1["TopOccupying"][str]);
				_listTopPlayer.push(player);
			}
			//sắp xếp lại danh sách
			_listTopPlayer.sortOn(["Rank"], Array.NUMERIC);
		}
		override protected function onInitGuiAfterServer():void 
		{
			if (_listTopPlayer.length > 5) 
			{
				btnPrev = AddButton(ID_BTN_PREVPAGE, "GuiTopLeague_BtnPrev", 70, 400);
				btnNext = AddButton(ID_BTN_NEXTPAGE, "GuiTopLeague_BtnNext", 160, 400);
				btnPrev.SetDisable();
			}
			addAllItem();
		}
		
		private function addAllItem():void 
		{
			var max:int = _listTopPlayer.length > 5 ? 5 : _listTopPlayer.length;
			var x:int = 12,y:int = 45;
			drawRangeItem(0, max - 1);
		}
		
		private function drawRangeItem(from:int, to:int):void 
		{
			var x:int = 12;
			var y:int = 45 + (from % 5) * 70;
			for (var i:int = from; i <= to; i++)
			{
				var player:Player = _listTopPlayer[i] as Player;
				var itemPlayer:ItemPlayerTop = new ItemPlayerTop(this.img, "GuiTopLeague_ItemPlayer", x, y);
				itemPlayer.EventHandler = this;
				itemPlayer.player = player;
				_listItemPlayer.push(itemPlayer);
				y += 70;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_NEXTPAGE:
					btnPrev.SetEnable(true);
					btnNext.SetEnable(false);
					removeAllItemPlayer();
					drawRangeItem(5, _listTopPlayer.length - 1);
				break;
				case ID_BTN_PREVPAGE:
					btnPrev.SetEnable(false);
					btnNext.SetEnable(true);
					removeAllItemPlayer();
					drawRangeItem(0, 4);
				break;
			}
		}
		
		private function removeAllItemPlayer():void 
		{
			for (var i:int = 0; i < _listItemPlayer.length; i++)
			{
				var itemPlayer:ItemPlayerTop = _listItemPlayer[i] as ItemPlayerTop;
				itemPlayer.Destructor();
			}
			_listItemPlayer.splice(0, _listItemPlayer.length);
		}
		override public function OnHideGUI():void 
		{
			LeagueInterface.getInstance().tableRankGift.isClickTop = false;
		}
	}

}