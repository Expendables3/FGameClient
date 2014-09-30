package GUI.Expedition.ExpeditionGui 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.Expedition.ExpeditionPackage.SendRollingDice;
	import GUI.GuiGetStatus.SendGetStatus;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUITest2 extends BaseGUI 
	{
		private const ID_BTN_DECREASE_HARD:String = "idBtnDecreaseHard";
		private const ID_BTN_INCREASE_VALUE:String = "idBtnIncreaseValue";
		private const ID_BTN_ROLLINGDICE:String = "idBtnRollingdice";
		private const ID_BTN_GETSTATUS:String = "idBtnGetstatus";
		private const ID_BTN_RESET:String = "idBtnReset";
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_COMPLETEQUEST:String = "idBtnCompletequest";
		
		public function GUITest2(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUITest2";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				var w:int = img.width;
				var h:int = img.height;
				SetPos(Constant.STAGE_WIDTH / 2 - w / 2, Constant.STAGE_HEIGHT / 2 - h / 2);
				AddButton(ID_BTN_CLOSE, "BtnThoat", w - 20, 15);
				AddButton(ID_BTN_RESET, "BtnThoat", w / 3 - 40, h - 30);
				
				AddLabel("1. GetStatus", 20, 100);
				AddButton(ID_BTN_GETSTATUS, "BtnThoat", 120, 100);
				AddLabel("2. RollingDice", 20, 140);
				AddButton(ID_BTN_ROLLINGDICE, "BtnThoat", 120, 140);
				AddLabel("3. IncreaseValue", 20, 180);
				AddButton(ID_BTN_INCREASE_VALUE, "BtnThoat", 120, 180);
				AddLabel("4. DecreaseHard", 20, 220);
				AddButton(ID_BTN_DECREASE_HARD, "BtnThoat", 120, 220);
				
				AddLabel("5. CompleteQuest", 200, 100);
				AddButton(ID_BTN_COMPLETEQUEST, "BtnThoat", 300, 100);
				
			}
			LoadRes("GuiInputCodeSuccess_Theme_Single");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var pk:BasePacket;
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_RESET:
					resetLastTime();
				break;
				case ID_BTN_GETSTATUS:
					pk = new SendGetStatus("ExpeditionService.getStatus", 
								Constant.CMD_GET_EXPEDITION_STATUS);
					Exchange.GetInstance().Send(pk);
				break;
				case ID_BTN_ROLLINGDICE:
					pk = new SendRollingDice("Free");
					Exchange.GetInstance().Send(pk);
				break;
				case ID_BTN_INCREASE_VALUE:
					pk = new SendGetStatus("ExpeditionService.increaseValue", "");
					Exchange.GetInstance().Send(pk);
				break;
				case ID_BTN_DECREASE_HARD:
					pk = new SendGetStatus("ExpeditionService.decreaseHard", "");
					Exchange.GetInstance().Send(pk);
				break;
				case ID_BTN_COMPLETEQUEST:
					pk = new SendGetStatus("ExpeditionService.completeQuest", "");
					Exchange.GetInstance().Send(pk);
				break;
			}
		}
		
		private function resetLastTime():void 
		{
			trace("gửi gói tin lên");
			var url:String = "ExpeditionService.resetLastTimeLog";
			var id:String = "reset";
			var pk:SendGetStatus = new SendGetStatus(url, id);
			Exchange.GetInstance().Send(pk);
		}
		
		
		public function getPacket(data:Object):void
		{
			trace("nhận dữ liệu về");
		}
	}

}


























