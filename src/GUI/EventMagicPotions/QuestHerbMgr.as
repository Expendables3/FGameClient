package GUI.EventMagicPotions 
{
	import Data.ConfigJSON;
	import Event.EventMgr;
	import flash.utils.getQualifiedClassName;
	import GUI.GuiMgr;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.TaskInfo;
	import NetworkPacket.BasePacket;
	/**
	 * Quản lý quest của event Thảo Dược
	 * @author longpt
	 */
	public class QuestHerbMgr 
	{
		private static var instance:QuestHerbMgr;
		
		private var QuestList:Array = [];
		private var QuestStillOnQueue:Array = [];	// Quest cho ket qua server tra ve
		
		public static function getInstance():QuestHerbMgr
		{
			if(instance == null)
			{
				instance = new QuestHerbMgr();
			}				
			return instance;
		}
		
		public function QuestHerbMgr() 
		{
			
		}
		
		public function InitQuest(questData:Object, refreshMoneyTime:int, isBlink:Boolean = true):void
		{
			if (QuestList.length > 0)
			{
				QuestList.splice(0, QuestList.length);
			}
			
			var quest:QuestHerbInfo;
			var task:TaskInfo;
			var taskConfig:Object;
			var bonus:QuestBonus;
			
			// Duyệt toàn bộ 3 quest
			for (var i:int = 1; i < 4; i ++)
			{
				var index:int = 1;
				var str:String = i + "";
				
				// khởi tạo 1 quest mới
				quest = new QuestHerbInfo();
				quest.Id = i;
				if (questData[str].GotGift)
				{
					quest.Status = true;
				}
				else
				{
					quest.Status = false;
				}
				quest.QuestType = QuestInfo.QUEST_EVENT_HERB;
				quest.RefreshMoney = refreshMoneyTime;
				
				task = new TaskInfo();
				taskConfig = ConfigJSON.getInstance().GetItemList("MagicPotion_Quest")[GetModeQuestHerb(questData[str].IdQuest)][questData[str].IdQuest];
				task.SetInfo(taskConfig);
				task.Num = questData[str].Done;
				task.MaxNum = questData[str].Num;
				task.Id = questData[str].IdQuest;
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
				var bonusCfg:Object = ConfigJSON.getInstance().GetItemList("MagicPotion_Cost")[GetModeQuestHerb(questData[str].IdQuest)]["Gift"];
				bonus.SetInfo(bonusCfg);
				quest.Bonus.push(bonus);
				
				if (isBlink && quest.Status == false && task.Status == true)
				{
					//GuiMgr.getInstance().GuiTopInfo.btnEvent.SetBlink(true);
				}
				if (quest.Status == false && task.Status == true)
				{
					quest.isBlink = true;
				}
				QuestList.push(quest);
			}
		}
		
		public function UpdateQuestHerb(Type:String, NewData:Object, OldData:Object):void
		{
			if (EventMgr.CheckEvent("MagicPotion") != EventMgr.CURRENT_IN_EVENT)
			{
				return;
			}
			
			for (var i:int = 0; i < QuestList.length; i++)
			{
				var quest:QuestHerbInfo = QuestList[i] as QuestHerbInfo;
				var task:TaskInfo = quest.TaskList[0] as TaskInfo;
				quest.UpdateQuest(OldData as BasePacket, 1, NewData);
				if (!quest.isBlink && quest.Status == false && task.Status == true && !GuiMgr.getInstance().GuiQuestHerb.IsVisible)
				{
					//GuiMgr.getInstance().GuiTopInfo.btnEvent.SetBlink(true);
					quest.isBlink = true;
				}
			}
		}
		
		public function GetModeQuestHerb(idQuest:int):int
		{
			return Math.ceil(idQuest / 13);
		}
		
		public function GetQuestHerbList():Array
		{
			return QuestList;
		}
	}
	
	

}