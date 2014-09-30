package Event.EventMidAutumn 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIFailGift extends BaseGUI 
	{
		private var numExp:int;
		static public const BNT_RECEIVE:String = "bntReceive";
		
		public function GUIFailGift(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(208, 172);
				AddButton(BNT_RECEIVE, "BtnThoat", 400 - 51, 17);
				AddButton(BNT_RECEIVE, "BtnNhanThuong", 50 + 86, 225);
				AddImage("", "IcExp", 50 + 142, 148);
				var label:TextField = AddLabel("x" + Ultility.StandardNumber(numExp), 50 + 99, 168, 0xffff00, 1, 0x000000);
				label.setTextFormat(new TextFormat("arial", 18, 0xffff00, true));
			}
			LoadRes("GuiFailGift_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BNT_RECEIVE)
			{
				GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + numExp);
				Hide();
			}
		}
		
		public function showGUI(_numExp:int):void
		{
			numExp = _numExp;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
	}

}