package Data 
{
	import flash.xml.XMLNode;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	/**
	 * ...
	 * @author ducnh
	 */
	public class Config
	{
		private static var instance:Config;
		private var _data:XML;
		
		
		public static function getInstance(xml:Object = null):Config
		{
			var _x:XML = XML(xml);
			if(instance == null)
			{
				instance = new Config(_x);
			}				
			return instance;
		}	
		
		public function Config(value:XML) 
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
		
		public function GetIniVersion():String
		{
			return data.IniVer.toString();
		}
		
		public function GetlocalizationVersion():String
		{
			return data.LocalizationVer.toString();
		}
		
		public function GetQuestVersion():String
		{
			return data.QuestVer.toString();
		}
		
		public function GetFishColor(FishID:int, FishLevel:int):Array
		{
			var subData:XMLList = data.FishList["Fish" +  FishID]["Level" + FishLevel];
			var a:Array = [];
			var obj:Object;
			var i:int;
			var l:int = subData.children().length();
			if (subData.toString != "")
			{
				var item:XMLList = subData.children();
				for (i = 0; i < l; i++)
				{
					obj = new Object;
					obj["Key"] = item[i].name().toString();
					obj["Alpha"] = item[i].@A.toString();
					obj["Red"] = item[i].@R.toString();
					obj["Green"] = item[i].@G.toString();
					obj["Blue"] = item[i].@B.toString();
					a.push(obj);
				}
			}
			return a;
		}
		
		public function GetContentVersion(ContentId:String):String
		{
			//trace("GetContentVersion== " + data.ContentList[ContentId]);
			return data.ContentList[ContentId];
		}
		
		public function isSmallBackGround(backgroundId:int):Boolean
		{
			if (data.BackGroundAttribute["BackGround" + backgroundId] == "small")
			{
				return true;
			}
			return false;
		}
	}

}