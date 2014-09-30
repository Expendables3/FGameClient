package GUI.MainQuest 
{
	import com.greensock.easing.Quad;
	import Data.Localization;
	import Data.QuestINI;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendCompleteSeriesQuest;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class GUISeriesQuest extends BaseGUI
	{
		private const GUI_SERIESQUEST_BTN_EXIT:String = "BtnExit";
		private const GUI_SERIESQUEST_BTN_BACK:String = "BtnBack";
		private const GUI_SERIESQUEST_BTN_RECEIVE:String = "BtnReceive";
		private const GUI_SERIESQUEST_BTN_FEED:String = "BtnFeed";
		
		// quest7
		private static const BTN_DONG_Y:String = "BtnDongY";
		private static const BTN_CANCEL:String = "BtnThoat";
		private static const CTN_GIFT:String = "CtnGift";
		
		//Luu thong tin quest
		public var MyQuest:QuestInfo = null;
		
		public var IDSeriesQuest:int;	
		public var questId:int;
		private var IsDataReady:Boolean;
		private var IsLevelUped:Boolean;
				
		private var rateScale:Number = 1;
	
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
				
		public function GUISeriesQuest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUISeriesQuest";
		}
		
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(125, 40);
				AddButton(GUI_SERIESQUEST_BTN_EXIT, "BtnThoat", 540, 19, this);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				if (MyQuest && MyQuest.IdSeriesQuest)
				{
					OpenRoomOut(0, rateScale);
				}
			}
			//if (MyQuest && MyQuest.IdSeriesQuest)
			{
				LoadRes("GuiSeriesQuest1_Theme");
			}
			//else
			//{
				//LoadRes("GuiSeriesQuest" + IDSeriesQuest + "_Theme");
			//}
		}				

		
		public function InitSeriesQuest(quest:QuestInfo, dataAvailable:Boolean = true, isPopUp:Boolean = true):void
		{
			if (quest == null) return;       
	
			IsDataReady = dataAvailable;
			
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
			{
				GameLogic.getInstance().BackToIdleGameState();
			}
			
			if (!isPopUp)	
			{
				if (GuiMgr.getInstance().GuiTopInfo.btnExQuestHelp && GuiMgr.getInstance().GuiTopInfo.btnExQuestHelp.img && !GameLogic.getInstance().user.IsViewer())	
				{
					GuiMgr.getInstance().GuiTopInfo.ShowNotifyNewQuest();
				}
				return;
			}
			
			MyQuest = quest;
			if (quest.Status == true && quest.Id > 1 && quest.IdSeriesQuest < 7)
			{
				rateScale = 0.9;
			}
			else
			{
				rateScale = 1;
			}
			
			GuiMgr.getInstance().GuiSeriesQuest.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public override function  EndingRoomOut():void
		{	
			if (IsDataReady)
			{
				RefreshComponent(MyQuest);
			}
		}
		
		
		public function RefreshComponent(quest:QuestInfo, dataAvailable:Boolean = true, isLevelup:Boolean = false):void
		{
			if (quest == null) return;
			if (isLevelup)
			{				
				Hide();
				
				return;
			}
			MyQuest = quest;
			//trace("refresh: ", MyQuest.idNum);
			IsDataReady = dataAvailable;
			if (!IsDataReady || !IsFinishRoomOut)
			{
				return;
			}
			if (img == null) return;
			
			//Clear các component trong gui
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			ClearComponent();
			
			AddButton(GUI_SERIESQUEST_BTN_EXIT, "BtnThoat", 540, 19, this);
			if (quest.Status == true)
			{
				InitQuest(quest);
			}
			else
			{
				FinishQuest(quest);
				HelperMgr.getInstance().HideHelper();
			}
		}
		
		private function InitIntro(quest:QuestInfo):void
		{
			var questConfig:QuestInfo = ConfigJSON.getInstance().GetSeriesQuest(MyQuest.IdSeriesQuest, MyQuest.Id);		
			
			//add ảnh tên seriquest
			AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_ImgName", img.width / 2 + 20, 17, true, ALIGN_CENTER_TOP);
			
			//Add ảnh giới thiệu seriquest
			var strImgIntro:String = "GuiSeriesQuest" + quest.IdSeriesQuest + "_ImgIntro";
			var introImg:Image = AddImage("", strImgIntro, 60, 60, true, ALIGN_LEFT_TOP);			
			introImg.SetPos((img.width - introImg.img.width) / 2 + 10, 90);
			
			var button:Button = AddButton(GUI_SERIESQUEST_BTN_RECEIVE, "BtnDong", 235, 385);
		}
		
		private function InitQuest(quest:QuestInfo):void
		{		
			//Quest giới thiệu game
			if (quest.IdSeriesQuest == 1 && quest.Id == 1)
			{
				InitIntro(quest);
				return;
			}
			
			//Quest thả cá lính
			if (quest.IdSeriesQuest == 1 && quest.Id == 5)
			{
				InitIntro(quest);
				return;
			}
			
			//Format giới thiệu chung cho tất cả các quest
			var questConfig:QuestInfo = ConfigJSON.getInstance().GetSeriesQuest(quest.IdSeriesQuest, quest .Id);				
			var format:TextFormat = new TextFormat("Arial", 20, 0x000000, true);			
			
			var x:int = 183;
			var y:int = 85;
			var y1:int = y;
			
			//add câu giới thiệu của NPC
			var tf:TextField;

			//add ảnh tên seriquest
			var imageName:String = "GuiSeriesQuest1_ImgName";
			AddImage("", imageName, img.width / 2 + 20, 17, true, ALIGN_CENTER_TOP);
			
			//add ảnh NPC
			var npcImgName:String = ConfigJSON.getInstance().GetSeriesQuestInfo(1, "Npc") as String;
			var npcImg:Image;
			if (npcImgName == "TienCa")
			{
				npcImgName = "NPC_Mermaid_New";
				npcImg = AddImage("", npcImgName, 115, 415, true, ALIGN_LEFT_TOP);
				npcImg.SetScaleXY(0.8);
			}
			else 
			{
				npcImg = AddImage("", npcImgName, 110, 330, true, ALIGN_LEFT_TOP);
			}
			var boxImg:Image = AddImage("", "GuiSeriesQuest1_NPCBox", 20, 100, true, ALIGN_LEFT_TOP);
		
			tf = AddLabel(Localization.getInstance().getString("SeriQuestNPC" + quest.IdSeriesQuest + quest.Id), boxImg.img.x + 10, 0, 0x000000, 0);
			tf.wordWrap = true;
			tf.width = boxImg.img.width - 20;
			format.size = 12;
			format.color = 0x8e3900;
			format.align = TextFormatAlign.JUSTIFY;
			tf.setTextFormat(format);
			tf.y = 114.3;
			
			boxImg.img.height = tf.height + 45;
			
			//Add các task
			for (var i:int = 0; i < quest.TaskList.length; i++ )
			{
				var taskConfig:TaskInfo = questConfig.TaskList[i] as TaskInfo;
				var task:TaskInfo = quest.TaskList[i] as TaskInfo;
				var conTask:Container = AddContainer("", "GuiSeriesQuest1_CtnBgTask", x, y);
								
				//Add icon của task
				//if (taskConfig.Icon != "")
				//{
					//conTask.AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_" + taskConfig.Icon, -17, 27).FitRect(65, 65, new Point(20, 7));
				//}
				//else
				//{
					//conTask.AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_" + getTaskIconName(quest.IdSeriesQuest, taskConfig.Action), 0, 0).FitRect(65, 65, new Point(20, 7));
				//}				
				
				//Add câu miêu tả task
				tf = conTask.AddLabel(Localization.getInstance().getString("SeriQuestTask" + quest.IdSeriesQuest + (quest.Id) + (i + 1)), 95, 32, 0xaf09d2, 0);
				tf.wordWrap = true;
				tf.width = 170;
				if (tf.height > 12)
				{
					tf.y -= (tf.height - 12) / 2;
				}
				
				//Add số lượng
				tf = conTask.AddLabel(task.Num + "/" + taskConfig.MaxNum, 265, 27, 0x09cc63, 0);
				format.size = 16;
				format.color = 0x09cc63;
				tf.setTextFormat(format);
				
				if (task.Num >= taskConfig.MaxNum)
				{
					task.Status = true;
					conTask.AddImage("", "IcComplete2",  tf.x + tf.textWidth + 20, 25);
					
				}		
				
				y += conTask.img.height + 10;
			}
			
			//Add phần thưởng
			format.bold = true;			
			format.size = 14;
			format.color = 0x8e3900;
			tf = AddLabel("Phần thưởng", 296, 174);
			//trace("vi tri: ", x + 113, y - 5);
			tf.setTextFormat(format);
			AddAward(questConfig.Bonus, tf.x + 50, tf.y + 25, this);
			
			
			if (quest.TaskList.length == 1)
			{
				//Add tip miêu tả của quest
				format.size = 12;
				format.color = 0xd2495b;
				format.align = TextFormatAlign.JUSTIFY;
				tf = AddLabel("Gợi ý:  " + Localization.getInstance().getString("SeriQuestTip" + quest.IdSeriesQuest + quest.Id ), x + 3, y + 100);
				tf.wordWrap = true;
				tf.width = 325;
				tf.setTextFormat(format);
				format.color = 0;
				format.underline = true;
				format.italic = true;
				tf.setTextFormat(format, 0, 6);
				//AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_" + getQuestIconName(quest.IdSeriesQuest, taskConfig.Action), 160, 200).FitRect(350, 150, new Point(x, y + 102));							
			}					
			
			//Add button nhận
			var pos:Point = new Point(x + 115 - 50, y1 + 365 - 45);
			var button:Button = AddButton(GUI_SERIESQUEST_BTN_EXIT, "BtnDong", pos.x, pos.y);
		}
		
				
		private function FinishQuest(quest:QuestInfo):void
		{			
			var questConfig:QuestInfo = ConfigJSON.getInstance().GetSeriesQuest(quest.IdSeriesQuest, quest.Id);				
			var format:TextFormat = new TextFormat(null, 20, 0x000000, true);
			var gui:Container = AddContainer("", "ImgFrameFriend", 0, 0);
			gui.img.scaleX = 1 / img.scaleX;
			gui.img.scaleY = 1 / img.scaleY;			
			
			var x:int = 85;
			var y:int = 80;
			var y1:int = y;
			var tf:TextField;			
			var n:int = quest.TaskList.length;
			
			//Add các task
			for (var i:int = 0; i < quest.TaskList.length; i++ )
			{
				var taskConfig:TaskInfo = questConfig.TaskList[i] as TaskInfo;
				var task:TaskInfo = quest.TaskList[i] as TaskInfo;
				var conTask:Container = gui.AddContainer("", "GuiSeriesQuest1_CtnBgTask", x, y);
								
				//Add icon của task
				//if (taskConfig.Icon != "")
				//{
					//conTask.AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_" + taskConfig.Icon, -17, 27).FitRect(65, 65, new Point(20, 5));					
				//}
				//else
				//{
					//conTask.AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_" + getTaskIconName(quest.IdSeriesQuest, taskConfig.Action), 0, 0).FitRect(65, 65, new Point(20, 5));
				//}
				
				//conTask.AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_TaskIcon", -17, 27).FitRect(65, 65, new Point(20, 7));
				
				//Add câu miêu tả task
				tf = conTask.AddLabel(Localization.getInstance().getString("SeriQuestTask" + quest.IdSeriesQuest + (quest.Id - 1) + (i + 1)), 95, 32, 0xaf09d2, 0);
				tf.wordWrap = true;
				tf.width = 170;
				if (tf.height > 12)
				{
					tf.y -= (tf.height - 12) / 2;
				}
				
				//Add số lượng
				tf = conTask.AddLabel(task.Num + "/" + taskConfig.MaxNum, 265, 27, 0x09cc63, 0);
				format.size = 16;
				format.color = 0x09cc63;
				tf.setTextFormat(format);
				
				if (task.Num >= taskConfig.MaxNum)
				{
					task.Status = true;
					conTask.AddImage("", "IcComplete2",  tf.x + tf.textWidth + 25, 35);
					
				}		
				
				y += conTask.img.height + 5;
			}
			
			//add ảnh tên seriquest
			//var image:Image = gui.AddImage("", "GuiSeriesQuest" + quest.IdSeriesQuest + "_ImgQuestComplete", img.width / 2 + 10, 20, true, ALIGN_CENTER_TOP);
			//image.SetPos(img.width / 2 + 10, 20);;
			//
			//Add phần thưởng
			format.bold = true;			
			format.size = 14;
			format.color = 0x8e3900;
			tf = gui.AddLabel("Phần thưởng", x + 127, y + (3-n)*15 - 15);
			tf.setTextFormat(format);
			AddAward(questConfig.Bonus, tf.x + 50, tf.y + 10 + (3 - n) * 8, gui, 1 + (3 - n) * 0.3);
			
			//Add button nhận
			var pos:Point = new Point(x + 105, y1 + 265);
			if(quest.Status == true || quest.TaskList.length == 0 || quest.CheckQuestDone())
			{
				var button:Button = gui.AddButton(GUI_SERIESQUEST_BTN_RECEIVE, "BtnNhanThuong", pos.x, pos.y, this);
			}
			
			GuiMgr.getInstance().GuiStore.Hide();
		}
		
		private function getTaskIconName(idSeriquest:int, action:String):String
		{
			var name:String = "";
			switch(idSeriquest)
			{
				case QuestMgr.ID_SERI_BEGIN_FISH_WAR:
				case QuestMgr.ID_SERI_MIX_FISH:
					name = "TaskIcon_" + action;
					break;
				case QuestMgr.ID_SERI_MIX_FISH_SKILL_SALE_OFF:
					name = "TaskIcon_saleOffSkill";
					break;
				case QuestMgr.ID_SERI_MIX_FISH_SKILL_OVER_LEVEL:
					name = "TaskIcon_overLevelSkill";
					break;
				case QuestMgr.ID_SERI_MIX_FISH_SKILL_SPECIAL:
					name = "TaskIcon_specialFishSkill";
					break;
				case QuestMgr.ID_SERI_MIX_FISH_SKILL_RARE:
					name = "TaskIcon_rareFishSkill";
					break;
				case QuestMgr.ID_SERI_ADD_MATERIAL:
					name = "TaskIcon_addMaterialFish";
					break;
				case QuestMgr.ID_SERI_FISH_WAR:
					//name = ""
					break;
			}
			return name;
		}
		

		private function AddAward(bonusArr:Array, x:int, y:int, container:Container, sacleAward:Number = 1):void
		{			
			var imgName:String;
			var image:Image;
			var tf:TextField;
			var format:TextFormat = new TextFormat(null, 20, 0x954200, true);		
			var ttipText:String = "";
				
			var x:int, y:int;
			//x = tf.x + 50 - (bonusArr.length * 80 * sacleAward) / 2;
			//y = tf.y + 21;
			x = x - (bonusArr.length * 80 * sacleAward) / 2;
			for (var i:int = 0; i < bonusArr.length; i++)
			{
				ttipText = "";
				
				var conAward:Container = container.AddContainer("", "CtnBgAward", x, y, true, container);
				conAward.img.scaleX = conAward.img.scaleY = sacleAward;
				//var w:int = conAward.img.width;
				//var h:int = conAward.img.height;
				var w:int = 70;
				var h:int = 60;
				var bonus:QuestBonus = bonusArr[i] as QuestBonus;
				switch(bonus.ItemType)
				{
					case "Money":
						//Add ảnh
						image = conAward.AddImage("", "IcGold", 0, 0);
						image.FitRect(70, 60, new Point(0, 0));
						//conAward.AddImage("", "BGSoLuong", 55, 50);
						
						//Add số lượng
						tf = conAward.AddLabel(Ultility.StandardNumber(bonus.Num), 5, 40, 0xffffff, 1, 0x26709C);
						format.size = 11;
						format.color = 0xffffff;
						tf.setTextFormat(format);
						break;
					case "Exp":
						image = conAward.AddImage("", "ImgEXP", 0, 0);
						image.FitRect(70, 60, new Point(0, 0));
						//conAward.AddImage("", "BGSoLuong", 55, 50);
						
						//Add số lượng
						tf = conAward.AddLabel(Ultility.StandardNumber(bonus.Num), 5, 40, 0xffffff, 1, 0x26709C);
						format.size = 11;
						format.color = 0xffffff;
						tf.setTextFormat(format);
						break;
						
					case "Other":				
					case "OceanTree":
						imgName = bonus.ItemType + bonus.ItemId;
						image = conAward.AddImage("", imgName, 66, 100, true, ALIGN_LEFT_TOP);
						image.FitRect(w, h, new Point(0, 0));
						break;
					case "OceanAnimal":
						imgName = bonus.ItemType + bonus.ItemId;
						image = conAward.AddImage("", imgName, 66, 100, true, ALIGN_LEFT_TOP);
						image.GoToAndStop(2);
						image.FitRect(w, h, new Point(0, 0));
						break;
					case "Material":
						//Add ảnh
						imgName = bonus.ItemType + bonus.ItemId;
						image = conAward.AddImage("", imgName, 66, 100, true, ALIGN_LEFT_TOP);
						image.FitRect(w, h, new Point(0, 0));
						
						//Add số lượng
						tf = conAward.AddLabel(Ultility.StandardNumber(bonus.Num), 5, 40, 0xffffff, 1, 0x26709C);
						format.size = 11;
						format.color = 0xffffff;
						tf.setTextFormat(format);
						
						//tooltip txt
						ttipText = "\n" + Localization.getInstance().getString("Tooltip30");					
						break;
						
					case "EnergyItem":
						//Add ảnh
						imgName = bonus.ItemType + bonus.ItemId;
						image = conAward.AddImage("", imgName, 66, 100, true, ALIGN_LEFT_TOP);
						image.FitRect(w, h, new Point(0, 0));
						
						//Add số lượng
						tf = conAward.AddLabel(Ultility.StandardNumber(bonus.Num), 5, 40, 0xffffff, 1, 0x26709C);
						format.size = 11;
						format.color = 0xffffff;
						tf.setTextFormat(format);									
						break;
					
					default:
						break;
				}
				
				//Add tooltip
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = ConfigJSON.getInstance().getItemInfo(bonus.ItemType, bonus.ItemId)[ConfigJSON.KEY_NAME] + ttipText;
				conAward.setTooltip(tooltip);
				x += (80 * sacleAward);		
			}		
		}
		
		public function ShowFinishSeriQuest(IdSeriesQuest:int, id:int = 0):void
		{
			GameLogic.getInstance().BackToIdleGameState();
			this.Hide();
			
			IDSeriesQuest = IdSeriesQuest;
			questId = id;
			GuiMgr.getInstance().GuiSeriesQuest.Show(Constant.GUI_MIN_LAYER, 5);
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
				
			var questConfig:QuestInfo = ConfigJSON.getInstance().GetSeriesQuest(IdSeriesQuest, 1);		
			
			switch (IdSeriesQuest) 
			{
				case QuestMgr.ID_SERI_ADD_MATERIAL:
				{
					Clear();
					LoadRes("GuiSeriesQuest8_GuiSeriesQuestUseMat");
					SetPos(125, 40);
					AddButton(GUI_SERIESQUEST_BTN_FEED, "BtnFeed", img.width / 2 - 45, img.height - 40);
					//AddButton(BTN_CANCEL, "BtnThoat", img.width - 25, 38);
				}
				break;
				
				case QuestMgr.ID_SERI_FISH_WAR:
				{
					Clear();
					LoadRes("GuiSeriesQuest7_ThemeComplete");
					//add ảnh tên seriquest
					AddImage("", "GuiSeriesQuest7_ImgName", img.width / 2 , 17, true, ALIGN_CENTER_TOP);
					
					var npcImg:Image = AddImage("", "NPC_Mermaid_War", 120, 125, true, ALIGN_LEFT_TOP);
					//npcImg.SetScaleXY(0.8);
					
					var introImg7:Image = AddImage("", "GuiSeriesQuest7_ImgFinish", 60, 60, true, ALIGN_LEFT_TOP);
					introImg7.SetPos((img.width - introImg7.img.width) / 2 + 10, 90);
					AddButton(GUI_SERIESQUEST_BTN_FEED, "BtnFeed", 260, 385);
				}
				break;
				
				default:
				{
					//add ảnh tên seriquest
					var imageName:String = "GuiSeriesQuest" + IdSeriesQuest + "_ImgName";
					AddImage("", imageName, img.width / 2 , 17, true, ALIGN_CENTER_TOP);
					
					var strImgIntro2:String = "GuiSeriesQuest" + IdSeriesQuest + "_ImgFinish";					
					var introImg:Image = AddImage("", strImgIntro2, 60, 60, true, ALIGN_LEFT_TOP);
					introImg.SetPos((img.width - introImg.img.width) / 2 + 10, 90);
					
					var button:Button = AddButton(GUI_SERIESQUEST_BTN_FEED, "BtnFeed", 240, 385);
				}	
				break;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_SERIESQUEST_BTN_EXIT:
					this.Hide();
					if (MyQuest != null)
					{
						MyQuest.setShowTutorial(true);
					}
					IDSeriesQuest = 0;
					//hiển thị phần thưởng của những seriquest đã hoàn thành nhưng còn trong hàng đợi
					var questArr:Array = QuestMgr.getInstance().finishedQuest;
					if (questArr.length > 0)
					{
						GameLogic.getInstance().OnQuestDone(questArr[0]);		
						questArr.splice(0, 1);
					}
					break;
				case GUI_SERIESQUEST_BTN_BACK:
					this.Hide();
					if (MyQuest != null)
					{
						MyQuest.setShowTutorial(true);
					}
					
					//hiển thị phần thưởng của những seriquest đã hoàn thành nhưng còn trong hàng đợi
					var questAr:Array = QuestMgr.getInstance().finishedQuest;
					if (questAr.length > 0)
					{
						GameLogic.getInstance().OnQuestDone(questAr[0]);		
						questAr.splice(0, 1);
					}
					
					//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SERIES_QUEST_FISH_WAR + "@" + questId, "", "\Nhiệm vụ thử thách cùng Ngư thủ\"");
					IDSeriesQuest = 0;	
					GameController.getInstance().UseTool("Home");
					break;
				case GUI_SERIESQUEST_BTN_RECEIVE:
					var btn:ButtonEx = GuiMgr.getInstance().GuiTopInfo.GetButtonEx(GUITopInfo.BTN_SERIQUEST + "_" + IDSeriesQuest);
					if (btn)
					{
						btn.SetBlink(false);
					}
					
					if (MyQuest)
						if (MyQuest.IdSeriesQuest == 7)
						{
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.Hide();
							}
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SERIES_QUEST_FISH_WAR + "@" + MyQuest.Id, "", "\"Nhiệm vụ thử thách cùng Ngư thủ\"");
							if (MyQuest.Id == 7)
							{
								GameLogic.getInstance().user.GenerateNextID();
							}
						}
					CompleteQuest();
					if (GameLogic.getInstance().user.IsViewer() && Ultility.IsInMyFish())
					{
						GameController.getInstance().UseTool("Home");
					}
					break;
				case GUI_SERIESQUEST_BTN_FEED:
				{
					switch (IDSeriesQuest)
					{
						case QuestMgr.ID_SERI_BEGIN_FISH_WAR:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_SQ_FINISH1);
							break;
						case QuestMgr.ID_SERI_MIX_FISH:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_SQ_FINISH2);
							break;
						case QuestMgr.ID_SERI_MIX_FISH_SKILL_SALE_OFF:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SALE_OFF_SKILL, "", "\"Kỹ năng giảm tiền lai cá\"");
							break;
						case QuestMgr.ID_SERI_MIX_FISH_SKILL_OVER_LEVEL:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_OVER_LEVEL_SKILL, "", "\"Kỹ năng lai cá vượt cấp\"");
							break;
						case QuestMgr.ID_SERI_MIX_FISH_SKILL_SPECIAL:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SPECIAL_SKILL, "", "\"Kỹ năng lai cá đặc biệt\"");
							break;
						case QuestMgr.ID_SERI_MIX_FISH_SKILL_RARE:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_RARE_SKILL, "", "\"Kỹ năng lai cá quý hiếm\"");
							break;
						case QuestMgr.ID_SERI_FISH_WAR:
							//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SERIES_QUEST_FISH_WAR + "@" + questId, "", "\Nhiệm vụ thử thách cùng Ngư thủ\"");
							break;
						case QuestMgr.ID_SERI_ADD_MATERIAL:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_QUEST_USE_MATERIAL);
							break;
							
					}	
					if (GuiMgr.getInstance().GuiTopInfo.btnExQuestHelp && GuiMgr.getInstance().GuiTopInfo.btnExQuestHelp.img)	
					{
						GuiMgr.getInstance().GuiTopInfo.ShowNotifyNewQuest();
					}
					this.Hide();
					IDSeriesQuest = 0;
					questId = 0;
				}
				break;
				
				case BTN_DONG_Y:
					// Quest nhận dc cá lính (quest 7)
					CompleteQuest();
					GameLogic.getInstance().user.GenerateNextID();
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					this.Hide();
					break;
				case BTN_CANCEL:
					this.Hide();
					break;

				default:
					break;
			}
		}
		
		public function CompleteQuest():void
		{
			if (MyQuest == null) return;
			if (MyQuest.IdSeriesQuest != 0 && MyQuest.Id != 0)
			{
				//Gửi thêm param cho quest nhận ngư thủ
				var param:Object;
				if (MyQuest.IdSeriesQuest == 1 && MyQuest.Id == 5)
				{
					param = new Object();
					param["Element"] = 5;
				}
				else
				if (MyQuest.IdSeriesQuest == 1 && MyQuest.Id == 6)
				{
					param = new Object();
					param["Element"] = 5;
				}
				
				var cmd:SendCompleteSeriesQuest = new SendCompleteSeriesQuest(MyQuest.IdSeriesQuest, MyQuest.Id, 0, param);
				Exchange.GetInstance().Send(cmd);
				QuestMgr.getInstance().RemoveSeriesQuest(MyQuest.IdSeriesQuest, MyQuest.Id);	
				
				//Update vao kho
				var questConfig:QuestInfo = ConfigJSON.getInstance().GetSeriesQuest(MyQuest.IdSeriesQuest, MyQuest.Id);	
				var  bonusArr:Array = questConfig.Bonus;
				if (GuiMgr.getInstance().GuiStore.IsVisible)
				{		
					for (var i:int = 0; i < bonusArr.length; i++)
					{
						var bonus:QuestBonus = bonusArr[i] as QuestBonus;
						if(bonus.ItemType != "Exp" && bonus.ItemType != "Money")
							GuiMgr.getInstance().GuiStore.UpdateStore(bonus.ItemType, bonus.ItemId, bonus.Num);
					}
				}
				MyQuest = null;
				Hide();
			}			
		}		
	}

}