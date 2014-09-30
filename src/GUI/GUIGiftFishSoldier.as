package GUI 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.Fish;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIGiftFishSoldier extends BaseGUI 
	{
		private static const BTN_DONG_Y:String = "BtnDongY";
		private static const BTN_CANCEL:String = "BtnThoat";
		private static const CTN_GIFT:String = "CtnGift";
		public var fishTypeId:int;
		
		public function GUIGiftFishSoldier(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftFishSoldier";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GuiGiftFishSoldier");	
			SetPos(125, 70);
		}
		
		public function Init(fishId:int):void
		{
			fishTypeId = fishId;
			this.Show(Constant.GUI_MIN_LAYER, 5);
			ClearComponent();
			AddFish();
			AddNPC();
			AddButtons();
		}
		
		public function AddFish():void
		{
			var ctn:Container = AddContainer(CTN_GIFT, "CtnGiftFish", 280, 172);
			ctn.AddImage("", Fish.ItemType + fishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
		}
		
		public function AddNPC():void
		{
			var npcImg:Image = AddImage("", "NPC_Mermaid_War", 60, 155, true, ALIGN_LEFT_TOP);
			npcImg.SetScaleXY(0.8);
		}
		
		public function AddButtons():void
		{
			AddButton(BTN_DONG_Y, "BtnDongY", 250, 400);
			AddButton(BTN_CANCEL, "BtnThoat", 540, 22);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_DONG_Y:
					//GuiMgr.getInstance().GuiSeriesQuest.CompleteQuest();
					GameLogic.getInstance().user.GenerateNextID();
					this.Hide();
					break;
				case BTN_CANCEL:
					this.Hide();
					break;
			}
		}	
	}

}