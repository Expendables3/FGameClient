package GUI.EventLuckyMachine 
{
	import com.adobe.serialization.json.JSON;
	import Data.ConfigJSON;
	import Data.Localization;
	/**
	 * cung cấp việc khởi tạo dữ liệu cho GUIDigritWheel
	 * @author HiepNM2
	 */
	public class DigritWheelData 
	{
		private static const SlotFirst_X:int = 188;		//tọa độ x của điểm đặt ô đầu tiên
		private static const SlotFirst_Y:int = 89;		//tọa độ y của điểm đặt ô đầu tiên
		private static const SlotNumber:int = 24;		//số lượng ô
		private static const Slot_A:int = 52;			//độ rộng 1 ô
		private static const DELTA:int = 4;				//khoảng cách giữa 2 ô kề nhau
		
		private static var dataFirst:Array = new Array();		//dữ liệu cho lần quay đầu tiên
		private static const SEPARATE:String = "_";
		private static const LEVEL_0:String = "0";
		private static const LEVEL_1:String = "1";
		private static const LEVEL_2:String = "2";
		private static const LEVEL_3:String = "3";
		private static const LEVEL_4:String = "4";
		private static const LEVEL_5:String = "5";
		private static const LEVEL_6:String = "6";
		public function DigritWheelData() 
		{
		};
		public static function initCorForDigritWheel(CorList:Array):void
		{
			var i:int, x:int, y:int;
			var a:int = SlotNumber / 4 + 1;
			x = SlotFirst_X - (Slot_A + DELTA);
			y = SlotFirst_Y;
			var obj:Object;
			
			//fix cứng vì là hình chữ nhật 8x6
			
			//CorList = new Array();
			//top edge
			for (i = 0; i < 8; i++)
			{
				x += Slot_A + DELTA;
				obj = new Object();
				obj.x = x;
				obj.y = y;
				CorList.push(obj);
			};
			//right edge
			for (i = 8; i < 13; i++)
			{
				y += Slot_A + DELTA;
				obj = new Object();
				obj.x = x;
				obj.y = y;
				CorList.push(obj);
			};
			//bottom edge
			for (i = 13; i < 20; i++)
			{
				x -= (Slot_A + DELTA);
				obj = new Object();
				obj.x = x;
				obj.y = y;
				CorList.push(obj);
			};
			//left edge
			for (i = 20; i < SlotNumber; i++)
			{
				y -= (Slot_A + DELTA);
				obj = new Object();
				obj.x = x;
				obj.y = y;
				CorList.push(obj);
			};
		};
		
		public static function initDataFailAll(floor:int, SlotList:Array):void
		{
			dataFirst = 
				[
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*0*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*1*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*2*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*3*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*4*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*5*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*6*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*7*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*8*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*9*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*10*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*11*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*12*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*13*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*14*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*15*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*16*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*17*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*18*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*19*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*20*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*21*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*22*/
					ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*23*/
				];
				
			var obj:Object;
			var i:int;
			var length:int = dataFirst.length;
			var typeGift:String;
			var levelSlot:int;
			var dt:Array;
			for (i = 0; i < length; i++)
			{
				dt = new Array();
				obj = new Object();
				dt = (dataFirst[i] as String).split(SEPARATE);
				typeGift = dt[0];
				levelSlot = dt[1];
				obj = initData(floor, typeGift, levelSlot);
				SlotList.push(obj);
			};
						
		}
		
		/*
		 * config cho lượt quay đầu tiên
		 */ 
		public static function initDataForDigritWheel(floor:int, SlotList:Array, state:int, type:String):void
		{
			if (state == 1)
			{
				dataFirst = 
				[
					ItemSlot.TYPE_ENERGYITEM + 		SEPARATE + 		LEVEL_1,			/*0*/
					ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_3,			/*1*/
					ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_1,			/*2*/
					ItemSlot.TYPE_MASK + 			SEPARATE + 		"21",				/*3*/
					ItemSlot.TYPE_WEAPON + 			SEPARATE + 		"22",				/*4*/
					ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_1,			/*5*/
					ItemSlot.TYPE_EXP + 			SEPARATE +		LEVEL_3,			/*6*/
					ItemSlot.TYPE_EXP + 			SEPARATE + 		LEVEL_1,			/*7*/
					ItemSlot.TYPE_MATERIAL + 		SEPARATE + 		LEVEL_1,			/*8*/
					ItemSlot.TYPE_ENERGYITEM + 		SEPARATE + 		LEVEL_2,			/*9*/
					ItemSlot.TYPE_ENERGYITEM + 		SEPARATE + 		LEVEL_1,			/*10*/
					ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_2,			/*11*/
					ItemSlot.TYPE_EXP + 			SEPARATE + 		LEVEL_1,			/*12*/
					ItemSlot.TYPE_MATERIAL + 		SEPARATE + 		LEVEL_3,			/*13*/
					ItemSlot.TYPE_MATERIAL + 		SEPARATE + 		LEVEL_1,			/*14*/
					ItemSlot.TYPE_ARMOR + 			SEPARATE + 		"23",				/*15*/
					ItemSlot.TYPE_HELMET + 			SEPARATE + 		"24",				/*16*/
					ItemSlot.TYPE_MATERIAL + 		SEPARATE + 		LEVEL_1,			/*17*/
					ItemSlot.TYPE_ENERGYITEM + 		SEPARATE + 		LEVEL_3,			/*18*/
					ItemSlot.TYPE_ENERGYITEM + 		SEPARATE + 		LEVEL_1,			/*19*/
					ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_1,			/*20*/
					ItemSlot.TYPE_EXP + 			SEPARATE + 		LEVEL_2,			/*21*/
					ItemSlot.TYPE_EXP + 			SEPARATE + 		LEVEL_1,			/*22*/
					ItemSlot.TYPE_MATERIAL + 		SEPARATE + 		LEVEL_2,			/*23*/
				];
				switch(floor)
				{
					case 2:
						dataFirst[3] = ItemSlot.TYPE_WEAPON + 			SEPARATE + 		"21";
						dataFirst[4] = ItemSlot.TYPE_NECKLACE + 		SEPARATE + 		"22";
						dataFirst[15] = ItemSlot.TYPE_ARMOR + 			SEPARATE + 		"23";
						dataFirst[16] = ItemSlot.TYPE_HELMET + 			SEPARATE + 		"24";
					break;
					case 10:
						dataFirst[3] = ItemSlot.TYPE_RING + 			SEPARATE + 		"21";
						dataFirst[4] = ItemSlot.TYPE_BRACELET + 		SEPARATE + 		"22";
						dataFirst[15] = ItemSlot.TYPE_BELT + 		SEPARATE + 		"23";
						dataFirst[16] = ItemSlot.TYPE_WEAPON + 			SEPARATE + 		"24";
					break;
					case 50:
						dataFirst[3] = ItemSlot.TYPE_ARMOR + 		SEPARATE + 		"21";
						dataFirst[4] = ItemSlot.TYPE_HELMET + 		SEPARATE + 		"22";
						dataFirst[15] = ItemSlot.TYPE_RING + 		SEPARATE + 		"23";
						dataFirst[16] = ItemSlot.TYPE_WEAPON + 		SEPARATE + 		"24";
					break;
				}
			}
			else
			{
				switch(type)
				{
					case ItemSlot.TYPE_MATERIAL:
					{
						dataFirst = 
						[
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*0*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*1*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*2*/
							ItemSlot.TYPE_MATERIAL +	SEPARATE +		 LEVEL_4,			/*3*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*4*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*5*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*6*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*7*/
							ItemSlot.TYPE_MATERIAL + 	SEPARATE + 		 LEVEL_1,			/*8*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*9*/
							ItemSlot.TYPE_MATERIAL +	SEPARATE +		 LEVEL_5,			/*10*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*11*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*12*/
							ItemSlot.TYPE_MATERIAL + 	SEPARATE + 		 LEVEL_3,			/*13*/
							ItemSlot.TYPE_MATERIAL + 	SEPARATE + 		 LEVEL_1,			/*14*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*15*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*16*/
							ItemSlot.TYPE_MATERIAL + 	SEPARATE + 		 LEVEL_1,			/*17*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*18*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*19*/
							ItemSlot.TYPE_MATERIAL +	SEPARATE +		 LEVEL_6,			/*20*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*21*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*22*/
							ItemSlot.TYPE_MATERIAL + 	SEPARATE + 		 LEVEL_2,			/*23*/
						];						
					};
					break;
					case ItemSlot.TYPE_EXP:
					{
						dataFirst = 
						[
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*0*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*1*/
							ItemSlot.TYPE_EXP + 	SEPARATE +		 LEVEL_4,			/*2*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*3*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*4*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*5*/
							ItemSlot.TYPE_EXP + 	SEPARATE +		 LEVEL_3,			/*6*/
							ItemSlot.TYPE_EXP + 	SEPARATE + 		 LEVEL_1,			/*7*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*8*/
							ItemSlot.TYPE_EXP + 	SEPARATE +		 LEVEL_5,			/*9*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*10*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*11*/
							ItemSlot.TYPE_EXP + 	SEPARATE + 		 LEVEL_1,			/*12*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*13*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*14*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*15*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*16*/
							ItemSlot.TYPE_EXP + 	SEPARATE +		 LEVEL_6,			/*17*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*18*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*19*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*20*/
							ItemSlot.TYPE_EXP + 	SEPARATE + 		 LEVEL_2,			/*21*/
							ItemSlot.TYPE_EXP + 	SEPARATE + 		 LEVEL_1,			/*22*/
							ItemSlot.TYPE_FAIL +	SEPARATE +		 LEVEL_0,			/*23*/
						];
					};
					break;
					case ItemSlot.TYPE_ENERGYITEM:
					{
						dataFirst =
						[
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_1,			/*0*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*1*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*2*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*3*/
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_4,			/*4*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*5*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*6*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*7*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*8*/
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_2,			/*9*/
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_1,			/*10*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*11*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*12*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*13*/
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_5,			/*14*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*15*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*16*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*17*/
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_3,			/*18*/
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_1,			/*19*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*20*/
							ItemSlot.TYPE_ENERGYITEM + 	SEPARATE + 		LEVEL_6,			/*21*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*22*/
							ItemSlot.TYPE_FAIL +		SEPARATE +		LEVEL_0,			/*23*/
						];
					};
					break;
					case ItemSlot.TYPE_RANKPOINTBOTTLE:
					{
						dataFirst = 
						[
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*0*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_3,			/*1*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_1,			/*2*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*3*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*4*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_1,			/*5*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*6*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_4,			/*7*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*8*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*9*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*10*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_2,			/*11*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*12*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*13*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*14*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_5,			/*15*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*16*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*17*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*18*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*19*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_1,			/*20*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*21*/
							ItemSlot.TYPE_RANKPOINTBOTTLE + SEPARATE + 		LEVEL_6,			/*22*/
							ItemSlot.TYPE_FAIL +			SEPARATE +		LEVEL_0,			/*23*/
						];
					};
					break;
				};
			};
			var obj:Object;
			var i:int;
			var length:int = dataFirst.length;
			var typeGift:String;
			var levelSlot:int;
			var dt:Array;
			for (i = 0; i < length; i++)
			{
				dt = new Array();
				obj = new Object();
				dt = (dataFirst[i] as String).split(SEPARATE);
				typeGift = dt[0];
				levelSlot = dt[1];
				obj = initData(floor, typeGift, levelSlot);
				SlotList.push(obj);
			};
		};
		
		private static function initData(floor:int, typeGift:String, levelSlot:int):Object
		{
			var obj:Object = new Object;
			var indexMask:int;
			switch(typeGift)
			{
				case ItemSlot.TYPE_FAIL:
				{
					obj = initFailSlot(floor, levelSlot);
				};
				break;
				case ItemSlot.TYPE_MATERIAL:
				{
					obj = initMaterial(floor, levelSlot);
				};
				break;
				case ItemSlot.TYPE_EXP:
				{
					obj = initEXP(floor, levelSlot);
				};
				break;
				case ItemSlot.TYPE_ENERGYITEM:
				{
					obj = initEnergyItem(floor, levelSlot);
				};
				break;
				case ItemSlot.TYPE_RANKPOINTBOTTLE:
				{
					obj = initRankPointBottle(floor, levelSlot);
				};
				break;
				case ItemSlot.TYPE_RING:
				case ItemSlot.TYPE_BELT:
				case ItemSlot.TYPE_BRACELET:
				case ItemSlot.TYPE_NECKLACE:
				case ItemSlot.TYPE_HELMET:
				case ItemSlot.TYPE_WEAPON:
				case ItemSlot.TYPE_ARMOR:
				case ItemSlot.TYPE_MASK:
				{
					indexMask = levelSlot;
					obj = initSpecialGift(floor, indexMask, typeGift);
				};
				break;
			};
			return obj;
		};
		private static function initFailSlot(floor:int, levelSlot:int = 1):Object
		{
			var obj:Object = new Object();
			obj["SlotName"] = "ImgSlotBlue";
			obj["levelSlot"] = levelSlot;
			obj["itemTypeDW"] = ItemSlot.TYPE_FAIL_DW;
			obj["itemType"] = ItemSlot.TYPE_FAIL;
			obj["ToolTipText"] = "Trượt";
			return obj;
		};
		private static function initRankPointBottle(floor:int, levelSlot:int = 1):Object
		{
			var obj:Object = new Object();
			obj["SlotName"] = "ImgSlotBlue";
			obj["levelSlot"] = levelSlot;
			obj["itemTypeDW"] = ItemSlot.TYPE_RANKPOINTBOTTLE_DW;
			obj["itemType"] = ItemSlot.TYPE_RANKPOINTBOTTLE;
			obj["ToolTipText"] = getTip(floor, "RankPointBottle", levelSlot);
			return obj;
		};
		private static function initEnergyItem(floor:int, levelSlot:int = 1):Object
		{
			var obj:Object = new Object();
			obj["SlotName"] = "ImgSlotBlue";
			obj["levelSlot"] = levelSlot;
			obj["itemTypeDW"] = ItemSlot.TYPE_ENERGYITEM_DW;
			obj["itemType"] = ItemSlot.TYPE_ENERGYITEM;
			obj["ToolTipText"] = getTip(floor, "EnergyItem", levelSlot);
			return obj;
		}
		private static function initMaterial(floor:int, levelSlot:int = 1):Object
		{
			var obj:Object = new Object();
			obj["SlotName"] = "ImgSlotBlue";
			obj["levelSlot"] = levelSlot;
			obj["itemTypeDW"] = ItemSlot.TYPE_MATERIAL_DW;
			obj["itemType"] = ItemSlot.TYPE_MATERIAL;
			//tooltip
			obj["ToolTipText"] = getTip(floor, "Material", levelSlot);
			return obj;
		};
		private static function initEXP(floor:int, levelSlot:int = 1):Object
		{
			var obj:Object = new Object();
			obj["SlotName"] = "ImgSlotBlue";
			obj["levelSlot"] = levelSlot;
			obj["itemTypeDW"] = ItemSlot.TYPE_EXP_DW;
			obj["itemType"] = ItemSlot.TYPE_EXP;
			//tooltip
			obj["ToolTipText"] = getTip(floor, "Exp", levelSlot);
			return obj;
		};
		private static function initSpecialGift(floor:int, indexGift:int = 21, typeGift:String=""):Object
		{
			var obj:Object = new Object();
			obj["SlotName"] = "ImgSlotOrange";
			obj["levelSlot"] = 1;
			obj["itemType"] = typeGift;
			switch(floor)
			{
				case 2:
					switch(typeGift)
					{
						case ItemSlot.TYPE_WEAPON:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_WEAPON_DW;
							obj["ToolTipText"] = "Rương Thần - Vũ Khí\nQuay trúng sẽ nhận ngẫu nhiên Vũ Khí anh hùng thần";
						};
						break;
						case ItemSlot.TYPE_NECKLACE:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_NECKLACE_DW;
							obj["ToolTipText"] = "Rương Thần - Vòng cổ\nQuay trúng sẽ nhận ngẫu nhiên Vòng Cổ anh hùng thần";
						};
						break;
						case ItemSlot.TYPE_ARMOR:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_ARMOR_DW;
							obj["ToolTipText"] = "Rương Thần - Áo Giáp\nQuay trúng sẽ nhận ngẫu nhiên Áo Giáp anh hùng thần";
						};
						break;
						case ItemSlot.TYPE_HELMET:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_HELMET_DW;
							obj["ToolTipText"] = "Rương Thần - Mũ Giáp\nQuay trúng sẽ nhận ngẫu nhiên Mũ Giáp anh hùng thần";
						};
						break;
						
					}
				break;
				case 10:
					switch(typeGift)
					{
						case ItemSlot.TYPE_RING:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_RING_DW;
							obj["ToolTipText"] = "Rương Thần - Nhẫn\nQuay trúng sẽ nhận ngẫu nhiên Nhẫn anh hùng thần";
						};
						break;
						case ItemSlot.TYPE_BRACELET:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_BRACELET_DW;
							obj["ToolTipText"] = "Rương Thần - Vòng tay\nQuay trúng sẽ nhận ngẫu nhiên Vòng Tay anh hùng thần";
						};
						break;
						case ItemSlot.TYPE_BELT:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_BELT_DW;
							obj["ToolTipText"] = "Rương Thần - Đai\nQuay trúng sẽ nhận ngẫu nhiên Đai Lưng anh hùng thần";
						};
						break;
						case ItemSlot.TYPE_WEAPON:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_WEAPON_VIP_DW;
							obj["ToolTipText"] = "Vũ Khí VIP\nQuay trúng sẽ nhận ngẫu nhiên Vũ Khí anh hùng vip";
						};
						break;
					}
				break;
				case 50:
					switch(typeGift)
					{
						case ItemSlot.TYPE_ARMOR:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_WEAPON_DW;
							obj["ToolTipText"] = "Hoàng Kim Bảo Rương - Áo Giáp\nQuay trúng sẽ nhận ngẫu nhiên Áo Giáp lưỡng cực thần";
						};
						break;
						case ItemSlot.TYPE_HELMET:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_WEAPON_DW;
							obj["ToolTipText"] = "Hoàng Kim Bảo Rương - Mũ Giáp\nQuay trúng sẽ nhận ngẫu nhiên Mũ Giáp lưỡng cực thần";
						};
						break;
						case ItemSlot.TYPE_RING:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_WEAPON_DW;
							obj["ToolTipText"] = "Hoàng Kim Bảo Rương - Nhẫn\nQuay trúng sẽ nhận ngẫu nhiên Nhẫn lưỡng cực thần";
						};
						break;
						case ItemSlot.TYPE_WEAPON:
						{
							obj["itemTypeDW"] = ItemSlot.TYPE_WEAPON_DW;
							obj["ToolTipText"] = "Hoàng Kim Bảo Rương - Vũ Khí\nQuay trúng sẽ nhận ngẫu nhiên Vũ Khí lưỡng cực thần";
						};
						break;
					}
				break;
			}
			return obj;
		}
		public static function getNameGift(type:String):String
		{
			var st:String;
			switch(type)
			{
				case ItemSlot.TYPE_ENERGYITEM:
				{
					st = "Năng lượng";
				};
				break;
				case ItemSlot.TYPE_MATERIAL:
				{
					st = "Tiền";
				};
				break;
				case ItemSlot.TYPE_MASK:
				{
					st = "Mặt nạ";
				};
				break;
				case ItemSlot.TYPE_RANKPOINTBOTTLE:
				{
					st = "Bình chiến công";
				};
				break;
				case ItemSlot.TYPE_EXP:
				{
					st = "Kinh nghiệm";
				};
				break;
			};
			return st;
		};
		public static function getNameItem(type:String, id:int):String
		{
			var st:String;
			switch(type)
			{
				case ItemSlot.TYPE_MATERIAL:
				case ItemSlot.TYPE_RANKPOINTBOTTLE:
				case ItemSlot.TYPE_ENERGYITEM:
				{
					st = Localization.getInstance().getString(type + id);
					st = (st == "1 giọt năng lượng")?"giọt năng lượng":st;
				};
				break;
				case "Exp":
				{
					st = "điểm kinh nghiệm";
				};
				break;
				case ItemSlot.TYPE_MASK:
				{
					st = "Mặt nạ";
				};
				break;
				case ItemSlot.TYPE_ARMOR:
				{
					st="Hoàng Kim Bảo Rương - Áo Giáp"
				};
				break;
				case ItemSlot.TYPE_WEAPON:
				{
					st = "Hoàng Kim Bảo Rương - Vũ Khí";
				};
				break;
				case ItemSlot.TYPE_HELMET:
				{
					st = "Hoàng Kim Bảo Rương - Mũ Giáp";
				};
				break;
			};
			return st;
		};
		/**
		 * Định dạng số theo chuẩn
		 * @param	num: số cần chuẩn hóa
		 * @return	Số sau khi đã chuẩn hóa
		 */
		public static function StandardNumber(num:int):String
		{
			var i:int;			
			var absNum:int = Math.abs(num);
			var st:String = absNum.toString();
			var result:String = "";
			if (absNum >= 1000000)
			{
				var rs:int = (int)(absNum / 1000000);
				st = rs.toString() + " triệu";
			}
			else if (absNum >= 1000)
			{
				st = st.split("").reverse().join("");
				for (i = 0; i <= st.length; i += 3)
				{					
					result = result.concat(st.substr(i, 3));
					if (st.substr(i+3).length > 0)
					{
						result = result.concat(",");
					}
				}
				st = result.split("").reverse().join("");
			}
			
			if (num < 0)
			{
				st = "-" + st;
			}
			return st;
		}
		public static function getTip(floor:int, type:String, levelGift:int):String
		{
			//tooltip
			var sType:String;
			var objVar:Object = { ItemId:0, Num:0, TicketNum:0 };
			ConfigJSON.getInstance().GetGiftContent(floor, type, levelGift, objVar);
			var strTooltip:String = "@num " + getNameItem(type, objVar["ItemId"]);
			var num:int = objVar["Num"];
			var stNum:String = StandardNumber(num);
			strTooltip = strTooltip.replace("@num", stNum);
			if (type == ItemSlot.TYPE_FAIL)
			{
				strTooltip = "Trượt";
			}
			return strTooltip;
		}
		public static function Randomize(min:int, max:int):int
		{
			return min + (int)((max - min + 1) * Math.random());
		}
	};
};