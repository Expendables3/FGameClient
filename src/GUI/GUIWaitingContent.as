package GUI 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.component.BaseGUI;
	
	/**
	 * GUI chờ load content
	 * @author longpt
	 */
	public class GUIWaitingContent extends BaseGUI 
	{
		private var WaitingForGUI:String = "";
		private var txtF:TextField;
		
		public function GUIWaitingContent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIWaitingContent";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GuiWaitingContent_Theme");
			SetPos(370, 220);
			
			txtF = AddLabel("Đang tải", 0, 110, 0xffffff, 1, 0x000000);
			var tF:TextFormat = new TextFormat();
			tF.size = 20;
			txtF.defaultTextFormat = tF;
			//txtF.setTextFormat(tF);
			
			// Add đồng hồ cát
			//AddImage("", "DongHoCat", this.img.width / 2, this.img.height / 2, true, ALIGN_LEFT_TOP);
			//AddButton("Thoat", "BtnThoat", this.img.width - 30, 6);
		}
		
		public function Init(ClassName:String):void
		{
			WaitingForGUI = ClassName;
			this.Show(Constant.GUI_MIN_LAYER, 1);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == "Thoat")
			{
				this.Hide();
			}
		}
		
		public override function OnHideGUI():void
		{
			WaitingForGUI = "";
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				if (!LeagueInterface.getInstance().isLoadWarEff)
				{
					LeagueInterface.getInstance().isLoadWarEff = true;
				}
			}
		}
		
		public function GetGUIWaitName():String
		{
			return WaitingForGUI;
		}
		
		public function SetText(s:String):void
		{
			txtF.text = s;
		}
		
	}

}