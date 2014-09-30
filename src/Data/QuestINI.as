package Data 
{
	import flash.xml.XMLNode;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	/**
	 * ...
	 * @author ducnh
	 */
	public class QuestINI
	{
		private static var instance:QuestINI;
		private var _data:XML;
		
		
		public static function getInstance(xml:Object = null):QuestINI
		{
			var _x:XML = XML(xml);
			if(instance == null)
			{
				instance = new QuestINI(_x);
			}				
			return instance;
		}	
		
		public function QuestINI(value:XML) 
		{
			_data = value;
		}  

		public function set data(value:XML):void
		{
			_data = value;
		}
		public function get data():XML
		{
			return _data;
		}
		
		/*public function GetDailyQuest(ID:int, level:int):QuestInfo
		{
			var kq:QuestInfo = new QuestInfo;
			//for (var m:int = 1; m <= 59; m++ )
			//{
				//trace("level", m, "cap", (       int( (m-1)/ 5) + 1      ));
			//}			
			
			var dailyTag:String = "dailyquest" + (       int( (level-1)/ 5) + 1      );
			var subData:XMLList = data.quests.dailyquest[dailyTag][dailyTag + ID];
			var subData1:XMLList;
			kq.Id = ID;
			kq.Name = subData.name;
			kq.LevelRequire = subData.levelrequire;
			kq.Decription = subData.decription;
			kq.QuestType = QuestInfo.QUEST_DAILY;
			
			// task
			var obj:Object;
			var j:int;
			var k:int;
			var st:String;

			subData1 = subData.task;
			obj = new Object;
			obj[ConfigJSON.KEY_ID] = subData1.id;
			obj["decription"] = subData1.decription.toString();
			obj["action"] = subData1.action.toString();
			obj["icon"] = subData1.icon.toString();
			obj["number"] = subData1.num.toString();
			var _o:Object = new Object;
			var param:XMLList = subData1.param[0].children();
			for (j = 0; j < param.length(); j++)
			{
				var pr:XMLList = subData1.param[param[j].name()].children();
				if (pr.length() > 1)
				{
					var _o1:Object = new Object;
					for (k = 0; k < pr.length(); k++)
					{
						_o1[pr[k].name()] = pr[k].toString();
					}
					_o[param[j].name()] = _o1;
				}
				else
				{
					_o[param[j].name()] = param[j].toString();
				}
			}
			obj["params"] = _o;
			kq.AddTask(obj);

			
			// bonus
			var l:int = subData.bonus.children().length();
			//trace("bonus: ", subData.bonus);
			for (var i:int = 0; i < l; i++)
			{
				var tg:String = "bonus" + (i + 1);
				subData1 = subData.bonus[tg];
				obj = new Object;
				obj["ItemType"] = subData1.itemtype.toString();
				obj["ItemId"] = subData1.itemid.toString();
				obj["Number"] = subData1.num.toString();
				kq.AddBonus(obj);
			}
			
			return kq;
		}*/
		
		/*public function GetBonusDailyQuest(idQuest:int, level:int, idBonus:int):QuestBonus
		{
			var bonus:QuestBonus = new QuestBonus;
			var dailyTag:String = "dailyquest" + (int((level-1) / 5) + 1);
			var subData:XMLList = data.quests.dailyquest[dailyTag][dailyTag + idQuest].bonus["bonus" + idBonus];
			var obj:Object = new Object;
			obj["ItemType"] = subData.itemtype.toString();
			obj["ItemId"] = subData.itemid.toString();
			obj["Num"] = subData.num.toString();
			bonus.SetInfo(obj);
			return bonus;
		}*/
		
		/*public function GetSeriesQuest(IDSeries:int , IDQuest:int):QuestInfo
		{
			var kq:QuestInfo = new QuestInfo;
			var tg:String = "quest" + IDQuest.toString();
			var subData:XMLList = data.quests.seriesquest["seriesquest" +  IDSeries].quest[tg];
			var subData1:XMLList;
			kq.IdSeriesQuest = IDSeries;
	
			
			// task
			var obj:Object;
			var l:int = subData.tasklist.children().length();
			var i:int;
			var j:int;
			var k:int;
			var st:String;
			for (i = 0; i < l; i++)
			{
				tg = "tasklist" + (i + 1);
				subData1 = subData.tasklist[tg];
				obj = new Object;
				obj[ConfigJSON.KEY_ID] = subData1.id;
				obj["decription"] = subData1.decription.toString();
				obj["action"] = subData1.action.toString();
				obj["icon"] = subData1.icon.toString();
				obj["number"] = subData1.num.toString();
				var _o:Object = new Object;
				var param:XMLList = subData1.param[0].children();
				for (j = 0; j < param.length(); j++)
				{
					var pr:XMLList = subData1.param[param[j].name()].children();
					if (pr.length() > 1)
					{
						var _o1:Object = new Object;
						for (k = 0; k < pr.length(); k++)
						{
							_o1[pr[k].name()] = pr[k].toString();
						}
						_o[param[j].name()] = _o1;
					}
					else
					{
						_o[param[j].name()] = param[j].toString();
					}
				}
				obj["params"] = _o;
				kq.AddTask(obj);
			}
			
			// bonus
			l = subData.bonus.children().length();
			for (i = 0; i < l; i++)
			{
				tg = "bonus" + (i + 1);
				subData1 = subData.bonus[tg];
				obj = new Object;
				obj["ItemType"] = subData1.itemtype.toString();
				obj["ItemId"] = subData1.itemid.toString();
				obj["Number"] = subData1.num.toString();
				kq.AddBonus(obj);
			}
			
			return kq;
		}*/
		
		/*public function GetSeriesQuestInfo(IDSeries:int):Object
		{
			var subData:XMLList = data.quests.seriesquest["seriesquest" +  IDSeries];
			var obj:Object = new Object;
			obj[ConfigJSON.KEY_ID] = subData.id;
			obj[ConfigJSON.KEY_NAME] = subData.name;
			obj["expiredate"] = subData.expiredate;
			obj["npc"] = subData.npc;
			obj["levelrequire"] = subData.levelrequire;
			obj["decription"] = subData.decription;
			return obj;
		}*/
	}

}