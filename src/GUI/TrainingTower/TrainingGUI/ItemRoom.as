package GUI.TrainingTower.TrainingGUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.TrainingTower.TrainingLogic.Room;
	import GUI.TrainingTower.TrainingLogic.TrainingMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemRoom extends Container 
	{
		static public const STATE_SELECTED:int = 0;
		static public const STATE_UNSELECTED:int = 1;
		static public const CMD_CHANGE_TAB:String = "cmdChangeTab";
		static public const CMD_UNLOCK_ROOM:String = "cmdUnlockRoom";
		private var _room:Room;//trỏ đến 1 room cụ thể
		
		public var imgTab:Image;
		public var btnTab:Button;
		public var tfStatus:TextField;
		//public var isUpdated:Boolean = false;
		public var VirtualTime:Number;
		public var State:int;
		// gui
		private var tfPriceUnlock:TextField;
		private var fmBlack:TextFormat;
		private var imgFinish:Image;
		private var tfNameSoldier:TextField;
		public function ItemRoom(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ItemRoom";
			fmBlack = new TextFormat("arial", 12, 0x000000);
		}
		
		public function initData(room:Room, timeGui:Number):void
		{
			_room = room;
		}
		
		public function drawItem():void
		{
			ClearComponent();
			var strNameFish:String;
			if (_room.State == Room.STATE_LOCK)
			{
				imgTab = AddImage("", "GuiTraining_ImgTabRoom_Lock", 0, 0, true, ALIGN_LEFT_TOP);
				btnTab = AddButton(CMD_UNLOCK_ROOM + "_" + _room.RoomId + "_" + _room.ZMoney, "GuiTraining_BtnUnLock", 11, 60, EventHandler);
				tfPriceUnlock = AddLabel(_room.ZMoney.toString(), 40, 66, 0xffffff, 1, 0x000000);
				var tip:TooltipFormat = new TooltipFormat();
				tip.text = "Phòng bị khóa";
				btnTab.setTooltip(tip);
			}
			else if (_room.State == Room.STATE_FINISH)
			{
				btnTab = AddButton(CMD_CHANGE_TAB + "_" + _room.RoomId, "GuiTraining_BtnTabRoom_Finish", 0, 0, EventHandler);
				imgTab = AddImage("", "GuiTraining_ImgTabRoom_Finish1", 0, 0, true, ALIGN_LEFT_TOP);
				imgTab.img.visible = false;
				strNameFish = TrainingMgr.getInstance().getNameSoldier(room.SoldierId);
			}
			else if (_room.State == Room.STATE_IDLE)
			{
				btnTab = AddButton(CMD_CHANGE_TAB + "_" + _room.RoomId, "GuiTraining_BtnTabRoom_Idle", 0, 0, EventHandler);
				imgTab = AddImage("", "GuiTraining_ImgTabRoom_Idle1", 0, 0, true, ALIGN_LEFT_TOP);
				imgTab.img.visible = false;
			}
			else {
				btnTab = AddButton(CMD_CHANGE_TAB + "_" + _room.RoomId, "GuiTraining_BtnTabRoom_Training", 0, 0, EventHandler);
				imgTab = AddImage("", "GuiTraining_ImgTabRoom_Training", 0, 0, true, ALIGN_LEFT_TOP);
				imgTab.img.visible = false;
			}
			
			AddLabel("Phòng " + _room.RoomId, 20, 4);
			imgFinish = AddImage("", "GuiTraining_TxtFinish", 21, 51,true,ALIGN_LEFT_TOP);
			imgFinish.img.visible = false;
			tfStatus = AddLabel("", 25, 50);
			updateItem(0);
			tfStatus.setTextFormat(fmBlack);
			tfNameSoldier = AddLabel("", 19, 25, 0xffffff);
			var fmName:TextFormat = new TextFormat("arial", 16, 0xcc6600);
			tfNameSoldier.defaultTextFormat = fmName;
			if (_room.State == Room.STATE_FINISH || _room.State == Room.STATE_TRAIN) {
				tfNameSoldier.text = TrainingMgr.getInstance().getNameSoldier(_room.SoldierId);
			}
			/*xét trạng thái của tab có được lựa chọn hay không*/
			suggestSelected();
		}
		
		public function deSelected():void
		{
			btnTab.SetVisible(true);
			imgTab.img.visible = false;
		}
		
		public function selected():void
		{
			btnTab.SetVisible(false);
			imgTab.img.visible = true;
		}
		
		public function suggestSelected():void
		{
			if (_room.State != Room.STATE_LOCK)
			{
				if (this.State == STATE_SELECTED)
				{
					selected();
				}
				else if (this.State == STATE_UNSELECTED)
				{
					deSelected();
				}
			}
		}
		
		public function addTime():void
		{
			
		}
		
		public function updateItem(time:Number):void 
		{
			_room.updateState(time);
			if (_room.State == Room.STATE_IDLE)
			{
				imgFinish.img.visible = false;
				tfStatus.visible = true;
				tfStatus.text = "Chưa tu luyện";
			}
			else if (_room.State == Room.STATE_FINISH)
			{
				room.inSeek = false;
				VirtualTime = GameLogic.getInstance().CurServerTime;
				ClearComponent();
				btnTab = AddButton(CMD_CHANGE_TAB + "_" + _room.RoomId, "GuiTraining_BtnTabRoom_Finish", 0, 0, EventHandler);
				imgTab = AddImage("", "GuiTraining_ImgTabRoom_Finish1", 0, 0, true, ALIGN_LEFT_TOP);
				imgTab.img.visible = false;
				AddLabel("Phòng " + _room.RoomId, 20, 4);
				imgFinish = AddImage("", "GuiTraining_TxtFinish", 21, 51, true, ALIGN_LEFT_TOP);
				imgFinish.img.mouseEnabled = false;
				tfStatus = AddLabel("", 25, 50);
				tfStatus.setTextFormat(fmBlack);
				tfNameSoldier = AddLabel("", 19, 25, 0xffffff);
				var fmName:TextFormat = new TextFormat("arial", 16, 0xcc6600);
				tfNameSoldier.text = TrainingMgr.getInstance().getNameSoldier(_room.SoldierId);
				tfNameSoldier.setTextFormat(fmName);
				suggestSelected();
				TrainingMgr.getInstance().hasUpdate = true;
			}
			else if (_room.State == Room.STATE_TRAIN)
			{
				tfStatus.visible = true;
				imgFinish.img.visible = false;
				var timeWait:int = _room.TimeTrain - (time - _room.StartTime);
				var strTime:String = Ultility.convertToTime(timeWait);
				if (time > 0) {
					tfStatus.text = strTime;
				}
				else {
					tfStatus.text = "-- : -- : --";
				}
			}
		}
		
		public function unlockItem():void 
		{
			_room.StartTime = 0;//chuyển trạng thái về IDLE
			drawItem();
		}
		
		public function get room():Room 
		{
			return _room;
		}
		
		public function set room(value:Room):void 
		{
			_room = value;
		}
	}

}





















