package GUI.EventLuckyMachine 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.Minigame.MinigameMgr;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftSpecial;
	//import GUI.GUICongrat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.LuckyMachine.SendBuyTicket;
	import NetworkPacket.PacketSend.LuckyMachine.SendPlayLuckyMachine;
	import Sound.SoundMgr;
	
	/**
	 * GUI máy quay sò
	 * @author HiepNM2
	 */
	public class GUIDigritWheel extends BaseGUI 
	{
		/*Attributes*/
		///Constant
		//hằng số logic
		private static const SlotNumber:int = 24;		//số lượng ô
		private static const STRONG_LIGHT:Number = 0xFF0000;//màu sắc xung quanh ô chạy
		private static const SPEED:int = 100;
		private static const SPEEDSLOW:int = 90;
		private static const TIMEGETDATA:int = 2000;
		private static const COUNTMIN:int = 1 * 48;		//thời gian cho nó quay với tốc độ cao, thêm vào cho đẹp
		private static const PAUSEMIN:int = 15;
		//id của các content
		private static const ID_BTN_CLOSE:String = "btnClose";
		private static const ID_BTN_QUAY:String = "btnQuay";
		private static const ID_BTN_QUAYTIEP:String = "btnQuayTiep";
		private static const ID_BTN_RECEIVEGIFT:String = "btnReceiveGift";
		private static const ID_BTN_MUA1:String = "btnMua1";
		private static const ID_BTN_MUA2:String = "btnMua2";
		private static const ID_BTN_MUA3:String = "btnMua3";
		private static const ID_BTN_MUC1:String = "btnMuc1";
		private static const ID_BTN_MUC2:String = "btnMuc2";
		private static const ID_BTN_MUC3:String = "btnMuc3";
		private static const ID_BTN_RECEIVETICKET:String = "btnReceiveTicket";
		private static const ID_IMG_INSIDEWHEEL:String = "imgInsideWheel";
		private static const ID_EFF_CONGRATE:String = "effCongrate";
		private static const ID_IC_HELPER_QUAY:String = "icHelperQuay";
		
		//variables
		//logic
		public var isFirstClick:Boolean = true;			//kiểm tra lần đầu ấn phím nhận thưởng
		private var curIndex1:int;						//chỉ số ô hiện tại đang xét
		private var curGiftType:String;					//loại giải thưởng hiện tại
		private var curGiftLevel:int;					//level của giải hiện tại
		private var curTicketType:String;
		private var state:int;
		private var pauseIndex:int;
		private var isRound1:Boolean = true;			//đang ở vòng quay 1
		private var loopCount:int = 0;
		private var isReceivedData:Boolean = false;		//Người chơi đã nhận thưởng chưa
		private var ItemList:Array = new Array();		//Mảng Item
		private var indexReceive:int;					//giá trị nhận về từ server khi quay xong ==> dựa vào config sẽ biết được loại giải và so sánh với curGiftType để biết xịt hay cộng tiếp vào curGiftLevel
		private var equipment:Object;
		public var Floor:int;							
		private var preFloor:int;							
		private var inFail:Boolean = false;
		//GUI process
		private var tfTurn1:TextField;
		private var tfTurn2:TextField;
		private var tfTurn3:TextField;
		private var curSlot1:ItemSlot;					//Slot hiện tại đang được xet đến
		private var _timer:Timer;						//clock để cho ô select chạy
		private var _timerSend:Timer;					//clock thực hiện việc mô phỏng gửi dữ liệu, cho delay 1 khoảng thời gian
		private var _timerEff:Timer;
		private var sound:Sound;
		private var soundChanel:SoundChannel;
		private var btnQuay:Button;
		private var btnQuayTiep:Button;
		private var btnRecTicket:Button;
		private var btnRecGift:Button;
		private var btnMuc1:Button;
		private var btnMuc2:Button;
		private var btnMuc3:Button;
		private var imgMuc1:Image;
		private var imgMuc2:Image;
		private var imgMuc3:Image;
		private var tfCurTicket:TextField;
		private var listEff:Array;
		private var listResult:Array = [];
		private var numEff:int;
		public var CountPlay2:int;
		public var CountPlay10:int;
		private var guiGift:GUIDigitWheelGift = new GUIDigitWheelGift(null, "");
		private var inReceiveGift:Boolean = false;
		private var inCongrate:Boolean = false;
		private var EffFinishNum:int=0;
		/*Methods*/
		/*
		 * Contructor
		 */ 
		public function GUIDigritWheel(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIDigritWheel";
			pauseIndex = -1;
		};
		
		/*getter and setter*/
		public function set CurGiftType(giftType:String):void
		{
			if (giftType == null) return;
			if (giftType.length >= 0)
			{
				giftType = (giftType == "Exp")?ItemSlot.TYPE_EXP:giftType;
				curGiftType = giftType;
			};
		};
		public function get CurGiftType():String
		{
			var str:String;
			str = (curGiftType == "ExpLM")?"Exp":curGiftType;
			return str;
		};
		public function set CurGiftLevel(giftLevel:int):void
		{
			if (giftLevel >= 0 && giftLevel <=6)
			{
				curGiftLevel = giftLevel;
			};
		};
		public function get CurGiftLevel():int
		{
			return curGiftLevel;
		};
		
		public function set CurTicketType(ticketType:String):void
		{
			if (ticketType == null) return;
			if (ticketType.length >= 0)
			{
				curTicketType = ticketType;
			};
		};
		public function get CurTicketType():String
		{
			return curTicketType;
		};
		/*normal methods*/
		/*
		 * tính toán trạng thái của máy dựa vào loại quà và cấp quà
		 */ 
		private function calState(type:String, level:int):int
		{
			var rs:int;
			if (level == 0 && type == "")//trạng thái bắt đầu của máy quay sò
			{
				rs = 1;
			}
			else if (level == 6 && type.length > 0 && !isSpecialGift(type) )//nhận được quà ko đặc biệt nhưng khủng nhất
			{
				rs = 3;
			}
			else if (isSpecialGift(type))//nhận được quà khủng
			{
				rs = 4;
			}
			else//nhận được quà bình thường
			{
				rs= 2;
			};
			return rs;
		};
		
		/*
		 * khởi tạo gui và các phần tử trong gui
		 */ 
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				if (!checkRevTicketAuto())		//chưa nhận
				{
					var strNotice:String = "Chanh ớt đã tặng bạn @num vỏ sò! Đừng quên quay lại vào ngày mai để nhận tiếp nhé!";
					var num:int = ConfigJSON.getInstance().getTicketDaily();
					strNotice = strNotice.replace("@num", num.toString());
					GuiMgr.getInstance().GuiMessageBox.ShowReceiveTicketAuto(strNotice);
				}
				GuiMgr.getInstance().GuiStore.Hide();
				preFloor = Floor;
				//CurGiftType = "";
				//curGiftLevel = 0;
				state = calState(curGiftType, curGiftLevel);
				SetPos(70, 15);
				refreshComponent();
				drawSlotList();
				OpenRoomOut();
			}
			
			LoadRes("GuiDigitWheel_Theme");
		}
		
		private function drawSlotList(isCheckPauseIndex:Boolean = false):void
		{
			var slotList:Array = [];
			DigritWheelData.initDataForDigritWheel(Floor, slotList, state, curGiftType);
			fixedRange(slotList, isCheckPauseIndex);
		}
		
		private function refreshComponent():void
		{
			var objVar:Object = { ItemId:0, Num:0, TicketNum:0 };
			ClearComponent();
			trace("add bgr");
			addBgr();
			ConfigJSON.getInstance().GetGiftContent(Floor, CurGiftType, CurGiftLevel, objVar);
			var tF:TextFormat = new TextFormat();
			tF.size = 16;
			var priceText:TextField;
			switch(state)
			{
				case 1://hiển thị ở trạng thái ban đầu
					btnQuay = AddButton(ID_BTN_QUAY, "GuiDigitWheel_BtnQuayLM", 432, 447);
					addMucTable();
					var tip:TooltipFormat = new TooltipFormat();
					/*check so lan limit */
					
					if (checkLimit()) 
					{
						tip.text = "Hôm nay, bạn đã hết số lần quay ở mức cược " + Floor + " sò";
						btnQuay.SetDisable();
						btnQuay.setTooltip(tip);
						break;
					}
					
					if (GameLogic.getInstance().user.GetMyInfo().Ticket >= Floor)//đủ sò để chơi
					{
						var configMinigame:Object = MinigameMgr.getInstance().config;
						var limit:int = configMinigame["Play_Limit_" + Floor];
						var countPlay:int = this["CountPlay" + Floor];
						tip.text = "Bạn còn " + (limit - countPlay) + " lượt quay ở mức cược " + Floor + " sò";
						
						btnQuay.SetEnable();
						btnQuay.setTooltip(tip);
					}
					else//không đủ xò
					{
						tip.text = "Hết sò";
						btnQuay.setTooltip(tip);
					};
					AddImage(ID_IC_HELPER_QUAY, "IcHelper", 520, 472);
				break;		
				case 2://hiển thị
					addRevGiftBgr();
					addButtonControl(objVar["TicketNum"]);	
					btnQuayTiep.SetDisable();
					btnRecGift.SetDisable();
					btnRecTicket.SetDisable();
					break;
				case 3://hiển thị ở trạng thái nhận quà cấp 6
					addRevGiftBgr();
					addButtonControl(objVar["TicketNum"]);
					btnQuayTiep.SetDisable();
				break;
				case 4://hiển thị ở trạng thái nhận quà đặc biệt
					btnQuay = AddButton(ID_BTN_QUAY, "GuiDigitWheel_BtnQuayLM", 432, 447);
					addMucTable();
				break;
			}
		}
		
		/*
		 * add các button: quay tiếp, nhận quà, nhận sò và GUI ở state 2 và 3
		 * @numXeng: số lượng sò sẽ được viết vào nút nhận sò
		 */ 
		private function addButtonControl(numXeng:int):void
		{
			var tip:TooltipFormat = new TooltipFormat();
			btnQuayTiep = AddButton(ID_BTN_QUAYTIEP, "GuiDigitWheel_BtnQuayTiepLM", 432, 447);
			AddImage("", "GuiDigitWheel_ImgToolTipQuayTiep", 243, 473);
			btnRecGift = AddButton(ID_BTN_RECEIVEGIFT, "GuiDigitWheel_BtnNhanThuongLM", 273, 325);
			btnRecTicket = AddButton(ID_BTN_RECEIVETICKET, "GuiDigitWheel_BtnNhanXengLM", 459, 325);
			//btnRecGift.SetEnable(!inCongrate);
			//btnRecTicket.SetEnable(!inCongrate);

			if (numXeng == 0)
			{
				btnRecTicket.SetDisable();
				tip.text = "Bạn không có vỏ sò để nhận";
			}
			else
			{
				tip.text = "Nhận lại vỏ sò";
			};
			btnRecTicket.setTooltip(tip);
		};
		
		/*
		 * add Effect slected vào trong ô dừng
		 */ 
		private function addEffGift():void
		{
			if (pauseIndex >= 0)
			{
				(ItemList[pauseIndex] as ItemSlot).addEffSelGift();
			}
		}
		/*
		 * Add cac anh va nut vao GUI
		 */ 
		public function addBgr():void
		{
			AddImage("idimg", "GuiDigitWheel_ImgLblDW", 187, 30);//title cho máy quay sò
			AddImage("idimgKhung", "GuiDigitWheel_ImgKhungDW", 411, 256);
			
			var btnClose:Button = AddButton(ID_BTN_CLOSE, "BtnThoat", 663, 18);
			//btnClose.SetEnable(!inReceiveGift);
			
			AddImage("idimg", "GuiDigitWheel_ImgCurTicketTable",118, 390);
			AddImage("idimg", "GuiDigitWheel_ImgTicketperTimeTable", 410, 320);
			AddImage("idimg", "GuiDigitWheel_ImgXeng", 509, 320);
			tfCurTicket = AddLabel(Ultility.StandardNumber(GameLogic.getInstance().user.GetMyInfo().Ticket), 34, 391, 0xFFFF00, 1, 0x000000);
			addTicketBuy();
		};
		
		/*
		 * add bảng giá và mua vé
		 */
		private function addTicketBuy():void
		{
			AddImage("idimg", "GuiDigitWheel_ImgPriceTable1", 116, 201);//add vào cái bảng tĩnh
			//add 3 nút mua
			AddButton(ID_BTN_MUA1, "GuiDigitWheel_BtnBuyTicket", 126, 136);
			AddButton(ID_BTN_MUA2, "GuiDigitWheel_BtnBuyTicket", 126, 206);
			AddButton(ID_BTN_MUA3, "GuiDigitWheel_BtnBuyTicket", 126, 274);
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Ticket");
			//gan vao so luong
			var firstXNum:int = 46;
			var firstXPrice:int = 95;
			var firstYNum:int = 150;
			var firstYPrice:int = 136;
			var i:int;
			var strNum:String;
			var strPrice:String;
			for (i = 1; i <= 3; i++)
			{
				strNum = obj[i.toString()]["Num"];
				strPrice = obj[i.toString()]["ZMoney"];
				AddLabel(strNum, firstXNum, firstYNum - 2, 0xffffff, 1, 0x000000);
				AddLabel(strPrice, firstXPrice , firstYPrice, 0xffffff, 1, 0x000000);
				firstYPrice += 70;
				firstYNum += 70;
			}
		};
		/*
		 * Sắp xếp các Item theo vị trí đã fix
		 */
		public function fixedRange(slotList:Array, isCheckPauseIndex:Boolean = false):void
		{
			/*tạo 2 mảng chứa các tọa độ x, y của từng slot*/
			var i:int, x:int, y:int;
			var slotName:String;
			var itemType:String, itemTypeDW:String, levelSlot:int;
			var item:ItemSlot;
			var strTooltip:String;
			var tooltip:TooltipFormat;
			var corList:Array = new Array();
			var SlotList:Array = new Array();
			//lấy dữ liệu từ data
			ItemList.splice(0, ItemList.length);
			DigritWheelData.initCorForDigritWheel(corList);					
			SlotList = slotList;			
			for (i = 0; i < SlotNumber; i++)
			{
				tooltip = new TooltipFormat();
				x = corList[i].x;
				y = corList[i].y;
				/*lấy dữ liệu từ data*/
				slotName = SlotList[i]["SlotName"];
				levelSlot = SlotList[i]["levelSlot"];
				itemType = SlotList[i]["itemType"];
				itemTypeDW = SlotList[i]["itemTypeDW"];
				/*khởi tạo item*/
				item = new ItemSlot(this.img, slotName, x, y);
				item.LevelSlot = levelSlot;
				if (isCheckPauseIndex && i == pauseIndex)
				{
					item.addEffSelGift();
					item.ItemType = CurGiftType;
					item.LevelGift = CurGiftLevel;
				}
				else
				{
					if (itemType != ItemSlot.TYPE_FAIL)
					{
						item.LevelGift = PlusSmart(levelSlot, CurGiftLevel, 6);
					}
					else
					{
						item.LevelGift = 0;
					}
					if (levelSlot >= 4 && levelSlot <= 6)
					{
						item.LevelGift = levelSlot;
						item.LevelSlot = 0;
						item.LevelGift = item.calLevelGiftForFakeSlot(CurGiftLevel);
					}
					item.ItemType = itemType;
				}
				item.ItemTypeDW = itemTypeDW;
				if (item.LevelGift == 6)
				{
					item.LoadRes("ImgSlotOrange");
				}
				
				/*tooltip*/
				if (isSpecialGift(item.ItemType))
				{
					strTooltip=SlotList[i]["ToolTipText"];
				}
				else
				{
					strTooltip = DigritWheelData.getTip(Floor, item.ItemType, item.LevelGift);
				}
				
				tooltip.text = strTooltip;
				item.setTooltip(tooltip);
				item.LoadImageDW(Floor);
				ItemList.push(item);
				if(i != pauseIndex)
					addFogToSlot(i);
			}
			var leng:int = ItemList.length;
			if (pauseIndex == -1 && state > 1)
			{
				for (i = 0; i < leng; i++)
				{
					item = ItemList[i] as ItemSlot;
					if (item.ItemType == CurGiftType&&(item.LevelGift - item.LevelSlot) ==CurGiftLevel)
					{
						pauseIndex = i;
						(ItemList[i] as ItemSlot).addEffSelGift();
						(ItemList[i] as ItemSlot).LevelGift = CurGiftLevel;
						(ItemList[i] as ItemSlot).LoadImageDW(Floor);
						break;
					}
				}
			}
		}
		
		/*
		 * Xử lý ấn các nút bấm trên GUI
		 */
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					this.Hide();
					break;
				case ID_BTN_QUAY:
				{
					if (IsExpire)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết sự kiện Vỏ sò may mắn\n Bạn hãy giữ lại sò cho lần Update tiếp theo nhé", 310, 200, 1);
						break;
					}
					var _user:User = GameLogic.getInstance().user;
					var played:Boolean = _user.CheckSetTicket(0 - Floor);
					if (!played)
					{
						cantPlay();
					}
					else
					{
						this["CountPlay" + Floor]++;
						/*trừ sò*/
						var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
						txtFormat.align = "left";
						txtFormat.font = "SansationBold";
						var st:String;
						st = "-" + Ultility.StandardNumber(Floor);
						txtFormat.color = 0xff0000;
						var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
						var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
						eff.SetInfo(125, 400, 125, 350, 4);
						refreshComponent();
						drawSlotList();
						/*quay*/
						btnQuay.SetDisable();
						RemoveImage(GetImage(ID_IC_HELPER_QUAY));
						GetButton(ID_BTN_MUA1).SetDisable();
						GetButton(ID_BTN_MUA2).SetDisable();
						GetButton(ID_BTN_MUA3).SetDisable();
						GetButton(ID_BTN_CLOSE).SetDisable();
						btnMuc1.SetDisable();
						btnMuc2.SetDisable();
						btnMuc3.SetDisable();
						play();
					};
					break;
				};
				case ID_BTN_QUAYTIEP:
				{
					if (IsExpire)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết sự kiện Vỏ sò may mắn\n Bạn hãy giữ lại sò cho lần Update tiếp theo nhé", 310, 200, 1);
						break;
					}
					disBtnInRevState();
					play();
					isFirstClick = false;
				};
				break;
				case ID_BTN_MUA1:
				{
					buyTicket(1);
				};
				break;
				case ID_BTN_MUA2:
				{
					buyTicket(2);
				};
				break;
				case ID_BTN_MUA3:
				{
					buyTicket(3);
				};
				break;
				case ID_BTN_RECEIVEGIFT:
				{
					if (isFirstClick && (CurGiftLevel < 3))
					{
						GuiMgr.getInstance().GuiMessageBox.ShowConfirmGetLuckyMachine("Bạn có thể quay tiếp (không mất sò) để nhận phần thưởng cao hơn.");
					}
					else
					{
						disBtnInRevState();
						receiveAvril("Gift");
					};
				};
				break;
				case ID_BTN_RECEIVETICKET:
				{
					disBtnInRevState();
					receiveAvril("Ticket");
				};
				break;
				case ID_BTN_MUC1:
					Floor = 2;
					showBtnMuc1();
					changeTab();
				break;
				case ID_BTN_MUC2:
					Floor = 10;
					showBtnMuc2();
					changeTab();
				break;
				case ID_BTN_MUC3:
					Floor = 50;
					showBtnMuc3();
					changeTab();
				break;
			};
		};
		public function disBtnInRevState():void
		{
			btnQuayTiep.SetDisable();
			btnRecGift.SetDisable();
			btnRecTicket.SetDisable();
			GetButton(ID_BTN_MUA1).SetDisable();
			GetButton(ID_BTN_MUA2).SetDisable();
			GetButton(ID_BTN_MUA3).SetDisable();
			GetButton(ID_BTN_CLOSE).SetDisable();
		}
		/*
		 * Move ra khoi nut
		 */ 
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			ActiveTooltip.getInstance().clearToolTip();
		};
		
		/*
		 * Hien tooltip khong the quay so
		 */ 
		private function cantPlay():void
		{
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("ToolTipLuckyMachine2");
			ActiveTooltip.getInstance().showNewToolTip(tooltip, GetButton(ID_BTN_QUAY).img);
			GuiMgr.getInstance().GuiMessageBox.ShowTicketOff("Bạn đã hết vỏ sò! Hãy mua thêm vỏ sò để quay thêm nhé!!!");
		};
		
		/*
		 * gọi khi người chơi bấm nút quay
		 */ 
		public function play():void
		{
			addBulbArr();
			/*send data*/
			if (curGiftLevel > 0)							//quay tiep
			{
				if (pauseIndex >= 0)						//tồn tại vị trí dừng
				{
					transform(ItemList[pauseIndex]);
					curIndex1 = pauseIndex;					//vị trí quay = vị trí dừng trước đó
				}
				else										//nếu vị trí dừng trước đó ko xác định
					curIndex1 = 0;
				sendData("PlayAgain");
			}
			else											//quay lần đầu
			{
				curIndex1 = 0;
				sendData("Play");
			}
			/*khởi tạo cho việc quay*/
			isRound1 = true;								//đúng là đang ở vòng đầu tiên
			_timer = new Timer(SPEED);
			_timer.addEventListener(TimerEvent.TIMER, onPlay);
			if (pauseIndex < 0)
				_timer.start();													//cho quay
			sound = SoundMgr.getInstance().getSound("MayQuaySo") as Sound;		//thêm nhạc
			if(sound!=null)
				soundChanel = sound.play(0,9999);								//chạy nhạc
		};
		
		/*
		 * Gửi dữ liệu lên server
		 * @type: loại dữ liệu là : "quay", "quay tiếp", "nhận sò" hay "nhận quà"
		 */ 
		private function sendData(type:String):void
		{
			isReceivedData = false;
			/*mô phỏng, cho delay 1 khoảng thời gian*/
			/*
			_timerSend = new Timer(TIMEGETDATA);
			_timerSend.addEventListener(TimerEvent.TIMER, onWaitData);
			_timerSend.start();
			*/
			/*gửi thật nè - gửi lên server*/
			var pk:SendPlayLuckyMachine = new SendPlayLuckyMachine(type, Floor);
			Exchange.GetInstance().Send(pk);
		};

		/*
		 * Nhận kết quả từ server về
		 */ 
		public function receiveFromServer(data:Object):void
		{
			indexReceive = data.GiftId;
			equipment = data.Equipment;
			isReceivedData = true;				//đã nhận được dữ liệu
		};
		
		private function onEndWait(event:Event):void
		{
		};
		/*
		 * máy quay sò đang chạy
		 */
		private function onPlay(event:Event):void
		{
			if (curSlot1)
				curSlot1.SetHighLight( -1);
			if (_timer.currentCount %2 == 0 && _timer.currentCount < 18)
				_timer.delay -= 5;	//quay nhanh dần đều trong khoảng thời gian đầu
			if (_timer.currentCount > COUNTMIN && isReceivedData)//nhận được dữ liệu và đạt countmin thì cho quay chậm dần
			{
				loopCount = calculateResult();//tính số bước đi tiếp cho đến khi dừng lại
				playSlow();
				return;
			}
			if (isRound1)
			{
				if (curIndex1 == SlotNumber)
				{
					isRound1 = false;
					curIndex1 = 0;
				}
			}
			else	//quay quá 1 vòng
			{
				curIndex1 %= SlotNumber;
			};
			curSlot1 = ItemList[curIndex1] as ItemSlot;
			curSlot1.SetHighLight(STRONG_LIGHT);
			curIndex1++;
		};
		
		/*
		 * Tính toán vòng quay đạt đến kết quả, chỉ rõ tọa độ ô chứa kết quả
		 */ 
		public function calculateResult():int
		{
			var len:int = 0;
			if (listResult)
			{
				len = listResult.length;
			}
			listResult.splice(0, len);
			pauseIndex = -1;
			var i:int;
			var item:ItemSlot;
			var distance:int;
			var obj:Object = { giftType:"", giftLevel:0 };
			ConfigJSON.getInstance().GetLuckyMachineGift(Floor, indexReceive, obj);//lấy type và level của quà dựa vào index trả về từ server
			if (state == 1)//lần đầu
			{
				obj["giftLevel"] = PlusSmart(obj["giftLevel"], curGiftLevel, 6);
			}
			else		//lần sau => có CurGiftType và curGiftLevel
			{
				
				if (CurGiftType == obj["giftType"])//trùng giải
				{
					obj["giftLevel"] = PlusSmart(obj["giftLevel"], curGiftLevel, 6);
				}
				else//trượt
				{
					obj["giftType"] = ItemSlot.TYPE_FAIL;
					obj["giftLevel"] = 0;
				}
			}
			/*lấy được tất cả các ô mà có thể dừng ở đó*/
			for (i = 0; i < SlotNumber; i++)
			{
				item = ItemList[i];
				if(item.ItemType == obj["giftType"] && item.LevelGift == obj["giftLevel"])
				{
					listResult.push(i);
				}
			}
			/*lấy ngẫu nhiên 1 ô trong số các ô đó để làm điểm dừng*/
			len = listResult.length;
			var index:int = DigritWheelData.Randomize(0, len -1);
			pauseIndex = listResult[index];
			distance = (pauseIndex - curIndex1 + SlotNumber) % SlotNumber;
			if (distance < PAUSEMIN)
			{
				distance += SlotNumber;
			}
			return distance + 1;
		};
		
		/*
		 * Quay chậm dần đến ô kết quả
		 */ 
		public function playSlow():void
		{
			curSlot1.SetHighLight( -1);
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onPlay);
			_timer = new Timer(SPEEDSLOW);			//tạo timer mới với tốc độ chậm hơn
			_timer.addEventListener(TimerEvent.TIMER, onPlaySlow);
			_timer.start();
		};
		
		/*
		 * xử lý quay chậm, chỉ cho 1 ô sáng chạy
		 */ 
		private function onPlaySlow(event:Event):void
		{
			if ((curIndex1 + 24 - pauseIndex) % 24 > 10)
			{
				_timer.delay += 3;
			}
			else
			{
				_timer.delay += 10;
			}
			curIndex1 %= SlotNumber;
			curSlot1.SetHighLight( -1);
			curSlot1 = ItemList[curIndex1] as ItemSlot;
			if (curIndex1 == pauseIndex && _timer.currentCount == loopCount)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onPlaySlow);
				var obj:Object = { giftType:"", giftLevel:0 };
				ConfigJSON.getInstance().GetLuckyMachineGift(Floor, indexReceive, obj);
				if (CurGiftType == obj["giftType"] || CurGiftType == "")
				{
					if (indexReceive > 20 && indexReceive <= 24)
					{
						CurGiftType = (ItemList[pauseIndex] as ItemSlot).ItemType;
						CurGiftLevel = (ItemList[pauseIndex] as ItemSlot).LevelGift;
						revSpecialGift();
					}
					else
					{
						showRevGift(obj["giftType"], obj["giftLevel"]);
					}
				}
				else//quay tiếp mà xịt
				{
					noticeFail();
				};
				if (soundChanel != null)
					soundChanel.stop();
				sound = SoundMgr.getInstance().getSound("TrungGiai") as Sound;
				if(sound!=null)
					sound.play();
			}
			else
			{
				curSlot1.SetHighLight(STRONG_LIGHT);
				curIndex1++;
			};			
		};
		
		/*
		 * Ấn mua vé
		 */ 
		public function buyTicket(id:int):void
		{
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Ticket");
			var price:int = obj[id.toString()]["ZMoney"];			//giá theo id
			var num:int = obj[id.toString()]["Num"];				//số lượng theo id
			var _user:User = GameLogic.getInstance().user;
			var numG:int = _user.GetMyInfo().ZMoney;
			var pk:SendBuyTicket;
			/*xét đủ G ko*/
			if (numG < price)			//không đủ G
			{
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Bạn không đủ G";
				ActiveTooltip.getInstance().showNewToolTip(tooltip, GetButton("btnMua" + id.toString()).img);
				//show tooltip
				GuiMgr.getInstance().GuiNapG.Init();
			}
			else						//đủ G
			{
				/*trừ G*/
				_user.UpdateUserZMoney(0 - price);
				/*cập nhật ticket và effect mua thành công + effect bay sò vào bảng sò*/
				EffectMgr.setEffBounceDown("Mua thành công", "GuiDigitWheel_ImgEffBuyXeng", 330, 280);
				_user.GetMyInfo().Ticket += num;
				tfCurTicket.text = Ultility.StandardNumber(_user.GetMyInfo().Ticket);
				var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
				txtFormat.align = "left";
				txtFormat.font = "SansationBold";
				var st:String;
				st = "+" + Ultility.StandardNumber(num);
				txtFormat.color = 0xFFFF00;  //Cộng xeng thì màu xanh
				var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				eff.SetInfo(125, 400, 125, 350, 4);
				/*send dữ liệu lên server*/
				//pk = new SendBuyTicket("Ticket", id, 1);
				//Exchange.GetInstance().Send(pk);
			};
		};
		
		/*
		 * Nhận giải đặc biệt
		 */ 
		public function revSpecialGift():void
		{
			addEffGift();
			//var objVar2:Object = {giftType:"", giftLevel:0 };
			//ConfigJSON.getInstance().GetLuckyMachineGift(Floor, indexReceive, objVar2);
			//var type:String = objVar2["giftType"];
			//var objVar:Object = {Color:0, ItemId:0, Num:0, TicketNum:0 };
			//ConfigJSON.getInstance().GetGiftContent(Floor, type, CurGiftLevel, objVar);
			//var item:ItemSlot = ItemList[pauseIndex] as ItemSlot;
			//var imName:String = item.ItemTypeDW;
			//var type1:String = "";
			//var rank:int;
			//var color:int;
			if (equipment)
			{
				var gift:AbstractGift = new GiftSpecial();
				gift.setInfo(equipment);
				if ((gift as GiftSpecial).Color == 5) {
					guiGift.initData(gift, "FEED");
				}
				else {
					guiGift.initData(gift,"RECEIVE");
				}
				
				guiGift.Show(Constant.GUI_MIN_LAYER, 5);
				GameLogic.getInstance().user.GenerateNextID();
				//type1 = equipment["Type"];
				//rank = equipment["Rank"];
				//color = equipment["Color"];
			}
			//GuiMgr.getInstance().guiDigritWheelCongrat.showGui(equipment,type1, rank, color);
			//GameLogic.getInstance().user.GenerateNextID();
		};
		
		/*
		 * Hiển thị GUI nhận quà (TH quay lần đầu và TH trùng quà)
		 */
		public function showRevGift(giftType:String, giftLevel:int):void
		{
			CurGiftType = giftType;
			addLevelGift(giftLevel);
			state = calState(curGiftType, curGiftLevel);//chỉ có thể ra 2 or 3
			refreshComponent();
		};
		/*
		 * add vào bảng Nhận quà (vùng giữa máy quay sò)
		 */
		private function addRevGiftBgr():void
		{
			var i:int;
			/*biến dữ liệu và quyết định tên ảnh add vào*/
			var objVar:Object = { ItemId:0, Num:0, TicketNum:0 };
			var imName:String;
			var imgGift:ButtonEx;
			var tip2:TooltipFormat;
			/*add cái background cho cái bảng nhận quà*/
			if (curGiftLevel == 6) {
				AddImage("ImgGiftTable", "GuiDigitWheel_ImgGiftTableMax", 411, 254); 
			}
			else {
				AddImage("ImgGiftTable", "GuiDigitWheel_ImgGiftTable", 411, 254); 
			}
			
			/*add quà, và số lượng*/
			ConfigJSON.getInstance().GetGiftContent(Floor, CurGiftType, CurGiftLevel, objVar);
			imName = curGiftType + objVar["ItemId"];
			
			imgGift = AddButtonEx(ID_IMG_INSIDEWHEEL, imName, 0, 0);
			imgGift.FitRect(43, 43, new Point(294, 244));
			tip2 = new TooltipFormat();
			tip2.text = DigritWheelData.getNameItem(CurGiftType, objVar["ItemId"]);
			imgGift.setTooltip(tip2);
			AddLabel(DigritWheelData.StandardNumber(objVar["Num"]), 266, 283, 0xffffff, 1, 0x000000);
			
			imgGift = AddButtonEx(ID_IMG_INSIDEWHEEL, "GuiDigitWheel_ImgXeng", 0, 0);
			imgGift.FitRect(43, 43, new Point(472, 244));
			tip2 = new TooltipFormat();
			tip2.text = "Vỏ Sò";
			imgGift.setTooltip(tip2);
			AddLabel(Ultility.StandardNumber(objVar["TicketNum"]), 442, 283, 0xffffff, 1, 0x000000);
			
			addEffCongrate();
		};
		
		private function addFogToSlot(indexSlot:int):void
		{
			var i:int;
			var itemTemp:ItemSlot;
			itemTemp = ItemList[indexSlot] as ItemSlot;
			if (itemTemp.ItemType != CurGiftType && CurGiftType!="")
			{
				(ItemList[indexSlot] as ItemSlot).showFogSlot();
			}
		};

		private function addEffCongrate():void
		{	
			/*effect chúc mừng*/
			//inCongrate = true;
			GetButton(ID_BTN_CLOSE).SetDisable();
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiDigitWheel_EffCongratulation", null, 462, 316, false, false, null, onCompleteCongrate);
			var slotList:Array = [];
			DigritWheelData.initDataFailAll(Floor, slotList);
			fixedRange(slotList, true);
		};
		
		private function onCompleteCongrate():void
		{
			//Clear những itemslot cũ đi để vẽ mới
			var i:int = 0;
			for (i = 0; i < ItemList.length; i++)
			{
				var container:ItemSlot = ItemList[i] as ItemSlot;		
				container.SetHighLight( -1);
				container.Destructor();
			}
			ItemList.splice(0, ItemList.length);
			//Vẽ mới lại item slot
			drawSlotList(true);
			bumBum();	
			sequenceEff();			
			if (state == 2)
			{
				var objVar:Object = { ItemId:0, Num:0, TicketNum:0 };
				ConfigJSON.getInstance().GetGiftContent(Floor, CurGiftType, CurGiftLevel, objVar);
				//btnQuayTiep.SetEnable();
				btnRecGift.SetEnable();
				if (objVar["TicketNum"] > 0)
				{
					btnRecTicket.SetEnable();
				}				
			}
		};
		private function onEndCongrate(event:TimerEvent):void
		{
		};
		/*
		 * add vào dãy bóng đèn
		 */ 
		private function addBulbArr():void
		{
			var bulb:Image, imgKhung:Image;
			var widthBulb:int = 12;
			var c:int = 5;		//dãy bóng cách cạnh trên dưới và 2 bên.
			var i:int, delta:int = 8, w:int/*chiều dài khung*/, h:int/*chiều rộng khung*/;
			var x:int = 100, y:int = 100;
			var sw:int, sh:int;		//số lượng bóng theo chiều dài và chiều rộng
			
			imgKhung = GetImage("idimgKhung");
			x = imgKhung.img.x - c - widthBulb + 10;				//tính tọa độ bắt đầu
			y = imgKhung.img.y - c - widthBulb + 10;
			w = imgKhung.img.width;							
			h = imgKhung.img.height;
			sw = (w + 2 * c) / (delta + widthBulb);			//tính số lượng bóng đèn theo chiều dài và rộng
			sh = (h + 2 * c) / (delta + widthBulb);			
			/*vẽ ra dãy bóng thành hình chữ nhật = 4 vòng lặp <=> vẽ 4 cạnh*/
			/*top edge*/
			for (i = 0; i < sw; i++)
			{
				bulb = AddImage(ID_EFF_CONGRATE, "GuiDigitWheel_ImgBulb", x, y);
				bulb.GoToAndPlay((i * 5) % 15);
				x += widthBulb + delta;
			};
			x = imgKhung.img.x + imgKhung.img.width + c;
			for (i = 0; i < sh; i++)
			{
				bulb = AddImage(ID_EFF_CONGRATE, "GuiDigitWheel_ImgBulb", x, y);
				bulb.GoToAndPlay((i * 5) % 15);
				y += widthBulb + delta;
			};
			y = imgKhung.img.y + imgKhung.img.height + c;
			for (i = 0; i < sw; i++)
			{
				bulb = AddImage(ID_EFF_CONGRATE, "GuiDigitWheel_ImgBulb", x, y);
				bulb.GoToAndPlay((i * 5) % 15);
				x -= widthBulb + delta;
			};
			x = imgKhung.img.x - widthBulb - c + 10;
			for (i = 0; i < sh; i++)
			{
				bulb = AddImage(ID_EFF_CONGRATE, "GuiDigitWheel_ImgBulb", x, y);
				bulb.GoToAndPlay((i * 5) % 15);
				y -= widthBulb + delta;
			};
		}

		/*
		 *@type[in]: để biết nhận thưởng hay nhận sò 
		 */ 
		public function receiveAvril(type:String):void
		{
			var _user:User = GameLogic.getInstance().user;
			var pk:SendPlayLuckyMachine = new SendPlayLuckyMachine(type, 2);
			var objVar:Object = { ItemId:0, Num:0, TicketNum:0 };
			var sId:String;
			var GiftNum:int;
			var TicketNum:int;
			var imgEff:String;
			ConfigJSON.getInstance().GetGiftContent(Floor, CurGiftType, CurGiftLevel, objVar);
			sId = (curGiftType==ItemSlot.TYPE_EXP)?"":(objVar["ItemId"] as int).toString();
			GiftNum = objVar["Num"];
			TicketNum = objVar["TicketNum"];
			/*Send dữ liệu lên server*/
			Exchange.GetInstance().Send(pk);
			switch(type)
			{
				case "Gift":
				{
					if (curGiftType == ItemSlot.TYPE_EXP)
					{
						_user.SetUserExp(_user.GetMyInfo().Exp + GiftNum);
					}
					else
					{
						_user.UpdateStockThing(curGiftType, (int)(sId), GiftNum);//update vào kho
					};
					imgEff = curGiftType + sId;
				}
				break;
				case "Ticket":
					imgEff = "GuiDigitWheel_ImgEffBuyXeng";
					_user.GetMyInfo().Ticket += TicketNum;
					var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
					txtFormat.align = "left";
					txtFormat.font = "SansationBold";
					var st:String;
					st = "+" + Ultility.StandardNumber(TicketNum);
					txtFormat.color = 0xff0000;
					var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
					var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
					eff.SetInfo(125, 400, 125, 350, 4);
				break;
			};
			disBtnInRevState();
			inReceiveGift = true;
			showEffRev(imgEff);
		};

		/*
		 * thông báo xịt
		 */ 
		public function noticeFail():void
		{
			var tf:TextField;
			var fm:TextFormat = new TextFormat("Arial", 14);
			fm.align = "center";
			var giftType:String = CurGiftType;
			var giftLevel:int = curGiftLevel;
			var slotList:Array = new Array();
			DigritWheelData.initDataForDigritWheel(Floor, slotList, state, curGiftType);
			state = 1;
			inFail = true;
			refreshComponent();				
			fixedRange(slotList);
			(ItemList[pauseIndex] as ItemSlot).addEffSelGift();
			tf = AddLabel("Tiếc quá!\n Lần này bạn không có phần thưởng.", 363, 184);
			tf.setTextFormat(fm);
			btnQuay.SetDisable();
			GetButton(ID_BTN_CLOSE).SetDisable();
			GetButton(ID_BTN_MUA1).SetDisable();
			GetButton(ID_BTN_MUA2).SetDisable();
			GetButton(ID_BTN_MUA3).SetDisable();
			
			_timer = new Timer(2000);
			_timer.addEventListener(TimerEvent.TIMER, onNoticefail);
			_timer.start();
			
		};
		private function onNoticefail(event:Event):void
		{
			resetMachine();
			showTab();
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onNoticefail);
			inFail = false;
		}
		/*
		 * Effect nhận quà hay nhận sò
		 */
		public function showEffRev(imgEff:String):void
		{
			
			EffectMgr.setEffBounceDown("Nhận thành công", imgEff, 330, 280, endEff)
			{
				function endEff():void
				{
					
					if (state == 3)
					{
						feed();
					};
					inReceiveGift = false;
					resetMachine();
					
				};
			};
		};
		/*
		 * Show gui Feed khi nhận giải đặc biệt
		 */
		public function feed():void
		{
			switch(CurGiftType)
			{
				case "Material":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineMaterial");
				break;
				case "Exp":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineExp");
				break;
				case "EnergyItem":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineEnergyItem");
				break;
				case "RankPointBottle":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineRankPointBottle");
				break;
			};
			
		};
		/*
		 * Thực hiện reset lại trạng thái của máy quay sò
		 */
		public function resetMachine():void
		{
			CurGiftType = "";
			curGiftLevel = 0;
			state = calState(CurGiftType, curGiftLevel);
			refreshComponent();				
			drawSlotList();
			pauseIndex = -1;
			isFirstClick = true;
		};
		
		private function addLevelGift(dLevel:int):void
		{
			if (dLevel > 0)
			{
				curGiftLevel += dLevel;
				curGiftLevel = (curGiftLevel > 6)?6:curGiftLevel;
			}
			else
			{
				curGiftLevel = 0;
			};
		};
		
		/*
		 * fake dữ liệu và 1 khoảng thời gian delay từ server trả về
		 */
		private function onWaitData(event:Event):void
		{
			isReceivedData = true;
			//fake dữ liệu trả về
			indexReceive = 6;			//thích ra cái gì nào, xem config
			_timerSend.stop();
			_timerSend.removeEventListener(TimerEvent.TIMER, onWaitData);
		};

		private function checkRevTicketAuto():Boolean
		{
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("RevceiveTicketAuto" + GameLogic.getInstance().user.GetMyInfo().Id);
			
			if (so.data.lastDay != null)
			{
				var lastDay:String = so.data.lastDay;				
				if (lastDay != today)
				{
					so.data.lastDay = today;
					Ultility.FlushData(so);
					return false;
				}
				else
					return true;
			}
			else
			{
				so.data.lastDay = today;
				Ultility.FlushData(so);
				return false;
			}
		};
		private function PlusSmart(no1:int, no2:int, max:int):int
		{
			var rs:int;
			rs = no1 + no2;
			rs = (rs < max)?rs:max;
			return rs;
		}
		
		private function bumBum():void
		{
			var length:int = ItemList.length;
			var levelSlot:int;
			var levelGift:int;
			var type:String;
			var i:int;
			var item:ItemSlot;
			listEff = new Array();
			for (i = 0; i < length; i++)
			{
				item = ItemList[i] as ItemSlot;
				levelSlot = item.LevelSlot;
				levelGift = item.LevelGift;
				type = item.ItemType;
				if (type == CurGiftType)//đúng cái giải đó
				{
					if (i!=pauseIndex)// đủ điều kiện biến hình
					{
						listEff.push(item);
					}
				}
			};
		}
		
		private function sequenceEff():void
		{
			var index:int = 0;
			var preIndex:int = -1;
			var x:int, y:int;
			var item:ItemSlot;
			var levelChung:int = CurGiftLevel;
			var i:int;
			var len:int = listEff.length;
			EffFinishNum = 0;
			for (i = 0; i < len; i++)
			{
				item = listEff[i] as ItemSlot;
				transform2(item);
			}
		}
		
		private function transform2(item:ItemSlot):void
		{
			var x:int = item.img.x + 109;
			var y:int = item.img.y + 56;
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
														"EffAnNgoc", 
														null, 
														x, y,
														false,
														false,
														null,
														onCompleteTransform);
			function onCompleteTransform():void
			{
				if (item.LevelSlot == 0)//với ô fake
				{
					item.LevelGift = item.calLevelGiftForFakeSlot(CurGiftLevel);
				}
				else	//với ô thực
				{
					item.LevelGift = PlusSmart(CurGiftLevel, item.LevelSlot, 6);
				}
				item.LoadImageDW(Floor);
				EffFinishNum++;
				if (EffFinishNum == listEff.length) {
					//trace("EffFinishNum = " + EffFinishNum);
					//if (GetButton(ID_BTN_CLOSE))
					//{
					
					if (!inReceiveGift)
					{
						trace("Set enable close");
						if (btnQuayTiep.img) {
							btnQuayTiep.SetEnable();
						}
						
						GetButton(ID_BTN_CLOSE).SetEnable();
					}
					//}
					//inCongrate = false;
					//btnRecGift.SetEnable();
					//btnRecTicket.SetEnable();
				}
				
			}
		}
		
		private function transform(item:ItemSlot):void
		{
			var x:int = item.img.x + 109;
			var y:int = item.img.y + 56;
			var levelChung:int = CurGiftLevel;
			var type:String = CurGiftType;
			var str:String;
			var tooltip:TooltipFormat=new TooltipFormat();
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, 
													"EffAnNgoc", 
													null, 
													x, y, 
													false, 
													false,
													null,
													onCompTransform);
			function onCompTransform():void
			{
				if (item.LevelSlot == 0)//với ô fake
				{
					item.LevelGift = item.calLevelGiftForFakeSlot(levelChung);
				}
				else	//với ô thực
				{
					item.LevelGift = PlusSmart(levelChung, item.LevelSlot, 6);
				}
				if (item.LevelGift == 6)
				{
					item.Clear();
					item.LoadRes("ImgSlotOrange");
				}
				str = DigritWheelData.getTip(Floor, item.ItemType, item.LevelGift);
				tooltip.text = str;
				item.setTooltip(tooltip);
				item.LoadImageDW(Floor);
				_timer.start();
			};
		}
		
		private function isSpecialGift(type:String):Boolean
		{
			if (type == ItemSlot.TYPE_HELMET || type == ItemSlot.TYPE_WEAPON 
					|| type == ItemSlot.TYPE_MASK || type == ItemSlot.TYPE_ARMOR
					|| type == ItemSlot.TYPE_BELT || type == ItemSlot.TYPE_BRACELET 
					|| type == ItemSlot.TYPE_NECKLACE || type == ItemSlot.TYPE_RING)
					
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function showBtnMuc1():void
		{
			btnMuc1.SetVisible(false);
			btnMuc2.SetVisible(true);
			btnMuc3.SetVisible(true);
		}
		
		private function showBtnMuc2():void
		{
			btnMuc1.SetVisible(true);
			btnMuc2.SetVisible(false);
			btnMuc3.SetVisible(true);
		}
		
		private function showBtnMuc3():void
		{
			btnMuc1.SetVisible(true);
			btnMuc2.SetVisible(true);
			btnMuc3.SetVisible(false);
		}
		
		private function addMucTable():void
		{
			trace("addMucTable");
			imgMuc1 = AddImage("", "GuiDigitWheel_ImgTurnPlay", 253, 175, true, ALIGN_LEFT_TOP);
			btnMuc1 = AddButton(ID_BTN_MUC1, "GuiDigitWheel_BtnTurnPlay", 253, 175, this);
			tfTurn1 = AddLabel("2", 335, 195, 0xFFFF00, 1, 0x000000);
			
			imgMuc2 = AddImage("", "GuiDigitWheel_ImgTurnPlay", 253, 235, true, ALIGN_LEFT_TOP);
			btnMuc2 = AddButton(ID_BTN_MUC2, "GuiDigitWheel_BtnTurnPlay", 253, 235, this);
			tfTurn2 = AddLabel("10", 330, 255, 0xFFFF00, 1, 0x000000);
			
			imgMuc3 = AddImage("", "GuiDigitWheel_ImgTurnPlay", 253, 295, true, ALIGN_LEFT_TOP);
			btnMuc3 = AddButton(ID_BTN_MUC3, "GuiDigitWheel_BtnTurnPlay", 253, 295, this);
			btnMuc3.SetDisable();
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Sắp ra mắt";
			btnMuc3.setTooltip(tip);
			tfTurn3 = AddLabel("50", 330, 315, 0xFFFF00, 1, 0x000000);
			switch(Floor)
			{
				case 2:
					showBtnMuc1();
				break;
				case 10:
					showBtnMuc2();
				break;
				case 50:
					showBtnMuc3();
				break;
			}
			if (inFail) {
				trace("infail");
				btnMuc1.SetVisible(false);
				btnMuc2.SetVisible(false);
				btnMuc3.SetVisible(false);
				imgMuc1.img.visible = imgMuc2.img.visible = imgMuc3.img.visible = false;
				tfTurn1.visible = tfTurn2.visible = tfTurn3.visible = false;
			}
		}
		private function showTab():void
		{
			btnMuc2.SetVisible(true);
			btnMuc3.SetVisible(true);
			imgMuc1.img.visible = imgMuc2.img.visible = imgMuc3.img.visible = true;
			tfTurn1.visible = tfTurn2.visible = tfTurn3.visible = true;
			btnMuc1.SetVisible(true);
			switch(Floor)
			{
				case 2:
					showBtnMuc1();
				break;
				case 10:
					showBtnMuc2();
				break;
				case 50:
					showBtnMuc3();
				break;
			}
		}
		private function changeTab():void
		{
			var i:int = 0;
			for (i = 0; i < ItemList.length; i++)
			{
				var container:ItemSlot = ItemList[i] as ItemSlot;
				container.SetHighLight( -1);
				container.Destructor();
			}
			ItemList.splice(0, ItemList.length);
			drawSlotList();
			btnQuay.clearTooltip();
			/*xử lý nút quay*/
			var tip:TooltipFormat = new TooltipFormat();
			if (checkLimit())
			{
				tip.text = "Hôm nay, bạn đã hết số lần quay ở mức cược " + Floor + " sò";
				btnQuay.SetDisable();
			}
			else {
				btnQuay.SetEnable();
				var configMinigame:Object = MinigameMgr.getInstance().config;
				var limit:int = configMinigame["Play_Limit_" + Floor];
				var countPlay:int = this["CountPlay" + Floor];
				tip.text = "Bạn còn " + (limit - countPlay) + " lượt quay ở mức cược " + Floor + " sò";
			}
			btnQuay.setTooltip(tip);
		}
		
		private function checkLimit():Boolean
		{
			var configMinigame:Object = MinigameMgr.getInstance().config;
			var limit:int = configMinigame["Play_Limit_" + Floor];
			var countPlay:int = this["CountPlay" + Floor];
			if (countPlay >= limit)
			{
				return true;
			}
			else {
				return false;
			}
		}
		
		private function get IsExpire():Boolean {
			return !(MinigameMgr.getInstance().checkMinigame());
		}
	}
};