package GUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import Logic.GameLogic;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ...
	 */
	public class GUITanThuDetailClickFinish extends GUITanThuDetailClickWait 
	{
		
		public function GUITanThuDetailClickFinish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				this.ClassName = "GUITanThuDetailClickFinish";	
				
				AddButtons();
				AddDetail();
				AddImgs(GameLogic.getInstance().user.tuiTanThu.giftList);
			}
			LoadRes("GuiTanThuDetailClickFinish_Theme");
		}
		
		override public  function AddDetail():void 
		{
			var f:TextFormat = new TextFormat();
			var lv:int = GameLogic.getInstance().user.Level;
			var times:int = GameLogic.getInstance().user.tuiTanThu.timesOpen;
			var t1:TextField=AddLabel("Bạn đã nhận đủ 4 lần quà tại cấp độ "+lv, 210, 177, 0x096791);
			f.size = 16;
			f.color = 0x004080;
			t1.setTextFormat(f);
			lv++;
			var t2:TextField=AddLabel("Bạn cần phải đạt cấp độ "+lv+" để tiếp tục nhận quà .", 190, 138);
			t2.setTextFormat(f);
		}
		
		override public function Update(time:String):void 
		{
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
		}
		
	}

}