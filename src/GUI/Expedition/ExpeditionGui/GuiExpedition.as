package GUI.Expedition.ExpeditionGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.Expedition.ExpeditionGui.ItemGui.MapExpedition;
	import GUI.Expedition.ExpeditionLogic.ExpeditionMgr;
	import GUI.Expedition.ExpeditionLogic.ExpeditionXML;
	import GUI.Expedition.ExpeditionLogic.ExQuestInfo;
	import GUI.Expedition.ExpeditionPackage.SendBuyExpeditionCard;
	import GUI.Expedition.ExpeditionPackage.SendRollingDice;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiGetStatus.SendGetStatus;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.BasePacket;
	
	/**
	 * Gui chính của viễn chinh
	 * @author HiepNM2
	 */
	public class GuiExpedition extends GUIGetStatusAbstract 
	{
		//const - id
		private const ID_BTN_ROLLDICE:String = "IdBtnRolldice";
		private const ID_BTN_CLOSE:String = "IdBtnClose";
		private const ID_BTN_INCREASE_VALUE:String = "IdBtnIncreaseValue";
		private const ID_BTN_DECREASE_HARD:String = "IdBtnDecreaseHard";
		private const ID_BTN_BUY_CARD:String = "IdBtnBuyCard";
		private const ID_BTN_RECEIVE_GIFT:String = "IdBtnReceiveGift";			//id nút nhận thưởng
		private const ID_BTN_COMPLETE_QUICK:String = "IdBtnCompleteQuick";		//id nút hoàn thành nhanh
		private const ID_BTN_PREVMAP:String = "idBtnPrevmap";
		private const ID_BTN_NEXTMAP:String = "idBtnNextmap";
		
		private const XMAP:int = 50;
		private const LENGTH_MAP:int = 3381;
		private const LENGTH_SCREEN:int = 676;
		private const DELTA_X:int = 20;
		private const TIME_HOLD:Number = 0.05;
		private const IMG_SLOT_GIFT:String = "imgSlotGift";
		//var - logic
		private var isLoadXML:Boolean = false;
		private var inRolling:Boolean = false;
		private var inUpDown:Boolean = false;
		private var inBuyCard:Boolean = false;
		private var isHoldNext:Boolean = false;
		private var isHoldPrev:Boolean = false;
		private var inRequestComplete:Boolean = false;
		//var - gui
		private var guiBuyCard:GuiBuyCard = new GuiBuyCard(null, "");
		private var btnClose:Button;
		private var _map:MapExpedition;
		private var btnNext:Button;
		private var btnPrev:Button;
		private var btnDice:Button;
		private var btnDec:Button;
		private var btnInc:Button;
		private var btnCompQuick:Button;
		private var tfPriceRoll:TextField;
		private var imgIconType:Image;
		private var imgTxtType:Image;
		private var tfTipStart:TextField;
		//private var tfTipFinish1:TextField;
		private var tfTipFinish2:TextField;
		private var tfTask:TextField;
		private var tfComplete:TextField;
		private var imgLineTask:Image;		//dòng để viết text lên
		private var imgLineGift:Image;		//dòng kẻ cạnh chữ phần thưởng
		private var imgTextGift:Image;		//chữ phần thưởng
		private var imgLineRequire:Image;	//dòng kẻ cạnh chữ yêu cầu
		private var imgTextRequire:Image;	//chữ yêu cầu
		private var imgDice:Image;
		private var tfNumCard:TextField;
		private var tfPriceCompleteQuick:TextField;
		private var imgBoxCard:Image;
		private var btnBuyCard:Button;
		private var imgSpeechBegin:Image;
		private var imgSpeechEnd:Image;
		private var imgCongrate:Image;
		private var imgTienCa:Image;
		private var tfHard:TextField;
		private var tfValue:TextField;
		private var imgNoneStarHard1:Image,imgNoneStarHard2:Image,imgNoneStarHard3:Image,imgNoneStarHard4:Image,imgNoneStarHard5:Image;
		private var imgNoneStarValue1:Image, imgNoneStarValue2:Image, imgNoneStarValue3:Image, imgNoneStarValue4:Image, imgNoneStarValue5:Image;
		private var imgStarHard1:Image, imgStarHard2:Image, imgStarHard3:Image, imgStarHard4:Image, imgStarHard5:Image;
		private var imgStarValue1:Image, imgStarValue2:Image, imgStarValue3:Image, imgStarValue4:Image, imgStarValue5:Image;
		private var _listItemGift:Array = [];
		
		public function GuiExpedition(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			_urlService = "ExpeditionService.getStatus";
			_idPacket = Constant.CMD_GET_EXPEDITION_STATUS;
			_imgThemeName = "GuiExpedition_Theme";
		}
		public function get LoadDataComp():Boolean {
			return IsDataReady;
		}
		public function get FinishRoomOutComp():Boolean {
			return IsFinishRoomOut;
		}
		public function set IsLoadFileOk(value:Boolean):void {
			IsLoadFileComp = value;
			isLoadXML = value;
		}
		/**
		 * thực hiện load về file ExpeditionTask.xml
		 */
		override protected function onLoadSomeThing():void 
		{
			if (!isLoadXML)
			{
				IsLoadFileComp = false;
				ExpeditionMgr.getInstance().loadExpeditionXML(Main.verLocalization);
			}
		}
		override protected function onInitGuiBeforeServer():void 
		{
			GameLogic.getInstance().BackToIdleGameState();
			AddButton(ID_BTN_CLOSE, "BtnThoat", 545, 15);
		}
		
		/**
		 * khởi tạo dữ liệu cho gui
		 * @param	data1 gồm: Index, Gift, Quest, SilkRoad, NumCard, IsNextDay
		 */
		override protected function onInitData(data1:Object):void 
		{
			ExpeditionMgr.getInstance().initData(data1);//đưa ra lớp quản lý dữ liệu
		}
		
		/**
		 * thực hiện vẽ ra map viễn chinh, và nhiệm vụ tại node hiện tại
		 */
		override protected function onInitGuiAfterServer():void 
		{
			_map = new MapExpedition(this.img, "KhungFriend", XMAP, 93);
			_map.create();

			AddImage("", "GuiExpedition_ImgBound", 34, 66, true, ALIGN_LEFT_TOP);
			
			btnPrev = AddButton(ID_BTN_PREVMAP, "GuiExpedition_BtnPrev", 20, 187);
			btnPrev.img.addEventListener(MouseEvent.MOUSE_DOWN, OnBtnPrevDown);
			btnPrev.img.addEventListener(MouseEvent.MOUSE_UP, OnBtnPrevUp);
			
			btnNext = AddButton(ID_BTN_NEXTMAP, "GuiExpedition_BtnNext", 735, 187);
			btnNext.img.addEventListener(MouseEvent.MOUSE_DOWN, OnBtnNextDown);
			btnNext.img.addEventListener(MouseEvent.MOUSE_UP, OnBtnNextUp);
			
			drawPage();
			
			var quest:ExQuestInfo = ExpeditionMgr.getInstance().getQuest();
			if (quest.IsComplete())
			{
				inRequestComplete = true;
				var pk:BasePacket = new SendGetStatus("ExpeditionService.completeQuest", 
										Constant.CMD_COMPLETE_EXPEDITION_QUEST);
				Exchange.GetInstance().Send(pk);
			}
		}
		
		
		private function OnBtnPrevDown(e:MouseEvent):void 
		{
			isHoldPrev = true;
		}
		private function OnBtnPrevUp(e:MouseEvent):void 
		{
			isHoldPrev = false;
		}
		
		private function OnBtnNextDown(e:MouseEvent):void 
		{
			isHoldNext = true;
		}
		private function OnBtnNextUp(e:MouseEvent):void 
		{
			isHoldNext = false;
		}
		
		/**
		 * vẽ toàn bộ phần dưới (dưới cái map, gồm có: quest, quà)
		 */
		private function drawPage():void
		{
			var i:int;
			var price:int;
			var strTip:String;
			var fm:TextFormat;
			var quest:ExQuestInfo = ExpeditionMgr.getInstance().getQuest();
			var type:int = quest.Type;		//loại quest hiện tại
			type = ((type % 100 != 0) && (type % 10 == 0))? 10 : type;
			imgIconType = AddImage("", "GuiExpedition_Icon" + type, 135, 440);
			imgTxtType = AddImage("", "GuiExpedition_Txt" + type, 127, 545);
			
			//content của cảnh khởi đầu (tung xúc xắc)
			imgTienCa = AddImage("", "GuiExpedition_ImgTienCa", 570, 339, true, ALIGN_LEFT_TOP);
			if (ExpeditionMgr.getInstance().NumRoll > 0)
			{
				btnDice = AddButton(ID_BTN_ROLLDICE, "GuiExpedition_BtnDice", 360, 523);
			}
			else
			{
				btnDice = AddButton(ID_BTN_ROLLDICE, "GuiExpedition_BtnDiceZMoney", 350, 512);
				price = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["PriceRoll"];
				tfPriceRoll = AddLabel(Ultility.StandardNumber(price), 420, 516, 0xffffff, 1, 0x000000);
			}
			imgDice = AddImage("", "GuiExpedition_ImgDice", 369, 385, true, ALIGN_LEFT_TOP);
			imgSpeechBegin = AddImage("", "GuiExpedition_ImgSpeechBegin", 336, 331, true, ALIGN_LEFT_TOP);
			strTip = ExpeditionXML.getInstance().getString("TipNumDice");
			var numRoll:int = ExpeditionMgr.getInstance().NumRoll;
			strTip = strTip.replace("@Num@", Ultility.StandardNumber(numRoll));
			tfTipStart = AddLabel("", 376, 336, 0x000000, 1, 0x000000);
			fm = new TextFormat("Arial", 18, 0xffffff, true);
			tfTipStart.defaultTextFormat = fm;
			tfTipStart.text = strTip;
			
			//content của cảnh finish
			imgCongrate = AddImage("", "GuiExpedition_ImgCongrate", 246, 289, true, ALIGN_LEFT_TOP);
			imgSpeechEnd = AddImage("", "GuiExpedition_ImgSpeechEnd", 256, 429, true, ALIGN_LEFT_TOP);
			//strTip = ExpeditionXML.getInstance().getString("TipFinishHeader");
			//tfTipFinish1 = AddLabel(strTip, 470, 350, 0xffffff, 1, 0x000000);
			strTip = ExpeditionXML.getInstance().getString("TipFinishContent");
			tfTipFinish2 = AddLabel("", 364, 441, 0x000000, 1, 0x000000);
			fm = new TextFormat("Arial", 13, 0xffffff, true);
			tfTipFinish2.defaultTextFormat = fm;
			tfTipFinish2.text = strTip;
			
			//content của cảnh in-quest
			imgTextRequire = AddImage("", "GuiExpedition_TxtYeuCau", 258, 325, true, ALIGN_LEFT_TOP);
			imgLineRequire = AddImage("", "GuiExpedition_LineYeuCau", 367, 338, true, ALIGN_LEFT_TOP);
			imgTextGift = AddImage("", "GuiExpedition_TxtPhanThuong", 258, 411, true, ALIGN_LEFT_TOP);
			imgLineGift = AddImage("", "GuiExpedition_LinePhanThuong", 417, 426, true, ALIGN_LEFT_TOP);
			imgLineTask = AddImage("", "GuiExpedition_ImgLineTask", 247, 389, true, ALIGN_LEFT_TOP);
			btnDec = AddButton(ID_BTN_DECREASE_HARD, "GuiExpedition_BtnDecHard", 633, 380);
			btnInc = AddButton(ID_BTN_INCREASE_VALUE, "GuiExpedition_BtnIncValue", 633, 495);
			btnCompQuick = AddButton(ID_BTN_COMPLETE_QUICK, "GuiExpedition_BtnCompleteNow", 347, 555);
			tfTask = AddLabel("", 365, 385, 0xffffff);
			fm = new TextFormat("Arial", 14);
			tfTask.defaultTextFormat = fm;
			tfTask.text = quest.Name;
			tfComplete = AddLabel("", 555, 383, 0xffffff);
			fm = new TextFormat("Arial", 18, 0xffffff, true);
			if (quest.NumTaskComp < quest.MaxNumTask)
			{
				fm.color = 0xff0000;
				fm.bold = true;
			}
			tfComplete.defaultTextFormat = fm;
			tfComplete.text = Ultility.StandardNumber(quest.NumTaskComp) + " / " + Ultility.StandardNumber(quest.MaxNumTask);
			tfHard = AddLabel("", 480, 350, 0x000000, 0, 0x000000);
			fm = new TextFormat("Arial", 14, 0xffffff, true);
			tfHard.defaultTextFormat = fm;
			tfHard.text = "Độ khó:";
			tfValue = AddLabel("", 480, 440, 0x000000, 0, 0x000000);
			tfValue.defaultTextFormat = fm;
			tfValue.text = "Giá trị:";
			var x:int = 550, y1:int = 350, y2:int = 440;
			for (i = 1; i <= 5; i++)
			{
				this["imgNoneStarHard" + i] = AddImage("", "GuiExpedition_Star0", x, y1, true, ALIGN_LEFT_TOP);
				this["imgStarHard" + i] = AddImage("", "GuiExpedition_Star1", x, y1, true, ALIGN_LEFT_TOP);
				if (quest.HardId < i)
				{
					(this["imgStarHard" + i] as Image).img.visible = false;
				}
				this["imgNoneStarValue" + i] = AddImage("", "GuiExpedition_Star0", x, y2, true, ALIGN_LEFT_TOP);
				this["imgStarValue" + i] = AddImage("", "GuiExpedition_Star1", x, y2, true, ALIGN_LEFT_TOP);
				if (ExpeditionMgr.getInstance().Value < i)
				{
					(this["imgStarValue" + i] as Image).img.visible = false;
				}
				x += 30;
			}
			
			//vẽ box mua lệnh bài
			imgBoxCard = AddImage("", "GuiExpedition_NumCardBg", 587, 547, true, ALIGN_LEFT_TOP);
			btnBuyCard = AddButton(ID_BTN_BUY_CARD, "GuiExpedition_BtnBuyCard", 697, 559);
			var numCard:int = ExpeditionMgr.getInstance().NumCard;
			tfNumCard = AddLabel("", 600, 560, 0xffffff, 1, 0x000000);
			tfNumCard.text = Ultility.StandardNumber(numCard);
			tfPriceCompleteQuick = AddLabel("", 466, 560, 0xffffff, 0, 0x000000);
			price = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["CompleteQuick"][quest.HardId.toString()];
			tfPriceCompleteQuick.text = Ultility.StandardNumber(price);
			tfPriceCompleteQuick.mouseEnabled = false;
			
			if (type == 100)//rơi vào cảnh finish
			{
				setVisible(1, false);
				setVisible(2, false);
				setVisible(3, true);
			}
			else if (type == 0 || quest.QuestId == -1)//rơi vào cảnh tung xúc xắc
			{
				goStartPage();
			}
			else//rơi vào cảnh quest
			{
				setVisible(1, false);
				setVisible(2, true);
				setVisible(3, false);
			}
		}
		
		private function setVisible(seg:int,visible:Boolean):void
		{
			switch(seg)
			{
				case 1:
					tfTipStart.visible = btnDice.img.visible = 
					imgDice.img.visible = imgSpeechBegin.img.visible =  
					visible;
					if (tfPriceRoll)
					{
						tfPriceRoll.visible = visible;
					}
					//if (visible)
					//{
						//imgTienCa.img.x = 570;
						//imgTienCa.img.y = 339;
					//}
					break;
				case 2:
					setvisibelAllStar(visible);
					tfHard.visible = tfValue.visible = 
					imgLineGift.img.visible = imgLineRequire.img.visible =
					imgLineTask.img.visible = imgTextGift.img.visible =
					imgTextRequire.img.visible = visible;
					btnCompQuick.img.visible = btnDec.img.visible =
					btnInc.img.visible = visible;
					tfTask.visible = tfComplete.visible = 
					imgBoxCard.img.visible = btnBuyCard.img.visible = 
					tfNumCard.visible = tfPriceCompleteQuick.visible = visible;
					imgTienCa.img.visible = !visible;
					if (visible)
					{
						initListGift();
					}
					else
					{
						clearListGift();
					}
					break;
				case 3:
					/*tfTipFinish1.visible = */tfTipFinish2.visible = 
					imgCongrate.img.visible = imgSpeechEnd.img.visible = 
					visible;
					if (visible)
					{
						imgTienCa.img.x = 589;
						imgTienCa.img.y = 405;
					}
					break;
			}
		}
		
		private function setvisibelAllStar(visible:Boolean):void 
		{
			for (var i:int = 1; i <= 5; i++)
			{
				(this["imgStarHard" + i] as Image).img.visible = visible;
				(this["imgNoneStarHard" + i] as Image).img.visible = visible;
				(this["imgStarValue" + i] as Image).img.visible = visible;
				(this["imgNoneStarValue" + i] as Image).img.visible = visible;
				if (visible)
				{
					if (ExpeditionMgr.getInstance().getQuest().HardId < i)
					{
						(this["imgStarHard" + i] as Image).img.visible = false;
					}
					if (ExpeditionMgr.getInstance().Value < i)
					{
						(this["imgStarValue" + i] as Image).img.visible = false;
					}
				}
			}
		}
		
		public function goStartPage():void 
		{
			setVisible(1, true);
			setVisible(2, false);
			setVisible(3, false);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (ExpeditionMgr.getInstance().isNextDay())
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Sang ngày mới!\nCon đường viễn chinh được làm mới", 310, 200, 1);
				Hide();
				return;
			}
			var pk:BasePacket;
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					if(!inRolling && !inBuyCard && !inUpDown)
						Hide();
				break;
				case ID_BTN_ROLLDICE:
					if (!inRolling && !inBuyCard)	//đang ko deo và ko mua
					{
						var oPriceType:Object = { "priceType":"" };
						if (checkRollDice(oPriceType))	//check xem còn lần deo và còn tiền ko
						{
							pk = new SendRollingDice(oPriceType["priceType"]);
							Exchange.GetInstance().Send(pk);
							inRolling = true;
						}
					}
				break;
				case ID_BTN_DECREASE_HARD:
					if (!inUpDown)//đang không tiêu lệnh bài
					{
						if (ExpeditionMgr.getInstance().getQuest().HardId == 1)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đang ở độ khó nhỏ nhất\nKhông thể giảm thêm", 310, 200, 1);
							return;
						}
						if (checkCard())
						{
							pk = new SendGetStatus("ExpeditionService.decreaseHard",
																Constant.CMD_DECREASE_HARD);
							Exchange.GetInstance().Send(pk);
							inUpDown = true;
						}
					}
					
				break;
				case ID_BTN_INCREASE_VALUE:
					if (!inUpDown)//đang không tiêu lệnh bài
					{
						if (ExpeditionMgr.getInstance().isMaxValue())
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã đạt giá trị quà cao nhất", 310, 200, 1);
							return;
						}
						if (checkCard())
						{
							pk = new SendGetStatus("ExpeditionService.increaseValue",
																Constant.CMD_INCREASE_VALUE);
							Exchange.GetInstance().Send(pk);
							inUpDown = true;
						}
					}
				break;
				case ID_BTN_BUY_CARD:
					if (!inRolling)
					{
						//var name:String = Localization.getInstance().getString("ExpeditionCard");
						var numMax:int = GameLogic.getInstance().user.GetZMoney();
						guiBuyCard.showGUI(numMax, "Lệnh bài viễn chinh", "GuiExpedition_IcCard", fBuyCard);
					}
				break;
				case ID_BTN_PREVMAP:
					_map.shiftRight();
				break;
				case ID_BTN_NEXTMAP:
					_map.shiftLeft();
				break;
				case ID_BTN_COMPLETE_QUICK:
					if (!inUpDown)
					{
						var hardId:int = ExpeditionMgr.getInstance().getQuest().HardId;
						var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["CompleteQuick"][hardId.toString()];
						if (Ultility.payMoney("ZMoney", price))
						{
							inRequestComplete = true;
							pk = new SendGetStatus("ExpeditionService.completeQuick", 
													Constant.CMD_COMPLETE_EXPEDITION_QUEST);
							Exchange.GetInstance().Send(pk);
						}
					}
				break;
			}
		}
		
		/**
		 * kiểm tra xem có deo được xúc xắc ko?
		 * @return
		 */
		private function checkRollDice(oTypePrice:Object):Boolean
		{
			var numRoll:int = ExpeditionMgr.getInstance().NumRoll;
			if (numRoll > 0)
			{
				numRoll = --ExpeditionMgr.getInstance().NumRoll;
				//cập nhật xâu "Còn @Num lần"
				var strTip:String = ExpeditionXML.getInstance().getString("TipNumDice");
				strTip = strTip.replace("@Num@", Ultility.StandardNumber(numRoll));
				tfTipStart.text = strTip;
				if (ExpeditionMgr.getInstance().NumRoll == 0)
				{
					//đổi nút tung xúc xắc = tung bằng G
					RemoveButton(ID_BTN_ROLLDICE);
					btnDice = AddButton(ID_BTN_ROLLDICE, "GuiExpedition_BtnDiceZMoney", 350, 512);
					var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["PriceRoll"];
					tfPriceRoll = AddLabel(Ultility.StandardNumber(price), 420, 516, 0xffffff, 1, 0x000000);
				}
				oTypePrice["priceType"] = "Free";
				return true;
			}
			else
			{
				var user:User = GameLogic.getInstance().user;
				var myZMoney:int = user.GetZMoney();
				if (myZMoney > 0)
				{
					user.UpdateUserZMoney( -1);
					oTypePrice["priceType"] = "ZMoney";
					return true;
				}
				else
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return false;
				}
			}
		}
		
		private function checkCard():Boolean
		{
			var numCard:int = ExpeditionMgr.getInstance().NumCard;
			if (numCard > 0)
			{
				ExpeditionMgr.getInstance().NumCard--;
				//thực hiện cập nhật gui
				Ultility.flyNumber(1, 680, 635, 680, 582, 4, 0xff0000, "-");
				tfNumCard.text = Ultility.StandardNumber(ExpeditionMgr.getInstance().NumCard);
				return true;
			}
			else
			{
				var numMax:int = GameLogic.getInstance().user.GetZMoney();
				guiBuyCard.showGUI(numMax, "Lệnh bài viễn chinh", "GuiExpedition_IcCard", fBuyCard);
				return false;
			}
		}
		private function fBuyCard(num:int):void
		{
			if (num > 0)
			{
				inBuyCard = true;
				var pk:SendBuyExpeditionCard = new SendBuyExpeditionCard("ExpeditionCard", num, "ZMoney");
				Exchange.GetInstance().Send(pk);
			}
		}
		/**
		 * deo xúc xắc từ server trả về
		 * @param	data : thông tin về số xúc xắc trả về index, Quest, Gift, TrunkGift(nếu là ô rương)
		 */
		public function rollingDice(data:Object):void
		{
			var xActor:int, firstNode:int, xPosFirstNode:int, index:int, delta:int;
			//khởi gán các dữ liệu cần thiết
			var numDice:int = data["Index"] - ExpeditionMgr.getInstance().Index;//số mặt xúc xắc nhận được
			//add effect tung xúc xắc
			var listFrameStop:Array = [];
			listFrameStop.push(numDice);
			EffectMgr.getInstance().AddSwfEffect1(Constant.GUI_MIN_LAYER,
													"GuiExpedition_EffRandomDice",
													2, listFrameStop,
													Constant.STAGE_WIDTH / 2 - 50, Constant.STAGE_HEIGHT / 2,
													false, false, null, rollingComp);
			function rollingComp():void
			{
				/*chỉnh lại map nếu con cá đang không nằm trong map*/
				xActor = _map.getXactor();
				index = ExpeditionMgr.getInstance().Index;
				firstNode = index - 2 < 0 ? 0 : index - 2;
				//trace("xActor: " + xActor);
				if (xActor < 20)
				{
					xPosFirstNode = Math.abs(_map.getXIndex(firstNode));
					delta = xPosFirstNode + 20;
				}
				else if (xActor >= LENGTH_SCREEN)
				{
					xPosFirstNode = _map.getXIndex(firstNode);
					delta = 20 - xPosFirstNode;
				}
				else
				{
					delta = 0;
				}
				function fShiftMapComp():void
				{
					//effect con cá di chuyển
					_map.hopFish(numDice, fishMoveComp);
					function fishMoveComp():void
					{
						ExpeditionMgr.getInstance().rollingDice(data);	//tính toán dữ liệu sau khi roll
						//tọa độ con cá
						xActor = _map.getXactor();
						if (xActor >= LENGTH_SCREEN)
						{
							firstNode = ExpeditionMgr.getInstance().Index - 2;
							xPosFirstNode = _map.getXIndex(firstNode);
							delta = xPosFirstNode - 20;
							function fCompleteAutoShift():void
							{
								EndOfRolling();
							}
							_map.AutoShiftMap( -delta, fCompleteAutoShift);//tự động shift map
						}
						else
						{
							EndOfRolling();
						}
					}
				}
				_map.AutoShiftMap(delta, fShiftMapComp);
				
			}
		}
		private function EndOfRolling():void 
		{
			var index:int = ExpeditionMgr.getInstance().Index;
			var silkRoad:Array = ExpeditionMgr.getInstance().getSilkRoad();
			var typeQuest:int = silkRoad[index];
			
			imgIconType.LoadRes("GuiExpedition_Icon" + typeQuest);
			imgTxtType.LoadRes("GuiExpedition_Txt" + typeQuest);
			
			if (typeQuest == 4)//nhảy vào ô khí vận
			{
				GuiMgr.getInstance().guiExpeditionGift.TypeShow = GuiReceiveGiftExpedition.CHANCE;
				GuiMgr.getInstance().guiExpeditionGift.Show(Constant.GUI_MIN_LAYER, 5);
				if (GuiMgr.getInstance().guiExpeditionGift.TypeChance == GuiReceiveGiftExpedition.LUCKY)
				{
					inRolling = false;
				}
			}
			else if (typeQuest % 10 == 0)//nhảy vào ô Rương
			{
				GuiMgr.getInstance().guiExpeditionGift.TypeShow = GuiReceiveGiftExpedition.TRUNK;
				GuiMgr.getInstance().guiExpeditionGift.Show(Constant.GUI_MIN_LAYER, 5);
				inRolling = false;
			}
			else//nhảy vào ô Quest
			{
				/*code cho hiển thị phần thưởng rương viễn chinh nếu có quà từ rương*/
				var giftServer:Array = ExpeditionMgr.getInstance().GiftServer;
				if (giftServer != null && giftServer.length > 0)
				{
					GuiMgr.getInstance().guiExpeditionGift.TypeShow = GuiReceiveGiftExpedition.TRUNK;
					GuiMgr.getInstance().guiExpeditionGift.Show(Constant.GUI_MIN_LAYER, 5);
				}
				goQuestPage();
				inRolling = false;
			}
		}
		private function goQuestPage():void
		{
			setVisible(1, false);
			setVisible(2, true);
			setVisible(3, false);
			var quest:ExQuestInfo = ExpeditionMgr.getInstance().getQuest();
			tfTask.text = quest.Name;
			tfComplete.text = Ultility.StandardNumber(quest.NumTaskComp) + " / " + Ultility.StandardNumber(quest.MaxNumTask);
			var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["CompleteQuick"][quest.HardId.toString()];
			tfPriceCompleteQuick.text = Ultility.StandardNumber(price);
		}
		/**
		 * trường hợp đóng gui xui xẻo lại
		 */
		public function seekBadChance():void 
		{
			var bad:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["Bad"];
			_map.hopFish( -bad, compBad);
			function compBad():void
			{
				ExpeditionMgr.getInstance().Index -= bad;
				var index:int = ExpeditionMgr.getInstance().Index;
				var silkRoad:Array = ExpeditionMgr.getInstance().getSilkRoad();
				var typeQuest:int = silkRoad[index];
				var quest:ExQuestInfo = ExpeditionMgr.getInstance().getQuest();
				quest.Type = typeQuest;
				imgIconType.LoadRes("GuiExpedition_Icon" + typeQuest);
				imgTxtType.LoadRes("GuiExpedition_Txt" + typeQuest);
				
				var xActor:int = _map.getXactor();
				if (xActor < 20)
				{
					var firstNode:int = index - 2;
					var xPosFirstNode:int = Math.abs(_map.getXIndex(firstNode));
					var delta:int = xPosFirstNode + 20;
					_map.AutoShiftMap(delta, CompShift);
					function CompShift():void
					{
						goQuestPage();
						inRolling = false;
					}
				}
				else
				{
					goQuestPage();
					inRolling = false;
				}
			}
		}
		
		public function decreaseHard(data:Object):void 
		{
			ExpeditionMgr.getInstance().decreaseHard(data);
			var quest:ExQuestInfo = ExpeditionMgr.getInstance().getQuest();
			tfTask.text = quest.Name;
			tfComplete.text = Ultility.StandardNumber(quest.NumTaskComp) + " / " + Ultility.StandardNumber(quest.MaxNumTask);
			/*cập nhật ngôi sao*/
			for (var i:int = 1; i <= 5; i++)
			{
				if (ExpeditionMgr.getInstance().getQuest().HardId < i)
				{
					(this["imgStarHard" + i] as Image).img.visible = false;
				}
			}
			var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["CompleteQuick"][quest.HardId.toString()];
			tfPriceCompleteQuick.text = Ultility.StandardNumber(price);
			inUpDown = false;
		}
		
		public function increaseValue(data:Object):void 
		{
			clearListGift();
			ExpeditionMgr.getInstance().increaseValue(data);
			initListGift();
			/*cập nhật ngôi sao*/
			for (var i:int = 1; i <= 5; i++)
			{
				if (ExpeditionMgr.getInstance().Value >= i)
				{
					(this["imgStarValue" + i] as Image).img.visible = true;
				}
			}
			inUpDown = false;
		}
		
		public function completeQuest(data:Object):void 
		{
			ExpeditionMgr.getInstance().initGiftServer(data);
			GuiMgr.getInstance().guiExpeditionGift.TypeShow = GuiReceiveGiftExpedition.QUEST;
			GuiMgr.getInstance().guiExpeditionGift.Show(Constant.GUI_MIN_LAYER, 5);
			inRequestComplete = false;
		}
		
		public function buyCard(data:Object):void 
		{
			//cộng lệnh bài
			ExpeditionMgr.getInstance().NumCard += data.Num;
			//chữ bay lên
			Ultility.flyNumber(data.Num, 680, 595, 680, 542, 4);
			//cập nhật số
			tfNumCard.text = Ultility.StandardNumber(ExpeditionMgr.getInstance().NumCard);
			inBuyCard = false;
		}
		
		override protected function onUpdateGui(curTime:Number):void 
		{
			if (isHoldNext)
			{
				isHoldNext = _map.shiftLeft();
			}
			
			if (isHoldPrev)
			{
				isHoldPrev = _map.shiftRight();
			}
			if (IsInitFinish)
			{
				_map.onUpdateMap();
			}
		}

		override public function OnHideGUI():void 
		{
			//
			//ExpeditionMgr.getInstance().Destructor();
			//
			if (IsInitFinish)
			{
				btnNext.img.removeEventListener(MouseEvent.MOUSE_DOWN, OnBtnNextDown);
				btnNext.img.removeEventListener(MouseEvent.MOUSE_UP, OnBtnNextUp);
				btnPrev.img.removeEventListener(MouseEvent.MOUSE_DOWN, OnBtnPrevDown);
				btnPrev.img.removeEventListener(MouseEvent.MOUSE_UP, OnBtnPrevUp);
				//
				clearListGift();
				//
				_map.Destructor();
			}
			
		}
		
		override public function Clear():void 
		{
			super.Clear();
			btnClose = btnCompQuick = btnDec = btnDice = btnInc = btnNext = btnPrev = null;
			imgDice = imgLineGift = imgLineRequire = imgLineTask = imgTextGift = imgTextRequire = null;
			tfTask = /*tfTipFinish1 = */tfTipFinish2 = tfTipStart = tfComplete = tfPriceCompleteQuick = null;
			imgSpeechBegin = imgSpeechEnd = imgTienCa = null;
		}
		
		public function finishAll():void 
		{
			setVisible(1, false);
			setVisible(2, false);
			setVisible(3, true);
		}
		
		private function initListGift():void
		{
			var oGift:Array = ExpeditionMgr.getInstance().getGift();
			var itGift:AbstractItemGift;
			var gift:AbstractGift;
			var x:int = 245, y:int = 470;
			var i:int;
			_listItemGift.splice(0, _listItemGift.length);
			for (i = 0; i < oGift.length; i++)
			{
				gift = oGift[i];
				itGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "GuiExpedition_ImgSlot", x, y);
				itGift.hasTooltipImg = false;
				itGift.initData(gift, "", 69, 72);
				itGift.yNum = 60;
				itGift.drawGift();
				x += 75;
				_listItemGift.push(itGift);
			}
			for (i = _listItemGift.length; i < 5; i++)
			{
				AddImage(IMG_SLOT_GIFT + "_" + i, "GuiExpedition_ImgSlot", x, y, true, ALIGN_LEFT_TOP);
				x += 75;
			}
		}
		
		private function clearListGift():void
		{
			var i:int;
			
			for (i = _listItemGift.length; i < 5; i++)
			{
				RemoveImage(GetImage(IMG_SLOT_GIFT + "_" + i));
			}
			
			for (i = 0; i < _listItemGift.length; i++)
			{
				var itGift:AbstractItemGift = _listItemGift[i];
				itGift.Destructor();
				itGift = null;
			}
			_listItemGift.splice(0, _listItemGift.length);
		}
	}
}











