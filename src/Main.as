package
{
	import com.flashdynamix.utils.SWFProfiler;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.ResMgr;
	import Data.Tips;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	import GameControl.*;
	import GUI.*;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.Image;
	import GUI.Minigame.MinigameMgr;
	import Logic.*;
	import NetworkPacket.*;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendInitRun;
	import NetworkSocket.ExchangeSocket;
	import Sound.SoundMgr;
	


	/**
	 * ...
	 * @author ducnh
	 */
	public class Main extends Sprite 
	{
		//public static var staticURL:String = "http://myfish-pre-static.apps.zing.vn/imgcache";
		//public static var HostUrl:String =  "http://myfish-pre.apps.zing.vn";
		//public static var ConfigVer:String = "";
		//public static var verLocalization:String = "";
		//public static var verJson:String = "";
		
		public static var staticURL:String = "http://123.30.184.149/myFish/imgcache";
		public static var HostUrl:String = "http://123.30.184.149/myFish";
		public static var ConfigVer:String = "170";
		public static var verJson:String = "170";
		public static var verLocalization:String = "170";
		
		public static var uId:int = 0;
		public static var userName:String = "";
		public static var sessionId:String = "";
		public static var verTournament:String = "";
		public static var SERVER_IP:String = ""
		public static var SERVER_PORT:int = 443;
		
		private var IsLoadedData:Boolean;
		private var IsLoadedJson:Boolean;
		private var IsLoadedLocalize:Boolean;
		public static var imgRoot:Sprite;
		
		public static var instanceId:String = "";
		public static var serverId:String = "";

		public function Main():void
		{ 			
			if (stage) init();			
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			//ExchangeSocket.getInstance().connect("120.138.72.152", 843);
		}
		
		private function init(e:Event = null):void 
		{
			IsLoadedData = false;
			IsLoadedLocalize = false;
			IsLoadedJson = false;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, GameInput.getInstance().OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, GameInput.getInstance().OnKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, GameInput.getInstance().OnMouseMove);
			stage.addEventListener(MouseEvent.CLICK, GameInput.getInstance().OnMouseClick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, GameInput.getInstance().OnMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, GameInput.getInstance().OnMouseUp);
			stage.addEventListener(Event.ENTER_FRAME, Loop);
			stage.addEventListener(Event.RESIZE, OnStageResize);
			stage.frameRate = 24;
			
			imgRoot = new Sprite();
			imgRoot.scrollRect = new Rectangle(0, 0, Constant.STAGE_WIDTH, Constant.STAGE_HEIGHT);
			stage.addChild(imgRoot);

			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("execute", Main.Execute);
			}
			//LayerMgr.getInstance().AddLayer(stage);
			LayerMgr.getInstance().AddLayers(imgRoot, Constant.TopLayer + 1);
			
			//Vẽ 1 hình chữ nhật để định hình layer background
			LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).graphics.drawRect(0, 0, Constant.MAX_WIDTH, Constant.MAX_HEIGHT);			
			
			//Dịch màn hành sang trái, lên trên 1 khoảng để view ở giữa
			Ultility.PanScreenView();
			
			//BaseObject.mainStage = this.stage;			
			//try {
				addChild(ResMgr.loadingSC);
			//}catch (err:Error){
				//GameLogic.getInstance().CatchErr(err);
			//}
			
			//if ("xmldir" in stage.loaderInfo.parameters)
			if ("configUrl" in stage.loaderInfo.parameters)
			{
				//HostUrl = stage.loaderInfo.parameters["xmldir"];
				//ConfigVer = stage.loaderInfo.parameters["version"];
				staticURL = stage.loaderInfo.parameters["configUrl"];
				ConfigVer = stage.loaderInfo.parameters["version"];
				HostUrl = stage.loaderInfo.parameters["gatewayUrl"];
				uId = stage.loaderInfo.parameters["sign_user"];	
				userName = stage.loaderInfo.parameters["username"];	
				sessionId = stage.loaderInfo.parameters["session_id"];
				verJson = stage.loaderInfo.parameters["versionJson"];
				verLocalization = stage.loaderInfo.parameters["versionLocalization"];
				verTournament = stage.loaderInfo.parameters["tournamentVersion"];
				SERVER_IP = stage.loaderInfo.parameters["socketIp"];
				SERVER_PORT = stage.loaderInfo.parameters["socketPort"];
				instanceId = stage.loaderInfo.parameters["instanceId"];
				serverId = stage.loaderInfo.parameters["serverId"];
			}
			loadTips(ConfigVer);
			//throw new Error("configUrl: " + HostUrl + " ,ver: " +  ConfigVer + " ,gatewayUrl: " + INI.BaseURL + " ,versionJson: " + verJson + " ,versionLocalization: " + verLocalization);
			INI.uId = uId.toString();
			INI.BaseURL = HostUrl;
			ResMgr.getInstance().DataUrl = staticURL;
			LoadConfigXML(ConfigVer);
			 				
			// cho phep domain
			if (Constant.DEV_MODE == false)
			{
				Security.loadPolicyFile("http://avatar.me.zdn.vn/crossdomain.xml");
				//Security.loadPolicyFile("http://1.s50.avatar.zdn.vn/crossdomain.xml");
				//Security.loadPolicyFile("http://c.1.s50.avatar.zdn.vn/crossdomain.xml");
			}
			else
			{
				//Security.loadPolicyFile("http://img-dev.avatar.me.zing.vn/crossdomain.xml");
			}			
			//Security.loadPolicyFile(staticURL+"/xml/crossdomain.xml");
		}
		
		private function loadTips(_xmlVersion:String):void
		{
			var tipUrl:String;
			if (Constant.OFF_SERVER)
			{
				tipUrl = "../src/tips.xml";		
			}
			else
			{
				Security.allowDomain("http://avatar.me.zdn.vn/");				
				Security.allowDomain(HostUrl);
				Security.allowDomain(staticURL);
				tipUrl = staticURL + "/xml/tips" + _xmlVersion + ".xml";	
			}
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadTipsComplete);
			urlLoader.load(new URLRequest(tipUrl));
		}
		
		private var tipTimer:Timer;
		//private var isLoadedTip:Boolean = false;
		private function loadTipsComplete(e:Event):void 
		{
			var xml:XML = new XML(e.target.data);
			var xmlTips:Tips = new Tips(xml);
			ResMgr.loadingSC.randomTip();
			//isLoadedTip = true;
			tipTimer = new Timer(3000);
			tipTimer.addEventListener(TimerEvent.TIMER, randomTip);
			tipTimer.start();
		}
		
		private function randomTip(e:TimerEvent):void 
		{
			ResMgr.loadingSC.randomTip();
		}
		
		private var count:int = 0;
		private function Loop(event:Event):void
		{
			if(GameController.getInstance().gameMode != GameController.GAME_MODE_BOSS_SERVER)
			{
				GameLogic.getInstance().UpdateLogic();
			}
			else
			{
				GameLogic.getInstance().updateLogicBossServer();
			}
		}
				
		
		private function StartGame():void
		{
			//chọn cách vào và thoát khỏi liên đấu
			LeagueController.getInstance().key = LeagueController.INVISIBLE;//chọn cách ẩn toàn bộ lúc vào => thoát nhanh
			//LeagueController.getInstance().key = LeagueController.DELETE;//chọn cách xóa toàn bộ lúc vào=>load lại game khi thoát
			// remove loadingbar
			removeChild(ResMgr.loadingSC);
			
			// Add Profiler :
			SWFProfiler.init(stage, this); 			
			
			// Add background
			//GameController.getInstance().SetBackground("BgLake", "BgSky");

			// add gui
			//GuiMgr.getInstance().GuiMain.Show(Constant.GUI_MIN_LAYER + 1);
			GuiMgr.getInstance().GuiMain.Show();
			//GuiMgr.getInstance().guiFrontEvent.initDataFromConfig();
			if (GameController.getInstance().blackHole == null)
			{
				var layerObject:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
				GameController.getInstance().blackHole = new Image(layerObject, "Black_Hole", 200, 100);
				layerObject.addChild(GameController.getInstance().blackHole.img);
				GameController.getInstance().blackHole.SetPos(485, 135);
				GameController.getInstance().blackHole.img.visible = false;
			}
			
			// yeu cau thong tin
			// Lấy thông tin cá lính của User
			var pk_run:SendInitRun = new SendInitRun();
			Exchange.GetInstance().Send(pk_run);
			var getSoldier:SendGetAllSoldier = new SendGetAllSoldier();
			Exchange.GetInstance().Send(getSoldier);
			
			// show waiting screen
			GuiMgr.getInstance().GuiWaitingData.Show(Constant.TopLayer-1, 1);
			
			// add GuiTopInfo
			//GuiMgr.getInstance().GuiTopInfo.Show(Constant.GUI_MIN_LAYER + 1);
			//GuiMgr.getInstance().GuiTopInfo.Show();
			//GUI user info
			GuiMgr.getInstance().guiUserInfo.Show();
			GuiMgr.getInstance().guiFrontScreen.Show();
			GuiMgr.getInstance().GuiSetting.Show();
			// add Setting gui
			//GuiMgr.getInstance().GuiSetting.Show(Constant.GUI_MIN_LAYER + 1);
			//GuiMgr.getInstance().GuiSetting.Show();
			
			// Add gui friends
			// MinhT
			var guiFriends:GUIFriends = GuiMgr.getInstance().GuiFriends;
			guiFriends.Show();			
			
			/*
			//statedispla
			stage.scaleMode = StageScaleMode.NO_SCALE;
			if (stage.displayState == StageDisplayState.NORMAL) 
			{
				stage.displayState=StageDisplayState.FULL_SCREEN;
			} f
			else 
			{
				stage.displayState=StageDisplayState.NORMAL;
			}
			var scalingRect:Rectangle = new Rectangle(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			stage["fullScreenSourceRect"] = scalingRect;  
			*/
			
		}
		
		private function LoadConfigXML(_xmlVersion:String):void
		{
			var iniurl:String;
			if (Constant.OFF_SERVER)
			{
				iniurl = "../src/config1.xml";		
			}
			else
			{
				Security.allowDomain("http://avatar.me.zdn.vn/");				
				Security.allowDomain(HostUrl);
				Security.allowDomain(staticURL);
				//iniurl = HostUrl + "/xml/config" + _xmlVersion + ".xml";	
				iniurl = staticURL + "/xml/config" + _xmlVersion + ".xml";	
			}

			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, LoadConfigComp);
			urlLoader.load(new URLRequest(iniurl));

			//throw new Error(iniurl);
		}
		
		private function LoadConfigComp(e:Event):void
		{
			Config.getInstance(e.target.data);
			//Load ini
			//var iniVer:String = Config.getInstance().GetIniVersion();
			loadIniXML(ConfigVer);		
			
			// Load localization	
			//var localVer:String = Config.getInstance().GetlocalizationVersion();
			
		}
		
		private var gameVersion:String = "";
		private var xmlVersion:int = 0;
		private var xmlName:String = "ini";
		private function loadIniXML(_xmlVersion:String):void
		{			
			var iniurl:String;
			if (Constant.OFF_SERVER)
			{
				iniurl = "../src/header.xml";		
			}
			else
			{
				Security.allowDomain(HostUrl);
				//iniurl = HostUrl + "/xml/header" + _xmlVersion + ".xml";	
				iniurl = staticURL + "/xml/header" + _xmlVersion + ".xml";
				//trace("load xml= " + iniurl);
			}
			var iniURLLoader:URLLoader = new URLLoader();
			iniURLLoader.addEventListener(Event.COMPLETE, loadXMLComp);
			iniURLLoader.load(new URLRequest(iniurl));
		}
		
		private function loadXMLComp(e:Event):void
		{
			INI.getInstance(e.target.data);			
			loadLocalizationXML(verLocalization);
			
		}	
		
		private function loadLocalizationXML(_xmlVersion:String):void
		{			
			var iniURL:String;			
			var iniURLLoader:URLLoader = new URLLoader();
			if (Constant.OFF_SERVER)
			{
				iniURL = "../src/localization1.xml";
			}
			else
			{
				//iniURL = HostUrl + "/xml/localization" + _xmlVersion + ".xml";					
				iniURL = staticURL + "/xml/localization" + _xmlVersion + ".xml";					
			}
			iniURLLoader.addEventListener(Event.COMPLETE, loadLocalizationComp);
			iniURLLoader.load(new URLRequest(iniURL));
		}
		
		private function loadLocalizationComp(e:Event):void
		{
			var xmlContent:Localization = Localization.getInstance(e.target.data);
			IsLoadedLocalize = true;
			
			//Load json
			loadJson(verJson);			
		}		
		
		
		private function LoadDefaultDataComp(e:Event):void
		{
			if (tipTimer != null)
			{
				tipTimer.stop();
				tipTimer.removeEventListener(TimerEvent.TIMER, randomTip);
				tipTimer = null;
			}
			IsLoadedData = true;			
			if (IsLoadedData && IsLoadedLocalize && IsLoadedJson)
			{
				StartGame();
			}
		}
		
		private function loadJson(_xmlVersion:String):void
		{	
			var jsonURL:String;			
			var jsonURLLoader:URLLoader = new URLLoader();
			if (Constant.OFF_SERVER)
			{
				jsonURL = "../src/json.txt";
			}
			else
			{
				jsonURL = HostUrl + "/xml/json" + _xmlVersion + ".txt";	
				jsonURL = staticURL + "/xml/json" + _xmlVersion + ".txt";	
			}
			jsonURLLoader.addEventListener(Event.COMPLETE, loadJsonComp);
			jsonURLLoader.load(new URLRequest(jsonURL));
		}
		
		private function loadJsonComp(e:Event):void 
		{
			var json:ConfigJSON = ConfigJSON.getInstance(e.target.data);
			IsLoadedJson = true;
			var confTour:Object = ConfigJSON.getInstance().GetItemList("Tournament");
			LogicTournament.arrTime.push(confTour["Time"][1] - 1);
			LogicTournament.arrTime.push(confTour["Time"][2] - 1);
			LogicTournament.arrTime.push(confTour["Time"][3] - 1);
			LogicTournament.arrTime.push(confTour["Time"][4] - 1);
			Fish.initStaticFish();
			FishSpartan.initStaticFish();
			MinigameMgr.getInstance().initData();
			
			ResMgr.getInstance().Init();
			// load default data
			var eventName:String = "BaseContentLoaded";
			ResMgr.getInstance().addEventListener(eventName, LoadDefaultDataComp);
			ResMgr.getInstance().LoadBaseData(ConfigVer);
			
			SoundMgr.getInstance().Init();
			//SoundMgr.getInstance().LoadData(-1);
			
			var url:URLRequest = new URLRequest(ResMgr.getInstance().DataUrl + INI.getInstance().GetBgMusic());
			var iniURLLoader:URLLoader = new URLLoader();
			iniURLLoader.addEventListener(Event.COMPLETE, SoundMgr.getInstance().Loaded);
			iniURLLoader.load(url);
			
			if (IsLoadedData && IsLoadedLocalize && IsLoadedJson) 
			{
				StartGame();
			}
		}
		
		private function OnStageResize(e:Event):void
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				GuiMgr.getInstance().DoFullScreen(true);
			}
			else
			{
				GuiMgr.getInstance().DoFullScreen(false);
			}
		}
		
		public static function VisibleAllLayer(visible:Boolean):void
		{
			var i:int;
			var layer:Layer;
			if (visible)
			{
				GameLogic.getInstance().ShowFish();
			}
			else
			{
				GameLogic.getInstance().HideFish(true);
			}
			for (i = 0 ; i < Constant.TopLayer + 1; i++)
			{
				layer = LayerMgr.getInstance().GetLayer(i);
				layer.visible = visible;
			}
		}
		
		private static function Execute(command:String):void
		{
			GuiMgr.getInstance().GuiShop.Show();
		}
	}
	
}