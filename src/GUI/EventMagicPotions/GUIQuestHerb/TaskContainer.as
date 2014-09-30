package GUI.EventMagicPotions.GUIQuestHerb 
{
	import com.bit101.components.HBox;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	import GUI.EventMagicPotions.NetworkPacket.DoneHerbQuest;
	import GUI.EventMagicPotions.NetworkPacket.GetNewHerbQuest;
	import GUI.EventMagicPotions.NetworkPacket.QuickDoneHerbQuest;
	import GUI.EventMagicPotions.QuestHerbInfo;
	import GUI.EventMagicPotions.QuestHerbMgr;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.QuestInfo;
	import Logic.TaskInfo;
	import Logic.Ultility;
	
	/**
	 * Container chứa 1 task của nhiệm vụ
	 * @author longpt
	 */
	public class TaskContainer extends Container 
	{
		public var quest:QuestHerbInfo;
		public var task:TaskInfo;
		public var giftId:int = 0;
		public var cfg:Object; //config
		
		private static const BTN_DONE_QUEST_FAST:String = "BtnDoneQuestFast";
		private static const BTN_GET_MORE_TASK_MONEY:String = "BtnGetMoreMoney";
		private static const BTN_GET_MORE_TASK_ZMONEY:String = "BtnGetMoreZMoney";
		private static const BTN_GET_GIFT:String = "BtnGetGift";
		private static const BTN_AUTO:String = "BtnAuto";
		
		public function TaskContainer(parent:Object, _quest:QuestHerbInfo, x:int = 0, y:int = 0, imgName:String = "", isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			this.quest = _quest;
			this.task = _quest.TaskList[0];
			giftId = QuestHerbMgr.getInstance().GetModeQuestHerb(task.Id);
			
			super(parent, "GuiQuestHerb_TaskContainer", x, y, isLinkAge, imgAlign);
			RefreshContent();
		}
		
		public function RefreshContent():void
		{
			ClearComponent();
			// Mô tả nhiệm vụ
			var txtF:TextField;
			var tF:TextFormat;
			txtF = AddLabel(Localization.getInstance().getString("HerbTask" + task.Id), 63, 25, 0xffffff, 1, 0x000000);
			
			tF = new TextFormat();
			tF.size = 14;
			txtF.setTextFormat(tF);
			
			txtF.wordWrap = true;
			//txtF.border = true;
			txtF.width = 230;
			if (txtF.numLines >= 3)
			{
				txtF.y -= 5;
			}
			
			txtF = AddLabel(task.Num + "/" + task.MaxNum, 273, 25, 0xffffff, 1, 0x000000);
			tF.size = 16;
			if (task.Num >= task.MaxNum)
			{
				tF.color = 0x00ff00;
			}
			else
			{
				tF.color = 0xff0000;
			}
			txtF.setTextFormat(tF);
			
			var ctn:Container = AddContainer("", "GuiQuestHerb_CtnGift", 363, 7);
			ctn.AddImage("", quest.Bonus[0].ItemType + quest.Bonus[0].ItemId, ctn.img.width / 2 + 2, ctn.img.height / 2 + 2);
			ctn.AddLabel(quest.Bonus[0].Num, 40, 35, 0xffffff, 0, 0x000000);
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = Localization.getInstance().getString(quest.Bonus[0].ItemType + quest.Bonus[0].ItemId);
			ctn.setTooltip(tt);
			
			AddImage("", "GuiQuestHerb_CtnTick", 40, 37);
			
			//Add Button lam nhanh hoac lam lai
			cfg = ConfigJSON.getInstance().GetItemList("MagicPotion_Cost");
			cfg = cfg[ConvertModeToId(task.Id)];
			if (task.Status)
			{
				if (quest.Status)
				{
					/*// Làm lại
					if (!cfg.Max || quest.RefreshMoney >= cfg.Max)
					{
						AddButton(BTN_GET_MORE_TASK_ZMONEY, "GuiQuestHerb_BtnRefresh_ZMoney", 393, 27);
						AddLabel(cfg.Refresh.ZMoney + "", 433, 28, 0xffffff, 1, 0x000000);
					}
					else
					{
						AddButton(BTN_GET_MORE_TASK_MONEY, "GuiQuestHerb_BtnRefresh_Money", 393, 27);
						AddLabel(cfg.Refresh.Money + "", 429, 28, 0xffffff, 1, 0x000000);
					}*/
					
					AddButton(BTN_GET_MORE_TASK_ZMONEY, "GuiQuestHerb_BtnRefresh_ZMoney", 433, 27);
					AddLabel(cfg.Refresh.ZMoney + "", 473, 28, 0xffffff, 1, 0x000000);
				}
				else
				{
					// Nhận quà
					AddButton(BTN_GET_GIFT, "GuiQuestHerb_BtnGetGift", 433, 27);
				}
				
				AddImage("", "GuiQuestHerb_IcTick", 40, 37);
			}
			else
			{
				AddButton(BTN_DONE_QUEST_FAST, "GuiQuestHerb_BtnDoneFast", 433, 27);
				AddLabel(cfg.QuickDone.ZMoney + "", 473, 28, 0xffffff, 1, 0x000000);
			}
			
			//AddButton(BTN_AUTO, "GuiQuestHerb_BtnAuto", 530, 27);
			
			var x0:int = 30;
			var y0:int = 22;
			var dx:int = 20;
			var dy:int = 0;
			var ddx:int = 9;
			for (var i:int = 0; i < giftId; i++)
			{
				AddImage("", "GuiQuestHerb_QuestStar", x0 + i * dx + (3 - giftId) * ddx, y0 + i * dy).SetScaleXY(0.6);
			}
		}
		
		private function ConvertModeToId(taskId:int):int
		{
			return Math.ceil(taskId / 13);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_DONE_QUEST_FAST:
					processDoneQuestFast();
					break;
				case BTN_GET_MORE_TASK_MONEY:
					processGetMoreTask(true);
					break;
				case BTN_GET_MORE_TASK_ZMONEY:
					processGetMoreTask(false);
					break;
				case BTN_GET_GIFT:
					processGetGift();
					break;
				case BTN_AUTO:
					var curBtn:Button = GetButton(buttonID);
					var global:Point = this.img.localToGlobal(new Point(curBtn.img.x + curBtn.img.width / 2, curBtn.img.y + curBtn.img.height));
					GuiMgr.getInstance().GuiTooltipAutoHerb.Init(this.giftId, global);
					break;
			}
		}
		
		private function processGetGift():void
		{
			GetButton(BTN_GET_GIFT).SetDisable();
			
			// Cmd
			var cmd:DoneHerbQuest = new DoneHerbQuest(quest.Id);
			Exchange.GetInstance().Send(cmd);
			
			// Add quà
			GuiMgr.getInstance().GuiStore.UpdateStore(quest.Bonus[0].ItemType, quest.Bonus[0].ItemId, quest.Bonus[0].Num);
			
			// Effect
			EffectMgr.setEffBounceDown("Nhận thành công", quest.Bonus[0].ItemType + quest.Bonus[0].ItemId, 330, 280, null, quest.Bonus[0].Num);
			
			quest.Status = true;
			
			//GuiMgr.getInstance().GuiQuestHerb.RefreshComponent();
		}
		
		private function processDoneQuestFast():void
		{
			if (cfg.QuickDone.ZMoney > GameLogic.getInstance().user.GetZMoney())
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
			}
			
			GetButton(BTN_DONE_QUEST_FAST).SetDisable();
			
			// Cmd
			var cmd:QuickDoneHerbQuest = new QuickDoneHerbQuest(quest.Id);
			Exchange.GetInstance().Send(cmd);
			
			// Pay
			GameLogic.getInstance().user.UpdateUserZMoney( -cfg.QuickDone.ZMoney);
			
			task.Status = true;
			task.Num = task.MaxNum;
			
			RefreshContent();
		}
		
		private function processGetMoreTask(isMoney:Boolean):void
		{
			var cmd:GetNewHerbQuest;
			
			// Update Làm lại
			/*if (cfg.Max && quest.RefreshMoney < cfg.Max)
			{
				if (cfg.Refresh.Money > GameLogic.getInstance().user.GetMoney())
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ vàng", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
				
				quest.RefreshMoney = quest.RefreshMoney + 1;
				
				// Cmd
				cmd = new GetNewHerbQuest(quest.Id, true);
				Exchange.GetInstance().Send(cmd);
				
				// Pay
				GameLogic.getInstance().user.UpdateUserMoney( -cfg.Refresh.Money);
			}
			else
			{
				if (cfg.Refresh.ZMoney > GameLogic.getInstance().user.GetZMoney())
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
			
				// Cmd
				cmd = new GetNewHerbQuest(quest.Id, false);
				Exchange.GetInstance().Send(cmd);
				
				// Pay
				GameLogic.getInstance().user.UpdateUserZMoney( -cfg.Refresh.ZMoney);
			}*/
			
			if (cfg.Refresh.ZMoney > GameLogic.getInstance().user.GetZMoney())
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
			}
		
			// Cmd
			cmd = new GetNewHerbQuest(quest.Id, false);
			Exchange.GetInstance().Send(cmd);
			
			// Pay
			GameLogic.getInstance().user.UpdateUserZMoney( -cfg.Refresh.ZMoney);
			
			RefreshContent();
		}
	}

}