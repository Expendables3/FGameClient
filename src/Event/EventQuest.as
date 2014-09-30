package Event 
{
	import com.greensock.easing.Quad;
	import Data.QuestINI;
	import flash.utils.getQualifiedClassName;
	import Logic.GameLogic;
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author ...
	 */
	public class EventQuest 
	{
		// du lieu co ban
		public var IdEvent:int;
		public var Name:String;
		public var IconName:String;
		public var ExpireDate:Date;
		public var NPC:String;
		public var LevelRequire:int;
		public var Decription:String;
		public var TaskList:Array = [];
		public var Bonus:Array = [];
		
		// thong tin lay tu database ve
		public var Status:Boolean = false;
		public var Id:int;
		
		public function EventQuest() 
		{
			
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
								var task:EventTask = new EventTask();
								task.SetInfo(data[itm][i]);
								this[itm].push(task);
							}
						}
						else if (itm == "Bonus")
						{					
							for (i in data[itm])
							{
								//var bonus:QuestBonus = new QuestBonus();
								//bonus.SetInfo(data[itm][i]);
								//this[itm].push(bonus);
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
		
		
		private function CompareParam(param1:Object, param2:Object, ParamName:String):Boolean
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
		
		
		
		public function UpdateInfoQuest(quest:Object):void
		{
			SetInfo(quest);
			
			var questConfig:EventQuest;
			var taskConfig:EventTask;
			var task:EventTask;			
			
			Status = true;
			//questConfig = QuestINI.getInstance().GetSeriesQuest(IdSeriesQuest, Id);
			for (var i:int = 0; i < TaskList.length; i++)
			{				
				task = TaskList[i] as EventTask;
				taskConfig = questConfig.TaskList[i] as EventTask;
				task.Action = taskConfig.Action;
				task.Param = taskConfig.Param;
				task.MaxNum = taskConfig.MaxNum;
				task.Icon = taskConfig.Icon;
				
				if (task.isDone())
				{
					task.Status = true;
				}
				else
				{
					Status = false;
				}
			}
		}
		
		public function CheckQuestDone():Boolean
		{
			var i:int;
			var task:EventTask;
			for (i = 0; i < TaskList.length; i++)
			{
				task = TaskList[i];			
				if (task.Status == false)
				{
					return false;
				}
			}
			
			Status = true;
			return true;
		}
		
		
		/**
		 * update hanh dong quest
		 */
		public function UpdateQuest(Cmd:BasePacket, nAction:int = 1):void
		{
			if (nAction <= 0) return;
			
			var i:int;
			var j:int;
			var count:int = nAction;
			for (i = 0; i < TaskList.length; i++)
			{
				var task:EventTask = TaskList[i];
				if (task.Status == true) continue;
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
						count = 0;
						for (j = 0; j < Cmd[itm].length; j++)
						{
							var obj:Object = Cmd[itm][j];
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
					task.Num += count;
					// kiem tra hoan thanh task			
					if (task.isDone())
					{
						task.Status = true;
						
						// kiem tra xong quest
						if (Status == false)
						{
							if (CheckQuestDone())
							{
								//Quest done
							}
						}
					}
				}

			}
		}
		
		
		
		
		/**
		 * Kiem tra xem 1 action co phai la event hay ko
		 */
		public function IsEvent(Cmd:BasePacket):Boolean
		{
			var i:int;
			for (i = 0; i < TaskList.length; i++)
			{
				var task:EventTask = TaskList[i];				
				if (task.Status == true) continue;
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
	}

}