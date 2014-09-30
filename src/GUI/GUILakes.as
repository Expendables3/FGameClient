package GUI 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Lake;
	import Logic.Ultility;
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUILakes extends BaseGUI
	{
		private const GUI_LAKE_BTN_CLOSE:String = "0";

		private var IsHiding:Boolean = false;
		public var SelectedLake:Lake;
		
		
		public function GUILakes(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUILakes";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("ImgFrameFriend");
			//GuiMgr.getInstance().GuiMain.btnHideLakes.SetEnable(false);
			GuiMgr.getInstance().GuiMain.ShowButtonLake(false);		
		}
		
		public function ShowLakes():void
		{
			var lakeArr:Array = GameLogic.getInstance().user.GetLakeArray();
			var i:int;
			
			//trace(ImageArr.length);
			for (i = 0; i < lakeArr.length; i++)
			{
				var lake:Lake = lakeArr[i] as Lake;
				var btn:Button = AddButton("BtnLake_" + lake.Id, "ButtonLake", -15, 10 + i * 60, this);
				// ten ho
				var lbl:TextField = AddLabel(lake.Id.toString(), btn.img.x - 35, btn.img.y + 35, 0, 1, 0x26709C);
				var txtFormat:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
				lbl.setTextFormat(txtFormat);
				Ultility.SetHightLight(lbl);
				if (GameLogic.getInstance().user.CurLake.Id == lake.Id)
				{
					btn.SetHighLight(0xffffff);
					btn.img.scaleX = 1.1;
					btn.img.scaleY = 1.1;
				}
				if (lake.Level <= 0)
				{
					var lock:Image = AddImage("", "ImgShopItemLock", btn.img.x + 20, btn.img.y + 40);
					lock.img.mouseChildren = false;
					lock.img.mouseEnabled = false;
					
					// kiem tra xem co unlcok dc ko
					if (lake.LakeLevels[0]["LevelRequire"] > GameLogic.getInstance().user.GetLevel())
					{
						btn.SetEnable(false);
					}
					// ko dc xem ho nha ban
					if (GameLogic.getInstance().user.IsViewer())
					{
						btn.SetEnable(false);
					}
				}
				else
				{
					
				}
			}
			var y:int = GuiMgr.getInstance().GuiMain.img.y;
			SetPos(730, y - img.height + 20);
		}
		
		public function ShowMoving(ilayer:int, x:int, y:int):void
		{
			Show(ilayer);	
			//var y:int = GuiMgr.getInstance().GuiMain.img.y;
			IsHiding = false;
			SetPos(x, y);	
			MoveTo(x, y - img.height, 30);
		}
		
		public function RefreshGUI():void
		{
			if (IsVisible)
			{
				var ilayer:int = iLayer;
				Hide();
				Show(ilayer);
			}
		}
		
		private function SelectLake(ID:String):void
		{
			var data:Array = ID.split("_");
			var st:String;
			
			SelectedLake = GameLogic.getInstance().user.GetLake(data[1]);
			
			if (SelectedLake.Level <= 0)
			{
				st = Localization.getInstance().getString("Message1");
				st = st.replace("@GiaTien", SelectedLake.GetUnlockMoney());
				st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
				// unlock ho
				if (GameLogic.getInstance().user.GetMoney() >= SelectedLake.GetUnlockMoney())
				{
					GameLogic.getInstance().SetState(GameState.GAMESTATE_UNLOCK_LAKE);
					
					GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				}

			}
			else
			{
				if (GameLogic.getInstance().user.CurLake.Id != SelectedLake.Id)
				{
					//GameLogic.getInstance().DoGoToLake(SelectedLake.Id, GameLogic.getInstance().user.Id);
					var st1:String = "GoToLake_" + SelectedLake.Id + "_" + GameLogic.getInstance().user.Id;
					GameController.getInstance().UseTool(st1);
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_LAKE_BTN_CLOSE:
				var x:int = GuiMgr.getInstance().GuiMain.img.x;
				var y:int = GuiMgr.getInstance().GuiMain.img.y;
				MoveHide(x, y);
				break;
				
				default:
				SelectLake(buttonID);
				break;
			}
		}
		
		public function MoveHide(x:int, y:int):void
		{
			IsHiding = true;
			MoveTo(x, y, 30);
		}
		
		public override function OnFinishMoving():void
		{
			if (IsHiding)
			{				
				GuiMgr.getInstance().GuiMain.ShowButtonLake(true);
				Hide();
			}
			else
			{
				//GuiMgr.getInstance().GuiMain.btnHideLakes.SetEnable(true);
			}
		}
	}

}