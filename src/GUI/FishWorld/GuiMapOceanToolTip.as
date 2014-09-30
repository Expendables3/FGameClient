package GUI.FishWorld 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GuiMapOceanToolTip extends GUIToolTip 
	{
		private const IMG_GIFT:String = "ImgGift_";
		private const STATE_LOCK:int = 0;
		private const STATE_UNLOCK:int = 1;
		
		private var posParent:Point = new Point();
		private var sizePX:Number;
		private var sizePY:Number;
		private var sizeX:Number;
		private var sizeY:Number;
		
		private var arrImageGift:Array = [];
		private var arrItemGift:Array = [];
		private var arrStateLockGift:Array = [];
		private var IdSea:int = -1;
		public function GuiMapOceanToolTip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			this.ClassName = "GuiMapOceanToolTip";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("GuiMapOcean_ImgBgGUIMap");
			
			var txtFieldLabel:TextField = AddLabel("Có thể nhận được các vật phẩm\nsau khi vào " + GetNameSea(), 85, 23, 0x264904);// , 1, 0x26709C);
			var formatLabel:TextFormat = new TextFormat(null, 15);
			formatLabel.align = TextFormatAlign.CENTER;
			txtFieldLabel.setTextFormat(formatLabel);
			
			sizeX = img.width;
			sizeY = img.height;
			var f:Function = function():void //Hàm này truyền vào để đổi màu cá
			{
				Ultility.SetEnableSprite(this.img, false, 0.2);
			}	
			
			var numRow:int = 2;
			var numCol:int = 3;
			var deltaX:Number = 77;
			var deltaY:Number = 79;
			var startX:Number = 20;
			var startY:Number = 66.5;
			
			var i:int = 0;
			var row:int;
			var col:int;
			// Add anh cac con ca vao GUI
			for (i = 0; i < arrItemGift.length; i++) 
			{
				row = Math.floor(i / numCol);
				col = Math.floor(i % numCol);
				var item:String = arrItemGift[i];
				if(item.search("Visa") < 0)
				{	
					var imageItem:Image;
					if (arrStateLockGift[i] == STATE_UNLOCK)
					{
						imageItem = AddImage("", item, 0, 0);
						imageItem.FitRect(50, 50, new Point(startX + col * deltaX + 10, startY + row * deltaY));
					}
					else 
					{
						imageItem = AddImage("", item, 0, 0, true, ALIGN_CENTER_CENTER, false, f);
						imageItem.FitRect(50, 50, new Point(startX + col * deltaX + 10, startY + row * deltaY));
					}
					// Add Label
					var txtField:TextField = AddLabel(GetName(item), startX + col * deltaX -10, startY + row * deltaY + 50, 0xFFFF00, 1, 0x26709C);
					var format:TextFormat = new TextFormat(null, 12);
					format.align = TextFormatAlign.CENTER;
					txtField.setTextFormat(format);
					//txtField.width = 70;
					//txtField.multiline = true;
					//txtField.wordWrap = true;
					
					arrImageGift.push(imageItem);
				}
			}
			getPosGui(getTypeBg());
			SetPos(posToolTipX, posToolTipY);
		}
		
		public function GetNameSea():String
		{
			var str:String = "";
			switch (IdSea) 
			{
				case Constant.OCEAN_NEUTRALITY:
					str = "biển Hoang Sơ";
				break;
				case Constant.OCEAN_METAL:
					str = "biển Kim";
				break;
			}
			return str;
		}
		
		public function GetName(st:String):String
		{
			var arr:Array = st.split("_");
			var str:String = arr[0];
			var name:String = "";
			var id:int = 0;
			if (str.search("Weapon") >= 0)
			{
				name = name + "Vũ khí hệ\n";
				id = str.split("Weapon")[1];
				id = Math.floor(id / 100);
			}
			else if (str.search("Helmet") >= 0)
			{
				name = name + "Áo giáp hệ\n";
				id = str.split("Helmet")[1];
				id = Math.floor(id / 100);
			}
			else if (str.search("Armor") >= 0)
			{
				name = name + "Mũ hệ\n";
				id = str.split("Armor")[1];
				id = Math.floor(id / 100);
			}
			else if (str.search("Visa") >= 0)
			{
				name = name + "Chìa khóa vào\nthế giới ";
				id = str.split("Visa")[1];
			}
			name = name + Ultility.GetNameElement(id);
			return name;
		}
		
		/**
		 * 
		 * @param	Data		:	Dữ liệu đã nhập vào như gui trước, có chứa danh sách các item
		 * @param	pos			:	vị trí của cha
		 * @param	sizeParentX	:	kích thước chiều rộng của cha
		 * @param	sizeParentY	:	Kích thước chiều đài của cha
		 */
		public function Init(Data:Object):void 
		{
			//posParent = pos;
			//sizePX = sizeParentX;
			//sizePY = sizeParentY;
			arrItemGift = Data.ListItem;
			arrStateLockGift = Data.ListUnlock;
			IdSea = Data.Id;
			//Show();
		}
		
		private function GetCurPos():Point
		{
			var cPos:Point = new Point();
			if (posParent.x < Constant.STAGE_WIDTH / 2 && posParent.y < Constant.STAGE_HEIGHT / 2)
			{
				cPos.x = posParent.x + sizePX - 5;
				cPos.y = posParent.y + sizePY - 5;
			}
			else if (posParent.x >= Constant.STAGE_WIDTH / 2 && posParent.y >= Constant.STAGE_HEIGHT / 2)
			{
				cPos.x = posParent.x - sizeX + 5;
				cPos.y = posParent.y - sizeY + 5;
			}
			else if (posParent.x >= Constant.STAGE_WIDTH / 2 && posParent.y < Constant.STAGE_HEIGHT / 2)
			{
				cPos.x = posParent.x - sizeX + 5;
				cPos.y = posParent.y + sizePY - 5;
			}
			else
			{
				cPos.x = posParent.x + sizePX - 5;
				cPos.y = posParent.y - sizeY + 5;
			}
			return cPos;
		}
	}

}