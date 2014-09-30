package GUI.EventMidle8 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendAnswerQuestion;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIAnswerQuestion extends BaseGUI 
	{
		//public const MAX_QUESTION:int = 10;
		public const NUM_QUESTION_MAX:int = 5;
		public const NUM_ANSWER_MAX:int = 3;
		public const STATUS_TRUE:int = 1;
		public const COLOR_CHOOSE:int = 0xFF9933;
		public var AllQuestion:Object = new Object();
		public var NowQuestion:Object = new Object();
		public var IdQuest:int = 1;
		public var XuPay:int = 1;
		public var timeStamp:int;
		
		public var StrQuest:String;
		public var arrAnswer:Array = [];
		public var arrAnswerId:Array = [];
		public var arrTextBoxAnswer:Array = [];
		public var arrCtnTickAnswer:Array = [];
		public var idTrueInArrAnswer:int = -1;
		public var idCtnChooseNow:String = "";
				
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_ANSWER_QUESTION:String = "BtnAnswerQuestion";
		public const BTN_ANSWER_FAST:String = "BtnAnswerFast";
		
		public const CTN_ANSWER:String = "CtnAnswer_";
		
		public const IMG_CHOOSE:String = "ImgChooseAnswer";
		
		public function GUIAnswerQuestion(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIAnswerQuestion";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			this.setImgInfo = function():void
			{
				OpenRoomOut();
			}
			LoadRes("GuiAnserQuestion_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			InitData();
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 35, 18, this);
			AddButton(BTN_ANSWER_QUESTION, "GuiAnserQuestion_BtnAnswerQuestion", 407, 400, this);
			AddButton(BTN_ANSWER_FAST, "GuiAnserQuestion_BtnAnswerFast", 240, 400, this);
			var txtGia:TextField = AddLabel(XuPay.toString(), 290, 405, 0x00FF00, 1, 0x000000);
			var txtFormatGia:TextFormat = new TextFormat();
			txtFormatGia.size = 16;
			txtGia.setTextFormat(txtFormatGia);
			
			var start_X:int = 365;
			var start_Y:int = 200;
			var delta_Y:int = 75;
			
			arrCtnTickAnswer = [];
			for (var i:int = 0; i < NUM_ANSWER_MAX; i++) 
			{
				var ctn:Container = AddContainer(CTN_ANSWER + i, "GuiAnserQuestion_CtnSlotAnswerQuestion", start_X, start_Y + i * delta_Y,true, this);
				ctn.AddImage(IMG_CHOOSE, "GuiAnserQuestion_ImgTickedGameMidle8", -ctn.img.width / 2 + 20, 0).img.visible = false;
				arrCtnTickAnswer.push(ctn);
			}
			idCtnChooseNow = CTN_ANSWER + 0;
			GetContainer(idCtnChooseNow).GetImage(IMG_CHOOSE).img.visible = true;
			GetContainer(idCtnChooseNow).SetHighLight(COLOR_CHOOSE);
			
			AddTextBoxQuestion();
			AddTextBoxAnswer();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
					{
						GuiMgr.getInstance().GuiGameTrungThu.Hide();
					}
					Hide();
				break;
				case BTN_ANSWER_FAST:
					AnswerQuestion(true);
				break;
				case BTN_ANSWER_QUESTION:
					AnswerQuestion();
				break;
				default:
					if (buttonID.search(CTN_ANSWER) >= 0)
					{
						ChooseAnswer(buttonID);
					}
				break;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			if (buttonID.search(CTN_ANSWER) >= 0)
			{
				GetContainer(buttonID).SetHighLight();
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonOut(event, buttonID);
			if (buttonID == idCtnChooseNow)
			{
				GetContainer(buttonID).SetHighLight(COLOR_CHOOSE);
				return;
			}
			if (buttonID.search(CTN_ANSWER) >= 0)
			{
				GetContainer(buttonID).SetHighLight(-1);
			}
		}
		
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
			{
				GuiMgr.getInstance().GuiGameTrungThu.ShowBtnArrow();
			}
		}
		public function ProcessDataServerGift(DataNew:Object, DataOld:Object):void 
		{
			GuiMgr.getInstance().GuiGameTrungThu.Question = 0;
			GuiMgr.getInstance().GuiGameTrungThu.RoadState = GuiMgr.getInstance().GuiGameTrungThu.ROAD_STATE_NORMAL;
			Hide();
			if (DataNew.New_Position)	// Nếu trả lời sai thì hiện câu trả lời đúng lên và hiện Eff sai lên
			{
				//GuiMgr.getInstance().GuiGameTrungThu.GotoNewPos(DataNew);
				GuiMgr.getInstance().GuiGameTrungThu.EffTornado(DataNew, DataOld.timeStamp);
			}
			else // Nếu đúng thì hiện eff đúng rồi lên
			{
				var dataGiftElement:Object = new Object();
				for (var iStr:String in DataNew.Gift) 
				{
					dataGiftElement = DataNew.Gift[iStr];
					break;
				}
				var dataServerGift:Object = new Object();
				var idCtnNow:String = GuiMgr.getInstance().GuiGameTrungThu.idCtnLiveNow;
				var Y:int = int(idCtnNow.split("_")[1]);
				var X:int = int(idCtnNow.split("_")[2]);
				dataServerGift.Error = 0;
				dataServerGift.CellStatus = GuiMgr.getInstance().GuiGameTrungThu.CELL_EXP;
				dataServerGift.Gift = new Object();
				dataServerGift.Gift.NormalGift = new Object();
				dataServerGift.New_Posotion = new Object();
				dataServerGift.Gift.NormalGift.ItemType = dataGiftElement.ItemType;
				dataServerGift.Gift.NormalGift.ItemId = dataGiftElement.ItemId;
				//dataServerGift.Gift.NormalGift.Num = NowQuestion.Gift[String(2)].Num;
				dataServerGift.Gift.NormalGift.Num = dataGiftElement.Num;
				dataServerGift.New_Posotion.X = X;
				dataServerGift.New_Posotion.Y = Y;
				GuiMgr.getInstance().GuiGameTrungThu.ProcessDataServerGift(dataServerGift, DataOld.timeStamp);
			}
		}
		/**
		 * Thực hiện hành động cần khi trả lời câu hỏi 
		 * @param	IsQuick
		 */
		public function AnswerQuestion(IsQuick:Boolean = false):void 
		{
			if (IsQuick)
			{
				if (GameLogic.getInstance().user.GetZMoney() < XuPay)
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
			}
			GetButton(BTN_ANSWER_FAST).SetDisable();
			GetButton(BTN_ANSWER_QUESTION).SetDisable();
			var idCtnChoose:int = int(idCtnChooseNow.split("_")[1]);
			if(IsQuick)
			{
				GameLogic.getInstance().user.UpdateUserZMoney( -XuPay);
			}
			var cmd:SendAnswerQuestion = new SendAnswerQuestion(arrAnswerId[idCtnChoose] + 1, IsQuick, timeStamp);
			if(Ultility.CheckDate(timeStamp, GuiMgr.getInstance().GuiGameTrungThu.NUM_TIME_DELAY))
			{
				Exchange.GetInstance().Send(cmd);
			}
			else 
			{
				GuiMgr.getInstance().GuiGameTrungThu.HideOthersGUI();
			}
		}
		/**
		 * Thực hiện xử lý khi user chọn câu trả lời
		 * @param	buttonID
		 */
		public function ChooseAnswer(buttonID:String):void 
		{
			if (buttonID == idCtnChooseNow)	return;
			for (var i:int = 0; i < this.ContainerArr.length; i++) 
			{
				var ctn:Container = this.ContainerArr[i] as Container;
				var txtBox:TextField = arrTextBoxAnswer[i] as TextField;
				
				var format:TextFormat = new TextFormat(null, 15);
				format.align = TextFormatAlign.LEFT;
				
				if (ctn.IdObject != buttonID)
				{
					ctn.GetImage(IMG_CHOOSE).img.visible = false;
					ctn.SetHighLight( -1);
					format.size = 15;
					format.bold = false;
					format.color = 0x096791;
					txtBox.setTextFormat(format);
				}
				else 
				{
					ctn.GetImage(IMG_CHOOSE).img.visible = true;
					idCtnChooseNow = buttonID;
					ctn.SetHighLight(COLOR_CHOOSE);
					format.size = 17;
					format.bold = true;
					format.color = 0x096791;
					txtBox.setTextFormat(format);
				}
			}
		}
		/**
		 * Thực hiện add câu hỏi vào GUI
		 */
		public function AddTextBoxQuestion():void 
		{
			var strQuestion:String = StrQuest + "?";
			if (strQuestion.length > 110)
			{
				strQuestion = strQuestion.substring(0, 110) + " ...";
			}
			var TfMsg:TextField = AddLabel(strQuestion, 155, 235, 0x096791);
			var format:TextFormat = new TextFormat(null, 17);
			format.align = TextFormatAlign.CENTER;
			TfMsg.setTextFormat(format);
			TfMsg.width = 300;
			TfMsg.multiline = true;
			TfMsg.wordWrap = true;
			
			TfMsg.y = 110 - TfMsg.textHeight / 2;
			TfMsg.x = 220;
		}
		/**
		 * Thực hiện add câu trả lời vào GUI
		 */
		public function AddTextBoxAnswer():void 
		{
			var start_X:int = 252;
			var start_Y:int = 190;
			var Delta_Y:int = 75;
			var idChoose:int = idCtnChooseNow.split("_")[1];
			
			for (var i:int = 0; i < arrAnswerId.length; i++) 
			{
				var strAnswer:String = (i + 1).toString() + ". " + arrAnswer[arrAnswerId[i]];
				if (strAnswer.length > 110)
				{
					strAnswer = strAnswer.substring(0, 110) + " ...";
				}
				var TfMsg:TextField = AddLabel(strAnswer, 120, 150, 0x096791);
				var format:TextFormat = new TextFormat(null, 17);
				format.align = TextFormatAlign.LEFT;
				if(i != idChoose)
				{
					format.size = 15;
					format.color = 0x096791;
					format.bold = false;
				}
				else 
				{
					format.size = 17;
					format.bold = true;
					//format.color = 0xFFCC33;
					format.color = 0x096791;
				}
				TfMsg.setTextFormat(format);
				TfMsg.width = 275;
				TfMsg.multiline = true;
				TfMsg.wordWrap = true;
				
				TfMsg.y = start_Y + Delta_Y * i - TfMsg.textHeight / 2 + 10;
				//TfMsg.y = 110 - TfMsg.textHeight / 2;
				TfMsg.x = start_X;
				arrTextBoxAnswer.push(TfMsg);
			}
		}
		
		public function UpdateGui():void 
		{
			
		}
		
		public function InitData():void
		{
			var iStr:String;
			var i:int = 0;
			AllQuestion = ConfigJSON.getInstance().GetItemList("Question");
			NowQuestion = AllQuestion[IdQuest.toString()];
			NowQuestion.type = "Question";
			NowQuestion.Id = IdQuest;
			if (NowQuestion && NowQuestion.XuPay)	XuPay = NowQuestion.XuPay;
			else 
			{
				XuPay = 1;
			}
			StrQuest = Localization.getInstance().getString(NowQuestion.type + "_" + NowQuestion.Id);
			
			var objAnswer:Object = NowQuestion.Answer;
			if (objAnswer == null)	objAnswer = new Object();
			arrAnswer = [];
			arrAnswerId = [];
			arrTextBoxAnswer = [];
			var count:int = 0;
			for (iStr in objAnswer)
			{
				count ++;
				//var strAnswer:String = objAnswer[iStr].Content as String;
				var strAnswer:String = Localization.getInstance().getString("Answer_" + NowQuestion.Id + "_" + count);
				arrAnswer.push(strAnswer);
				if (int(objAnswer[iStr].Status) == STATUS_TRUE)
				{
					idTrueInArrAnswer = arrAnswer.length - 1;
				}
			}
			
			for (i = 0; i < NUM_ANSWER_MAX; i++) 
			{
				var iRand:int;
				do
				{
					iRand = Math.floor(Math.random() * NUM_ANSWER_MAX);
				}
				while(CheckIdInArr(iRand, arrAnswerId))
				arrAnswerId.push(iRand);
			}
			
			for (i = 0; i < arrAnswerId.length; i++) 
			{
				if (idTrueInArrAnswer == arrAnswerId[i])
				{
					idTrueInArrAnswer = i;
					break;
				}
			}
		}
		public function CheckIdInArr(id:int, arr:Array):Boolean
		{
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (id == arr[i])
				{
					return true;
				}
			}
			return false;
		}
	}

}