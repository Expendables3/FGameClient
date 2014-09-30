package Event.EventMidAutumn 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import Event.EventMidAutumn.EventPackage.SendBuyItemEventMidMoon;
	import Event.EventMidAutumn.EventPackage.SendUseFan;
	import Event.EventMidAutumn.ItemEvent.EventItemInfo;
	import Event.EventMidAutumn.ItemEvent.ItemEvent;
	import Event.EventMidAutumn.ItemEvent.Lantern;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.GUIFeedWall;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.BasePacket;
	
	/**
	 * Hiển thị ở phía trên GUI BackGround của Đông
	 * điều khiển mọi action của lồng đèn
	 * @author HiepNM2
	 */
	public class GuiFrontScreenEvent extends GUIGetStatusAbstract 
	{
		//const
		static public var bNextDay:Boolean;
		private const objBuyFuel:Object = {"PaperBurn":1, "GasCan":1, "SpaceCraft":1};
		private const TIME_TO_DELAY:int = 2;
		private const ID_BTN_STORE:String = "IdBtnStore";
		private const ID_BTN_COLLECT:String = "IdBtnCollect";
		private const ID_BTN_BUY:String = "idBtnBuy";
		private const ID_BTN_REMIND:String = "idBtnRemind";
		private const CMD_SELECT:String = "cmdSelect";
		private const CMD_GAS:String = "cmdGas";
		private const CMD_SPACE:String = "cmdSpace";
		private const ID_BTN_SHOP:String = "idBtnShop";
		private const ID_BTN_GUIDE:String = "idBtnGuide";
		
		// gui
		private var btnShop:Button;
		private var btnGuide:Button;
		private var btnCollect:Button;
		private var btnRemind:Button;
		private var _lantern:Lantern;
		private var _listItemEvent:Object;		//list tất cả những itemEvent xuất hiện trong gui này
		private var _objBuyFuel:Object;			//list những item đốt để tên lửa bay lên
		private var _fan:AbstractGift;			//chong chong
		private var _objCollection:Object;		//list những item Collection
		private var _listItemBuy:Object;		//list những item cần mua => batch lại thành 1 rồi gửi lên cho gọn
		private var isUpdateForBuy:Boolean;
		private var timeBuy:Number;
		private var _isBuying:Boolean = false;	//đang mua
		private var _typeFire:String;
		
		//public var inDropLantern:Boolean = false;
		public var inTween:Boolean = false;
		private var timeLockTween:Number;
		private var mc:Sprite;					//mc tween
		private var lastPlayDate:String;
		//private var isUpdatePaper:Boolean = false;
		
		//logic
		public var dataStore:Object;//dữ liệu lấy từ initRun: Store->StoreList->EventItem->MidMoon va 
		public function GuiFrontScreenEvent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiFrontScreenEvent";
			_imgThemeName = "KhungFriend";
			//IsExternSend = true;			//gói tin lấy status được gửi từ GUI khác (GUI của Đông)
			//IsExternDataReady = true;
		}
		
		/**
		 * khởi tạo GUI trước server
		 */
		override protected function onInitGuiBeforeServer():void 
		{
			SetPos(0, 0);
			AddImage("", "EventMidAutumn_ImgConner", 812, 627, true, ALIGN_RIGHT_BOTTOM);
			btnCollect = AddButton(ID_BTN_COLLECT, "EventMidAutumn_BtnCollection", 647, 37);
			btnCollect.setTooltipText(Localization.getInstance().getString("EventMidAutumn_TipBtnCollection"));
			//btnShop = AddButton(ID_BTN_SHOP, "EventMidAutumn_BtnShopFuel", 700, 89);
			btnGuide = AddButton(ID_BTN_GUIDE, "EventMidAutumn_BtnGuide", 612, 42);
			btnGuide.setTooltipText(Localization.getInstance().getString("EventMidAutumn_TipBtnGuide"));
			//img.mouseEnabled = false;
			_lantern = new Lantern(this.img, "EventMidAutumn_LanternIdle", 368, 425);
		}
		
		//override protected function onGetReadyData():void 
		protected function onGetReadyData():void 
		{
			var data:Object = new Object();
			data["Lantern"] = GuiMgr.getInstance().guiBackGround.eventData["MidMoon"];
			if (!IsDataReady)
			{
				data["DataStore"] = dataStore;
			}
			processData(data);
		}
		/**
		 * khởi tạo dữ liệu cho GUI
		 * @param	data1 : dữ liệu được tách ra từ gói getStatus (lấy về ở chỗ Đông)
		 */
		override protected function onInitData(data1:Object):void 
		{
			initEventStore(data1["DataStore"]);
			initLanternData(data1["Lantern"]);
		}
		/**
		 * Khởi tạo dữ liệu từ kho
		 * @param	dataStore : dữ liệu từ Store
		 */
		public function initEventStore(dataStore:Object):void
		{
			if (dataStore)
			{
				var itm:String;
				var str:String;
				for (itm in dataStore)
				{
					if (itm == "Collection")//lấy dữ liệu cho bộ sưu tập
					{
						for (str in dataStore["Collection"])
						{
							_objCollection[int(str)]["Num"] = dataStore[itm][str];
						}
					}
					else
					{
						for (str in dataStore[itm])
						{
							if (itm in objBuyFuel)		//nhiên liệu đốt phải mua
							{
								_objBuyFuel[itm]["Num"] = dataStore[itm][str];
							}
							else if (itm == "Propeller")	//chong chóng
							{
								_fan["Num"] = dataStore[itm][str];
							}
						}
					}
				}
			}
		}
		/**
		 * khởi tạo dữ liệu cho cái đèn lồng
		 */
		public function initLanternData(dataLantern:Object):void
		{
			/*khoi tao du lieu cho den long*/
			_lantern.X = dataLantern["Lantern"]["X"];
			_lantern.Blood = dataLantern["Lantern"]["Healthy"];
			_lantern.NumMagnet = dataLantern["Lantern"]["NumUse_Magnetic"];
			_lantern.NumArmor = dataLantern["Lantern"]["NumUse_Protector"];
			_lantern.NumSpeed = dataLantern["Lantern"]["NumUse_Speeduper"];
			lastPlayDate = dataLantern["LastPlayDate"];
		}
		/**
		 * khởi tạo cái gui sau server
		 */
		override protected function onInitGuiAfterServer():void 
		{
			var itemEvent:AbstractItemGift;
			var info:AbstractGift;
			var price:int;
			_listItemEvent = new Object();
			
			//giấy
			info = _objBuyFuel["PaperBurn"];
			itemEvent = new ItemEvent(this.img, "KhungFriend", 770, 438);
			itemEvent.IdObject = CMD_SELECT + "_" + info["ItemType"];
			itemEvent["HasTooltipText"] = true;
			itemEvent.EventHandler = this;
			itemEvent.initData(info, "EventMidAutumn_ImgFuelSlot");
			itemEvent.drawGift();
			_typeFire = info["ItemType"];
			_listItemEvent[info["ItemType"]] = itemEvent;
			AddButton(itemEvent.IdObject, "EventMidAutumn_BtnFire", 749, 483);
			
			//can xăng
			info = _objBuyFuel["GasCan"];
			itemEvent = new ItemEvent(this.img, "KhungFriend", 732, 550);
			itemEvent.IdObject = CMD_SELECT + "_" + info["ItemType"];
			itemEvent["HasTooltipText"] = true;
			itemEvent.EventHandler = this;
			itemEvent.initData(info, "EventMidAutumn_ImgFuelSlot");
			itemEvent.drawGift();
			_listItemEvent[info["ItemType"]] = itemEvent;
			AddButton(itemEvent.IdObject, "EventMidAutumn_BtnFire", 707, 598);
			
			//tên lửa
			info = _objBuyFuel["SpaceCraft"];
			itemEvent = new ItemEvent(this.img, "KhungFriend", 640, 551);
			itemEvent.IdObject = CMD_SELECT + "_" + info["ItemType"];
			itemEvent["HasTooltipText"] = true;
			itemEvent.EventHandler = this;
			itemEvent.initData(info, "EventMidAutumn_ImgFuelSlot");
			itemEvent.drawGift();
			_listItemEvent[info["ItemType"]] = itemEvent;
			AddButton(itemEvent.IdObject, "EventMidAutumn_BtnFire", 615, 598);
			
			//chong chóng
			info = _fan;
			itemEvent = new ItemEvent(this.img, "KhungFriend", 764, 303);
			itemEvent.IdObject = CMD_SELECT + "_" + info["ItemType"];
			itemEvent["HasTooltipText"] = true;
			itemEvent.EventHandler = this;
			itemEvent.initData(info, "EventMidAutumn_ImgPropellerSlot");
			itemEvent.drawGift();
			_listItemEvent[info["ItemType"]] = itemEvent;
			price = info[info["TypeMoney"]];
			addRemindFriend(728, 350, price, "Propeller");
			
			//lồng đèn
			if (_lantern.High == 0  && !_lantern.isDrop)
			{
				_lantern.LoadRes("EventMidAutumn_GenieHoldFish");
				_lantern.SetPos(278, 420);
			}
			else
			{
				_lantern.LoadRes("EventMidAutumn_LanternIdle");
				_lantern.SetPos(368, 350);
				_lantern.draw();
			}
		}
		
		private function addRemindFriend(x:int, y:int, price:int, type:String):void 
		{
			var btnBuy:Button;
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("EventMidAutumn_PressRemind" + GameLogic.getInstance().user.GetMyInfo().Id);
			var data:Object;
			if (so.data.uId != null)//đã feed nhờ bạn ít nhất 1 lần
			{
				data = so.data.uId;
				if (data.lastday != today)//chưa feed nhờ bạn hôm nay
				{
					//trace("thêm nút nhờ bạn ---- chưa feed hôm nay");
					btnRemind = AddButton(ID_BTN_REMIND, "EventMidAutumn_BtnRemind", x, y);
				}
				else//đã feed nhờ bạn hôm nay
				{
					//trace("thêm nút mua ---- đã feed hôm nay");
					btnBuy = AddButton(ID_BTN_BUY + "_" + type + "_1_" + price, "EventMidAutumn_BtnBuy", x, y);
					AddLabel(Ultility.StandardNumber(price), x - 5, y, 0xFFFFFF, 1, 0x000000);
				}
			}
			else//chưa feed nhờ bạn lần nào trong đời
			{
				btnRemind = AddButton(ID_BTN_REMIND, "EventMidAutumn_BtnRemind", x, y);
				//trace("thêm nút nhờ bạn ---- chưa feed lần nào trong đời");
			}
			
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (EventMgr.CheckEvent("MidMoon") != EventMgr.CURRENT_IN_EVENT)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("EventMidAutumn_TipFinishEvent"), 
															310, 200, 1);
				return;
			}
			if (/*inDropLantern ||*/ _lantern.isMoving || inTween || _lantern.inTransform)
			{
				return;
			}
			var dataBtn:Array = buttonID.split("_");
			var cmd:String = dataBtn[0];
			var type:String;
			switch(cmd)
			{
				case ID_BTN_STORE:
					sendAllBuyAction();
					//show gui quà tích lũy
				break;
				case ID_BTN_COLLECT:
					sendAllBuyAction();
					GuiMgr.getInstance().guiEventCollection.Show(Constant.GUI_MIN_LAYER, 5);
				break;
				case ID_BTN_SHOP:
					sendAllBuyAction();
					GuiMgr.getInstance().guiQuickBuyFuel.Show(Constant.GUI_MIN_LAYER, 5);
				break;
				case ID_BTN_GUIDE:
					sendAllBuyAction();
					GuiMgr.getInstance().guiGuideEvent.Show(Constant.GUI_MIN_LAYER, 5);
				break;
				
				case ID_BTN_BUY:
					type = dataBtn[1];
					var id:int = int(dataBtn[2]);
					var zmoney:int = int(dataBtn[3]);
					buyItem(type, id, zmoney);
					break;
				case ID_BTN_REMIND:
					remindFriend();
					break;
				case CMD_SELECT:
					type = dataBtn[1];
					//check lên đến độ cao cực đại
					if (_lantern.High == ConfigJSON.getInstance().getItemInfo("Param")["MidMoon"]["MissMoonHome"])
					{
						var xText:int;
						if (type == "PaperBurn" || type=="Propeller")
						{
							xText = (_listItemEvent[type] as ItemEvent).img.x - 20;
						}
						else
						{
							xText = (_listItemEvent[type] as ItemEvent).img.x;
						}
						var posStart:Point = new Point(xText, (_listItemEvent[type] as ItemEvent).img.y);
						posStart = img.localToGlobal(posStart);
						var posEnd:Point = new Point(xText, (_listItemEvent[type] as ItemEvent).img.y - 40);
						posEnd = img.localToGlobal(posEnd);
						var strNotice:String = Localization.getInstance().getString("EventMidAutumn_HighMaxNotice");
						Ultility.ShowEffText(strNotice, (_listItemEvent[type] as ItemEvent).img, posStart, posEnd);
						return;
					}
					//check qua ngày
					var curTime:Number = GameLogic.getInstance().CurServerTime;
					var date:Date = new Date(curTime * 1000);
					var month:int = date.month + 1;
					var sMonth:String = month < 10 ? "0" + month : month.toString();
					var sDay:String = date.date < 10 ? "0" + date.date : date.date.toString();
					var sDate:String = date.fullYear.toString() + sMonth + sDay;
					if (sDate != lastPlayDate)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("EventMidAutumn_TipNextDay"), 310, 200, 1);
						return;
					}
					//check dùng chong chóng
					if (type == "Propeller")
					{
						GameLogic.getInstance().MouseTransform("EventMidAutumn_" + type + "1", 0.7, 0, -35, -20);
						Mouse.hide();
						return;
					}
					if (_typeFire != type)
					{
						(_listItemEvent[type] as ItemEvent).selected();
						(_listItemEvent[_typeFire] as ItemEvent).unSelected();
						_typeFire = type;
					}
					sendAllBuyAction();
					if (getNumItemEvent(type) == 0)
					{
						GuiMgr.getInstance().guiQuickBuyOneFuel.setData(type);
						GuiMgr.getInstance().guiQuickBuyOneFuel.Show(Constant.GUI_MIN_LAYER, 5);
						return;
					}
					if (_lantern.Blood == 0)
					{
						GuiMgr.getInstance().guiRebornLantern.Show(Constant.GUI_MIN_LAYER, 5);
						return;
					}
					if (!inTween)
					{
						GuiMgr.getInstance().guiBackGround.setPosition(_lantern.High);
						inTween = true;
						mc = ResMgr.getInstance().GetRes("EventMidAutumn_" + type + "1") as Sprite;
						this.img.addChild(mc);
						mc.rotationX = 180;
						mc.x = (_listItemEvent[type] as ItemEvent).img.x;
						mc.y = (_listItemEvent[type] as ItemEvent).img.y;
						var xDes:int = _lantern.img.x + 65;
						var yDes:int = _lantern.img.y + 170;
						if (_lantern.High == 0 && !_lantern.isDrop)
						{
							xDes += 77;
						}
						var xMid:int = (mc.x + xDes) / 2;
						var yMid:int = (mc.y + yDes) / 2 - 90;
						if ((_listItemEvent[type] as ItemEvent).tooltipText.IsVisible)
						{
							(_listItemEvent[type] as ItemEvent).tooltipText.Hide();
						}
						timeLockTween = GameLogic.getInstance().CurServerTime;
						TweenMax.to(mc, 0.8, 
									{ bezierThrough:[ { x:xMid, y:yMid }, { x:xDes, y:yDes } ], 
									orientToBezier:true, 
									scaleX:0.5, scaleY:0.5, 
									alpha:0.5, ease:Expo.easeOut} );
					}
					
					break;
			}
		}
		/**
		 * mua vật phẩm trong event
		 * @param	type : loại vật phẩm
		 * @param	id  : id của vật phẩm
		 * @param	zmoney : giá của vật phẩm
		 */
		private function buyItem(type:String, id:int, price:int):void 
		{
			var user:User = GameLogic.getInstance().user;
			var typeMoney:String = "ZMoney";
			var myMoney:int;
			if (type == "Propeller")
			{
				typeMoney = _fan["TypeMoney"];
			}
			else if (type in objBuyFuel)
			{
				typeMoney = _objBuyFuel[type]["TypeMoney"];
			}
			if (typeMoney == "Diamond")
			{
				myMoney = user.getDiamond();
				if (myMoney < price)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ kim cương", 310, 200, 1);
					return;
				}
				else
				{
					user.updateDiamond( -price);
				}
			}
			else if (typeMoney == "ZMoney")
			{
				myMoney = user.GetZMoney();
				if (myMoney < price)
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
				else
				{
					user.UpdateUserZMoney( -price);
				}
			}
			
			mergeBuyAction(type, id, 1);
			if (type in objBuyFuel)
			{
				_objBuyFuel[type]["Num"]++;
			}
			else if (type == "Propeller")
			{
				(_fan as EventItemInfo).Num++;
			}
			(_listItemEvent[type] as ItemEvent).refreshTextNum();
			EffectMgr.setEffBounceDown("Mua thành công", "EventMidAutumn_" + type + id, 330, 280);
		}
		
		private function remindFriend():void 
		{
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("EventMidAutumn_PressRemind" + GameLogic.getInstance().user.GetMyInfo().Id);
			var data:Object;
			if (so.data.uId != null)//đã feed nhờ bạn ít nhất 1 lần => chắc chắn có lastday
			{
				data = so.data.uId;
				if (data.lastDay != today)//chưa bấm feed hôm nay
				{
					//trace("hiện guifeed ---- chưa feed hôm nay");
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_REMIND_FRIEND);
				}
			}
			else//chưa feed nhờ bạn lần nào trong đời
			{
				//trace("hiện guifeed ---- chưa feed lần nào trong đời");
				GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_REMIND_FRIEND);
			}
		}
		
		public function changeRemindToBuy():void
		{
			if (btnRemind.img)
			{
				btnRemind.SetVisible(false);
			}
			var price:int = _fan[_fan["TypeMoney"]];
			AddButton(ID_BTN_BUY + "_" + "Propeller_1_" + price, "EventMidAutumn_BtnBuy", 728, 350);
			AddLabel(Ultility.StandardNumber(price), 728, 350, 0xffffff, 1, 0x000000);
		}
		/**
		 * cập nhật Gui tại thời điểm hiện tại
		 * @param	curTime : thời điểm hiện tại
		 */
		override protected function onUpdateGui(curTime:Number):void 
		{
			if (isUpdateForBuy)
			{
				if (curTime - timeBuy > TIME_TO_DELAY)
				{
					sendAllBuyAction();
				}
			}
			if (inTween)
			{
				if (curTime - timeLockTween > 1)
				{
					inTween = false;
					_lantern.clickToFire();
					img.removeChild(mc);
					mc = null;
				}
			}
		}
		
		public function initDataFromConfig():void
		{
			var itm:String, str:String;
			//khởi tạo cho nhiên liệu và chong chóng
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("MidMoon_MoveItem");
			var cfgLookup:Object = ConfigJSON.getInstance().getItemInfo("MidMoon_Lookup");
			var itEvent:AbstractGift;
			_objBuyFuel = new Object();
			for (itm in cfg)//khởi tạo cho nhiên liệu mua được
			{
				for (str in cfg[itm])
				{
					itEvent = new EventItemInfo();
					itEvent["ItemType"] = itm;
					itEvent["ItemId"] = int(str);
					itEvent["Num"] = 0;
					if (itm in objBuyFuel)
					{
						itEvent["MoveStep"] = cfg[itm][str]["MoveStep"];
						itEvent["Diamond"] = cfgLookup["Material"][itm]["Diamond"];
						itEvent["ZMoney"] = cfgLookup["Material"][itm]["ZMoney"];
						itEvent["Gold"] = cfgLookup["Material"][itm]["Gold"];
						_objBuyFuel[itm] = itEvent;
					}
				}
			}
			_fan = new EventItemInfo();	//khởi tạo dữ liệu cho chong chóng
			_fan["ItemType"] = "Propeller";
			_fan["ItemId"] = 1;
			_fan["Num"] = 0;
			_fan["Diamond"] = cfgLookup["Material"]["Propeller"]["Diamond"];
			_fan["ZMoney"] = cfgLookup["Material"]["Propeller"]["ZMoney"];
			_fan["Gold"] = cfgLookup["Material"]["Propeller"]["Gold"];
			
			//khởi tạo dữ liệu cho bộ sưu tập
			_objCollection = new Object();
			for (var i:int = 1; i <= 9; i++)
			{
				itEvent = new EventItemInfo();
				itEvent["ItemType"] = "Collection";
				itEvent["ItemId"] = i;
				itEvent["Num"] = 0;
				_objCollection[i.toString()] = itEvent;
			}
		}
		
		public function sendAllBuyAction():void
		{
			if (_listItemBuy == null)
			{
				return;
			}
			isUpdateForBuy = false;
			var num:int, type:String, id:String, pk:BasePacket, typeMoney:String = "ZMoney";
			for (type in _listItemBuy)
			{
				for (id in _listItemBuy[type])
				{
					num = _listItemBuy[type][id];
					if (type == "Propeller")
					{
						typeMoney = _fan["TypeMoney"];
					}
					else if (type in objBuyFuel)
					{
						typeMoney = _objBuyFuel[type]["TypeMoney"];
					}
					pk = new SendBuyItemEventMidMoon(type, int(id), num, typeMoney);
					Exchange.GetInstance().Send(pk);
					_isBuying = true;
				}
				_listItemBuy[type] = null;//giải phóng luôn
			}
			_listItemBuy = null;
		}
		
		private function mergeBuyAction(itemType:String, itemId:int, num:int):void
		{
			if (_listItemBuy == null)
			{
				_listItemBuy = new Object();
			}
			if (_listItemBuy[itemType] == null)
			{
				_listItemBuy[itemType] = new Object();
				_listItemBuy[itemType][itemId] = 0;
			}
			_listItemBuy[itemType][itemId]+=num;
			
			isUpdateForBuy = true;
			timeBuy = GameLogic.getInstance().CurServerTime;
		}
		
		override public function ClearComponent():void 
		{
			for (var s:String in _listItemEvent)
			{
				_listItemEvent[s].Destructor();
				_listItemEvent[s] = null;
			}
			_listItemEvent = null;
			super.ClearComponent();
		}
		
		public function get TypeFire():String 
		{
			return _typeFire;
		}
		
		public function getNumStep(type:String):int
		{
			return (_objBuyFuel[type] as EventItemInfo).BuffStep;
		}
		
		override public function OnHideGUI():void 
		{
			sendAllBuyAction();
		}
		
		public function useFan(high:int, fromX:int):int 
		{
			sendAllBuyAction();
			var fan:EventItemInfo = _fan as EventItemInfo;
			if (fan.Num <= 0)
			{
				GuiMgr.getInstance().guiQuickBuyOneFuel.setData(fan.ItemType, fan.ItemId);
				GuiMgr.getInstance().guiQuickBuyOneFuel.Show(Constant.GUI_MIN_LAYER, 5);
				return -1;
			}
			//trừ chong chóng
			fan.Num--;
			var itemFan:ItemEvent = _listItemEvent[fan.ItemType] as ItemEvent;
			itemFan.refreshTextNum();
			
			//gửi gói tin
			var toX:int = -1;	//lấy vị trí
			if (fromX == 1 || fromX == 3)
			{
				toX = 2;
			}
			else if (fromX == 2)
			{
				if (Math.random() >= 0.5)
				{
					toX = 3;
				}
				else
				{
					toX = 1;
				}
			}
			var pk:SendUseFan = new SendUseFan(high, fromX, toX);
			Exchange.GetInstance().Send(pk);
			
			return toX;
		}
		
		public function get ListBuyFuel():Object
		{
			return _objBuyFuel;
		}
		public function get Fan():AbstractGift
		{
			return _fan;
		}
		public function get lantern():Lantern 
		{
			return _lantern;
		}
		
		public function set lantern(value:Lantern):void 
		{
			_lantern = value;
		}
		
		public function get ListCollection():Object
		{
			return _objCollection;
		}
		
		public function getNumItemEvent(type:String, id:int = 1):int 
		{
			switch(type)
			{
				case "PaperBurn":
				case "SpaceCraft":
				case"GasCan":
					return _objBuyFuel[type]["Num"];
				case "Propeller":
					return _fan["Num"];
				case "Collection":
					return _objCollection[id.toString()]["Num"];
				default:
					return 0;
			}
		}
		public function updateNumItemEvent(type:String, num:int = 1, id:int = 1):void
		{
			switch(type)
			{
				case "PaperBurn":
				case "SpaceCraft":
				case"GasCan":
					_objBuyFuel[type]["Num"] += num;
				break;
				case "Propeller":
					_fan["Num"] += num;
				break;
				case "Collection":
					_objCollection[id.toString()]["Num"] += num;
				break;
			}
			if (IsVisible && type != "Collection")
			{
				(_listItemEvent[type] as ItemEvent).refreshTextNum();
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_SELECT:
					var type:String = data[1];
					(_listItemEvent[type] as ItemEvent).showTooltipText();
				break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_SELECT:
					var type:String = data[1];
					(_listItemEvent[type] as ItemEvent).showTooltipText(false);
				break;
			}
		}
	}

}































