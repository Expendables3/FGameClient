package GUI.EventMagicPotions 
{
	import flash.utils.getQualifiedClassName;
	import Logic.QuestInfo;
	import Logic.TaskInfo;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class QuestHerbInfo extends QuestInfo 
	{
		public var RefreshMoney:int;
		public var isBlink:Boolean = false;
		
		public function QuestHerbInfo() 
		{
			super();
		}
		
		public override function UpdateQuest(Cmd:BasePacket, nAction:int = 1, Result:Object = null):void
		{
			if (nAction <= 0)
			{
				return;
			}
			
			var j:int;
			var count:int = nAction;
			
			var task:TaskInfo = TaskList[0];
			
			if (task.Status == true) return;
			if (Cmd.getAPI() != task.Action) return;
			
			var IsTaskDone:Boolean = true;
			for (var itm:String in task.Param)
			{
				/*if (!(itm in Cmd)) 
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
						if (getQualifiedClassName(task.Param[itm]) != "Array")
						{
							for (var s:String in task.Param[itm])
							{
								if (s in obj)			// s trong ItemList[i]
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
						else if (getQualifiedClassName(task.Param[itm]) == "Array")
						{
							var isQuest:Boolean = true;
							for (var k:int = 0; k < task.Param[itm].length; k++)
							{
								IsTaskDone = true;
								var obj1:Object = task.Param[itm][k];
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
					for (var st:String in task.Param[itm])
					{
						if (st in Cmd[itm])
						{
							if (!CompareParam(task.Param[itm][st], Cmd[itm][st], st))
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
				}*/
			}
			
			if (IsTaskDone)
			{
				if ((Result != task.Param) && (task.Param != null))
				{
					for (var ss:String in task.Param)
					{
						if (ss in Result)
						{
							if (!CompareParam(task.Param[ss], Result[ss], ss))
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
				if (task.Num >= task.MaxNum)
				{
					task.Status = true;
				}
				trace("cap nhat hanh dong quest thanh cong!");
			}
		}
		
	}

}