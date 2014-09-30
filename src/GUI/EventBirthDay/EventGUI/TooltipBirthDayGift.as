package GUI.EventBirthDay.EventGUI 
{
	import Data.Localization;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * Tooltip khi di qua quà trong gui đổi quà
	 * @author HiepNM2
	 */
	public class TooltipBirthDayGift extends BaseGUI 
	{
		private var _id:int;
		private var _gift:Object;
		private var _numSlot:int;
		private var arrGift:Array;
		private var tipY:Object = new Object();
		public function TooltipBirthDayGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUITooltipBirthDayGift";
			tipY[1] = 60;
			tipY[2] = 160;
			tipY[3] = 300;
		}
		
		override public function InitGUI():void 
		{
			LoadRes("Event83_GUITooltip");
			drawTitle();
			drawSlot();
			drawGift();
			SetPos(250, tipY[_id]);
		}
		
		public function init(gift:Object,idGift:int):void
		{
			_gift = gift;
			var count:int = 0;
			for (var i:String in gift)
			{
				if (getTypeName(gift[i]["ItemType"]) == "Event_8_3_Jewelry")
				{
					continue;
				}
				else if (getTypeName(gift[i]["ItemType"]) == "Event_8_3_VuKhi")
				{
					continue;
				}
				count++;
			}
			_numSlot = count + 2;
			_id = idGift;
		}
		
		
		private function getTypeName(itemType:String):String
		{
			switch(itemType)
			{
				case "Ring":
				case "Bracelet":
				case "Necklace":
				case "Belt":
					return "Event_8_3_Jewelry";
				case "Weapon":
				case "Armor":
				case "Helmet":
					return "Event_8_3_VuKhi";
				default:
					return itemType;
			}
		}
		
		private function drawGift():void 
		{
			var imName:String;
			var x:int = 60;
			var y:int = 90;
			var image:Image;
			var num:int;
			var w:int, h:int,dx:int,dy:int;
			for (var i:int = 1; i <= _numSlot - 2; i++)
			{
				if (_gift[i]["ItemType"] == "Gem")
				{
					imName = "Event_8_3_" + _gift[i]["ItemType"] + "_" + _gift[i]["ItemId"];
					w = 60; h = 60; dx = 30; dy = 35;
				}
				else if (_gift[i]["ItemType"] == "PowerTinh")
				{
					imName = _gift[i]["ItemType"];
					w = 70, h = 70; dx = 35; dy = 40;
				}
				else
				{
					imName = _gift[i]["ItemType"] + _gift[i]["ItemId"];
					w = 70, h = 70; dx = 35; dy = 35;
				}
				num = _gift[i]["Num"];
				image = AddImage("", imName, x, y);
				image.FitRect(w, h, new Point(x - dx, y - dy));
				AddLabel(Ultility.StandardNumber(num), x - 50, y + 22, 0xffffff, 1, 0x000000);
				if ((i % 4) == 0)
				{
					y += 90;
					x = 60;
				}
				else
					x+=85
			}
			x += 20;
			AddImage("", "Event_8_3_Eff_" + (_id + 1), x + 1, y + 1);
			AddImage("", "Event_8_3_Jewelry" + (_id + 1), x, y - 3);
			AddLabel("1", x - 45, y + 22, 0xffffff, 1, 0x000000);
			var name:String = Localization.getInstance().getString("EventBirthDay_Jewelry");
			name += getNameById(_id);
			AddLabel(name, x - 55, y + 40, 0x0000ff, 1, 0xffffff);
			
			x += 105;
			AddImage("", "Event_8_3_Eff_" + (_id + 1), x + 1, y + 1);
			AddImage("", "Event_8_3_VuKhi" + (_id + 1), x, y - 3);
			AddLabel("1", x - 45, y + 22, 0xffffff, 1, 0x000000);
			name = Localization.getInstance().getString("EventBirthDay_Equipment");
			name += getNameById(_id);
			AddLabel(name, x - 55, y + 40, 0x0000ff, 1, 0xffffff);
		}
		
		private function drawSlot():void 
		{
			var x:int = 60;
			var y:int = 90;
			for (var i:int = 1; i <= _numSlot - 2; i++)
			{
				AddImage("", "Event83_ImgSlotGift", x, y);
				//vẽ gift
				if (i % 4 == 0)//xuống dòng
				{
					y += 90;
					x = 60;
				}
				else
					x += 85;
			}
			AddImage("", "Event83_ImgSlotGift", x + 20, y);
			x += 85;
			AddImage("", "Event83_ImgSlotGift", x + 40, y);
		}
		
		private function drawTitle():void 
		{
			var name:String = Localization.getInstance().getString("EventBirthDayGift" + _id);
			AddLabel(name + ": Bạn có thể nhận được", 140, 25, 0x315068);
		}
		
		private function getNameById(id:int):String
		{
			switch(id + 1)
			{
				case 2:
					return " đặc biệt";
				case 3:
					return " quý";
				case 4:
					return " thần";
			}
			return "";
		}
	}

}




























