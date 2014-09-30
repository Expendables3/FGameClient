package GUI.unused 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.QuestINI;
	import Data.ResMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import Logic.GameLogic;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import NetworkPacket.PacketSend.SendCompleteDailyQuest;
	import Sound.SoundMgr;
	/**
	 * ...
	 * @author tuan
	 */
	
	public class GUIDailyQuest extends BaseGUI
	{
		private const GUI_DAILYQUEST_BTN_NEXT:String = "BtnNext";
		private const GUI_DAILYQUEST_BTN_BACK:String = "BtnBack";
		private const GUI_DAILYQUEST_EXIT:String = "BtnExit";
		
		
		private const SLOT_NUMBER:int = 3;
		
		public var CurrentPage:int = 0;
		private var MaxPage:int = 1;
		private var IsDataReady:Boolean;
		
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		
		public function GUIDailyQuest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIDailyQuest";
		}
		
		private function AddCloseButton():void
		{
			//Add button đóng ở góc trên bên phải
			var bt:Button = AddButton(GUI_DAILYQUEST_EXIT, "BtnThoat", 335, 4, this);
			//bt.img.scaleX = bt.img.scaleY = 0.70;
		}
		
		public override function InitGUI() :void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			LoadRes("Gui_DailyQuest");			
			SetPos(230, 100);
			//SetDragable(new Rectangle(70, -10, 300, 80));			
			AddCloseButton();
			
			//Add ảnh chờ load dữ liệu
			img.addChild(WaitData);
			WaitData.x = img.width / 2 - 5;
			WaitData.y = img.height / 2 - 5;
		}
		
		public function Init(page:int, dataAvailable:Boolean = true):void
		{
			IsDataReady = dataAvailable;			
			GameLogic.getInstance().BackToIdleGameState();
			this.Hide();
			//this.Show(Constant.GUI_MIN_LAYER + 2, 5);
			this.Show(Constant.GUI_MIN_LAYER, 5);
			
			CurrentPage = page;
			OpenRoomOut();
		}
		
		
		public override function  EndingRoomOut():void
		{
			if (IsDataReady)
			{
				RefreshComponent();
			}
		}
		
		
		public function RefreshComponent(dataAvailable:Boolean = true):void
		{
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
			
			//Add các component của gui
			AddCloseButton();	
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}
			
			var DailyQuest:Array = QuestMgr.getInstance().DailyQuest;
			var quest:QuestInfo;
			var task:TaskInfo;
			var questConfig:QuestInfo;
			var taskConfig:TaskInfo;
			var bonus:QuestBonus;
			
			var format:TextFormat = new TextFormat(null, 18, 0x954200, true);
			if (DailyQuest.length <= 0)
			{							
				format.size = 18;
				format.color = 0x604220;
				format.bold = true;
				var tf:TextField = AddLabel("Bạn đã làm hết nhiệm vụ trong ngày", 140, 150);
				tf.setTextFormat(format);
				return;
			}		
			
			//var TaskLisk:Array = quest.TaskList;
			
			MaxPage = Math.ceil(DailyQuest.length / SLOT_NUMBER);
			
			var t:int = CurrentPage * SLOT_NUMBER;
			var nItem:int = SLOT_NUMBER;
			if (t + SLOT_NUMBER >= DailyQuest.length)
			{
				nItem = DailyQuest.length - t;
			}
			AddItemSlots(nItem);
			
			for (var i:int = t; i < nItem + t; i++)
			{			
				quest = DailyQuest[i] as QuestInfo;
				task = quest.TaskList[0] as TaskInfo;
				//questConfig = QuestINI.getInstance().GetDailyQuest(task.Id, task.Level);
				questConfig = ConfigJSON.getInstance().GetDailyQuest(task.Id, task.Level);
				taskConfig = questConfig.TaskList[0] as TaskInfo;
				var container:Container = ContainerArr[i - t];
								
				if (task.Num >= taskConfig.MaxNum)
				{
					container.AddImage("", "IcComplete",  275, 18);
					container.AddButton("Receive_" + task.Id, "BtnGreen", 250, 61, this);
					container.AddLabel("Nhận", 256, 39, 0x00000, 0);
				}
				if (taskConfig.Icon != "")
				{
					container.AddImage("", taskConfig.Icon, 35, 30);
				}
				else
				{
					container.AddImage("", "TaskIcon_" + taskConfig.Action, 35, 30);
				}			
								
				container.AddLabel(task.Num + "/" + taskConfig.MaxNum, 65, 25, 0x00000, 0);
				//container.AddLabel(taskConfig.Decription, 10, 10,0x1908fb, 0);
				container.AddLabel(Localization.getInstance().getString("DailyDescription" + task.Id) , 90, 10, 0xaf09d2, 0);
				container.AddLabel("Phần thưởng: ", 90, 40, 0x8e3900, 0);
				bonus = questConfig.Bonus[task.BonusId - 1]as QuestBonus
				switch(bonus.ItemType)
				{
					case "Money":
						container.AddLabel(bonus.Num.toString(), 106, 40, 0x00000, 2);
						container.AddImage("", "IcGold", 220, 47);
						break;
					case "Exp":
						container.AddLabel(bonus.Num.toString(), 106, 40, 0x00000, 2);
						container.AddImage("", "ImgEXP", 220, 47);
						break;			
					case "Food":
						container.AddLabel(bonus.Num.toString(), 106, 40, 0x00000, 2);
						var image:Image = container.AddImage("", "ImgFoodBox", 220, 70);
						image.SetScaleX(0.5);
						image.SetScaleY(0.5);
						break;
					
					case "Material":
						container.AddLabel(bonus.Num.toString(), 106, 40, 0x00000, 2);
						image = container.AddImage("", "Material1", 237, 65);
						image.SetScaleX(0.7);
						image.SetScaleY(0.7);
						break;
				}				
			}				
		
			InitButton();
		}
		
		private function AddItemSlots(nItem:int, maxRow:int = 3):void
		{
			var dy:int = 12;
			var x0:int = 33;
			var y0:int = 60;
			var icon:Sprite = ResMgr.getInstance().GetRes( "BGContainerDailyQuest") as Sprite;
			var h:int = icon.height;
			var y:int;
			
			for (var i:int = 0; i < nItem; i++)
			{
				if (i > maxRow)
				{
					return;
				}
								
				var container:Container = AddContainer("", "BGContainerDailyQuest", x0, y0);
				y0 += h + dy;
			}
		}
		
		private function InitButton():void
		{			
			//Add button đóng ở dưới gui
			var pos:Point = new Point(157, 325);
			var bt:Button = AddButton(GUI_DAILYQUEST_EXIT, "BtnGreen", pos.x, pos.y);
			bt.img.scaleX = 1.5;
			bt.img.scaleY = 1.3;
			var tf:TextField = AddLabel("Đóng",  pos.x + 13, pos.y - 29, 0x00000, 0);
			var format:TextFormat = new TextFormat(null, 20, 0x954200, true);		
			format.size = 16;
			format.color = 0x00000;
			tf.setTextFormat(format);			
			
			//Add button tiếp theo, quay lại
			if (MaxPage > 1)
			{
				var btnNext:Button = AddButton(GUI_DAILYQUEST_BTN_NEXT, "ButtonTiepTheo", 400, 320, this);
				var btnBack:Button = AddButton(GUI_DAILYQUEST_BTN_BACK, "ButtonQuayLai", 45, 320, this);
				if (CurrentPage == 0)
				{
					btnBack.SetDisable();
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetDisable();
				}
			}
		}		
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_DAILYQUEST_BTN_NEXT:
					if (CurrentPage < MaxPage - 1)
					{
						Init(CurrentPage + 1);
					}
					break;
				
				case GUI_DAILYQUEST_BTN_BACK:
					if (CurrentPage > 0)
					{
						Init(CurrentPage - 1);
					}
					break;
					
				case GUI_DAILYQUEST_EXIT:
					this.Hide();
					break;

				default:
					CompleteQuest(buttonID);
					break;
			}
		}
		
		private function CompleteQuest(buttonId:String):void
		{
			var data:Array = buttonId.split("_");
			var cmd:SendCompleteDailyQuest = new SendCompleteDailyQuest(data[1]);
			Exchange.GetInstance().Send(cmd);
			GuiMgr.getInstance().GuiTopInfo.btnDailyQuest.SetBlink(false);
		}
	}

}