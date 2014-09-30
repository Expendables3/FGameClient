package  Data
{
	import com.adobe.serialization.json.JSON;
	import com.greensock.easing.Quad;
	import flash.text.engine.EastAsianJustifier;
	import flash.utils.getQualifiedClassName;
	import GUI.FishWorld.GUIMixFormulaInfo;
	import GUI.GUIShop;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import Logic.Ultility;
	/**
	 * ...
	 * @author ducnh
	 */
	public class ConfigJSON
	{
		public static const KEY_NAME:String = "Name";
		public static const KEY_ID:String = "Id";
		
		private static var instance:ConfigJSON;
		private var InfoList:Object;
		public static var maxUserLevel:int = 0;		
		private var maxEnergyArr:Array = new Array();
		private var bonusEnergy:int = 0;
		
		/**
		 * quản lý config thông tin về các đối tượng (fish, decorate) như (id, version, price...)
		 * <br>Thể hiện này mang tính chất gần như 1 biến toàn cục </br>
		 */
		public static function getInstance(data:Object = null):ConfigJSON
		{
			if(instance == null)
			{
				instance = new ConfigJSON(data);
			}
			return instance;
		}
		
		public function ConfigJSON(data:Object) 
		{
			InfoList = JSON.decode(data as String);
			//InfoList["Icon"]["1"]["UnlockType"]=1;
			//Lưu config maxengery vào 1 mảng
			for (var i:String in InfoList["MaxEnergy"]) 
			{
				maxEnergyArr.push(InfoList["MaxEnergy"][i]);				
			}
			maxEnergyArr.sort(Array.CASEINSENSITIVE | Array.NUMERIC);
			
			//Lưu config phần bonus energy khi có máy tăng giới hạn năng lượng
			bonusEnergy = InfoList["Param"]["EnergyMachine"];
			
			getMaxUserLevel();
			//addConfig();			
		}
		
		public function GetItemList(type: String): Object
		{
			return InfoList[type];
		}
		
		public function getItemInfo(type:String, id:int = -1):Object
		{
			var obj:Object;
			if (id == -1)
			{
				obj = InfoList[type];
			}
			else if(InfoList[type] != null)
			{
				obj = InfoList[type][id];
			}
			
			if (obj == null)
			{
				obj = new Object();
			}
			
			//Gán Name, type, Id
			switch(type)
			{
				case "Money":
					obj["type"] = type;
					obj["Id"] = id;
					obj["Name"] = "Vàng";
					break;
				case "ZMoney":
					obj["type"] = type;
					obj["Id"] = id;
					obj["Name"] = "Xu";
					break;
				case "Exp":
					obj["type"] = type;
					obj["Id"] = id;
					obj["Name"] = "Kinh nghiệm";
					break;
				case "Medicine":
					obj["type"] = type;
					obj["Id"] = id;
					obj["Name"] = "Thuốc tăng trưởng";
					break;
				case "Draft":
				case "Paper":
				case "GoatSkin":
				case "Blessing":
					obj = InfoList["MixFormula"][type][id.toString()];
					obj["Name"] = Localization.getInstance().getString(type) + " - "  + GUIMixFormulaInfo.getElementsName(id);
					obj["type"] = type;
					obj["Id"] = id;
					break;
				case "Samurai":
				case "Resistance":
				case "BuffExp":
				case "BuffMoney":
				case "BuffRank":
				case "StoreRank":
					obj = InfoList["BuffItem"][type][id.toString()];
					obj["type"] = type;
					obj["Id"] = id;
					obj["Count"] = 1;
					obj["Name"] = Localization.getInstance().getString(type + id).split("\n")[0];
					break;
				case "HireFish":
					obj = InfoList["MixFormula"]["Rent"][id.toString()];
					obj["Name"] = "Thích sát ngư";
					obj["Id"] = id;
					obj["type"] = type;
					break;
				case "Ticket":
					obj["type"] = type;
					obj["Id"] = id;
					obj["Name"] = "Sò";
					break;
				case "GiftTicket":
					obj["type"] = type;
					obj["Id"] = id;
					obj["Name"] = "Sò được tặng";
					break;
				case "Event_8_3_Flower":
					obj["type"] = type;
					obj["Id"] = id;
					obj["Name"] = Localization.getInstance().getString(type + "_Name" + id);
					break;
				case "Sea":
					for (var s:String in obj)
					{
						if (getQualifiedClassName(obj[s]) != "Object")
						{
							break;
						}
						obj[s][KEY_ID] = s;
						obj[s]["type"] = type;
					}
					break;
				case "EventDiscount":
					break;
				
				default:
					if (id != -1)
					{
						obj["type"] = type;
						obj["Id"] = id;
						obj["Name"] = Localization.getInstance().getString(type + id);
					}
					if (type == "BirthDayItem")
					{
						obj["type"] = type;
						obj["Id"] = id;
						var strName:String;
						switch(id)
						{
							case 1:
								strName = "Kẹo xanh";
							break;
							case 2:
								strName = "Kẹo đỏ";
							break;
							case 3:
								strName = "Kẹo tím";
							break;
							case 10:
								strName = "Mũ giấy";
							break;
							case 11:
								strName = "Bong bóng";
							break;
							case 12:
								strName = "Kèn giấy";
							break;
							case 13:
								strName = "Thiệp mừng";
							break;
							case 14:
								strName = "Điểm ước muốn";
							break;
							
						}
						obj["Name"] = strName;
					}
					break;
			}			
			
			return obj;
		}
		
		public function getHireFish(type:String, id:int, subtype:String):Object
		{
			var obj:Object = new Object();
			
			for (var s:String in InfoList["MixFormula"][subtype][id.toString()])
			{
				if (s == "LevelRequire")
				{
					obj[s] = 7;
				}
				else if (s != "Money" && s != "ZMoney")
				{
					obj[s] = InfoList["MixFormula"][subtype][id.toString()][s];
				}
				else
				{
					if (InfoList["Soldier"][subtype][id.toString()][s])
					{
						obj[s] = InfoList["Soldier"][subtype][id.toString()][s];
					}
					else
					{
						obj[s] = 0;
					}
				}
			}
			//obj = InfoList["MixFormula"][subtype][id.toString()];
			obj[KEY_NAME] = "Võ Lâm Ngư";
			obj[KEY_ID] = id;
			obj["type"] = type;
			obj["subtype"] = subtype;
			return obj;
		}
		
		private function getMaxUserLevel():void
		{
			var obj:Object = InfoList["UserLevel"];
			maxUserLevel = 0;
			for (var s:String in obj) 
			{
				maxUserLevel++;
			}
			// hardcode for future
			maxUserLevel = 500;
		}
		
		
		public function getSuperFishInfo(type:String):Object
		{
			var obj:Object = new Object();
			obj = InfoList["SuperFish"][type];
			obj["Id"] = type;
			obj["type"] = "SuperFish";
			return obj;
		}
		
		public function GetItemDamageFishSoldier(type:String, idType:int):Object
		{
			var obj:Object = InfoList["Damage"][type][idType.toString()] as Object;
			return obj["Damage"];
			/*var arr:Array = new Array();
			for (var i:String in obj) 
			{
				arr.push(int(i));
			}
			return arr;	*/	
		}
		
		/**
		 * cái hàm này nhằm bổ sung những thuộc tính bị thiếu của config
		 */
		private function addConfig():void
		{
			var i:int;
			var objList:Object;
			var obj:Object;
			
			for (var type:String in InfoList)
			{
				objList = InfoList[type];
				if (getQualifiedClassName(objList) != "Object")
				{
					continue;
				}
				for (var s:String in objList)
				{
					obj = objList[s];
					if (getQualifiedClassName(obj) != "Object")
					{
						break;
					}
					obj[KEY_ID] = s;
					obj["type"] = type;
					if (type != "Gift")
						obj[KEY_NAME] = Localization.getInstance().getString(type + s);
				}
			}
		}
		
		
		public function getEnergyInfo(id:String):int
		{
			var result:int;
			result = InfoList["Energy"][id];

			if (GameLogic.getInstance().isMonday())//thứ 2 vui vẻ
			{
				if (id != "cleanlake" && id != "carefriendfish")
				{
					result = InfoList["HappyWeekDay"]["1"]["energy"];
				}
			}
			return result;
		}
		
		public function getFishHarvest(FishTypeID:int, FishType:int, fish:Fish, isAgeTime:Boolean = false):int
		{
			var time:int;
			time = getItemInfo("Fish", FishTypeID)["Growing"][5];	
			if (isAgeTime) 
			{
				time = getItemInfo("Fish", FishTypeID)["LevelUpTime"] * 3600;		
			}
			return time;
		}
		
		public function getEggTime(type:int):int 
		{
			var time:int = getItemInfo("Fish", type)["Growing"][0];				
			return -time;
		}
		
		public function getActionExp(id:String):int
		{
			var result:int;
			result = InfoList["Experience"][id];
			return result;
		}
		
		public function getMaxEnergy(level:int):int
		{
			var result:int;
			result = maxEnergyArr[level - 1];// InfoList["MaxEnergy"][level];
			if (GameLogic.getInstance().user.GetMyInfo().hasMachine)	//hiepnm2: nếu mà user có máy nlg
			{
				if(GameLogic.getInstance().user.GetMyInfo().IsExpiredMachine)	//nếu máy nlg của user đã hết xăng hoặc chưa đổ xăng
					return result;
				else
					return result + bonusEnergy;//InfoList["Param"]["EnergyMachine"];
			}
			else
			{
				return result;
			}			
		}
		
		public function getUserLevelExp(level:int):int
		{
			var obj:Object = getItemInfo("UserLevel", level);
			var exp:int = 0;
			if(obj)
			{
				exp = obj["NextExp"] as int;			
			}
			return exp;
		}
		
		public function GetTimeIntervalPeriod(ID:int, Period:int):int
		{
			var time:int = 0;
			var obj:Object = new Object();
			obj["1"]= getItemInfo("Fish", ID)["Growing"][Period];		
			obj["2"] = getItemInfo("Fish", ID)["Growing"][Period + 1];
			time = obj["2"] - obj["1"];
			return time;
		}
		
		public function GetTimePeriod(ID:int, Period:int):int
		{
			var time:int = 0;
			time = getItemInfo("Fish", ID)["Growing"][Period + 1];
			return time;
		}
		
		public function GetMoneyPeriod(ID:int, Period:int):Number
		{
			var price:Number = 0;
			price = getItemInfo("Fish", ID)["PeriodValue"][(Period - 1)];
			return price;
		}
		
		public function getItemList(ListName:String):Array
		{
			var a:Array = [];
			var b:Array = [];
			
			switch(ListName)
			{
				case "Special":
					//Thuốc hồi sinh
					b = GetList("RebornMedicine");
					a = a.concat(b);
					//energymachine
					b = GetList("EnergyMachine");
					a = a.concat(b);
					//viagra
					b = GetList("Viagra");
					a = a.concat(b);
					//PETROL
					b = GetList("Petrol");
					a = a.concat(b);	
					//thức ăn					
					b = GetList("Food");
					a = a.concat(b);
					//level mixlake
					b = GetList("LevelMixLake");
					a = a.concat(b);
					//lake upgrade
					//b = GameLogic.getInstance().user.GetUpgradeLakeList();
					//a = a.concat(b);
					//lake unlock
					//b = GameLogic.getInstance().user.GetUnlockLakeList();
					//a = a.concat(b);
					//mix lake
					b = GetList("MixLake");
					a = a.concat(b);	
					//Giấy phép hồ
					b = GetList("License");
					a = a.concat(b);
					//Năng lượng
					b = GetList("EnergyItem");
					a = a.concat(b);
					//Nguyen lieu
					b = GetList("Material");
					a = a.concat(b);				
					b = GetList("GodCharm");
					a = a.concat(b);
					break;
				case "Event":
					a = GetList("Icon");
					break;
				case "Fish":
					a = GetFish("Fish", false);
					break;
				case "New":
				case "FishGift":
				case "Other":
				case "OceanAnimal":
				case "OceanTree":
				case "Food":				
				case "Gift":
				case "MixLake":
				case "SuperFish":
					a = GetList(ListName);
					break;
				/*case "Draft":
				case "Paper":
				case "GoatSkin":
				case "Blessing":
					a = GetMixFormulaDraft(ListName);
					break;*/
				case "HireFish":
					a = GetFish("Fish", true);
					break;
				case "Support":
					// Thuốc hồi sức
					b = GetList("RecoverHealthSoldier");
					a = a.concat(b);
				
					// Thuốc hồi sinh khỏe cá
					b = GetList("Ginseng");
					a = a.concat(b);
					
					// Các item buff
					b = GetBuffList();
					a = a.concat(b);
					break;
				case "Helmet":
				case "Armor":
				case "Weapon":
					b = GetEquipList(ListName);
					a = a.concat(b);
					break;
				case "Formula":
					a = GetMixFormulaDraft("Draft");
					a = a.concat(GetMixFormulaDraft("Paper"));
					a = a.concat(GetMixFormulaDraft("GoatSkin"));
					a = a.concat(GetMixFormulaDraft("Blessing"));
					break;
				default:
					a = GetList(ListName);
					break;
			}
			
			return a;
		}
		
		private function GetList(ListName:String):Array
		{
			var a:Array = [];
			for (var i:String in InfoList[ListName])
			{
				var o:Object = new Object();
				o[KEY_ID] = i;
				o["type"] = ListName;
				o["LevelRequire"] = InfoList[ListName][i]["LevelRequire"];
				a.push(o);
			}		
			return a;
		}
		
		private function GetEquipList(ListName:String):Array
		{
			ListName = "Wars_" + ListName;			
			var a:Array = [];
			
			for (var id:String in InfoList[ListName])
			{
				for (var color:String in InfoList[ListName][id])
				{
					if (color == "Id" || color == "Name" || color == "type")	continue;
					
					var o:Object = new Object();
					//o[KEY_ID] = InfoList[ListName][id][color].Element + "$" + color;
					o[KEY_ID] = id + "$" + color;
					o["type"] = ListName.split("_")[1];
					o["LevelRequire"] = 7;
					a.push(o);
				}
			}
			return a;
		}
		
		private function GetBuffList():Array
		{
			var a:Array = [];
			for (var i:String in InfoList["BuffItem"])
			{
				var j:int = 1;
				while (InfoList["BuffItem"][i][String(j)])
				{
					var o:Object = new Object();
					o[KEY_ID] = i + "_" + j;
					o["type"] = "BuffItem";
					o["LevelRequire"] = InfoList["BuffItem"][i][j]["LevelRequire"];
					a.push(o);
					j++;
				}
			}
			return a;
		}
		
		/**
		 * Hàm lấy cấu hình các item hỗ trợ cá lính từ config
		 * @param	type	Samurai, Resisstance, BuffMoney...
		 * @param	id
		 * @return
		 */
		public function GetBuffItemInfo(type:String, id:int):Object
		{
			InfoList["BuffItem"][type][id]["type"] = "BuffItem";
			InfoList["BuffItem"][type][id]["subtype"] = type;
			return InfoList["BuffItem"][type][id];
		}
		
		/**
		 * Hàm lấy cấu hình đồ đạc cá từ config
		 * @param	type	Helmet, Armor, Weapon
		 * @param	id		Rank$Color
		 * @return
		 */
		public function GetEquipmentInfo(type:String, id:String):Object
		{
			var a:Array = id.split("$");		// a[0] là id, a[1] là color
			InfoList["Wars_" + type][a[0]][a[1]]["type"] = type;
			InfoList["Wars_" + type][a[0]][a[1]]["subtype"] = id;
			
			return InfoList["Wars_" + type][a[0]][a[1]];
		}
		
		private function GetFish(ListName:String, isSoldierFish:Boolean = true):Array
		{
			var a:Array = [];
			var i:String;
			var o:Object;
			if (isSoldierFish)
			{
				for (i in InfoList["Soldier"])
				{
					for (var j:String in InfoList["Soldier"][i])
					{
						if (getQualifiedClassName(InfoList["Soldier"][i][j]) == "Object")
						if (InfoList["Soldier"][i][j].UnlockType == GUIShop.UNLOCK_TYPE_LEVEL)
						{
							if (InfoList["Soldier"][i][j].UnlockType == GUIShop.UNLOCK_TYPE_LEVEL)
							{
								o = new Object();
								//o[KEY_ID] = int(i);
								o[KEY_ID] = j;
								o["type"] = "HireFish";
								o["subtype"] = i;
								//o["type"] = i;
								o["Money"] = InfoList["Soldier"][i][j].Money;
								
								//o["LevelRequire"] = InfoList["MixFormula"]["Draft"][i]["LevelRequire"];
								a.push(o);
							}
						}
					}
				}
			}
			else
			{
				for (i in InfoList[ListName])
				{
					if (InfoList[ListName][i]["Id"] < Constant.FISH_TYPE_START_SOLDIER)
					{
						o = new Object();
						o[KEY_ID] = i;
						o["type"] = ListName;
						o["LevelRequire"] = InfoList[ListName][i]["LevelRequire"];
						a.push(o);
					}
				}
			}
			return a;
		}
		
		private function GetMixFormulaDraft(ListName:String):Array
		{
			var a:Array = [];
			var param:Array = ListName.split("_");
			var objList:Object = InfoList["MixFormula"][param[param.length - 1]];
			for (var i:String in objList)
			{
				if (i != "Id" && i != "Name" && i != "type")
				{
					var o:Object = new Object();
					o[KEY_ID] = i;
					o["type"] = param[param.length - 1];
					o["element"] = GUIMixFormulaInfo.getElementsName(objList[i]["Elements"]);
					o["kind"] = i;
					o["LevelRequire"] = objList[i]["LevelRequire"];
					a.push(o);
				}
			}		
			return a;
		}
		
		public function GetSoldierEventConfig(type:String, id:int = -1):Object
		{
			if (id == -1)
			{
				return InfoList["SoldierEvent"][type];
			}
			else
			{
				return InfoList["SoldierEvent"][type][String(id)];
			}
		}
		
		public function getEventInfo(eventName:String = ""):Object
		{
			if (eventName == "")
			{
				return InfoList["Event"];
			}
			return InfoList["Event"][eventName];
		}
		
		public function getFishBonus(ID:int, colorLevel:int):int
		{
			var result:int = getItemInfo("Fish", ID)["MoneyColor" + colorLevel];
			return result;
		}
		
		public function getConstantInfo(id:String):int
		{
			var result:int;
			result = InfoList["Param"][id];
			return result;
		}
		
		public function getGiftInfo(Id: String):Object 
		{
			var _o: Object = new Object();
			var subData:Object = InfoList["Gift"][Id];
			_o[KEY_ID] = Id;
			_o["type"] = subData["ItemType"];
			_o["typeid"] = subData["ItemId"];
			_o["levelrequire"] = subData["LevelRequire"];
			return _o;
		}
		
		public function getLakeList():Array
		{
			var subData:Object = InfoList["Lake"];
			var a:Array = [];
			for (var i:String in subData)
			{
				var o:Object = new Object();
				o[KEY_ID] = i;
				var count:int = 0;
				for (var j:String in subData[i]) 
				{
					if(!isNaN(parseInt(j)))
					{
						count++;
					}
				}
				o["NumLevel"] = count;
				o["type"] = "Lake";
				a.push(o);
			}
			return a;
		}
		
		
		public function getCurLevelList(level:int):Array
		{			
			var List:Array = ["Fish", "Other", "OceanAnimal", "OceanTree", "MixLake"];
			var a:Array = [];
			var b:Array = [];
			
			for (var i:int = 0; i < List.length; i++)
			{
				b = getItemListByLevel(List[i], level);
				a = a.concat(b);
			}
			
			return a;
		}
		
		private function getItemListByLevel(ListName:String, level:int):Array
		{
			var subData:Object = InfoList[ListName];
			var tg:int;
			var a:Array = [];
			for (var i:String in subData)
			{
				if (subData[i]["LevelRequire"] == level)
				{
					var o:Object = new Object();
					o[KEY_ID] = i;
					o["type"] = ListName;
					o[KEY_NAME] = Localization.getInstance().getString(ListName + i);
					if (ListName == "New")
					{
						o["type"] = subData[i]["type"];
					}
					switch (ListName)
					{
						case "Fish":
						case "Other":
						case "OceanAnimal":
						case "OceanTree":
						case "MixLake":
							tg = subData[i]["UnlockType"];
							if (tg > 1)
							{
								continue;
							}
							break;
					}
					a.push(o);
				}
			}
			
			
			return a;
		}
		
		
		public function GetDailyQuest(ID:int, level:int):QuestInfo
		{
			var quest:QuestInfo = new QuestInfo;
			
			var step:int = int( (level-1)/ 5) + 1;
			var subData:Object = getItemInfo("DailyQuest", step)[ID];
			quest.SetInfo(subData);
			quest.QuestType = QuestInfo.QUEST_DAILY;
			
			// task			
			var taskData:Object = subData["Task"];
			var task:TaskInfo = new TaskInfo;
			task.SetInfo(taskData);
			task.MaxNum = taskData["Num"];
			quest.AddTask(task);	
			
			return quest;
		}
		
		public function GetDailyQuestNew(arr:Array, level:int):QuestInfo
		{
			var quest:QuestInfo = new QuestInfo;
			var step:int = int((level - 1) / 5) +1;
			step = Math.min(21, step);//Harccode do step max nhất trong json là 21
			
			for (var i:int = 0; i < arr.length; i++)
			{
				var subData:Object = getItemInfo("DailyQuest", step)[arr[i].Id];
				quest.SetInfo(subData);
				quest.QuestType = QuestInfo.QUEST_DAILY_NEW;
				
				var task:TaskInfo = new TaskInfo;
				task.SetInfo(subData);
				if(subData != null)
				{
					task.MaxNum = subData["Num"];
				}
				quest.AddTask(task);
			}
			return quest;
		}
		
		/**
		 * 
		 * Hàm lấy giá trị config của DailyBonus
		 * @param	level	: Level user ở thời điểm nhận (?)
		 * @param	day		: Ngày combo
		 * @return
		 */
		public function GetDailyBonus(level:int, day:int):Object
		{
			var step:int = int((level - 1) / 10);
			step = Math.min(10, step);//Hard code vi max step trong Json la 10
			if (step == 0)
			{
				return InfoList["DayGift"]["1"][String(day)];
			}
			else
			{
				return InfoList["DayGift"][String(step)][String(day)];
			}
		}
		
		public function GetDailyQuestXu(level:int):Object
		{
			var step:int = int((level - 1) / 5) +1;
			step = Math.min(21, step);//Harccode do step max nhất trong json là 21
			return InfoList["XuDailyQuest"][String(step)];
		}
		
		public function GetLevelFish(level:int):int
		{
			var max:int = Constant.FISH_LEVEL_MAX_NOW;
			var returnNum:int = InfoList["FishIdFollowLevel"][String(level)];
			if (returnNum > max || returnNum == 0)	returnNum = max;
			return returnNum;
		}

		public function GetBuffItemList():Array
		{
			var order:Array = ["StoreRank", "BuffRank", "BuffMoney", "BuffExp", "Resistance", "Samurai"];
			var a:Array = [];
			var o:Object = InfoList["BuffItem"];
			for (var str:String in o)
			{
				for (var s:String in o[str])
				{
					if (getQualifiedClassName(o[str][s]) == "Object")
					{
						o[str][s]["Order"] = order.indexOf(str) * 10 + o[str][s].Id;
						o[str][s]["Type"] = str;
						a.push(o[str][s]);
					}
				}
			}
			return a;
		}
		
		/**
		 * Hàm trả về danh sách quà tặng hàng ngày của user
		 * @param	level	Level của user
		 * @return
		 */
		public function GetDailyQuestGiftNew(level:int):Object
		{
			//var step:int = int((level - 1) / 5) +1;
			if (level > 300) level = 300;//hard code để không bị crash
			return InfoList["DailyQuestGift"][level];
		}
		
		public function GetFishRankInfo(idRank:int = 0):Object
		{
			if (idRank == 0)
			{
				return InfoList["RankPoint"];
			}
			else
			{
				return InfoList["RankPoint"][String(idRank)];
			}
		}
		/*** thứ 2 vui vẻ*/
		public function getEnergyForAttack(idRank:int = 0):int
		{
			var cfg:Object = GetFishRankInfo(idRank);
			if (GameLogic.getInstance().isMonday())
			{
				return InfoList["HappyWeekDay"]["1"]["energy"];
			}
			else
			{
				return cfg["AttackEnergy"];
			}
		}
		public function getEnergyForFishWorld(id:String):int
		{
			var defaultEnergy:int = InfoList["Param"][id];
			if (GameLogic.getInstance().isMonday())
			{
				return InfoList["HappyWeekDay"]["1"]["energy"];
			}
			else
			{
				return defaultEnergy;
			}
		}
		/*****/
		public function GetBonusDailyQuest(idQuest:int, level:int, idBonus:int):QuestBonus
		{
			var bonus:QuestBonus = new QuestBonus;
			var step:int = int( (level-1)/ 5) + 1;
			var subData:Object = getItemInfo("DailyQuest", step)[idQuest]["Bonus"][idBonus];
			bonus.SetInfo(subData);
			return bonus;
		}
		
		public function GetSeriesQuest(IDSeries:int , IDQuest:int):QuestInfo
		{
			var quest:QuestInfo = new QuestInfo;
			var subData:Object = getItemInfo("SeriesQuest", IDSeries)["Quest"][IDQuest];
			quest.SetInfo(subData);
			quest.IdSeriesQuest = IDSeries;	
			quest.QuestType = QuestInfo.QUEST_SERIES;
			
			// task
			quest.TaskList.splice(0, quest.TaskList.length);
			var taskData:Object = subData["TaskList"];
			for (var i:String in taskData)
			{
				var task:TaskInfo = new TaskInfo;
				task.SetInfo(taskData[i]);
				task.MaxNum = taskData[i]["Num"];
				quest.AddTask(task);	
			}			
			
			return quest;
		}	
		
		public function GetSeriesQuestInfo(IDSeries:int, keyValue:String):Object
		{
			var obj:Object = getItemInfo("SeriesQuest", IDSeries)[keyValue];
			return obj;
		}
		
		public function getInfoRateMate(fishType:int, type:int):Object
		{
			var normal:int = 0;
			var special:int = 1;
			var rare:int = 2;
			var obj:Object = new Object();
			var rateUplv:Number = 0;
			var rateSpec:Number = 0;
			var rateRare:Number = 0;
			var f:Object = InfoList["MixFish"][fishType];
			
			var bonusSpecialOver:int = 0;
			var rSpecial_Special:int = 0;
			var rSpecial_Rare:int = 0;
			var bonusRareOver:int = 0;
			var rRare_Special:int = 0;
			var rRare_Rare:int = 0;
			bonusSpecialOver = (f["BonusSpecialOver"] == null) ? 0 : f["BonusSpecialOver"];
			rSpecial_Special = (f["RSpecial_Special"] == null) ? 0 : f["RSpecial_Special"];
			rSpecial_Rare = (f["RSpecial_Rare"] == null) ? 0 : f["RSpecial_Rare"];
			bonusRareOver = (f["BonusRareOver"] == null) ? 0 : f["BonusRareOver"];
			rRare_Special = (f["RRare_Special"] == null) ? 0 : f["RRare_Special"];
			rRare_Rare = (f["RRare_Rare"] == null) ? 0 : f["RRare_Rare"];
			switch(type)
			{
				case normal:
					rateUplv = f["RateOverMix"];
					break;
				case special:
					rateUplv = f["RateOverMix"] + bonusSpecialOver;
					rateSpec = rSpecial_Special;
					rateRare = rSpecial_Rare;
					break;
				case rare:
					rateUplv = f["RateOverMix"] + bonusRareOver;
					rateSpec = rRare_Special;
					rateRare = rRare_Rare;
					break;				
			}
			obj["Uplevel"] = rateUplv;
			obj["Special"] = rateSpec;
			obj["Rare"] = rateRare;
			
			return obj;
		}
		
		public function getUnlockedSlot(level:int):Array
		{
			var slot:int = 1;
			var arr:Array = [];
			var maxSlot:int = 0;
			for (var s:String in InfoList["LevelUnlockSlot"])
			{
				if (!isNaN(parseInt(s)) && InfoList["LevelUnlockSlot"][s]["LevelRequire"] <= level)
				{
					if(int(s) > slot)
					{
						slot = int(s);
					}
				}
				maxSlot++;
			}
			arr.push(maxSlot);
			arr.push(slot);
			return arr;
		}
		
		public function getOptionMaterial(level:int,type:int):Object
		{
			var lv:int = int((level - 1) / 10) * 10 + 1;
			if (level > Constant.FISH_LEVEL_MAX || level <= 0) 	
			{
				return null;
			}
			/*if (1 <= level && level < 11)
			{
				lv = 1;
			}
			else if (11 <= level && level < 21)
			{
				lv = 11;
			}
			else if (21 <= level && level < 31)
			{
				lv = 21;
			}
			else if (31 <= level && level < 41)
			{
				lv = 31;
			}
			else if (41 <= level)
			{
				lv = 41;
			}
			else
			{
				return null;
			}*/			
			var obj:Object = InfoList["RateOfMaterial"][lv][type];
			var o:Object = new Object();
			if(obj)
			{
				if(obj["RateOverLevel"])
				{
					o["RateOverLevel"] = Number(obj["RateOverLevel"]);
				}
				else
				{
					o["RateOverLevel"] = 0;
				}
				if(obj["RateSpecial"])
				{
					o["RateSpecial"] = Number(obj["RateSpecial"]);
				}
				else
				{
					o["RateSpecial"] = 0;
				}
				if(obj["RateRare"])
				{
					o["RateRare"] = Number(obj["RateRare"]);
				}
				else
				{
					o["RateRare"] = 0;
				}
			}
			else 
			{
				o["RateOverLevel"] = 0;
				o["RateSpecial"] = 0;;
				o["RateRare"] = 0;
			}
			
			return o;
		}
		
		public function getRequireIconNumb(type:String, id:int):int
		{
			var obj:Object;
			switch(type)
			{
				case "Wood":
					obj = InfoList["EventContent"][1];
					break;
				case "Silver":
					obj = InfoList["EventContent"][2];
					break;
				case "Gold":
					obj = InfoList["EventContent"][3];
					break;
			}
			return obj[id];
		}
		public function getExpiredTimePetrol(type:int):int
		{
			return InfoList["Petrol"][type].ExpiredTime*86400;		//server tra ve ngay => doi ra second
		}
		public function getEnergyMachineLimit(type:int):int
		{
			return InfoList["EnergyMachine"][type].Buff;
		}
		
		public function getPointBuff(buffPercent:int,buffType:String):int
		{
			if(InfoList["FairyDropPoint"] && InfoList["FairyDropPoint"][buffPercent] && InfoList["FairyDropPoint"][buffPercent][buffType])
			{
				return InfoList["FairyDropPoint"][buffPercent][buffType];
			}
			else
			{
				return 0;
			}
		}
		
		public function getRateBuff(level:int):Number
		{
			return InfoList["FairyDropLevel"][level];
		}
		
		
		public function getLevelRequired(fisId:int):int
		{
			return InfoList["Fish"][fisId]["LevelRequire"];
		}		
		
		
		public function GetTimeReborn2(id:int):String
		{
			var timeToLive:Number = Number(getItemInfo("RebornMedicine", id)["RebornTime"]);
			var sResult:String;
			if (timeToLive < 3600)
			{
				sResult = (int)(Math.round(timeToLive / 60)).toString() + " phút";
			}
			else if (timeToLive<86400&&timeToLive>=3600)
			{
				sResult = (int)(Math.round(timeToLive / 3600)).toString() + " tiếng";
			}
			else if (timeToLive >= 86400)
			{
				sResult = (int)(Math.round(timeToLive / 86400)).toString() + " ngày";
			}
			return sResult;
		}
		
		/*
		 * lấy quà dựa vào index trả về từ Server
		 * @index [in]: truyền vào chỉ số của quà
		 * objParam [out]: lấy ra loại quà objParam["giftType"] và level của quà objParam["giftLevel"]
		 * vd: index = 1 ====> obj["giftType"] = Exp và obj["giftLevel"] = 1
		 */ 
		public function GetLuckyMachineGift(floor:int, index:int, objParam:Object):void
		{
			var obj:Object;
			obj = InfoList["M_LuckyGiftRate"][floor.toString()][index.toString()];
			objParam["giftType"] = obj["ItemType"];
			objParam["giftLevel"] = obj["LevelGift"];
		}
		/*
		 * @giftType [in]: loại quà				vd : EnergyItem
		 * @levelGift [in]: level của quà		vd: 4	(từ 1-6 theo designer)
		 * @objParam [out]: lấy ra nội dung quà: ItemId (quà gì), Num (số lượng bao nhiêu), TicketNum(số vé nhận được nếu ko lấy quà)
		 */
		public function GetGiftContent(floor:int, giftType:String, levelGift:int, objParam:Object):void
		{
			var obj:Object;
			if (giftType.length == 0 || levelGift == 0)
			{
				objParam = null;
				return;
			};
			obj = InfoList["M_GiftContent"][floor.toString()][giftType][levelGift.toString()];//lấy data từ config
			//nguyên nhân xét Exp vì đối tượng này config ko cho trường ItemId vào
			if (giftType == "Exp")
			{
				objParam["ItemId"] = "";
			}
			else
			{
				objParam["ItemId"] = obj["ItemId"];
			}
			objParam["Num"] = obj["Num"];
			objParam["TicketNum"] = obj["TicketNum"];
			if (obj["Color"])
			{
				objParam["Color"] = obj["Color"];
			};
		}
		
		
		public function getTicketDaily():int
		{
			var ticketRec:int;
			var beginTimeEvent:Number = InfoList["Param"]["MiniGame"]["LuckyMachine"]["BeginTime"];
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime-beginTimeEvent;			/*Tính bằng second*/
			var threeDay:Number = 86400 * 3;
			if (remainTime < threeDay)
			{
				ticketRec = InfoList["Param"]["MiniGame"]["LuckyMachine"]["GiveTicket1"];
			}
			else
			{
				ticketRec = InfoList["Param"]["MiniGame"]["LuckyMachine"]["GiveTicket2"];
			}
			return ticketRec;
		}
	}
}

