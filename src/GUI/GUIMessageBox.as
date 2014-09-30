package GUI 
{
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Event.EventMidAutumn.EventPackage.SendGetEventInfo;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.Mail.SystemMail.Controller.MailMgr;
	import Logic.EventNationalCelebration.FireworkFish;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.FishSpartan;
	import Logic.GameLogic;
	import Logic.Lake;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendUnlockSlotMaterial;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIMessageBox extends BaseGUI
	{
		public static const MSGBOX_OK:String = "0";
		public static const MSGBOX_CANCEL:String = "1";
		public static const MSGBOX_NOTHING:String = "nothing";
		public static const MSGBOX_LINK_SHOP:String = "LinkShop";
		public static const MSGBOX_DEL_EQUIP:String = "DelEquip";
		public static const MSGBOX_TB_ID:String = "InputUid";
		public static const MSGBOX_BUY_GOLD:String = "btnGold";
		public static const MSGBOX_BUY_ZXU:String = "btnXu";
		
		//NPC ID
		public static const NPC_OCTOPUS:int = 0;
		public static const NPC_MERMAID_NORMAL:int = 1;
		public static const NPC_MERMAID_WAR:int = 2;
		
		//State back in world
		public static const STATE_BACK_HOME:int = 1;
		public static const STATE_BACK_MAP:int = 0;
		
		// Msgbox feed
		public static const MSGBOX_FEED:String = "LinkFeed"; 
		public static const MSGBOX_FEED_UNLOCK_LAKE: String = "FeedUnlockLake";
		// Msgbox time out
		public static const MSGBOX_RELOAD:String = "Reload";
		
		// Msgbox buy mix fish
		public static const MSGBOX_INVENTORY:String = "Inventory";
		// Msgbox Ep nguyen lieu
		public static const MSGBOX_RAW_MATERIAL:String = "RawMaterial";
		
		// Msgbox confirm co play nhanh khong
		public static const MSGBOX_CONFIRM_PLAY_FAST:String = "PlayFastGame";
		
		// Msgbox confirm sell small fish
		public static const MSGBOX_CLOSE:String = "SellCancel";
		public static const MSGBOX_CONFIRM_SELL:String = "SellFish";
		public static const MSGBOX_CONFIRM_SELL_SPARTAN:String = "SellFishSpartan";
		public static const MSGBOX_CONFIRM_SELL_FIREWORK_FISH:String = "SellFishFireworkFish";
		private var SellFishSpartan:FishSpartan;
		private var SellFish:Fish;
		
		// Msgbox confirm sell small fish
		public var itemIdBgr:int = 0;
		
		//Msgbox cheat ID
		public var TextboxId:TextBox = new TextBox("b", 10, 10, 20, 20) ;
		public static const MSGBOX_OK_CHEAT:String = "OkCheat";
		
		//Msgbox confirm get DailyBonus
		public static const MSGBOX_OK_GET_DAILYBONUS:String = "OkGetDailyBonus";
		
		//Msgbox confirm get LuckyMachine
		public static const MSGBOX_OK_GET_LUCKYMACHINE:String = "OkGetLuckyMachine";
		
		//Msgbox get ticket auto in LuckyMachine
		public static const MSGBOX_OK_GET_TICKET_AUTO:String = "OkGetTicketAutoLuckyMachine";
		//MsgBox fishwar
		public static const MSGBOX_ERROR_FISHWAR_GO_HOME:String = "ErrorFishWarGoHome";
		public static const MSGBOX_ERROR_FISHWAR_REFRESH:String = "ErrorFishWarRefresh";
		
		//MsgBox fishworld
		public static const MSGBOX_CONFIRM_BACK_MAP:String = "MsgBoxConfirmBackMap";
		public static const MSGBOX_ERROR_FISHWORLD_REFRESH:String = "ErrorFishWorldRefresh";
		
		public static const MSGBOX_FISHWORLD_BACK_HOME:String = "FishWorldBackHome";
		public static const MSGBOX_FISHWORLD_BACK_MAP:String = "FishWorldBackMap";
		
		//Msgbox delete all mail
		public static const MSGBOX_OK_DELETE:String = "DeleteAllMailOk";
		public static const MSGBOX_CANCEL_DELETE:String = "DeleteAllMailCancel";
		
		//Msgbox delete system mail
		public static const MSGBOX_OK_DELETE_SYSTEM_MAIL:String = "DeleteSystemMailOk";
		public static const MSGBOX_CANCEL_DELETE_SYSTEM_MAIL:String = "DeleteSystemMailCancel";
		private const MSGBOX_CANCEL_STOP_TRAINING:String = "msgboxCancelStopTraining";
		private const MSGBOX_OK_STOP_TRAINING:String = "msgboxOkStopTraining";
		public var idSystemMail:int;
		
		public var FeedType:String;
		
		// Store MixLake Name for use in feed form
		public var MixLakeName:String;
		private var slotUnlock:int;
		
		// Store TargetLake for use in feed form
		public var TargetLake:Lake;
		
		private var Msg:String = "";
		private var IsOK:Boolean = true;
		private var IsCancel:Boolean = true;
		private var X: int;
		private var Y: int;
		private var TfAgree:TextField;
		private var TfMsg:TextField;
		private var NPCType:int = 0;
		public var inReload:Boolean = false;
		public function GUIMessageBox(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMessageBox";
		}
		
		public function ShowOK(msg:String, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = true;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		private var callFunc:Function;
		
		public function ShowOkCancel(msg:String,x: int = 310, y: int = 200, NPC:int = 0, f:Function = null):void
		{
			Msg = msg;
			IsOK = true;
			callFunc = f;
			IsCancel = true;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);		
		}
		
		public function ShowOkShop(msg:String,x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			//TfMsg.y = 50;
			
			//var buttonGreen:Button = AddButton(MSGBOX_LINK_SHOP_, "Btngreen", 170, 219, this);
			//buttonGreen.img.scaleX = 100;
			//buttonGreen.img.scaleY = 38;
			//AddLabel("Cửa hàng", 177, 192, 0x000000, 0);
			
			var button:Button = AddButton(MSGBOX_LINK_SHOP, "BtnGotoShop", 85, 165, this);			
			//button = GetButton(MSGBOX_OK);			
			button.SetPos(85, 165);
			//button.img.width = 100;
			//button.img.height = 38;			
			//TfAgree.x = 72;
			//TfAgree.y = 176;
			//TfAgree.scaleX = TfAgree.scaleY = 1.3;
		}
		
		public function ShowOkCancelDelEquip(msg:String, x:int = 310, y:int = 200, NPC:int = NPC_MERMAID_WAR):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			
			var btnGet: Button = AddButton(MSGBOX_DEL_EQUIP, "BtnRed",65, 207, this);
			btnGet.img.width = 100;
			btnGet.img.height = 38;
			TfAgree = AddLabel("Hủy", 92, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
			
			var btnCancel: Button = AddButton(MSGBOX_CANCEL, "Btngreen", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Quay lại", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
		
		public function ShowBuySlotMaterial(level:int, NPC:int = 0):void
		{
			IsOK = false;
			IsCancel = false;
			X = 310;
			Y = 170;
			NPCType = NPC;
			slotUnlock = level;
			var obj:Object = ConfigJSON.getInstance().getItemInfo("LevelUnlockSlot", level);
			var gold:int = obj.Money;
			var zxu:int = obj.ZMoney;
			Msg = Localization.getInstance().getString("GUILabel34");			
			super.Show(Constant.GUI_MIN_LAYER, 3);		
			
			var btnGold:Button = AddButton(MSGBOX_BUY_GOLD, "BtnBuyGold", 80, 170, this);
			var btnZXu:Button = AddButton(MSGBOX_BUY_ZXU, "BtnBuyXu", 185, 170, this);
			if (gold <= 0 || gold > GameLogic.getInstance().user.GetMoney())
			{
				btnGold.SetEnable(false);
			}
			if (zxu <= 0 || zxu > GameLogic.getInstance().user.GetZMoney())
			{
				btnZXu.SetEnable(false);
			}
			//AddImage("", "IcGold", 80, 140, true, ALIGN_LEFT_TOP);
			//AddImage("", "IcZingXu", 185, 140, true, ALIGN_LEFT_TOP);
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 14;
			AddLabel(Ultility.StandardNumber(gold), 90, 170, 0x966904, 0, 0xffffff).setTextFormat(txtFormat);
			AddLabel(Ultility.StandardNumber(zxu), 200, 170, 0x966904, 0, 0xffffff).setTextFormat(txtFormat);
			//AddLabel(Ultility.StandardNumber(gold), 107, 142, 0x966904, 0, 0xffffff).setTextFormat(txtFormat);
			//AddLabel(Ultility.StandardNumber(zxu), 212, 142, 0x966904, 0, 0xffffff).setTextFormat(txtFormat);
			
			if (gold > GameLogic.getInstance().user.GetMoney() && zxu > GameLogic.getInstance().user.GetZMoney())
			{
				var warning:TextField = AddLabel(Localization.getInstance().getString("Message16"), 105, 68, 0xff0000);
				var format:TextFormat = new TextFormat();
				format.size = 16;
				format.bold = true;
				warning.setTextFormat(format);
			}		
		}
		
		public function ShowConfirmSellFish(fish:Fish, msg:String, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			
			var button:Button = AddButton(MSGBOX_CONFIRM_SELL, "BtnRed", 90, 207, this);
			button.img.width = 75;
			button.img.height = 30;
			AddLabel( Localization.getInstance().getString("GUILabel29"), 96, 183, 0xffffff, 0);
			
			var CloseButton:Button = AddButton(MSGBOX_CLOSE , "Btngreen", 180, 207, this);
			AddLabel( Localization.getInstance().getString("GUILabel30"), 184, 183, 0xffffff, 0);		
			CloseButton.img.width = 75;
			CloseButton.img.height = 30;
			
			SellFish = fish;
		}
		public function ShowConfirmFastPlay(msg:String, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			
			var button:Button = AddButton(MSGBOX_CLOSE, "BtnRed", 90, 207, this);
			button.img.width = 75;
			button.img.height = 30;
			AddLabel("Quay lại", 96, 183, 0xffffff, 0);
			
			var CloseButton:Button = AddButton(MSGBOX_CONFIRM_PLAY_FAST , "Btngreen", 180, 207, this);
			AddLabel("Đồng ý", 184, 183, 0xffffff, 0);	
			CloseButton.img.width = 75;
			CloseButton.img.height = 30;
		}
		
		public function ShowConfirmSellFishSpartan(fish:FishSpartan, msg:String, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			
			var button:Button = AddButton(MSGBOX_CLOSE , "BtnRed", 90, 207, this);
			button.img.width = 75;
			button.img.height = 30;
			AddLabel( Localization.getInstance().getString("GUILabel30"), 96, 183, 0xffffff, 0);
			
			var CloseButton:Button = AddButton(MSGBOX_CONFIRM_SELL_SPARTAN, "Btngreen", 180, 207, this);
			AddLabel( Localization.getInstance().getString("GUILabel29"), 184, 183, 0xffffff, 0);	
			CloseButton.img.width = 75;
			CloseButton.img.height = 30;
			
			SellFishSpartan = fish;
		}
		
		public function showConfirmSellFireworFish(fish:FireworkFish, msg:String, x: int = 310, y: int = 200, NPC:Boolean = true):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPCType;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			
			var button:Button = AddButton(MSGBOX_CONFIRM_SELL_FIREWORK_FISH, "BtnRed", 90, 207, this);
			button.img.width = 75;
			button.img.height = 30;
			AddLabel( Localization.getInstance().getString("GUILabel29"), 96, 183, 0xffffff, 0);
			
			var CloseButton:Button = AddButton(MSGBOX_CLOSE , "Btngreen", 180, 207, this);
			AddLabel( Localization.getInstance().getString("GUILabel30"), 184, 183, 0xffffff, 0);	
			CloseButton.img.width = 75;
			CloseButton.img.height = 30;
			
			this.SellFish = fish;
		}
		
		public function ShowFeedUpgradeLake(msg:String, lake:Lake, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			FeedType = GUIFeedWall.FEED_TYPE_UPGRADE_TANK;
			
			TargetLake = lake;
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			
			var btnOK: Button = AddButton(MSGBOX_FEED, "Btngreen",65, 207, this);
			btnOK.img.width = 100;
			btnOK.img.height = 38;
			TfAgree = AddLabel("Chia sẻ", 82, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
				
			var btnCancel: Button = AddButton(MSGBOX_CANCEL, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Hủy bỏ", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
		
		public function ShowReload(msg:String,x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			var button:Button = AddButton(MSGBOX_RELOAD, "Btngreen", 123, 207, this);	
			//button.img.scaleX = 1.55;
			//button.img.scaleY = 1.35;
			button.img.width = 75;
			button.img.height = 30;
			AddLabel("Đồng ý", 136, 183, 0x000000, 0);
		}
		
		public function ShowGoToInventory(name:String, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = "";
			var st:String = Localization.getInstance().getString("Message22");
			var index:int = st.indexOf("@FishName");
			var bef:String = st.substring(0, index);
			var aft:String = st.substring(bef.length + "@FishName".length);
			st = bef.concat(name, aft);
			ShowOK(st);
		}
		
		public function ShowInputUid():void
		{
			X = 350;
			Y = 200;
			IsOK = false;
			IsCancel = false;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			//if (isPaul)
			//{
				//AddImage("", "Paul", 47, 190);
			//}
			//else
			//{
				//AddImage("", "TienCa", 35, 190);
			//}
			TextboxId = AddTextBox(MSGBOX_TB_ID, "22969454", 55, 25, 120, 20, this);
			var txtFormat:TextFormat = new TextFormat("Arial", 14, 0x000000);			
			TextboxId.SetTextFormat(txtFormat);
			var button:Button = AddButton(MSGBOX_OK_CHEAT, "Btngreen", 123, 207, this);	
			//button.img.scaleX = 1.55;
			//button.img.scaleY = 1.35;
			button.img.width = 75;
			button.img.height = 30;
			AddLabel("Đồng ý", 136, 183, 0x000000, 0);			
		}
		
		/**
		 * Show feed unlock hồ mới!
		 * @param	msg
		 * @param	lake
		 * @param	x
		 * @param	y
		 */
		public function ShowFeedUnlockLake(msg:String, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			FeedType = GUIFeedWall.FEED_TYPE_UNLOCK_LAKE;
			
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 2);
			var btnOK: Button = AddButton(MSGBOX_FEED_UNLOCK_LAKE, "Btngreen",65, 207, this);
			btnOK.img.width = 100;
			btnOK.img.height = 38;
			TfAgree = AddLabel("Chia sẻ", 82, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
				
			var btnCancel: Button = AddButton(MSGBOX_CANCEL, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Hủy bỏ", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
			
		}		
		
		public function ShowInTournament(timeRemain:int, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			var minute:int = timeRemain / 60;
			var second:int = timeRemain - minute * 60;
			Msg = "Hãy thoát khỏi lôi đài hoặc \nvào lại sau " + minute + " phút " + second + " giây nữa nhé";
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 10);
			AddButton(MSGBOX_NOTHING, "BtnThoat", 278, -65, null);
		}
		
		public function ShowConfirmGetDailyBonus(msg:String, x: int = 310, y: int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			var btnGet: Button = AddButton(MSGBOX_OK_GET_DAILYBONUS, "Btngreen",65, 207, this);
			btnGet.img.width = 100;
			btnGet.img.height = 38;
			TfAgree = AddLabel("Nhận", 92, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
			
			var btnCancel: Button = AddButton(MSGBOX_CANCEL, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Quay lại", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
		public function ShowConfirmGetLuckyMachine(msg:String, x:int = 310, y:int = 200, NPC:int = 0):void
		{
			//GuiMgr.getInstance().guiDigritWheel.isShowMsgBox = true;
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			var btnGet: Button = AddButton(MSGBOX_OK_GET_LUCKYMACHINE, "Btngreen",55, 207, this);
			btnGet.img.width = 120;
			btnGet.img.height = 38;
			TfAgree = AddLabel("Nhận thưởng", 57, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
			
			var btnCancel: Button = AddButton(MSGBOX_CANCEL, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Quay tiếp", 185, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
		public function ShowTicketOff(msg:String, x:int = 310, y:int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			var btnCancel: Button = AddButton(MSGBOX_CANCEL, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Đóng", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
		
		public function ShowReceiveTicketAuto(msg:String, x:int = 590, y:int = 340, NPC:int = 1):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.ACTIVE_LAYER, 3);
			
			var btnGet: Button = AddButton(MSGBOX_OK_GET_TICKET_AUTO, "Btngreen",105, 207, this);
			btnGet.img.width = 100;
			btnGet.img.height = 38;
			TfAgree = AddLabel("Đóng", 132, 117, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
		};
		public function ShowGuideFishWorld(msg:String, x: int = 310, y: int = 200, NPC:int = 2, stateBack:int = 0):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			var idButtonAdd:String;
			var nameButtonAdd:String;
			var xLabel:int = 115;
			var yLabel:int = 117;
			switch (stateBack) 
			{
				case STATE_BACK_HOME:
					idButtonAdd = MSGBOX_FISHWORLD_BACK_HOME;
					nameButtonAdd = "Về trại cá";
				break;
				case STATE_BACK_MAP:
					xLabel = 100;
					yLabel = 177;
					idButtonAdd = MSGBOX_FISHWORLD_BACK_MAP;
					nameButtonAdd = "Về bản đồ";
				break;
			}
			AddButton(idButtonAdd, "Btngreen", 95, 209, this);
			var tF:TextField = AddLabel(nameButtonAdd, xLabel, yLabel, 0xffffff, 0);
			tF.scaleX = tF.scaleY = 1.5;
		}
		
		public function ShowGuideFishWorldConfirm(msg:String, nameBtn:String = "Về Trại cá", x: int = 310, y: int = 200, NPC:int = 2):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			AddButton(MSGBOX_CONFIRM_BACK_MAP, "BtnRed", 90, 209, this);
			var tF:TextField = AddLabel(nameBtn, 110, 177, 0xffffff, 0);
			tF.scaleX = tF.scaleY = 1.5;
		}
		
		public function ShowGuideFishWar(msg:String, x: int = 310, y: int = 200, NPC:int = 2, isBackToHome:Boolean = true):void
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			if (isBackToHome)
			{
				AddButton(MSGBOX_ERROR_FISHWAR_GO_HOME, "BtnVeTraiCa", 65, 197, this);
			}
			else
			{
				AddButton(MSGBOX_ERROR_FISHWAR_REFRESH, "Btngreen", 95, 209, this);
				var tF:TextField = AddLabel("Tải lại", 115, 177, 0xffffff, 0);
				tF.scaleX = tF.scaleY = 1.5;
			}
		}
		
		public function ShowDeleteAllMail(msg:String, x:int = 310, y:int = 200, NPC:int = 0):void
		{
			Msg = msg;
			IsOK = true;
			IsCancel = true;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			var btnOK: Button = AddButton(MSGBOX_OK_DELETE, "Btngreen",65, 207, this);
			btnOK.img.width = 100;
			btnOK.img.height = 38;
			TfAgree = AddLabel("Đồng ý", 82, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
			
			var btnCancel: Button = AddButton(MSGBOX_CANCEL_DELETE, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Hủy bỏ", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
		public function ShowDeleteSystemMail(msg:String, idSysMail:int, x:int = 310, y:int = 200, NPC:int = 1):void
		{
			idSystemMail = idSysMail;
			Msg = msg;
			IsOK = true;
			IsCancel = true;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			var btnOK: Button = AddButton(MSGBOX_OK_DELETE_SYSTEM_MAIL, "Btngreen",65, 207, this);
			btnOK.img.width = 100;
			btnOK.img.height = 38;
			TfAgree = AddLabel("Đồng ý", 82, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
			
			var btnCancel: Button = AddButton(MSGBOX_CANCEL_DELETE_SYSTEM_MAIL, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Hủy bỏ", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
		public override function InitGUI() :void
		{
			LoadRes("ImgFrameFriend");
			//var imgF: Image = AddImage("", "Gui_ThongBao", 90, 95);			
			var imgF: Image = AddImage("", "ImgBgGUIMessage", 90, 95);			
		
			//if (NPCType)
			//{
				//AddImage("", "ImgPaul", 52, 235);
			//}
			//else
			//{
				//AddImage("", "NPC_Mermaid_New", 75, 395);				
			//}
			//
			switch (NPCType)
			{
				case NPC_OCTOPUS:
					AddImage("", "NPC_Paul", 52, 235);
					break;
				case NPC_MERMAID_NORMAL:
					AddImage("", "NPC_Mermaid_New", 75, 395);	
					break;
				case NPC_MERMAID_WAR:
					var imgg:Image = AddImage("", "NPC_Mermaid_War", -80, 20, true, ALIGN_LEFT_TOP)
					imgg.img.scaleX = imgg.img.scaleY = 0.7;
					break;
			}
			
			//imgF.SetScaleX(1.4);
			//imgF.SetScaleY(1.4);
			//imgF.SetSize(340, 290);
			//var txtFormat: TextFormat = new TextFormat("Arial", 15, 0x000000, true);
		//	var lbl1: TextField = AddLabel("Thông báo", 80, 3);
			//lbl1.setTextFormat(txtFormat);
		
			var button:Button = AddButton(MSGBOX_CANCEL, "BtnThoat", 278, -65, this);
			//button.img.scaleX = button.img.scaleY = 0.7;
			if (IsOK && IsCancel)
			{
			//	AddButton(MSGBOX_OK, "ButtonOK", 50, 250, this);
				var btnOK: Button = AddButton(MSGBOX_OK, "Btngreen",65, 207, this);
				btnOK.img.width = 100;
				btnOK.img.height = 38;
				TfAgree = AddLabel("Đồng ý", 82, 177, 0x000000, 0);
				TfAgree.scaleX = TfAgree.scaleY = 1.3;
				
				var btnCancel: Button = AddButton(MSGBOX_CANCEL, "BtnRed", 175, 207, this);
				btnCancel.img.width = 100;
				btnCancel.img.height = 38;
				var tf1:TextField = AddLabel("Hủy bỏ", 192, 177, 0x000000, 0);
				tf1.scaleX = tf1.scaleY = 1.3;
				//AddButton(MSGBOX_CANCEL, "ButtonCancel", 140, 250, this);
			}
			else if (IsOK && !IsCancel)
			{
				//AddButton(MSGBOX_OK, "ButtonOK", 95, 250, this);
				btnOK = AddButton(MSGBOX_OK, "Btngreen", 170, 207, this);
				btnOK.img.width = 100;
				btnOK.img.height = 38;
				TfAgree = AddLabel("Đồng ý", 187, 177, 0x000000, 0);
				TfAgree.scaleX = TfAgree.scaleY = 1.3;
			}
			
			TfMsg = AddLabel(Msg, 120, 150);
			var format:TextFormat = new TextFormat(null, 16);
			format.align = TextFormatAlign.CENTER;
			TfMsg.setTextFormat(format);
			TfMsg.width = 250;
			TfMsg.multiline = true;
			TfMsg.wordWrap = true;
			
			TfMsg.y = (96 - TfMsg.textHeight) / 2;
			TfMsg.x = 35;
			
			SetPos(X,Y);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			var ImageNameFeed:String;
			switch(buttonID)
			{
				case MSGBOX_OK_GET_DAILYBONUS:
					GuiMgr.getInstance().GuiDailyBonus.processGetGift();
					break;
				case MSGBOX_OK_GET_LUCKYMACHINE:
					GuiMgr.getInstance().guiDigitWheel.disBtnInRevState();
					GuiMgr.getInstance().guiDigitWheel.receiveAvril("Gift");
					//GuiMgr.getInstance().guiDigritWheel.isFirstClick = false;
					break;
				case MSGBOX_OK_GET_TICKET_AUTO:
					break;
				case MSGBOX_DEL_EQUIP:
					GuiMgr.getInstance().GuiChooseEquipment.processDeleteClothes(int(GuiMgr.getInstance().GuiChooseEquipment.curHighlight.IdObject.split("_")[1]));
					break;
				case MSGBOX_ERROR_FISHWAR_GO_HOME :
					if(Ultility.IsInMyFish())
					{
						if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
						{
							if (LeagueInterface.getInstance().IsGotoLegueOk)//nếu đã vào liên đấu thành công thì mới được về nhà
							{
								LeagueMgr.getInstance().goBackHome();
							}
							else {
								return;
							}
						}
						else {
							GameController.getInstance().UseTool("Home");
						}
						
					}
					else
					{
						GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
						//GuiMgr.getInstance().GuiMainFishWorld.InitRound();
					}
					break;
				case MSGBOX_ERROR_FISHWAR_REFRESH:
					if(Ultility.IsInMyFish())
					{
						GameLogic.getInstance().DoGoToLake(GameLogic.getInstance().user.CurLake.Id, GameLogic.getInstance().user.Id);
					}
					else 
					{
						//GuiMgr.getInstance().GuiMapOcean.ComeBackHome();
						GuiMgr.getInstance().GuiMainFishWorld.InitRound();
					}
					break;
				case MSGBOX_FISHWORLD_BACK_MAP:
					GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
					break;
				case MSGBOX_FISHWORLD_BACK_HOME:
					GuiMgr.getInstance().GuiMapOcean.ComeBackHome();
					break;
				case MSGBOX_ERROR_FISHWORLD_REFRESH:
					GuiMgr.getInstance().GuiMainFishWorld.InitRound();
					break;
				case MSGBOX_CONFIRM_BACK_MAP:
					GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
					break;
				case MSGBOX_LINK_SHOP:
					GuiMgr.getInstance().GuiShop.CurrentShop = "Special";
					GuiMgr.getInstance().GuiShop.curPage = 1;
					GameController.getInstance().UseTool("Shop");
					//GuiMgr.getInstance().GuiShop.ShowShop("Food");
					break;
				case MSGBOX_FEED:
					{
						//GuiMgr.getInstance().GuiFeedWall.SetMixLakeName(MixLakeName);
						//GuiMgr.getInstance().GuiFeedWall.SetTargetUpgradeLake(TargetLake);
						ImageNameFeed = Localization.getInstance().getString("FeedIcon" + FeedType)
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(FeedType, "", "", ImageNameFeed);
					}
					break;
					
				case MSGBOX_FEED_UNLOCK_LAKE:
					ImageNameFeed = Localization.getInstance().getString("FeedIcon" + GUIFeedWall.FEED_TYPE_UNLOCK_LAKE)
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_UNLOCK_LAKE, "", "", ImageNameFeed);
				break;
				
				case MSGBOX_RELOAD:
					{
						if (ExternalInterface.available)
						{
							ExternalInterface.call("function startover(){document.location.reload()}");
						}
					}
					break;
				case MSGBOX_INVENTORY:
					{
						GameController.getInstance().UseTool("Inventory_Special_0");
					}
					break;
				case MSGBOX_CONFIRM_SELL:
					{
						if (SellFish.FishType != Fish.FISHTYPE_SOLDIER)
						{
							GameLogic.getInstance().SellFish(SellFish);
							//GameLogic.getInstance().user.UpdateOptionLakeObject(-1, SellFish.RateOption, GameLogic.getInstance().user.CurLake.Id);
						}
						else
						{
							GameLogic.getInstance().SellFishSoldier(SellFish as FishSoldier);
						}
						GameLogic.getInstance().cursor.gotoAndPlay(0);
					}
					break;
				case MSGBOX_CONFIRM_SELL_SPARTAN:
					{
						GameLogic.getInstance().SellFishSpartan(SellFishSpartan);
						//GameLogic.getInstance().user.UpdateOptionLakeObject(-1, SellFishSpartan.RateOption, GameLogic.getInstance().user.CurLake.Id);
						GameLogic.getInstance().cursor.gotoAndPlay(0);
					}
					break;
				case MSGBOX_CONFIRM_PLAY_FAST:
					{
						GuiMgr.getInstance().GuiAutomaticGame.StartSendPacket();
					}
					break;
				case MSGBOX_CONFIRM_SELL_FIREWORK_FISH:
					GameLogic.getInstance().SellFireworkFish(SellFish as FireworkFish);
					GameLogic.getInstance().cursor.gotoAndPlay(0);
					break;
				case MSGBOX_CLOSE:
					{
						
					}
					break;
				case MSGBOX_OK_CHEAT:
					INI.uId = TextboxId.GetText();
					//GameLogic.getInstance().user.GetMyInfo() = new MyUserInfo();
					Exchange.RenewInstance();
					//GameLogic.getInstance().DoGoToLake(1, int(INI.uId));
					if(Ultility.IsInMyFish())
					{
						GameLogic.getInstance().DoGoToLake(1, int(INI.uId));
					}
					else 
					{
						GuiMgr.getInstance().GuiMapOcean.ComeBackHome();
					}
					break;					
				case MSGBOX_BUY_GOLD:
				{
					var cmd:SendUnlockSlotMaterial = new SendUnlockSlotMaterial("Money");
					Exchange.GetInstance().Send(cmd);
					
					/*if (GuiMgr.getInstance().GuiMixFish.IsVisible)
					{
						GuiMgr.getInstance().GuiMixFish.UnlockSlot(true);
						// Feed lên tường khi unlock slot nguyên liệu
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_UNLOCK_SLOT_MATERIAL, slotUnlock.toString());
					}*/
					if (GuiMgr.getInstance().guiMateFish.IsVisible)
					{
						GuiMgr.getInstance().guiMateFish.unlockSlotMaterial(false);
						// Feed lên tường khi unlock slot nguyên liệu
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_UNLOCK_SLOT_MATERIAL, slotUnlock.toString());
					}
					break;
				}				
				case MSGBOX_BUY_ZXU:
				{
					var cmdXu:SendUnlockSlotMaterial = new SendUnlockSlotMaterial("ZMoney");
					Exchange.GetInstance().Send(cmdXu);
					
					/*if (GuiMgr.getInstance().GuiMixFish.IsVisible)
					{
						GuiMgr.getInstance().GuiMixFish.UnlockSlot(false);
						// Feed lên tường khi unlock slot nguyên liệu
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_UNLOCK_SLOT_MATERIAL, slotUnlock.toString(), "",
							Localization.getInstance().getString("FeedIcon" + GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_UNLOCK_SLOT_MATERIAL));
					}*/
					if (GuiMgr.getInstance().guiMateFish.IsVisible)
					{
						GuiMgr.getInstance().guiMateFish.unlockSlotMaterial(true);
						// Feed lên tường khi unlock slot nguyên liệu
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_UNLOCK_SLOT_MATERIAL, slotUnlock.toString());
					}
					break;
				}
				case MSGBOX_OK_DELETE:
				{
					GuiMgr.getInstance().GuiNewMail.ProcessDeleteAll();
					break;
				}
				case MSGBOX_CANCEL_DELETE:
				{
					Hide();
					break;
				}
				case MSGBOX_OK_DELETE_SYSTEM_MAIL:
				{
					MailMgr.getInstance().deleteMail(idSystemMail);
					break;
				}
				case MSGBOX_CANCEL_DELETE_SYSTEM_MAIL:
				{
					Hide();
					break;
				}
				case MSGBOX_OK_STOP_TRAINING:
					GuiMgr.getInstance().GuiTrainingTower.stopOk();
				break;
				case MSGBOX_CANCEL_STOP_TRAINING:
				break;
				default:
					GameLogic.getInstance().OnMessageBox(buttonID);
					break;
			}
			if (buttonID != MSGBOX_NOTHING)
			{
				if (inReload)
				{
					if (ExternalInterface.available)
					{
						ExternalInterface.call("function startover(){document.location.reload()}");
					}
					inReload = false;
				}
				Hide();
			}
			if (buttonID == MSGBOX_OK)
			{
				switch(Msg)
				{
					case Localization.getInstance().getString("Message34"):
						GuiMgr.getInstance().guiMateFish.mateFish();
					break;
					case Localization.getInstance().getString("Message42"):
						GuiMgr.getInstance().GuiGemRefine.delAllGem();
					break;
					case Localization.getInstance().getString("IslandMess5"):
						callFunc();
					break;
					case Localization.getInstance().getString("EventMidAutumn_TipNextDay"):
					case Localization.getInstance().getString("EventMidAutumn_TipFinishEvent"):
						if (GuiMgr.getInstance().guiBackGround.IsVisible)
						{
							GuiMgr.getInstance().guiBackGround.Hide();
						}
					break;
				}
			}
		}
		
		public function ShowConfirmStopTraining(msg:String, x:int = 310, y:int = 200, NPC:int = 0):void 
		{
			Msg = msg;
			IsOK = false;
			IsCancel = false;
			X = x;
			Y = y;
			NPCType = NPC;
			super.Show(Constant.GUI_MIN_LAYER, 5);
			var btnOK: Button = AddButton(MSGBOX_OK_STOP_TRAINING, "Btngreen",65, 207, this);
			btnOK.img.width = 100;
			btnOK.img.height = 38;
			TfAgree = AddLabel("Đồng ý", 82, 177, 0x000000, 0);
			TfAgree.scaleX = TfAgree.scaleY = 1.3;
			
			var btnCancel: Button = AddButton(MSGBOX_CANCEL_STOP_TRAINING, "BtnRed", 175, 207, this);
			btnCancel.img.width = 100;
			btnCancel.img.height = 38;
			var tf1:TextField = AddLabel("Hủy bỏ", 192, 177, 0x000000, 0);
			tf1.scaleX = tf1.scaleY = 1.3;
		}
	}

}