package GUI.FishWorld.ForestWorld 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.FishWorld.FishWorldController;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGetPiece extends BaseGUI 
	{
		public var BTN_NHAN_THUONG:String = "BtnNhanThuong";
		public function GUIGetPiece(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGetPiece";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("LoadingForestWorld_GUIGetPiece_Theme");
			SetPos(200, 80);
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			AddButton(BTN_NHAN_THUONG, "LoadingForestWorld_GUIGetPiece_BtnNhanThuong", 120, 250, this);
			var ct:Image;
			switch (FishWorldController.GetRound()) 
			{
				case Constant.SEA_ROUND_1:
					ct = AddImage("", "LoadingForestWorld_ImgForestWorld1", 205, 168);
				break;
				case Constant.SEA_ROUND_2:
					ct = AddImage("", "LoadingForestWorld_ImgForestWorld2", 160, 150);
				break;
				case Constant.SEA_ROUND_3:
					ct = AddImage("", "LoadingForestWorld_ImgForestWorld3", 160, 140);
				break;
			}
			ct.FitRect(50, 50, new Point(165, 145));
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_NHAN_THUONG:
					if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
					{
						GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
						GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, GuiMgr.getInstance().GuiMainFishWorld.CurrentPage);
						GuiMgr.getInstance().GuiMainFishWorld.UpdateStateButton();
					}
					ProcessComeBackForestSea();
					Hide();
				break;
			}
		}
		
		public function ProcessComeBackForestSea():void 
		{
			switch (FishWorldController.GetRound()) 
			{
				case Constant.SEA_ROUND_1:
					GameLogic.getInstance().Round1ComeBackForestSea();
				break;
				case Constant.SEA_ROUND_2:
					GameLogic.getInstance().Round2ComeBackForestSea();
				break;
				case Constant.SEA_ROUND_3:
					GameLogic.getInstance().Round3ComeBackForestSea();
				break;
			}
		}
	}

}