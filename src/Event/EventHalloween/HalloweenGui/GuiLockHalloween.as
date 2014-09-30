package Event.EventHalloween.HalloweenGui
{
	import Data.ConfigJSON;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventHalloween.HalloweenPackage.SendUnlockHalloween;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiLockHalloween extends BaseGUI
	{
		static public const CMD_CLOSE:String = "cmdClose";
		static public const CMD_UNLOCK:String = "cmdUnlock";
		static public const CMD_WAIT:String = "cmdWait";
		static public const CMD_UNLOCK_FREE:String = "cmdUnlockFree";
		
		private var tfTime:TextField;
		private var btnUnlock:Button;
		private var btnUnlockBuyXu:Button;
		private var tfPrice:TextField;
		public function GuiLockHalloween(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiLockHalloween";
		}
		
		override public function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(CMD_CLOSE, "BtnThoat", 408, 20);
				btnUnlock = AddButton(CMD_UNLOCK_FREE, "GuiLockHalloween_BtnUnlock", 90, 310);
				btnUnlock.SetVisible(false);
				btnUnlockBuyXu = AddButton(CMD_UNLOCK + "_ZMoney", "GuiLockHalloween_BtnUnlockZMoney", 90, 310);
				var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["SpeedupJoin"]["ZMoney"];
				tfPrice = AddLabel("", 123, 316, 0xffffff, 1, 0x000000);
				tfPrice.text = Ultility.StandardNumber(price);
				AddButton(CMD_CLOSE, "GuiLockHalloween_BtnWait", 270, 310);
				
				tfTime = AddLabel("", 182, 262, 0xffffff, 1, 0x000000);
				var fm:TextFormat = new TextFormat("Arial", 14);
				tfTime.defaultTextFormat = fm;
			}
			LoadRes("GuiLockHalloween_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			
			switch (cmd)
			{
				case CMD_CLOSE: 
					Hide();
					break;
				case CMD_UNLOCK: 
					if (!HalloweenMgr.getInstance().checkLockHalloween())
					{
						Hide();
						return;
					}
					var priceType:String = data[1];
					var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["SpeedupJoin"]["ZMoney"];
					if (Ultility.payMoney(priceType, price))
					{
						HalloweenMgr.getInstance().breakLockHalloween();
						var pk:SendUnlockHalloween = new SendUnlockHalloween(priceType);
						Exchange.GetInstance().Send(pk);
					}
					break;
				case CMD_UNLOCK_FREE:
					Hide();
					GuiMgr.getInstance().guiHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					break;
			}
		}
		
		public function updateGUI(curTime:Number):void
		{
			if (HalloweenMgr.getInstance().IsLockHalloween)
			{
				var passTime:Number = curTime - HalloweenMgr.getInstance().LastTimeLock;
				var cfgTime:int = 1800;
				var remainTime:Number = cfgTime - passTime;
				if (remainTime < -2)
				{
					btnUnlock.SetVisible(true);
					btnUnlockBuyXu.SetVisible(false);
					tfPrice.visible = false;
					HalloweenMgr.getInstance().breakLockHalloween();
				}
				else
				{
					if (remainTime >= 0)
					{
						tfTime.text = Ultility.convertToTime(int(remainTime));
					}
				}
			}
		}
	}

}

