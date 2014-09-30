package Sound
{
	import Data.ResMgr;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import Data.INI
	/**
	 * ...
	 * @author minht
	 */
	public class SoundMgr extends EventDispatcher
	{
		public static const MUSIC_NORMAL:int = 1;
		public static const MUSIC_WAR:int = 2;
		
		public static const EXT:String = ".mp3";
		
		private static var instance:SoundMgr;
		
		private var dataList:Array = [];
		private var dataLoader:Array = [];
		private var resArray:Array = [];
		
		private var bgMusic:SoundChannel;		
		public var IsMute:Boolean;
		public var IsPlayBg:Boolean;
		public var IsLoaded:Boolean = false;
		public var so:SharedObject;
		public var savedData:Object;
		
		public var musicMode:int;
		
		public function SoundMgr() 
		{
			if(instance != null)
			{
				throw new Error("Single cases of class instantiation error-SoundMgr");
			}

			IsMute = false;
			bgMusic = null;
			IsLoaded = false;
			so = SharedObject.getLocal("SavedSetting");
			if (so.data.uId != null)
			{
				
				savedData = so.data.uId;
			}
			else									//luu vao trong cache trong truong hop ko co du lieu
			{
				savedData = new Object();			
				so.data.uId = savedData;
			}
		}
		
		public static function getInstance():SoundMgr
		{
			if(instance == null)
			{
				instance = new SoundMgr;
			}
				
			return instance;
		}
		
		public function Init():int
		{
			dataList = INI.getInstance().getSoundList();
			var i:int;
			for (i = 0; i < dataList.length; i++)
			{
				var vLoader:Loader = new Loader();
				dataLoader.push(vLoader);
			}
			IsPlayBg = false;
			return 1;
		}
		
		public function GetDataID(resID:String):int 
		{
			var i:int;
			var j:int;
			
			
			for (i = 0; i < dataList.length; i++)
			{
				for (j = 0; j < dataList[i]["res"].length; j++)
				{
					if (dataList[i]["res"][j] == resID)
					{
						return i;
					}
				}
			}
			return -1;
		}
		
		public function LoadData(DataID:int):void
		{	
			var url:URLRequest;
			var sound:Sound
			if (DataID < 0)
			{
				for (var i:int = 0; i < dataList.length; i++)
				{
					url = new URLRequest(dataList[i]["url"]);
					sound = new Sound();
					sound.load(url);					
					dataList[i]["state"] = "loading";
					resArray.push(sound);
				}				
				return;
			}
			//dataLoader[DataID].contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComp);
			//dataLoader[DataID].load(new URLRequest(url));
			
			if (dataList[DataID]["state"] != "notLoad")
			{
				return;
			}
			url = new URLRequest(dataList[DataID]["url"]);
			sound = new Sound();
			sound.load(url);			
			dataList[DataID]["state"] = "loading";
			resArray.push(sound);
		}
		
		private function onLoaderComp(e:Event):void 
		{
			//resArray.push(e.currentTarget.applicationDomain);
			resArray.push(e.currentTarget.url);
			var i:int;
			for (i = 0; i < dataList.length; i++)
			{
				if (dataList[i]["url"] == e.currentTarget.url)
				{
					dataList[i]["state"] = "loaded";	
					//break;
				}
			}
		}

		public function getClass(name:String):Sound
		{
			for (var i:int = 0; resArray && i < resArray.length; i++)
			{
				if (resArray[i].url && resArray[i].url.search(name) >= 0)
				{
					return resArray[i];
				}
			}
			return null;		
		}
		
		private function searchClass(name:String):Class
		{
			//for(var i:int = 0,j:int = resArray.length;i<j;i++)
			//{
				//if((resArray[i] as ApplicationDomain).hasDefinition(name))
				//{
					//return (resArray[i] as ApplicationDomain).getDefinition(name) as Class;
				//}
			//}
			return null;
		}
		
		/**
		 * 
		 * @param	name id của sound
		 * @return	object kiểu flash.media.Sound
		 */
		public function getSound(name:String):Sound
		{
			if (IsMute)
			{
				return null;
			}
			
			// check data exits
			var _dataID:int = GetDataID(name);
			if (_dataID < 0)
			{
				return null;
			}
			if (dataList[_dataID]["state"] == "notLoad")
			{
				LoadData(_dataID);
				return null;
			}		
			
			var c:Sound = getClass(name);
			if(c != null)
			{
				return c;
			}
			return null;
		}
		
		public function Loaded(e:Event = null):void
		{
			IsLoaded = true;
			var arr:Array = GetSoundSetting();
			if (arr["music"] != "off")
			{
				playBgMusic();
				arr["music"] = "on";
			}
			else
			{
				arr["music"] = "off";
			}	
			
			if (arr["sound"] == "off")
			{
				IsMute = true;
				arr["sound"] = "off";
			}
			else
			{
				IsMute = false;
				arr["sound"] = "on";
			}
			
			//for (var i:int = 0; i < dataList.length; i++)
			//{
				//dataList[i]["state"] == "loaded"
				//LoadData(i);
			//}
		}
		
		public function playBgMusic(mode:int = MUSIC_NORMAL):void
		{
			if (IsPlayBg || !IsLoaded)
			{
				if (mode == musicMode)
				{
					return;
				}
				else
				{
					if (bgMusic != null)
					bgMusic.stop();
				}
			}
			savedData.music = "on";
			var url:URLRequest = new URLRequest(ResMgr.getInstance().DataUrl + INI.getInstance().GetBgMusic(mode));
			var bg:Sound = new Sound();
			bg.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void { trace(e) } );
			bg.load(url);
			
			bgMusic = bg.play(0, 9999);
			
			if (mode == MUSIC_WAR && bgMusic != null)
			{
				var st:SoundTransform = new SoundTransform(0.4);
				bgMusic.soundTransform = st;
			}
			
			IsPlayBg = true;
			musicMode = mode;
		}
		
		public function stopBgMusic():void
		{			
			if (bgMusic != null)
			{
				bgMusic.stop();
				IsPlayBg = false;
				savedData.music = "off";
			}
		}
		
		public function MuteSound(IsMute:Boolean):void
		{
			this.IsMute = IsMute;
			if (IsMute)
			{
				savedData.sound = "off";
			}
			else
			{
				savedData.sound = "on";
			}
		}
		
		public function GetSoundSetting():Array
		{
			var arr:Array = [];
			arr["sound"] = savedData.sound;
			arr["music"] = savedData.music;
			return arr;
		}
	}

}