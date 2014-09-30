package  
{
	import flash.media.Microphone;
	import Logic.Fish;
	import Logic.Lake;
	import Logic.MyUserInfo;
	import Logic.User;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FakeServ 
	{
		private var URL:String;		// service 
		private var ID:String;		// cmdId
		
		public function FakeServ() 
		{
			
		}
		
		public function ProcessPacket(url:String, id:String):Object
		{
			URL = url;
			ID = id;
			var service:String = url.split(".")[0];
			var cmd:String = url.split(".")[1];
			var data:Object = new Object();
			switch(url)
			{
				case "UserService.run":
					data = InitialRun(cmd);
					break;
				default:
					data["Error"] = 60;
					break;
			}
			return data;
		}
		
		public function InitialRun(id:String):Object
		{
			var obj:Object = new Object();
			// fake fish
			var fishArr:Object = new Object;
			var fish:Object = new Object();
			var CollectedStars:int = 0;						fish["CollectedStars"] = CollectedStars;
			var FeedAmount:Number = 13;						fish["FeedAmount"] = FeedAmount;
			var FishTypeId:int = 2;							fish["FishTypeId"] = FishTypeId;
			var Id:int = 13;								fish[ConfigJSON.KEY_ID] = Id;
			var LastBirthTime:int = 0;						fish["LastBirthTime"] = LastBirthTime;
			var LastCollectedTime:int = 0;					fish["LastCollectedTime"] = LastCollectedTime;
			var LastPeriodCare:int = 0;						fish["LastPeriodCare"] = LastPeriodCare;
			var LastPeriodStim:int = 0;						fish["LastPeriodStim"] = LastPeriodStim;
			var Name:String = "sexy";						fish[ConfigJSON.KEY_NAME] = Name;
			var OriginalStartTime:int = 1287653133;			fish["OriginalStartTime"] = OriginalStartTime;
			var Sex:int = 1;								fish["Sex"] = Sex;
			var StartTime:int = 1287734815;					fish["StartTime"] = StartTime;			
			fishArr[0] = fish;	
			for (var i:int = 1; i < 20; i++)
			{
				fish = new Object();
				CollectedStars = 0;						fish["CollectedStars"] = CollectedStars;
				FeedAmount = 13;						fish["FeedAmount"] = FeedAmount;
				FishTypeId = i % 20;						fish["FishTypeId"] = FishTypeId;
				Id = 13;								fish[ConfigJSON.KEY_ID] = Id;
				LastBirthTime = 0;						fish["LastBirthTime"] = LastBirthTime;
				LastCollectedTime = 0;					fish["LastCollectedTime"] = LastCollectedTime;
				LastPeriodCare = 0;						fish["LastPeriodCare"] = LastPeriodCare;
				LastPeriodStim = 0;						fish["LastPeriodStim"] = LastPeriodStim;
				Name = "sexy";							fish[ConfigJSON.KEY_NAME] = Name;
				OriginalStartTime = 1287653133;			fish["OriginalStartTime"] = OriginalStartTime;
				Sex = 1;								fish["Sex"] = Sex;
				StartTime = 1287734815;					fish["StartTime"] = StartTime;			
				fishArr[i] = fish;
			}
			
			// fake lake
			var lake:Object = new Object();
			var CleanAmount:int = 20;						lake["CleanAmount"] = CleanAmount;
			var Id1:int = 1;								lake[ConfigJSON.KEY_ID] = Id1;
			var Level:int = 2;								lake["Level"] = Level;
			var StarTimeOriginal:int = 1287652570;			lake["StarTimeOriginal"] = StarTimeOriginal;
			var StartTime1:int = 1287652570;				lake["StartTime"] = StartTime1;
			
			// fake mix lake
			var mixLakeArr:Object = new Object;
			var mixLake:Object = new Object();
			var Id2:int = 1;								mixLakeArr[ConfigJSON.KEY_ID] = Id2;
			var LastResetTime:int = 1287802866;				mixLakeArr["LastResetTime"] = LastResetTime;
			var TypeId:int = 2;								mixLakeArr["TypeId"] = TypeId;
			//mixLakeArr["1"] = mixLake;
			
			// fake user
			var user:Object = new Object();
			var AutoId:int = 43;							user["AutoId"] = AutoId;
			var AvatarPic:String = "";						user["AvatarPic"] = AvatarPic;
			var AvatarType:int = 1;							user["AvatarType"] = AvatarType;
			var Energy:int = 50;							user["Energy"] = Energy;
			var Exp:int = 231;								user["Exp"] = Exp;
			var FoodCount:int = 420;						user["FoodCount"] = FoodCount;
			var Id3:int = 2165568;							user[ConfigJSON.KEY_ID] = Id3;
			var LakeNumb:int = 1;							user["LakeNumb"] = LakeNumb;
			var lastEnergyTime:int = 0;						user["lastEnergyTime"] = lastEnergyTime;
			var LastGiftTime:int = 0;						user["LastGiftTime"] = LastGiftTime;
			var LastLuckyTime:int = 0;						user["LastLuckyTime"] = LastLuckyTime;
			var Level3:int = 7;								user["Level"] = Level3;
			var MixLakeCount:int = 16;						user["MixLakeCount"] = MixLakeCount;
			var Money:int = 100000;							user["Money"] = Money;
			var Name3:String = "blabla";					user[ConfigJSON.KEY_NAME] = Name3;
			var NewGift:Boolean = false;					user["NewGift"] = NewGift;
			var NewMessage:Boolean = false;					user["NewMessage"] = NewMessage;
			var NumReceiver:int = 0;						user["NumReceiver"] = NumReceiver;
			var ZMoney:int = 0;								user["ZMoney"] = ZMoney;
			
			obj["Error"] = 0;
			obj["FishList"] = fishArr;
			obj["Item"] = null;			
			obj["Lake1"] = lake;
			obj["User"] = user;
			obj["SystemTime"] = 1287870240;
			obj["MixLakeList"] = mixLakeArr;
			return obj;
		}
		
	}

}