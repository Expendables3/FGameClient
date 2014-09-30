package GUI.MainQuest 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.QuestMgr;
	import NetworkPacket.PacketSend.SendCompleteSeriesQuest;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIIntroFishWarQuest extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		
		public function GUIIntroFishWarQuest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(120, 50);
				OpenRoomOut();
			}
			LoadRes("GuiIntroFishWarQuest_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 542, 20);
			AddButton(BTN_CLOSE, "BtnDong", 237, 398);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var cmd:SendCompleteSeriesQuest = new SendCompleteSeriesQuest(1, 1);
			Exchange.GetInstance().Send(cmd);
			QuestMgr.getInstance().RemoveSeriesQuest(1, 1);	
			Hide();
		}
		
	}

}