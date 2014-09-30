package GUI.FishWorld 
{
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMapToolTip extends GUIToolTip 
	{
		private var arrListItem:Array;
		private var arrListItemUnlock:Array;
		public var arrImageFish:Array;
		public var data:Object;
		
		public function GUIMapToolTip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			this.ClassName = "GUIMapTooltip";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes(imgNameBg);
			var i:int = 0;
			var startX:int = 52;
			var startY:int = 18;
			var distanceX:int = 75;
			arrImageFish = [];
			
			var f:Function = function():void //Hàm này truyền vào để đổi màu cá
			{
				Ultility.SetEnableSprite(this.img, false, 0.2);
			}	
			
			// Add anh cac con ca vao GUI
			for (i = 0; i < arrListItem.length; i++) 
			{
				var item:String = arrListItem[i];
				var imageItem:Image;
				if (arrListItemUnlock[i] == 1)
				{
					imageItem = AddImage("", item, startX + i * distanceX - deltaX, startY - deltaY);
					imageItem.FitRect(70, 65, new Point(startX + i * distanceX - deltaX, startY - deltaY));
				}
				else 
				{
					imageItem = AddImage("", item, startX + i * distanceX - deltaX, startY - deltaY, true, ALIGN_CENTER_CENTER, false, f);
					imageItem.FitRect(50, 50, new Point(startX + i * distanceX - deltaX + 10, startY - deltaY + 7));
				}
				arrImageFish.push(imageItem);
			}
			getPosGui(getTypeBg());
			SetPos(posToolTipX, posToolTipY);
		}
		public function SetInfo(item:Object):void
		{
			data = new Object();
			data = item;
			arrListItem = item.ListItem;
			arrListItemUnlock = item.ListUnlock;
		}
	}

}