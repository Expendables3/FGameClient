package GUI.ChampionLeague.GuiLeague 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.PackageLeague.SendChangeSoldier;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.FishWar.ItemSoldier;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	
	/**
	 * GUI chọn ngư thủ
	 * @author HiepNM2
	 */
	public class GUISelectSoldier extends BaseGUI 
	{
		static public const ID_BTN_CONFIRM:String = "idBtnConfirm";
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const ID_BTN_NEXT_FISH:String = "idBtnNextFish";
		static public const ID_BTN_PRE_FISH:String = "idBtnPreFish";
		
		// gui
		private var btnBackSolider:Button;
		private var btnNextSolider:Button;
		private var _itemSoldier:ItemSoldier;
		private var _formatProperties:TextFormat;
		private var _formatRankProperties:TextFormat;
		private var icElement:Image;
		// logic
		private var _damage:int;
		private var _defence:int;
		private var _critical:int;
		private var _vitality:int;
		private var listFish:Array;

		public function GUISelectSoldier(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUISelectSoldier";
			_formatProperties = new TextFormat("arial", 13, 0xffff00, true);
			_formatRankProperties = new TextFormat("arial", 13, 0xffffff, true);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void 
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addBgr();
				OpenRoomOut();
			}
			LoadRes("GuiSelectSoldier_Theme");
		}
		
		private function addBgr():void 
		{
			AddButton(ID_BTN_CONFIRM, "GuiSelectSoldier_BtnComfirm", 112, 362);
			AddButton(ID_BTN_CLOSE, "GuiSelectSoldier_BtnClose", 255, 6);
		}
		override public function EndingRoomOut():void 
		{
			listFish = LeagueMgr.getInstance().ListSoldier;
			if (listFish == null || listFish.length == 0) {
				return;
			}
			var soldier:FishSoldier = listFish[0] as FishSoldier;
			_itemSoldier = new ItemSoldier(this, soldier, 70, 50, true);
			_itemSoldier.addProperties(150, 270,
										150, 291,
										150, 312,
										150, 333,
										_formatProperties);
			_itemSoldier.addRankIcon(80, 232);
			_itemSoldier.addRankProperties("GuiSelectSoldier_PrgRank",
											123, 240,
											143, 215,
											130, 238,
											_formatRankProperties);
			_itemSoldier.X = (soldier.Element == 3)?95:70;
			_itemSoldier.soldier = soldier;
			if (listFish.length > 1) {
				btnNextSolider = AddButton(ID_BTN_NEXT_FISH, "GuiSelectSoldier_BtnNext", 242, 97);
				btnBackSolider = AddButton(ID_BTN_PRE_FISH, "GuiSelectSoldier_BtnPrev", 25, 97);
			}
			icElement = AddImage("", "GuiSelectSoldier_IconElement" + soldier.Element, 35, 46,true,ALIGN_LEFT_TOP);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var soldier:FishSoldier;
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_CONFIRM:
					var chooseSuccess:Boolean = chooseSoldier();
					if (chooseSuccess) {
						Hide();
					}
					
				break;
				case ID_BTN_NEXT_FISH:
					var indexNext:int = listFish.indexOf(_itemSoldier.soldier);
					if (indexNext == listFish.length - 1) {
						indexNext = 0;
					}
					else {
						indexNext++;
					}
					soldier = listFish[indexNext] as FishSoldier;
					_itemSoldier.X = (soldier.Element == 3)?95:70;
					_itemSoldier.soldier = soldier;
					icElement.LoadRes("GuiSelectSoldier_IconElement" + _itemSoldier.soldier.Element);
				break;
				case ID_BTN_PRE_FISH:
					var indexPre:int = listFish.indexOf(_itemSoldier.soldier);
					if (indexPre == 0) {
						indexPre = listFish.length - 1;
					}
					else {
						indexPre--;
					}
					soldier = listFish[indexPre] as FishSoldier;
					_itemSoldier.X = (soldier.Element == 3)?95:70;
					_itemSoldier.soldier = listFish[indexPre] as FishSoldier;
					icElement.LoadRes("GuiSelectSoldier_IconElement" + _itemSoldier.soldier.Element);
				break;
			}
		}
		
		private function chooseSoldier():Boolean 
		{
			var success:Boolean = true;
			if (LeagueMgr.getInstance().MyPlayer.SoldierId != _itemSoldier.soldier.Id) 
			{
				if (IsExpired(_itemSoldier.soldier) == true)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Ngư thủ đã già\nVui lòng chọn ngư thủ khác",310,200,1);
					success = false;
				}
				else 
				{
					LeagueInterface.getInstance().IsGotoLegueOk = false;
					trace("send ChooseSoldierId = " + _itemSoldier.soldier.Id);
					var soldierId:int = _itemSoldier.soldier.Id;
					var lakeId:int = _itemSoldier.soldier.LakeId;
					if (LeagueInterface.getInstance().guiInfoMe.IsVisible)
					{
						LeagueInterface.getInstance().guiInfoMe.Hide();
					}
					var _mySoldier:FishSoldier = _itemSoldier.soldier;
					LeagueInterface.getInstance().guiInfoMe.isMe = true;
					LeagueInterface.getInstance().guiInfoMe.damage = _mySoldier.getTotalDamage();
					LeagueInterface.getInstance().guiInfoMe.defence = _mySoldier.getTotalDefence();
					LeagueInterface.getInstance().guiInfoMe.critical = _mySoldier.getTotalCritical();
					LeagueInterface.getInstance().guiInfoMe.vitality = _mySoldier.getTotalVitality();
					LeagueInterface.getInstance().guiInfoMe.Show();
					
					var pk:SendChangeSoldier = new SendChangeSoldier(soldierId, lakeId);
					Exchange.GetInstance().Send(pk);
				}
			}
			return success;
						
		}
		
		/**
		 * check con ca het han chua
		 * @param	soldier : con ca can check
		 * @return  = true: het han, = false: chua het han
		 */
		private function IsExpired(soldier:FishSoldier):Boolean 
		{
			return false;
			var startTime:Number = soldier.OriginalStartTime;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var existTime:int = curTime - startTime;
			var lifeTime:int = soldier.LifeTime;
			if (existTime > lifeTime) {
				return true;
			}
			else {
				return false;
			}
		}
	}

}
































