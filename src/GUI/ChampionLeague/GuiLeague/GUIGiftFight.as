package GUI.ChampionLeague.GuiLeague 
{
	import flash.events.MouseEvent;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.GUIFishStatus;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.FishSoldier;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * GUI nhận quà sau khi đánh nhau xong trong liên đấu
	 * @author HiepNM2
	 */
	public class GUIGiftFight extends GUIReceiveMultiGiftAbstract 
	{
		private var _listGift:Array = [];
		private var _isWin:int;
		private const CMD_CLOSE:String = "idBtnClose";
		private const ID_BTN_RECEIVE:String = "idBtnReceive";
		
		public function GUIGiftFight(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGiftFight";
			ThemeName = "GuiLeagueFinishFight_Theme";
			xClose = 371;
			yClose = 16;
			
			numRow = 1;
			numCol = 2;
			dCol = 5;
		}
		override public function addTip():void 
		{
			if (_isWin == 0)
			{
				AddImage("", "GuiLeagueFinishFight_Speech", 130, 65,true,ALIGN_LEFT_TOP);
			}
		}
		public function initData(listGift:Array):void {
			_listGift.splice(0, _listGift.length);
			/*clone listGift and copy to _listGift*/
			for (var i:int = 0; i < listGift.length; i++) {
				_listGift.push(listGift[i]);
			}
		}
		
		override public function initListGift():void 
		{
			//ListGift.border = true;
			var i:int;
			for (i = 0; i < _listGift.length; i++)
			{
				var gift:AbstractGift = _listGift[i] as AbstractGift;
				addGift(gift);
			}
			addTitle();
		}
		
		private function addTitle():void 
		{
			//var x:int, y:int;
			//if (_isWin == 1)
			//{
				//x = 200;
				//y = 28;
			//}
			//else {
				//x = 170;
				//y = 35;
			//}
			//AddImage("", "GuiLeagueFinishFight_Tip" + _isWin, x, y);
			if (_isWin == 0)
			{
				AddImage("", "GuiLeagueFinishFight_Tip" + _isWin, 170, 35);
			}
		}
		
		override public function addGift(gift:AbstractGift):void 
		{
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "KhungFriend");
			itemGift.initData(gift);
			itemGift.drawGift();
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
		
		private function addBgr():void 
		{
			AddImage("", "GuiLeagueFinishFight_Speech", 132, 63, true, ALIGN_LEFT_TOP);
			AddButton(CMD_CLOSE, "BtnThoat", 371, 16);
			AddButton(ID_BTN_RECEIVE, "GuiLeagueFinishFight_BtnReceiveGift", 150, 215);
		}
		override public function OnHideGUI():void 
		{
			trace("nhận phần thưởng trong liên đấu sau khi đánh nhau xong xong");
			LeagueInterface.getInstance().onFinishReceiveGift();
			var mySoldier:FishSoldier = LeagueInterface.getInstance().ChoseSoldier;
			mySoldier.GuiFishStatus.ShowStatus(mySoldier, GUIFishStatus.WAR_INFO);
			LeagueInterface.getInstance().btnChooseSoldier.SetEnable(true);
		}
		
		public function set isWin(value:int):void 
		{
			_isWin = value;
			if (value == 1)
			{
				ThemeName = "GuiLeagueFinishFight_Theme1";
				xReceive = 130;
				yReceive = 255;
				xListBox = 118;
				yListBox = 115;
			}
			else
			{
				ThemeName = "GuiLeagueFinishFight_Theme";
				xReceive = 150;
				yReceive = 215;
				xListBox = 140;
				yListBox = 88;
			}
		}
		
	}

}























