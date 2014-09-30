package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGuideHalloween extends BaseGUI 
	{
		public var idPage:int = 1;
		private const ID_GUI_MAX:int = 4;
		static public const GUI_GUIDE_CTN_ID_GUI:String = "guiGuideCtnIdGui";
		static public const GUI_GUIDE_BTN_CLOSE:String = "guiGuideBtnClose";
		static public const GUI_GUIDE_BTN_BACK:String = "guiGuideBtnBack";
		static public const GUI_GUIDE_BTN_NEXT:String = "guiGuideBtnNext";
		static public const GUI_GUIDE_BTN_KNOWN:String = "guiGuideBtnKnown";
		
		public function GuiGuideHalloween(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGuideHalloween";
		}
		override public function InitGUI():void 
		{
			idPage = 1;
			LoadRes("GuiGuideHalloween_Theme" + idPage);
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			OpenRoomOut();
		}
		override public function EndingRoomOut():void 
		{
			UpdateAllButton(idPage);
		}
		public function UpdateAllButton(id:int):void 
		{
			ClearComponent();
			
			if (id != idPage)
			{
				idPage = id;
			}
			LoadRes("GuiGuideHalloween_Theme" + idPage);
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			
			var deltaX:Number = 15;
			var startX:Number = img.width / 2 - ID_GUI_MAX * deltaX - 15;
			var startY:Number = img.height - 40;
			
			var fm:TextFormat;
			for (var i:int = 0; i < ID_GUI_MAX; i++) 
			{
				var deltaY:int = 0;
				fm = new TextFormat();
				fm.color = 0xFFFF00;
				fm.size = 18;
				fm.align = "center";
				if (i + 1 == idPage)
				{
					fm.color = 0xCC0000;
					fm.size = 20;
					fm.underline = true;
					fm.bold = true;
					deltaY = -2;
				}
				var container:Container = AddContainer(GUI_GUIDE_CTN_ID_GUI + (i + 1), "KhungFriend", 0, 0, true, this);
				container.SetPos(startX + deltaX * i, startY + deltaY);
				container.AddLabel((i + 1).toString(), 0, 0).setTextFormat(fm);
			}
			
			GetContainer(GUI_GUIDE_CTN_ID_GUI + id).SetHighLight(0x00FF00, false, true, 2);
			
			AddButton(GUI_GUIDE_BTN_CLOSE, "BtnThoat", img.width - 35, 20);
			
			AddButton(GUI_GUIDE_BTN_BACK, "GuiGuideHalloween_BtnBack", img.width / 2, img.height - 50, this).SetVisible(false);
			AddButton(GUI_GUIDE_BTN_NEXT, "GuiGuideHalloween_BtnNext", img.width / 2, img.height - 50, this).SetVisible(false);
			AddButton(GUI_GUIDE_BTN_KNOWN, "GuiGuideHalloween_BtnKnown", img.width / 2, img.height - 50, this).SetVisible(false);
			
			if (idPage == 1)
			{
				GetButton(GUI_GUIDE_BTN_NEXT).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_NEXT).img.x =  img.width / 2 + 55;
				GetButton(GUI_GUIDE_BTN_NEXT).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_BACK).SetVisible(false);
				GetButton(GUI_GUIDE_BTN_KNOWN).SetVisible(false);
			}
			else if (idPage < ID_GUI_MAX) 
			{
				GetButton(GUI_GUIDE_BTN_NEXT).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_NEXT).img.x =  img.width / 2 + 55;
				GetButton(GUI_GUIDE_BTN_NEXT).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_BACK).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_BACK).img.x =  img.width / 2 - GetButton(GUI_GUIDE_BTN_BACK).img.width - 55;
				GetButton(GUI_GUIDE_BTN_BACK).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_KNOWN).SetVisible(false);
			}
			else if (idPage == ID_GUI_MAX) 
			{
				
				GetButton(GUI_GUIDE_BTN_KNOWN).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_KNOWN).img.x =  img.width / 2 + 55;
				GetButton(GUI_GUIDE_BTN_KNOWN).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_BACK).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_BACK).img.x =  img.width / 2 - GetButton(GUI_GUIDE_BTN_BACK).img.width - 55;
				GetButton(GUI_GUIDE_BTN_BACK).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_NEXT).SetVisible(false);
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case GUI_GUIDE_BTN_CLOSE:
					Hide();
				break;
				case GUI_GUIDE_BTN_KNOWN:
					idPage = 1;
					Hide();
				break;
				case GUI_GUIDE_BTN_NEXT:
					UpdateAllButton(Math.min(idPage + 1, ID_GUI_MAX));
				break;
				case GUI_GUIDE_BTN_BACK:
					UpdateAllButton(Math.max(idPage - 1, 1));
				break;
				default:
					if (buttonID.search(GUI_GUIDE_CTN_ID_GUI) >= 0)
					{
						UpdateAllButton(int(buttonID.split("_")[1]));
					}
				break;
			}
		}
	}

}