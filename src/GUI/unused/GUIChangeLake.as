package GUI.unused 
{
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Lake;
	import Logic.Pocket;
	import NetworkPacket.PacketSend.SendFishChangeLake;
	import Sound.SoundMgr;
	/**
	 * ...
	 * @author tuan
	 */
	public class GUIChangeLake extends BaseGUI
	{
		private const GUI_CHANGELAKE_BTN_OK:String = "BtnOk";
		private const GUI_CHANGELAKE_BTN_CANCEL:String = "BtnCancel";
		
		public var CurLakeButton:Button = null;
		public var CanSelectLake:Boolean = false;
		public var SelectedIdLake:int = 0;
		public var fish:Fish = null;
		
		public function GUIChangeLake(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChangeLake";
		}
		
		public override function InitGUI(): void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			LoadRes("GUI_ChangeLake");
			SetPos(255, 130);
			CurLakeButton = null;
			CanSelectLake = false;
			
			var fmt:TextFormat = new TextFormat("Arial", 18, 0x604220);			
			var tf:TextField = AddLabel("Chọn hồ muốn chuyển", 120, 40, 0x000000);
			tf.defaultTextFormat  = fmt;
			tf.text = "Chọn hồ muốn chuyển";
									
			var button:Button = AddButton(GUI_CHANGELAKE_BTN_CANCEL, "BtnThoat", 295, -4, this);
			//button.img.scaleX = button.img.scaleY = 0.8;
			
			button = AddButton(GUI_CHANGELAKE_BTN_OK, "BtnGreen", 80, 255, this);
			button.img.scaleX = button.img.scaleY = 1.3;
			AddLabel("Đồng ý", 60, 229, 0);
			button = AddButton(GUI_CHANGELAKE_BTN_CANCEL, "ButtonRed", 190, 255, this);
			button.img.scaleX = button.img.scaleY = 1.3;
			AddLabel("Hủy bỏ", 171, 229, 0);
			
			//Add button hồ
			var lakeArr:Array = GameLogic.getInstance().user.GetLakeArray();
			var i:int;
			var x:int = 40;
			var y:int = 40;
			var dx:int = 150;
			var format:TextFormat = new TextFormat("Arial", 20, 0xffffff, true);			
			format.size = 20;
			format.bold = true;
			for (i = 0; i < lakeArr.length; i++)
			{
				var lake:Lake = lakeArr[i] as Lake;
				if (GameLogic.getInstance().user.CurLake.Id == lake.Id)
				{
					continue;
				}
				var btn:Button = AddButton("BtnLake_" + lake.Id, "ButtonLake",  x,  y, this);				
				btn.img.scaleX = btn.img.scaleY = 1.8;
				btn.SetPos(x, 70);				
				//AddLabel("Hồ " + lake.Id, x - 15, y + 25);
				AddLabel(lake.Id.toString() , x - 21, btn.img.y + btn.img.height - 18, 0xffffff, 1,  0x26709C).setTextFormat(format);
				
				
				if (lake.Level <= 0)
				{
					var lock:Image = AddImage("", "ImgShopItemLock", btn.img.x + 30, btn.img.y + 50);
					lock.SetScaleX(1.4);
					lock.SetScaleY(1.4);
					//if (!GameLogic.getInstance().user.CanUserUnlockLake(lake.Id))
					//{
						btn.SetDisable();
					//}
				}
				else
				{
					CanSelectLake = true;
				}
				
				//Add thông tin về số lượng cá trong hồ
				var txt:TextField = AddLabel(lake.NumFish + " / " + lake.CurCapacity, x + 5, y + 130, 0xffffff, 1, 0x26709C);
				txt.setTextFormat(format);
				
				x += dx;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_CHANGELAKE_BTN_OK:
					if (CanSelectLake)
					{
						if (CurLakeButton == null)
						{
							//GuiMgr.getInstance().GuiMessageBox.ShowOK("Chưa chọn hồ để chuyển",  290, 200);
							return;
						}
						else
						{
							ChangeLake();
						}
					}
					else
					{
						Cancel();
					}								
					break;
				case GUI_CHANGELAKE_BTN_CANCEL:
					Cancel();
					break;
				default:
					SelectLake(buttonID);
					break;
			}
		}
		public function Cancel():void
		{
			Hide();
			if (fish != null)
			{
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight(-1);
			}
		}
		
		private function SelectLake(ID:String):void
		{
			var data:Array = ID.split("_");
			if (CurLakeButton != null)
			{
				CurLakeButton.SetHighLight(-1);
			}			
			CurLakeButton = GetButton("BtnLake_" + data[1]);
			SelectedIdLake = data[1];
			CurLakeButton.SetHighLight();
		}
		
		public function ChangeLake():void
		{
			var lake:Lake = GameLogic.getInstance().user.GetLake(SelectedIdLake);
			if (lake.Level <= 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message19"), 290, 200);
				Cancel();
				return;
			}
			
			if (lake.NumFish >= lake.CurCapacity)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg16"),  290, 200);
				Cancel();
				return;
			}
			
			lake.NumFish += 1;
			GameLogic.getInstance().user.CurLake.NumFish -= 1;
			
			var cmd:SendFishChangeLake = new SendFishChangeLake(fish.Id, GameLogic.getInstance().user.CurLake.Id, SelectedIdLake);
			Exchange.GetInstance().Send(cmd);
			
			// Effect
			var arr:Array = [];
			//var nameF:String = Fish.ItemType + fish.FishTypeId + "_Old_Idle";
			arr.push(fish.img);
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffChuyenHo", arr, fish.CurPos.x + 20, fish.CurPos.y + 30);			
			
			// Xóa túi tiền của con cá
			for (var i:int = 0; i < GameLogic.getInstance().user.PocketArr.length; i++)
			{
				var pocket:Pocket = GameLogic.getInstance().user.PocketArr[i];
				if (pocket.fish.Id == fish.Id)
				{
					GameLogic.getInstance().user.PocketArr.splice(i, 1);
					pocket.ClearImage();
					break;
				}
			}
			
			//xoa con ca khoi mang ca
			var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			var index:int = fishArr.indexOf(fish);			
			fish.Clear();
			fishArr.splice(index, 1);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
			
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			
			Cancel();
		}
	}

}