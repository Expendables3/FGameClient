package  
{
	import Data.INI;
	import Data.ResMgr;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import GUI.GUIMain;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import NetworkPacket.PacketReceive.Tournament.ReceiveGetGiftTournamentInfo;
	import NetworkPacket.PacketReceive.Tournament.ReceiveGiftTournament;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendInitRun;
	import NetworkPacket.PacketSend.SendUpdateG;
	import NetworkPacket.PacketSend.Tournament.SendGetGiftTournamentInfo;
	/**
	 * ...
	 * @author ...
	 */
	public class LogicTournament extends EventDispatcher
	{
		public static const TYPE_GOLD:int = 1;
		public static const TYPE_XU:int = 2;
		public static var instance:LogicTournament = new LogicTournament();
		private static var tounament:Sprite = null;
		public static var arrTime:Array = new Array();
		private static var today:Date;
		public function LogicTournament() 
		{
			today = new Date();
		}		
		
		public static function getInstance():LogicTournament
		{
			if (instance == null)
			{
				instance = new LogicTournament();
			}
			return instance;
		}
		
		public static function checkTournamentRegister():Boolean 
		{			
			if ((int)(Main.verTournament) <= 0)
			{
				return false;
			}
			
			var hourActiveArr:Array = LogicTournament.arrTime;
			var gmt7:int = -420;
			var currentTime:int = GameLogic.getInstance().CurServerTime;			
			today.setTime(currentTime * 1000);
			var hour:int = today.getUTCHours() - gmt7 / 60;
			var minute:int = today.getUTCMinutes();
			if (minute >= 50 && minute <= 59)
			{
				if (hourActiveArr.indexOf(hour) != -1)
				{
					return true;
				}
			}
			return false;
		}
		
		public function openTournament():void
		{
			if (!tounament)
			{
				var loaderS:Loader = new Loader();
				loaderS.contentLoaderInfo.addEventListener(Event.COMPLETE, ok);
				var contextLoader:LoaderContext = new LoaderContext(false, new ApplicationDomain());			
				
				var st:String = Main.staticURL + "/content/tournament" + Main.verTournament + ".swf";
				loaderS.load(new URLRequest(st), contextLoader);
			}
			else
			{
				Object(tounament).initDataTournament(Main.HostUrl, Main.staticURL, Main.ConfigVer, Main.verTournament, Main.verJson, Main.verLocalization, Main.sessionId, GameLogic.getInstance().user.GetMyInfo(), checkHasSoldier(), GameLogic.getInstance().CurServerTime, ResMgr.UseMd5, Main.SERVER_IP, Main.SERVER_PORT);
			}
			
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("hideAllLayer", function():void {Main.VisibleAllLayer(false)});
				ExternalInterface.addCallback("showAllLayer", function():void {Main.VisibleAllLayer(true)});
				ExternalInterface.addCallback("tournamentFee", payFeeTournament);				
				ExternalInterface.addCallback("showGuiCongrat", getGiftTourInfo);
				ExternalInterface.addCallback("updateG", function ():void {
						Exchange.GetInstance().Send(new SendUpdateG());
					});
				ExternalInterface.addCallback("reRun", function():void {
						Exchange.GetInstance().Send(new SendInitRun());
						Exchange.GetInstance().Send(new SendGetAllSoldier());
					});
				ExternalInterface.addCallback("enableButton", function():void {
						if(GuiMgr.getInstance().guiFrontScreen && GuiMgr.getInstance().guiFrontScreen.btnTournament)
						{
							GuiMgr.getInstance().guiFrontScreen.btnTournament.SetEnable(true);
						}
					});
				ExternalInterface.addCallback("napG", function ():void {
					GuiMgr.getInstance().GuiNapG.Init();
					});	
			}
		}
		
		public function getGiftTourInfo(champion:Boolean = false):void 
		{
			var cmd:SendGetGiftTournamentInfo = new SendGetGiftTournamentInfo();
			Exchange.GetInstance().Send(cmd);
			if (champion)
			{
				GameLogic.getInstance().user.GenerateNextID();
			}
		}
		
		public function processGetGiftTourInfo(data:Object):void 
		{			
			var cmd:ReceiveGetGiftTournamentInfo = new ReceiveGetGiftTournamentInfo(data);
			if (cmd.Error != 0 || cmd.userId != GameLogic.getInstance().user.GetMyInfo().Id)
			{
				return;
			}
			if (cmd.cardStar == 5)
			{
				if (cmd.groupId < 1 || cmd.groupId > 3)
				{
					return;
				}
				GuiMgr.getInstance().guiTournamentCongratChampion.ShowGui(cmd.cardStar, cmd.numChoose, cmd.lastCardId, cmd.groupId);
			}
			else if (cmd.cardStar >= 1)
			{
				if (cmd.groupId < 1 || cmd.groupId > 3)
				{
					return;
				}
				GuiMgr.getInstance().guiTournamentCongratLoser.ShowGui(cmd.cardStar, cmd.numChoose, cmd.lastCardId, cmd.groupId);
			}
		}
		
		public function processReceiveGiftTour(data:Object):void 
		{
			var cmd:ReceiveGiftTournament = new ReceiveGiftTournament(data);
			if (cmd.Error != 0)
			{
				return;
			}
			
			GuiMgr.getInstance().guiTournamentReceiveGift.ShowGui(cmd.cardId, cmd.star, cmd.groupId, cmd.equipment);
			if (GuiMgr.getInstance().guiTournamentCongratChampion.IsVisible)
			{
				GuiMgr.getInstance().guiTournamentCongratChampion.afterChoose();
			}
			if (GuiMgr.getInstance().guiTournamentCongratLoser.IsVisible)
			{
				GuiMgr.getInstance().guiTournamentCongratLoser.afterChoose();
			}
			if (cmd.eventItems != null && cmd.eventItems.length > 0)
			{
				GuiMgr.getInstance().guiGiftFromEvent.showGui(cmd.eventItems);
			}
		}
		
		private function payFeeTournament(payType:int, price:int):void 
		{
			switch(payType)
			{
				case TYPE_GOLD:
					GameLogic.getInstance().user.UpdateUserMoney(price);
					break;
				case TYPE_XU:
					GameLogic.getInstance().user.UpdateUserZMoney(price);
					break;
			}
		}
		
		private function ok(e:Event):void 
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			tounament = loaderInfo.content as Sprite;
			Main.imgRoot.addChild(tounament);
			Object(tounament).initDataTournament(Main.HostUrl, Main.staticURL, Main.ConfigVer, Main.verTournament, Main.verJson, Main.verLocalization, Main.sessionId, GameLogic.getInstance().user.GetMyInfo(), checkHasSoldier(), GameLogic.getInstance().CurServerTime, ResMgr.UseMd5, Main.SERVER_IP, Main.SERVER_PORT);
		}
		
		private function checkHasSoldier():Boolean
		{
			var arrSoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var fish:FishSoldier;
			var i:int;
			for (i = 0; i < arrSoldier.length; i++)
			{
				fish = arrSoldier[i];
				if (fish.Status == 1)
				{
					return true;
				}
			}
			return false;
		}
	}

}