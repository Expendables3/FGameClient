package Logic 
{
	import adobe.utils.CustomActions;
	import Data.INI;
	import Data.QuestINI;
	import flash.utils.getQualifiedClassName;
	import GameControl.GameController;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.GuiMgr;
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class QuestInfo
	{
		public static const QUEST_DAILY:int = 1;
		public static const QUEST_SERIES:int = 2;
		public static const QUEST_DAILY_NEW:int = 3;
		public static const QUEST_EVENT_HERB:int = 4;
		public static const QUEST_POWER_TINH:int = 5;
		
		// du lieu co ban
		public var IdSeriesQuest:int;
		public var Name:String;
		public var Icon:String;
		public var ExpireDate:Date;
		public var NPC:String;
		public var LevelRequire:int;
		public var Decription:String;
		public var TaskList:Array = [];
		public var Bonus:Array = [];
		public var QuestType:int = QUEST_SERIES;
		private var ShowTutorial:Boolean;
		
		// thong tin lay tu database ve
		public var Status:Boolean = false;
		public var Id:int;
		
		public var isSentCompleteQuest:Boolean = false;
		
		public function QuestInfo()
		{
			ShowTutorial = false;
		}
		
		public function setShowTutorial(show:Boolean):void
		{
			this.ShowTutorial = true;
			//trace("true roi: ",idNum, Id, ShowTutorial);
		}
		
		public function GetCurTutorial():String
		{
			var result:String = "";
			//trace("quest: ", idNum, Id, this.ShowTutorial);
			if (ShowTutorial)
			{
				for (var i:int = 0; i < TaskList.length; i++ )
				{
					var task:TaskInfo = TaskList[i] as TaskInfo;
					if (task.Status == false && checkUserIdParam(task))
					{
						result = getTutorial(task.Action);
						switch(task.Action)
						{
							case "feed":
								GameLogic.getInstance().user.UpdateFishHelper(task.Action);
								break;
							case "sell":
								GameLogic.getInstance().user.UpdateFishHelper(task.Action);
								break;
							case "useEquipmentSoldier":
								GameLogic.getInstance().user.UpdateFishHelper("soldier1");
								break;
							case "attackFriendLake":
							case "fishing":
								GameLogic.getInstance().user.UpdateFishHelper("visitFriend");
								break;
							case "recoverHealthSoldier":
								if(GameLogic.getInstance().gameState == GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER)
								{
									GameLogic.getInstance().user.UpdateFishHelper("soldier1");
								}
								break;
							case "acttackMonster":
								GameLogic.getInstance().user.UpdateFishHelper("Monster1");
								break;
							case "useGem":
								GameLogic.getInstance().user.UpdateFishHelper("soldier1");
								break;
						}
					}
				}
			}
			
			return result;
		}
		
		/**
		 * Hàm trả về string các tutorial
		 * @param	action
		 * @return
		 */
		private function getTutorial(action:String):String
		{
			var result:String = "";
			switch(action)
			{
				case "buy":
					result = "Shop/ShopFish/Fish_1_Money/BuyFish";
					break;
				case "feed":
					result = "FeedFishTool";
					break;
				case "sell":
					result = "SellFishTool/sell";
					break;
				case "useItem":
					result = "InventoryTool/InventorySpecial/Use_Energy";
					break;
				case "useBabyFish":
					result = "InventoryTool/BabyFishSoldier/Use_FishSoldier";
					break;
				case "useEquipmentSoldier":
					result = "soldier1/useEquipmentSoldier";
					break;
				case "attackFriendLake":
					result = "VisitFriend/FishWarMode/attackFriendLake";
					break;
				case "recoverHealthSoldier":
					result = "InventoryTool/SupportTab/Use_RecoverHealthSoldier/recoverHealthSoldier/soldier1";
					break;
				case "acttackMonster":
					result = "MapOcean/FirstOcean/BtnUnlock/BtnAttack/Monster1/attackMonster";
					break;
				case "sendGift":
					result = "BtnFriendGift/BtnSendGift1/SeaBall/BtnSendGift2/ChooseFriend/BtnSendGift3";
					break;
				case "fishing":
					result = "VisitFriend/Fishing";
					break;
				case "exchangeItemCollection":
					result = "BtnFishWar/BtnCollection/BtnExchangeCollection";
					break;
				case "upgradeGem":
					result = "BtnRefinePearl/BtnNextGuide/BtnExitPearl/ChoosePearl/BtnRefine";
					break;
				case "useGem":
					result = "InventoryTool/GemTab/Use_Gem";
					break;
				case "boostItem":
					result = "MaterialTool/ChooseMaterial/JoinMaterial";
					break;
				case "enchantEquipment":
					result = "BtnEnchantEquip/EquipmentEnchant/ChooseEnchantMaterial/DoEnchant";
					break;
				case "refineIngredient":
					result = "BtnEquipmentStore/BtnSeparateEquip/ChooseSeparateEquipment/SeparateOneEquipment";
					break;
				case "craftEquip":
					result = "BtnCreateEquipment/CreateWeaponSkill/BtnCreateEquip";
					break;
				case "getGiftTraining":
					result = "BtnTrainingTower/StartTraining/SpeedUp/GetGiftTraining";
					break;
				case "upgradeMeridian":
					result = "BtnMeridian/StingMeridian";
					break;
				default:
					result = "";
					break;
			}
			return result;
		}
		
		private function checkUserIdParam(task:TaskInfo):Boolean
		{
			var viewer:Boolean = GameLogic.getInstance().user.IsViewer();
			if (task.Param["UserId"] == "Self")
			{
				return viewer == false?true:false;
			}
			else if (task.Param["UserId"] == "Other")
			{
				return viewer == true?true:false;
			}
			return true;
		}
		
		public function SetInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{				
					if (itm in this)
					{
						if (itm == "TaskList")
						{					
							for (var i:String in data[itm])
							{
								var task:TaskInfo = new TaskInfo();
								task.SetInfo(data[itm][i]);
								this[itm].push(task);
							}
						}
						else if (itm == "Bonus")
						{					
							for (i in data[itm])
							{
								var bonus:QuestBonus = new QuestBonus();
								bonus.SetInfo(data[itm][i]);
								this[itm].push(bonus);
							}
						}
						else
						{
							this[itm] = data[itm];
						}
					}
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
		
		public function AddTask(obj:TaskInfo):void
		{
			var task:TaskInfo = new TaskInfo();
			task.Id = obj.Id;
			task.Action = obj.Action;
			task.Decription = obj.Decription;
			task.Icon = obj.Icon;
			task.MaxNum = obj.MaxNum;
			task.Param = obj.Param;
			task.Result = obj.Result;
			
			TaskList.push(task);
		}
		
		public function AddBonus(bonus:QuestBonus):void
		{
			Bonus.push(bonus);
		}
		
		public function CheckQuestDone():Boolean
		{
			var i:int;
			var task:TaskInfo;
			//var questConfig:QuestInfo = null;
			//if(QuestType == QUEST_SERIES)
			//{
				//questConfig = QuestINI.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
			//}				
			for (i = 0; i < TaskList.length; i++)
			{
				task = TaskList[i];			
				//if (QuestType == QUEST_DAILY)
				//{
					//questConfig = QuestINI.getInstance().GetDailyQuest(task.Id, task.Level);
				//}
				//var taskConfig:TaskInfo = questConfig.TaskList[i] as TaskInfo;
				//if (task.Num < taskConfig.MaxNum)
				if (task.Status == false)
				{
					return false;
				}
			}
			
			Status = true;
			return true;
		}
		
		protected function CompareParam(param1:Object, param2:Object, ParamName:String):Boolean
		{
			switch (ParamName)
			{
				case "UserId":
					if (param1 == "Self")
					{
						if (param2 == GameLogic.getInstance().user.GetMyInfo().Id)
						{
							return true;
						}
						else
						{
							return false
						}
					}
					else if (param1 == "Other")
					{
						if (param2 != GameLogic.getInstance().user.GetMyInfo().Id)
						{
							return true;
						}
						else
						{
							return false
						}
					}
					else
					{
						return true;
					}
					
					break;
				default:
					if (param1 != param2)
					{
						return false;
					}
					break;
			}
			
			return true;
		}
		
		/**
		 * update hanh dong quest
		 */
		public function UpdateQuest(Cmd:BasePacket, nAction:int = 1, Result:Object = null):void
		{
			if (nAction <= 0) return;
			
			var i:int;
			var j:int;
			var count:int = nAction;
			for (i = 0; i < TaskList.length; i++)
			{
				var task:TaskInfo = TaskList[i];
				var questConfig:QuestInfo = null;
				if (QuestType == QUEST_DAILY)
				{
					//questConfig = QuestINI.getInstance().GetDailyQuest(task.Id, task.Level);
					questConfig = ConfigJSON.getInstance().GetDailyQuest(task.Id, task.Level);
				}
				else
				{
					//questConfig = QuestINI.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
					questConfig = ConfigJSON.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
				}
				
				var taskConfig:TaskInfo = questConfig.TaskList[i] as TaskInfo;
				if (task.Status == true) continue;
				if (Cmd.getAPI() != taskConfig.Action) continue;

				var IsTaskDone:Boolean = true;
				for (var itm:String in taskConfig.Param)
				{
					if (!(itm in Cmd)) 
					{
						IsTaskDone = false;
						break;
					}

					if (getQualifiedClassName(Cmd[itm]) == "Array") // neu la mang
					{
						count = 0;
						for (j = 0; j < Cmd[itm].length; j++)			//ItemList
						{
							var obj:Object = Cmd[itm][j];					// Itemlist[i]
							var isEnd:Boolean = (j == Cmd[itm].length - 1);
							if (getQualifiedClassName(taskConfig.Param[itm]) != "Array")
							{
								for (var s:String in taskConfig.Param[itm])
								{
									if (s in obj)			// s trong ItemList[i]
									{
										if (!CompareParam(taskConfig.Param[itm][s], obj[s], s))
										{
											IsTaskDone = false;
											break;
										}
									}
									else
									{
										IsTaskDone = false;
										break;
									}
								}
								if (IsTaskDone)
								{
									count++;
									
									//if (taskConfig.Result == null)
									//{
										//count++;
									//}
									//else
									//{
										//if (Result == taskConfig.Result)
										//{
											//count++;
										//}
									//}
								}
								else
								{
									break;
								}
							}
							else if (getQualifiedClassName(taskConfig.Param[itm]) == "Array")
							{
								var isQuest:Boolean = true;
								for (var k:int = 0; k < taskConfig.Param[itm].length; k++)
								{
									IsTaskDone = true;
									var obj1:Object = taskConfig.Param[itm][k];
									for (var s1:String in obj1)
									{
										if (s1 in obj)			// s trong ItemList[i]
										{
											if (!CompareParam(obj1[s1], obj[s1], s1))
											{
												if (isEnd)
												{
													IsTaskDone = false;
													break;
												}
											}
										}
										else
										{
											if (isEnd)
											{
												IsTaskDone = false;
												break;
											}
										}
									}
									if (IsTaskDone)
									{
										//count++;
									}
									else
									{
										if (isEnd)
										{
											isQuest = false;
											break;
										}
									}
								}
								
								if (isQuest)
								{
									count++;
									//if (taskConfig.Result == null)
									//{
										//count++;
									//}
									//else
									//{
										//if (Result == taskConfig.Result)
										//{
											//count++;
										//}
									//}
									break;
								}
								else
								{
									break;
								}
							}
						}
					}
					else if (getQualifiedClassName(Cmd[itm]) == "Object") // neu la object
					{
						for (var st:String in taskConfig.Param[itm])
						{
							if (st in Cmd[itm])
							{
								if (!CompareParam(taskConfig.Param[itm][st], Cmd[itm][st], st))
								{
									IsTaskDone = false;
									break;
								}
							}
							else
							{
								IsTaskDone = false;
								break;
							}
						}
					}
					else // neu ko la mang
					{
						if (!CompareParam(taskConfig.Param[itm], Cmd[itm], itm))
						{
							IsTaskDone = false;
							break;
						}	
					}

				}
				
				if (IsTaskDone)
				{
					if ((Result != taskConfig.Result) && (taskConfig.Result != null))
					{
						for (var ss:String in taskConfig.Result)
						{
							if (ss in Result)
							{
								if (!CompareParam(taskConfig.Result[ss], Result[ss], ss))
								{
									IsTaskDone = false;
									break;
								}
							}
							else
							{
								IsTaskDone = false;
								break;
							}
						}
					}
				}
				
				if (IsTaskDone)
				{
					task.Num += count;
					// kiem tra hoan thanh task			
					if (task.Num >= taskConfig.MaxNum)
					{
						task.Status = true;
						
						// kiem tra xong quest
						if (Status == false)
						{
							if (CheckQuestDone())
							{
								//Nếu guil lai đang bật thì không hiển thị nhận phần thưởng của quest nữa
								//Đợi sau khi tắt gui lai mới hiển thị kết quả
								if (GuiMgr.getInstance().guiMateFish.IsVisible
									|| GuiMgr.getInstance().GuiFishWar.IsVisible
									|| GuiMgr.getInstance().GuiInfoFishWar.IsVisible
									|| GameController.getInstance().isFishing
									|| GuiMgr.getInstance().GuiGemRefine.IsVisible
									|| GuiMgr.getInstance().GuiEnchantEquipment.IsVisible
									|| GuiMgr.getInstance().GuiRawMaterials.IsVisible
									|| GuiMgr.getInstance().guiMeridian.IsVisible
									|| GameLogic.getInstance().isFighting) 
								{
									QuestMgr.getInstance().finishedQuest.push(this);
								}
								else
								{
									GameLogic.getInstance().OnQuestDone(this);		
								}								
							}
						}
					}
				}

			}
		}
		
		
		public function UpdateQuestNew(Cmd:BasePacket, nAction:int = 1):void
		{
			// Lấy quest đang thực hiện ra
			var questList:Array = QuestMgr.getInstance().GetDailyQuestNew();
			var curQuest:QuestInfo = questList[QuestMgr.getInstance().curDailyQuest];
			
			var count:int = nAction;
			
			// Duyệt quest hiện đang thực hiện
			// Duyệt từng task xem hành động này có thuộc task nào hay không
			
			
			
			//var quest: QuestInfo = curQuest as QuestInfo;
			//var task: TaskInfo = curQuest.TaskList[j] as TaskInfo;
			//var bonus:QuestBonus;	
			
			var lvl:int = GameLogic.getInstance().user.GetLevel();
			var questConfig:QuestInfo = ConfigJSON.getInstance().GetDailyQuestNew(TaskList, lvl);
			var questconfig:QuestInfo = QuestMgr.getInstance().GetDailyQuestNew()[QuestMgr.getInstance().curDailyQuest];
			
			for (var j:int = 0; j < curQuest["TaskList"].length; j ++)
			{
				var task:TaskInfo = TaskList[j];
				var taskConfig: TaskInfo = questConfig.TaskList[j] as TaskInfo;

				// Nếu như task đó chưa hoàn thành
				if (curQuest["TaskList"][j].Status == false)
				// Nếu như hành động đó là hành động trong quest
				
				// Nếu là hành động câu cá nhà bạn, API là fishing nhưng action server trả về là fishingFish nên phải check riêng
				//var action:String = Cmd.getAPI();
				//if (action == "fishing") action = "fishingFish";
				if (Cmd.getAPI() != curQuest["TaskList"][j].Action) continue;
				
				// 
				var IsTaskDone:Boolean = true;
				for (var itm:String in taskConfig.Param)
				{
					if (!(itm in Cmd)) 
					{
						IsTaskDone = false;
						break;
					}

					if (getQualifiedClassName(Cmd[itm]) == "Array") // neu la mang
					{
						count = 0;
						for (j = 0; j < Cmd[itm].length; j++)
						{
							var obj:Object = Cmd[itm][j];
							for (var s:String in taskConfig.Param[itm])
							{
								if (s in obj)
								{
									if (!CompareParam(taskConfig.Param[itm][s], obj[s], s))
									{
										IsTaskDone = false;
										break;
									}
								}
								else
								{
									IsTaskDone = false;
									break;
								}
							}
							if (IsTaskDone)
							{
								count++;
							}
							else
							{
								break;
							}
						}
					}
					if (getQualifiedClassName(Cmd[itm]) == "Object") // neu la object
					{
						for (var st:String in taskConfig.Param[itm])
						{
							if (st in Cmd[itm])
							{
								if (!CompareParam(taskConfig.Param[itm][st], Cmd[itm][st], st))
								{
									IsTaskDone = false;
									break;
								}
							}
							else
							{
								IsTaskDone = false;
								break;
							}
						}
					}
					else // neu ko la mang
					{
						if (!CompareParam(taskConfig.Param[itm], Cmd[itm], itm))
						{
							IsTaskDone = false;
							break;
						}	
					}
				}
				
				if (IsTaskDone)
				{
					
					//cập nhật task đã làm được 1 đơn vị
					task.Num += count;
					if (task.Num >= taskConfig.MaxNum)
					{
						task.Num = taskConfig.MaxNum;
						task.Status = true;
					}

					// nếu hoàn thành task cuối cùng trong quest, rung icon quest
					var con1:Boolean = QuestMgr.getInstance().isQuestDone();
					var con2:Boolean = GameLogic.getInstance().user.IsViewer();
					var blinked:Boolean = QuestMgr.getInstance().isBlink;
					if (con1 && !con2 && !blinked)
					{
						//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
						GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
						QuestMgr.getInstance().isBlink = true;
					}
				}
			}
		}
		
		public function IsDailyQuestNew(Cmd:BasePacket):Boolean
		{
			var i:int;
			var questConfig:QuestInfo = null;
			questConfig = QuestMgr.getInstance().GetDailyQuestNew()[QuestMgr.getInstance().curDailyQuest];
			//questConfig = ConfigJSON.getInstance().GetDailyQuestNew1(Id, TaskList[0].Level, TaskList);
			
			for (i = 0; i < TaskList.length; i++)
			{
				var taskConfig:TaskInfo = questConfig.TaskList[i] as TaskInfo;
				var task:TaskInfo = TaskList[i];
				if (task.Status == true) continue;
				//var action:String = Cmd.getAPI();
				//if (action == "fishing") action = "fishingFish";
				//if (action != task.Action) continue;
				if (Cmd.getAPI() != task.Action) continue;

				var IsTaskDone:Boolean = true;
				for (var itm:String in task.Param)
				{
					if (!(itm in Cmd)) 
					{
						IsTaskDone = false;
						break;
					}

					if (getQualifiedClassName(Cmd[itm]) == "Array") // neu la mang
					{
						var obj:Object = Cmd[itm][0];
						for (var s:String in task.Param[itm])
						{
							if (s in obj)
							{
								if (!CompareParam(task.Param[itm][s], obj[s], s))
								{
									IsTaskDone = false;
									break;
								}
							}
							else
							{
								IsTaskDone = false;
								break;
							}
						}
					}
					else // neu ko la mang
					{
						if (!CompareParam(task.Param[itm], Cmd[itm], itm))
						{
							IsTaskDone = false;
							break;
						}	
					}

				}
				
				if (IsTaskDone)
				{
					return true;
				}

			}
			return false;
		}
		
		/**
		 * Kiem tra xem 1 action co phai la hanh dong quest hay ko
		 */
		public function IsQuest(Cmd:BasePacket):Boolean
		{
			var i:int;
			for (i = 0; i < TaskList.length; i++)
			{
				var task:TaskInfo = TaskList[i];
				var questConfig:QuestInfo = null;
				if (QuestType == QUEST_DAILY)
				{
					//questConfig = QuestINI.getInstance().GetDailyQuest(task.Id, task.Level);
					questConfig = ConfigJSON.getInstance().GetDailyQuest(task.Id, task.Level);
				}
				else if (QuestType == QUEST_SERIES)
				{
					//questConfig = QuestINI.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
					questConfig = ConfigJSON.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
				}
				else
				{
					//for (var i:int = 0; i < 
					//questConfig = ConfigJSON.getInstance().GetDailyQuestNew(Id, task.Level, task.Id);
				}
				
				var taskConfig:TaskInfo = questConfig.TaskList[i] as TaskInfo;
				if (task.Status == true) continue;
				if (Cmd.getAPI() != taskConfig.Action) continue;

				var IsTaskDone:Boolean = true;
				for (var itm:String in taskConfig.Param)
				{
					if (!(itm in Cmd)) 
					{
						IsTaskDone = false;
						break;
					}

					if (getQualifiedClassName(taskConfig.Param[itm]) != "Array")
					{
						if (getQualifiedClassName(Cmd[itm]) == "Array") // neu la mang
						{
							for (var ii:int = 0; ii < Cmd[itm].length; ii++)
							{
								var obj:Object = Cmd[itm][ii];
								for (var s:String in taskConfig.Param[itm])
								{
									if (s in obj)
									{
										if (!CompareParam(taskConfig.Param[itm][s], obj[s], s))
										{
											IsTaskDone = false;
											break;
										}
									}
									else
									{
										IsTaskDone = false;
										break;
									}
								}
								
								if (IsTaskDone)
								{
									break;
								}
							}
						}
						if (getQualifiedClassName(Cmd[itm]) == "Object") // neu la object
						{
							for (var st:String in taskConfig.Param[itm])
							{
								if (st in Cmd[itm])
								{
									if (!CompareParam(taskConfig.Param[itm][st], Cmd[itm][st], st))
									{
										IsTaskDone = false;
										break;
									}
								}
								else
								{
									IsTaskDone = false;
									break;
								}
							}
						}
						else // neu ko la mang
						{
							if (!CompareParam(taskConfig.Param[itm], Cmd[itm], itm))
							{
								IsTaskDone = false;
								break;
							}	
						}
					}
					else
					{
						for (var jj:int = 0; jj < taskConfig.Param[itm].length; jj++)
						{
							//if (!IsTaskDone)
							//{
								//break;
							//}
							if (getQualifiedClassName(Cmd[itm]) != "Array")
							{
								IsTaskDone = false;
								break;
							}
							else
							{
								
								for (var kk:int = 0; kk < Cmd[itm].length; kk++)
								{
									var isFind:Boolean = true;
									for (var ss:String in taskConfig.Param[itm][jj])
									{
										if (ss in Cmd[itm][kk])
										{
											if (!CompareParam(taskConfig.Param[itm][jj][ss], Cmd[itm][kk][ss], ss))
											{
												isFind = false;
												break;
											}
										}
										else
										{
											isFind = false;
											break;
										}
										
										//if (isFind)
										//{
											//break;
										//}
									}
									
									//if (kk == Cmd[itm].length - 1)
									//{
										//if (IsTaskDone)
										//break;
									//}
									
									if (isFind)
									{
										break;
									}
								}
								
								if (!isFind)
								{
									IsTaskDone = false;
									break;
								}
							}
						}
					}
				}
				
				if (IsTaskDone)
				{
					return true;
				}

			}
			return false;
		}		
		
		
		public function UpdateStatusQuest():void
		{
			var questConfig:QuestInfo;
			var taskConfig:TaskInfo;
			var task:TaskInfo;
			
			Status = true;
			for (var i:int = 0; i < TaskList.length; i++)
			{
				task = TaskList[i] as TaskInfo;
				if (QuestType == QUEST_DAILY)
				{
					//questConfig = QuestINI.getInstance().GetDailyQuest(task.Id, task.Level);
					questConfig = ConfigJSON.getInstance().GetDailyQuest(task.Id, task.Level);
				}
				else if (QuestType == QUEST_SERIES)
				{
					//questConfig = QuestINI.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
					questConfig = ConfigJSON.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
				}
				else
				{
					//questConfig = ConfigJSON.getInstance().GetDailyQuestNew(task.Id, task.Level);
				}
				
				taskConfig = questConfig.TaskList[i] as TaskInfo;
				task.Action = taskConfig.Action;
				task.Param = taskConfig.Param;

				
				if (task.Num >= taskConfig.MaxNum)
				{
					task.Status = true;
				}
				else
				{
					Status = false;
				}
			}
		}
		
		
	}

}