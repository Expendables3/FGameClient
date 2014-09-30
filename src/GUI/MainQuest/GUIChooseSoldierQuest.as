package GUI.MainQuest 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import NetworkPacket.PacketSend.SendCompleteSeriesQuest;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIChooseSoldierQuest extends BaseGUI 
	{
		private var imgInfo:Image;
		private var imgSoldier:Image;
		private var element:int;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_ELEMENT:String = "btnElement";
		static public const IMG_SELECTED_ELEMENT:String = "imgSelectedElement";
		static public const IMG_INFO:String = "imgInfo";
		static public const IMG_SOLDIER:String = "imgSoldier";
		static public const BTN_CHOOSE:String = "btnChoose";
		
		public function GUIChooseSoldierQuest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(20, 20);
				OpenRoomOut();
				GuiMgr.getInstance().GuiStore.Hide();
			}
			LoadRes("GuiChooseSoldierQuest_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 350 + 356, 22);
			AddButton(BTN_CHOOSE, "BtnDongY", 350 - 38, 538);
			
			for (var i:int = 1; i <= 5; i++)
			{
				AddImage(IMG_SELECTED_ELEMENT + "_" + i.toString(), "GuiChooseSoldierQuest_Selected" + i.toString(), -148 + 130 + i * 130, 213).img.visible = false;
				AddButton(BTN_ELEMENT + "_" + i.toString(), "GuiChooseSoldierQuest_BtnElement" + i.toString(), -143 + 62 + i * 130, 105);
			}
			
			imgInfo = AddImage(IMG_INFO, "GuiChooseSoldierQuest_Info1", 131, 656, true, ALIGN_LEFT_BOTTOM);
			imgSoldier = AddImage(IMG_SOLDIER, getSoldierImgName(1), 113 + 128, 600 - 133, true, ALIGN_CENTER_CENTER);
			OnButtonClick(null, BTN_ELEMENT + "_1");
			element = 1;
		}
		
		private function getSoldierImgName(element:int):String
		{
			switch(element)
			{
				case 5:
					return "Fish360_Old_Idle";
				case 4:
					return "Fish350_Old_Idle";
				case 3:
					return "Fish340_Old_Idle";
				case 2:
					return "Fish330_Old_Idle";
				case 1:
					return "Fish320_Old_Idle";
			}
			return "";
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_CHOOSE:
					trace(element);
					var param:Object = new Object();
					param["Element"] = element;		
					var cmd:SendCompleteSeriesQuest = new SendCompleteSeriesQuest(1, 6, 0, param);
					Exchange.GetInstance().Send(cmd);
					QuestMgr.getInstance().RemoveSeriesQuest(1, 5);	
					GameLogic.getInstance().user.GenerateNextID();
					
					GuiMgr.getInstance().guiMainQuest.soldierElement = element;
					Hide();
					break;
				default:
					if (buttonID.search(BTN_ELEMENT) >= 0)
					{
						GetButton(buttonID).SetFocus(true);
						element = buttonID.split("_")[1];
						for (var i:int = 1; i <= 5; i++)
						{
							if (i == element)
							{
								GetImage(IMG_SELECTED_ELEMENT + "_" + i).img.visible = true;
							}
							else
							{
								GetImage(IMG_SELECTED_ELEMENT + "_" + i).img.visible = false;
								GetButton(BTN_ELEMENT + "_" + i).SetFocus(false);
							}
						}
						
						imgInfo.LoadRes("GuiChooseSoldierQuest_Info" + element);
						imgSoldier.LoadRes(getSoldierImgName(element));
					}
					break;
			}
		}
		
	}

}