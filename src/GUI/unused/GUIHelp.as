package GUI.unused
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	import flash.events.*;
	import Logic.*;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIHelp extends BaseGUI
	{
		public static var GUI_HELP_BTN1:String = "hlp_btn1";
		public static var GUI_HELP_PRG1:String = "prg1";
		
		public function GUIHelp(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIHelp";
		}
		
		public override function InitGUI():void
		{
			var container:Container = AddContainer("container1", "GUI1", 30, 50);
			
			var txt:TextBox = container.AddTextBox("test", "Help gui na`y", -100, -100, 120, 30);
			container.TooltipText = "Minh bệnh, bệnh Minh";
			txt.SetSize(200, 20);
			var btn:Button = container.AddButton(GUI_HELP_BTN1, "button1", 10, 30, this);
			btn.TooltipText = "Tên tôi là Trần Minh";
			//var prBar:ProgressBar = container.AddProgressBar(GUI_HELP_PRG1, "loading", 100, 100);
			//var image:Sprite = container.AddImage("aaa", "button1", 20, 40);
			SetDragable(new Rectangle(100, 0, 300, 30));
			
			//this.img.m
			SetPos(120, 300);
			img.scaleX = 2;
		}
	
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == GUI_HELP_BTN1)
			{
				//var sound:Sound = SoundMgr.getInstance().getSound("test1") as Sound;
				//if(sound != null)sound.play();
			}
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
			
		}
		
	}

}