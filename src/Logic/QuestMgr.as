package Logic 
{
	import com.adobe.utils.StringUtil;
	import com.greensock.events.LoaderEvent;
	import Data.ConfigJSON;
	import Data.QuestINI;
	import flash.net.SharedObject;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.component.BaseGUI;
	import GUI.MainQuest.GUIMainQuest;
	import GUI.MainQuest.GUISeriesQuest;
	import NetworkPacket.PacketSend.SendFeedFish;
	
	import GUI.GuiMgr;
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author ducnh
	 */
	public class QuestMgr
	{
		public static const ID_SERI_NONE:int = 0;
		public static const ID_SERI_BEGIN_JOIN:int = 1;
		public static const ID_SERI_MIX_FISH:int = 2;
		public static const ID_SERI_MIX_FISH_SKILL_SALE_OFF:int = 3;
		public static const ID_SERI_MIX_FISH_SKILL_OVER_LEVEL:int = 4;
		public static const ID_SERI_MIX_FISH_SKILL_SPECIAL:int = 5;
		public static const ID_SERI_MIX_FISH_SKILL_RARE:int = 6;
		public static const ID_SERI_FISH_WAR:int = 7;
		public static const ID_SERI_ADD_MATERIAL:int = 8;
		
		public static const MAX_VISIBLE_QUEST:int = 1;
		
		public static const QUEST_PT_GIFT:int = 0;
		public static const QUEST_PT_DAILY_GIFT:int = 1;
		public static const QUEST_PT_INGREDIENT:int = 2;
		public static const QUEST_PT_DONE_QUEST_1:int = 3;
		public static const QUEST_PT_DONE_QUEST_2:int = 4;
		public static const QUEST_PT_RETRY_QUEST:int = 4;
		
		public var retryTime:int;
		public var curDailyQuest:int;						//id của quest hiện tại
		public var isUnlock:Boolean;						//Quest2 đã được unlock hay chưa
		private static var instance:QuestMgr;
		
		public var SeriesQuest:Array = [];
		public var DailyQuest:Array = [];
		public var DailyQuestNew:Array = [];
		public var SpecialTask:Object = new Object();
		public var XuInfo:Object;
		public var isBlink:Boolean = false;
		public var finishedQuest:Array = [];
		
		private var questDataSave:Object;
		
		public var QuestPowerTinh:Array = [];
		public var PointReceived:int = 0;
		public var LastTimeAccess:Number;
		
		public static function getInstance():QuestMgr
		{
			if(instance == null)
			{
				instance = new QuestMgr();
			}				
			return instance;
		}
		
		public function QuestMgr() 
		{
			
		}
		
		public function UpdateQuests(Cmd:BasePacket, nAction:int = 1, Result:Object = null):void
		{
			var i:int;
			var quest:QuestInfo;
			// kiem tra du lieu quest
			for (i = 0; i < SeriesQuest.length; i++)
			{
				quest = SeriesQuest[i] as QuestInfo;
				if (!Result)
				{
					quest.UpdateQuest(Cmd, nAction);
				}
				else
				{
					quest.UpdateQuest(Cmd, nAction, Result);
				}
			}
			
			for (i = 0; i < DailyQuest.length; i++)
			{
				quest = DailyQuest[i] as QuestInfo;
				quest.UpdateQuest(Cmd, nAction);
			}
			
			//kiểm tra dữ liệu quest (new)	
			if ((curDailyQuest < 3) && (curDailyQuest != -1) && (DailyQuestNew.length != 0) && (Cmd.GetURL() != "QuestService.completeDailyQuestNew") && (Cmd.GetURL() != "QuestService.getDailyQuestNew"))
			{
				quest = DailyQuestNew[curDailyQuest] as QuestInfo;
				quest.UpdateQuestNew(Cmd, nAction);
			}
		}
		
		public function InitDailyQuest(dailyQuest:Object, isShowGui:Boolean):void
		{
			//if (GameLogic.getInstance().user.IsViewer())
				//return;
				
			if (DailyQuest.length > 0)
			{
				DailyQuest.splice(0, DailyQuest.length);
			}
			
			if (GameLogic.getInstance().user.GetMyInfo().NewDailyQuest)
			{
				//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
			}
			
			var quest:QuestInfo;
			var task:TaskInfo;
			var questConfig:QuestInfo;
			var taskConfig:TaskInfo;
			
			for (var i:String in dailyQuest)
			{
				quest = new QuestInfo();
				quest.QuestType = QuestInfo.QUEST_DAILY;
				task = new TaskInfo();
				task.SetInfo(dailyQuest[i]);
				quest.Id = task.Id;
				
				//questConfig = QuestINI.getInstance().GetDailyQuest(task.Id, task.Level);
				questConfig = ConfigJSON.getInstance().GetDailyQuest(task.Id, task.Level);
				taskConfig = questConfig.TaskList[0] as TaskInfo;
				if (task.Num >= taskConfig.MaxNum)
				{
					task.Status = true;
					//GuiMgr.getInstance().GuiTopInfo.btnDailyQuest.SetBlink(true);	
					//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);	
				}
				
				quest.TaskList.push(task);
				DailyQuest.push(quest);
			}
			
			//if(isShowGui)
			//if (GuiMgr.getInstance().GuiDailyQuest.IsVisible)
			//{ 
				//GuiMgr.getInstance().GuiDailyQuest.Init(0);	-1
				//GuiMgr.getInstance().GuiDailyQuest.RefreshComponent();
				//GuiMgr.getInstance().GuiTopInfo.btnDailyQuest.SetBlink(false);
			//}			
		}
		
		public function InitQuestPowerTinh(questData:Object):void
		{			
			var isNewDay:Boolean = Ultility.CheckOldDate(questData.LastTimeAccess);
			if (isNewDay)
			{
				PointReceived = 0;
				LastTimeAccess = GameLogic.getInstance().CurServerTime;
			}
			else
			{
				PointReceived = questData.PointReceived;
				LastTimeAccess = questData.LastTimeAccess;
			}
			questData = questData["Quest"];
			QuestPowerTinh = [];
			
			var quest:QuestInfo;
			var task:TaskInfo;
			var taskConfig:Object;
			var bonus:QuestBonus;
			
			// Duyệt toàn bộ 3 quest
			for (var i:int = 1; i < 6; i ++)
			{
				var index:int = 1;
				var str:String = i + "";
				
				// khởi tạo 1 quest mới
				quest = new QuestInfo();
				quest.Id = i;
				quest.QuestType = QuestInfo.QUEST_POWER_TINH;
				
				task = new TaskInfo();
				taskConfig = ConfigJSON.getInstance().GetItemList("PowerTinh_Quest")[quest.Id];
				task.SetInfo(questData[str]);
				task.Num = questData[str].Done;
				if (isNewDay)
				{
					task.Num = 0;
				}
				task.MaxNum = questData[str].Num;
				task.Id = quest.Id;
				if (task.Num >= task.MaxNum)
				{
					task.Status = true;
				}
				else
				{
					task.Status = false;
				}
				quest.TaskList.push(task);
				
				bonus = new QuestBonus();
				bonus.ItemType = "PowerTinhExchangePoint";
				bonus.ItemId = 1;
				bonus.Num = taskConfig.Point;
				quest.Bonus.push(bonus);
				
				QuestPowerTinh.push(quest);
			}
		}
		
		/**
		 * Khởi tạo mảng DailyQuestNew chứa các quest hàng ngày
		 * @param	dailyQuestNew	Object server trả về
		 * @param	isShowGui		
		 */
		public function InitDailyQuestNew(questData:Object, isShowGui:Boolean):void
		{
			questDataSave = questData;
			// làm rỗng mảng DaiyQuestNew
			if (DailyQuestNew.length > 0)
			{
				DailyQuestNew = [];
			}
			
			// Rung button nếu có quest mới
			var isNewDay:Boolean = GameLogic.getInstance().user.GetMyInfo().NewDailyQuest;
			if (isNewDay)
			{
				//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
				GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
			}
			
			var quest:QuestInfo;
			var task:TaskInfo;
			var bonus:QuestBonus;
			var questConfig:QuestInfo;
			var taskConfig:TaskInfo;
			
			retryTime = questData["ResetTime"];
			
			// Duyệt toàn bộ 3 quest
			for (var i:int = 1; i < 4; i ++)
			{
				var index:int = 1;
				var str:String = i + "";
				
				// khởi tạo 1 quest mới
				quest = new QuestInfo();
				quest.Id = i;
				quest.QuestType = QuestInfo.QUEST_DAILY_NEW;
				
				
				// Duyệt toàn bộ các task trong quest
				var k:int = 1;
				// Mảng các task
				var arr:Array = [];
				for (var j:String in questData["DailyQuest"][str])
				{
					// Cho danh sách các task vào mảng
					questData["DailyQuest"][str][j]["Id"] = j;
					questData["DailyQuest"][str][j]["Param"] = j;
					arr.push(questData["DailyQuest"][str][j]);
				}
				
				for (var l:int = 0; l < arr.length; l++)
				{
					var myLevel:int = arr[l]["Level"];
					questConfig = ConfigJSON.getInstance().GetDailyQuestNew(arr, myLevel);
					taskConfig = questConfig.TaskList[l] as TaskInfo;
					// khởi tạo 1 task mới
					task = new TaskInfo();
					task.SetInfo(arr[l]);
					//task.Id = int(l);
					task.MaxNum = taskConfig.MaxNum;
					task.Param = taskConfig.Param;
					if (task.MaxNum <= task.Num)
						task.Status = true;
					
					//for (var m:int = 0; m < arr.length
					//task.Num = taskConfig.Num;
					
					
					var GiftList:Object = ConfigJSON.getInstance().GetDailyQuestGiftNew(myLevel);
					if (GiftList)
					{
						bonus = new QuestBonus();
						bonus.SetInfo(GiftList[String(i)]);
						index++;					
						quest.Bonus.push(bonus);
					}
					
					quest.TaskList.push(task);
				}
				
				DailyQuestNew.push(quest);
				
				//Khi hết quest trong daily quest rùi thì
				//phải lấy thông tin xu từ level hiện tại của user
				if (arr.length == 0) myLevel = GameLogic.getInstance().user.GetMyInfo().Level;
				XuInfo = ConfigJSON.getInstance().GetDailyQuestXu(myLevel);
			}
			
			// Đã thực hiện đến quest nào
			curDailyQuest = questData["CurrentQuest"] - 1;
			if (curDailyQuest > 2)
				curDailyQuest = -1;
			
			//GuiMgr.getInstance().GuiTopInfo.showDailyQuestTask(curDailyQuest);
			GuiMgr.getInstance().guiFrontScreen.showDailyQuestTask(curDailyQuest);
			
			// Cac hanh dong dac biet
			var curQuest:QuestInfo = DailyQuestNew[curDailyQuest];
			if (curQuest != null)
			{
				checkSpecialTask(curQuest);
			}
			
				
			if (GuiMgr.getInstance().GuiDailyQuestNew.IsVisible)
			{ 
				GuiMgr.getInstance().GuiDailyQuestNew.refreshComponent();
				//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(false);
				GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(false);
			}		
			
			if (isQuestDone() && !isBlink)
			{
				//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
				GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
				QuestMgr.getInstance().isBlink = true;
			}
		}
		
		public function checkSpecialTask(curQuest:QuestInfo):void
		{
			SpecialTask = new Object();
			for (var z:int = 0; z < curQuest["TaskList"].length; z++)
			{
				switch (curQuest["TaskList"][z].Action)
				{
					case "earnMoney":
						SpecialTask["earnMoney"] = curQuest["TaskList"][z];
						break;
					case "useEnergy":
						SpecialTask["useEnergy"] = curQuest["TaskList"][z];
						break;
					case "collectMaterial":
						SpecialTask["collectMaterial"] = curQuest["TaskList"][z];
						break;
					case "fishingFish":
						SpecialTask["fishingFish"] = curQuest["TaskList"][z];
				}
			}
		}
		
		public function InitSeriesQuest(seriesQues:Object, isInitRun:Boolean = false, isLevelUp:Boolean = false):void
		{
			//if (GameLogic.getInstance().user.IsViewer())
				//return;	

			ClearAllSeriQuest();
			
			var quest:QuestInfo;	
			for (var i:String in seriesQues)
			{
				quest = new QuestInfo();
				quest.IdSeriesQuest = seriesQues[i].Id;
				quest.SetInfo(seriesQues[i].Quest);		
				quest.LevelRequire = ConfigJSON.getInstance().GetSeriesQuestInfo(quest.IdSeriesQuest, "LevelRequire") as int;
				quest.UpdateStatusQuest();
				SeriesQuest.push(quest);				
			}
			
			//Sắp xếp lại thứ tự
			SeriesQuest.sortOn("LevelRequire", Array.NUMERIC);
			
			if (GameLogic.getInstance().user.IsViewer() == false)
			{
				//GuiMgr.getInstance().GuiTopInfo.InitButtonSeriesQuest();
				GuiMgr.getInstance().guiFrontScreen.initBtnSeriesQuest();
				CheckPopUpSeriQuest(isInitRun, isLevelUp);
			}			
			
			//Nếu gui seriquest đang hiển thị rùi thì chuyển nội dung sang quest khác
			//var gui:GUISeriesQuest = GuiMgr.getInstance().GuiSeriesQuest;		
			var gui:GUIMainQuest = GuiMgr.getInstance().guiMainQuest;
			if(gui.IsVisible && gui.curQuest != null && gui.curQuest.IdSeriesQuest > 0)
			{
				quest = GetSeriesQuest(gui.curQuest.IdSeriesQuest);
				gui.showGUI(quest);
			}
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE) {
				LeagueInterface.getInstance().updateGuiTopForLeague();
				if (GuiMgr.getInstance().GuiLevelUp)
				{
					if (GuiMgr.getInstance().GuiLevelUp.img)
					{
						GuiMgr.getInstance().GuiLevelUp.Hide();
					}
				}
			}
		}
		
		// kiem tra xem 1 action co phai thuoc quest ko
		public function IsQuest(Cmd:BasePacket):Boolean
		{
			var i:int;
			var quest:QuestInfo;
			// kiem tra du lieu quest
			//for (i = 0; i < DailyQuest.length; i++)
			//{
				//quest = DailyQuest[i] as QuestInfo;
				//if (quest.IsQuest(Cmd))
				//{
					//return true;
				//}
			//}
			
			for (i = 0; i < SeriesQuest.length; i++)
			{
				quest = SeriesQuest[i] as QuestInfo;
				if (quest.IsQuest(Cmd))
				{
					return true;
				}
			}
			
			// kiểm tra có phải dailyquest new hay ko
			if (DailyQuestNew.length != 0)
			{
				// Nếu đã hết quest
				if (curDailyQuest == -1)
					return false;
				
				// Nếu còn quest
				quest = DailyQuestNew[curDailyQuest] as QuestInfo;
				if (quest.IsDailyQuestNew(Cmd))
				{
					return true;
				}
			}
			
			// Update harded-code ở một số task đặc biệt không gửi lên server thông qua APIs cụ thể
			if (SpecialTask["useEnergy"] != null)
			{
				switch (Cmd.GetID())
				{
					case Constant.CMD_CLEAN_LAKE:
					case Constant.CMD_FEED_FISH:
					case Constant.CMD_CARE_FISH:
					case Constant.CMD_MATE_FISH:
					case Constant.CMD_MIX_FISH:
					case Constant.CMD_FISHING:
					case Constant.CMD_ATTACK_FRIEND_LAKE:
					case Constant.CMD_ATTACK_OCEAN_SEA:
					case Constant.CMD_ATTACK_BOSS_OCEAN_SEA:
						return true;
						break;
				}
			}
			
			if (SpecialTask["collectMaterial"] != null)
			{
				switch (Cmd.GetID())
				{
					case Constant.CMD_CARE_FISH:
					case Constant.CMD_FEED_FISH:
					case Constant.CMD_FISHING:
					case Constant.CMD_CLEAN_LAKE:
					case Constant.CMD_ATTACK_FRIEND_LAKE:
						var isFriend:Boolean = GameLogic.getInstance().user.IsViewer();
						if (isFriend)
							return true;
						break;
				}
			}
			
			if (SpecialTask["earnMoney"] != null)
			{
				var Id:String = Cmd.GetID();
				switch (Id)
				{
					case Constant.CMD_COLLECT_MONEY:
					case Constant.CMD_STEAL_MONEY:
					case Constant.CMD_SELL_FISH:
					case Constant.CMD_ACCEPT_DAILY_GIFT:
					case Constant.CMD_COMPLETE_SERIES_QUEST:
					case Constant.CMD_FISHING:
					case Constant.CMD_SELL_DECORATE:
					case Constant.CMD_SELL_SPARTA:
					case Constant.CMD_SELL_STOCK_THING:
					case Constant.CMD_SEND_CLICK_MERMAID:
					case Constant.CMD_LEVEL_UP:
					case Constant.CMD_GET_NEW_USER_GIFT_BAG:
					case Constant.CMD_GET_DAILY_BONUS:
					case Constant.CMD_ATTACK_FRIEND_LAKE:
					case Constant.CMD_ATTACK_BOSS_OCEAN_SEA:
					case Constant.CMD_ATTACK_OCEAN_SEA:
						return true;
						break;
				}
			}
			
			if (SpecialTask["fishingFish"] != null)
			{
				var Id1:String = Cmd.GetID();
				switch (Id1)
				{
					case Constant.CMD_FISHING:
						return true;
						break;
				}
			}
			
			return false;
		}
		
		public function GetDailyQuest(idQuest:int):QuestInfo
		{
			for (var i:int = 0; i < DailyQuest.length; i++)
			{
				var quest:QuestInfo = DailyQuest[i] as QuestInfo;
				if (quest.Id == idQuest)
				{
					return quest;
				}
			}
			return null;
		}
		
		/**
		 * Hàm trả về danh sách DailyQuest mới
		 * @author	longpt
		 * @param	idQuest:	id của Quest cần trả về, mặc định -1 là tất cả các quest
		 * @return	danh sách các quest yêu cầu
		 */
		public function GetDailyQuestNew():Array
		{
			return DailyQuestNew;
		}
		
		/**
		 * Hàm cập nhật hoàn thành task bằng xu, nếu hoàn thành quest thì gửi gói tin nhận quà lên server
		 * @author	longpt
		 * @param	qId		id của quest		
		 * @param	tId		id của task trong quest
		 */
		
		public function DoneTaskWithXu(qId:String, tId:int):void
		{
			// Cập nhật thông tin task
			var tskList:Array = DailyQuestNew[curDailyQuest]["TaskList"];
			for (var i:int = 0; i < tskList.length; i++)
			{
				if (tskList[i].Id != tId) continue;
				
				var task:TaskInfo = tskList[i];
			
				task.Num = task.MaxNum;
				task.Status = true;
			}
			
			// Hiển thị lại nội dung GUI
			if (GuiMgr.getInstance().GuiDailyQuestNew.IsVisible)
			{
				if (isQuestDone())
				{
					QuestMgr.getInstance().isBlink = true;
				}
				GuiMgr.getInstance().GuiDailyQuestNew.refreshComponent();
			}
			else if (isQuestDone())
			{
				//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
				GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
				QuestMgr.getInstance().isBlink = true;
			}
		}

		/**
		 * Hàm chuyển sang nhiệm vụ mới
		 * @return
		 */
		public function nextQuest():void		
		{
			// Chuyển nhiệm vụ hiện thời
			if (curDailyQuest < 2)
			{
				curDailyQuest += 1;
				if (curDailyQuest != 1 || isUnlock)
				{
					checkSpecialTask(DailyQuestNew[curDailyQuest]);
				}
			}
			else curDailyQuest = -1;

			// Hiển thị lại nội dung GUI
			if (GuiMgr.getInstance().GuiDailyQuestNew.IsVisible)
			{
				GuiMgr.getInstance().GuiDailyQuestNew.refreshComponent();
				GuiMgr.getInstance().GuiDailyQuestNew.ChangeTabPos(String(curDailyQuest));
			}
			QuestMgr.getInstance().isBlink = false;

			//GuiMgr.getInstance().GuiTopInfo.showDailyQuestTask(curDailyQuest);
			GuiMgr.getInstance().guiFrontScreen.showDailyQuestTask(curDailyQuest);
		}
		
		/**
		 * Hàm kiểm tra quest hiện thời đã hoàn thành chưa
		 * @return
		 */
		public function isQuestDone():Boolean
		{
			if (curDailyQuest == -1)	return false;
			var tskList:Array = DailyQuestNew[curDailyQuest]["TaskList"];
			var isDone:Boolean = true;
			for (var i:int = 0; i < tskList.length; i++)
			{
				var task:TaskInfo = tskList[i];
				if (task.Status != true) 	
				{
					isDone = false;
					break;
				}
			}
			return isDone;
		}
		
		/**
		 * Mở quest 2 ra
		 */
		public function UnlockQuest2():void
		{
			checkSpecialTask(DailyQuestNew[curDailyQuest]);
			GuiMgr.getInstance().GuiDailyQuestNew.unlockQuest2();
		}
		
		/**
		 * Hàm trả về quest đang thực hiện dở
		 * @return
		 */
		public function findCurrentQuest():int
		{
			for (var i:int = 0; i < DailyQuestNew.length; i++)
			{
				var tskList:Array = DailyQuestNew[i]["TaskList"];
				var isDone:Boolean = true;
				for (var j:int = 0; j < tskList.length; j++)
				{
					var task:TaskInfo = tskList[j];
					if (task.Status != true) 	
					{
						isDone = false;
						break;
					}
				}
				if (!isDone)
				{
					return i;
				}
			}
			
			//Nếu như đã hoàn thành tất cả các quest
			return -1;
		}
		
		public function RemoveDailyQuest(id:int):void
		{
			for (var i:int = 0; i < DailyQuest.length; i++)
			{
				var quest:QuestInfo = DailyQuest[i] as QuestInfo;
				if (quest.TaskList[0].Id == id)
				{					
					DailyQuest.splice(i, 1);
					break;
				}
			}
		}		
		
		
		public function GetSeriesQuest(idSeriesQuest:int):QuestInfo
		{
			for (var i:int = 0; i < SeriesQuest.length; i++)
			{
				var quest:QuestInfo = SeriesQuest[i] as QuestInfo;
				if (quest.IdSeriesQuest == idSeriesQuest)
				{
					return quest;
				}
			}
			return null;
		}
		
		public function RemoveSeriesQuest(idSeriesQuest:int, idQuest:int):void
		{
			var quest:QuestInfo;
			for (var i:int = 0; i < SeriesQuest.length; i++)
			{
				quest = SeriesQuest[i] as QuestInfo;
				if (quest.IdSeriesQuest == idSeriesQuest && quest.Id == idQuest)
				{
					SeriesQuest.splice(i, 1);
					break;
				}
			}
			
			for (i = 0; i < finishedQuest.length; i++)
			{
				quest = finishedQuest[i] as QuestInfo;
				if (quest.IdSeriesQuest == idSeriesQuest && quest.Id == idQuest)
				{
					finishedQuest.splice(i, 1);
					break;
				}
			}
		}
		
		public function GetCurTutorial():String
		{
			//var quest:QuestInfo = null;
			//quest = GuiMgr.getInstance().GuiSeriesQuest.MyQuest;
			var quest:QuestInfo = GuiMgr.getInstance().guiMainQuest.curQuest;
			
			if (quest == null)
			{
				return "";
			}
			else
			{
				return quest.GetCurTutorial();
			}
		}
		
		public function ClearAllSeriQuest():void
		{
			SeriesQuest.splice(0, SeriesQuest.length);			
		}
		
		
		public function CheckPopUpSeriQuest(isInitRun:Boolean, isLevelUp:Boolean):void
		{
			for (var i:int = 0; i < SeriesQuest.length && i < MAX_VISIBLE_QUEST; i++)
			{
				var quest:QuestInfo = SeriesQuest[i] as QuestInfo;
				if (isInitRun && quest.IdSeriesQuest == ID_SERI_BEGIN_JOIN)
				{
					if (quest.Id == 1 && GuiMgr.getInstance().guiMainQuest.IsVisible == false)
					{
						//GuiMgr.getInstance().GuiSeriesQuest.InitSeriesQuest(quest);
						GuiMgr.getInstance().guiMainQuest.showGUI(quest);
					}		
				}
				//if (isLevelUp)
				//{
					//if(	quest.IdSeriesQuest == ID_SERI_MIX_FISH_SKILL_OVER_LEVEL
						//|| quest.IdSeriesQuest == ID_SERI_MIX_FISH_SKILL_SALE_OFF
						//|| quest.IdSeriesQuest == ID_SERI_MIX_FISH_SKILL_RARE
						//|| quest.IdSeriesQuest == ID_SERI_MIX_FISH_SKILL_SPECIAL 
						//|| quest.IdSeriesQuest == ID_SERI_FISH_WAR)
						//{
							//if (quest.Id == 1)
							//{
								//GuiMgr.getInstance().GuiSeriesQuest.InitSeriesQuest(quest, true, isLevelUp);
							//}				
						//}
				//}
			}
		}
		
		public function convertQuestIdToArrayIndex(questId:String):int
		{
			// Lấy phần tử cuối cùng của questId - 1 , gán kiểu int
			// ví dụ: Quest1 -> 0, Quest2 -> 1...
			var pos:int = questId.length -1;
			var index:int = int(questId.slice(pos));
			return index -1;
		}
		
		public function UpdatePointReceive():void
		{
			for (var i:int = 0; i < QuestPowerTinh.length; i++)
			{
				var task:TaskInfo = QuestPowerTinh[i].TaskList[0] as TaskInfo;
				if (!task.Status && task.Num >= task.MaxNum)
				{
					PointReceived += (QuestPowerTinh[i].Bonus[0] as QuestBonus).Num;
					task.Status = true;
					//GuiMgr.getInstance().GuiTopInfo.btnQuestPowerTinh.SetBlink(true);
					GuiMgr.getInstance().guiFrontScreen.btnSpiritPowerQuest.SetBlink(true);
				}
			}
			
			if (GuiMgr.getInstance().GuiQuestPowerTinh.IsVisible)
			{
				GuiMgr.getInstance().GuiQuestPowerTinh.RefreshComponent();
			}
		}
	}

}