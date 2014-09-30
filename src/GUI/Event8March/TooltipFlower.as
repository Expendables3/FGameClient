package GUI.Event8March 
{
	import Data.Localization;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	
	/**
	 * gui tooltip cho cái cây hoa trong event
	 * quà + thời gian + progessbar
	 * @author HiepNM2
	 */
	public class TooltipFlower extends BaseGUI 
	{
		private var _parent:GUIChangeFlower;
		private var _id:int;
		private var _gift:Object;
		private var _numSlot:int;
		private var arrGift:Array = [];
		private var listItemGift:Array = [];
		private var tipY:Object = new Object();
		private var hasSeal:Boolean = false;
		public function TooltipFlower(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "TooltipFlower";
			tipY[1] = 60;
			tipY[2] = 160;
			tipY[3] = 300;
		}
		
		override public function InitGUI():void 
		{
			LoadRes("Event83_GUITooltip");
			drawTitle();
			//drawSlot();
			drawGift();
			SetPos(250, tipY[_id]);
		}
		
		private function drawTitle():void
		{
			var name:String = Localization.getInstance().getString("Event_8_3_Gift" + _id);
			AddLabel(name + ": Bạn có thể nhận được\n   một trong những phần quà sau", 140, 25, 0x315068);
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
		
		private function drawGift():void
		{
			listItemGift.splice(0, listItemGift.length);
			var imName:String;
			var x:int = 60 - 36;
			var y:int = 90 - 32;
			var image:Image;
			var num:int;
			var w:int, h:int, dx:int, dy:int;
			var abItemGift:AbstractItemGift;
			var dSlot:int = hasSeal?3:2;
			for (var i:int = 0; i < _numSlot - dSlot; i++)
			{
				var giftN:GiftNormal = arrGift[i] as GiftNormal;
				abItemGift = new ItemNormalGift(this.img, "KhungFriend", x, y);
				abItemGift.initData(giftN, "Event83_ImgSlotGift", 75, 78, true);
				abItemGift.drawGift();
				listItemGift.push(abItemGift);
				if (((i+1) % 4) == 0)
				{
					y += 90;
					x = 60;
				}
				else
					x+=85
			}
			if(!hasSeal)
				x += 20;
			
			var giftS:GiftSpecial = arrGift[_numSlot - dSlot] as GiftSpecial;
			abItemGift = new ItemSpecialGift(this.img, "KhungFriend", x, y);
			abItemGift.initData(giftS, "", 0, 0, false);
			abItemGift.drawGift();
			listItemGift.push(abItemGift);
			var name:String = Localization.getInstance().getString("Event_8_3_Jewelry" + _id);
			name += getNameById(giftS.Color);
			//var xx:int = _id == 1? -2:15;
			var xx:int = 15;
			AddLabel(name, x - xx, y + 80, 0x0000ff, 1, 0xffffff);
			//AddLabel(name, x + 2, y + 80, 0x0000ff, 1, 0xffffff);
			x += 105;
			giftS = arrGift[_numSlot - dSlot + 1] as GiftSpecial;
			abItemGift = new ItemSpecialGift(this.img, "KhungFriend", x, y);
			abItemGift.initData(giftS, "", 0, 0, false);
			abItemGift.drawGift();
			listItemGift.push(abItemGift);
			//AddImage("", "Event_8_3_Eff_" + (_id + 1), x + 1, y + 1);
			//AddImage("", "Event_8_3_Jewelry" + (_id + 1), x, y - 3);
			//AddLabel("1", x - 45, y + 22, 0xffffff, 1, 0x000000);
			
			
			//x += 105;
			//AddImage("", "Event_8_3_Eff_" + (_id + 1), x + 1, y + 1);
			//AddImage("", "Event_8_3_VuKhi" + (_id + 1), x, y - 3);
			//AddLabel("1", x - 45, y + 22, 0xffffff, 1, 0x000000);
			name = Localization.getInstance().getString("Event_8_3_Equipment" + _id);
			name += getNameById(giftS.Color);
			AddLabel(name, x - xx, y + 80, 0x0000ff, 1, 0xffffff);
			//AddLabel(name, x + 2, y + 80, 0x0000ff, 1, 0xffffff);
			if (hasSeal)
			{
				x += 105;
				giftS = arrGift[_numSlot - dSlot + 2] as GiftSpecial;
				abItemGift = new ItemSpecialGift(this.img, "KhungFriend", x, y);
				abItemGift.initData(giftS, "", 0, 0, false);
				abItemGift.drawGift();
				abItemGift.RemoveImage(abItemGift.GetImage("idLock"));
				abItemGift.AddImage("idRank", "ImgLaMa" + giftS.Rank, 14, 63);
				listItemGift.push(abItemGift);
				name = Localization.getInstance().getString(giftS.ItemType + giftS.Rank);
				//name = "Ngọc ấn\n";
				//name += "Cấp " + giftS.Rank;
				//name += getNameById(giftS.Color);
				AddLabel(name, x - xx, y + 80, 0x0000ff, 1, 0xffffff);
			}
			
		}
		
		public function init(gift:Object,idGift:int):void
		{
			arrGift.splice(0, arrGift.length);
			_gift = gift;
			var abGift:AbstractGift;
			var count:int = 0;
			var hasJewel:Boolean = false;
			var hasEquip:Boolean = false;
			for (var i:String in gift)
			{
				if (getTypeName(gift[i]["ItemType"]) == "Event_8_3_Jewelry")
				{
					if (!hasJewel)
					{
						abGift = new GiftSpecial();
						abGift.setInfo(gift[i]);
						(abGift as GiftSpecial).ItemType = "JewelChest";
						arrGift.push(abGift);
						hasJewel = true;
					}
					continue;
				}
				else if (getTypeName(gift[i]["ItemType"]) == "Event_8_3_VuKhi")
				{
					if (!hasEquip) 
					{
						abGift = new GiftSpecial();
						abGift.setInfo(gift[i]);
						(abGift as GiftSpecial).ItemType = "EquipmentChest";
						arrGift.push(abGift);
						hasEquip = true;
					}
					continue;
				}
				else if (getTypeName(gift[i]["ItemType"]) == "Event_8_3_Seal")
				{
					if (!hasSeal)
					{
						abGift = new GiftSpecial();
						abGift.setInfo(gift[i]);
						arrGift.push(abGift);
						hasSeal = true;
					}
					continue;
				}
				abGift = new GiftNormal();
				abGift.setInfo(gift[i]);
				arrGift.push(abGift);
				count++;
			}
			if (hasSeal)
			{
				_numSlot = count + 3;
			}
			else 
			{
				_numSlot = count + 2;
			}
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
				case "Seal":
					return "Event_8_3_Seal";
				default:
					return itemType;
			}
		}
		
		private function getNameById(id:int):String
		{
			switch(id)
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
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < listItemGift.length; i++)
			{
				var gift:AbstractItemGift = listItemGift[i];
				gift.Destructor();
			}
			listItemGift.splice(0, listItemGift.length);
			super.ClearComponent();
		}
		
	}
}