package GUI.ChampionLeague.GuiLeague 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * GUI nhận 20 ngư lệnh lần đầu tiên trong ngày vào liên đấu.
	 * @author HiepNM2
	 */
	public class GUIDailyGift extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_AGREE:String = "idBtnAgree";
		public var NumCurrent:int = 0;
		public var NumExpired:int = 0;
		public function GUIDailyGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIDailyGift";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addBgr();
			}
			LoadRes("GuiLeagueDailyGift_Theme");
			//addBgr();
		}
		
		private function addBgr():void 
		{
			//var strTip:String = Localization.getInstance().getString("ChampionLeague_TipDailyGift");
			var strTip1:String = "Bạn được tặng @NumAward ngư lệnh có hiệu lực trong ngày";
			//var strTip2:String = "\n và bị trừ @NumLost ngư lệnh hết hiệu lực";
			var numAward:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["GiftToken"];
			strTip1 = strTip1.replace("@NumAward", numAward);
			//if (NumExpired > 0)
			//{
				//strTip2 = strTip2.replace("@NumLost", NumExpired);
			//}
			//else 
			//{
				//strTip2 = "";
			//}
			
			var fm:TextFormat = new TextFormat("Arial", 12);
			fm.align = TextFormatAlign.CENTER;
			var tfTip:TextField = AddLabel(strTip1 /*+ strTip2*/, 180, 80);
			tfTip.setTextFormat(fm);
			//AddImage("", "GuiLeagueDailyGift_Tip", 43, 64, true, ALIGN_LEFT_TOP);
			AddImage("", "GuiLeagueDailyGift_ImgCard", 182, 120, true, ALIGN_LEFT_TOP);
			AddLabel("x" + numAward, 162, 186,0xffffff,1,0x000000);
			AddButton(ID_BTN_CLOSE, "BtnThoat", 371, 16);
			AddButton(ID_BTN_AGREE, "GuiLeagueDailyGift_BtnAgree", 163, 213);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_AGREE:
				case ID_BTN_CLOSE:
					receiveCard();
					Hide();
				break;
			}
		}
		
		private function receiveCard():void 
		{
			trace("Nhận Card khi vào liên đấu lần đầu tiên trong ngày");
			
			var user:User = GameLogic.getInstance().user;
			var beforeNumCard:int = user.GetStoreItemCount("OccupyToken", 1);
			LeagueMgr.getInstance().NumCard = NumCurrent;
			user.UpdateStockThing("OccupyToken", 1, NumCurrent - beforeNumCard);
			LeagueInterface.getInstance().guiRank.tfNumCard.text = Ultility.StandardNumber(NumCurrent);
			LeagueMgr.getInstance().receivedCard = true;
		}
	}
}






















