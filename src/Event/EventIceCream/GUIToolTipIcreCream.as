package Event.EventIceCream 
{
	import com.greensock.plugins.BevelFilterPlugin;
	import Data.ConfigJSON;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIToolTipIcreCream extends BaseGUI 
	{
		public const IMG_BG_GUI:String = "ImgBgGui";
		private var arrGift:Array = [];
		private var idIceCream:int;
		public function GUIToolTipIcreCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIToolTipIcreCream";
		}
		/**
		 * 
		 * @param	id	: Id cua cay kem ma minh muon xem thong tin
		 */
		public function Init(id:int):void 
		{
			idIceCream = id;
			GetArrGift(id);
			Show();
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			LoadRes("EventIceCream_ImgBgGUITooltip");
			var mousePos:Point = GameInput.getInstance().MousePos;
			var w:Number = img.width, h:Number = img.height;
			var pos:Point = new Point();
			if (mousePos.x > Constant.STAGE_WIDTH / 2)
			{
				if (mousePos.y > Constant.STAGE_HEIGHT / 2)
				{
					pos = new Point(mousePos.x - w - 5, Math.max(mousePos.y - h, 0));
				}
				else
				{
					pos = new Point(mousePos.x - w - 5, Math.min(mousePos.y, Constant.STAGE_HEIGHT - h));
				}
			}
			else
			{
				if (mousePos.y > Constant.STAGE_HEIGHT / 2)
				{
					pos = new Point(mousePos.x + 5, Math.max(mousePos.y - h, 0));
				}
				else
				{
					pos = new Point(mousePos.x + 5, Math.min(mousePos.y, Constant.STAGE_HEIGHT - h));
				}
			}
			SetPos(pos.x, pos.y);
			AddImage(IMG_BG_GUI, "EventIceCream_ImgContentGUITooltip" + idIceCream, 25, 22, true, ALIGN_LEFT_TOP);
			DrawGift();
		}
		
		public function DrawGift():void 
		{
			var txtFormat:TextFormat;
			var px:Number, py:Number, startX:Number = 30.2, startY:Number = 129.5, deltaX:Number = 79, deltaY:Number = 84, dx:Number, dy:Number;
			for (var i:int = 0; i < arrGift.length; i++) 
			{
				var item:Object = arrGift[i];
				var name:String = GetName(item);
				var labelGift:String = GetLabelGift(item);
				dx = (i % 4) * deltaX;
				dy = Math.floor(i / 4) * deltaY;
				px = startX + dx;
				py = startY + dy;
				if (idIceCream == 2)
				{
					py = py + 15;
				}
				var imageGift:Image = AddImage("", name, px, py, true, ALIGN_LEFT_TOP);
				imageGift.FitRect(55, 55, new Point(px + 15, py + 5));
				if (labelGift != "")
				{
					txtFormat = new TextFormat("Arial", 11, 0xffffff, true);
					AddLabel(labelGift, px - 8, py + 80, 0x003366, 1, 0x000000).setTextFormat(txtFormat);
				}
				
				var numGift:String = Ultility.StandardNumber(int(item.Num));
				if (item.Rate < 100)
				{
					numGift = "0~" + Ultility.StandardNumber(int(item.Num));
				}
				txtFormat = new TextFormat("Arial", 14, 0xffffff, true);
				AddLabel(numGift, px - 5, py + 60, 0xFFFF00, 1, 0x000000).setTextFormat(txtFormat);
			}
			var objConfig:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var obj:Object = objConfig[String(idIceCream)];
			var posx:int;
			var posy:int;
			switch (idIceCream) 
			{
				case 3:
					posx = 210;
					posy = 57;
				break;
				case 2:
					posx = 210;
					posy = 67;
				break;
				case 1:
					posx = 210;
					posy = 57;
				break;
			}
			// Add thời gian thành phẩm
			txtFormat = new TextFormat("Arial", 15, 0xCC0000, true);
			AddLabel(String(int(obj.Time) / 60), posx, posy, 0x003366).setTextFormat(txtFormat);
			// Add số lượng có thể đạt được
			AddLabel("≤ " + obj.MaxIceCream, posx - 70, posy + 20, 0x003366).setTextFormat(txtFormat);
		}
		
		public function GetLabelGift(item:Object):String
		{
			if (item.ItemType.search("EventIceCream_Treasure") < 0 && (item.ItemType != "Material" || int(item.ItemId) != 11))	return "";
			if (item.ItemType.search("EventIceCream_Treasure") < 0)	
				return "Ngư thạch 11";
			var str:String = "";
			var str2:String = "";
			switch (String(item.ItemType.split("_")[2])) 
			{
				case "All":
					str = "Đồ ";
				break;
				case "Jewel":
					str = "Trang sức\n";
				break;
				case "Equipment":
					str = "Trang bị\n";
				break;
			}
			
			switch (int(item.Rank) )
			{
				case 1:
					str2 = "Lưỡng Cực\n";
				break;
				case 2:
					str2 = "Anh Hùng\n";
				break;
				case 3:
					str2 = "Vô Song\n";
				break;
				case 4:
					str2 = "Cấp 4";
				break;
			}
			str = str + str2;
			
			switch (int(item.Color)) 
			{
				case 1:
					str2 = "Thường";
				break;
				case 2:
					str2 = "Hiếm";
				break;
				case 3:
					str2 = "Quý";
				break;
				case 4:
					str2 = "Thần";
				break;
			}
			str = str + str2;
			
			return str;
		}
		
		public function GetName(obj:Object):String
		{
			var str:String = "";
			if (obj.ItemType != "Gem" && String(obj.ItemType).search("EventIceCream") < 0)
			{
				if(obj.ItemId)
				{
					str = obj.ItemType + obj.ItemId;
				}
				else
				{
					str = obj.ItemType;
				}
			}
			else if(obj.ItemType == "Gem")
			{
				str = obj.ItemType + obj.ItemId;
			}
			else 
			{
				str = obj.ItemType.split("_")[0] + "_" + obj.ItemType.split("_")[1] + "_" + obj.Color + "_" + obj.Rank;
			}
			return str;
		}
		
		public function GetArrGift(id:int):void 
		{
			var objConfig:Object = ConfigJSON.getInstance().GetItemList("IceCreamItem");
			var obj:Object = objConfig[String(id)];
			arrGift.splice(0, arrGift.length);
			for (var istr:String in obj) 
			{
				if (istr.search("Gift") >= 0)
				{
					var obj1:Object = obj[istr];
					for (var jstr:String in obj1) 
					{
						var obj2:Object = obj1[jstr];
						var str:String = obj2.ItemType;
						if (str.search("Chest") >= 0)	
						{
							obj2.ItemType = "EventIceCream_Treasure_" + str.split("Chest")[0];
						}
						arrGift.push(obj2);
					}
				}
			}
			FilterGift();
		}
		
		public function FilterGift():void 
		{
			var count:int = 0;
			var arrTemp:Array = [];
			for (var i:int = 0; i < arrGift.length - count; i++) 
			{
				if (arrGift[i].ItemType.search("EventIceCream_Treasure_") >= 0)
				{
					arrGift = ReNewArr(arrGift, i);
					i--;
					count ++;
				}
			}
			
			for (var j:int = 0; j < arrGift.length; j++) 
			{
				if (arrGift[j].ItemType.search("EventIceCream_Treasure_") >= 0)
				{
					for (var k:int = j; k < arrGift.length; k++) 
					{
						arrTemp.push(arrGift[k]);
					}
					break;
				}
			}
			
			arrGift.splice(arrGift.length - arrTemp.length, arrTemp.length);
			
			arrTemp = SortArrObj(arrTemp);
			
			for (var l:int = 0; l < arrTemp.length; l++) 
			{
				arrGift.push(arrTemp[l]);
			}
		}
		public function ReNewArr(arr:Array, index:int):Array 
		{
			var arrNew:Array = [];
			if (index + 1 >= arr.length)	return arr;
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (i < index)
				{
					arrNew.push(arr[i]);
				}
				else if(i < arr.length - 1)
				{
					arrNew.push(arr[i + 1]);
				}
				else
				{
					arrNew.push(arr[index]);
				}
			}
			
			return arrNew;
		}
		
		public function SortArrObj(arr:Array):Array
		{
			for (var i:int = 0; i < arr.length; i++) 
			{
				var obj1:Object = arr[i];
				for (var j:int = i; j < arr.length; j++) 
				{
					var obj2:Object = arr[j];
					if (int(obj1.Rank) > int(obj2.Rank))
					{
						arr = Swap(arr, i, j);
					}
				}
			}
			return arr;
		}
		
		public function Swap(arr:Array, index1:int, index2:int):Array
		{
			var arrNew:Array = [];
			if (index1 == index2)	return arr;
			for (var i:int = 0; i < arr.length; i++) 
			{
				if ( i == index1 || i == index2)
				{
					if (i == index1) 
					{
						arrNew.push(arr[index2]);
					}
					else
					{
						arrNew.push(arr[index1]);
					}
				}
				else
				{
					arrNew.push(arr[i]);
				}
			}
			return arrNew;
		}
	}

}