package GUI 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import Logic.Fish;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class GUISecretFishInfo extends BaseGUI
	{
		private static const GUI_SECRETFISHINFO_BTN_CLOSE:String = "ButtonMale";		
		public var FishTypeId:int;
		public function GUISecretFishInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISecretFishInfo";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GUI_Bgr");
			var button:Button = AddButton(GUI_SECRETFISHINFO_BTN_CLOSE, "BtnThoat", 232, 2, this);
			//button.img.scaleX = button.img.scaleY = 0.6;
			SetPos(300, 200);		
			
			
			var image1:Image = AddImage("",  "CtnMuaCaBg", 80, 80);
			var f:Function = function():void //Hàm này truyền vào để đổi màu cá
			{
				var c:ColorTransform = new ColorTransform(0, 0, 0, 2, 0, 0, 0, 0);
				this.img.transform.colorTransform = c;
			}		
			var image2:Image = AddImage("",  Fish.ItemType + FishTypeId + "_Baby_Idle", 110, 100, true, ALIGN_CENTER_CENTER, false, f);
			image2.FitRect(75, 75, new Point(image1.img.x + 10, image1.img.y - 5));
			
			var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, FishTypeId);
			AddLabel("Cấp độ: Level " + obj["LevelRequire"], 140, 50, 0, 0);
			AddLabel("Mở khóa: " , 140, 70, 0, 0);			
				
			OpenRoomOut();
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_SECRETFISHINFO_BTN_CLOSE:
					Hide();
					break;				
				default:
					break;
			}
		}
	}

}