package GUI.EventMidle8 
{
	import adobe.utils.CustomActions;
	import com.adobe.utils.IntUtil;
	import com.greensock.easing.*;
	import com.greensock.loading.display.ContentDisplay;
	import Data.Localization;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.net.SharedObject;
	import flash.text.TextFieldAutoSize;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.component.Tooltip;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import com.greensock.*;
	import Data.ConfigJSON;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.OfflineExp.SendEventMidle8Teleport;
	import NetworkPacket.PacketSend.SendBuyArrow;
	import NetworkPacket.PacketSend.SendGetEventOnRoad;
	import NetworkPacket.PacketSend.SendGetNextMap;
	import NetworkPacket.PacketSend.SendGetRandomDice;
	import NetworkPacket.PacketSend.SendSetGoGo;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGameEventMidle8 extends BaseGUI 
	{
	
		public var widthCtn:Number = 29;
		public var heightCtn:Number = 28.5;
		public var PearFlower:Object = new Object();
		public var MapId:int = 0;
		public var Position:Object = new Object();
		public var Dice:Object = new Object();
		public var Question:int = 0;
		public var JoinNum:int = 0;
		public var Revards:Object = new Object();
		public var History:Object = new Object();
		public var CreateTime:Number = 0;
		public var TeleportNum:int = 0;
		public var RoadState:int = 0;
		public var MazeKeyInfo:Object = new Object();
		
		public const DELTA_TORNADO_POINT_Y:int = 110;
		public const DELTA_TORNADO_POINT_X:int = 45;
		public var effTornado:SwfEffect = null;
		public var posDeltaTornado:Point;
		
		public var user:User;
		public var isTeleport:Boolean = false;
		public var isNextDay:Boolean = false;
		public var isFirstPlay:Boolean = false;
		public var isEff:Boolean = false;
		//public var isEffScrollBar:Boolean = false;
		public var isProcess:Boolean = false;
		public var count:int = 0;
		
		public var isProcessSpringy:Boolean = false;
		public var isFinishProcessSpringy:Boolean = false;
		public var isShowEffOpenWindow:Boolean = false;
		public var typeFall:int = 0;
		public const TYPE_FALL_DOWN:int = -1;
		public const TYPE_FALL_UP:int = 1;
		public const TYPE_FALL_NONE:int = 0;
		
		public var spSpringy:Sprite = null;
		
		public var dataGift:Object = new Object();;
		public var spProcess:Sprite;
		public var isMazeKey:Boolean = false;
		public var MAX_FRAME_PROCESS_ZOOM_IN:int = 10;
		public var MAX_FRAME_PROCESS_ZOOM_OUT:int = 6;
		public var isProcessZoomInOut:Boolean = false;
		public const ZOOM_IN:Number = 1.8;
		public const ZOOM_OUT:Number = 1.5;
		public var DELTA_ZOOM_IN:Number = (ZOOM_IN - 1) / MAX_FRAME_PROCESS_ZOOM_IN;
		public var DELTA_ZOOM_OUT:Number = (ZOOM_IN - 1) / MAX_FRAME_PROCESS_ZOOM_OUT;
		
		public var isShowScrollBar:Boolean = true;
		public var MAX_X_CLOSE_SCROLL_BAR:int = 625;
		public var MIN_X_OPEN_SCROLL_BAR:int = 310;
		
		public var txtKho:TextField;
		public var txtKhoEmpty:TextField;
		
		public var arrObjGift:Array = [];
		public var arrNameGift:Array = [];
		public var arrNumGift:Array = [];
		public var arrArrow:Array = [];
		
		public var isChooseTwoDice:Boolean = false;
		public var so:SharedObject;
		
		public var objArrow:Object = new Object();
		public var objMap:Object = new Object();
		public var objAllMap:Object = new Object();
		public var objAllMapRewards:Object = new Object();
		public var FishIdFollowLevel:Object = new Object();
		public var arrMapConstant:Array = [];
		public var arrMap:Array = [];
		public var arrMapLeaved:Array = [];
		public var arrGiftInMap:Array = [];
		public var arrIdCtnCanGo:Array = [];
		public var idCtnLiveNow:String;
		
		public const NUM_TIME_DELAY:int = 30;
		public const NUM_COL:int = 19;
		public const NUM_ROW:int = 18;
		
		public const ROAD_STATE_NORMAL:int = 0;
		public const ROAD_STATE_GOING:int = 1;
		public const ROAD_STATE_TORNADO:int = 2;
		public const ROAD_STATE____:int = 3;
		public const ROAD_STATE_ANSWERING:int = 4;
		
		public const STATE_START:int = 1;
		public const STATE_END:int = 2;
		public const STATE_FATE:int = 3;
		public const STATE_TREASURE:int = 4;
		public const STATE_LIVE:int = 8;
		public const STATE_CAN_MOVE:int = 7;
		public const STATE_SPECIAL_TREASURE:int = 5;
		public const STATE_CANT_MOVE:int = -1;
		public const STATE_LEAVED:int = 0;
		
		public const CELL_TREASURE:int = 4;
		public const CELL_SPECIAL_TREASURE:int = 5;
		public const CELL_END:int = 2;
		
		public const CELL_EXP:int = 10;
		public const CELL_MATERIAL:int = 11;
		public const CELL_ENERGY_ITEM:int = 12;
		public const CELL_BABY_FISH:int = 13;
		
		public const CELL_GIFT:int = 20;
		public const CELL_TORNADO:int = 21;
		public const CELL_QUESTION:int = 22;
		
		public const ARROW_UP:int = 1;
		public const ARROW_DOWN:int = 2;
		public const ARROW_LEFT:int = 3;
		public const ARROW_RIGHT:int = 4;
		public const ARROW_KEY:int = 5;
		public const ARROW_TORNADO:int = 6;
		
		public const PRICE_BY_ZMONEY:String = "ZMoney";
		public const PRICE_BY_MONEY:String = "Money";
		
		public const MAX_FISHTYPE:int = 79;
		public const COLOR_USER:int = 0xFF9933;
		public const COLOR_CAN_GO:int = 0xFFFF99;
		
		public static const GIFT_EXP:int = 10;
		public static const GIFT_MATERIAL:int = 11;
		public static const GIFT_ENERGY_ITEM:int = 12;
		public static const GIFT_BABYFISH:int = 13;
		public static const GIFT_FATE:int = 3;
		public static const GIFT_TREASURE:int = 4;
		
		public const IMG_TREASURE_OPEN:String = "ImgTreasureOpen";
		public const IMG_TREASURE_CLOSE:String = "ImgTreasureClose";
		public const IMG_CHOOSE_DICE:String = "ImgChooseDice";
		
		public const BTN_TREASURE_OPEN:String = "BtnTreasureOpen";
		public const BTN_TREASURE_CLOSE:String = "BtnTreasureClose";
		public static const BTN_CHOOSE_TWO_DICE:String = "BtnChooseTwoByG";
		public static const BTN_CLOSE:String = "BtnThoat";
		public static const BTN_HELP:String = "BtnHelp";
		public static const BTN_BUY_UP:String = "BtnBuyUp";
		public static const BTN_BUY_DOWN:String = "BtnBuyDown";
		public static const BTN_BUY_LEFT:String = "BtnBuyLeft";
		public static const BTN_BUY_RIGHT:String = "BtnBuyRight";
		public static const BTN_ASK_RIGHT:String = "BtnAskRight";
		public static const BTN_BUY_KEY:String = "BtnBuyKey";
		public static const BTN_BUY_TORNADO:String = "BtnBuyTornado";
		
		public static const BTN_AUTOMATIC:String = "BtnAutomatic";
		
		public static const BTN_UP:String = "BtnUp";
		public static const BTN_DOWN:String = "BtnDown";
		public static const BTN_LEFT:String = "BtnLeft";
		public static const BTN_RIGHT:String = "BtnRight";
		
		public static const BTN_UP_SMART:String = "BtnUpSmart";
		public static const BTN_DOWN_SMART:String = "BtnDownSmart";
		public static const BTN_LEFT_SMART:String = "BtnLeftSmart";
		public static const BTN_RIGHT_SMART:String = "BtnRightSmart";
		
		public static const BTNEX_KEY:String = "BtnExKey";
		public static const CTN_TORNADO:String = "CtnTornado";
		
		public static const IMG_TICKED:String = "ImgTick";
		public static const IMG_UP:String = "ImgUp";
		public static const IMG_DOWN:String = "ImDown";
		public static const IMG_LEFT:String = "ImgLeft";
		public static const IMG_RIGHT:String = "ImgRight";
		
		//public const CTN_CHOOSE_DICE_ONE:String = "CtnDiceOne";
		public const CTN_CHOOSE_DICE_TWO:String = "CtnDiceTwo";
		public const CTN_TREASURE:String = "CtnTreasure";
		public const CTN_TREASURE_STORE:String = "CtnTreasureStore";
		public static const CTN_UP:String = "CtnUp";
		public static const CTN_DOWN:String = "CtnDown";
		public static const CTN_LEFT:String = "CtnLeft";
		public static const CTN_RIGHT:String = "CtnRight";
		public static const CTN_SQUARE:String = "CtnSquare_";
		public static const CTN_GIFT_SCROLL:String = "CtnGiftScroll_";
		
		public static const WIDTH_CTN_IN_SCROLL:int = 75;
		public static const HEIGHT_CTN_IN_SCROLL:int = 78;
		
		public var ctnDiceOne:Container;
		public var ctnDiceTwo:Container;
		public var ctnTreasure:Container;
		public var ctnTreasureStore:Container;
		
		public var txtNumArrowUp:TextField;
		public var txtNumArrowDown:TextField;
		public var txtNumArrowLeft:TextField;
		public var txtNumArrowRight:TextField;
		public var txtNumArrowKey:TextField;
		public var txtNumTeleport:TextField;
		public var txtWarningTeleport:TextField;
		
		public var txtLabelZMoneyKey:TextField;
		public var txtTimeFinish:TextField;
		public var timePlay:Number = 0;
		public var hour:int = 0;
		public var min:int = 0;
		public var sec:int = 0;
		
		private var Content: Sprite = new Sprite();
		private var m_scroll:ScrollPane = new ScrollPane();
		
		private var ctnScrollBar:Container;
		private var scrollBar:ScrollBar;
		private var listGift:ListBox;
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitDataGame:Sprite = new DataLoading();
		private var WaitDataReverts:Sprite = new DataLoading();
		
		
		
		public function GUIGameEventMidle8(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGameEventMidle8";
		}
		
		override public function InitGUI():void 
		{
			so = SharedObject.getLocal("GameMidle8_Ver3" + GameLogic.getInstance().user.GetMyInfo().Id.toString())
			if (so.data.isFirstPlay == null || so.data.isFirstPlay == false)
			{
				so.data.isFirstPlay = true;
				Ultility.FlushData(so);
				GuiMgr.getInstance().GuiGuideGameTrungThu.Show(Constant.GUI_MIN_LAYER, 1);
				Hide();
				return;
			}
			isTeleport = false;
			isStartSendRandomDice = false;
			super.InitGUI();
			GameLogic.getInstance().HideFish();
			LoadRes("GUIGameEventMidle8_ImgBgGUIGameTrungThu");
			SetPos(0, 0);
			InitBaseData();
			img.addChild(WaitDataGame);
			WaitDataGame.x = 250;
			WaitDataGame.y = 250;
			AddBtn();
			CheckFirstPlay();
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			if (!isFirstPlay)
			{
				RefreshAllComponent();
			}
			else 
			{
				isFirstPlay = false;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			if (isNextDay)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã sang ngày mới\nHãy chờ hệ thống xử lý trong giây lát");
				return;
			}
			if (isNextDay || isEff || isProcess)	return;
			if (!GameLogic.getInstance().isEvent("PearFlower"))
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian diễn ra sự kiện.");	
				if(GameLogic.getInstance().user.coralTree && GameLogic.getInstance().user.coralTree.img && GameLogic.getInstance().user.coralTree.img.visible)
				{
					GameLogic.getInstance().user.coralTree.Destructor();
				}
				HideGUI();
				return;
			}
			switch (buttonID) 
			{
				case BTN_AUTOMATIC:
					GuiMgr.getInstance().GuiAutomaticGame.Show(Constant.GUI_MIN_LAYER, 1);
				break;
				case BTN_CLOSE:
					if(!isEff)
						HideGUI();
				break;
				case BTN_HELP:
					GuiMgr.getInstance().GuiGuideGameTrungThu.Show(Constant.GUI_MIN_LAYER, 3);
				break;
				case BTN_UP:
				case BTN_UP_SMART:
					if (isTeleport)	return;
					RandomDice(ARROW_UP, false, int(CreateTime));
				break;
				case BTN_DOWN:
				case BTN_DOWN_SMART:
					if (isTeleport)	return;
					RandomDice(ARROW_DOWN, false, int(CreateTime));
				break;
				case BTN_LEFT:
				case BTN_LEFT_SMART:
					if (isTeleport)	return;
					RandomDice(ARROW_LEFT, false, int(CreateTime));
				break;
				case BTN_RIGHT:
				case BTN_RIGHT_SMART:
					if (isTeleport)	return;
					RandomDice(ARROW_RIGHT, false, int(CreateTime));
				break;
				case BTN_BUY_KEY:
					// Effect mở chìa khóa khi đủ điều kiện
					if (arrIdCtnCanGo.length >= 0 && idCtnLiveNow)	
					{
						var rowCur:int = int(idCtnLiveNow.split("_")[1]);
						var colCur:int = int(idCtnLiveNow.split("_")[2]);
						if(int(objMap[rowCur.toString()][colCur.toString()] == STATE_SPECIAL_TREASURE))
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể mua chìa khóa khi đang ở trạng thái này");
							return;
						}
					}
					var ctnEnd:Container = GetContainer(CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1));
					if (arrArrow[ARROW_KEY - 1] <= 0 && MazeKeyInfo.Num && MazeKeyInfo.Num <= 0)
					{
						isEff = true;
						EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffOpenWindowGameMidle8", null, ctnEnd.CurPos.x - widthCtn, ctnEnd.CurPos.y - heightCtn,
															false, false, null, function():void { ShowLock(int(CreateTime)) } );
					}
					BuyArrowAndKey(ARROW_KEY, PRICE_BY_ZMONEY);
				break;
				case BTN_BUY_UP:
					BuyArrowAndKey(ARROW_UP, PRICE_BY_ZMONEY);
				break;
				case BTN_BUY_DOWN:
					BuyArrowAndKey(ARROW_DOWN, PRICE_BY_ZMONEY);
				break;
				case BTN_BUY_LEFT:
					BuyArrowAndKey(ARROW_LEFT, PRICE_BY_ZMONEY);
				break;
				case BTN_BUY_RIGHT:
					BuyArrowAndKey(ARROW_RIGHT, PRICE_BY_ZMONEY);
				break;
				case CTN_TREASURE_STORE:
					ShowScrollBar(ctnTreasureStore.GetImage(IMG_TREASURE_CLOSE).img.visible);
				break;
				case BTN_TREASURE_CLOSE:
					ShowScrollBar(false);
				break;
				case CTN_TORNADO:
				if(RoadState == ROAD_STATE_NORMAL && (!Dice || !Dice.Num || Dice.Num == 0) && !isEff)
				{
					var zxuPay:int = objArrow[ARROW_TORNADO.toString()].ZMoney;//bh 6548031  -> 1221
					if (GameLogic.getInstance().user.GetZMoney() < zxuPay)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						return;
					}
					if(txtWarningTeleport.visible == false)
					{
						var ctnTornado:Container = GetContainer(CTN_TORNADO);
						isTeleport = !isTeleport;
						ctnTornado.GetImage(IMG_TICKED).img.visible = isTeleport;
						ShowCanTornado(isTeleport);
						GetButton(BTN_UP_SMART).SetVisible(!isTeleport);
						GetButton(BTN_DOWN_SMART).SetVisible(!isTeleport);
						GetButton(BTN_LEFT_SMART).SetVisible(!isTeleport);
						GetButton(BTN_RIGHT_SMART).SetVisible(!isTeleport);
						if (!isTeleport)
						{
							ShowBtnArrow();
						}
					}
				}
				break;
				default:
					if (buttonID.search(CTN_SQUARE) >= 0)
					{
						EffGoGo(buttonID, int(CreateTime));
					}
				break;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			var i:int = 0;
			if (isNextDay || isEff || isProcess)	return;
			if (idCtnLiveNow == buttonID)	return;
			var ctn:Container;
			if (buttonID.search(CTN_GIFT_SCROLL) >= 0)
			{
				ctn = listGift.getItemById(buttonID);
				var IdGIftInData:int = buttonID.split("_")[1];
				var objData:Object = arrObjGift[IdGIftInData];
				if (arrNameGift[IdGIftInData].search("_Shop") >= 0) 
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(objData);
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				}
			}
			if(buttonID.search(CTN_SQUARE) >= 0)
			{
				GetContainer(buttonID).SetHighLight();
			}
			if (buttonID.search("BtnEx") >= 0) 
			{
				if(GetButtonEx(buttonID).img.mouseEnabled)
					GetButtonEx(buttonID).SetHighLight(-1);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonOut(event, buttonID);
			var i:int
			var isInArrIdCtn:Boolean = false;
			if (isNextDay || isEff || isProcess)	return;
			if (idCtnLiveNow == buttonID)
			{
				return;
			}
			var ctn:Container;
			if (buttonID.search(CTN_GIFT_SCROLL) >= 0)
			{
				ctn = listGift.getItemById(buttonID);
				var IdGIftInData:int = buttonID.split("_")[1];
				var objData:Object = arrObjGift[IdGIftInData];
				if (arrNameGift[IdGIftInData].search("_Shop")) 
				{
					if(GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					}
				}
			}
			for (i = 0; i < arrIdCtnCanGo.length; i++)
			{
				if (buttonID == arrIdCtnCanGo[i])
				{
					GetContainer(buttonID).SetHighLight(COLOR_CAN_GO);
					return;
				}
			}
			if(buttonID.search(CTN_SQUARE) >= 0)
			{
				GetContainer(buttonID).SetHighLight(-1);
			}
			if (buttonID.search("BtnEx") >= 0) 
			{
				if(GetButtonEx(buttonID).img.mouseEnabled)
					GetButtonEx(buttonID).SetHighLight(-1);
			}
		}
		
		public function ShowCanTornado(isShow:Boolean):void 
		{
			var rowNow:int = idCtnLiveNow.split("_")[1];
			var colNow:int = idCtnLiveNow.split("_")[2];
			var rowS:int = Math.max(0, rowNow - 5);
			var rowE:int = Math.min(NUM_ROW - 1, rowNow + 5);
			var colS:int = Math.max(0, colNow - 5);
			var colE:int = Math.min(NUM_COL, colNow + 5);
			var i:int = 0;
			var j:int = 0;
			arrIdCtnCanGo = [];
			if (isShow)
			{
				for (i = rowS; i < rowE + 1; i++) 
				{
					for (j = colS; j <= colE; j++)
					{
						if (GetContainer(CTN_SQUARE + i + "_" + j) && (CTN_SQUARE + i + "_" + j) != idCtnLiveNow)
						{
							GetContainer(CTN_SQUARE + i + "_" + j).SetHighLight(COLOR_CAN_GO);
							arrIdCtnCanGo.push(CTN_SQUARE + i + "_" + j);
						}
					}
				}
			}
			else 
			{
				for (i = rowS; i < rowE + 1; i++) 
				{
					for (j = colS; j <= colE; j++)
					{
						if (GetContainer(CTN_SQUARE + i + "_" + j) && (CTN_SQUARE + i + "_" + j) != idCtnLiveNow)
						{
							GetContainer(CTN_SQUARE + i + "_" + j).SetHighLight(-1);
						}
					}
				}
				arrIdCtnCanGo = [];
				// Khởi tạo các ô mà có thể chọn
				if(Dice && Dice.Arrow && Dice.Arrow > 0 && Dice.Arrow < ARROW_KEY)
				{
					HightLightCtnAffterRandomDice(GetDeltaFromArrow(Dice.Arrow).x, GetDeltaFromArrow(Dice.Arrow).y, Dice.Num);
					DiableAllArrowBtn();
				}
			}
		}
		
		public function ShowScrollBar(isShow:Boolean = true):void 
		{
			isShowScrollBar = isShow;
			ctnTreasureStore.GetImage(IMG_TREASURE_OPEN).img.visible = isShow;
			ctnTreasureStore.GetImage(IMG_TREASURE_CLOSE).img.visible = !isShow;
		}
		/**
		 * Hàm thực hiện mua các mũi tên
		 * @param	typeArrow
		 * @param	priceType
		 */
		public function BuyArrowAndKey(typeArrow:int, priceType:String):void 
		{
			var price:int = int(objArrow[typeArrow.toString()][priceType]);
			if (GameLogic.getInstance().user.GetZMoney() < price)	
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
			}
			
			var cmd:SendBuyArrow = new SendBuyArrow(typeArrow, priceType);
			Exchange.GetInstance().Send(cmd);
			
			switch (typeArrow) 
			{
				case ARROW_UP:
					txtNumArrowUp.text = (int(txtNumArrowUp.text) + 1).toString();
				break;
				case ARROW_DOWN:
					txtNumArrowDown.text = (int(txtNumArrowDown.text) + 1).toString();
				break;
				case ARROW_LEFT:
					txtNumArrowLeft.text = (int(txtNumArrowLeft.text) + 1).toString();
				break;
				case ARROW_RIGHT:
					txtNumArrowRight.text = (int(txtNumArrowRight.text) + 1).toString();
				break;
				case ARROW_KEY:
					txtNumArrowKey.text = (int(txtNumArrowKey.text) + 1).toString();
				break;
			}
			GuiMgr.getInstance().GuiStore.UpdateStore("Arrow", typeArrow, 1);
			arrArrow[typeArrow - 1] ++;
			if(priceType == PRICE_BY_ZMONEY)
			{
				GameLogic.getInstance().user.UpdateUserZMoney( -price);
			}
			if(arrIdCtnCanGo == null || arrIdCtnCanGo.length == 0)
			{
				ShowBtnArrow();
			}
			EffectMgr.setEffBounceDown("Mua thành công", "GUIGameEventMidle8_Arrow" + typeArrow, Constant.STAGE_WIDTH / 2 - 170, Constant.STAGE_HEIGHT / 2 - 50);
		}
		
		public var isStartSendRandomDice:Boolean = false;
		public var countIsStartSendRandomDice:int = 0;
		public function RandomDice(typeArrow:int, isTwoDice:Boolean, timeStamp:int):void 
		{
			if (isStartSendRandomDice)	return;
			isStartSendRandomDice = true;
			isEff = true;
			if (GameLogic.getInstance().user.GetZMoney() < 1 && isTwoDice)
			{
				GuiMgr.getInstance().GuiNapG.Init();
				isEff = false;
				return;
			}
			DiableAllArrowBtn();
			arrArrow[typeArrow - 1]--;
			GuiMgr.getInstance().GuiStore.UpdateStore("Arrow", typeArrow, -1);
			switch (typeArrow) 
			{
				case ARROW_DOWN:
					txtNumArrowDown.text = arrArrow[typeArrow - 1].toString();
				break;
				case ARROW_UP:
					txtNumArrowUp.text = arrArrow[typeArrow - 1].toString();
				break;
				case ARROW_RIGHT:
					txtNumArrowRight.text = arrArrow[typeArrow - 1].toString();
				break;
				case ARROW_LEFT:
					txtNumArrowLeft.text = arrArrow[typeArrow - 1].toString();
				break;
			}
			var cmd:SendGetRandomDice = new SendGetRandomDice(isTwoDice, GetDeltaFromArrow(typeArrow).x, GetDeltaFromArrow(typeArrow).y, typeArrow, timeStamp);
			if (isTwoDice)
			{
				user.UpdateUserZMoney( -1);
				Exchange.GetInstance().Send(cmd);
			}
			else 
			{
				Exchange.GetInstance().Send(cmd);
			}
			if (Dice == null)
			{
				Dice = new Object();
			}
			Dice.Num = 2;
			Dice.Arrow = 1
		}
		/**
		 * Enable các nút có thể đi được
		 */
		public function ShowBtnArrow():void 
		{
			UpdatePositionBtnSmart();
			
			GetButton(BTN_UP_SMART).SetVisible(false);
			GetButton(BTN_RIGHT_SMART).SetVisible(false);
			GetButton(BTN_LEFT_SMART).SetVisible(false);
			GetButton(BTN_DOWN_SMART).SetVisible(false);
			
			var row:int = idCtnLiveNow.split("_")[1];
			var col:int = idCtnLiveNow.split("_")[2];
			if (GetContainer(CTN_SQUARE + (row + 1) + "_" + col) && row < NUM_ROW - 1 && int(txtNumArrowDown.text) > 0)		
			{
				GetButton(BTN_DOWN).SetEnable(true);
				GetButton(BTN_DOWN_SMART).SetEnable(true);
				GetButton(BTN_DOWN_SMART).SetVisible(true);
			}
			else 
			{
				GetButton(BTN_DOWN).SetEnable(false);
				GetButton(BTN_DOWN_SMART).SetEnable(false);
				if (GetContainer(CTN_SQUARE + (row + 1) + "_" + col) && row < NUM_ROW - 1)
				{
					GetButton(BTN_DOWN_SMART).SetVisible(true);
				}
			}
			
			if (GetContainer(CTN_SQUARE + (row - 1) + "_" + col) && row > 0 && int(txtNumArrowUp.text) > 0)				
			{
				GetButton(BTN_UP).SetEnable(true);
				GetButton(BTN_UP_SMART).SetEnable(true);
				GetButton(BTN_UP_SMART).SetVisible(true);
			}
			else 
			{
				GetButton(BTN_UP).SetEnable(false);
				GetButton(BTN_UP_SMART).SetEnable(false);
				if (GetContainer(CTN_SQUARE + (row - 1) + "_" + col) && row > 0)
				{
					GetButton(BTN_UP_SMART).SetVisible(true);
				}
			}
			
			if (GetContainer(CTN_SQUARE + (row) + "_" + (col + 1)) && col < NUM_COL - 1 && int(txtNumArrowRight.text) > 0)	
			{
				GetButton(BTN_RIGHT).SetEnable(true);
				GetButton(BTN_RIGHT_SMART).SetEnable(true);
				GetButton(BTN_RIGHT_SMART).SetVisible(true);
			}
			else 
			{
				GetButton(BTN_RIGHT).SetEnable(false);
				GetButton(BTN_RIGHT_SMART).SetEnable(false);
				if(GetContainer(CTN_SQUARE + (row) + "_" + (col + 1)) && col < NUM_COL - 1)
				{
					GetButton(BTN_RIGHT_SMART).SetVisible(true);
				}
			}
			
			if (GetContainer(CTN_SQUARE + (row) + "_" + (col - 1)) && col > 0 && int(txtNumArrowLeft.text) > 0)				
			{
				GetButton(BTN_LEFT).SetEnable(true);
				GetButton(BTN_LEFT_SMART).SetEnable(true);
				GetButton(BTN_LEFT_SMART).SetVisible(true);
			}
			else 
			{
				GetButton(BTN_LEFT).SetEnable(false);
				GetButton(BTN_LEFT_SMART).SetEnable(false);
				if(GetContainer(CTN_SQUARE + (row) + "_" + (col - 1)) && col > 0)
				{
					GetButton(BTN_LEFT_SMART).SetVisible(true);
				}
			}
		}
		
		/**
		 * Enable hoặc disable 
		 * @param	isDisable
		 */
		public function DiableAllArrowBtn(isDisable:Boolean = true):void 
		{
			UpdatePositionBtnSmart();
			
			GetButton(BTN_DOWN).SetEnable(!isDisable);
			GetButton(BTN_UP).SetEnable(!isDisable);
			GetButton(BTN_LEFT).SetEnable(!isDisable);
			GetButton(BTN_RIGHT).SetEnable(!isDisable);
			
			GetButton(BTN_DOWN_SMART).SetVisible(!isDisable);
			GetButton(BTN_UP_SMART).SetVisible(!isDisable);
			GetButton(BTN_LEFT_SMART).SetVisible(!isDisable);
			GetButton(BTN_RIGHT_SMART).SetVisible(!isDisable);
		}
		
		public function UpdatePositionBtnSmart():void 
		{
			var ctn:Container = GetContainer(idCtnLiveNow);
			var curPosFish:Point = new Point(ctn.CurPos.x - 18, ctn.CurPos.y - 22);
			var DELTA_X:int = 44;
			var DELTA_Y:int = 43;
			GetButton(BTN_DOWN_SMART).SetPos(curPosFish.x, curPosFish.y + DELTA_Y);
			GetButton(BTN_UP_SMART).SetPos(curPosFish.x, curPosFish.y - DELTA_Y);
			GetButton(BTN_LEFT_SMART).SetPos(curPosFish.x - DELTA_X, curPosFish.y);
			GetButton(BTN_RIGHT_SMART).SetPos(curPosFish.x + DELTA_X, curPosFish.y);
		}
		
		/**
		 * Add các button cần thiết
		 */
		public function AddBtn():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 811 - 35, 18, this);
			AddButton(BTN_HELP, "GUIGameEventMidle8_BtnGuide", 811 - 75, 18, this);
		}
		 
		public function AddContent():void 
		{
			var txtFormat:TextFormat;
			if (arrNameGift && arrNameGift.length == 0)
			{
				var strTextShowKho:String = "Rương hiện tại trống rỗng";
				var strTextShowKhoEmpty:String = "(Nhấn vào rương báu để ẩn (hiện) rương!^_^!)";
				txtFormat = new TextFormat("Arial", 20, 0x707070);
				txtKho = ctnScrollBar.AddLabel(strTextShowKho , 110, 90);
				txtKho.setTextFormat(txtFormat);
				txtFormat = new TextFormat("Arial", 12, 0xFF0000);
				txtKhoEmpty = ctnScrollBar.AddLabel(strTextShowKhoEmpty , 110, 120);
				txtKhoEmpty.setTextFormat(txtFormat);
			}
			else 
			{
				if (arrNameGift && arrNameGift.length > 0)
				{
					if (txtKho)	txtKho.visible = false;
					if (txtKhoEmpty)	txtKhoEmpty.visible = false;
				}
				
				for (var i:int = 0; i < arrNameGift.length; i++) 
				{
					var container:Container;
					var objGift:Object = arrObjGift[i] as Object;
					var strName:String = arrNameGift[i];
					var numGift:int = arrNumGift[i];
					container = AddElementGift(strName, objGift, numGift);
					container.IdObject = "ctn" + i;
					listGift.addItem(CTN_GIFT_SCROLL + i, container, this);
				}
			}
		
			if (listGift)	
			{
				if (listGift.length > 0)
				{
					if (txtKho)	txtKho.visible = false;
					if (txtKhoEmpty)	txtKhoEmpty.visible = false;
				}
				else 
				{
					if (txtKho)	txtKho.visible = true;
					if (txtKhoEmpty)	txtKhoEmpty.visible = true;
				}
				if (listGift.length > 6)
				{
					scrollBar.visible = true;
				}
				else 
				{
					scrollBar.visible = false;
				}
			}
			else 
			{
				scrollBar.visible = false;
				if (txtKho)	txtKho.visible = true;
				if (txtKhoEmpty)	txtKhoEmpty.visible = true;
			}
		}
		
		public function AddElementGift(strName:String, objGift:Object, numGift:int):Container 
		{
			var setInfo:Function = function():void
			{
				//Vẽ aura bằng glowFilter
				var cl:int = 0xff0000;
				TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
			}
			var ctn:Container = new Container(listGift, "GUIGameEventMidle8_CtnSlotGiftGame8");
			var isFishRare:Boolean = false;
			var imageContent:Image;
			var domain:int;
			if (strName.search("Fish") >= 0)
			{
				var FishType:int = int(strName.split("_")[2]);
				var FishTypeId:int = int(strName.split("_")[1]);
				FishTypeId = Math.min(FishTypeId, MAX_FISHTYPE);
				domain = Ultility.DomainFish(FishTypeId);
				strName = "Fish" + (FishTypeId - Math.max(domain, 0)) + "_" + Fish.OLD + "_" + Fish.HAPPY;
				if (FishType == Fish.FISHTYPE_RARE)
				{
					isFishRare = true;
				}
			}
			if (strName == "Sparta")
			{
				isFishRare = true;
			}
			if (isFishRare)
			{
				imageContent = ctn.AddImage("ImgContent", strName, 0, 0, true, ALIGN_CENTER_CENTER, false, setInfo);
			}
			else
			{
				imageContent = ctn.AddImage("ImgContent", strName, 0, 0);
			}
			imageContent.FitRect(50, 50, new Point(10, 0));
			if (domain > 0)
			{
				ctn.AddImage("ImgDomain", Fish.DOMAIN + domain.toString(), 0, 0).FitRect(20,20, new Point(25,0));
			}
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.bold = true;
			txtFormat.color = 0xFFFF00;
			txtFormat.size = 16;
			var txtBox:TextField = ctn.AddLabel("x" + Ultility.StandardNumber(numGift), -15, HEIGHT_CTN_IN_SCROLL - 24, 0xFFFF00, 1, 0x26709C);
			txtBox.setTextFormat(txtFormat);
			txtBox.defaultTextFormat = txtFormat;
			
			var ToolTip:TooltipFormat = new TooltipFormat();
			switch (objGift.ItemType) 
			{
				case "Money":
					ToolTip.text = "Tiền nhận được khi thoát khỏi mê cung";
				break;
				case "EnergyItem":
				case "RankPointBottle":
				case "Material":
					ToolTip.text = Localization.getInstance().getString(objGift.ItemType + objGift.ItemId);
				break;
				default:
					return ctn;
				break;
			}
			ctn.setTooltip(ToolTip);
			
			return ctn;
		}
		
		public function CheckCanBuyIconInEvent(eventName:String):Boolean
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			if (event && event[eventName] && event[eventName]["BeginTime"] <= GameLogic.getInstance().CurServerTime - Constant.NUM_DAY_START_BUY_EVENT * 86400)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * Bắt đầu vẽ game sau khi khởi tạo xong hết dữ liệu
		 */
		public function RefreshAllComponent():void 
		{
			var i:int = 0;
			var j:int = 0;
			m_scroll = new ScrollPane();
			Content = new Sprite();
			//if (WaitDataGame.parent)	
				//WaitDataGame.parent.removeChild(WaitDataGame);
			ClearComponent();
			ResetData();
			
			isTeleport = false;
			InitBaseData();
			AddBtn();
			
			InitData();
			
			//AddImage("ImageBgGame", "GUIGameEventMidle8_ImgBgGameTrungThu" + Math.floor(Math.random() * 3 + 1), 22, 60);
			AddImage("ImageBgGame", "GUIGameEventMidle8_ImgBgGameTrungThu" + Math.floor(Math.random() * 3 + 1), 22, 60);
			GetImage("ImageBgGame").SetPos(	GetImage("ImageBgGame").img.width / 2 + GetImage("ImageBgGame").CurPos.x,
											GetImage("ImageBgGame").img.height / 2 + GetImage("ImageBgGame").CurPos.y)
			for (i = 0; i < NUM_ROW; i++)
			{
				for (j = 0; j < NUM_COL; j++)
				{
					if(arrMap[i][j] != STATE_CANT_MOVE)
					{
						DrawSquare(i, j)
					}
				}
			}
			
			// Hightlight ô người chơi đang đứng
			GetContainer(idCtnLiveNow).SetHighLight(COLOR_USER);
			
			for (i = 0; i < arrIdCtnCanGo.length; i++) 
			{
				GetContainer(arrIdCtnCanGo[i]).SetHighLight(COLOR_CAN_GO);
			}
			
			// Vẽ xúc xắc
			var toolTipAll:TooltipFormat;
			
			toolTipAll = new TooltipFormat();
			toolTipAll.text = "Tìm hiểu cách chơi";
			GetButton(BTN_HELP).setTooltip(toolTipAll);
			
			var objPriceArrowTemp:Object = new Object();
			
			toolTipAll = new TooltipFormat();
			toolTipAll.text = "Rương đựng đồ \nnhặt được trong mê cung";
			var delta_Y_1:int = 420;
			var delta_X_1:int = -10;
			//ctnTreasureStore = AddContainer(CTN_TREASURE_STORE, "CtnRevards", 660, 73 + delta_Y_1, true, this);
			ctnTreasureStore = AddContainer(CTN_TREASURE_STORE, "GUIGameEventMidle8_ImgFrameFriend", 635, 73 + delta_Y_1, true, this);
			ctnTreasureStore.setTooltip(toolTipAll);
			ctnTreasureStore.AddImage(IMG_TREASURE_OPEN, "GUIGameEventMidle8_ImgRevards_Open", 1 + 58, 12 + 45).img.visible = isShowScrollBar;
			ctnTreasureStore.AddImage(IMG_TREASURE_CLOSE, "GUIGameEventMidle8_ImgRevards_Close", 1 + 57, 12 + 51).img.visible = !isShowScrollBar;
			
			// Add khóa và lốc xoáy
			var delta_Y_2:int = -218;
			toolTipAll = new TooltipFormat();
			toolTipAll.text = Localization.getInstance().getString("Arrow5");
			AddButtonEx(BTNEX_KEY, "GUIGameEventMidle8_BtnExGameMidle8Key", 628, 288 + delta_Y_2, this);
			txtNumArrowKey = AddLabel(arrArrow[ARROW_KEY - 1].toString(), 590, 288 + delta_Y_2, 0xFFFFFF, 1, 0x000000);
			GetButtonEx(BTNEX_KEY).setTooltip(toolTipAll);
			AddButton(BTN_BUY_KEY, "GUIGameEventMidle8_BtnBuyByG", 638, 350 + delta_Y_2, this);//.SetVisible(false);
			objPriceArrowTemp = objArrow[ARROW_KEY.toString()];
			txtLabelZMoneyKey = AddLabel(objPriceArrowTemp.ZMoney.toString(), 608, 351 + delta_Y_2, 0x00FF00, 1, 0x000000);
			//txtLabelZMoneyKey.visible = false;
			if (CheckCanBuyIconInEvent("PearFlower"))
			{
				GetButton(BTN_BUY_KEY).SetVisible(true);
				txtLabelZMoneyKey.visible = true;
			}
			
			toolTipAll = new TooltipFormat();
			toolTipAll.text = "Dịch chuyển tức thời\nNhảy đến ô bất kỳ trong phạm vi\n 5 ô so với vị trí hiện tại\nMỗi bản đồ chỉ được dùng 3 lần";
			var ctnTornado:Container = AddContainer(CTN_TORNADO, "GUIGameEventMidle8_CtnGameMidle8Tornado", 706, 288 + delta_Y_2, true, this);
			ctnTornado.AddImage(CTN_TORNADO, "GUIGameEventMidle8_IcTornado", 0, 0);
			ctnTornado.AddImage(IMG_TICKED, "GuiAnserQuestion_ImgTickedGameMidle8", 70, 5);
			ctnTornado.GetImage(CTN_TORNADO).FitRect(70, 70, new Point(0, 0));
			ctnTornado.GetImage(IMG_TICKED).FitRect(20, 20, new Point(55, 0));
			ctnTornado.setTooltip(toolTipAll);
			ctnTornado.AddButton(BTN_BUY_TORNADO, "GUIGameEventMidle8_BtnBuyByG", 10, 60);
			var numTeleportMax:int = 3;
			txtNumTeleport = ctnTornado.AddLabel((objArrow[ARROW_TORNADO.toString()].ZMoney).toString(), -18, 60, 0x00FF00, 1, 0x000000);
			txtWarningTeleport= AddLabel("Bạn đã hết\nsố lần được\n sử dụng", 693, 295 + delta_Y_2, 0xFF0000, 1, 0x000000);
			if (TeleportNum >= numTeleportMax)
			{
				ctnTornado.GetImage(CTN_TORNADO).img.visible = false;
				ctnTornado.GetImage(IMG_TICKED).img.visible = false;
				txtWarningTeleport.visible = true;
				Ultility.SetEnableSprite(ctnTornado.img, false);
			}
			else 
			{
				ctnTornado.GetImage(CTN_TORNADO).img.visible = true;
				ctnTornado.GetImage(IMG_TICKED).img.visible = isTeleport;
				txtWarningTeleport.visible = false;
				Ultility.SetEnableSprite(ctnTornado.img);
			}
			
			AddButton(BTN_AUTOMATIC, "GUIGameEventMidle8_BtnAutomatic", 647, 341, this);
			
			// Add các mũi tên
			AddButton(BTN_UP, "GUIGameEventMidle8_BtnGameMidle8Up", 685, 258 - 85, this);
			txtNumArrowUp = AddLabel(arrArrow[ARROW_UP - 1].toString(), 651, 262 - 85, 0xFFFFFF, 1, 0x000000);
			
			AddButton(BTN_DOWN, "GUIGameEventMidle8_BtnGameMidle8Down", 684, 345 - 85, this);
			txtNumArrowDown = AddLabel(arrArrow[ARROW_DOWN - 1].toString(), 651, 365 - 85, 0xFFFFFF, 1, 0x000000);
			toolTipAll = new TooltipFormat();
			toolTipAll.text = Localization.getInstance().getString("Arrow2");
			
			AddButton(BTN_LEFT, "GUIGameEventMidle8_BtnGameMidle8Left", 636, 308 - 85, this);
			txtNumArrowLeft = AddLabel(arrArrow[ARROW_LEFT - 1].toString(), 601, 315 - 85, 0xFFFFFF, 1, 0x000000);
			
			AddButton(BTN_RIGHT, "GUIGameEventMidle8_BtnGameMidle8Right", 724, 308 - 85, this);
			txtNumArrowRight = AddLabel(arrArrow[ARROW_RIGHT - 1].toString(), 701, 315 - 85, 0xFFFFFF, 1, 0x000000);
			
			// add các mũi tên 
			AddButton(BTN_UP_SMART, "GUIGameEventMidle8_BtnGameMidle8Up", 689, 258, this);
			AddButton(BTN_DOWN_SMART, "GUIGameEventMidle8_BtnGameMidle8Down", 689, 345, this);
			AddButton(BTN_LEFT_SMART, "GUIGameEventMidle8_BtnGameMidle8Left", 640, 308, this);
			AddButton(BTN_RIGHT_SMART, "GUIGameEventMidle8_BtnGameMidle8Right", 728, 308, this);
			
			// Add các button mua và giá
			var delta_X_Arrow_Buy:int = 15;
			var delta_Y_Arrow_Buy:int = 20;
			AddButton(BTN_BUY_UP, "GUIGameEventMidle8_BtnBuyByG", 638, 408, this);
			AddImage(IMG_UP, "GUIGameEventMidle8_ArrowSmall" + ARROW_UP, 638 + delta_X_Arrow_Buy, 408 + delta_Y_Arrow_Buy);
			objPriceArrowTemp = objArrow[ARROW_UP.toString()];
			AddLabel(objPriceArrowTemp.ZMoney.toString(), 615, 409, 0x00FF00, 1, 0x000000);
			
			AddButton(BTN_BUY_DOWN, "GUIGameEventMidle8_BtnBuyByG", 716, 408, this);
			AddImage(IMG_DOWN, "GUIGameEventMidle8_ArrowSmall" + ARROW_DOWN, 716 + delta_X_Arrow_Buy, 408 + delta_Y_Arrow_Buy);
			objPriceArrowTemp = objArrow[ARROW_DOWN.toString()];
			AddLabel(objPriceArrowTemp.ZMoney.toString(), 693, 409, 0x00FF00, 1, 0x000000);
			
			AddButton(BTN_BUY_LEFT, "GUIGameEventMidle8_BtnBuyByG", 638, 449, this);
			AddImage(IMG_LEFT, "GUIGameEventMidle8_ArrowSmall" + ARROW_LEFT, 638 + delta_X_Arrow_Buy, 449 + delta_Y_Arrow_Buy);
			objPriceArrowTemp = objArrow[ARROW_LEFT.toString()];
			AddLabel(objPriceArrowTemp.ZMoney.toString(), 615, 450, 0x00FF00, 1, 0x000000);
			
			AddButton(BTN_BUY_RIGHT, "GUIGameEventMidle8_BtnBuyByG", 716, 449, this);
			AddImage(IMG_RIGHT, "GUIGameEventMidle8_ArrowSmall" + ARROW_RIGHT, 716 + delta_X_Arrow_Buy, 449 + delta_Y_Arrow_Buy);
			objPriceArrowTemp = objArrow[ARROW_RIGHT.toString()];
			AddLabel(objPriceArrowTemp.ZMoney.toString(), 693, 450, 0x00FF00, 1, 0x000000);
			
			DiableAllArrowBtn();
			ShowBtnArrow();
			
			// thời gian count down báo sắp hết ngày
			timePlay = GameLogic.getInstance().CurServerTime * 1000 - NUM_TIME_DELAY * 1000;
			var date:Date = new Date(timePlay);
			hour = int(date.getUTCHours() + Constant.TIME_ZONE_SERVER);
			if (hour >= 24)	hour -= 24;
			min = int(date.getUTCMinutes());
			sec = int(date.getUTCSeconds());
			if (sec == 0)
			{
				if (min == 0) 
				{
					hour = 24 - hour;
				}
				else 
				{
					hour = 23 - hour;
					min = 60 - min;
				}
			}
			else 
			{
				sec = 60 - sec;
				min = 59 - min;
				hour = 23 - hour;
			} 
			txtTimeFinish = AddLabel("Còn " + hour + ":" + min + ":" + sec + " để thoát khỏi mê cung", 400, 20, 0xffffff, 1, 0x26709C);
			var	txtFormatTime:TextFormat = new TextFormat();
			txtFormatTime.size = 20;
			txtTimeFinish.setTextFormat(txtFormatTime);
			txtTimeFinish.defaultTextFormat = txtFormatTime;
			
			// Effect mở chìa khóa khi đủ điều kiện
			var ctnEnd:Container = GetContainer(CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1));
			if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0)) 
			{
				isEff = true;
				EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffOpenWindowGameMidle8", null, ctnEnd.CurPos.x - widthCtn, ctnEnd.CurPos.y - heightCtn,
													false, false, null, function():void { ShowLock(int(CreateTime)) } );
			}
			// Khởi tạo các ô mà có thể chọn
			if(Dice && Dice.Arrow && Dice.Arrow > 0 && Dice.Arrow < ARROW_KEY)
			{
				HightLightCtnAffterRandomDice(GetDeltaFromArrow(Dice.Arrow).x, GetDeltaFromArrow(Dice.Arrow).y, Dice.Num);
				DiableAllArrowBtn();
			}
			else if (Question && Question > 0)
			{
				GuiMgr.getInstance().GuiAnswerQuestion.IdQuest = Question;
				GuiMgr.getInstance().GuiAnswerQuestion.timeStamp = int(CreateTime);
				GuiMgr.getInstance().GuiAnswerQuestion.Show(Constant.GUI_MIN_LAYER, 1);
			}
			else if(RoadState != 0)
			{
				if(RoadState == ROAD_STATE_GOING || RoadState == ROAD_STATE_TORNADO || RoadState == ROAD_STATE_ANSWERING)
				{
					if (arrMapLeaved[idCtnLiveNow.split("_")[1]][idCtnLiveNow.split("_")[2]] == STATE_END && MazeKeyInfo.Num <= 0 && arrArrow[ARROW_KEY - 1] <= 0)
					{
						GuiMgr.getInstance().GuiMessageFinishGame.Show(Constant.GUI_MIN_LAYER, 3);
						ShowBtnArrow();
					}
					else 
					{
						if (RoadState == ROAD_STATE_ANSWERING)
						{
							GuiMgr.getInstance().GuiAnswerQuestion.timeStamp = int(CreateTime);
							GuiMgr.getInstance().GuiAnswerQuestion.IdQuest = Question;
							GuiMgr.getInstance().GuiAnswerQuestion.Show(Constant.GUI_MIN_LAYER, 1);
						}
						else 
						{
							var cmd1:SendGetEventOnRoad = new SendGetEventOnRoad();
							GetButton(BTN_CLOSE).SetDisable();
							Exchange.GetInstance().Send(cmd1);
						}
					}
				}
			}
			else 
			{
				if (arrMapLeaved[idCtnLiveNow.split("_")[1]][idCtnLiveNow.split("_")[2]] == STATE_END && MazeKeyInfo.Num <= 0 && arrArrow[ARROW_KEY - 1] <= 0)
				{
					GuiMgr.getInstance().GuiMessageFinishGame.Show(Constant.GUI_MIN_LAYER, 3);
					ShowBtnArrow();
				}
			}
			
			ctnScrollBar = AddContainer("ctnScrollBar", "GUIGameEventMidle8_ImgBgScrollBarGameMidle8", MIN_X_OPEN_SCROLL_BAR, 75 + delta_Y_1 - 150);
			ctnScrollBar.AddButton(BTN_TREASURE_CLOSE, "BtnThoat", 287, 6, this);
			ctnScrollBar.GetButton(BTN_TREASURE_CLOSE).img.width = 25;
			ctnScrollBar.GetButton(BTN_TREASURE_CLOSE).img.height = 25;
			scrollBar = ctnScrollBar.AddScroll("", "GUIGameEventMidle8_ScrollBarExtendDeco", 265, 30);
			//if (!listGift || listGift.itemList.length == 0)	
			{
				listGift = new ListBox(ListBox.LIST_Y, 2, 3, 5, 5);
				ctnScrollBar.img.addChild(listGift);
				AddContent();
				listGift.x = 20;
				listGift.y = 30;
				
			}
			//else 
			//{
				//listGift.sortById();
			//}
			scrollBar.setScrollImage(listGift.img, 0, 100);
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xffffff, 0);
			sp.graphics.drawRect(300, 50 + delta_Y_1 - 150, 325, 260);
			sp.graphics.endFill();
			img.addChild(sp);
			ctnScrollBar.img.mask = sp;
		}
		
		public function playEffFast(NewData:Object, OldData:Object):void 
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffAutoPlay", null, 367, 285, false, false, null,
							function():void { UpdateAffterEffFast(NewData, OldData) } );
		}
		
		public function UpdateAffterEffFast(NewData:Object, OldData:Object):void 
		{
			var arrNameGiftFast:Array = [];
			var arrNumGiftFast:Array = [];
			var arrObjGiftFast:Array = [];
			var normalGift:Object = NewData.NormalGift;
			var specialGift:Object = NewData.SpecialGift;
			var strName:String;
			if(normalGift)
			{
				for (var i:String in normalGift) 
				{
					var obj:Object = normalGift[i];
					switch (obj.ItemType) 
					{
						case "Material":
							if (obj.ItemId > 100)
							{
								strName = obj.ItemType + (obj.ItemId % 100) + "S";
							}
							else
							{
								strName = obj.ItemType + obj.ItemId;
							}
						break;
						case "Equipment":
							strName = "GUIAutomatic_ImgEquipment";
						break;
						case "Money":
							strName = "IcGold";
						break;
						case "Exp":
							strName = "Exp";
						break;
						case "VipMedal":
							strName = "GUIAutomatic_VipMedal";
						break;
						case "VipTag":
							strName = "VipTag1";
						break;
						default:
							strName = obj.ItemType + obj.ItemId;
						break;
					}
					arrNameGiftFast.push(strName);
					arrNumGiftFast.push(obj.Num);
					arrObjGiftFast.push(obj);
				}
			}
			if (specialGift)
			{
				for (var i1:String in specialGift) 
				{
					var obj1:Object = specialGift[i1];
					strName = obj1.Type + obj1.Rank + "_Shop";
					arrNameGiftFast.push(strName);
					arrNumGiftFast.push(1);
					arrObjGiftFast.push(obj1);
					GameLogic.getInstance().user.GenerateNextID();
				}
			}
			GuiMgr.getInstance().GuiGiftFastGameMid8.InitGui(arrNameGiftFast, arrNumGiftFast, arrObjGiftFast);
		}
		
		public function DrawSquare(row:int, col:int):void 
		{
			var start_x:Number = 50 + widthCtn / 2;
			var start_y:Number = 80 + heightCtn / 2;
			var state:int = arrMap[row][col];
			//var ctn:Container = AddContainer(CTN_SQUARE + row + "_" + col, "ImgState" + state, start_x + widthCtn * col, start_y + heightCtn * row, true, this);
			var ctn:Container;
			if (state != STATE_END)
			{
				ctn = AddContainer(CTN_SQUARE + row + "_" + col, "GUIGameEventMidle8_ImgState" + STATE_CAN_MOVE, start_x + widthCtn * col, start_y + heightCtn * row, true, this);
			}
			else 
			{
				ctn = AddContainer(CTN_SQUARE + row + "_" + col, "GUIGameEventMidle8_ImgStateEnd", start_x + widthCtn * col, start_y + heightCtn * row, true, this);
			}
			var strState:String = state.toString();
			if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0) &&  state == STATE_END)
			{
				strState = strState + "Open";
			}
			ctn.AddImage("ImgState", "GUIGameEventMidle8_ImgState" + strState, ctn.img.width / 2, ctn.img.height / 2);
			if(state == STATE_LIVE)
			{
				ctn.GetImage("ImgState").FitRect(40, 40, new Point( -widthCtn + 7,-heightCtn));
			}
			if(state == STATE_END)
			{
				ctn.GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn / 2 - 5, -heightCtn / 2 - 5));
			}
			var guiToolTip:GUITooltipGameMidle8;
			var posParent:Point = new Point();
			var ToolTip:TooltipFormat;
			ToolTip = new TooltipFormat();
				if(arrMapLeaved[row][col] == STATE_LEAVED)
				{
					
					if (arrMap[row][col] != STATE_START && arrMap[row][col] != STATE_END && arrMap[row][col] != STATE_LIVE)
					{
						ToolTip.text = "Bạn đã nhận quà rồi";
						ctn.setTooltip(ToolTip);
					}
					
					if(arrMap[row][col] != STATE_LIVE)
					{
						SetEnableSprite(ctn.GetImage("ImgState").img, false);
					}
				}
				else
				{
					if (arrMap[row][col] == STATE_TREASURE)
					{
						ToolTip.text = "Bạn có thể nhận chìa khóa ở đây";
						ctn.setTooltip(ToolTip);
					}
					else if(arrMap[row][col] == STATE_END)
					{
						ToolTip.text = "Đích đến";
						ctn.setTooltip(ToolTip);
					}
				}
			
		}
		
		public function CheckFirstPlay():void 
		{
			var cmd:SendGetNextMap;
			if (!Ultility.CheckDate(CreateTime, NUM_TIME_DELAY))
			{
				CreateTime = GameLogic.getInstance().CurServerTime;
				isFirstPlay = true;
				HideOthersGUI();
				cmd = new SendGetNextMap("",true);
				Exchange.GetInstance().Send(cmd);
				ResetTextBoxScrollBar();
			}
			else if(MapId < 1)
			{
				var objtemp:Object = ConfigJSON.getInstance().GetItemList("Param");
				var playLimit:int = ConfigJSON.getInstance().GetItemList("Param")["PlayLimit"];
				var timeWait:int = ConfigJSON.getInstance().GetItemList("Param")["MapCoolDown"];
				
				isFirstPlay = true;
				ResetTextBoxScrollBar();
				if (JoinNum < playLimit - 1)
				{
					GuiMgr.getInstance().GuiRePlayGame.Show(Constant.GUI_MIN_LAYER, 1);
				}
				else 
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã vào đủ số lần được phép\nQuay lại sau nhé ^^!");
				}
				Hide();
			}
		}
		/**
		 * Hàm thực hiện các hành động khi trở lại game
		 */
		public function  HideGUI():void 
		{
			ResetData();
			Hide();
			
			if (isTeleport)
			{
				isTeleport = false;
			}
			GameLogic.getInstance().ShowFish();
		}
		
		public function ResetData():void 
		{
			scrollBar = null;
			listGift = null;
			arrNameGift = [];
			arrNumGift = [];
			arrObjGift = [];
			arrIdCtnCanGo = [];
			isEff = false;
			isProcess = false;
			isProcessSpringy = false;
			isProcessZoomInOut = false;
			isNextDay = false;
		}
		
		/**
		 * Khớp lại dữ liệu với server khi dửi gói tin tạo map mới lên
		 * @param	data
		 */
		public function InitInfo(data:Object, isShowGiftFail:Boolean = false):void 
		{		
			if(!isShowGiftFail)
			{	
				if (GuiMgr.getInstance().GuiRePlayGame.IsVisible)
				{
					GuiMgr.getInstance().GuiRePlayGame.Hide();
				}
				CreateTime = GameLogic.getInstance().CurServerTime;
				PearFlower = data.NewMap;
				CreateAllData();
				if (!isFirstPlay)
				{
					RefreshAllComponent();
				}
				else 
				{
					isFirstPlay = false;
				}
				
				if (!IsVisible)
					Show(Constant.GUI_MIN_LAYER, 1);
			}
			else 
			{
				if (GuiMgr.getInstance().GuiRePlayGame.IsVisible)
					GuiMgr.getInstance().GuiRePlayGame.Hide();
				
				CreateTime = GameLogic.getInstance().CurServerTime;
				PearFlower = data.NewMap;
				CreateAllData();
				GuiMgr.getInstance().GuiGiftGame8Fail.numExp = data.Exp;
				GuiMgr.getInstance().GuiGiftGame8Fail.Show(Constant.GUI_MIN_LAYER, 1);
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian để bạn thoát khỏi mê cung\nBạn hãy bắt đầu lại từ đầu nhé! ^_^");
				GuiMgr.getInstance().GuiGameTrungThu.RefreshAllComponent();
				isEff = false;
				isProcess = false;
			}
		}
		
		public function ResetTextBoxScrollBar():void 
		{
			if(listGift)	listGift.removeAllItem();
			arrNumGift = [];
			arrNameGift = [];
			arrObjGift = [];
		}
		/**
		 * Khớp dữ liệu client với server khi init_run
		 * @param	data
		 */
		public function ReInitInfo(data:Object):void 
		{
			JoinNum = data.JoinNum;
			if(data["Object"])
			{
				PearFlower = data["Object"];
				CreateAllData();
			}
			else 
			{
				ReNewMap();
			}
			
			if (data.CreateMapTime)
			{
				CreateTime = data.CreateMapTime;
			}
			else 
			{
				CreateTime = 0;
			}
		}
		/**
		 * CÓ thể gọi khi tạo map mới
		 */
		public function ReNewMap(isSubKey:Boolean = true):void 
		{
			RoadState = 0;
			Dice = new Object();
			History = new Object();
			MapId = 0;
			if(MazeKeyInfo && int(MazeKeyInfo.Num) > 0)
			{
				MazeKeyInfo = new Object();
			}
			else 
			{
				MazeKeyInfo = new Object();
				if(isSubKey)
				{
					arrArrow[ARROW_KEY - 1] --;
					GuiMgr.getInstance().GuiStore.UpdateStore("Arrow", ARROW_KEY, -1);
				}
			}
			PearFlower = new Object();
			Position = new Object();
			//JoinNum = 0;
			Question = 0;
			Revards = new Object();
		}
		
		public function HideOthersGUI():void 
		{	
			if (GuiMgr.getInstance().GuiGiftGameMid8.IsVisible)	GuiMgr.getInstance().GuiGiftGameMid8.Hide();
			if (GuiMgr.getInstance().GuiMessageFinishGame.IsVisible)	GuiMgr.getInstance().GuiMessageFinishGame.Hide();
			if (GuiMgr.getInstance().GuiAnswerQuestion.IsVisible)	GuiMgr.getInstance().GuiAnswerQuestion.Hide();
			if (GuiMgr.getInstance().GuiGiftFinalGameMid8.IsVisible)	GuiMgr.getInstance().GuiGiftFinalGameMid8.Hide();
		}
		
		/**
		 * Tạo lại các dữ liệu lấy từ server
		 */
		public function CreateAllData():void 
		{
			MapId = PearFlower.MapId;
			Position = PearFlower.Position;
			Dice = PearFlower.Dice;
			Question = PearFlower.Question;
			Revards = PearFlower.Revards;
			History = PearFlower.History;
			RoadState = PearFlower.RoadState;
			MazeKeyInfo = PearFlower.MazeKeyInfo;
			TeleportNum = PearFlower.TeleportNum;
			arrIdCtnCanGo = [];
		}
		
		public function UpdateGUI():void 
		{
			if (isStartSendRandomDice)
			{
				if (countIsStartSendRandomDice < 150)
				{
					countIsStartSendRandomDice++;
				}
				else
				{
					countIsStartSendRandomDice = 0;
					isStartSendRandomDice = false;
				}
			}
			
			// Cập nhật time count down
			if(!isNextDay)
			{
				if (GameLogic.getInstance().CurServerTime - (timePlay + NUM_TIME_DELAY * 1000) / 1000 >= 1 && txtTimeFinish && txtTimeFinish.text)
				{
					timePlay += 1000;
					if (sec == 0)
					{
						sec = 59;
						if (min == 0)
						{
							min = 59;
							if (hour == 0)
							{
								isNextDay = true;
								if(!isEff && !isProcess)
								{
									HideOthersGUI();
									var cmd:SendGetNextMap = new SendGetNextMap("", true);
									Exchange.GetInstance().Send(cmd);
									hour = 23;
								}
							}
							else 
							{
								hour --;
							}
						}
						else 
						{
							min --;
						}
					}
					else 
					{
						sec --;
					}
					txtTimeFinish.text = "Còn " + hour + ":" + min + ":" + sec + " để thoát khỏi mê cung";
				}
			}
			else if (!isEff && !isProcess && hour == 0)
			{
				HideOthersGUI();
				var cmd1:SendGetNextMap = new SendGetNextMap("", true);
				Exchange.GetInstance().Send(cmd1);
				hour = 23;
				txtTimeFinish.text = "Đang xử lý sang ngày mới ...!";
			}
			// Cập nhật số lượng quà trong scroll bar
			var i:int = 0;
			for (i = 0; i < arrNameGift.length; i++) 
			{
				var strNum:String = listGift.getItemById(CTN_GIFT_SCROLL + i).LabelArr[0].text.split("x")[1];
				var arrNum:Array = strNum.split(",");
				var num:int = 0;
				for (var ii:int = arrNum.length - 1; ii >= 0; ii--) 
				{
					var numInArr:int = int(arrNum[ii]);
					num += numInArr * Math.pow(1000, arrNum.length - 1 - ii);
				}
				if (arrNumGift[i] > num)
				{
					listGift.getItemById(CTN_GIFT_SCROLL + i).LabelArr[0].text = "x" + Ultility.StandardNumber(Math.ceil(num + (arrNumGift[i] - num)/6 - 0.005));
				}
			}
			
			// Xử lý phóng to thu nhỏ khi nhận quà
			if (isProcessZoomInOut)
			{
				if (spProcess.scaleX > ZOOM_IN || spProcess.scaleY > ZOOM_IN)
				{
					isProcessZoomInOut = false;
				}
				else 
				{
					isEff = true;
					count ++;
					if (spProcess.name.search("EnergyItem") >= 0 || spProcess.name.search("RankPointBottle") >= 0 || spProcess.name == "Exp")
					{
						spProcess.x -= spProcess.width * DELTA_ZOOM_IN / 2;
						spProcess.y -= spProcess.height * DELTA_ZOOM_IN / 2;
					}
					else if (spProcess.name.search("PearFlower") >= 0) 
					{
						spProcess.y += spProcess.height / 2 * DELTA_ZOOM_IN;
					}
					spProcess.scaleX += DELTA_ZOOM_IN;
					spProcess.scaleY += DELTA_ZOOM_IN;
				}
				
			}
			else 
			{
				if (count > 0)
				{
					if(spProcess.scaleX > ZOOM_OUT || spProcess.scaleY > ZOOM_OUT)
					{
						count--;
						if (spProcess.name.search("EnergyItem") >= 0 || spProcess.name.search("RankPointBottle") >= 0 || spProcess.name == "Exp")
						{
							spProcess.x += spProcess.width * DELTA_ZOOM_OUT / 2;
							spProcess.y += spProcess.height * DELTA_ZOOM_OUT / 2;
						}
						else if (spProcess.name.search("PearFlower") >= 0) 
						{
							spProcess.y -= spProcess.height / 2 * DELTA_ZOOM_OUT;
						}
						spProcess.scaleX -= DELTA_ZOOM_OUT;
						spProcess.scaleY -= DELTA_ZOOM_OUT;
					}
					else 
					{
						var pD:Point;
						if (!isMazeKey)
						{
							pD = new Point(ctnTreasureStore.CurPos.x + ctnTreasureStore.img.width / 2, ctnTreasureStore.CurPos.y + ctnTreasureStore.img.height / 2);
							if (spProcess.name.search("EnergyItem") >= 0 || spProcess.name.search("RankPointBottle") >= 0 || spProcess.name == "Exp")
							{
								pD.x -= spProcess.width / 2;
								pD.y -= spProcess.height / 2;
							}
							else if (spProcess.name.search("PearFlower") >= 0) 
							{
								pD.y += spProcess.height / 2;
							}
						}
						else 
						{
							pD = new Point(GetButtonEx(BTNEX_KEY).CurPos.x + GetButtonEx(BTNEX_KEY).img.width / 2, GetButtonEx(BTNEX_KEY).CurPos.y + GetButtonEx(BTNEX_KEY).img.height / 2);
						}
						var pM:Point = new Point((pD.x / 2 + spProcess.x / 2) - 0.5 * Math.random() * (pD.x - spProcess.x), pD.y);
						TweenMax.to(	spProcess, 1.5, { bezier:[ { x:(pM.x), y:(pM.y) } , { x:(pD.x), y:(pD.y) } ], orientToBezier:true, scaleX:1.5, scaleY:1.5, alpha:0.5,
							ease:Expo.easeOut, onComplete:OnFinishTweenMax, onCompleteParams:[spProcess, dataGift, int(CreateTime)] } );
						spProcess = null;
						count = 0;
					}
				}
			}
			
			// Eff con cá nhún nhảy
			if(!isFinishProcessSpringy)
			{
				if (isProcessSpringy)
				{
					if (spSpringy != null)
					{
						if(spSpringy.scaleY > 0.6)
						{
							spSpringy.scaleY -= 0.08;
							spSpringy.scaleX += 0.003;
							spSpringy.y -= 0.05 * 40 * typeFall;
						}
						else 
						{
							isProcessSpringy = false;
						}
					}
				}
				else 
				{
					if (spSpringy != null)
					{
						if(spSpringy.scaleY < 1)
						{
							spSpringy.scaleY += 0.08;
							spSpringy.scaleX -= 0.003;
							spSpringy.y += 0.05 * 40 * typeFall;
						}
						else 
						{
							spSpringy.scaleY = 1;
							spSpringy.scaleX = 1;
							isFinishProcessSpringy = true;
							DoUserGoGo(spSpringy.name, spSpringy, int(CreateTime));
							spSpringy = null;
						}
					}
				}
			}
			
			// Eff lốc xoáy
			if (effTornado != null)
			{
				var ctn:Container = GetContainer(idCtnLiveNow);
				var currentPos:Point = new Point(ctn.CurPos.x - DELTA_TORNADO_POINT_X, ctn.CurPos.y - DELTA_TORNADO_POINT_Y);
				if (Math.abs(effTornado.img.x - currentPos.x) < Math.abs(posDeltaTornado.x) || Math.abs(effTornado.img.y - currentPos.y) < Math.abs(posDeltaTornado.y))
				{
					effTornado.img.x += posDeltaTornado.x / 50;
					effTornado.img.y += posDeltaTornado.y / 50;
				}
				else 
				{
					effTornado.FinishEffect();
				}
			}
			
			// cập nhật vị trí scroll bar
			if(ctnScrollBar && ctnScrollBar.img)
			{
				if (isShowScrollBar)
				{
					if (ctnScrollBar.img.x > MIN_X_OPEN_SCROLL_BAR)
					{
						ctnScrollBar.img.x -= 15;
					}
				}
				else
				{
					if (ctnScrollBar.img.x < MAX_X_CLOSE_SCROLL_BAR)
					{
						ctnScrollBar.img.x += 15;
					}
				}
			}
		}
		
		public function EffGoGo(buttonId:String, timeStamp:int):void 
		{
			for (var i:int = 0; i < arrIdCtnCanGo.length; i++) 
			{
				var iStr:String = arrIdCtnCanGo[i];
				if (iStr == buttonId)
				{
					break;
				}
				if (i == arrIdCtnCanGo.length - 1)	return;
			}
			if (arrIdCtnCanGo && arrIdCtnCanGo.length == 0)	return;
			var posOld:Point = new Point(idCtnLiveNow.split("_")[1], idCtnLiveNow.split("_")[2]);
			var ctnOld:Container = GetContainer(idCtnLiveNow);
			var posNew:Point = new Point(buttonId.split("_")[1], buttonId.split("_")[2]);
			isEff = true;
			
			var rowOld:int = int(idCtnLiveNow.split("_")[1]);
			var colOld:int = int(idCtnLiveNow.split("_")[2]);
			var idCtnStart:String = CTN_SQUARE + "0_0";
			var idCtnEnd:String = CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1);
			
			if(!GetContainer(idCtnLiveNow).tooltip && idCtnLiveNow != idCtnStart && idCtnLiveNow != idCtnEnd)
			{
				var ToolTip:TooltipFormat = new TooltipFormat();
				ToolTip.text = "Bạn đã nhận quà rồi";
				GetContainer(idCtnLiveNow).setTooltip(ToolTip);
			}
			
			var state:int = int(objMap[rowOld.toString()][colOld.toString()]);
			if(state >= 10 && state <= 15)
			{
				arrMap[rowOld][colOld] = STATE_CAN_MOVE;
			}
			else 
			{
				arrMap[rowOld][colOld] = state;
			}
			
			GetContainer(idCtnLiveNow).RemoveAllImage();
			var strStateOld:String = arrMap[rowOld][colOld].toString();
			if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0) &&  state == STATE_END)
			{
				strStateOld = strStateOld + "Open";
			}
			GetContainer(idCtnLiveNow).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + strStateOld, GetContainer(idCtnLiveNow).img.width / 2, GetContainer(idCtnLiveNow).img.height / 2);
			if(state == STATE_END)
			{
				GetContainer(idCtnLiveNow).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn / 2 - 5, -heightCtn / 2 - 5));
			}
			
			if(arrMap[rowOld][colOld] != STATE_END)
			{
				SetEnableSprite(GetContainer(idCtnLiveNow).GetImage("ImgState").img, false);
			}
			
			if(!isTeleport)
			{
				ctnOld.SetHighLight( -1);
				DeHightLightCtnAffterRandomDice();
				
				var delta_row:int = posNew.x - posOld.x;
				var delta_col:int = posNew.y - posOld.y;
				
				var mc:Sprite = new Sprite();
				var imageFishFly:Image = new Image(mc, "GUIGameEventMidle8_ImgState" + STATE_LIVE);
				imageFishFly.FitRect(40, 40);
				var glow:GlowFilter = new GlowFilter(COLOR_USER, 1, 8, 8, 8);
				imageFishFly.img.filters = [glow];
				mc.name = buttonId;
				mc.x = ctnOld.CurPos.x;
				mc.y = ctnOld.CurPos.y;
				img.addChild(mc);
				
				var ctnNew:Container = GetContainer(buttonId);
				
				if (delta_col == 0)
				{
					if (delta_row > 0)
					{
						typeFall = TYPE_FALL_DOWN;
						TweenMax.to(mc, 1 / 12 * Math.abs(delta_row), { bezierThrough:[ { x:ctnNew.CurPos.x, y:ctnNew.CurPos.y} ],
									orientToBezier:false, ease:Expo.easeIn, onComplete:OnFinishFishFly, 
									onCompleteParams:[mc] } );
						mc = null;
					}
					else if (delta_row < 0)
					{
						typeFall = TYPE_FALL_UP;
						TweenMax.to(mc, 1 / 12 * Math.abs(delta_row), { bezierThrough:[ { x:ctnNew.CurPos.x, y:ctnNew.CurPos.y } ],
									orientToBezier:false, ease:Expo.easeIn, onComplete:OnFinishFishFly, 
									onCompleteParams:[mc] } );
						mc = null;
					}
					else 
					{
						typeFall = TYPE_FALL_NONE;
						return;
					}
				}
				else
				{
					typeFall = TYPE_FALL_NONE;
					EffFishJumps(posOld, posNew, mc, ctnOld);
				}
			}
			else 
			{
				var zxuPay:int = objArrow[ARROW_TORNADO.toString()].ZMoney;//bh 6548031  -> 1221
				if (GameLogic.getInstance().user.GetZMoney() < zxuPay)
				{
					isEff = false; 
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
				DeHightLightCtnAffterRandomDice(true);
				isTeleport = false;
				var dataServer:Object = new Object();
				dataServer.New_Position = new Object();
				dataServer.New_Position.Y = buttonId.split("_")[1];
				dataServer.New_Position.X = buttonId.split("_")[2];
				var cmd:SendEventMidle8Teleport = new SendEventMidle8Teleport(dataServer.New_Position.Y, dataServer.New_Position.X, timeStamp);
				Exchange.GetInstance().Send(cmd);
				RoadState = ROAD_STATE_TORNADO;
				TeleportNum++;
				GameLogic.getInstance().user.UpdateUserZMoney( -zxuPay);
				GetContainer(CTN_TORNADO).GetImage(IMG_TICKED).img.visible = false;
				if (TeleportNum >= 3)
				{
					txtWarningTeleport.visible = true;
					GetContainer(CTN_TORNADO).GetImage(CTN_TORNADO).img.visible = false;
					Ultility.SetEnableSprite(GetContainer(CTN_TORNADO).img, false)
				}
				EffTornado(dataServer, timeStamp);
			}
		}
		
		public function OnFinishFishFly(mc:Sprite):void 
		{
			spSpringy = mc;
			// Giải phóng RAM
			mc = null;
			isProcessSpringy = true;
			isFinishProcessSpringy = false;
		}
		
		public function EffFishJumps(posOld:Point, posNew:Point, mc:Sprite, ctnOld:Container):void 
		{
			var arrPosJum:Array = [];
			var delta_col:int = posNew.y - posOld.y;
			for (var i:int = 0; i < Math.abs(delta_col); i++) 
			{
				var posTemp:Point = new Point(posOld.x, posOld.y + (i + 1) * Math.abs(delta_col) / delta_col);
				arrPosJum.push(posTemp);
			}
			
			var pos:Point = arrPosJum[0] as Point;
			var ctnNew:Container = GetContainer(CTN_SQUARE + pos.x + "_" + pos.y);
			
			var pD:Point = ctnNew.CurPos;
			var pM:Point = new Point();
			pM.x = (mc.x + pD.x) / 2;
			pM.y = pD.y - 20;
			
			TweenMax.to(mc, 1 / 12, { bezierThrough:[ { x:pM.x, y:pM.y}, { x:pD.x, y:pD.y} ],
						orientToBezier:false, ease:Expo.easeIn, onComplete:EffFishJump, 
						onCompleteParams:[arrPosJum, mc, delta_col] } );
			mc = null;
		}
		
		public function EffFishJump(arrPosJump:Array, mc:Sprite, delta_col:int):void 
		{
			if (arrPosJump.length <= 1)
			{
				arrPosJump = [];
				spSpringy = mc;
				// Giải Phóng RAM
				mc = null;
				isProcessSpringy = true;
				isFinishProcessSpringy = false;
				typeFall = TYPE_FALL_DOWN;
			}
			else 
			{
				arrPosJump.splice(0, 1);
				var pos:Point = arrPosJump[0] as Point;
				var ctnNew:Container = GetContainer(CTN_SQUARE + pos.x + "_" + pos.y);
			
				var pD:Point = ctnNew.CurPos;
				var pM:Point = new Point();
				pM.x = (mc.x + pD.x) / 2;
				pM.y = pD.y - 20;
			
				TweenMax.to(mc, 1 / 12, { bezierThrough:[ { x:pM.x, y:pM.y}, { x:pD.x, y:pD.y} ],
						orientToBezier:false, ease:Expo.easeIn, onComplete:EffFishJump, 
						onCompleteParams:[arrPosJump, mc, delta_col] } );
				mc = null;
			}
		}
		
		public function DoUserGoGo(buttonId:String, mc:Sprite = null, timeStamp:int = 0):void 
		{
			if (mc)
			{				
				mc.visible = false;
				if (mc.parent)	mc.parent.removeChild(mc);
				mc = null;
			}
			for (var i:int = 0; i < arrIdCtnCanGo.length; i++)
			{
				if (buttonId == arrIdCtnCanGo[i])
				{
					break;
				}
				if (i == arrIdCtnCanGo.length)
				{
					return;
				}
			}
			if (arrIdCtnCanGo && arrIdCtnCanGo.length == 0)	return;
			
			isProcess = true;
			DeHightLightCtnAffterRandomDice(true);
			
			// Tọa độ của ô đang đứng
			var rowOld:int = int(idCtnLiveNow.split("_")[1]);
			var colOld:int = int(idCtnLiveNow.split("_")[2]);
			// Đưa ra tọa độ của ô định đến
			GetContainer(buttonId).SetHighLight(COLOR_USER);
			var rowNow:int = int(buttonId.split("_")[1]);
			var colNow:int = int(buttonId.split("_")[2]);
			
			// Gửi gói tin nhảy đến ô định đến
			if(arrMap[rowOld][colOld] != STATE_SPECIAL_TREASURE || (arrMap[rowOld][colOld] == STATE_SPECIAL_TREASURE && ((MazeKeyInfo.Num > 0 || arrArrow[ARROW_KEY - 1] > 0))))
			{
				if(arrMap[rowOld][colOld] != STATE_END)
				{
					arrMapLeaved[rowOld][colOld] = STATE_LEAVED;
				}
			}
			var cmd:SendSetGoGo = new SendSetGoGo(Math.max(Math.abs(rowNow - rowOld), Math.abs(colOld - colNow)), timeStamp);
			Exchange.GetInstance().Send(cmd);
			RoadState = ROAD_STATE_GOING;
			
			// Xóa hình ảnh của ô định đến và cập nhật lại hình ảnh cho nó
			GetContainer(buttonId).RemoveAllImage();
			GetContainer(buttonId).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + STATE_LIVE, GetContainer(buttonId).img.width / 2, GetContainer(buttonId).img.height / 2);
			GetContainer(buttonId).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn + 7, - heightCtn));
			
			// Cập nhật lại id hiện tại của ô đang đứng
			idCtnLiveNow = buttonId;
			// Cập nhật database vị trí hiện tại
			Position.Y = rowNow;
			Position.X = colNow;
			var isGetGiftSpecialTreasure:Boolean = false;
			if ((arrMap[rowNow][colNow] == STATE_CAN_MOVE || arrMap[rowNow][colNow] == STATE_FATE || arrMap[rowNow][colNow] == STATE_SPECIAL_TREASURE ||
				arrMap[rowNow][colNow] == STATE_TREASURE || arrMap[rowNow][colNow] == STATE_END) 
				&& arrMapLeaved[rowNow][colNow] != STATE_LEAVED)
			{
				// Nếu là ô kết thúc hoặc ô rương báu có chìa khóa nhưng không có chìa khóa thì thực hiện show bảng mua chìa khóa lên
				if ((arrMap[rowNow][colNow] == STATE_END || arrMap[rowNow][colNow] == STATE_SPECIAL_TREASURE) && MazeKeyInfo.Num <= 0 && arrArrow[ARROW_KEY - 1] <= 0)
				{
					GuiMgr.getInstance().GuiMessageFinishGame.Show(Constant.GUI_MIN_LAYER, 3);
					ShowBtnArrow();
				}
				else // nếu không thì sẽ thực hiện gửi gói tin nhận quà lên và trừ đi 1 chiếc chìa khóa
				{
					if(arrMap[rowNow][colNow] == STATE_SPECIAL_TREASURE && ((MazeKeyInfo.Num > 0 || arrArrow[ARROW_KEY - 1] > 0)))
					{
						arrMapLeaved[rowNow][colNow] = STATE_LEAVED;
					}
					if (arrMap[rowNow][colNow] == STATE_SPECIAL_TREASURE)
					{
						isGetGiftSpecialTreasure = true;
						if (int(MazeKeyInfo.Num) <= 0)
						{
							arrArrow[ARROW_KEY - 1]--;
							user.UpdateStockThing("Arrow", ARROW_KEY, -1);
						}
						else 
						{
							MazeKeyInfo.Num = 0;
						}
						// Cập nhật lại trạng thái ô thoát khỏi mê cung
						var idCtnEnd:String = CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1);
						GetContainer(idCtnEnd).RemoveAllImage();
						var strStateOld:String = STATE_END.toString();
						if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0))
						{
							strStateOld = strStateOld + "Open";
						}
						GetContainer(idCtnEnd).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + strStateOld, GetContainer(idCtnEnd).img.width / 2, GetContainer(idCtnEnd).img.height / 2);
						GetContainer(idCtnEnd).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn / 2 - 5, -heightCtn / 2 - 5));
					}
					arrMap[rowNow][colNow] = STATE_LIVE;
					arrMap[rowOld][colOld] = arrMapConstant[rowOld][colOld];
					var cmd1:SendGetEventOnRoad = new SendGetEventOnRoad(timeStamp);
					GetButton(BTN_CLOSE).SetDisable();
					Exchange.GetInstance().Send(cmd1);
				}
			}
			else 
			{
				ShowBtnArrow();
				RoadState = ROAD_STATE_NORMAL;
			}	
			var objHistory:Object = new Object();
			// Cập nhật logic cho trạng thái của các ô thay đổi
			if((arrMapLeaved[rowOld][colOld] == STATE_END) || (arrMap[rowOld][colOld] == STATE_SPECIAL_TREASURE && arrMapLeaved[rowOld][colOld] != STATE_LEAVED))
			{
				SetEnableSprite(GetContainer(CTN_SQUARE + rowOld + "_" + colOld).GetImage("ImgState").img);
				 if((arrMapLeaved[rowOld][colOld] == STATE_END))
				{
					// Cập nhật lịch sử
					if (History[rowOld.toString()])
					{
						History[rowOld.toString()][colOld.toString()] = true;
					}
					else 
					{
						objHistory[colOld.toString()] = true;
						History[rowOld.toString()] = objHistory;
					}
				}
			}
			else
			{
				// Cập nhật lịch sử
				if (History[rowOld.toString()])
				{
					History[rowOld.toString()][colOld.toString()] = true;
				}
				else 
				{
					objHistory[colOld.toString()] = true;
					History[rowOld.toString()] = objHistory;
				}
			}
			isProcess = false;
			isEff = false;
			Dice.Arrow = 0;
			if(CTN_SQUARE + rowOld + "_" + colOld != idCtnLiveNow)
			{
				Dice.Num = 0;
			}
		}
		/**
		 * Trừ một chiếc chìa khóa và cập nhật lại trạng thái của ô đích
		 * @param	isGetGiftSpecialTreasure
		 */
		public function UpdateAboutKey(isGetGiftSpecialTreasure:Boolean, rowNow:int, colNow:int):void 
		{
			if (arrMap[rowNow][colNow] == STATE_SPECIAL_TREASURE)
			{
				isGetGiftSpecialTreasure = true;
				if (int(MazeKeyInfo.Num) <= 0)
				{
					arrArrow[ARROW_KEY - 1]--;
					user.UpdateStockThing("Arrow", ARROW_KEY, -1);
				}
				else 
				{
					MazeKeyInfo.Num = 0;
				}
				// Cập nhật lại trạng thái ô thoát khỏi mê cung
				var idCtnEnd:String = CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1);
				GetContainer(idCtnEnd).RemoveAllImage();
				var strStateOld:String = STATE_END.toString();
				if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0))
				{
					strStateOld = strStateOld + "Open";
				}
				GetContainer(idCtnEnd).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + strStateOld, GetContainer(idCtnEnd).img.width / 2, GetContainer(idCtnEnd).img.height / 2);
				GetContainer(idCtnEnd).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn / 2 - 5, -heightCtn / 2 - 5));
			}
		}
		
		/**
		 * Hàm xử lý khi nhận được số chấm của mặt xúc xắc
		 * @param	m
		 * @param	n
		 * @param	isTwoDice
		 * @param	Num
		 */
		public function doRunNextSquare(m:int, n:int, isTwoDice:int, typeArrow:int, Num:int, Num2:int = 0):void 
		{
			var arrTypeDice1:Array = [];
			var arrTypeDice2:Array = [];
			var numBonusArrow:int = 1;
			var isLucky:Boolean = false;
			isEff = true;
			if (!Dice)	
				Dice = new Object();
			if(!isTwoDice)
			{
				if (Num == 6)
				{
					isLucky = true;
					numBonusArrow = 1;
				}
				arrTypeDice1.push(Num);
				arrTypeDice1.push(Math.floor(1 + 6 * Math.random()));
				// Giải phóng RAM
				//EffAfter(m, n, Num, isLucky, numBonusArrow, typeArrow);
				EffectMgr.getInstance().AddSwfEffect1(Constant.GUI_MIN_LAYER, "EffRandomDice", 2, arrTypeDice1, Constant.STAGE_WIDTH / 2 - 50, 
					Constant.STAGE_HEIGHT / 2, false, false, null,  function():void { EffAfter(m, n, Num, isLucky, numBonusArrow, typeArrow) } );
			}
			else 
			{
				if (Num == 6 || Num2 == 6)
				{
					isLucky = true;
					numBonusArrow = 1;
					if (Num + Num2 == 12)	numBonusArrow = 2;
				}
				arrTypeDice1.push(Num);
				arrTypeDice1.push(Math.floor(1 + 6 * Math.random()));
				arrTypeDice2.push(Num2);
				arrTypeDice2.push(Math.floor(1 + 6 * Math.random()));
				//EffAfter(m, n, Num + Num2, isLucky, numBonusArrow, typeArrow);
				EffectMgr.getInstance().AddSwfEffect1(Constant.GUI_MIN_LAYER, "EffRandomDice", 2, arrTypeDice1, Constant.STAGE_WIDTH / 2 - 50 - 105, Constant.STAGE_HEIGHT / 2 - 25);
				EffectMgr.getInstance().AddSwfEffect1(Constant.GUI_MIN_LAYER, "EffRandomDice", 2, arrTypeDice2, Constant.STAGE_WIDTH / 2 - 50 + 2, 
					Constant.STAGE_HEIGHT / 2 - 5, false, false, null,  function():void { EffAfter(m, n, Num + Num2, isLucky, numBonusArrow, typeArrow) } );
			}
		}
		
		public function BonusArrow(typeArrow:int, numBonus:int = 1):void 
		{
			arrArrow[typeArrow - 1] += numBonus;
			GuiMgr.getInstance().GuiStore.UpdateStore("Arrow", typeArrow, numBonus);
			switch (typeArrow) 
			{
				case ARROW_DOWN:
					txtNumArrowDown.text = arrArrow[typeArrow - 1].toString();
				break;
				case ARROW_UP:
					txtNumArrowUp.text = arrArrow[typeArrow - 1].toString();
				break;
				case ARROW_RIGHT:
					txtNumArrowRight.text = arrArrow[typeArrow - 1].toString();
				break;
				case ARROW_LEFT:
					txtNumArrowLeft.text = arrArrow[typeArrow - 1].toString();
				break;
			}
		}
		
		public function EffAfterLucky(m:int, n:int, Num:int, numBonus:int = 0, typeArrow:int = 0, mc:Sprite = null):void 
		{
			mc.parent.removeChild(mc);
			mc = null;
			BonusArrow(typeArrow, numBonus)
			HightLightCtnAffterRandomDice(m, n, Num);
			isEff = false;
		}
		
		public function EffAfter(m:int, n:int, Num:int, isLucky:Boolean = false, numBonus:int = 0, typeArrow:int = 0):void 
		{
			if(isLucky)
			{
				var mc:Sprite = new Sprite();
				var imgArrowBonus:Image = new Image(mc, "GUIGameEventMidle8_Arrow" + typeArrow);
				//mc = Ultility.CloneImage(imgArrowBonus.img);
				img.addChild(mc);
				mc.x = Constant.STAGE_WIDTH / 2 - 50;
				mc.y = Constant.STAGE_HEIGHT / 2
				var pD:Point = new Point();
				var idBtnEx:String = "";
				switch (typeArrow) 
				{
					case ARROW_UP:
						idBtnEx = BTN_UP;
					break;
					case ARROW_DOWN:
						idBtnEx = BTN_DOWN;
					break;
					case ARROW_LEFT:
						idBtnEx = BTN_LEFT;
					break;
					case ARROW_RIGHT:
						idBtnEx = BTN_RIGHT;
					break;
				}
				pD = img.globalToLocal(GetButton(idBtnEx).img.localToGlobal(new Point(GetButton(idBtnEx).img.width / 2, GetButton(idBtnEx).img.height / 2)));
				TweenMax.to(mc, 1, { bezierThrough:[ { x:(pD.x ), y:(pD.y) } ], ease:Quint.easeOut, 
					onComplete:EffAfterLucky, onCompleteParams:[m, n, Num, numBonus, typeArrow, mc] } );
				mc = null;
			}
			else 
			{
				HightLightCtnAffterRandomDice(m, n, Num);
				isEff = false;
			}
		}
		
		/**
		 * Hàm thực hiện hightlight numCtn container theo 1 đường nào đó
		 * @param	deltaRow
		 * @param	deltaCol
		 * @param	numCtn
		 */
		public function HightLightCtnAffterRandomDice(deltaRow:int, deltaCol:int, numCtn:int):void 
		{
			var rowNow:int = int(idCtnLiveNow.split("_")[1]);
			var colNow:int = int(idCtnLiveNow.split("_")[2]);
			var row:int = 0;
			var col:int = 0;
			if (arrIdCtnCanGo == null || arrIdCtnCanGo.length > 0)	arrIdCtnCanGo = [];
			for (var i:int = 1; i <= numCtn; i++) 
			{
				row = rowNow + i * deltaRow;
				col = colNow + i * deltaCol;
				if (GetContainer(CTN_SQUARE + row + "_" + col))
				{
					arrIdCtnCanGo.push(CTN_SQUARE + row + "_" + col);
				}
				else 
				{
					break;
				}
				
			}
			for (var j:int = 0; j < arrIdCtnCanGo.length; j++) 
			{
				GetContainer(arrIdCtnCanGo[j]).SetHighLight(COLOR_CAN_GO);
			}
		}
		
		public function DeHightLightCtnAffterRandomDice(isRemoveElement:Boolean = false):void 
		{
			for (var i:int = 0; i < arrIdCtnCanGo.length; i++) 
			{
				GetContainer(arrIdCtnCanGo[i]).SetHighLight( -1);
			}
			if(isRemoveElement)
			{
				arrIdCtnCanGo.splice(0, arrIdCtnCanGo.length);
			}
		}
		
		public function updateData(m:int, n:int, Num:int, Num2:int = 0):void 
		{
			if (Dice == null)	
				Dice = new Object();
			Dice.Arrow = GetTypeArrow(m, n);
			Dice.Num = Num + Num2;
		}
		
		public function ProcessDataServerGift(dataServer:Object, timeStamp:int):void 
		{
			if (timeStamp != int(CreateTime))	return;
			var data:Object = new Object();
			var iStr:String = "";
			var jStr:String = "";
			var objGiftReceive:Object = new Object();
			var nameGift:String = "";
			var nameSprite:String = "";
			var typeGift:String = "";
			var idGift:String = "";
			var ctn:Container = GetContainer(idCtnLiveNow);
			Dice = new Object();
			var imageKey:Image;
			var imageGift:Image;
			var imageDomain:Image;
			var numGiftRecieve:int = 0;
			switch (int(dataServer.CellStatus)) 
			{
				case CELL_BABY_FISH:
				case CELL_ENERGY_ITEM:
				case CELL_EXP:
				case CELL_MATERIAL:
				case CELL_TREASURE:
				case CELL_SPECIAL_TREASURE:
				{
					if (dataServer.Gift != null)
					{
						var mc:Sprite = new Sprite();
						if ((int(dataServer.CellStatus) == CELL_TREASURE || int(dataServer.CellStatus) == CELL_SPECIAL_TREASURE) && dataServer.Gift && 
							dataServer.Gift.NormalGift && dataServer.Gift.NormalGift.ItemType == "MazeKey")
						{
							mc.name = "GUIGameEventMidle8_Arrow" + ARROW_KEY;
							imageKey = new Image(mc, mc.name);
							img.addChild(mc);
							mc.x = ctn.CurPos.x;
							mc.y = ctn.CurPos.y;
							isMazeKey = true;
							numGiftRecieve = 1;
						}
						else
						{
							isProcess = true;
							AddMoreContent(dataServer.Gift);
							var domain:int = 0;
							data = dataServer.Gift;
							for (iStr in data)
							{
								objGiftReceive = data[iStr];
								break;
							}
							if(iStr == "NormalGift")
							{
								if (objGiftReceive.ItemType)
								{
									typeGift = objGiftReceive.ItemType;
									if (typeGift == "Money")
									{
										typeGift = "IcGold";
									}
								}
								if(objGiftReceive.ItemId)
									idGift = objGiftReceive.ItemId;
								if (typeGift == "Material" && int(idGift) >= 100)
								{
									idGift = (int(idGift) % 100).toString() + "S";
								}
								nameGift = typeGift + idGift;
								nameSprite = nameGift;
								numGiftRecieve = objGiftReceive.Num
							}
							else if(iStr == "SpecialGift")
							{
								GameLogic.getInstance().user.GenerateNextID();
								nameGift = objGiftReceive.Type + objGiftReceive.Rank + "_Shop";
								nameSprite = objGiftReceive.Type + objGiftReceive.Rank + "_Shop";
								numGiftRecieve = 1;
							}
							mc.name = nameSprite;
							imageGift = new Image(mc, nameGift);
							if (domain > 0)
							{
								imageDomain = new Image(mc, Fish.DOMAIN + domain.toString(), 0, -30);
							}
							img.addChild(mc);
							mc.x = ctn.CurPos.x;
							mc.y = ctn.CurPos.y;
							mc.x -= mc.width / 2;
							mc.y -= mc.height / 2;
							isMazeKey = false;
						}
						
						spProcess = mc;
						// Giải phóng RAM
						mc = null;
						dataGift = data;
						isProcessZoomInOut = true;
						isProcess = false;

						var stEffNum:String = "+" + Ultility.StandardNumber(numGiftRecieve);
						var txtFormat :TextFormat = new TextFormat("Arial", 48, 0xffffff, true);
						if(nameGift == "Exp")
						{
							txtFormat.color = 0x00FFFF;
						}
						else
						{
							txtFormat.color = 0xFFFF00;
						}
						txtFormat.font = "SansationBold";
						txtFormat.align = "left"
						var tmp1:Sprite = Ultility.CreateSpriteText(stEffNum, txtFormat, 6, 0x293661, true);
						
						var pos:Point = new Point(spProcess.x , spProcess.y);
						pos = img.localToGlobal(pos);
						var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1) as ImgEffectFly;
						eff1.SetInfo(pos.x, pos.y, pos.x, Math.max(pos.y - 300, 10), 10);
						var arrIdCtn:Array = idCtnLiveNow.split("_");
						if(objMap[arrIdCtn[1]][arrIdCtn[2]] == STATE_SPECIAL_TREASURE ||objMap[arrIdCtn[1]][arrIdCtn[2]] == STATE_END)
						{
							txtNumArrowKey.text = String(Math.max(int(txtNumArrowKey.text) - 1, 0));
							if (MazeKeyInfo.Num != null && int(MazeKeyInfo.Num) <= 0)
							{
								arrArrow[ARROW_KEY - 1] = arrArrow[ARROW_KEY - 1] - 1;
							}
							else
							{
								MazeKeyInfo.Num = 0;
							}
						}
					}
					else
					{
						ShowBtnArrow();
						RoadState = ROAD_STATE_NORMAL;
						isEff = false;
						GetButton(BTN_CLOSE).SetEnable();
					}
				}
				break;
				
				case CELL_END:
				{
					RoadState = ROAD_STATE_NORMAL;
					ReNewMap();
					EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffQuitGameMidle8", null, Constant.STAGE_WIDTH / 2 - 100, Constant.STAGE_HEIGHT / 2,
														false, false, null, function():void { ShowGiftFinal(arrNameGift, arrNumGift, dataServer.Gift) } );
				}
				break;
				
				case CELL_GIFT:
				{
					RoadState = ROAD_STATE_NORMAL;
					GuiMgr.getInstance().GuiGiftGameMid8.AddGift(dataServer.Gift);
					GuiMgr.getInstance().GuiGiftGameMid8.Show(Constant.GUI_MIN_LAYER, 1);
					GetButton(BTN_CLOSE).SetEnable();
				}
				break;
				
				case CELL_TORNADO:
				{
					RoadState = ROAD_STATE_TORNADO;
					EffTornado(dataServer, timeStamp);
				}
				break;
				
				case CELL_QUESTION:
				{
					RoadState = ROAD_STATE_ANSWERING;
					Question = int(dataServer.Question);
					GuiMgr.getInstance().GuiAnswerQuestion.timeStamp = timeStamp;
					GuiMgr.getInstance().GuiAnswerQuestion.IdQuest = Question;
					GuiMgr.getInstance().GuiAnswerQuestion.Show(Constant.GUI_MIN_LAYER, 1);
					GetButton(BTN_CLOSE).SetEnable();
				}
				break;
			}
		}
		
		public function ShowGiftFinal(arrNameGift:Array, arrNumGift:Array, data:Object):void 
		{
			GuiMgr.getInstance().GuiGiftFinalGameMid8.InitGui(arrNameGift, arrNumGift, arrObjGift, data);
			GetButton(BTN_CLOSE).SetEnable();
		}
		
		public function EffTornado(dataServer:Object, timeStamp:int):void 
		{
			isEff = true;
			var strDes:String;
			if (dataServer.New_Position)
			{
				strDes = CTN_SQUARE + dataServer.New_Position.Y + "_" + dataServer.New_Position.X;
			}
			else 
			{
				return;
			}
			var ctn:Container = GetContainer(idCtnLiveNow);
			var ctnDes:Container = GetContainer(strDes);
			posDeltaTornado = new Point(ctnDes.CurPos.x - ctn.CurPos.x, ctnDes.CurPos.y - ctn.CurPos.y);
			DiableAllArrowBtn();
			if(strDes != idCtnLiveNow)
			{
				effTornado = EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffTornado", null, ctn.CurPos.x - DELTA_TORNADO_POINT_X, ctn.CurPos.y - DELTA_TORNADO_POINT_Y,
																		false, true, null, function():void { GotoNewPos(dataServer, timeStamp) } );
			}
			else 
			{
				EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffTornado", null, ctn.CurPos.x - DELTA_TORNADO_POINT_X, ctn.CurPos.y - DELTA_TORNADO_POINT_Y,
														false, false, null, function():void { GotoNewPos(dataServer, timeStamp) } );
			}
		}
 		
		public function AddMoreContent(data:Object, numGiftAdd:int = 0):void 
		{
			var setInfo:Function = function():void
			{
				//Vẽ aura bằng glowFilter
				var cl:int = 0xff0000;
				TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
			}
			var i:int = 0;
			var j:int = 0;
			var iStr:String;
			var jStr:String;
			var Start_X:int = 5;
			var Start_Y:int = 5;
			var delta_X:int = Start_X + WIDTH_CTN_IN_SCROLL;
			var delta_Y:int = Start_Y + HEIGHT_CTN_IN_SCROLL;
			var X:int = 0;
			var Y:int = 0;
			
			var arrStrKey:Array = [];
			var isNameExist:Boolean = false;
			var isNameSpecialExist:Boolean = false;
			if (data.SpecialGift != null)
			{
				var revardElement:Object = data.SpecialGift;
				isNameExist = false;
				{
					if (Revards.SpecialGift == null)	Revards.SpecialGift = new Object();
					Revards.SpecialGift[String(revardElement.Id)] = revardElement;
					arrNameGift.push(revardElement.Type + revardElement.Rank + "_Shop");
					arrNumGift.push(numGiftAdd);
					arrObjGift.push(revardElement);
				}
			}
			else if (data.NormalGift != null) 
			{
				var obj:Object = data.NormalGift;
				if (obj == null)	obj = new Object();
				isNameExist = false;
				var strNameNormal:String
				if (obj.ItemId)
				{
					strNameNormal = obj.ItemType + obj.ItemId ;
				}
				else
				{
					strNameNormal = obj.ItemType;
					if (obj.ItemType == "Money")
					{
						strNameNormal = "IcGold";
					}
				}
				
				if (obj.ItemType == "Material" && obj.ItemId >= 100)
				{
					strNameNormal = obj.ItemType + (obj.ItemId % 100) + "S";
				}
				
				for (i = 0; i < arrNameGift.length; i++)
				{
					if (strNameNormal == arrNameGift[i])
					{
						isNameExist = true;
						arrNumGift[i] += numGiftAdd;
						break;
					}
				}
				
				if (!isNameExist)
				{
					arrNameGift.push(strNameNormal);
					arrNumGift[i] = numGiftAdd;
					if (!Revards.NormalGift)
					{
						Revards.NormalGift = [];
					}
					var arrRevardNormal:Array = Revards.NormalGift as Array;
					arrRevardNormal.push(data.NormalGift);
					arrObjGift.push(data.NormalGift);
				}
				else 
				{
					for (var si:String in Revards.NormalGift) 
					{
						if (obj.ItemType == Revards.NormalGift[si].ItemType && 
							((obj.ItemId && Revards.NormalGift[si].ItemId && obj.ItemId == Revards.NormalGift[si].ItemId) || 
							(obj.ItemId == null && Revards.NormalGift[si].ItemId == null)))
						{
							Revards.NormalGift[si].Num += obj.Num;
							break;
						}
					}
				}
			}
			
			if (!isNameExist && (data.NormalGift != null ||  data.SpecialGift != null))
			{
				var ctnGift:Container = AddElementGift(arrNameGift[arrNameGift.length - 1], arrObjGift[arrObjGift.length - 1], arrNumGift[arrNumGift.length - 1]);
				listGift.addItem(CTN_GIFT_SCROLL + (arrNameGift.length - 1), ctnGift, this);
				if (listGift.length > 6)
				{
					scrollBar.visible = true;
				}
				else 
				{
					scrollBar.visible = false;
				}
				
				if (listGift.length > 0)
				{
					if (txtKhoEmpty)	txtKhoEmpty.visible = false;
					if (txtKho)	txtKho.visible = false;
				}
				else 
				{
					if (txtKhoEmpty)	txtKhoEmpty.visible = true;
					if (txtKho)	txtKho.visible = true;
				}
			}
		}
		
		public function GotoNewPos(dataServer:Object, timeStamp:int):void
		{
			if (effTornado != null)	effTornado = null;
			var idCtnLiveNew:String = CTN_SQUARE + dataServer.New_Position.Y + "_" + dataServer.New_Position.X;
			var rowOld:int = int(idCtnLiveNow.split("_")[1]);
			var colOld:int = int(idCtnLiveNow.split("_")[2]);
			var idCtnStart:String = CTN_SQUARE + "0_0";
			var idCtnEnd:String = CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1);
			
			if(!GetContainer(idCtnLiveNow).tooltip && idCtnLiveNow != idCtnStart && idCtnLiveNow != idCtnEnd)
			{
				var ToolTip:TooltipFormat = new TooltipFormat();
				ToolTip.text = "Bạn đã nhận quà rồi";
				GetContainer(idCtnLiveNow).setTooltip(ToolTip);
			}
			
			GetContainer(idCtnLiveNow).SetHighLight(-1);
			GetContainer(idCtnLiveNew).SetHighLight(COLOR_USER);
			var rowNow:int = int(idCtnLiveNew.split("_")[1]);
			var colNow:int = int(idCtnLiveNew.split("_")[2]);
			
			// lấy lại state ban đầu của ô vừa đi qua và gán lại vào trong mảng arrMap
			var state:int = int(objMap[rowOld.toString()][colOld.toString()]);
			if(state >= 10 && state <= 15)
			{
				arrMap[rowOld][colOld] = STATE_CAN_MOVE;
			}
			else 
			{
				arrMap[rowOld][colOld] = state;
			}
			// Xóa hết hình ảnh ở ô xuất phát và vẽ lại 
			GetContainer(idCtnLiveNow).RemoveAllImage();
			var strStateOld:String = arrMap[rowOld][colOld].toString();
			if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0) &&  state == STATE_END)
			{
				strStateOld = strStateOld + "Open";
			}
			GetContainer(idCtnLiveNow).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + strStateOld, GetContainer(idCtnLiveNow).img.width / 2, GetContainer(idCtnLiveNow).img.height / 2);
			if(state == STATE_END)
			{
				GetContainer(idCtnLiveNow).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn / 2 - 5, -heightCtn / 2 - 5));
			}
			if(!(arrMap[rowOld][colOld] == STATE_END || (arrMap[rowOld][colOld] == STATE_SPECIAL_TREASURE && arrMapLeaved[rowOld][colOld] != STATE_LEAVED)))
			{
				SetEnableSprite(GetContainer(idCtnLiveNow).GetImage("ImgState").img, false);
			}
			
			GetContainer(idCtnLiveNew).RemoveAllImage();
			GetContainer(idCtnLiveNew).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + STATE_LIVE, GetContainer(idCtnLiveNew).img.width / 2, GetContainer(idCtnLiveNew).img.height / 2);
			GetContainer(idCtnLiveNew).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn + 7, - heightCtn));
			idCtnLiveNow = idCtnLiveNew;
			
			/**
			 * Chú ý là nếu ô quà đặc biệt thì còn cần xét đến trạng thái đã nhận quà hay chưa.
			 * Nếu chưa thì không được lưu lại vào data
			 */
			
			var isGetGiftSpecialTreasure:Boolean = false;
			// Nếu như ô hiện tại chuẩn bị đến không phải là ô đã từng đi qua
			if(arrMap[rowOld][colOld] != STATE_SPECIAL_TREASURE || (arrMap[rowOld][colOld] == STATE_SPECIAL_TREASURE && ((MazeKeyInfo.Num > 0 || arrArrow[ARROW_KEY - 1] > 0))))
			{
				if(arrMap[rowOld][colOld] != STATE_END)
				{
					arrMapLeaved[rowOld][colOld] = STATE_LEAVED;
				}
			}
			if(arrMapLeaved[rowNow][colNow] != STATE_LEAVED)
			{
				// Nếu là ô chuẩn bị đến không phải là ô cuối cùng hoặc ô rương báu.
				// Còn nếu là một trong 2 ô đó thì kiểm tra xem có key không. Nếu có key thì gửi gói tin lấy quà lên server
				if (((idCtnLiveNow != CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1)) && (arrMap[rowNow][colNow] != STATE_SPECIAL_TREASURE)) 
					|| (MazeKeyInfo.Num > 0 || arrArrow[ARROW_KEY - 1] > 0))
				{
					if(arrMap[rowNow][colNow] == STATE_SPECIAL_TREASURE && ((MazeKeyInfo.Num > 0 || arrArrow[ARROW_KEY - 1] > 0)))
					{
						arrMapLeaved[rowNow][colNow] = STATE_LEAVED;
					}
					if (arrMap[rowNow][colNow] == STATE_SPECIAL_TREASURE)
					{
						isGetGiftSpecialTreasure = true;
						if (int(MazeKeyInfo.Num) <= 0)
						{
							arrArrow[ARROW_KEY - 1]--;
							user.UpdateStockThing("Arrow", ARROW_KEY, -1);
						}
						else 
						{
							MazeKeyInfo.Num = 0;
						}
						// Cập nhật lại trạng thái ô thoát khỏi mê cung
						GetContainer(idCtnEnd).RemoveAllImage();
						var strStateOldEnd:String = STATE_END.toString();
						if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0))
						{
							strStateOldEnd = strStateOldEnd + "Open";
						}
						GetContainer(idCtnEnd).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + strStateOldEnd, GetContainer(idCtnEnd).img.width / 2, GetContainer(idCtnEnd).img.height / 2);
						GetContainer(idCtnEnd).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn / 2 - 5, -heightCtn / 2 - 5));
					}
					arrMap[rowNow][colNow] = STATE_LIVE;
					arrMap[rowOld][colOld] = arrMapConstant[rowOld][colOld];
					var cmd1:SendGetEventOnRoad = new SendGetEventOnRoad(timeStamp);
					GetButton(BTN_CLOSE).SetDisable();
					Exchange.GetInstance().Send(cmd1);
				}
				else 
				{
					// Nếu như mà trong trường hợp vào hai ô đó mà không có chìa khóa thì hiện bảng mua chìa khóa lên
					if (MazeKeyInfo.Num <= 0 && arrArrow[ARROW_KEY - 1] <= 0)
					{
						GuiMgr.getInstance().GuiMessageFinishGame.Show(Constant.GUI_MIN_LAYER, 3);
					}
					ShowBtnArrow();
					GetButton(BTN_CLOSE).SetEnable();
				}
			}
			else 
			{
				ShowBtnArrow();
				GetButton(BTN_CLOSE).SetEnable();
				
			}
			
			/**
			 * cập nhật các dữ liệu cần thiết
			 * thứ nhất là:	Cập nhật vị trí đứng hiện tại vào data
			 * thứ hai là:	cập nhật vào lịch sử đường đi
			 */
			Position.Y = rowNow;
			Position.X = colNow;
			
			arrMap[rowNow][colNow] = STATE_LIVE;
			if (isGetGiftSpecialTreasure)
			{
				arrMapLeaved[rowOld][colOld] = STATE_LEAVED;
			}
			var objHistory:Object = new Object();
			if (History[rowOld.toString()])
			{
				History[rowOld.toString()][colOld.toString()] = true;
			}
			else 
			{
				objHistory[colOld.toString()] = true;
				History[rowOld.toString()] = objHistory;
			}
			RoadState = ROAD_STATE_NORMAL;
			isEff = false;
		}
		
		public function OnFinishTweenMax(mc:Sprite, data:Object, timeStamp:int):void 
		{
			if(!isMazeKey)
			{
				var typeGift:String;
				for (typeGift in data)
				{
					break;
				}
				mc.visible = false;
				ShowBtnArrow();
				RoadState = ROAD_STATE_NORMAL;
				var index:int = arrNameGift.indexOf(mc.name);
				if(typeGift == "NormalGift")
				{
					arrNumGift[index] += int(data[typeGift].Num);
				}
				else if(typeGift == "SpecialGift")
				{
					for (var i:int = 0; i < arrNameGift.length; i++) 
					{
						if (mc.name == arrNameGift[i])
						{
							arrNumGift[i] = 1;
						}
					}
				}
				isEff = false;
				GetButton(BTN_CLOSE).SetEnable();
			}
			else 
			{
				MazeKeyInfo.Num = 1;
				mc.visible = false;
				RoadState = ROAD_STATE_NORMAL;
				var numArrowKey:int = int(txtNumArrowKey.text);
				numArrowKey++;
				txtNumArrowKey.text = (numArrowKey).toString();
				ShowBtnArrow();
				var ctn:Container = GetContainer(CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1));
				if(numArrowKey == 1)
				{
					isEff = true;
					EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffOpenWindowGameMidle8", null, ctn.CurPos.x - widthCtn, ctn.CurPos.y - heightCtn,
														false, false, null, function():void { ShowLock(timeStamp) } );
				}
				else 
				{
					isEff = false;
					GetButton(BTN_CLOSE).SetEnable();
				}
			
			}
			mc.parent.removeChild(mc);
			mc = null;
		}
		
		public function ShowLock(timeStamp:int):void 
		{
			var idCtnEnd:String = CTN_SQUARE + (NUM_ROW - 1) + "_" + (NUM_COL - 1);
			if(GetContainer(idCtnEnd))	GetContainer(idCtnEnd).RemoveAllImage();
			var strStateOld:String = STATE_END.toString();
			if ((arrArrow[ARROW_KEY - 1] > 0 || MazeKeyInfo.Num > 0))
			{
				strStateOld = strStateOld + "Open";
			}
			if(GetContainer(idCtnEnd))	GetContainer(idCtnEnd).AddImage("ImgState", "GUIGameEventMidle8_ImgState" + strStateOld, GetContainer(idCtnEnd).img.width / 2, GetContainer(idCtnEnd).img.height / 2);
			if(GetContainer(idCtnEnd))	GetContainer(idCtnEnd).GetImage("ImgState").FitRect(40, 40, new Point( - widthCtn / 2 - 5, -heightCtn / 2 - 5));
			var arrID:Array = idCtnLiveNow.split("_");
			if (idCtnLiveNow == idCtnEnd || (objMap[arrID[1]][arrID[2]] == STATE_SPECIAL_TREASURE && arrMapLeaved[arrID[1]][arrID[2]] != STATE_LEAVED))
			{
				arrMapLeaved[arrID[1]][arrID[2]] = STATE_LEAVED;
				var cmd1:SendGetEventOnRoad = new SendGetEventOnRoad(timeStamp);
				GetButton(BTN_CLOSE).SetDisable();
				Exchange.GetInstance().Send(cmd1);
			}
			isEff = false;
		}
		
		/**
		 * KHởi tạo các dữ liệu cơ sở trong gui
		 */
		public function InitBaseData():void 
		{
			listGift
			var i:int = 0;
			objArrow = ConfigJSON.getInstance().GetItemList("Arrow");
			objAllMap = ConfigJSON.getInstance().GetItemList("Map");
			objAllMapRewards = ConfigJSON.getInstance().GetItemList("MapRewards");
			FishIdFollowLevel = ConfigJSON.getInstance().GetItemList("FishIdFollowLevel");
			user = GameLogic.getInstance().user;
		}
		/**
		 * Hàm lấy kiểu lưu trữ trong object revards từ tên quà
		 * @param	name
		 * @return
		 */
		public function GetTypeGift(name:String):String
		{
			if (name == "Sparta" || name.search("Fish") >= 0)
			{
				return "SpecialGift";
			}
			return "NormalGift";
		}
		/**
		 * Khởi tạo các dữ liệu cần thiết cho Logic và GUI
		 */
		public function InitData():void 
		{
			if (!so.data.numDice)
			{
				so.data.numDice = 1;
				isChooseTwoDice = false;
			}
			else 
			{
				isChooseTwoDice = false;
			}
			Ultility.FlushData(so);
			
			arrGiftInMap = [];
			arrMap = [];
			arrMapConstant = [];
			arrMapLeaved = [];
			arrObjGift = [];
			arrNameGift = [];
			arrNumGift = [];
			arrArrow = [];
			count = 0;
			var i:int = 0;
			var j:int = 0;
			var iStr:String = "";
			var jStr:String = "";
			objMap = objAllMap[MapId.toString()];
			// KHởi tạo số lượng quà trong scroll bar
			for (iStr in Revards) 
			{
				var arrStrKey:Array = [];
				var isNameExist:Boolean = false;
				var isNameSpecialExist:Boolean = false;
				if (iStr == "SpecialGift")
				{
					for (jStr in Revards[iStr]) 
					{
						for (var kNew:int = 0; kNew < arrStrKey.length; kNew++) 
						{
							var item:String = arrStrKey[kNew];
							if (item == jStr)
							{
								isNameSpecialExist = true;
							}
						}
						if(!isNameSpecialExist)
						{
							arrStrKey.push(jStr);
							var revardElement:Object = Revards[iStr][jStr];
							{
								if (Revards.SpecialGift == null)	Revards.SpecialGift = new Object();
								Revards.SpecialGift[String(revardElement.Id)] = revardElement;
								arrNameGift.push(revardElement.Type + revardElement.Rank + "_Shop");
								arrNumGift.push(1);
								arrObjGift.push(revardElement);
							}
						}
					}
				}
				else if (iStr == "NormalGift") 
				{
					var arr:Array = Revards["NormalGift"] as Array;
					if (arr == null)	arr = [];
					for (j = 0; j < arr.length; j++)
					{
						isNameExist = false;
						var strName:String
						if (arr[j].ItemId)
						{
							strName = arr[j].ItemType + arr[j].ItemId ;
						}
						else
						{
							if(arr[j].ItemId)
							{
								strName = arr[j].ItemType + arr[j].ItemId;
							}
							else 
							{
								strName = arr[j].ItemType;
								if (strName == "Money")	strName = "IcGold";
							}
						}
						
						if (arr[j].ItemType == "Material" && arr[j].ItemId >= 100)
						{
							strName = arr[j].ItemType + (arr[j].ItemId % 100) + "S";
						}
						
						if (arr[j].ItemType == "MazeKey")
						{
							continue;
						}
						
						for (i = 0; i < arrNameGift.length; i++)
						{
							if (strName == arrNameGift[i])
							{
								arrNumGift[i] += arr[j].Num;
								isNameExist = true;
								break;
							}
						}
						
						if (!isNameExist)
						{
							arrNameGift.push(strName);
							arrNumGift[i] = arr[j].Num;
						}
						
						arrObjGift.push(Revards["NormalGift"][j]);
					}
				}
			}
			
			// KHởi tạo mảng chứa các tham số trạng thái của map
			for (i = 0; i < NUM_ROW; i++) 
			{
				var arrMapRow:Array = [];
				var arrMapRowLeaved:Array = [];
				var arrGiftRow:Array = [];
				for (j = 0; j < NUM_COL; j++)
				{
					if (objMap[i.toString()][j.toString()])
					{
						if (int(objMap[i.toString()][j.toString()]) == 5)
						{
							trace();
						}
						if (int(objMap[i.toString()][j.toString()]) >= 10 && int(objMap[i.toString()][j.toString()]) <= 15)
						{
							arrMapRow.push(STATE_CAN_MOVE);
							arrMapRowLeaved.push(STATE_CAN_MOVE);
							arrGiftRow.push(int(objMap[i.toString()][j.toString()]));
						}
						else
						{
							arrMapRow.push(int(objMap[i.toString()][j.toString()]));
							arrMapRowLeaved.push(int(objMap[i.toString()][j.toString()]));
							arrGiftRow.push(int(objMap[i.toString()][j.toString()]));
						}
					}
					else 
					{
						arrMapRow.push(STATE_CANT_MOVE);
						arrMapRowLeaved.push(STATE_CANT_MOVE);
						arrGiftRow.push(STATE_CANT_MOVE);
					}
				}
				arrMap.push(arrMapRow);
				arrMapConstant.push(arrMapRow);
				arrMapLeaved.push(arrMapRowLeaved);
				arrGiftInMap.push(arrGiftRow);
			}
			// KHởi tạo các vị trí đã đi qua
			for (iStr in History)
			{
				var objInHistory:Object = History[iStr];
				for (jStr in objInHistory) 
				{
					if(arrMapLeaved[int(iStr)][int(jStr)] != STATE_END)
					{
						arrMapLeaved[int(iStr)][int(jStr)] = STATE_LEAVED;
					}
				}
			}
			// Khởi tạo vị trí đang đứng
			arrMap[int(Position.Y)][int(Position.X)] = STATE_LIVE;
			idCtnLiveNow = CTN_SQUARE + Position.Y + "_" + Position.X;
			// Khởi tạo mảng chứa các Icon mà user đang có
			for (i = 0; i < ARROW_KEY; i++)
			{
				arrArrow.push(0);
			}
			for (i = 0; i < user.StockThingsArr.Arrow.length; i++)
			{
				var objArrowTemp:Object = user.StockThingsArr.Arrow[i];
				arrArrow[int(objArrowTemp.Id) - 1] = objArrowTemp.Num;
			}
			if (MazeKeyInfo.Num > 0)
			{
				arrArrow[ARROW_KEY - 1] += MazeKeyInfo.Num;
			}
		}
		/**
		 * Lấy dạng của Arrow khi biết được sự thay đổi hàng, cột
		 * @param	deltaRow
		 * @param	deltaCol
		 * @return
		 */
		public function GetTypeArrow(deltaRow:int, deltaCol:int):int
		{
			if (deltaRow == 0)
			{
				if (deltaCol == 1)
				{
					return ARROW_RIGHT;
				}
				else if(deltaCol == -1)
				{
					return ARROW_LEFT;
				}
			}
			if (deltaCol == 0)
			{
				if (deltaRow == 1)
				{
					return ARROW_DOWN;
				}
				else if(deltaRow == -1)
				{
					return ARROW_UP;
				}
			}
			return 0;
		}
		/**
		 * Lấy cặp (deltaRow, deltaCol) khi biết được loại mũi tên
		 * @param	TypeArrow
		 * @return
		 */
		public function GetDeltaFromArrow(TypeArrow:int):Point
		{
			switch (TypeArrow) 
			{
				case ARROW_UP:
					return new Point(-1, 0);
				break;
				case ARROW_DOWN:
					return new Point(1, 0);
				break;
				case ARROW_LEFT:
					return new Point(0, -1);
				break;
				case ARROW_RIGHT:
					return new Point(0, 1);
				break;
				default:
					return new Point(0, 0);
				break;
			}
		}
		
		public function SetEnableSprite(spEnable:Sprite, IsEnable:Boolean = true):void
		{
			if (!IsEnable)
			{				
				var elements:Array =
				[0.20, 0.20, 0.20, 0, 0,
				0.20, 0.20, 0.20, 0, 0,
				0.20, 0.20, 0.20, 0, 0,
				0, 0, 0, 1, 0];

				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				spEnable.filters = [colorFilter];
			}
			else
			{
				spEnable.mouseEnabled = true;
				spEnable.filters = null;
			}
		}
		/**
		 * Dựa vào FishType và FishLevel của cá để trả về tên của cá được đặt trong GUI
		 * @param	FishType
		 * @param	FishLevel
		 * @return
		 */
		public function GetNameFishInGui(FishType:int = 0, FishLevel:int = int.MAX_VALUE):String
		{
			var levelUser:int = user.GetLevel();
			if (FishType == Fish.FISHTYPE_RARE)
			{
				return "Fish_0_2";
			}
			else if(FishLevel - levelUser < 3)
			{
				return "Fish_0_0";
			}
			else if(FishLevel - levelUser < 5)
			{
				return "Fish_3_0";
			}
			else if(FishLevel - levelUser < 10)
			{
				return "Fish_5_0";
			}
			return "Sparta";
		}
	}

}