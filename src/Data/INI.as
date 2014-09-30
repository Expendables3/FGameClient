/**
 * package quản lý dữ liệu dùng trong game
 */




package Data
{
	import GUI.*;
	import Sound.SoundMgr;
	/**
	 * load file thiết lập mặc định từ server như host, swf url, sound url...
	 * @see ini.xml
	 */
	public class INI
	{
		private static var instance:INI;
		public static var BaseURL:String;		
		public static var uId:String = "";
		
		public function INI(xml:XML)
		{
			if(instance != null)
			{
				throw new Error("Single cases of class instantiation error-INI");
			}
			data = xml;
		}
		public static function getInstance(xml:Object = null):INI
		{
			var _x:XML = XML(xml);
			if(instance == null)
			{
				if (xml == null) {
					return null;
				}
				instance = new INI(_x);
			}
		
			return instance;
		}
		
		private var _data:XML;
		public function set data(value:XML):void
		{
			_data = value;
		}
		public function get data():XML
		{
			return _data;
		}
		
		
		/*public function getIniVersion():int
		{
			var returnValue:int;
			if(data != null)
				returnValue = int(data.version.@xmlVer);
			
			if(!returnValue)
			{
				throw new Error("Request address error");
			}
			return returnValue;
		}*/
		
		/**
		 * To obtain the requested url
		 */
		public function getPostUrl():String
		{
			if (uId == "" || uId == null || uId == '0')
			{				
				//return BaseURL + "/amf/gateway.php?uId=49383538";			// ??
				//return BaseURL + "/amf/gateway.php?uId=18322500";			// Tài Mà
				//return BaseURL + "/amf/gateway.php?uId=487794";			// ?_?
				//return BaseURL + "/amf/gateway.php?uId=2165568";			// Minh
				//return BaseURL + "/amf/gateway.php?uId=487707";			// Huấn
				//return BaseURL + "/amf/gateway.php?uId=20800690";			// Hiệp
				//return BaseURL + "/amf/gateway.php?uId=20800579"; 			//Long
				//return BaseURL + "/amf/gateway.php?uId=18322115"; 			//Linh
				//return BaseURL + "/amf/gateway.php?uId=11357326";			// Tuấn
				//return BaseURL + "/amf/gateway.php?uId=1546211";			// Quang
				//return BaseURL + "/amf/gateway.php?uId=20800525";			// Đông
				//return BaseURL + "/amf/gateway.php?uId=284847";			// Hiếu
				//return BaseURL + "/amf/gateway.php?uId=487853"; //Thai Anh
				//return BaseURL + "/amf/gateway.php?uId=2199078"; //Dung Qc
				//return BaseURL + "/amf/gateway.php?uId=358245"; //Van Anh
				//return BaseURL + "/amf/gateway.php?uId=7979248"; // Anh Thanh
				//return BaseURL + "/amf/gateway.php?uId=14995646"; // ThanhNT2
				return BaseURL + "/amf/gateway.php";
				
			}
			else
			{
				return BaseURL + "/amf/gateway.php";				
			}
		}
		
		
		/*public function helpScreenUrl():String
		{
			var returnValue:String = "";
			if(data != null)
				returnValue = data.helpScreen.@url;
			
			if(returnValue == "")
			{
				throw new Error("Request address error");
			}
			return returnValue;
		}*/
		
		/**
		 * Access to the module url
		 */
		/*public function getModuleUrl(moduleName:String):Object
		{
			var returnValue:Object = new Object();
			if(data != null)
			{
				returnValue["url"] = data.moduleList.module.(@name==moduleName).@url;
				returnValue["statusText"] = data.moduleList.module.(@name==moduleName).@statusText;
				returnValue["size"] = data.moduleList.module.(@name==moduleName).@size;
			}
			
			if(returnValue == "")
			{
				throw new Error("Module address error"+moduleName);
			}
			return returnValue;
		}*/
		
		public function getHelper(index:String):String
		{
			var subData:XMLList = data.helperList[index];
			var st:String = subData.toString();
			return st;
		}
		
		public function getTutorial(index:String):String
		{
			var subData:XMLList = data.tutorial[index];
			var st:String = subData.toString();
			var tg:Array = st.split("/");
			var result:String = new String();
			for (var i:int = 0; i < tg.length; i++ )
			{
				result += (getHelper(tg[i]) + "/");
			}
			return result;
		}
		
		
		/*public function getLakeInfo(id:String, index:int):Object
		{
			var subData:XMLList = data.lakeList.listname.lake.(Id == id)["level" + (index + 1)];
			var _o:Object = new Object();
			
			_o["capacity"] = subData.totalfish.toString();
			_o["gold"] = subData.money.toString();
			_o["ExpGet"] = subData.exp.toString();
			_o["levelRequire"] = subData.levelrequire.toString();
			_o["DirtyTime"] = subData.dirtytime.toString();
			// nhung thu can trong shop
			_o[ConfigJSON.KEY_ID] = id;
			_o[ConfigJSON.KEY_NAME] = "";
			_o["xu"] = subData.zmoney.toString();
			_o["type"] = "Lake";
			_o["IsNew"] = false;
			
			return _o;
		}		*/
		
		/*public function getLakeList():Array
		{
			var subData:XMLList = data.lakeList.listname.lake;
			var _l:int = subData.length();
			var _a:Array = [];
			var tg:XML;
			for (var i:int = 0; i < _l; i++)
			{
				var _b:Array = [];
				var _o:Object = new Object();
				_o[ConfigJSON.KEY_ID] = subData[i].Id;
				_o["NumLevel"] = subData[i].children().length()-1;
				_o["type"] = "Lake";
				_a.push(_o);
			}
			return _a;
		}*/
		
		/*public function getGiftInfo(Id: String):Object 
		{
			var _o: Object = new Object();
			var subData:XMLList = data.itemList.listname.(name == "Gift").item.(id == Id);		
			_o[ConfigJSON.KEY_ID] = Id;
			_o["type"] = subData.type;
			_o["typeid"] = subData.typeid;
			_o["levelrequire"] = subData.levelrequire;
			return _o;
		}*/
		
		public function getGeneralInfo(name:String, id:String):int
		{
			var result:int;
			result = data.GeneralInfo[name][id];
			return result;
		}		
		
		/*public function getMoneyPocket(typeFish:String, para:String):Number
		{
			var result:Number;
			var SubData:XMLList = data.itemList.listname.(name == "MoneyPocket").item.(type == typeFish);
			result = SubData[para];
			return result;
		}*/
		
		/*public function getEnergyInfo(id:String):int
		{
			var result:int;
			var SubData:XMLList = data.itemList.listname.(name == "Energy");
			result = SubData[id];
			return result;
		}*/
		
		/*public function getActionExp(id:String):int
		{
			var result:int;
			var SubData:XMLList = data.itemList.listname.(name == "Experience");
			result = SubData[id];
			return result;
		}*/
		
		/*public function getMaxEnergy(level:int):int
		{
			var result:int;
			var SubData:XMLList = data.itemList.listname.(name == "MaxEnergy");
			result = SubData["maxenergy" + level];
			return result;
		}*/
		
		
		
		/*public function getConstantInfo(id:String):int
		{
			var result:int;
			var SubData:XMLList = data.itemList.listname.(name == "Param");
			result = SubData[id];
			return result;
		}*/
		
		/*public function getEggTime(type:int):int 
		{
			var time:int = data.itemList.listname.(name == "Fish").item.(id == type).growing.growing0;		
			return -time;
		}*/
		
		/*public function getUserLevelExp(level:int):int
		{
			var subData:XMLList = data.itemList.listname.(name == "UserLevel");
			var st:String = subData["userlevel" + level];
			
			var exp:int;
			if (st != "")
			{
				exp = subData["userlevel" + level];
			}
			else
			{
				exp = -1;
			}
			return exp;
		}*/
		
		/*public function getCurLevelList(level:int):Array
		{
			var i:int;
			var subData:XMLList;
			var List:Array = ["Fish", "Other", "OceanAnimal", "OceanTree", "MixLake"];
			var _a:Array = [];
			var _b:Array = [];
			
			for (i = 0; i < List.length; i++)
			{
				_b = getItemListByLevel(List[i], level);
				_a = _a.concat(_b);
			}

			
			return _a;
		}
		
		public function getItemListByLevel(ListName:String, level:int):Array
		{
			var subData:XMLList = data.itemList.listname.(name == ListName).item;
			var tg:int;
			var _l:int = subData.length();
			var _a:Array = [];
			for (var i:int = 0; i < _l; i++)
			{
				if (subData[i].levelrequire == level)
				{
					var _o:Object = new Object();
					_o[ConfigJSON.KEY_ID] = String(subData[i].id);
					_o["type"] = ListName;
					_o[ConfigJSON.KEY_NAME] = Localization.getInstance().getString(ListName + String(subData[i].id));
					if (ListName == "New")
					{
						_o["type"] = String(subData[i].type);
					}
					switch (ListName)
					{
						case "Fish":
						case "Other":
						case "OceanAnimal":
						case "OceanTree":
						case "MixLake":
							tg = subData[i].unlocktype;
							if (tg > 1)
							{
								continue;
							}
							break;
					}
					_a.push(_o);
				}
			}
			
			
			return _a;
		}*/
		
		/*public function getFishHarvest(FishTypeID:String):int
		{
			var time:int = data.itemList.listname.(name == "Fish").item.(id == FishTypeID).growing.growing5;				
			return time;
			
		}*/
		
		/*public function getFishBonus(ID:String, colorLevel:int):int
		{
			var subData:XMLList = data.itemList.listname.(name == "Fish").item.(id == ID);
			var bonus:int = subData["moneycolor" + colorLevel];
			var result:int = bonus;// * 100 / subData["maxvalue"];
			return result;
		}*/
		
		/*public function getFishMaterial(ID:int):Object
		{
			var subData:XMLList = data.itemList.listname.(name == "Fish").item.(id == ID);
			var _o:Object = new Object();
			_o["type"] = subData["materialtype"];
			_o["require"] = subData["materialnum"];
			return _o;
		}*/
		
		/*public function getItemInfo(ID:String, Type:String):Object
		{
			var _o:Object = new Object();
			if ((Type == "Money") || (Type == "ZMoney") || (Type == "Material"))
			{
				_o["type"] = Type;
				_o[ConfigJSON.KEY_ID] = ID;
				if (Type == "Material")
				{
					_o[ConfigJSON.KEY_NAME] = Localization.getInstance().getString(Type + ID);
				}
				return _o;
			}

			var subData:XMLList = data.itemList.listname.(name == Type).item.(id == ID);		
			
			
			_o[ConfigJSON.KEY_ID] = ID;
			_o[ConfigJSON.KEY_NAME] = Localization.getInstance().getString(Type + ID); //subData.name;
			_o["gold"] = subData.money.toString();
			_o["xu"] = subData.zmoney.toString();
			_o["levelRequire"] = subData.levelrequire.toString();
			_o["type"] = Type;
			_o["IsNew"] = false;
			_o["UnlockType"] = subData.unlocktype.toString();
			
			if (data.itemList.listname.(name == "New").item.(type == Type).(id == ID).length() > 0)
			{
				_o["IsNew"] = true;
			}
			
			switch (Type)
			{
				case "Fish":					
					_o["HarvestTime"] = subData.growing.growing5.toString();
					_o["MoneyGet"] = subData.maxvalue.toString();
					_o["ExpGet"] = subData.exp.toString();
					_o["EatedSpeed"] = subData.eatedspeed.toString();
					_o["Terms"] = 4;
					_o["version"] = subData.version.toString();
					_o["pricegift"] = subData.pricegift.toString();
					break;
				
				case "Other":
					_o["ExpGet"] = subData.exp.toString();
					_o["version"] = subData.version.toString();
					break;
				
				case "OceanAnimal":
					_o["ExpGet"] = subData.exp.toString();
					_o["version"] = subData.version.toString();
					break;
				
				case "OceanTree":
					_o["ExpGet"] = subData.exp.toString();
					_o["version"] = subData.version.toString();
					break;
				
				case "Food":
					_o["Numb"] = subData.num.toString();
					break;
					
				case "New":
					break;
				case "Gift":				
					break;
					
				case "LakeUnlock":
					_o["ExpGet"] = subData.exp.toString();
					break;
				case "LakeUpgrade":
					_o["ExpGet"] = subData.exp.toString();
					break;
					
				case "MixLake":
					_o["Exp"] = subData.exp.toString();
					_o["ZMoney"] = subData.zmoney.toString();
					_o["Cooldown"] = subData.resettime.toString();
					_o["Expire"] = subData.timeuse.toString();
					_o["version"] = subData.version.toString();
					break;
				case "LevelMixLake":
					_o["Exp"] = subData.exp.toString();
					_o["MaxFishLevel"] = subData.limitlevelfish.toString();
					break;
				case "EnergyItem":
					_o["num"] = subData.num.toString();
					break;
				default:
					return null;
					break;
			}
			return _o;
		}*/
		
		/*public function getItemList(ListName:String):Array
		{
			var _a:Array = [];
			var _b:Array = [];
			
			switch(ListName)
			{
				case "Fish":					
				case "Other":
				case "OceanAnimal":
				case "OceanTree":
				case "Food":
				case "New":
				case "Gift":
				case "MixLake":
					_a = GetList(ListName);
					break;
					
				case "Special":
					// level mixlake
					_b = GetList("LevelMixLake");
					_a = _a.concat(_b);
					// lake upgrade
					_b = GameLogic.getInstance().user.GetUpgradeLakeList();
					_a = _a.concat(_b);
					//lake unlock
					_b = GameLogic.getInstance().user.GetUnlockLakeList();
					_a = _a.concat(_b);
					// mix lake
					_b = GetList("MixLake");
					_a = _a.concat(_b);
					break;
			}
			
			return _a;
		}
		
		private function GetList(ListName:String):Array
		{
			var subData:XMLList = data.itemList.listname.(name == ListName).item;
			
			var _l:int = subData.length();
			var _a:Array = [];
			for (var i:int = 0; i < _l; i++)
			{
				var _o:Object = new Object();
				_o[ConfigJSON.KEY_ID] = subData[i].id.toString();
				_o["type"] = ListName;
				if (ListName == "New")
				{
					_o["type"] = subData[i].type.toString();
				}
				_a.push(_o);
			}
			
			
			return _a;
		}*/
		
		/*public function getListName(ListName:String):XMLList
		{
			var subData:XMLList = data.itemList.listname.(name == ListName);
			return subData;
		}*/
		
		/*public function GetTimeIntervalPeriod(ID:String, Period:int):int
		{
			var time:int = 0;
			var obj:Object = new Object();
			var subData:XMLList = data.itemList.listname.(name == "Fish").item.(id == ID);	
			obj["1"]= subData.growing["growing" + Period];
			obj["2"] = subData.growing["growing" + (Period + 1)];
			time = obj["2"] - obj["1"];
			return time;
		}*/
		
		/*public function GetTimePeriod(ID:String, Period:int):int
		{
			var time:int = 0;
			var obj:Object = new Object();
			var subData:XMLList = data.itemList.listname.(name == "Fish").item.(id == ID);	
			obj["1"] = subData.growing["growing" + (Period + 1)];
			time = obj["1"];
			return time;
		}*/
		
		/*public function GetMoneyPeriod(ID:String, Period:int):Number
		{
			var price:Number = 0;
			var subData:XMLList = data.itemList.listname.(name == "Fish").item.(id == ID);	
			price = subData.periodvalue["periodvalue" + (Period-1)];
			return price;
		}*/
		
		public function getDataUrl():String
		{
			if (Constant.OFF_SERVER)
			{
				//return BaseURL + data.dataUrl.@url
				return "file://C:/Documents and Settings/minht2/Desktop/My Dropbox/ZingFish/bin/";
				//return "../bin/";
			}
			if (ResMgr.UseMd5)
			{
				//return BaseURL + data.dataUrlMD5.@url;
				return ResMgr.getInstance().DataUrl + data.dataUrlMD5.@url;
			}
			return ResMgr.getInstance().DataUrl + data.dataUrl.@url;
		}
		
		public function GetBaseConttentSize():int
		{
			return data.baseContent.@size;
		}
		
		public function GetBaseConttentNum():int
		{
			return data.baseContent.@Num;
		}
		
		public function GetBaseConttentName(id:int):String
		{
			//if (ResMgr.UseMd5)
			//{
				//return data.baseContentMD5.@name;
			//}
			var name:String = "name" + id;
			return data.baseContent[name];
		}
		
		public function GetBgMusic(mode:int = 1):String
		{
			switch (mode)
			{
				case SoundMgr.MUSIC_NORMAL:
					return data.bgMusic.@name;
				case SoundMgr.MUSIC_WAR:
					return data.bgMusicWar.@name;
			}
			return data.bgMusic.@name;
		}
		
		public function getSoundList():Array
		{			
			var _s:String = ResMgr.getInstance().DataUrl;			
			var _a:Array = [];
			var _l:int = data.soundList.data.sound.length();
			if (data != null)
			{
				for (var i:int = 0; i < _l; i++)
				{
					var _b:Array = [];
					var _n:String = _s + data.soundList.data.@url + data.soundList.data.sound[i].@id + SoundMgr.EXT;
					var id:String = data.soundList.data.sound[i].@id;
					var size:int = data.soundList.data.@size;
					var _l1:int = data.soundList.data.sound.length();					
					var _o:Object = new Object();
					
					_b.push(id);
					_o["url"] = _n;
					_o["state"] = "notLoad";
					_o["size"] = size;
					_o["res"] = _b;						
					_a.push(_o);
				}
			}
			return _a;
		}
		
		
		
		/*public function getDataFish():Array
		{
			var _a:Array = [];
			if(data != null)
			{
				var _l:int = data.fishList.fish.length();
				for(var i:int = 0;i<_l;i++)
				{
					var _o:Object = new Object();
					_o[ConfigJSON.KEY_NAME] = data.fishList.fish[i].name.@value;
					_o["xp"] = data.fishList.fish[i].xp.@value;
					_o["gold"] = data.fishList.fish[i].price.@value;
					_o["harvestTime"] = data.fishList.fish[i].harvestTime.@value;
					_a.push(_o);
				}
			}
			
			//if(_a.length == 0){ throw new Error("Module address error"+moduleName); }
			return _a;
		}
		*/
		/**
		 * 	Access to the module of all swf's url
		 */
		/*public function getMaterialUrl(moduleName:String):Array
		{
			var _a:Array = [];
			if(data != null)
			{
				var _l:int = data.moduleList.module.(@name==moduleName).material.length();
				for(var i:int = 0;i<_l;i++)
				{
					var _n:String = data.moduleList.module.(@name==moduleName).material[i].@url;
					var _t:String = data.moduleList.module.(@name==moduleName).material[i].@statusText;
					var _s:String = data.moduleList.module.(@name==moduleName).material[i].@size;
					var _o:Object = new Object();
					_o["url"] = _n;
					_o["statusText"] = _t;
					_o["size"] = _s;
					_a.push(_o);
				}
			}
			
			//if(_a.length == 0){ throw new Error("Module address error"+moduleName); }
			return _a;
		}*/
		
		/*public function getSizeOfMaterials():String {
			return data.moduleList.module.@size;
		}*/
		
		/**
		 * 	socket request address
		 */
		/*public function getHost():String
		{
			var returnValue:String = "";
			if(data != null)
			{
				returnValue = data.security.@host;
			}
			return returnValue;
		}*/
		
		/**
		 * socket request port
		 */
		/*public function getPort():int
		{
			var returnValue:int = 9999;
			if(data != null)
			{
				returnValue = data.security.@port;
			}
			return returnValue;
		}*/
		
	}
}