package GUI.Mail.SystemMail.View 
{
	import GUI.GUIChooseElementAbstract;
	import GUI.GuiMgr;
	import GUI.Mail.SystemMail.MailPackage.SendInputCode;
	
	/**
	 * Chọn hệ khi nhập ItemCode
	 * @author HiepNM2
	 */
	public class GuiInputCodeElement extends GUIChooseElementAbstract 
	{
		private var _code:String;
		public function set Code(value:String):void
		{
			_code = value;
		}
		public function GuiInputCodeElement(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiInputCodeElement";
		}
		override public function receiveGift(element:int):void 
		{
			var pk:SendInputCode = new SendInputCode(_code, element);
			Exchange.GetInstance().Send(pk);
			GuiMgr.getInstance().GuiInputCode.GetButton(GUIInputCode.ID_BTN_CLOSE).SetDisable();
			GuiMgr.getInstance().GuiInputCode.GetButton(GUIInputCode.ID_BTN_RECEIVE).SetDisable();
			Hide();
		}
	}

}