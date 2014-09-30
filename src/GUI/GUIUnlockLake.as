package GUI 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Lake;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIUnlockLake extends BaseGUI
	{
		
		public var lakeId:int = 0;
		
		private var GUI_UNLOCK_BTN_CLOSE:String = "buttonClose";
		private var GUI_UNLOCK_BTN_UNLOCK:String = "buttonUnlock";
		private var GUI_UNLOCK_BTN_BUY_PERMIT:String = "buttonBuyPermit";
		
		public var txtLicense:TextField;
		
		private var btnUnlock:Button;
		
		public function GUIUnlockLake(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		//Add button đóng ở góc trên bên phải
		private function AddButtons():void
		{
			var bt:Button = AddButton(GUI_UNLOCK_BTN_CLOSE, "BtnThoat", 372, 17, this);
			//bt.img.scaleX = bt.img.scaleY = 1.25;
			btnUnlock = AddButton(GUI_UNLOCK_BTN_UNLOCK, "GuiUnlockLake_BtnOpenLake", 70, 210, this);
			bt = AddButton(GUI_UNLOCK_BTN_BUY_PERMIT, "GuiUnlockLake_BtnGotoShop", 190, 210, this);
			//bt.img.scaleX = bt.img.scaleY = 0.65;
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(220, 180);	
				AddButtons();	
				OpenRoomOut();
			}			
			LoadRes("GuiUnlockLake_Theme");
		}
		
		public function ShowGUIUnlock(lId:int):void
		{
			lakeId = lId;
			ClearComponent();
			GameLogic.getInstance().BackToIdleGameState();
			this.Hide();
			this.Show(Constant.GUI_MIN_LAYER, 5);
			
		}
		
		public override function  EndingRoomOut():void
		{

			var lake:Lake = GameLogic.getInstance().user.GetLake(lakeId);
			var userLicense:int;
			
			AddImage("", "GuiUnlockLake_ImgLakeIcon" + lake.Id, 55, 135);
			AddImage("", "GuiUnlockLake_TxtIndexLake" + lake.Id, 250, 37);
			
			if (GameLogic.getInstance().user.StockThingsArr.License[0] != null)
			{
				userLicense = GameLogic.getInstance().user.StockThingsArr.License[0].Num;
			}
			else
			{
				userLicense = 0;
			}
			
			var lakeLevelInfo:Object = lake.LakeLevels[0];
			var licenseNeed:int = lakeLevelInfo["License"];
			
			// Add thông tin lên GUI: giấy phép, level yêu cầu, tổng số cá
			var txtFld:TextField;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "arial";
			txtFormat.size = 15;
			txtFormat.bold = true;
			txtFormat.align = "center";
			txtFormat.color = 0x000000;
			
			txtLicense = AddLabel(userLicense + "/" + licenseNeed, 260, 127);
			txtLicense.setTextFormat(txtFormat);
			txtFld = AddLabel(lakeLevelInfo["LevelRequire"], 260, 102);
			txtFld.setTextFormat(txtFormat);
			txtFld = AddLabel(lakeLevelInfo["TotalFish"] + "/" + lakeLevelInfo["TotalFish"], 54, 168);	
			txtFld.autoSize = "center";		
			txtFld.defaultTextFormat = txtFormat;
			
			txtFormat = new TextFormat();
			txtFormat.size = 18;
			txtFormat.color = 0xFFFFFF;
			txtFormat.bold = true;
			txtFormat.align = "center";
			txtFld.setTextFormat(txtFormat);
			txtFld.width = txtFld.textWidth;	
			
			if (userLicense < licenseNeed)
			{
				btnUnlock.SetDisable();
			}
			else
			{
				btnUnlock.SetEnable();
			}
		}
		
		public function UpdateLicense():void 
		{
			var lake:Lake = GameLogic.getInstance().user.GetLake(lakeId);
			var lakeLevelInfo:Object = lake.LakeLevels[0];
			var licenseNeed:int = lakeLevelInfo["License"];
			
			var userLicense:int;
			if (GameLogic.getInstance().user.StockThingsArr.License[0] != null)
			{
				userLicense = GameLogic.getInstance().user.StockThingsArr.License[0].Num;
			}
			else
			{
				userLicense = 0;
			}
			txtLicense.text = userLicense + "/" + licenseNeed;
			if (userLicense < licenseNeed)
			{
				btnUnlock.SetDisable();
			}
			else
			{
				btnUnlock.SetEnable();
			}
		}
		
		private function ShowUnlockLake(objID:int):void
		{
			var lake:Lake;
			var st:String;
			
			lake = GameLogic.getInstance().user.LakeArr[objID];
			GuiMgr.getInstance().GuiMain.SelectedLake = lake;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_UNLOCK_LAKE);
			st = Localization.getInstance().getString("Message1");
			st = st.replace("@GiaTien", lake.GetUnlockMoney());
			st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
			GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
		}

		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_UNLOCK_BTN_CLOSE:
					this.Hide();
					break;
				case GUI_UNLOCK_BTN_UNLOCK:
					ShowUnlockLake(lakeId - 1);
					GameLogic.getInstance().DoUnlockLake(GameLogic.getInstance().user.GetLake(lakeId));
					Hide();
					break;
				case GUI_UNLOCK_BTN_BUY_PERMIT:
					GuiMgr.getInstance().GuiShop.CurrentShop = "Special";
					GuiMgr.getInstance().GuiShop.curPage = 1;
					GameController.getInstance().UseTool("Shop");
					break;
				default:
					break;
			}
		}
	}

}