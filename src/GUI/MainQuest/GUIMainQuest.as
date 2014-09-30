package GUI.MainQuest 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.GameLogic;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendCompleteSeriesQuest;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIMainQuest extends BaseGUI 
	{
		private var themeName:String;
		public var curQuest:QuestInfo;
		public var soldierElement:int;//Hệ con cá khi thả ra hồ để dùng khi hoàn thành quest thả cá
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_RECEIVE:String = "btnReceive";
		
		public function GUIMainQuest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				if (!curQuest.Status)
				{
					SetPos(42, 42);
				}
				else
				{
					SetPos(42 + 80, 42);
				}
				OpenRoomOut();
				//EndingRoomOut();
			}
			LoadRes(themeName);
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 300 + 240 + 153, 21);
			
			//Nhan quest
			var questConfig:QuestInfo = ConfigJSON.getInstance().GetSeriesQuest(curQuest.IdSeriesQuest, curQuest.Id);				
			var txtFormat:TextFormat = new TextFormat("Arial", 20, 0x000000, true);	
			if (!curQuest.Status)
			{
				AddImage("", "GuiMainQuest_Title_" + curQuest.IdSeriesQuest + "_" + curQuest.Id, 115, 22, true, ALIGN_LEFT_TOP);
				AddButton(BTN_CLOSE, "GuiMainQuest_BtnGoHome", 100 + 136 + 130, 394 + 90);
				var npcMessage:String = Localization.getInstance().getString("SeriQuestNPC" + curQuest.IdSeriesQuest + curQuest.Id);
				var npcText:TextField = AddLabel(npcMessage, 100 - 51, 67 + 43, 0x000000, 0);
				npcText.wordWrap = true;
				npcText.width = 123;
				txtFormat.size = 12;
				txtFormat.color = 0x8e3900;
				txtFormat.align = TextFormatAlign.JUSTIFY;
				npcText.setTextFormat(txtFormat);
				if(curQuest.IdSeriesQuest == 1 && curQuest.Id < 7)
				{
					AddImage("", "GuiMainQuest_FairyFish3", 50 + 62, 250 + 110);
				}
				else
				{
					AddImage("", "GuiMainQuest_FairyFish1", 50 + 62, 250 + 110);
				}
				
				//Add các task
				for (var i:int = 0; i < curQuest.TaskList.length; i++ )
				{
					var taskConfig:TaskInfo = questConfig.TaskList[i] as TaskInfo;
					var task:TaskInfo = curQuest.TaskList[i] as TaskInfo;
					var conTask:Container = AddContainer("", "", 183 + 26, 110 + i*40);
					conTask.LoadRes("");
					//Add câu miêu tả task
					var guide:String = Localization.getInstance().getString("SeriQuestTask" + curQuest.IdSeriesQuest + (curQuest.Id) + (i + 1));
					var textFieldGuide:TextField = conTask.AddLabel(guide, 25, 32, 0xffffff, 0, 0xaf09d2);
					textFieldGuide.wordWrap = true;
					textFieldGuide.width = 360;
					if (textFieldGuide.height > 12)
					{
						textFieldGuide.y -= (textFieldGuide.height - 12) / 2;
					}
					txtFormat = new TextFormat("arial", 16, 0xffffff, true);
					textFieldGuide.setTextFormat(txtFormat);
					
					//Add số lượng
					var textFieldNum:TextField = conTask.AddLabel(task.Num + "/" + taskConfig.MaxNum, 265 + 132, 32, 0x09cc63, 0);
					txtFormat.size = 16;
					txtFormat.color = 0x09cc63;
					textFieldNum.setTextFormat(txtFormat);
					
					if (task.Num >= taskConfig.MaxNum)
					{
						task.Status = true;
						//conTask.AddImage("", "IcComplete2",  textFieldNum.x + textFieldNum.textWidth + 20, 25);
						
					}		
				}
				
				//Add phần thưởng
				AddAward(questConfig.Bonus, 325, 216 + 37, this);
				
				//Goi y:
				//var instruction:String = Localization.getInstance().getString("SeriQuestTip" + curQuest.IdSeriesQuest + curQuest.Id);
				//AddLabel("Gợi ý: ", 181, 300, 0x000000, 0).setTextFormat(txtFormat);
				//var labelInstruction:TextField = AddLabel(instruction, 230 + 18 + 56 + 14 - 88, 300 + 135, 0xffffff, 0, 0x000000);
				//labelInstruction.width = 350;
				//labelInstruction.wordWrap = true;
				//txtFormat.color = 0xffffff;
				//txtFormat.align = "left";
				//txtFormat.size = 13;
				//labelInstruction.setTextFormat(txtFormat);
				var iconHelp:String = "GuiMainQuest_IconQuest_" + curQuest.IdSeriesQuest + "_" + curQuest.Id;
				if ((curQuest.IdSeriesQuest == 4 && curQuest.Id == 1) || (curQuest.IdSeriesQuest == 5 && curQuest.Id == 1))
				{
					iconHelp = "GuiMainQuest_IconQuest_1_9";
				}
				AddImage("", iconHelp, 160, 205).FitRect(450, 150, new Point(220, 337));							
			}
			//Hoan thanh
			else
			{
				AddImage("", "GuiMainQuest_Title_" + curQuest.IdSeriesQuest + "_" + curQuest.Id, 281, 37, true, ALIGN_CENTER_TOP);
				AddButton(BTN_RECEIVE, "BtnNhanThuong", 100 + 136 + 58, 394);
				AddAward(questConfig.Bonus, 300 - 44, 216 + 67, this);
					
				if(curQuest.IdSeriesQuest == 1 && curQuest.Id < 7)
				{
					AddImage("", "GuiMainQuest_FairyFish4", 50 + 90, 250 + 48);
				}
				else
				{
					AddImage("", "GuiMainQuest_FairyFish2", 50 + 90, 250 + 48);
				}
			}
		}
		
		private function AddAward(bonusArr:Array, x:int, y:int, container:Container):void
		{			
			var itemImgName:String;
			var image:Image;
			var tf:TextField;
			var format:TextFormat = new TextFormat("arial", 13, 0xffffff, true);		
			//var x:int, y:int;
			var tipText:String = "";
			for (var i:int = 0; i < bonusArr.length; i++)
			{
				var conAward:Container = container.AddContainer("", "", x + i*68, y, true, container);
				conAward.LoadRes("");
				var bonus:QuestBonus = bonusArr[i] as QuestBonus;
				switch(bonus.ItemType)
				{
					case "Money":
						itemImgName = "IcGold";
						tipText = "Tiền vàng";
						break;
					case "Exp":
						itemImgName = "ImgEXP";
						tipText = "Kinh nghiệm";
						break;
					case "ZMoney":
						itemImgName = "IcZingXu";
						tipText = "Tiền Xu";
						break;
					case "StampPack":
						itemImgName = "GuiMainQuest_TemPack";
						tipText = "Bộ tem";
						break;
					case "Armor":
					case "Weapon":
					case "Helmet":
					case "Belt":
					case "Ring":
					case "Necklace":
						var bg:Image = conAward.AddImage("", FishEquipment.GetBackgroundName(bonus.Color), 0, 0, true, ALIGN_LEFT_TOP);
						bg.FitRect(63, 60, new Point(0, 0));
						var rank:int = soldierElement * 100 + bonus.Rank;
						if (soldierElement == 0)
						{
							rank = 100 + bonus.Rank;
						}
						if (bonus.ItemType == "Belt" || bonus.ItemType == "Ring" || bonus.ItemType == "Necklace")
						{
							rank = bonus.Rank;
						}
						itemImgName = FishEquipment.GetEquipmentName(bonus.ItemType, rank, bonus.Color) + "_Shop";
						tipText = FishEquipment.GetEquipmentLocalizeName(bonus.ItemType, rank, bonus.Color);
						break;
					case "Iron":
					case "PowerTinh":
					case "Jade":
						itemImgName = bonus.ItemType;
						tipText = Localization.getInstance().getString(bonus.ItemType);
						break;
					case "SoulRock":
						itemImgName = bonus.ItemType;
						tipText = Localization.getInstance().getString(bonus.ItemType) + " cấp " + bonus.ItemId;
						break;
					case "Soldier":
						if(soldierElement != 0)
						{
							itemImgName = "Fish3" + (soldierElement+1)+"0_Old_Idle";
						}
						else
						{
							itemImgName = "Fish360_Old_Idle";
						}
						tipText = "Ngư Thủ";
						break;
					default:
						itemImgName = bonus.ItemType + bonus.ItemId;	
						tipText = ConfigJSON.getInstance().getItemInfo(bonus.ItemType, bonus.ItemId)[ConfigJSON.KEY_NAME];
						break;
				}
				
				image = conAward.AddImage("", itemImgName, 0, 0, true, ALIGN_LEFT_TOP);
				image.FitRect(58, 58, new Point(0, 0));
				if (bonus.ItemType == "SoulRock")
				{
					var rankImage:Image = conAward.AddImage("", "Number_" + bonus.ItemId, 0, 0, true, ALIGN_LEFT_TOP);
					rankImage.FitRect(20, 20, new Point( 21, 16));
				}
				
				//Add số lượng
				tf = conAward.AddLabel(Ultility.StandardNumber(bonus.Num), -20, 40, 0xffffff, 1, 0x26709C);
				tf.setTextFormat(format);				
				//Add tooltip
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = tipText;
				conAward.setTooltip(tooltip);
			}		
		}
		
		public function showGUI(quest:QuestInfo):void
		{
			curQuest = quest;
			if (quest == null)
			{
				return;
			}
			//Các quest đặc biệt
			if (quest.IdSeriesQuest == 1 && quest.Id == 1)
			{
				GuiMgr.getInstance().guiIntroFishWarQuest.Show(Constant.GUI_MIN_LAYER, 3);
			}
			else
			if (quest.IdSeriesQuest == 1 && quest.Id == 6)
			{
				GuiMgr.getInstance().guiChooseSoldierQuest.Show(Constant.GUI_MIN_LAYER, 3);
			}
			else
			{
				if(curQuest.Status)
				{
					themeName = "GuiMainQuest_CompleteTheme";
					HelperMgr.getInstance().HideHelper();
				}
				else
				{
					themeName = "GuiMainQuest_Theme";
				}
				if(img == null)
				{
					Show(Constant.GUI_MIN_LAYER, 3);
				}
				else if(IsFinishRoomOut)
				{
					ClearComponent();
					EndingRoomOut();
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					if (curQuest != null)
					{
						curQuest.setShowTutorial(true);
					}
					if(GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					//hiển thị phần thưởng của những seriquest đã hoàn thành nhưng còn trong hàng đợi
					var questAr:Array = QuestMgr.getInstance().finishedQuest;
					if (questAr.length > 0)
					{
						GameLogic.getInstance().OnQuestDone(questAr[0]);		
						questAr.splice(0, 1);
					}
					break;
				case BTN_RECEIVE:					
					CompleteQuest();
					if (GameLogic.getInstance().user.IsViewer() && Ultility.IsInMyFish())
					{
						GameController.getInstance().UseTool("Home");
					}
					break;
			}
		}
		
		private function CompleteQuest():void
		{
			if (curQuest == null) return;
			if (curQuest.IdSeriesQuest != 0 && curQuest.Id != 0)
			{
				//Hoàn thành quest thả cá thì gửi thêm hệ để tạo vũ khí
				var param:Object = new Object();
				if (curQuest.Id == 7 && curQuest.IdSeriesQuest == 1)
				{
					param["Element"] = soldierElement;
				}
				var cmd:SendCompleteSeriesQuest = new SendCompleteSeriesQuest(curQuest.IdSeriesQuest, curQuest.Id, 0, param);
				Exchange.GetInstance().Send(cmd);
				
				//Update vao kho
				var questConfig:QuestInfo = ConfigJSON.getInstance().GetSeriesQuest(curQuest.IdSeriesQuest, curQuest.Id);	
				var  bonusArr:Array = questConfig.Bonus;	
				for (var i:int = 0; i < bonusArr.length; i++)
				{
					var bonus:QuestBonus = bonusArr[i] as QuestBonus;
					switch (bonus.ItemType)
					{
						case "Money":
							GameLogic.getInstance().user.UpdateUserMoney(bonus.Num);
							break;
						case "Exp":					
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + bonus.Num);
							break;		
						case "ZMoney":
							GameLogic.getInstance().user.UpdateUserZMoney(bonus.Num);
							break;
						case "Soldier":
						case "Weapon":
						case "Armor":
						case "Helmet":
						case "Ring":
						case "Necklace":
						case "Bracelet":
						case "Belt":
							//trace("GUIMainQuest.as Helmet()");
							for (var j:int = 0; j < bonus.Num; j++)
							{
								GameLogic.getInstance().user.GenerateNextID();
							}
							break;
						case "Jade":
						case "Iron":
						case "SoulRock":
						case "SixColorTinh":
						case "PowerTinh":
						case "Jade":
							GameLogic.getInstance().user.updateIngradient(bonus.ItemType, bonus.Num, bonus.ItemId);
							break;
						case "StampPack":
							break;
						default:
							GuiMgr.getInstance().GuiStore.UpdateStore(bonus.ItemType, bonus.ItemId, bonus.Num);
							break;
					}
				}
				
				QuestMgr.getInstance().RemoveSeriesQuest(curQuest.IdSeriesQuest, curQuest.Id);	
				
				//Het Quest
				if (curQuest.IdSeriesQuest == 7 && curQuest.Id == 2)
				{
					GuiMgr.getInstance().guiCongratFinishQuest.Show();
				}
				curQuest = null;
				Hide();
			}			
		}
		
	}

}