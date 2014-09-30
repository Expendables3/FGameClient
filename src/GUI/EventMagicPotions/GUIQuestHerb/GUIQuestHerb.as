package GUI.EventMagicPotions.GUIQuestHerb 
{
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	import GUI.EventMagicPotions.NetworkPacket.SendGetHerbList;
	import GUI.EventMagicPotions.QuestHerbMgr;
	import Logic.QuestInfo;
	import Sound.SoundMgr;
	
	/**
	 * GUI Thảo dược thần kì
	 * @author longpt
	 */
	public class GUIQuestHerb extends BaseGUI 
	{
		public static const HERB_POTION_STRENGTH:int = 1;
		public static const HERB_POTION_MIND:int = 2;
		public static const HERB_POTION_GOD:int = 3;
		
		[Embed(source='../../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		private static const BTN_THOAT:String = "BtnThoat";

		private var Quest:QuestInfo;
		private var mixAreaList:Array = [];
		
		public function GUIQuestHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIQuestHerb";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(35, 10);
				
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
			}
			LoadRes("GuiQuestHerb_Theme");
		}
		
		public override function EndingRoomOut():void
		{
			AddButtons();
			var cmdGetHerb:SendGetHerbList = new SendGetHerbList();
			Exchange.GetInstance().Send(cmdGetHerb);
		}
		
		public function RefreshComponent():void
		{
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			ClearComponent();
			AddButtons();
			AddImage("", "GuiQuestHerb_Title", 65, 65, true, ALIGN_LEFT_TOP);
			AddTasks();
			AddMixArea();
		}
		
		/**
		 * Add các nút ở đây
		 */
		private function AddButtons():void
		{
			AddButton(BTN_THOAT, "BtnThoat", 705, 20);
		}
		
		/**
		 * Add các tasks ở đây
		 */
		private function AddTasks():void
		{
			var x0:int = 75;
			var y0:int = 105;
			var dx:int = 0;
			var dy:int = 70;
			var i:int;
			
			var QuestList:Array = QuestHerbMgr.getInstance().GetQuestHerbList();
			
			for (i = 0; i < QuestList.length; i++)
			{
				var taskCtn:TaskContainer = new TaskContainer(this.img, QuestList[i], x0 + i * dx, y0 + i * dy);
			}
		}
		
		/**
		 * Add khu chế tạo ở đây
		 */
		private function AddMixArea():void
		{
			mixAreaList = [];
			var ctn:Container = AddContainer("", "GuiQuestHerb_MixAreaContainer", 42, 320, true);
			var x0:int = 50;
			var y0:int = 0;
			var dx:int = 200;
			var dy:int = 0;
			
			var i:int;
			for (i = 0; i < 3; i++)
			{
				var mixCtn:MixAreaContainer = new MixAreaContainer(ctn.img, i + 1, x0 + i * dx, y0 + i * dy);
				mixAreaList.push(mixCtn);
			}
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 30;
			ctn.AddLabel("+", 520, 50, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = Localization.getInstance().getString("HerbMedal1") + "\nDùng để đổi Ngọc Ấn";
			ctn.AddContainer("", "HerbMedal1", 590, 40).setTooltip(tt);
			
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_THOAT:
					this.Hide();
					break;
			}
		}
		
		public function GetMixAreaList():Array
		{
			return mixAreaList;
		}
	}

}