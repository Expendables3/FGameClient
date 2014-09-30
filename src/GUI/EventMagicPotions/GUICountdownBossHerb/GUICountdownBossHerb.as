package GUI.EventMagicPotions.GUICountdownBossHerb 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.EventMagicPotions.NetworkPacket.SendRebornHerbBoss;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.User;
	
	/**
	 * GUI hiển thị thời gian đếm BOss xuất hiện
	 * @author longpt
	 */
	public class GUICountdownBossHerb extends BaseGUI 
	{
		public var txtF:TextField;
		
		private static const BTN_INFO:String = "BtnInfo";
		private static const BTN_REBORN:String = "BtnReborn";
		
		private var costReborn:int = 5; // HARD CODE!!!! =))
		
		public function GUICountdownBossHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUICountdownBossHerb";
		}
		public override function InitGUI() :void
		{
			LoadRes("GuiCountdownBossHerb_Theme");
			SetPos(475, 55);
			
			AddButton(BTN_INFO, "GuiCountdownBossHerb_BtnGuide", 205, 5);
			
			// Nếu đánh thua boss thì cho hiện nút đánh lại
			if (GameLogic.getInstance().user.GetMyInfo().EventInfo.IsFail == true)
			{
				var btn:Button = AddButton(BTN_REBORN, "Btngreen", 46, 135);
				btn.img.scaleX = 1;
				btn.img.scaleY = 0.8;
				var txtFormat:TextFormat = new TextFormat(null, 15);
				AddLabel("Đấu lại   " + costReborn, 52, 109, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
				AddImage("", "IcZingXu", 140, 114).SetScaleXY(1.5);
			}
			
			RefreshContent();
		}
		
		public function RefreshContent():void
		{
			var TimeLeft:int = -1 * CheckTimeLeft();
			if (TimeLeft > 0)
			{
				var minLeft:int = Math.floor(TimeLeft / 60);
				var secLeft:int = TimeLeft % 60;
				var str:String = "";
				if (minLeft < 10)
				{
					str += "0" + minLeft + ":";
				}
				else
				{
					str += minLeft + ":";
				}
				
				if (secLeft < 10)
				{
					str += "0" + secLeft;
				}
				else
				{
					str += secLeft;
				}
				
				if (!txtF)
				{
					var tF:TextFormat = new TextFormat();
					tF.size = 30;
					txtF = AddLabel(str, 50, 60, 0xffffff, 1, 0x000000);
					txtF.defaultTextFormat = tF;
				}
				else
				{
					txtF.text = str;
				}
				
				SetScaleXY(0.8);
			}
			else
			{
				this.Hide();
			}
		}
		
		public function UpdateGUI():void 
		{
			RefreshContent();
		}
		
		private function CheckTimeLeft():int
		{
			if (BossHerb.CooldownBoss <= 0)
			{
				BossHerb.CooldownBoss = ConfigJSON.getInstance().GetItemList("Event")["MagicPotion"]["TimeAppear"];
			}
			
			var user:User = GameLogic.getInstance().user;
			if (!user.GetMyInfo().EventInfo)
			{
				user.GetMyInfo().EventInfo = new Object();
			}
			
			if (!user.GetMyInfo().EventInfo.LastTimeAttackBoss)
			{
				user.GetMyInfo().EventInfo.LastTimeAttackBoss = 0;
			}
			
			var lastAtk:Number = user.GetMyInfo().EventInfo.LastTimeAttackBoss;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			
			return curTime - lastAtk - BossHerb.CooldownBoss - Constant.TIME_DELAY;
		}
		
		public override function OnHideGUI():void
		{
			txtF = null;
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_INFO:
					GuiMgr.getInstance().GuiInfoBossHerb.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_REBORN:
					if (GameLogic.getInstance().user.GetZMoney() < costReborn)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						break;
					}
					
					// Cmd
					var cmd:SendRebornHerbBoss = new SendRebornHerbBoss();
					Exchange.GetInstance().Send(cmd);
					
					// Update ZMoney
					GameLogic.getInstance().user.UpdateUserZMoney( -costReborn);
					
					// Update Last AtkBoss
					GameLogic.getInstance().user.GetMyInfo().EventInfo.LastTimeAttackBoss = 0;
					break;
			}
		}
	}

}