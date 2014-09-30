package Event.EventHalloween.HalloweenGui 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiGetStatus.SendGetStatus;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiTest2 extends BaseGUI 
	{
		private const ID_BTN_GETSTATUS:String = "idBtnGetstatus";
		private const ID_BTN_CLOSE:String = "idBtnClose";
		public function GuiTest2(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
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
				
				AddLabel("1. GetStatus", 20, 100);
				AddButton(ID_BTN_GETSTATUS, "BtnThoat", 120, 100);
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
				case ID_BTN_GETSTATUS:
					pk = new SendGetStatus("FakeEventService.getStatus",
											Constant.CMD_GET_STATUS_EVENT_HALLOWEEN);
					Exchange.GetInstance().Send(pk);
				break;
			}
		}
	}

}



















