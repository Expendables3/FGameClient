package GUI.ZingMeWallet 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIZingWallet extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const CTN_LEVEL:String = "ctnLevel";
		static public const BTN_OK:String = "btnOk";
		
		public function GUIZingWallet(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(200, 200);
				AddButton(BTN_CLOSE, "BtnThoat", 100, 10);
				AddButton(BTN_OK, "BtnDong", 20, 100);
				
				for (var i:int = 0; i < 10; i++)
				{
					var ctn:Container = new Container(img, "", 20, i * 30 + 20, true, this);
					ctn.LoadRes("");
					ctn.AddLabel(String(i * 10), 0, 0);
					ctn.AddImage("", "IcZingXu", 0, 0);
					ctn.IdObject = CTN_LEVEL + i.toString();
					AddContainer2(ctn, 20, i * 30 + 20, this);
				}
			}
			LoadRes("GuiCongratulation_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_OK:
					
					break;
			}
			if (buttonID.search(CTN_LEVEL) >= 0)
			{
				var level:int = buttonID.split("_")[1];
				trace(level);
			}
		}
		
	}

}