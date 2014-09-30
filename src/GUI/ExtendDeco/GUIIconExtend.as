package GUI.ExtendDeco 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiMgr;
	
	/**
	 * GUI hiện icon gia hạn trên mỗi deco đang trang trí
	 * @author dongtq
	 */
	public class GUIIconExtend extends BaseGUI 
	{
		public var buttonExtend:Button;
		public var idDeco:int;
		
		public function GUIIconExtend(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("");
			buttonExtend = AddButton("btnExtend", "Btn_Extend_Deco", 0, 0);
			buttonExtend.img.scaleX = buttonExtend.img.scaleY = 0.7;
		}
		
		public function showGUI():void
		{
			Show(Constant.OBJECT_LAYER);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			GuiMgr.getInstance().guiExtendDeco.showGUI(idDeco);
		}
	}

}