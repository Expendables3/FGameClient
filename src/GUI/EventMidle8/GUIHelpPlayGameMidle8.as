package GUI.EventMidle8 
{
	import Data.ConfigJSON;
	import Data.ResMgr;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIHelpPlayGameMidle8 extends BaseGUI 
	{
		private const GUI_GUIDE_BTN_CLOSE:String = "btnClose";
		private const GUI_GUIDE_BTN_BACK:String = "btnBack";
		private const GUI_GUIDE_BTN_NEXT:String = "btnNext";
		private const GUI_GUIDE_BTN_KNOWN:String = "btnKnown";
		
		private const GUI_GUIDE_CTN_ID_GUI:String = "ctnIdGui_";
		
		private const ID_GUI_MAX:int = 7;
		
		public var so:SharedObject;
		public var idGuiHelp:int = 1;
		
		public function GUIHelpPlayGameMidle8(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIHelpPlayGameMidle8";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			
			so = SharedObject.getLocal("GameMidle8");
			if (!so.data.idGuiHelp)
			{
				idGuiHelp = 1;
				so.data.idGuiHelp = idGuiHelp;
			}
			else 
			{
				idGuiHelp = so.data.idGuiHelp;
			}
			
			LoadRes("GUIHelpGame_GUIHelpPlayGameMidle8" + idGuiHelp.toString());
			SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			
			UpdateAllButton(idGuiHelp);
		}
		
		public function UpdateAllButton(id:int):void 
		{
			this.Clear();
			
			if (id != idGuiHelp)
			{
				idGuiHelp = id;
				so.data.idGuiHelp = id;
			}
			
			LoadRes("GUIHelpGame_GUIHelpPlayGameMidle8" + idGuiHelp.toString());
			SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
			
			var deltaX:Number = 15;
			var startX:Number = img.width / 2 - ID_GUI_MAX * deltaX + 5;
			var startY:Number = img.height - 40;
			
			var fm:TextFormat;
			for (var i:int = 0; i < ID_GUI_MAX; i++) 
			{
				var deltaY:int = 0;
				fm = new TextFormat();
				fm.color = 0xFFFF00;
				fm.size = 18;
				fm.align = "center";
				if (i + 1 == idGuiHelp)
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
			
			AddButton(GUI_GUIDE_BTN_BACK, "GUIHelpGame_BtnBackGameMidle8", img.width / 2, img.height - 50, this).SetVisible(false);
			AddButton(GUI_GUIDE_BTN_NEXT, "GUIHelpGame_BtnNextGameMidle8", img.width / 2, img.height - 50, this).SetVisible(false);
			AddButton(GUI_GUIDE_BTN_KNOWN, "GUIHelpGame_BtnKnownGameMidle8", img.width / 2, img.height - 50, this).SetVisible(false);
			
			if (idGuiHelp == 1)
			{
				GetButton(GUI_GUIDE_BTN_NEXT).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_NEXT).img.x =  img.width / 2 + 55;
				GetButton(GUI_GUIDE_BTN_NEXT).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_BACK).SetVisible(false);
				GetButton(GUI_GUIDE_BTN_KNOWN).SetVisible(false);
			}
			else if (idGuiHelp < ID_GUI_MAX) 
			{
				GetButton(GUI_GUIDE_BTN_NEXT).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_NEXT).img.x =  img.width / 2 + 55;
				GetButton(GUI_GUIDE_BTN_NEXT).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_BACK).SetVisible(true);
				GetButton(GUI_GUIDE_BTN_BACK).img.x =  img.width / 2 - GetButton(GUI_GUIDE_BTN_BACK).img.width - 55;
				GetButton(GUI_GUIDE_BTN_BACK).img.y =  img.height - 45;
				
				GetButton(GUI_GUIDE_BTN_KNOWN).SetVisible(false);
			}
			else if (idGuiHelp == ID_GUI_MAX) 
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
		
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			if (!GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
			{
				var event:Object = ConfigJSON.getInstance().GetItemList("Event");
				if(GameLogic.getInstance().user.Level >= event["PearFlower"].BeginLevel)
				{
					GuiMgr.getInstance().GuiGameTrungThu.Show(Constant.GUI_MIN_LAYER, 1);
				}
				else 
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn hãy lên cấp " + event["PearFlower"].LevelRequire 
						+ " để tham dự sự kiện nhé! ^_^");
				}
			}
		} 
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case GUI_GUIDE_BTN_CLOSE:
					Hide();
				break;
				case GUI_GUIDE_BTN_KNOWN:
					idGuiHelp = 1;
					so.data.idGuiHelp = 1;
					Hide();
				break;
				case GUI_GUIDE_BTN_NEXT:
					UpdateAllButton(Math.min(idGuiHelp + 1, ID_GUI_MAX));
				break;
				case GUI_GUIDE_BTN_BACK:
					UpdateAllButton(Math.max(idGuiHelp - 1, 1));
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