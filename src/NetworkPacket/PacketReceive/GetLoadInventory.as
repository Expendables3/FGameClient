package NetworkPacket.PacketReceive 
{
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.FishEquipmentMask;
	import Logic.GameLogic;
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class GetLoadInventory extends BaseReceivePacket
	{
		public var Error:int;
		public var Medicine:Array = new Array();
		public var OceanAnimal:Array = new Array();
		public var OceanTree:Array = new Array();
		public var PearFlower:Array = new Array();
		public var Other:Array = new Array();
		public var BackGround:Array = new Array();
		public var WallPaper:Array = new Array();
		public var WaterFilter:Array = new Array();
		public var Food:Array = new Array();
		public var MixLake:Array = new Array();
		public var Material:Array = new Array();
		public var BabyFish:Array = new Array();
		public var Soldier:Array = new Array();
		public var EnergyItem:Array = new Array();
		public var Viagra:Array = new Array();
		
		//public var Petrol:Array = new Array();
		public var License:Array = [];
		public var Draft:Array = [];
		public var Paper:Array = [];
		public var GoatSkin:Array = [];
		public var Blessing:Array = [];
		public var Petrol:Array = [];
		public var MagicBag:Array = [];
		public var RebornMedicine:Array = [];
		//public var Ticket:Array = [];
		public var GiftTicket:Array = [];
		//public var Lixi:Array = [];
		public var RankPointBottle:Array = [];
		public var Event_8_3_Flower:Array = [];
		public var Island_Item:Array = [];
		public var BirthDayItem:Array = [];
		public var IceCreamItem:Array = [];
		
		// Item của cá lính
		public var Ginseng:Array = new Array();
		public var RecoverHealthSoldier:Array = new Array();
		public var BuffExp:Array = new Array();
		public var BuffMoney:Array = new Array();
		public var BuffRank:Array = new Array();
		public var Resistance:Array = new Array();
		public var Samurai:Array = new Array();
		public var Dice:Array = new Array();
		public var StoreRank:Array = new Array();
		public var Gem1:Array = new Array();	// Kim
		public var Gem2:Array = new Array();	// Mộc
		public var Gem3:Array = new Array();	// Thổ
		public var Gem4:Array = new Array();	// Thủy
		public var Gem5:Array = new Array();	// Hỏa	
		public var Helmet:Array = new Array();	// Mũ
		public var Armor:Array = new Array();	// Áo
		public var Weapon:Array = new Array();	// Vũ khí
		public var Belt:Array = new Array();		// Thắt lưng
		public var Bracelet:Array = new Array();	// Vòng tay
		public var Necklace:Array = new Array();	// Vòng cổ
		public var Ring:Array = new Array();		// Nhẫn
		public var Mask:Array = new Array();		// Mặt nạ
		
		public var GodCharm:Array = new Array();	// Bùa thánh
		public var Seal:Array = new Array();// Ngọc Ấn
		public var HerbPotion:Array = new Array();	// Lọ thảo dược
		public var Herb:Array = new Array();		// Cây thảo dược
		public var HerbMedal:Array = new Array();	// Huy chương thảo dược
		
		public var MixFormula:Array = new Array();
		
		public var StoreList: Object = new Object();
		public var FishGift: Array = new  Array();
		public var Items: Array = new Array();
		public var Fish:Array = new Array();
		
		public var OpenKeyItem:Array = new Array();		// Item mở khóa cho trang bị
		
		//For event 30/4/2011
		public var Icon:Array = [];
		public var IconND:Array = [];
		public var Key:Array = [];
		public var numSparta:int = 0;
		
		//Event 2-9
		public var IconChristmas:Array = [];
		public var SockExchange:Array = [];
		//public var Firework:Array = [];
		public var Sock:Array = [];
		public var Arrow:Array = [];
		public var VipMedal:Array = [];
		public var MazeKey:Array = [];
		
		//Collection
		public var ItemCollection:Array = [];
		public var Visa:Array = [];
		
		//Liên đấu (ngư lệnh)
		public var OccupyToken:Array = [];
		
		//Trung linh thach
		//public var Quartz:Array = [];
		public var QWhite:Array = [];
		public var QGreen:Array = [];
		public var QYellow:Array = [];
		public var QPurple:Array = [];
		public var QVIP:Array = [];
		
		public function findBabyFishInfo(id:int):Object
		{
			var i: int, j: int;
			var idArr:Array, colorArr: Array, sexArr: Array;
			var obj: Object = new Object();
			
			for (i = 0;  i < BabyFish.length; i++)
			{
				idArr = BabyFish[i]["ListId"] as Array;
				colorArr = BabyFish[i]["ListColor"] as Array;
				sexArr = BabyFish[i]["ListSex"] as Array;
				if (BabyFish[i][ConfigJSON.KEY_ID] == id)
				{
					for (var s: String in BabyFish[i])
					{
						if (s == "RateOption")
						{
							var obj1: Object = new Object();
							for (var ss: String in BabyFish[i][s])
							{
								
								obj1[ss] = BabyFish[i][s][ss];
							}
							obj[s] = obj1;
						}
						else
							obj[s] = BabyFish[i][s];
					}
					return obj;
				}
			}
			return null;
		}
		
		public function PopBabyFishSoldier(id: int): Object
		{
			var i: int, j: int;
			var idArr:Array, colorArr: Array, sexArr: Array;
			var obj: Object = new Object();

			for (i = 0;  i < BabyFish.length; i++)
			{
				idArr = BabyFish[i]["ListId"] as Array;
				if (BabyFish[i][ConfigJSON.KEY_ID] == id)
				{
					BabyFish[i]["Num"] -= 1;
					for (var s: String in BabyFish[i])
					{
						if (s == "RateOption")
						{
							var obj1: Object = new Object();
							for (var ss: String in BabyFish[i][s])
							{
								
								obj1[ss] = BabyFish[i][s][ss];
							}
							obj[s] = obj1;
						}
						else
							obj[s] = BabyFish[i][s];
					}
					
					if (BabyFish[i]["Num"] == 0)
					{
						BabyFish.splice(i, 1);
					}
					else
					{
						idArr.splice(0, 1);
						BabyFish[i][ConfigJSON.KEY_ID] = idArr[0];
					}
					return obj;
				}
			}
			return null;
		}
		
		public function PopBabyFish(id: int): Object
		{
			var i: int, j: int;
			var idArr:Array, colorArr: Array, sexArr: Array;
			var obj: Object = new Object();

			for (i = 0;  i < BabyFish.length; i++)
			{
				idArr = BabyFish[i]["ListId"] as Array;
				colorArr = BabyFish[i]["ListColor"] as Array;
				sexArr = BabyFish[i]["ListSex"] as Array;
				if (BabyFish[i][ConfigJSON.KEY_ID] == id)
				{
					BabyFish[i]["Num"] -= 1;
					for (var s: String in BabyFish[i])
					{
						if (s == "RateOption")
						{
							var obj1: Object = new Object();
							for (var ss: String in BabyFish[i][s])
							{
								
								obj1[ss] = BabyFish[i][s][ss];
							}
							obj[s] = obj1;
						}
						else
							obj[s] = BabyFish[i][s];
					}
					
					if (BabyFish[i]["Num"] == 0)
					{
						BabyFish.splice(i, 1);
					}
					else
					{
						idArr.splice(0, 1);
						BabyFish[i][ConfigJSON.KEY_ID] = idArr[0];
						colorArr.splice(0, 1);
						BabyFish[i]["ColorLevel"] = colorArr[0];
						sexArr.splice(0, 1);
						BabyFish[i]["Sex"] = sexArr[0];
					}
					return obj;
				}
			}
			return null;
		}
		public function PopBabyFishSparta(id: int): Object
		{
			var obj: Object = BabyFish.pop();
			return obj;
		}
		
		public function CompareRateOption(obj1: Object, obj2: Object): Boolean
		{
			var s1: String, s2: String;
				
			for (s1 in obj1)
			{
				if (obj1[s1] != obj2[s1]) return false;
			}
			
			for (s2 in obj2)
			{
				if (obj1[s2] != obj2[s2]) return false;
			}
			
			return true;
		}
		
		public function GetLoadInventory(data:Object) 
		{
			//trace("asdasd");
			super(data);
			var si: String, sj: String;
			
			var obji: Object, objj: Object;
			var i: int = 0, j: int = 0;
			var ok: Boolean;
			
			for (si in StoreList["Fish"])
			{
				//if (StoreList["Fish"][si]["FishTypeId"] < Constant.FISH_TYPE_START_SOLDIER)
				{
					BabyFish.push(StoreList["Fish"][si]);
				}
				//else
				//{
					//Soldier.push(StoreList["Fish"][si]);
				//}
			}
			if (Soldier)
			{
				// Ghép các con cá con cùng đặc tính
				for (i = 0; i < Soldier.length; i++ )
				{
					obji = Soldier[i];
					obji["Num"] = 1;
					obji["ListId"] = new Array();
					obji["ListId"].push(obji[ConfigJSON.KEY_ID]);

					//for (j = i + 1; j < BabyFish.length - numSparta; j++ )
					//{
						//objj = BabyFish[j];
						//ok = (objj["FishType"] == obji["FishType"]) && 
							 //(objj["FishTypeId"] == obji["FishTypeId"]) &&
							 //(CompareRateOption(obji["RateOption"], objj["RateOption"]));
						//var isSoldier:Boolean = ((obji["FishType"] == 3) && (objj["FishType"] == 3));
						//if (ok && !isSoldier)
						//{
							//obji["Num"] += 1;
							//obji["ListId"].push(objj[ConfigJSON.KEY_ID]);
							//obji["ListColor"].push(objj["ColorLevel"]);
							//obji["ListSex"].push(objj["Sex"]);
							//BabyFish.splice(j, 1);
							//j--;
						//}
					//}
				}
			}
			if (StoreList["AllOther"])
			{
				//for (si in StoreList["AllOther"]["Sparta"])
				//{
					//BabyFish.push(StoreList["AllOther"]["Sparta"][si]);
					//numSparta++;
					//obji = BabyFish[BabyFish.length - 1];
					//obji["Num"] = 1;
					//obji["ItemType"] = "BabyFish";
					//obji["ListId"] = new Array();
					//obji["ListId"].push(obji[ConfigJSON.KEY_ID]);
					//obji["ListColor"] = new Array();
					//obji["ListColor"].push(obji["ColorLevel"]);
					//obji["ListSex"] = new Array();
					//obji["ListSex"].push(obji["Sex"]);
				//}
				for (si in StoreList["AllOther"])
				{
					var allOther:Object = StoreList["AllOther"][si];
					
					//Đồ trang trí có thời hạn
					if (si == "Other" || si == "OceanAnimal" || si == "OceanTree" || si == "BackGround" || si == "PearFlower")
					{
						for (sj in allOther)
						{
							obj = new Object();
							obj = allOther[sj];
							obj["Num"] = 1;
							//Chỉ lấy đối tượng chưa quá hạn 7 ngày
							if(obj["ExpiredTime"] + Constant.TIME_DISAPPEAR > GameLogic.getInstance().CurServerTime && (si in this))
							{
								this[si].push(obj);
							}
						}
					}
					else
						for (var sk:String in allOther) 
						{
							BabyFish.push(allOther[sk]);
							numSparta++;
							obji = BabyFish[BabyFish.length - 1];
							obji["Num"] = 1;
							obji["ItemType"] = "BabyFish";
							obji["Name"] = si;
							obji["ListId"] = new Array();
							obji["ListId"].push(obji[ConfigJSON.KEY_ID]);
							obji["ListColor"] = new Array();
							obji["ListColor"].push(obji["ColorLevel"]);
							obji["ListSex"] = new Array();
							obji["ListSex"].push(obji["Sex"]);
						}
				}
			}
			
			if (BabyFish)
			{
				// Ghép các con cá con cùng đặc tính
				for (i = 0; i < BabyFish.length - numSparta; i++ )
				{
					obji = BabyFish[i];
					obji["Num"] = 1;
					obji["ListId"] = new Array();
					obji["ListId"].push(obji[ConfigJSON.KEY_ID]);
					obji["ListColor"] = new Array();
					obji["ListColor"].push(obji["ColorLevel"]);
					obji["ListSex"] = new Array();
					obji["ListSex"].push(obji["Sex"]);

					for (j = i + 1; j < BabyFish.length - numSparta; j++ )
					{
						objj = BabyFish[j];
						ok = (objj["FishType"] == obji["FishType"]) && 
							 (objj["FishTypeId"] == obji["FishTypeId"]) &&
							 (CompareRateOption(obji["RateOption"], objj["RateOption"]));
						var isSoldier:Boolean = ((obji["FishType"] == 3) && (objj["FishType"] == 3));
						if (ok && !isSoldier)
						{
							obji["Num"] += 1;
							obji["ListId"].push(objj[ConfigJSON.KEY_ID]);
							obji["ListColor"].push(objj["ColorLevel"]);
							obji["ListSex"].push(objj["Sex"]);
							BabyFish.splice(j, 1);
							j--;
						}
					}
				}
			}
			
			
			var obj: Object;
			for (si in StoreList["Items"])
				for (sj in StoreList["Items"][si])
				{
					if (si == "IceCreamItem" || si == "Event_8_3_Flower")	continue;
					obj = new Object();
					obj["ItemType"] = si;
					obj[ConfigJSON.KEY_ID] = sj;
					obj["Num"] = StoreList["Items"][si][sj];
					if (si == "MagicBag")
					{
						var ji:int = 1;
					}
					if (obj["Num"] > 0 && (si in this))
						this[si].push(obj);
				}
			
			if (StoreList["EventItem"])
			{
				if (StoreList["EventItem"]["PearFlower"])
				{
					for (si in StoreList["EventItem"]["PearFlower"])
					{
						for (sj in StoreList["EventItem"]["PearFlower"][si])
						{
							obj = new Object();
							obj["ItemType"] = si;
							obj[ConfigJSON.KEY_ID] = sj;
							obj["Num"] = StoreList["EventItem"]["PearFlower"][si][sj];
							if (obj["Num"] > 0 && (si in this))
							{
								this[si].push(obj);
							}
						}
					}
				}
				if (StoreList["EventItem"]["Event_8_3_Flower"])
				{
					for (si in StoreList["EventItem"]["Event_8_3_Flower"])
					{
						for (sj in StoreList["EventItem"]["Event_8_3_Flower"][si])
						{
							obj = new Object();
							obj["ItemType"] = si;
							obj[ConfigJSON.KEY_ID] = sj;
							obj["Num"] = StoreList["EventItem"]["Event_8_3_Flower"][si][sj];
							if (obj["Num"] > 0 && (si in this))
							{
								this[si].push(obj);
							}
						}
					}
				}
				
				if (StoreList["EventItem"]["TreasureIsland"])
				{
					for (si in StoreList["EventItem"]["TreasureIsland"])
					{
						for (sj in StoreList["EventItem"]["TreasureIsland"][si])
						{
							obj = new Object();
							obj["ItemType"] = si;
							obj[ConfigJSON.KEY_ID] = sj;
							obj["Num"] = StoreList["EventItem"]["TreasureIsland"][si][sj];
							if (obj["Num"] > 0 && (si in this))
							{
								this[si].push(obj);
							}
						}
					}
				}
				
				if (StoreList["EventItem"]["IceCream"])
				{
					for (si in StoreList["EventItem"]["IceCream"])
					{
						for (sj in StoreList["EventItem"]["IceCream"][si])
						{
							obj = new Object();
							obj["ItemType"] = si;
							obj[ConfigJSON.KEY_ID] = sj;
							obj["Num"] = StoreList["EventItem"]["IceCream"][si][sj];
							if (obj["Num"] > 0 && (si in this))
							{
								this[si].push(obj);
							}
						}
					}
				}
			}
			
			//trace("Done!");
			
			// Load các item hỗ trợ cá lính của user
			for (si in StoreList["BuffItem"])
				for (sj in StoreList["BuffItem"][si])
				{
					obj = new Object();
					obj["ItemType"] = si;
					obj[ConfigJSON.KEY_ID] = sj;
					obj["Num"] = StoreList["BuffItem"][si][sj];
					if (obj["Num"] > 0 && (si in this))
						this[si].push(obj);
				}
				
			// Load các đan tán của user
			if (StoreList["Gem"])
			for (si in StoreList["Gem"]["ListGem"])
				for (sj in StoreList["Gem"]["ListGem"][si])
					for (var sk1:String in StoreList["Gem"]["ListGem"][si][sj])
					{
						obj = new Object();
						obj["ItemType"] = "Gem$" + si + "$" + sj;
						//obj[ConfigJSON.KEY_ID] = sj + "_" + sk1;
						obj[ConfigJSON.KEY_ID] = sk1;
						obj["Num"] = StoreList["Gem"]["ListGem"][si][sj][sk1];
						
						if (obj["Num"] > 0 && (("Gem" + si) in this))
							this["Gem" + si].push(obj);
					}
			
			// Load các trang bị của cá lính
			if (StoreList["Equipment"])
			for (si in StoreList["Equipment"])				// si là type: helmet, armor, weapon...
			{
				//ThanhNT2 Add them de fix bug sever add sai data trong kho vao trang bi!
				if (si == "QWhite" || si == "QGreen" || si == "QYellow" || si == "QPurple" || si == "QVIP")
				{
					continue;
				}
				
				if (si != "Mask")
				{
					for (sj in StoreList["Equipment"][si])		// sj là auto-Id của trang bị
					{
						var eq:FishEquipment = new FishEquipment();
						eq.SetInfo(StoreList["Equipment"][si][sj]);
						//eq.Color = 4;
						this[si].push(eq);
					}
				}
				else
				{
					for (sj in StoreList["Equipment"][si])		// sj là auto-Id của trang bị
					{
						var mask:FishEquipmentMask = new FishEquipmentMask();
						mask.SetInfo(StoreList["Equipment"][si][sj]);
						this[si].push(mask);
					}
				}
			}
			
			
			// Load Trung Linh Thach
			if (StoreList["Quartz"])
			{
				for (si in StoreList["Quartz"]["QWhite"])
					//for (sj in StoreList["Quartz"]["QWhite"][si])
					{
						//trace("QWhite sj== " + sj + " |StoreList[QWhite]== " + StoreList["Quartz"]["QWhite"][si]);
						//trace("id QWhite== " + StoreList["Quartz"]["QWhite"][si]["Id"]);
						QWhite.push(StoreList["Quartz"]["QWhite"][si]);
					}
				
				for (si in StoreList["Quartz"]["QGreen"])
					//for (sj in StoreList["Quartz"]["QGreen"][si])
					{
						//trace("QGreen sj== " + sj + " |StoreList[QGreen]== " + StoreList["Quartz"]["QGreen"][si]);
						QGreen.push(StoreList["Quartz"]["QGreen"][si]);
					}
					
				for (si in StoreList["Quartz"]["QYellow"])
					//for (sj in StoreList["Quartz"]["QYellow"][si])
					{
						//trace("QYellow sj== " + sj + " |StoreList[QYellow]== " + StoreList["Quartz"]["QYellow"][si]);
						QYellow.push(StoreList["Quartz"]["QYellow"][si]);
					}
					
				for (si in StoreList["Quartz"]["QPurple"])
					//for (sj in StoreList["Quartz"]["QPurple"][si])
					{
						//trace("QPurple sj== " + sj + " |StoreList[QPurple]== " + StoreList["Quartz"]["QPurple"][si]);
						QPurple.push(StoreList["Quartz"]["QPurple"][si]);
					}
				
				for (si in StoreList["Quartz"]["QVIP"])
					//for (sj in StoreList["Quartz"]["QVIP"][si])
					{
						//trace("QVIP sj== " + sj + " |StoreList[QVIP]== " + StoreList["Quartz"]["QVIP"][si]);
						QVIP.push(StoreList["Quartz"]["QVIP"][si]);
					}
			}
		}
		
	}

}