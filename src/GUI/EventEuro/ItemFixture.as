package GUI.EventEuro 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	import GUI.EventEuro.Packet.SendRecieveGiftEuro;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemFixture extends Container 
	{
		private var predictType:String;//Loai cuoc
		private var numBall:int;//So bong cuoc
		private var betTimeBegin:Number;
		public var prediction:int;//Du doan 1, 2, 3 thang hoa thang
		public var isWin:Boolean = true;
		public var matchType:String;
		public var dataFixture:Object;
		static public const BTN_PREDICT:String = "btnPredict";
		static public const PREDICTION_A:int = 1;
		static public const PREDICTION_DRAW:int = 2;
		static public const PREDICTION_B:int = 3;
		static public const BTN_GET_GIFT:String = "btnGetGift";
		static public const CTN_GIFT:String = "ctnGift";
		static public const IC_COMPLETE:String = "icComplete";
		static public const IC_PREDICTED:String = "icPredicted";
		static public const IC_VS:String = "icVs";
		static public const IC_TEAM_A:String = "icTeamA";
		static public const IC_TEAM_B:String = "icTeamB";
		static public const MATCH_TYPE_BOARD:String = "BOARD";
		static public const MATCH_TYPE_QUAD:String = "QUAD";
		static public const MATCH_TYPE_SEMI:String = "SEMI";
		static public const MATCH_TYPE_FINAL:String = "FINAL";
		public var teamA:String;
		public var teamB:String;
		public var day:String;
		public var time:String;
		public var numStar:int;
		public var matchId:int;
		public var matchTimeBegin:Number;
		
		public function ItemFixture(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
		}
		
		public function initFixture(_mathId:int, _data:Object):void
		{
			LoadRes("");
			matchId = _mathId;
			dataFixture = _data;
			teamA = _data["Team1"];
			teamB = _data["Team2"];
			day = Ultility.convertTimeToDate(_data["MatchTimeBegin"], true, false);
			time = Ultility.convertTimeToDate(_data["MatchTimeBegin"], false, true);
			numStar = _data["Star"];
			matchType = _data["MatchType"];
			matchTimeBegin = _data["MatchTimeBegin"];
			betTimeBegin = _data["BetTimeBegin"];
			
			var txtFormat:TextFormat = new TextFormat("arial", 12, 0xffffff);
			txtFormat.align = "center";
			AddLabel(day, 0, 47, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			txtFormat.size =30;
			AddLabel(time, 1, 75, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			//var nameMatch:String;
			switch(matchType)
			{
				case MATCH_TYPE_BOARD:
					//txtFormat.size = 20;
					//txtFormat.color = 0xffffff;
					//nameMatch = "Vòng Bảng";
					AddImage("", "Effect_Board", 42, 20, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);// .FitRect(125, 45, new Point(0, 0));
					break;
				case MATCH_TYPE_QUAD:
					//txtFormat.size = 22;
					//txtFormat.color = 0x00ffff;
					//nameMatch = "Tứ Kết";
					AddImage("", "Effect_Quad", 0, 10, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);// .FitRect(125, 45, new Point(0, 0));
					break;
				case MATCH_TYPE_SEMI:
					//txtFormat.size = 24;
					//txtFormat.color = 0xffff00;
					//nameMatch = "Bán Kết";
					AddImage("", "Effect_Semi", 0, 10, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);// .FitRect(125, 45, new Point(0, 0));
					break;
				case MATCH_TYPE_FINAL:
					//txtFormat.size = 25;
					//txtFormat.color = 0xff0000;
					//nameMatch = "Chung Kết";
					AddImage("", "Effect_Final", 0, -10, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);// .FitRect(125, 45, new Point(0, 0));
					break;
			}
			//AddLabel(nameMatch, 0, 5, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			txtFormat.color = 0xffffff;
			txtFormat.size = 18;
			var teamAName:String = Localization.getInstance().getString(teamA);
			var teamBName:String = Localization.getInstance().getString(teamB);
			AddLabel(teamAName, 160 - 42, 22, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			AddLabel(teamBName, 370 + 13, 22, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			AddImage(IC_TEAM_A, "Flag_" + teamA, 157, 78);
			AddImage("", "Effect_Flag", 227, 123).GoToAndPlay(15 + Math.random()*60);
			AddImage(IC_VS, "Ic_VS", 360, 100);
			AddImage(IC_TEAM_B, "Flag_" + teamB, 428, 78);
			AddImage("", "Effect_Flag", 498,123).GoToAndPlay(15 + Math.random()*60);
			txtFormat.size = 20;
			AddImage(IC_COMPLETE + PREDICTION_A, "GuiEventEuro_IcWin", 210 - 23, 140).img.visible = false;
			AddImage(IC_COMPLETE + PREDICTION_DRAW, "GuiEventEuro_IcDraw", 300, 135).img.visible = false;
			AddImage(IC_COMPLETE + PREDICTION_B, "GuiEventEuro_IcWin", 406, 140).img.visible = false;
					
			var x00:int = 235;// - 30 * numStar / 2;
			var dxx:int = 30;
			for (var i:int = 0; i < 5; i++)
			{
				if(i < numStar)
				{
					AddImage("", "Ic_Star", x00 + dxx * i, 10, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);
				}
				else
				{
					AddImage("", "Ic_DarkStar", x00 + dxx * i, 10, true, ALIGN_LEFT_TOP).SetScaleXY(0.7);
				}
			}
			
			AddButton(BTN_PREDICT, "GuiEventEuro_BtnPredict", 500, 63);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_PREDICT:
					var curServerTime:Number = GameLogic.getInstance().CurServerTime;
					trace(curServerTime, betTimeBegin);
					//Chua den thoi gian cuoc
					if (curServerTime < betTimeBegin)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Dự đoán bắt đầu mở vào lúc\n" + Ultility.convertTimeToDate(betTimeBegin, true, true));
					}else
					//Trận đấu đã bắt đầu
					if (curServerTime > matchTimeBegin)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể cược vì trận đấu đã bắt đầu!");
					}
					else
					{
						GuiMgr.getInstance().guiEventEuro.img.visible = false;
						GuiMgr.getInstance().guiPrediction.showGUI(this);
					}
					break;
				case BTN_GET_GIFT:
					GetButton(BTN_GET_GIFT).SetEnable(false);
					GuiMgr.getInstance().guiEventEuro.setGotGift(dataFixture);
					GuiMgr.getInstance().guiEventEuro.refreshGUI();
					GuiMgr.getInstance().guiEventEuro.showTab(GUIEventEuro.BTN_TAB_PREDICTION);
					Exchange.GetInstance().Send(new SendRecieveGiftEuro("Bet", matchId, 0));
					var levelGift:int = GUIPrediction.getGiftLevel(predictType, numStar, numBall);
					var feedType:String  = "EventEuro4";
					if (!isWin)
					{
						feedType = "";
					}
					GuiMgr.getInstance().guiEuroRewards.showGUI("TrunkGift" + levelGift, this, feedType);
					break;
					
			}
		}
		
		public function setPrediction(predict:int, level:int, predictType:String):void
		{
			this.predictType = predictType;
			this.numBall = level;
			this.prediction = predict;
			var glow:GlowFilter;
			switch(predict)
			{
				case PREDICTION_A:
					GetImage(IC_COMPLETE +PREDICTION_A).img.visible = true;
					glow = new GlowFilter(0xffff00, 1, 4, 4, 8);
					GetImage(IC_TEAM_A).img.filters = [glow];
					break;
				case PREDICTION_B:
					GetImage(IC_COMPLETE +PREDICTION_B).img.visible = true;
					glow = new GlowFilter(0xffff00, 1, 4, 4, 8);
					GetImage(IC_TEAM_B).img.filters = [glow];
					break;
				case PREDICTION_DRAW:
					GetImage(IC_COMPLETE +PREDICTION_DRAW).img.visible = true;
					break;
			}
			
			AddContainer(CTN_GIFT, "GuiEventEuro_TxtBg", 567 - 82, 35, true, this);
			
			var txtFormat:TextFormat = new TextFormat("arial", 16, 0xffffff, true);
			AddLabel(Ultility.StandardNumber(level), 453 + 66, 45, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
			if (predictType == "ORD")
			{
				AddImage("", "Ic_ORDBall", 531, 87).FitRect(35, 35, new Point(531 - 50, 87 - 50));
			}
			else
			{
				AddImage("", "Ic_VIPBall", 531, 87).FitRect(35, 35, new Point(531 - 50, 87 - 50));
			}
			GetButton(BTN_PREDICT).SetVisible(false);
			AddImage(IC_PREDICTED, "GuiEventEuro_IcPredicted", 485, 84, true, ALIGN_LEFT_TOP);
		}
		
		public function setResult(aGoal:int, bGoal:int, penalty:Boolean = false):void 
		{
			//GetImage(IC_VS).img.visible = false;
			//AddImage("", "Number_" + aGoal, 269, 66).FitRect(38, 38, new Point(269 - 34, 64));
			//AddImage("", "Ic_Line", 304, 66);
			//AddImage("", "Number_" + bGoal, 339, 66).FitRect(38, 38, new Point(339 - 16, 64));
			
			var txtFormat:TextFormat = new TextFormat("arial", 30, 0xffffff, true);
			AddLabel(aGoal.toString(), 200, 64).setTextFormat(txtFormat);
			AddLabel(bGoal.toString(), 293, 64).setTextFormat(txtFormat);
			if (penalty)
			{
				AddLabel("(Penalty)", 253, 34, 0xffffff, 1, 0x000000);
			}
		}
		
		public function setGift(isWin:Boolean):void
		{
			this.isWin = isWin;
			if (isWin)
			{
				//AddImage("", "GuiEventEuro_IcTrue", 311, 18);
			}
			else
			{
				//AddImage("", "GuiEventEuro_IcFalse", 311, 18);
				//AddImage("", "IcExp", 498 + 107, 54);
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Phần thưởng an ủi(kinh nghiệm)";
				GetContainer(CTN_GIFT).setTooltip(tooltip);
			}
			AddButton(BTN_GET_GIFT, "BtnNhanThuong", 486, 83, this);
			GetImage(IC_PREDICTED).img.visible = false;
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_GIFT) >= 0 && isWin)
			{
				var level:int = GUIPrediction.getGiftLevel(predictType, numStar, numBall);
				var configGift:Object = ConfigJSON.getInstance().GetItemList("EventEuro_BetGifts")[predictType][level][numStar][1];
				GuiMgr.getInstance().guiGiftTooltip.showGUI(event.stageX, event.stageY, configGift);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_GIFT) >= 0)
			{
				GuiMgr.getInstance().guiGiftTooltip.Hide();
			}
		}
	}

}