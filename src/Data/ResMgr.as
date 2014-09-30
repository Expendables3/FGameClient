package Data
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import GameControl.GameController;
	import GUI.GuiMgr;
	import Logic.*;
	import Data.LoadingBar;
	/**
	 * lớp quản lý các dữ liệu ảnh lấy từ server về
	 * trong toàn chương trình chỉ có 1 dẫn xuất của lớp này thôi
	 * và được lấy ra = getInstance()
	 * @author ducnh
	 */
	public class ResMgr extends EventDispatcher
	{
		private static var instance:ResMgr;
		public static var loadingSC:LoadingScreen = new LoadingScreen();
		public static var loadingSCW:LoadingScreenWorld = new LoadingScreenWorld();
		public var DataUrl:String;
		private var BaseContentSize:int;
		private var BaseLoader:Loader;
		private var BgrLoader:Loader;
		private var resArray:Array = [];
		private var curLoadDataID:int;
		private var maxDataLoadSize:int;
		public static var UseMd5:Boolean = true;
		private var version:String = "";
		private var countContent:int = 0;
		
		private var loadResArr:Array = [];
		public var bmpList:Object = new Object();
		
		//Lưu lại các domain của avatar friend
		public var crossDomainArr:Array = [];
		public var LoadingList:Array = [];
		
		public function ResMgr() 
		{
			if(instance != null)
			{
				throw new Error("Single cases of class instantiation error-ResMgr");
			}
			curLoadDataID = -1;
		}
		
		/**
		 * truy cập đến dẫn xuất duy nhất của ResMgr
		 * @return đãn xuất duy nhất trong toàn bộ chương trình
		 */
		public static function getInstance():ResMgr
		{
			if(instance == null)
			{
				instance = new ResMgr;
			}
			
			return instance;
		}
		
		/**
		 * khởi tạo dữ liệu ban đầu
		 */
		public function Init():void
		{
			if (Constant.DEV_MODE)
			{
				UseMd5 = false;
			}
			DataUrl = INI.getInstance().getDataUrl();
			//DataUrl = "http://fish.zing.vn/web/contents/";
			BaseContentSize = INI.getInstance().GetBaseConttentSize();
		}
			
		public function GetRes(name:String, IsLinkAge:Boolean = true, toBitmap:Boolean = false):Object
		{
			var kq:Object = null;
			//trace("ResMgr 1 GetRes()== " + name);
			var url:String = FindUrl(name, IsLinkAge);
			
			if (IsLinkAge)
			{
				var C:Class = getClass(name);
				
				if (C != null)
				{
					kq = new C();
					if (toBitmap)
					{
						if (name in bmpList)
						{
							return bmpList[name].duplicate();
						}
						else
						{
							bmpList[name] = new BitmapMovie(kq as MovieClip);
							return bmpList[name].duplicate();
						}
					}
					
					return kq;
				}
			}
			else
			{
				var DuplicateUrl:int = GetDuplicateUrl(url); 
				if (DuplicateUrl >= 0)
				{
					var load:Loader = loadResArr[DuplicateUrl]["loader"] as Loader;
					
					if (loadResArr[DuplicateUrl]["status"] == "loaded")
					{
						try 
						{
							var a:Bitmap = loadResArr[DuplicateUrl]["loader"].content;
							var b:Bitmap = new Bitmap(a.bitmapData.clone());
							var c:Sprite = new Sprite();
							c.addChild(b);
							kq = c as Object;
							return c;
						}
						catch (err:Error)
						{
							trace("domain ko cho phep", name);
							LoadResErr(loadResArr[DuplicateUrl]["url"], "loi thieu cross domain ");
						}
					}
					else
					{
						if (loadResArr[DuplicateUrl]["status"] == "error")
						{
							LoadResErr(loadResArr[DuplicateUrl]["url"]);
						}
					}
				}
			}
			
			if (kq != null)
			{
				return kq;
			}
			else
			{
				if (GetDuplicateUrl(url) < 0 || name.search("Gui") >= 0)
				{
					var version:String = "";
					if (IsLinkAge)
					{
						version = GetFileVersion(name);
					}
					var loader:Loader = new Loader();
					// luu lai url da load
					//trace("ResMgr 2 GetRes()== " + name);
					var _o:Object = new Object();
					_o["BaseUrl"] = url;
					_o["url"] = FindUrl(name, IsLinkAge, version);
					_o["MD5url"] = FindMD5Url(name, IsLinkAge, version);
					_o["loader"] = loader;
					_o["status"] = "loading";
					_o["CheckName"] = name;
					loadResArr.push(_o);
					// load du lieu
					if (IsLinkAge)
					{
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadResComp);
					}
					else
					{
						var i:int = loadResArr.length - 1;
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void { UrlLoaded(i)});// onLoadResComp);
					}
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function():void { LoadResErr(url) } );
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function():void { LoadResErr(url) });
					
					try
					{
						if (UseMd5)
						{
							loader.load(new URLRequest(_o["MD5url"]));
						}
						else
						{
							loader.load(new URLRequest(_o["url"]));
						}
					}
					catch(err:Error)
					{
						trace(url);
					}		
				}
				return null;
			}
		}
		
		private function LoadResErr(url:String, errType:String = "dữ liệu ko tồn tại "):void
		{
			for (var i:int = 0; i < loadResArr.length; i++)
			{
				if (loadResArr[i]["url"] == url)
				{
					trace("Load fail content name: " + loadResArr[i]["CheckName"]);
					loadResArr[i]["status"] = "error";
					break;
				}
			}

			dispatchEvent(new Event("err" + url));
			if (Constant.DEV_MODE)
			{
				//trace(errType + url);
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(errType + url);
			}
		}
		
		public function UrlLoaded(index:int):void
		{
			loadResArr[index]["status"] = "loaded";
			var loader:Loader = loadResArr[index]["loader"] as Loader;
			//resArray.push(loader.contentLoaderInfo.applicationDomain);
			dispatchEvent(new Event(loadResArr[index]["BaseUrl"]));
			//trace(loadResArr[index]["BaseUrl"], index);
		}
		
		public function onLoadResComp(e:Event):void
		{
			for (var i:int = 0; i < loadResArr.length; i++)
			{
				if ((loadResArr[i]["url"] == e.currentTarget.url) || (loadResArr[i]["MD5url"] == e.currentTarget.url))
				{ 
					loadResArr[i]["status"] = "loaded";
					resArray.push(e.currentTarget.applicationDomain);
					dispatchEvent(new Event(loadResArr[i]["BaseUrl"]));
					return;
				}
			}
		}
		
		public function FindMD5UrlBaseData(url:String, IsLinkAge:Boolean = true, version:String = ""):String
		{
			if (IsLinkAge)
			{
				var FileName:String = url.split("_")[0] + version;
				FileName = Ultility.MD5Hash(FileName);
				//trace("FindMD5UrlBaseData== " + (DataUrl + "base/" + FileName + ".swf"));
				return (DataUrl + "base/" + FileName + ".swf");
			}
			else
			{
				return (url);
			}
		}
		
		public function FindMD5Url(url:String, IsLinkAge:Boolean = true, version:String = ""):String
		{
			if (IsLinkAge)
			{
				var FileName:String = Ultility.getFileName(url.split("_")[0], version, true);
				return (DataUrl + FileName + ".swf");
			}
			else
			{
				return (url);
			}
		}
		
		public function FindUrl(url:String, IsLinkAge:Boolean = true, version:String = ""):String
		{
			if (IsLinkAge)
			{
				var FileName:String = Ultility.getFileName(url.split("_")[0], version, false);
				return (DataUrl + FileName + ".swf");
			}
			else
			{
				return (url);
			}
			
		}
		
		
		public function GetBmpArray(name:String):Vector.<BitmapData>
		{
			return bmpList[name].bmpList;
		}
		
		public function GetBmpPos(name:String):Vector.<Rectangle>
		{
			return bmpList[name].bmpPos;
		}
		
		private function GetDuplicateUrl(url:String):int
		{
			for (var i:int = 0; i < loadResArr.length; i++)
			{
				if ((loadResArr[i]["BaseUrl"] == url) && (loadResArr[i]["status"] == "loaded"))
				{
					return i;
				}
			}
			
			return -1;
		}
		
		
		/**
		 * load file swf từ server về
		 * @param DataID index của file swf trong list các file swf trên server
		 * @see #GetDataID()
		 */
		public function LoadBaseData(ver:String):void
		{	
			var url:String = DataUrl + "base/" + INI.getInstance().GetBaseConttentName(countContent + 1) + ver + ".swf";
			version = ver;
			//throw new Error(url);
			//trace("LoadBaseData() load thu vien goc url== " + url);
			BaseLoader = new Loader();
			BaseLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBaseContentComp);
			BaseLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onReloadBaseContent);
			BaseLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadBaseContentProgress);
			BaseLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function():void { LoadResErr(url) });
			if (UseMd5)
			{
				//url = FindMD5Url(INI.getInstance().GetBaseConttentName(countContent + 1) + ver, true);
				url = FindMD5UrlBaseData(INI.getInstance().GetBaseConttentName(countContent + 1) + ver, true);
				BaseLoader.load(new URLRequest(url));
			}
			else
			{
				BaseLoader.load(new URLRequest(url));
			}
		}
		
		private function onReloadBaseContent(e:IOErrorEvent):void 
		{
			var url:String = DataUrl + "base/" + INI.getInstance().GetBaseConttentName(countContent + 1) + version + ".swf";
			if (UseMd5)
			{
				url = FindMD5UrlBaseData(INI.getInstance().GetBaseConttentName(countContent + 1) + version, true);
				BaseLoader.load(new URLRequest(url));
			}
			else
			{
				BaseLoader.load(new URLRequest(url));
			}
			trace("Reload lại onReloadBaseContent url== " + url);
		}
		
		private function onLoadBaseContentProgress(e:Event):void 
		{
			BaseContentSize = BaseLoader.contentLoaderInfo.bytesTotal;
			if (loadingSC != null) 
			{
				var curDataLoadSize:int = BaseLoader.contentLoaderInfo.bytesLoaded;
				var part:Number = 100/INI.getInstance().GetBaseConttentNum();
				var percent:Number = curDataLoadSize * part / BaseContentSize + countContent * part;								
				loadingSC.SetPercent(percent);
			}
		}
		
		private function onLoadBaseContentComp(e:Event):void 
		{
			resArray.push(e.currentTarget.applicationDomain);	
			countContent++;
			if (countContent < INI.getInstance().GetBaseConttentNum())
			{
				LoadBaseData(version);
			}
			else
			{
				loadingSC.SetPercent(100);
				var st:String = "BaseContentLoaded";
				dispatchEvent(new Event(st));	
			}
		}		
		
		/**
		 * Load hình nền
		 */
		public function loadBackGround():void
		{
			var itemId:int = GameLogic.getInstance().user.backGround.ItemId;
			var v:String = Config.getInstance().GetContentVersion("BackGround" + itemId);
			if (searchClass("BackGround" + itemId + v))
			{
				GameController.getInstance().changeBackGround(itemId);
				
				//Update lại độ bẩn của hồ
				if (GameLogic.getInstance().user.CurLake != null)
				{
					var nDirty:int = GameLogic.getInstance().user.CurLake.GetDirtyAmount();
					GameController.getInstance().SetLakeBright(0.5 + 0.5 * (1 - nDirty / Lake.MAX_DIRTY));
				}
				//trace("ko load lai");
				return;
			}
			
		
			var url:String = DataUrl + "BackGround" + itemId + v + ".swf";
			//trace("loadBackGround 1 url== " + url);
			BgrLoader = new Loader();
			BgrLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBgComp);
			BgrLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onReloadBg);
			BgrLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function():void { LoadResErr(url) });
			if (UseMd5)
			{
				var FileName:String = Ultility.MD5Hash("BackGround" + itemId + v);
				url = DataUrl + FileName + ".swf";
				//trace("loadBackGround 2 url== " + url);
				BgrLoader.load(new URLRequest(url));
			}
			else
			{
				BgrLoader.load(new URLRequest(url));
			}
			//trace("Load lai");
		}		
		
		/**
		 * Nếu có lỗi thì load lại hình nền
		 * @param	e
		 */		
		private function onReloadBg(e:IOErrorEvent):void 
		{
			//trace("Load lai background");
			var itemId:int = GameLogic.getInstance().user.backGround.ItemId;
			var v:String = Config.getInstance().GetContentVersion("BackGround" + itemId);
			var url:String = DataUrl + DataUrl + "BackGround" + itemId + v + ".swf";
			//trace("onReloadBg 1 url== " + url);
			if (UseMd5)
			{
				var FileName:String = Ultility.MD5Hash("BackGround" +  itemId + v);
				url = DataUrl + FileName + ".swf";
				//trace("onReloadBg 2 url== " + url);
				BgrLoader.load(new URLRequest(url));
			}
			else
			{
				BgrLoader.load(new URLRequest(url));
			}
			//trace("Reload lại Background");
		}
		
		
		/**
		 * Hoàn thành load hình nền
		 * @param	e
		 */
		private function onLoadBgComp(e:Event):void 
		{
			resArray.push(e.currentTarget.applicationDomain);
			if (GameLogic.getInstance().user.backGround != null)
			{
				var itemId:int = GameLogic.getInstance().user.backGround.ItemId;
				if (searchClass("BgLake" + itemId) == null)
				{
					//trace("khong thay background roiiiiiiiiiiiiiiiiii");
					return;
				}
				var isSmall:Boolean = Config.getInstance().isSmallBackGround(itemId);
				
				if(!isSmall)
				{
					GameController.getInstance().SetBackground(itemId);
				}
				else
				{
					GameController.getInstance().setSmallBackground(itemId);
				}
				
				//Update lại độ bẩn của hồ
				if (GameController.getInstance().typeFishWorld == Constant.TYPE_MYFISH)
				{
					var nDirty:int = GameLogic.getInstance().user.CurLake.GetDirtyAmount();
					GameController.getInstance().SetLakeBright(0.5 + 0.5 * (1 - nDirty / Lake.MAX_DIRTY));
				}
			}
		}				

		public function getClass(name:String):Class
		{
			return searchClass(name);			
		}
		
		private function searchClass(name:String):Class
		{
			for(var i:int = 0,j:int = resArray.length;i<j;i++)
			{
				if((resArray[i] as ApplicationDomain).hasDefinition(name))
				{
					return (resArray[i] as ApplicationDomain).getDefinition(name) as Class;
				}
			}
			return null;
		}
		
		// cai ham nay du`ng tam thoi
		private function GetFileVersion(imgName:String):String
		{
			//return "";
			var FileName:String = imgName.split("_")[0];
			var ObjId:String = "";
			var ObjType:String = "";
			
			var arr:Array = ["FishGift", "Fish", "Other", "OceanTree", "OceanAnimal", "MixLake"];
			var i:int;
			
			if (FileName.search("Gui") >= 0 
				|| FileName.search("Weapon") >= 0
				|| FileName.search("Helmet") >= 0
				|| FileName.search("Armor") >= 0
				|| FileName.search("GodCharm") >= 0 
				|| FileName.search("HerbPotion") >= 0
				|| FileName.search("HerbMedal") >= 0
				|| FileName.search("Material") >= 0 
				//|| FileName.search("EnergyItem") >= 0 
				|| FileName.search("BackGround") >= 0
				|| FileName.search("ForestWorld") >= 0
				|| FileName.search("fameTitle") >= 0
				|| FileName.search("Loading") >= 0
				|| FileName.search("Dice") >= 0)
			{
				return Config.getInstance().GetContentVersion(FileName);
			}
			
			for (i = 0; i < arr.length; i++)
			{
				var vt:int = FileName.search(arr[i]);
				//var Gui:int = FileName.search("Gui");
				//if (vt >= 0 && Gui == -1)
				if (vt >= 0)
				{
					ObjType = arr[i];
					ObjId = FileName.replace(arr[i], "");
					break;
				}
			}
			
			if ((ObjId != "") && (ObjType != ""))
			{
				//var obj:Object = INI.getInstance().getItemInfo(ObjId, ObjType);
				//if (obj["version"] == "")
				//{
					//trace(" ten ", FileName);
				//}
				//return obj["version"];
				//var id:int = parseInt(ObjId);
				//if (id > 1000 && ObjType == "Fish")
				//{
					//ObjType = "Gift";
					//id = id % 1000;
				//}
				var obj:Object = ConfigJSON.getInstance().getItemInfo(ObjType, int(ObjId));
				if(obj["Version"])
					return obj["Version"];
				else
					return "";
			}
			
			return "";
		}
		
		//Tìm xem cross domain của avatar đã được load chưa?
		//return true nếu cross domain đã được load
		//Tham số Domain truyền vào là domain của avatar
		public function searchCrossDomain(Domain:String):Boolean
		{
			for (var i:int = 0; i < crossDomainArr.length; i++)
			{
				if(resArray[i] == Domain)
				{
					return true;
				}
			}
			return false;
		}
		
		//Load policy file trong domain của avatar
		//Lưu ý chỉ dùng cho việc load avatar
		//Tham số Domain truyền vào là đường dẫn tới avatar
		public function loadPolicyFile(Domain:String):void
		{
			var domain:String;
			if (Domain == null) return;
			if (Domain.search("avatar_files"))
			{
				domain = Domain.split("avatar_files")[0] + "crossdomain.xml";
				if (ResMgr.getInstance().searchCrossDomain(domain) == false)
				{
					ResMgr.getInstance().crossDomainArr.push(domain);
					Security.loadPolicyFile(domain);
				}
			}
		}
		
		/**
		 * Load file content khi đang play - longbig
		 */
		public function LoadFileContent(FileName:String):void
		{
			var version:String = GetFileVersion(FileName);
			//trace("ResMgr LoadFileContent()== " + FileName);
			var url:String = FindUrl(FileName, true, version);
			if (GetDuplicateUrl(url) < 0)
			{
				var loader:Loader = new Loader();
				// luu lai url da load
				var _o:Object = new Object();
				_o["BaseUrl"] = url;
				_o["url"] = url;
				_o["MD5url"] = FindMD5Url(FileName, true, version);
				_o["loader"] = loader;
				_o["status"] = "loading";
				loadResArr.push(_o);
				
				var __o:Object = new Object();
				__o["url"] = url;
				__o["MD5url"] = FindMD5Url(FileName, true, version);
				__o["name"] = FileName;
				LoadingList.push(__o);
				
				// load du lieu
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadFileComp);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function():void { LoadResErr(url) } );
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function():void { LoadResErr(url) });
				
				try
				{
					if (UseMd5)
					{
						loader.load(new URLRequest(_o["MD5url"]));
					}
					else
					{
						loader.load(new URLRequest(_o["url"]));
					}
				}
				catch (err:Error)
				{
					trace(url);
				}
			}
		}
		
		public function onLoadFileComp(e:Event):void
		{
			onLoadResComp(e);
			if (GuiMgr.getInstance().GuiWaitingContent.IsVisible && GuiMgr.getInstance().GuiWaitingContent.GetGUIWaitName() == LoadingList[i]["name"])
			{
				GuiMgr.getInstance().GuiWaitingContent.Hide();
			}
			
			for (var i:int = 0; i < LoadingList.length; i++)
			{
				if ((LoadingList[i]["url"] == e.currentTarget.url) || (LoadingList[i]["MD5url"] == e.currentTarget.url))
				{
					LoadingList.splice(i, 1);
					return;
				}
			}
		}
	}

}