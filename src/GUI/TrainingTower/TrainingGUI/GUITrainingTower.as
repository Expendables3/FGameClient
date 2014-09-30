package GUI.TrainingTower.TrainingGUI 
{
	import com.bit101.components.Text;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Event.EventMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import GUI.TrainingTower.TrainingGUI.ItemRoom;
	import GUI.TrainingTower.TrainingLogic.Room;
	import GUI.TrainingTower.TrainingLogic.TrainingMgr;
	import GUI.TrainingTower.TrainingPackage.SendGetGiftTraining;
	import GUI.TrainingTower.TrainingPackage.SendGetStatusTraining;
	import GUI.TrainingTower.TrainingPackage.SendSpeedUpTraining;
	import GUI.TrainingTower.TrainingPackage.SendStartTrainingTower;
	import GUI.TrainingTower.TrainingPackage.SendStopTraining;
	import GUI.TrainingTower.TrainingPackage.SendUnlockRoom;
	import Logic.BaseObject;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LogicGift.GiftNormal;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * hiển thị và điều khiển việc luyện tập ngư thủ
	 * @author HiepNM2
	 */
	public class GUITrainingTower extends BaseGUI 
	{
		private const YBUFF:int = 26;
		static public const MAXNUMROOM:int = 4;
		static public const FASTTIME:Number = 0.05;
		static public const NORMALTIME:Number = 1.001;
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		// gui
		
		[Embed(source = '../../../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		private var ListItemRoom:Array = [];
		private var fmBlack:TextFormat;
		private var curPage:PageRoom;
		private var guiGift:GUIGetGiftTraining = new GUIGetGiftTraining(null, "");
		
		// logic
		public var IsInitFinish:Boolean = false;
		public var IsDataReady:Boolean;
		private var listRoom:Array = [];
		private var _timeGui:Number;
		private var inSeek:Boolean = false;
		private var isInitedListRoom:Boolean = false;
		public var bCheckCookies:Boolean = false;			//kiểm tra sự checkCookies
		private var UnlockSuccess:Boolean = true;
		private var StartSuccess:Boolean = true;
		/*dữ liệu lấy từ cache*/
		private var cacheId:int = 1;
		private var cacheState:Boolean;
		private var cacheTimeType:int = -1;
		private var cacheIntensityType:int = -1;
		private var IdTabDisable:int = -1;
		private var IdTabStart:int=-1;
		
		
		public function GUITrainingTower(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUITrainingTower";
			fmBlack = new TextFormat("Arial", 14);
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				IsInitFinish = false;
				IsDataReady = false;
				var cmd:SendGetStatusTraining = new SendGetStatusTraining();
				Exchange.GetInstance().Send(cmd);
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addBgr();
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 10;
				WaitData.y = img.height / 2 - 10;
				OpenRoomOut();
			}
			LoadRes("GuiTraining_Theme");
		}
		
		private function addBgr():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 704, 19);
			//add vào các slot
			//var x:int = 395, y:int = 245;
			var x:int = 420, y:int = 245;
			var i:int, j:int;
			for (i = 0; i < 2; i++)
			{
				for (j = 0; j < 3; j++)
				{
					AddImage("", "GuiTraining_ImgSlotGift", x, y + YBUFF);
					x += 100;
				}
				//y = 322; x = 395;
				y = 322; x = 420;
			}
			//add vào 2 quà chắc chắn
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Điểm ngư mạch";
			var giftMeridian:ButtonEx = AddButtonEx("", "GuiTraining_ImgMeridianGift", 400, 215 + YBUFF);
			giftMeridian.setTooltip(tip);
			tip = new TooltipFormat();
			tip.text = "Điểm chiến công";
			var giftRank:ButtonEx = AddButtonEx("", "GuiTraining_ImgRank", 500, 222 + YBUFF);
			giftRank.setTooltip(tip);
			
			//add vào text thời gian và cường độ.
			var tf:TextField;
			fmBlack.align = TextFormatAlign.JUSTIFY;
			tf = AddLabel("Thời gian", 333, 368 + YBUFF);
			tf.setTextFormat(fmBlack);
			tf = AddLabel("Cường độ", 333, 402 + YBUFF);
			tf.setTextFormat(fmBlack);
			
			/*thêm vào dòng text thông báo diễn ra sự kiện*/
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var beginTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["BeginTime"];
			var endTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["ExpireTime"];
			
			if (curTime<endTime&&curTime>beginTime)
			{
				var multi:int = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["multi"];
				var date:Date = new Date(beginTime * 1000);
				var begin:String = date.getDate() + "/" + (date.getMonth() + 1);
				date = new Date(endTime * 1000);
				var end:String = date.getDate() + "/" + (date.getMonth() + 1);
				var strNotice:String = "x" + multi + " điểm ngư mạch trong thời gian diễn ra sự kiện từ " + begin + " đến " + end;
				AddLabel(strNotice, 330, 527, 0xffffff, 0, 0x000000);
				AddLabel("x"+multi, 385, 527 - 293, 0xffffff, 0, 0x000000);
			}
		}
		
		override public function EndingRoomOut():void 
		{
			// gửi dữ liệu lên server
			if (IsDataReady)
			{
				initGui();
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var money:int;
			var idRoom:int;
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ItemRoom.CMD_CHANGE_TAB:
					idRoom = int(data[1]);
					//trace("GuiTrainingTower change tab to id = " + idRoom);
					changeRoom(idRoom);
				break;
				case PageRoom.ID_BTN_START:
					//trace("click bắt đầu luyện");
					startTraining();
				break;
				case PageRoom.ID_BTN_STOP:
					//trace("click dừng tập");
					stopTraining();
				break;
				case PageRoom.ID_BTN_SPEEDUP:
					//trace("click tăng tốc với giá " + money);
					money = int(data[1]);
					var isMoney:Boolean = false;//(int(data[2]) == 1);
					speedUpTraining(money, isMoney);
				break;
				case PageRoom.ID_BTN_MERIDIAN:
					//trace("click ngư mạch");
					var soldier:FishSoldier = curPage.curSoldier;
					GuiMgr.getInstance().guiMeridian.showGUI(soldier);
				break;
				case PageRoom.ID_BTN_RECEIVE:
					//trace("click nhận thưởng");
					receiveGift();
				break;
				case ItemRoom.CMD_UNLOCK_ROOM:
					idRoom = int(data[1]);
					money = int(data[2]);
					unlockRoom(idRoom,money);
					//trace("unlock phong " + idRoom + " với số tiền " + money);
				break;
			}
		}
		public function updateMeridianForCurrentSoldier():void
		{
			curPage.updateMeridianForCurrentSoldier();
		}
		private function stopTraining():void 
		{
			var msg:String = "Dừng luyện bạn sẽ không nhận được phần thưởng\nBạn có muốn dừng không?";
			GuiMgr.getInstance().GuiMessageBox.ShowConfirmStopTraining(msg);
		}
		
		private function receiveGift():void 
		{
			/*send dữ liệu lên server*/
			var room:Room = curPage.room;
			var roomId:int = curPage.room.RoomId;
			var pk:SendGetGiftTraining = new SendGetGiftTraining(roomId);
			Exchange.GetInstance().Send(pk);
			
			//hiện gui nhận thưởng
			guiGift.initData(room.GiftList);
			guiGift.Show(Constant.GUI_MIN_LAYER, 5);
			//cập nhật meridian và rankpoint cho con cá
			
			curPage.receiveGift();
			room.StartTime = 0;												//chuyển trạng thái về IDLE
			room.GiftList.splice(0, room.GiftList.length);					//giải phóng mảng gift
			TrainingMgr.getInstance().transferTrainingToIdle(room.SoldierId);//chuyển con cá sang mảng rỗi
			curPage.activeId = room.SoldierId;
			curPage.initPage();
			
			var curItemRoom:ItemRoom = ListItemRoom[room.RoomId - 1] as ItemRoom;
			curItemRoom.State = ItemRoom.STATE_SELECTED;
			curItemRoom.drawItem();
			TrainingMgr.getInstance().hasUpdate = true;
		}
		
		private function unlockRoom(idRoom:int, money:int):void 
		{
			/*kiểm tra đã mở phòng trước đó*/
			if (idRoom > 2) {
				var preRoomId:int = idRoom - 1;
				var preRoom:Room = TrainingMgr.getInstance().getRoomById(preRoomId);
				if (preRoom.State == Room.STATE_LOCK) {
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn chưa mở phòng trước đó");
					return;
				}
			}
			var user:User = GameLogic.getInstance().user;
			var myMoney:int = user.GetZMoney();
			if (money > myMoney) {
				GuiMgr.getInstance().GuiNapG.Init();
			}
			else {
				/*gửi dữ liệu lên server*/
				UnlockSuccess = false;
				var pk:SendUnlockRoom = new SendUnlockRoom();
				Exchange.GetInstance().Send(pk);
				user.UpdateUserZMoney(0 - money);
				var unlockedItem:ItemRoom = ListItemRoom[idRoom - 1] as ItemRoom;
				unlockedItem.unlockItem();
				if (idRoom < MAXNUMROOM)
				{
					var nextItemRoom:ItemRoom = ListItemRoom[idRoom] as ItemRoom;
					nextItemRoom.btnTab.enable = false;
				}
				IdTabDisable = idRoom;
			}
		}
		
		public function unlockSuccess():void {
			UnlockSuccess = true;
			if (IdTabDisable < MAXNUMROOM)
			{
				var itemDisable:ItemRoom = ListItemRoom[IdTabDisable] as ItemRoom;
				itemDisable.btnTab.enable = true;
			}
			var justUnlockItem:ItemRoom = ListItemRoom[IdTabDisable - 1] as ItemRoom;
			if (cacheId == justUnlockItem.room.RoomId)
			{
				curPage.btnStart.enable = true;
			}
			IdTabDisable = -1;
			TrainingMgr.getInstance().hasUpdate = true;
		}
		
		private function speedUpTraining(money:int, isMoney:Boolean):void 
		{
			var myMoney:Number;
			var user:User = GameLogic.getInstance().user;
			if (isMoney)
			{
				myMoney = user.GetMoney();
			}
			else {
				myMoney = user.GetZMoney();
			}
			if (money > myMoney)//số tiền phải trả lớn hơn số tiền của người chơi
			{
				if (!isMoney) {
					GuiMgr.getInstance().GuiNapG.Init();
				}
				else {
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ vàng");
				}
			}
			else //đủ tiền
			{
				if (isMoney) {
					user.UpdateUserMoney(0 - money);
				}
				else {
					user.UpdateUserZMoney(0 - money);
				}
				/*thực hiện việc tua ảo*/
				var room:Room = curPage.room;
				curPage.isFinishPlusMeridian = false;
				curPage.isFinishPlusRankPoint = false;
				var curItemRoom:ItemRoom = ListItemRoom[room.RoomId - 1] as ItemRoom;
				/*gửi dữ liệu lên server*/
				curPage.btnSpeedUp.SetDisable();// = false;// SetVisible(false);
				//curPage.tfPriceSpeedUp.visible = false;
				curPage.btnStop.SetDisable();
				var pk:SendSpeedUpTraining = new SendSpeedUpTraining(room.RoomId);
				Exchange.GetInstance().Send(pk);
				TrainingMgr.getInstance().SpeedUpNum++;
				curPage.updateTimeToTraing();
				curItemRoom.room.inSeek = true;
			}
		}
		
		private function startTraining():void 
		{
			if (TrainingMgr.getInstance().ListIdleSoldier.length == 0)
			{
				return;
			}
			var room:Room = curPage.room;
			//lấy giá luyện
			if (curPage.curSoldier.timeToTraining < room.TimeTrain) {
				var posStart:Point = new Point(487, 466);
				posStart = img.localToGlobal(posStart);
				var posEnd:Point = new Point(487, 426);
				posEnd = img.localToGlobal(posEnd);
				var str:String = "không thể luyện ở chế độ này";
				//var fm:TextFormat = new TextFormat("arial", 12, 0xFFFF00);
				Ultility.ShowEffText(str, curPage.btnStart.img, posStart, posEnd);
				return;
			}
			if (!subMoneyStart2()) 
			{
				return;
			}
			
			curPage.isFinishPlusMeridian = false;
			curPage.isFinishPlusRankPoint = false;
			StartSuccess = false;
			var fs:FishSoldier = TrainingMgr.getInstance().getSoldierFromIdleList(room.SoldierId);
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var isExpired:Boolean = TrainingMgr.getInstance().checkExpireFish(fs, curTime);
			if (isExpired) {
				//var nameFish:String = TrainingMgr.getInstance().getNameSoldier(room.SoldierId);
				GuiMgr.getInstance().GuiMessageBox.ShowOK("cá của bạn đã hết hạn\nBạn chọn cá lính khác nhé!");
				return;
			}
			var priceType_time:String = curPage.room.TimePayType;// curPage.priceType_time;
			var priceType_intensity:String = curPage.room.IntensityPayType;// curPage.priceType_intensity;
			var pk:SendStartTrainingTower = new SendStartTrainingTower(room.RoomId,
																		room.SoldierId,
																		room.LakeId,
																		room.TimeType,
																		room.IntensityType,
																		priceType_time,
																		priceType_intensity);
			Exchange.GetInstance().Send(pk);
			//lấy thời gian bắt đầu luyện
			room.StartTime = GameLogic.getInstance().CurServerTime;
			TrainingMgr.getInstance().transferIdleToTraining(room.SoldierId);
			IdTabStart = room.RoomId;
			var itemRoom:ItemRoom = ListItemRoom[IdTabStart - 1] as ItemRoom;
			itemRoom.drawItem();
			curPage.curSoldier.timeToTraining -= curPage.room.TimeTrain;
			curPage.initPage();
			curPage.btnSpeedUp.enable = false;
			curPage.btnStop.enable = false;
			
			curPage.markTimeRank = room.StartTime;
			curPage.markTimeMeridian = room.StartTime;
			
			
		}
		
		
		public function subMoneyStart2():Boolean 
		{
			var user:User = GameLogic.getInstance().user;
			var myGold:Number = user.GetMoney();
			var myXu:int = user.GetZMoney();
			var myDiamond:int = user.getDiamond();
			var gold:int = curPage.moneyIntensity + curPage.moneyTime;
			var xu:int = curPage.zmoneyIntensity + curPage.zmoneyTime;
			var diamond:int = curPage.diamondTime + curPage.diamondIntensity;
			if (xu == 0) {
				if (gold == 0) {
					if (diamond == 0)
					{
						return true;//Miễn phí
					}
					else 
					{
						if (diamond > myDiamond)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ Kim cương", 310, 200, 1);
							return false;
						}
						else {
							user.updateDiamond(0 - diamond);
							return true;
						}
					}
				}
				else {//không bao h rơi vào trường hợp này
					if (gold > myGold) {
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền vàng", 310, 200, 1);
						return false;
					}
					else {
						user.UpdateUserMoney(0 - gold, true);
						return true;
					}
				}
			}
			else {
				if (gold == 0) {
					if (xu > myXu) {
						GuiMgr.getInstance().GuiNapG.Init();
						return false;
					}
					else {
						if (diamond == 0)
						{
							user.UpdateUserZMoney(0 - xu, true);
							return true;
						}
						else 
						{
							if (diamond > myDiamond)
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ Kim cương", 310, 200, 1);
								return false;
							}
							else
							{
								user.UpdateUserZMoney(0 - xu, true);
								user.updateDiamond(0 - diamond);
								return true;
							}
						}
					}
				}
				else {//không bao giờ rơi vào trường hợp này
					if (gold > myGold) {
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền vàng", 310, 200, 1);
						return false;
					}
					if (xu > myXu) {
						GuiMgr.getInstance().GuiNapG.Init();
						return false;
					}
					user.UpdateUserZMoney(0 - xu, true);
					user.UpdateUserMoney(0 - gold, true);
					return true;
				}
			}
		}
		public function startSuccess(data:Object, oldData:Object):void
		{
			StartSuccess = true;
			var oldCmd:SendStartTrainingTower = oldData as SendStartTrainingTower;
			var oldRoomId:int = oldCmd.RoomId;
			var oldRoom:Room = TrainingMgr.getInstance().getRoomById(oldRoomId);
			oldRoom.GiftList = data["GiftList"];
			if (oldRoomId == cacheId) {
				//if (curPage.hasSpeedUp())
				//{
					curPage.btnSpeedUp.enable = true;
				//}
				
				curPage.btnStop.enable = true;
			}
			TrainingMgr.getInstance().hasUpdate = true;
			var myId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var so:SharedObject = SharedObject.getLocal("CachedRoom" + myId);
			var data:Object = new Object();
			for (var i:int = 0; i < 4; i++)
			{
				var room:Room = listRoom[i] as Room;
				if (room.State == Room.STATE_TRAIN)
				{
					data[room.RoomId] = new Object();
					data[room.RoomId]["TimePayType"] = room.TimePayType;
					data[room.RoomId]["IntensityPayType"] = room.IntensityPayType;
				}
			}
			so.data.uId = data;
		}
		
		public function processData(data1:Object):void 
		{
			curPage = new PageRoom(this.img, "KhungFriend");	//tạo ra 1 cái page để vẽ dữ liệu về
			curPage.IdObject = "PageRoom";
			curPage.EventHandler = this;
			curPage.initBoxTime();								//khởi tạo dữ liệu cho các combobox
			curPage.countDeltaTime();
			IsDataReady = true;
			if (!isInitedListRoom)
			{
				initListRoom();
				isInitedListRoom = true;
			}
			updateListRoom(data1);
			if (IsFinishRoomOut){
				initGui();
			}
		}
		
		/**
		 * reference to general listRoom (tham chiếu đến listroom chung)
		 */
		private function initListRoom():void 
		{
			listRoom = TrainingMgr.getInstance().ListRoom;
		}
		
		private function updateListRoom(data1:Object):void 
		{
			TrainingMgr.getInstance().updateListRoom(data1);
		}
		
		private function initGui():void 
		{
			if (!bCheckCookies)
			{
				checkCookies();
			}
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			_timeGui = GameLogic.getInstance().CurServerTime;
			inSeek = false;
			addAllItemRoom();									//vẽ ra các tab là các itemRoom
			var room:Room = TrainingMgr.getInstance().getRoomById(cacheId);
			curPage.room = room;								//vẽ ra page hiện tại
			curPage.timePage = _timeGui;
			IsInitFinish = true;
		}
		
		private function addAllItemRoom():void 
		{
			var i:int;
			var x:int = 60, y:int = 87;
			//var leng:int = listRoom.length;
			var leng:int = TrainingMgr.getInstance().ListRoom.length;
			for (i = 0; i < leng; i++)
			{
				var roomId:int = i + 1;
				var room:Room = TrainingMgr.getInstance().getRoomById(roomId);
				addItemRoom(room, x, y);
				x += 158;
			}
		}
		
		private function addItemRoom(room:Room, x:int, y:int):void 
		{
			var itemRoom:ItemRoom = new ItemRoom(this.img, "KhungFriend");
			itemRoom.initData(room, _timeGui);
			itemRoom.IdObject = "TabRoom_" + room.RoomId;
			itemRoom.EventHandler = this;
			itemRoom.VirtualTime = _timeGui;
			if (room.RoomId == cacheId)
			{
				itemRoom.State = ItemRoom.STATE_SELECTED;
			}
			else
			{
				itemRoom.State = ItemRoom.STATE_UNSELECTED;
			}
			itemRoom.drawItem();
			itemRoom.img.x = x;
			itemRoom.img.y = y;
			ListItemRoom.push(itemRoom);
		}
		
		//override public function Hide():void 
		//{
			//ghi lại vào cookie những thứ như: phòng hiện tại, trạng thái phòng hiện tại, kiểu thời gian , kiểu cường độ phòng hiện tại
			//var myId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			//var so:SharedObject = SharedObject.getLocal("CachedRoom" + myId);
			///*lưu lại các thông số*/
			//var data:Object = new Object();
			//for (var i:int = 0; i < 4; i++)
			//{
				//var room:Room = listRoom[i] as Room;
				//if (room.State == Room.STATE_TRAIN)
				//{
					//data[room.RoomId] = new Object();
					//data[room.RoomId]["TimePayType"] = room.TimePayType;
					//data[room.RoomId]["IntensityPayType"] = room.IntensityPayType;
				//}
			//}
			//so.data.uId = data;
			//
			//super.Hide();
		//}
		
		override public function ClearComponent():void 
		{
			if(curPage)
				curPage.Clear();
			super.ClearComponent();
			for (var i:int = 0; i < ListItemRoom.length; i++)
			{
				var itemRoom:ItemRoom = ListItemRoom[i] as ItemRoom;
				itemRoom.Clear();
			}
			ListItemRoom.splice(0, ListItemRoom.length);
		}
		
		/**
		 * chuyển tab này sang tab khác
		 * @param	roomId
		 */
		public function changeRoom(roomId:int):void
		{
			/*kiểm tra các trường hợp không hợp lệ*/
			if (cacheId == roomId)/*TH1: preRoomId == roomId*/
			{
				return;
			}
			else
			{
				var room:Room = TrainingMgr.getInstance().getRoomById(roomId);
				var itemRoom:ItemRoom = ListItemRoom[roomId - 1] as ItemRoom;
				var curItRoom:ItemRoom = ListItemRoom[cacheId - 1]as ItemRoom;
				//trace("curItemRoom.room.RoomId = " + curItRoom.room.RoomId);
				if (room.State == Room.STATE_LOCK)/*TH2: phòng bị khóa*/
				{
					return;
				}
				else/*các trường hợp hợp lệ*/
				{
					//b1:thay đổi trạng thái của preRoom và curRoom (preRoom sẽ tối đi, curRoom sẽ sáng lên)
					curItRoom.State = ItemRoom.STATE_UNSELECTED;
					curItRoom.deSelected();
					itemRoom.State = ItemRoom.STATE_SELECTED;
					itemRoom.selected();
					//b2: thay đổi page = con cá+ điểm của con cá+ quà+ giá các comboitem
					curPage.room = room;
					if (!UnlockSuccess) {//trong lúc gửi nhận gói unlock mà chuyển tab 2 lần unlock -> changetab -> changetab(tab cũ)
						if (cacheId == IdTabDisable)
						{
							curPage.btnStart.enable = false;
						}
					}
					if (!StartSuccess) {//trong lúc gửi nhận gói start mà chuyển tab
						if (cacheId != IdTabStart)
						{
							curPage.btnStop.enable = true;
							//if (curPage.hasSpeedUp()) {
								curPage.btnSpeedUp.enable = true;
							//}
						}
						else {
							curPage.btnStop.enable = false;
							curPage.btnSpeedUp.enable = false;
						}
					}
					curPage.timePage = _timeGui;
					cacheId = roomId;
				}
			}
		}
		
		public function updateGUI():void 
		{
			if (IsInitFinish)
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				updateAllPage(curTime);
			}
		}
		
		public function stopOk():void 
		{
			var pk:SendStopTraining = new SendStopTraining(cacheId);
			Exchange.GetInstance().Send(pk);
			/*reset phòng về trạng thái nhàn rỗi*/
			var room:Room = TrainingMgr.getInstance().getRoomById(cacheId);
			TrainingMgr.getInstance().transferTrainingToIdle(room.SoldierId);
			room.StartTime = 0;
			room.SoldierId = -1;
			curPage.room = room;
			var curItemRoom:ItemRoom = ListItemRoom[cacheId - 1] as ItemRoom;
			curItemRoom.drawItem();
		}
		
		private function updateAllPage(curTime:Number):void 
		{
			var isSetTimeGui:Boolean = false;
			for (var i:int = 0; i < ListItemRoom.length; i++)
			{
				var itemRoom:ItemRoom = ListItemRoom[i] as ItemRoom;
				var isUpdated:Boolean = (itemRoom.room.State == Room.STATE_TRAIN);
				
				if (isUpdated)
				{
					if (cacheId == itemRoom.room.RoomId) {
						var room:Room = curPage.room;
						//if (!inSeek) {
							curPage.updateProgessbarClock(curTime);
						//}
						//else {
							
						//}
					}
					
					var tickcount:Number = curTime - _timeGui;
					var inSeek:Boolean = itemRoom.room.inSeek;
					if (inSeek)
					{
						if (tickcount >= FASTTIME)
						{
							itemRoom.VirtualTime += itemRoom.room.TimeType;
							updateTime(itemRoom, itemRoom.VirtualTime);
							isSetTimeGui = true;
						}
					}
					else
					{
						if (tickcount >= NORMALTIME)
						{
							updateTime(itemRoom, curTime);
							isSetTimeGui = true;
						}
					}
				}
			}
			if (isSetTimeGui)
			{
				_timeGui = curTime;
			}
		}
		
		private function updateTime(itemRoom:ItemRoom, time:Number):void 
		{
			itemRoom.updateItem(time);
			if (cacheId == itemRoom.room.RoomId)
			{
				curPage.updatePage(time);
			}
		}
		
		private function checkCookies():void
		{
			
			//lấy về thứ tự tab trước đó đã mở => khi mà tắt đi 
			var myId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var so:SharedObject = SharedObject.getLocal("CachedRoom" + myId);
			var data:Object;
			var room:Room;
			if (so.data.uId != null)//đã từng mở gui và chọn tab
			{
				data = so.data.uId;
				for (var str:String in data)
				{
					room = listRoom[int(str) - 1] as Room;
					room.TimePayType = data[str]["TimePayType"];
					room.IntensityPayType = data[str]["IntensityPayType"];
				}
			}
			else// chưa mở gui tab lần nào trong đời, và đây là lần đầu
			{
				room = listRoom[0] as Room;
				room.TimePayType = "Free";
				room.IntensityPayType = "Free";
			}
			
			cacheId = 1;
			cacheState = false;
			cacheTimeType = 15;
			cacheIntensityType = 1;
			bCheckCookies = true;
		}
	}

}




















