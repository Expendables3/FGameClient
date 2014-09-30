package GUI 
{
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendFishing;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author Le Ba Dung
	 */
	public class GUIFishing extends BaseGUI
	{
		private const BUTTON_GUI_FISHING_CLOSE:String = "ButtonClose";
		private const BUTTON_GUI_FISHING_OK:String = "ButtonOk";
		
		private const MIN_SCALE:Number = 0.5;
		private const MAX_SCALE:Number = 1;
		private var RingScale:Number = 1;
		private var RingImage:Image;
		private var RingSpeed:Number = 0.1;
		private var RingDir:int = -1;
		private var RingSpeedArray:Array = [0.001, 0.001, 0.002, 0.1, 0.1, 0.15];
		
		public function GUIFishing(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishing";			
		}		

		/**
		 * 
		 */
		override public function InitGUI():void 
		{
			img = new Sprite;
			Parent.addChild(img);
			RingImage = AddImage("", "Fishing_Ring", 0, 0);
			//imgRing.SetScaleX(0.5);
			//imgRing.SetScaleY(0.5);
			AddImage("", "Fishing_Icon", 0, 0);			
			AddButton(BUTTON_GUI_FISHING_CLOSE, "BtnThoat", 25, -50, this);
			//GetButton(BUTTON_GUI_FISHING_CLOSE).img.scaleX = GetButton(BUTTON_GUI_FISHING_CLOSE).img.scaleY = 0.6;
			var fmt:TextFormat = new TextFormat();
			fmt.bold = true;
			fmt.color = 0xFFFFFF;
			AddButton(BUTTON_GUI_FISHING_OK, "BtnGreen", -23, 60, this);
			AddLabel("Câu", -50, 38).setTextFormat(fmt);			
			
			//var fishImgName:String = "Fish1_Old_Idle";
			//trace(fishImgName);
			//AddImage("", fishImgName, 0, 0, true);
			
			SetPos(500, 200);
		}
		
		private function CanFishing():Boolean
		{
			return GameLogic.getInstance().user.GetEnergy(true) >= ConfigJSON.getInstance().getEnergyInfo("fishing");;
		}
		/**
		 * Button click
		 * @param	event
		 * @param	buttonID
		 */
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{
				case BUTTON_GUI_FISHING_CLOSE:
					Hide();				
				break;
				case BUTTON_GUI_FISHING_OK:
					if (CanFishing())
					{
						if (IsSuccess())
						{
							FishingSuccess();
						}
						else
						{
							FishingFail();
						}
					}
					else
					{
						//GuiMgr.getInstance().GuiFishingCannot.Show(Constant.GUI_MIN_LAYER + 1);
						//GuiMgr.getInstance().GuiFishingCannot.Show();
						GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
						//GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message4"));
						Hide();
					}
				break;
			}
		}		
		
		/**
		 * Ham kiem tra co cau duoc hay ko
		 * @return
		 */
		private function IsSuccess():Boolean
		{
			//return true;
			if (RingScale > MIN_SCALE + 0.1)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * Ham duoc goi khi cau ca thanh cong
		 */
		private function FishingSuccess():void
		{
			//GuiMgr.getInstance().GuiFishingSuccess.RandomBonus();
			//GuiMgr.getInstance().GuiFishingSuccess.Show(Constant.GUI_MIN_LAYER + 1);			
			//var cmd:SendFishing = new SendFishing(GameLogic.getInstance().user.Id, GameLogic.getInstance().user.CurLake.Id, true);
			//Exchange.GetInstance().Send(cmd);
			
			Hide();
		}
		
		/**
		 * Ham duoc goi khi cau ca that bai
		 */
		private function FishingFail():void
		{
			//GameLogic.getInstance().user.GetMyInfo().Energy -= 2;
			GameLogic.getInstance().user.UpdateEnergy( -2);
			//var cmd:SendFishing = new SendFishing(GameLogic.getInstance().user.Id, GameLogic.getInstance().user.CurLake.Id, false);
			//Exchange.GetInstance().Send(cmd);
			
			//GuiMgr.getInstance().GuiFishingFail.Show(Constant.GUI_MIN_LAYER + 1);
			GuiMgr.getInstance().GuiFishingFail.Show();
			Hide();
		}
		
		/**
		 * Ham duoc goi sau moi frame
		 */
		public function Loop():void
		{
			if (!IsVisible)
			{
				return;
			}
			
			if (RingImage == null)
			{
				return;
			}
			
			RingSpeed = RingSpeedArray[Ultility.RandomNumber(0, RingSpeedArray.length - 1)];

			RingScale += RingDir * RingSpeed;
			if (RingScale > MAX_SCALE)
			{
				RingScale = MAX_SCALE;
				RingDir = -RingDir;
			}
			if (RingScale < MIN_SCALE)
			{
				RingScale = MIN_SCALE;
				RingDir = -RingDir;
			}
				
			RingImage.SetScaleX(RingScale);
			RingImage.SetScaleY(RingScale);
			
			var Offset:Number = 0;
			RingImage.SetPos(Offset * (1 - RingScale), Offset * (1 - RingScale));
		}
	}
}