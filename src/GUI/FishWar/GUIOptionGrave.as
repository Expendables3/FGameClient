package GUI.FishWar 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	
	/**
	 * GUI chọn hồi sinh cho mộ
	 * @author longpt
	 */
	public class GUIOptionGrave extends BaseGUI 
	{
		private static const BTN_SELL:String = "BtnSell";
		private static const BTN_REVIVE:String = "BtnRevive";
		private static const BTN_THOAT:String = "BtnThoat";
		
		private var grave:FishSoldier;
		
		public function GUIOptionGrave(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIOptionGrave";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{	
				var tF:TextFormat;
				var txtF:TextField;
				
				var btn:Button = AddButton(BTN_REVIVE, "GuiOptionGrave_BtnGreen", 135, 310);
				btn.img.scaleX = btn.img.scaleY = 0.9;
				txtF = AddLabel("Hồi sinh", btn.img.x + 9, btn.img.y - 26, 0xffffff, 0, 0x000000);
				tF = new TextFormat();
				tF.size = 17;
				tF.align = "center";
				tF.italic = true;
				txtF.setTextFormat(tF);
				
				btn = AddButton(BTN_SELL, "GuiOptionGrave_BtnRed", 245, 310);
				btn.img.scaleX = btn.img.scaleY = 0.9;
				txtF = AddLabel("Hóa kiếp", btn.img.x + 9, btn.img.y - 26, 0xffffff, 0, 0x000000);
				txtF.setTextFormat(tF);
				
				AddImage("", "GuiOptionGrave_Title", 180, 20, true, ALIGN_LEFT_TOP);
				AddButton(BTN_THOAT, "BtnThoat", 435, 22);
				
				txtF = AddLabel("Bạn có thể hồi sinh hoặc hóa kiếp cho Ngư Thủ của mình", 100, 80, 0xffffff, 0, 0x000000);
				txtF.wordWrap = true;
				txtF.width = 300;
				tF = new TextFormat();
				tF.size = 20;
				tF.align = "center";
				tF.italic = true;
				txtF.setTextFormat(tF);
				
				AddImage("", "FishGrave", 190, 140, true, ALIGN_LEFT_TOP);
				
				SetPos(170, 150);
			}
			LoadRes("GuiOptionGrave_Theme");
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_THOAT:
					this.Hide();
					break;
				case BTN_REVIVE:
					processRevive();
					this.Hide();
					break;
				case BTN_SELL:
					GameLogic.getInstance().ClickGrave(grave);
					this.Hide();
					break;
			}
		}
		
		public function processRevive():void
		{
			var numElement:int = 0;
			for (var s:String in GameLogic.getInstance().user.ElementList)
			{
				numElement += 1;
			}
			
			if (numElement == 1)
			{
				if (GameLogic.getInstance().checkCounter(grave.Element, parseInt(s)))
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể cùng lúc nuôi 2 Ngư Thủ khắc hệ với nhau", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
			}
			
			if (numElement >= 2)
			{
				if (!GameLogic.getInstance().user.ElementList[grave.Element])
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn chỉ có thể sở hữu 2 hệ Ngư Thủ!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
			}
			
			if (GameLogic.getInstance().user.CurLake.NumSoldier >= GameLogic.getInstance().user.CurLake.CurCapacitySoldier)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Mỗi hồ chỉ được thả 3 Ngư Thủ!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			GuiMgr.getInstance().GuiReviveFishSoldier.Init(grave,true);
		}
		
		public function GetGrave():FishSoldier
		{
			return grave;
		}
		public function SetGrave(g:FishSoldier):void
		{
			grave = g;
		}
	}

}