package GUI.EventMagicPotions 
{
	import flash.events.MouseEvent;
	import GameControl.GameController;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	
	/**
	 * Container chứa nút chọn đánh hay chăm sóc
	 * @author longpt
	 */
	public class TooltipBossHerb extends Container 
	{
		public static const BTN_CARE:String = "BtnCare";
		public static const BTN_RAPE:String = "BtnRape";
		public static const BTN_NOTICE:String = "BtnNotice";
		private var Boss:BossHerb = null;
		
		public function TooltipBossHerb(boss:BossHerb, parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			Boss = boss;
			super(parent, imgName, x, -40, isLinkAge, imgAlign);
			ClassName = "TooltipBossHerb";
			var btn:ButtonEx;
			btn = AddButtonEx(BTN_RAPE, "EmoWar", -25, 0, this);
			btn.SetScaleXY(1.2);
			btn.SetVisible(false);
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = "Tấn công";
			btn.setTooltip(tt);
			
			btn = AddButtonEx(BTN_CARE, "EmoCare", 30, 0, this)
			btn.SetVisible(false);
			tt = new TooltipFormat();
			tt.text = "Chăm sóc";
			btn.setTooltip(tt);
			
			AddButtonEx(BTN_NOTICE, "EmoNotice", 0, 0, this);
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{	
			switch (buttonID)
			{
				case BTN_RAPE:
				case BTN_CARE:
				case BTN_NOTICE:
					var btnE:ButtonEx = GetButtonEx(buttonID);
					btnE.SetHighLight(0x00ff00);
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_RAPE:
				case BTN_CARE:
				case BTN_NOTICE:
					var btnE:ButtonEx = GetButtonEx(buttonID);
					btnE.SetHighLight( -1);
					break;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_RAPE:
					if (Boss.SendAttackBoss())
					{
						this.SetVisible(false);
					}
					break;
				case BTN_CARE:
					if (Boss.SendCareBoss())
					{
						this.SetVisible(false);
					}
					break;
				case BTN_NOTICE:
					GameController.getInstance().UseTool("RapeBoss");
					GetButtonEx(BTN_NOTICE).SetVisible(false);
					//GetButtonEx(BTN_CARE).SetVisible(true);
					//GetButtonEx(BTN_RAPE).SetVisible(true);
					break;
			}
		}
	}

}