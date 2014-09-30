package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import Data.ConfigJSON;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiGetStatus.SendGetStatus;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiTrickTask extends BaseGUI 
	{
		private const CMD_CLOSE:String = "cmdClose";
		private const CMD_CONFIRM:String = "cmdConfirm";
		
		private var tfTime:TextField;
		private var tfTask:TextField;
		private var btnConfirm:Button;
		private var _task:Object;			//reference đến _task của HalloweenMgr
		public function GuiTrickTask(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiTrickTask";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				_task = HalloweenMgr.getInstance().getTask();
				var fm:TextFormat;
				AddButton(CMD_CLOSE, "BtnThoat", 565, 20);
				if (!HalloweenMgr.getInstance().inTask)
				{
					btnConfirm = AddButton(CMD_CONFIRM, "GuiTrickTask_BtnConfirm", 265, 270);
				}
				tfTime = AddLabel("", 305, 220, 0xffffff, 1, 0x000000);
				fm = new TextFormat("Arial", 14);
				tfTime.defaultTextFormat = fm;
				tfTask = AddLabel("", 240, 120, 0xffffff, 1, 0x000000);
				tfTask.defaultTextFormat = fm;
			}
			LoadRes("GuiTrickTask_Theme");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case CMD_CLOSE:
					Hide();
					break;
				case CMD_CONFIRM://đã thực hiện nhận nhiệm vụ
					btnConfirm.enable = false;
					HalloweenMgr.getInstance().inTask = true;
					//var pk:SendGetStatus = new SendGetStatus("EventService.confirmTrick", "");
					var pk:SendGetStatus = new SendGetStatus("FakeEventService.confirmTrick", "");
					Exchange.GetInstance().Send(pk);
					/*cho đồng hồ chạy*/
					
					break;
			}
		}
		
		public function updateGUI(curTime:Number):void
		{
			if (HalloweenMgr.getInstance().inTask)
			{
				var cfgTime:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["TimeTrick"];
				var passTime:Number = curTime - _task["TimeConfirm"];
				var remainTime:Number = cfgTime - passTime;
				if (remainTime < -4)
				{
					HalloweenMgr.getInstance().inTask = false;
					//gửi gói tin failTask lên server
					//nếu không muốn đợi 3second thì diễn 1 cái effect nào đó => xong effect thì gửi gói tin
					var pk:SendGetStatus = new SendGetStatus("EventService.failTrickTask",
														Constant.CMD_FAIL_TRICK_TASK);
					Exchange.GetInstance().Send(pk);
				}
				else
				{
					if (remainTime >= 0)
					{
						tfTime.text = Ultility.convertToTime(int(remainTime), false);
					}
				}
			}
		}
	}

}






















