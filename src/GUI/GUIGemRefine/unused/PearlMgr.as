package GUI.GUIGemRefine.unused 
{
	import com.greensock.easing.Strong;
	import Data.ConfigJSON;
	import GUI.GUIGemRefine.GemPackage.SendCancelUpgrade;
	import GUI.GUIGemRefine.GemPackage.SendDeleteGem;
	import GUI.GUIGemRefine.GemPackage.SendGetGem;
	import GUI.GUIGemRefine.GemPackage.SendQuickUpgrade;
	import GUI.GUIGemRefine.GemPackage.SendRecoverGem;
	import GUI.GUIGemRefine.GemPackage.SendUpgradeGem;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import NetworkPacket.PacketSend.SendUseGem;
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author ...
	 */
	public class PearlMgr
	{
		// MAX_TIME_LIFE
		public static const MAX_TIME_LIFE:int = 7 * 24 * 60 * 60;
		
		// loại hệ
		public static const KIM:int = 1;
		public static const MOC:int = 2;
		public static const THO:int = 3;
		public static const THUY:int = 4;
		public static const HOA:int = 5;
		
		public static const RANK_NONE:int = 0;	// thạch
		public static const RANK_ONE:int = 1;
		public static const RANK_TWO:int = 2;
		public static const RANK_THREE:int = 3;
		public static const RANK_FOUR:int = 4;
		public static const RANK_FIVE:int = 5;
		public static const RANK_SIX:int = 6;
		public static const RANK_SEVEN:int = 7;
		public static const RANK_EIGHT:int = 8;
		public static const RANK_NINE:int = 9;
		public static const RANK_TEN:int = 10;
		public static const RANK_MORE:int = 11;		
		
		public var NUM_GEM_DAY:int = 0;
		public var EXP_GEM_DAY:int = 0;
		
		public var pearlList:Array = [];			//list tất cả các gem của user
		public var lastUpdateTime:Number = 0;
		public var upgradingList:Array = [];		//list những gem đang được add vào khu luyện

		
		public function PearlMgr() 
		{
			
		}
		
	
		
		public function InitLoad(data:Object):void 
		{
			var obj:Object;
			if (data)
			{
				if ("Gem" in data)
				{
					lastUpdateTime = data["Gem"]["LastUpdateTime"];
					var tdtd:int = GameLogic.getInstance().CurServerTime ;
					obj = data["UpgradingGem"];	
					SetpearlList(data["Gem"]["ListGem"]);
				}
			}
			var o:Object = ConfigJSON.getInstance().GetItemList("Param");

			if ("NumGemDay" in o)
			{
				EXP_GEM_DAY = o.ExpiredGemDay;
				NUM_GEM_DAY = o.NumGemDay;
			}
			
			for (var i:int = 0; i <3; i++) 
			{
					var a:Array = [];
					upgradingList.push(a);
			}
			if (obj)
			{
				for (var s:String in obj) 
				{
					var item:Object = obj[s];
					var j:int = parseInt(s);
					var tmp:Array = item["ListGem"];
					var time:Number  = GameLogic.getInstance().CurServerTime;
					for (var k:int = 0; k < tmp.length; k++) 
					{
						var temp:Pearl = new Pearl();
						temp.level = tmp[k]["GemId"];
						temp.number = tmp[k]["Num"];
						temp.element = tmp[k]["Element"];
						temp.timeLife = tmp[k]["Day"];
						temp.timeStartRefine = obj[s]["StartTime"];
						temp.isRefining = 0;
						temp.SetInfoFromConfig();
						if (time-temp.timeStartRefine >= temp.timeRefining)
						{
							temp.isRefining = 1;
						}

					//	temp.timeRefining = list[j]["Time"];
						(upgradingList[j] as Array).push(temp);
					}
				}
			}
			
		}
		
		public function SetUpgradingList():void 
		{
			var a:Array = [];
			for (var i:int = 0; i < 3; i++) 
			{
				upgradingList.push(a);
			}
		}
		
		public function GetNewPearlUpgraded(p:Pearl):Pearl 
		{
			var t:Pearl = new Pearl();
			t.level = p.level + 1;
			t.element = p.element;
			t.isRefining = 1;
			t.number = 1;
			// t.timeLife thiếu  ????
			t.SetInfoFromConfig();
			
			// tìm t có trong list ko , nếu có tăng number
			for (var i:int = 0; i < pearlList.length; i++) 
			{
				var item:Pearl = pearlList[i];
				if (item.level == t.level && item.element == t.element && item.timeLife == t.timeLife)
				{
					item.number = item.number + 1;
					return null;
				}
			}
			// không tìm thấy đã có trong list
			// push t vào list
			
			pearlList.push(t);
			return t;
		}
		
		public function SetpearlList(obj:Object):void 
		{
			var n:int;
			if (obj)
			{
				pearlList = [];
				for (var e:String in obj)
				{
					for (var l:String in obj[e] ) 
					{
						for (var s:String in obj[e][l]) 
						{
							var pearl:Pearl = new Pearl();
							pearl.element = parseInt(e);
							pearl.level = parseInt(l);
							pearl.timeLife = parseInt(s);
							pearl.SetInfoFromConfig();
							//var o:Object;
							//o["number"] = obj[e][l][s];
							pearl.number = obj[e][l][s];
							//o["pearl"] = pearl;
							pearlList.push(pearl);
						}
						
					}
				}
				pearlList.sortOn(["level","number"],Array.NUMERIC);// , "element", "number", "timeLife"]);
			}
		}
		
		
		public function PickPearlRefine(index:int,slot:int):int 
		{
			var list:Array = GuiMgr.getInstance().GuiPearlRefine.pearlList;
			if (list)
			{
				var p:Pearl = list[index];
				if (p)
				{
					if (p.number > 0)
					{
						p.number = p.number - 1;
						// nạp vào upgrading
						var q:Pearl = new Pearl();
						q.asignPearl(p);
						(upgradingList[slot] as Array).push(q);
						// xóa khỏi pearlList
						
					}
					return p.number;
				}
				
			}
		
			return -1;
			
		}
		
		private function UpdateSubPearlList(p:Pearl):void 
		{
			if (p)
			{
				for (var i:int = 0; i < pearlList.length; i++) 
				{
					var item:Pearl = pearlList[i];
					if (item.timeLife == p.timeLife && item.level == p.level && p.element == item.element)
					{
						if (item.number >= p.number)
						{
							item.number = item.number - p.number;
							if (item.number == 0)
							{
								pearlList.splice(i, 1);
							}
						}
						return;
					}
				}
			}
		}
		
		private function UpdateAddPearlList(p:Pearl):void 
		{
			if (p)
			{
				for (var i:int = 0; i < pearlList.length; i++) 
				{
					var item:Pearl = pearlList[i];
					if (item.timeLife == p.timeLife && item.level == p.level && p.element == item.element)
					{
							item.number = item.number+p.number;
							return;
					}
				}
				// nếu không tìm thấy thì add thêm phần tử mới vào mảng
				var o:Pearl = new Pearl;
				o.asignPearl(p);
				o.number = p.number;
				pearlList.push(o);
			}
		}
		
		public function QuickRefine(index:int):void 
		{
			if (index > -1)
			{
				var a:Array = upgradingList[index];
				for (var i:int = 0; i < a.length; i++) 
				{
					var item:Pearl = a[i];
					item.timeStartRefine = GameLogic.getInstance().CurServerTime-item.timeRefining;
				}
			}
			
		}
		
		public function RefinePearl (index:int):void 
		{
			var a:Array = [];
			a = upgradingList[index];
			for (var i:int = 0; i < a.length; i++) 
			{

				var item:Pearl = a[i];
				item.RefinePearl();
				UpdateStoreGui(item.element, item.level, item.timeLife, -1);
				for (var j:int = 0; j < pearlList.length; j++) 
				{
					var p:Pearl = pearlList[j];
					if (item.level == p.level && item.element == p.element && item.timeLife == p.timeLife)
					{
						p.number = p.number - item.number;
						if (p.number <= 0)
						{	
							//delete
							pearlList.splice(j, 1);
							//j--;
						}
						break;
					}
				}

			}
		}
		
		public function FinishRefine(index:int):void 
		{
			var a:Array = [];
			a = upgradingList[index];
			var min:int = NUM_GEM_DAY
			for (var i:int = 0; i < a.length; i++) 
			{
				var item:Pearl = a[i];
				item.isRefining = 1;
				if (min > item.timeLife)
				{
					min = item.timeLife;
				}
			}	
			if (a[0])
			{
				(a[0]as Pearl).timeLife = min;
			}
		}
		
		/**
		 * update vao store Gui
		 * @param	el
		 * @param	lv
		 * @param	tlife
		 * @param	num
		 */
		public function UpdateStoreGui(el:int, lv:int,tlife:int, num:int):void 
		{
			var itemType:String = "Gem$" + el + "$" + lv;
			var itemId:int = tlife;
			//if (GuiMgr.getInstance().GuiStoreSoldier.IsVisible)
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				//GuiMgr.getInstance().GuiStoreSoldier.UpdateStore(itemType, itemId, num);
				GuiMgr.getInstance().GuiStore.UpdateStore(itemType, itemId, num);
			}
			else
			{
				GameLogic.getInstance().user.UpdateStockThing(itemType, itemId, num);
			}
		}

		
		/**
		 * hoàn thành việc luyện ngọc, update vào danh sách ngọc 
		 * và xóa khỏi upgradeList
		 * @param	index
		 */
		public function RefineFinishPearl(index:int):Boolean 
		{
			var a:Array = upgradingList[index] ;
			var flag:Boolean = false;
		
			var item:Pearl = a[0];
			// tìm item trong PearlList xem có chưa
			for (var j:int = 0; j < pearlList.length; j++) 
			{
				var p:Pearl = pearlList[j];
				if (p.element == item.element && p.level == (item.level+1) && p.timeLife==item.timeLife)
				{
					flag = true;
					p.number = p.number + 1;
					break;
				}	
			}
			if (!flag)
			{
				// nạp  vào list
				var tmp:Pearl = new Pearl();
				tmp.asignPearl(item);
				tmp.level++;
				tmp.SetInfoFromConfig();
				pearlList.push(tmp);
			}
			UpdateStoreGui(item.element, item.level+1, item.timeLife, 1);
			
			// clear khỏi upgrading list
			upgradingList[index] = [];
			
			return flag;
		
		}
		
		public function UnRefinePearl(index:int):void 
		{
			
			var a:Array = upgradingList[index] ;
			var flag:Boolean = false;
			var i:int;
			
			// tìm item trong PearlList xem có chưa
			for ( i = 0; i < a.length; i++) 
			{
				var item:Pearl = a[i];
				UpdatePearlUnRefine(item);
				if (item.timeLife > 0)
				{
					UpdateStoreGui(item.element, item.level, item.timeLife, 1);
				}
				if (item.timeLife > -7)
				{
					for (var j:int = 0; j < pearlList.length; j++) 
					{
						var p:Pearl = pearlList[j];
						if (p.element == item.element && p.level == item.level && p.timeLife==item.timeLife)
						{
							flag = true;
							p.number = p.number + 1;
							break;
						}
					}
					if (!flag)
					{
						// nạp  vào list
						var tmp:Pearl = new Pearl();
						tmp.asignPearl(item);
						pearlList.push(tmp);
					}
				}
			}
						
		}
		
		
		private function UpdatePearlUnRefine(p:Pearl):void 
		{			
			// thực hiện việc update lại ngọc 
			if (p.timeStartRefine >lastUpdateTime)
			{
				var time:Number = GameLogic.getInstance().CurServerTime;
				var datCur:Date = new Date( time* 1000);
				var datLast:Date = new Date( p.timeStartRefine * 1000);
				if (datLast.getDate() != datCur.getDate() || (datLast.getDate() == datCur.getDate() && datCur.getMonth() != datLast.getMonth()))
				{
					p.timeLife--;
				}
			}
		}
		
		public function  SendReceivePearl(id:int):void 
		{
			var cmd:SendGetGem = new SendGetGem(id);
			Exchange.GetInstance().Send(cmd);
		}
		
		public function SendRefinePearl(index:int):void 
		{
			var a:Array = upgradingList[index];
			var p:Pearl = a[0] as Pearl;
			var list:Array = [];
			if (p)
			{
				var el:int = p.element;
				var le:int = p.level + 1;
				for (var i:int = 0; i < a.length; i++) 
				{
					var item:Pearl = a[i] as Pearl;
					var o:Object = new Object();
					o["Element"] = item.element;
					o["GemId"] = item.level;
					o["Day"] = item.timeLife;
					o["Num"] = item.number;
					list.push(o);
				}
				var cmd:SendUpgradeGem = new SendUpgradeGem(el, list, le,index);
				Exchange.GetInstance().Send(cmd);
			}
		}
		
		public function SendCancelUpgradePearl(id:int):void 
		{
			var cmd:SendCancelUpgrade= new SendCancelUpgrade(id);
			Exchange.GetInstance().Send(cmd);
			
		}
		
		public function SendQuickRefinePearl(index:int,isMoney:Boolean):void 
		{
			var a:Array = upgradingList[index];
			var p:Pearl = a[0] as Pearl;
			var l:int = p.level + 1;
			var cmd:SendQuickUpgrade = new SendQuickUpgrade(index, isMoney);
			Exchange.GetInstance().Send(cmd);
		}
		
		public function SendDeletePearl(el:int,life:int,num:int,lv:int=-1):void 
		{
			if (lv>-1)
			{
				var list:Array = [];
				var o:Object = new Object();
				o["Element"] = el;
				o["GemId"] = lv;
				o["Day"] = life;
				o["Num"] = num;
				list.push(o);
				var cmd:SendDeleteGem= new SendDeleteGem(list);
				Exchange.GetInstance().Send(cmd);
			}
		}
		
		public function Update():void 
		{
			var datLast:Date = new Date(lastUpdateTime * 1000 );
			var tmpt:int = GameLogic.getInstance().CurServerTime;
			var datCur:Date = new Date( tmpt* 1000);
			if (datLast.getDate() != datCur.getDate() || (datLast.getDate() == datCur.getDate() && datCur.getMonth() != datLast.getMonth()))
			{
				// thực hiện việc update
				for (var i:int = 0; i < pearlList.length; i++) 
				{
					var item:Pearl = pearlList[i];
					item.timeLife--;
					if (item.timeLife < -6)
					{
						pearlList.splice(i, 1);
						i--;
						// update lại content 
					}
				}
				lastUpdateTime = GameLogic.getInstance().CurServerTime;
			}
			
			//update upgradeList
			
			for (var j:int = 0; j < upgradingList.length; j++) 
			{
				var a:Array = GameLogic.getInstance().user.pearlMgr.upgradingList[j];
				if (a)
				{
					var p:Pearl = a[0];
					var temp:Number;
					if (p)
					{
						if (p.isRefining==0)
						{
							temp = (tmpt-p.timeStartRefine);
							if (temp > p.timeRefining)
							{
								p.isRefining = 1;
							}
						}
					}
				}
			}	
		}
		
		public function SortAutoPearl():void 
		{
			pearlList.sortOn(["level", "number"], Array.NUMERIC);
		}
		
		public function DeletePearl(el:int,life:int,num:int,lv:int=-1):void 
		{
			if (lv>-1) 
			{
				if (lv)
				{
					UpdateStoreGui(el, lv, life, -num);
				}
				for (var i:int = 0; i < pearlList.length; i++) 
				{
					var item:Pearl = pearlList[i];
					if (item.level == lv && item.element == el && item.timeLife == life )
					{
						item.number = item.number - num;
						if (item.number <=0)
						{
							pearlList.splice(i, 1);
						}
						return;
					}
				}
			}
		}
		
		public function usePearlInMyLake(el:int,life:int,num:int,lv:int=-1):void 
		{
			if (lv) 
			{
				for (var i:int = 0; i < pearlList.length; i++) 
				{
					var item:Pearl = pearlList[i];
					if (item.level == lv && item.element == el && item.timeLife == life )
					{
						item.number = item.number - num;
						if (item.number <=0)
						{
							pearlList.splice(i, 1);
						}
						return;
					}
				}
			}	
		}
		
		public function SendRecoverPearl(el:int,life:int,num:int,id:int,lv:int=-1):void 
		{
			if (lv>-1)
			{
				var list:Array = [];
				var o:Object = new Object();
				o["Element"] = el;
				o["GemId"] = lv;
				o["Day"] = life;
				o["Num"] = num;
				list.push(o);
				var cmd:SendRecoverGem= new SendRecoverGem(list);
				Exchange.GetInstance().Send(cmd);
			}
		}
		
		public function RecoverPearl(el:int,life:int,num:int,lv:int=-1):void 
		{
			if (lv>-1) 
			{
				if (lv)
				{
					UpdateStoreGui(el, lv, life, -num);
					UpdateStoreGui(el, lv, NUM_GEM_DAY, num);
				}
				for (var i:int = 0; i < pearlList.length; i++) 
				{
					var item:Pearl = pearlList[i];
					if (item.level == lv && item.element == el && item.timeLife == life )
					{
						if ( item.number == num)
						{
							item.timeLife = NUM_GEM_DAY;
						}
						else
						{
							if (item.number > num)
							{
								item.number = item.number - num;
								// push 1 pearl mới vào list
								var p:Pearl = new Pearl();
								p.asignPearl(item);
								p.number = num;
								p.timeLife = NUM_GEM_DAY;
								pearlList.push(p);
							}
						}
						return;
					}
				}
			}
		}
		
		public function copyPearlList():Array 
		{
			//return pearlList;
			var list:Array = []; 
			for (var i:int = 0; i < pearlList.length; i++) 
			{
				var item:Pearl = pearlList[i] as Pearl;
				var tmp:Pearl = new Pearl();
				tmp.copy(item);
				list.push(tmp);
			}
			return list;
		}
		
		/**
		 * xóa các list add vào chưa luyện
		 */
		public function cleanUpgradeList():void 
		{
			var p:Pearl;
			var i:int;
			for ( i = 0; i < upgradingList.length; i++) 
			{
				var itemm:Array = upgradingList[i];
				if (itemm.length > 0)
				{
					p=itemm[0];
					if (p.isRefining == -1)
					{
						upgradingList[i] = [];
					}
				}
			}
		}
	}

}