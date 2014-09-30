package GUI.QuestPowerTinh 
{
	import Data.Localization;
	import Data.QuestINI;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.TaskInfo;
	import Logic.Ultility;
	
	/**
	 * Container chứa 1 task
	 * @author longpt
	 */
	public class QuestPowerTinhContainer extends Container 
	{
		private const BTN_GO_TO_TASK:String = "BtnGoToTask";
		
		private const QUEST_GIFT:int = 1;
		private const QUEST_DAILY_BONUS:int = 2;
		//private const QUEST_SEPARATE:int = 3;
		private const QUEST_DONE_DAILY_QUEST_1:int = 3;
		private const QUEST_DONE_DAILY_QUEST_2:int = 4;
		private const QUEST_RETRY_DAILY_QUEST:int = 5;
		
		private var questInfo:QuestInfo;
		//private var TaskUserInfo:Object;
		
		public function QuestPowerTinhContainer(parent:Object, quest:QuestInfo, x:int = 0, y:int = 0, imgName:String = "", isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "GuiQuestPowerTinh_TaskBg", x, y, isLinkAge, imgAlign);
			questInfo = quest;
			//TaskUserInfo = GameLogic.getInstance().user.GetMyInfo().PowerTinhQuest[TaskId];
			RefreshContent();
		}
		
		public function RefreshContent():void
		{
			ClearComponent();
			
			var task:TaskInfo = questInfo.TaskList[0];
			var bonus:QuestBonus = questInfo.Bonus[0];
			
			var txtFormat:TextFormat = new TextFormat();
			if (task.Num >= task.MaxNum)
			{
				txtFormat.color = 0x00ff00;
			}
			
			AddLabel(Localization.getInstance().getString("QuestPowerTinhTask" + questInfo.Id), 10, 3, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
			AddButton(BTN_GO_TO_TASK, "GuiQuestPowerTinh_BtnGoToFeature", 550, 0);
			
			
			if (task.Num >= task.MaxNum)
			{
				AddImage("", "IcComplete", 350, 18).SetScaleXY(0.6);
			}
			else
			{
				AddLabel(task.Num + "/" + task.MaxNum, 295, 3, 0xffffff, 1, 0x000000);
			}
			AddLabel("+" + bonus.Num, 400, 3, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			//AddLabel(TaskUserInfo.Done + "/" + TaskUserInfo.Num, 295, 3, 0xffffff, 1, 0x000000);
			AddImage("", "GuiQuestPowerTinh_Icon", 480, 16);
			
			AddLabel("Đến", 560, 5, 0xffffff, 0, 0x000000);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (questInfo.Id)
			{
				case QUEST_GIFT:
					GuiMgr.getInstance().GuiGift.showGuiGift();
					break;
				case QUEST_DAILY_BONUS:
					GuiMgr.getInstance().GuiDailyBonus.Init();
					break;
				/*case QUEST_SEPARATE:
					GuiMgr.getInstance().GuiChooseEquipment.Init(null);
					break;*/
				case QUEST_DONE_DAILY_QUEST_1:
				case QUEST_DONE_DAILY_QUEST_2:
				case QUEST_RETRY_DAILY_QUEST:
					GuiMgr.getInstance().GuiDailyQuestNew.Init(false);
					break;
			}
			GuiMgr.getInstance().GuiQuestPowerTinh.Hide();
		}
	}

}