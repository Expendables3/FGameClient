package GUI.QuestPowerTinh 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.QuestPowerTinh.Network.SendExchangePowerTinh;
	import GUI.QuestPowerTinh.Network.SendGetPowerTinhQuest;
	import Logic.GameLogic;
	import Logic.QuestMgr;
	
	/**
	 * GUI nhiệm vụ nhận Tinh Lực
	 * @author longpt
	 */
	public class GUIQuestPowerTinh extends BaseGUI 
	{
		private const BTN_THOAT:String = "BtnThoat";
		
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		private var cfg:Object;
		
		public function GUIQuestPowerTinh(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIQuestPowerTinh";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(35, 30);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				// Cmd
				var cmd:SendGetPowerTinhQuest = new SendGetPowerTinhQuest();
				Exchange.GetInstance().Send(cmd);
				
				OpenRoomOut();
			}
			LoadRes("GuiQuestPowerTinh_Theme");	
		}
		
		public override function EndingRoomOut():void
		{
			AddButton(BTN_THOAT, "BtnThoat", 705, 20);
			//RefreshComponent();
		}
		
		public function RefreshComponent():void
		{
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			ClearComponent();
			
			AddImage("", "GuiQuestPowerTinh_Bg", 47, 80, true, ALIGN_LEFT_TOP);
			
			AddButtons();
			
			AddTasks();
			
			AddExchangeArea();
		}
		
		private function AddButtons():void
		{
			AddButton(BTN_THOAT, "BtnThoat", 705, 20);
		}
		
		private function AddTasks():void
		{
			var x0:int = 80;
			var y0:int = 114;
			var dx:int = 0;
			var dy:int = 38;
			
			var cfg:Object = ConfigJSON.getInstance().GetItemList("PowerTinh_Quest");
			var QuestPTList:Array = QuestMgr.getInstance().QuestPowerTinh;
			for (var i:int = 0; i < QuestPTList.length; i++)
			{
				var ctn:QuestPowerTinhContainer = new QuestPowerTinhContainer(this.img, QuestPTList[i], x0 + i * dx, y0 + i * dy);
			}
		}
		
		private function AddExchangeArea():void
		{
			AddProgress("", "GuiQuestPowerTinh_Prg", 150, 370, null, true).setStatus(QuestMgr.getInstance().PointReceived / 150);
			cfg = ConfigJSON.getInstance().GetItemList("PowerTinhQuest_Reward");
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 18;
			
			AddLabel(cfg["1"].Point + "", 298, 398, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
			AddLabel(cfg["2"].Point + "", 453, 398, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
			AddLabel(cfg["3"].Point + "", 613, 398, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
			
			AddImage("", "GuiQuestPowerTinh_Circle", 130, 387);
			
			txtFormat = new TextFormat();
			txtFormat.size = 20;
			AddLabel(QuestMgr.getInstance().PointReceived + "", 76, 370, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			var x0:int = 180;
			var y0:int = 380;
			var dx:int = 160;
			var dy:int = 0;
			
			for (var i:int = 0; i < 3; i++)
			{
				var ctn:Container = AddContainer("", "GuiQuestPowerTinh_Ctn", x0 + i * dx, y0 + i * dy);
				ctn.AddLabel("x" + cfg[i + 1]["Reward"]["1"].Num, 73, 80, 0xffffff, 0, 0x000000);
				var btn:Button = AddButton("BtnNhan_" + i, "GuiQuestPowerTinh_BtnNhan", x0 + i * dx + 33, y0 + i * dy + 110);
				if (QuestMgr.getInstance().PointReceived < cfg[i + 1].Point)
				{
					btn.SetDisable();
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_THOAT:
					this.Hide();
					break;
				default:
					var a:Array = buttonID.split("_");
					if (a[0] == "BtnNhan")
					{
						var gift:Object = ConfigJSON.getInstance().GetItemList("PowerTinhQuest_Reward")[int(a[1]) + 1]["Reward"]["1"];
						// Update powerTinh
						if (GameLogic.getInstance().user.ingradient)
						{
							GameLogic.getInstance().user.ingradient["PowerTinh"] += gift.Num;
						}
						
						// Eff
						EffectMgr.setEffBounceDown("Nhận thành công", "PowerTinh", 330, 280, null, gift.Num);
						
						// Cmd
						var cmd:SendExchangePowerTinh = new SendExchangePowerTinh(int(a[1]) + 1);
						Exchange.GetInstance().Send(cmd);
						
						// Update
						QuestMgr.getInstance().PointReceived -= cfg[int(a[1]) + 1].Point;
						
						RefreshComponent();
					}
					break;
			}
		}
	}
}