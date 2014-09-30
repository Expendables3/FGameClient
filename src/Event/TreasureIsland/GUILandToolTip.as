package Event.TreasureIsland 
{
	import Data.ConfigJSON;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import GUI.component.BaseGUI;
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUILandToolTip extends BaseGUI 
	{
		private var tip:TextField;
		private var num:TextField;
		
		public function GUILandToolTip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUILandTooltip";
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUILandToolTip");
			SetPos(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);	
			tip = AddLabel("", -50, -75, 0xffffff);
			num = AddLabel("", -20, -35, 0x000000, 1, 0xffffff);
		}
		
		public function showGUI(type:int):void
		{
			if (type < 1) return;
			Show(Constant.GUI_MIN_LAYER);
			var configStateLand:Object = ConfigJSON.getInstance().getItemInfo("Island_StateMap");
			num.text = "-" + configStateLand[type]["ShovelRequire"].toString();
			switch (type)
			{
				case 1:
					tip.text = "Click để đào đất";
					break;
				case 2:
				case 8:
				case 9:
					tip.text = "Click để phá đá";
					break;
				case 3:
					tip.text = "Click để bắt cua";
					break;
				case 4:
					tip.text = "Click để bắt ốc";
					break;
				case 5:
				case 6:
				case 7:
					tip.text = "Click để chặt cây";
					break;
			}
		}
	}

}