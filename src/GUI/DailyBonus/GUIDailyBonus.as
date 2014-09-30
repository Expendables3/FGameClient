package GUI.DailyBonus 
{
	import adobe.utils.CustomActions;
	import adobe.utils.ProductManager;
	import com.adobe.utils.IntUtil;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.errors.ScriptTimeoutError;
	import flash.text.TextFormat;
	import GUI.component.TooltipFormat;
	import com.greensock.TweenMax;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Effect.ImgEffectBlink;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.MyUserInfo;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendGetDailyBonus;
	import NetworkPacket.PacketSend.SendReChooseDailyBonus;
	import Sound.SoundMgr;
	import flash.filters.*;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIDailyBonus extends BaseGUI
	{
		public var sob:SharedObject;
		
		public var ChosenButtonArray: Array;
		public var UnChosenButtonArray: Array;
		public var WilLChoseButtonArray: Array;
		private var GiftWillGet:Object;
		private var isChoose:int = -1;
		public var curDay:Point;
		public var curDayView:int;
		public var GiftList:Array;
		private var giftPos:int;
		public var numOpen:int;
		private var saveData:Object;
		private var glow:GlowFilter;
		private var costText:TextField;
		private var rechooseCost:Object = new Object();
		private var cfg:Object;
		private var completeIcon:Image;
		private var isVeryRareGift:Boolean = false;
		public var isSendReChoose:Boolean;
		private var curDayLevel:int;
		private var isCanChangeDay:Boolean;
		
		private const GUI_BUTTON_SLOT_1:String 	= "ButtonSlot_1";
		private const GUI_BUTTON_SLOT_2:String 	= "ButtonSlot_2";
		private const GUI_BUTTON_SLOT_3:String 	= "ButtonSlot_3";
		private const GUI_BUTTON_SLOT_4:String 	= "ButtonSlot_4";
		private const GUI_BUTTON_SLOT_5:String 	= "ButtonSlot_5";
		private const GUI_BUTTON_SLOT_6:String 	= "ButtonSlot_6";
		
		public static const AURA_COLOR_EXP:int = 0x66ffff;
		public static const AURA_COLOR_OTHER:int = 0xff00ff;
		public static const AURA_COLOR_MIX:int = 0x00ff00;
		public static const AURA_COLOR_GOLD:int = 0xffff00;
		
		public static const OPTION_MONEY:String = "Money";
		public static const OPTION_MIX_RARE:String = "MixFish";
		public static const OPTION_MIX_SPECIAL:String = "MixSpecial";
		public static const OPTION_EXP:String = "Exp";
		public static const OPTION_TIME:String = "Time";
		
		private const GUI_BUTTON_DAY_1:String	= "Day_1";
		private const GUI_BUTTON_DAY_2:String	= "Day_2";
		private const GUI_BUTTON_DAY_3:String	= "Day_3";
		private const GUI_BUTTON_DAY_4:String	= "Day_4";
		private const GUI_BUTTON_DAY_5:String	= "Day_5";
		
		private const OPEN:String 	= "Open";
		private const CLOSE:String 	= "Close";	
		
		private const BUTTON_CLOSE:String = "ButtonClose";
		private const BUTTON_RECHOOSE:String = "ButtonRechoose";
		private const BUTTON_GET_GIFT:String = "ButtonGetGift";

		private static const SLOT_PER_ROW:int = 3;
		private static const MAX_SLOT:int = 6;
		
		private static const NumOpenMax:int = 4;
		
		private var day:int;		// Load dong Gui fix
		private var level:int;		// load dong gui fix
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public function GUIDailyBonus(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			x = 240;
			y = 800;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIDailyBonus";
			sob = SharedObject.getLocal("DailyBonus");
		}

		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				if (day == 0)
				{
					// Hay là ngày hiện thời
					day = curDay.y;
				}
				
				if (level == 0)
				{
					//day = curDay.x;
					var obj:Object = GiftList[day - 1];
					if (obj["Level"])
						level = obj["Level"];				
				}
				curDayLevel = level;
				curDayView = day;
		
				// Lấy dữ liệu từ client
				var myInfo:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
				var uId:String = myInfo.Id.toString();
				var timeStamp:Number = GameLogic.getInstance().CurServerTime;
				var date:Date = new Date(timeStamp * 1000);
				//var date:Date = new Date();

				// Nếu chưa có dữ liệu user này thì tạo luôn
				if (!sob.data[uId])
					sob.data[uId] = new Object();
				
				// Nếu như dữ liệu 1 ngày nào đó chưa có thì sẽ khởi tạo, lấy ngày khởi tạo thông tin là ngày hôm nay
				for (var index:int = 1; index <= day; index++)
					if (!sob.data[uId][String(index)])
					{
						sob.data[uId][String(index)] = new Object();
						sob.data[uId][String(index)]["Date"] = date.date;
						sob.data[uId][String(index)]["Month"] = date.month;
					}
				saveData = sob.data[uId][String(day)];
					
				// Nếu dữ liệu cũ (so sánh với ngày hiện tại) thì khởi tạo lại toàn bộ dữ liệu user
				if ((sob.data[uId][String(curDay.y)]["Date"] != date.date) || (sob.data[uId][String(curDay.y)]["Month"] != date.month))
				{
					sob.clear();
					saveData = new Object();
					sob.data[uId] = new Object();
					sob.data[uId][String(day)] = saveData;
					saveData["Date"] = date.date;
					saveData["Month"] = date.month;
				}
				
				GameLogic.getInstance().BackToIdleGameState();
				
				isVeryRareGift = false;
				isSendReChoose = false;
				isChoose = -1;
				rechooseCost = new Object();
				
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				SetPos(65, 70);
				
				InitData(level, day);
				refreshComponent();
			}
			LoadRes("GuiDailyBonus_Theme");
		}
		
		/**
		 * Khởi tạo thông số của dailyBonus
		 * @param	level	: level của user
		 * @param	day		: ngày combo
		 */
		public function Init(level:int = 0, day:int = 0):void
		{
			this.level = level;
			this.day = day;
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		/**
		 * Thiết lập dữ liệu
		 */
		private function InitData(lv:int, day:int):void
		{
			isCanChangeDay = true;
			isVeryRareGift = false;
			curDayView = day;
			
			// Khởi tạo mảng phần thưởng
			ChosenButtonArray = [];
			UnChosenButtonArray = [];
			WilLChoseButtonArray = [];
			//isChoose = -1;

			cfg = ConfigJSON.getInstance().GetDailyBonus(lv, day);
			rechooseCost["1"] = cfg["FirstTime"];
			rechooseCost["2"] = cfg["SecondTime"];
			rechooseCost["3"] = cfg["ThirdTime"];
			
			// Nếu như có quà thì show hết ra
			if (GiftList[day - 1]["Gift"])
			{
				initArrays(cfg, day, lv);
				
				//Lấy dữ liệu Position từ client
				if (saveData["1"])
				{
					// Hiển thị cả quà đã mở nhưng chưa nhận
					numOpen = 0;
					var j:int;
					for (j = 1; j < 4; j++)
					{
						if (saveData[String(j)])
							numOpen++;
						else	break;
					}
					
					if (numOpen > ChosenButtonArray.length)
					{
						// Chuyển vị trí
						var temp:int;
						
						isChoose = UnChosenButtonArray[giftPos]["Pos"];
						ChosenButtonArray.push(UnChosenButtonArray[giftPos]);
						UnChosenButtonArray.splice(giftPos, 1);
					}
					
					// Lấy dữ liệu ra nếu có
					for (var i:int = 0; i < ChosenButtonArray.length; i++)
					{
						for (var k:int = i + 1; k < ChosenButtonArray.length; k++)
						{
							if (ChosenButtonArray[k]["Pos"] == saveData[String(i + 1)])
							{
								ChosenButtonArray[k]["Pos"] = ChosenButtonArray[i]["Pos"];
								break;
							}
						}
						
						for (j = 0; j < UnChosenButtonArray.length; j ++)
						{
							if (UnChosenButtonArray[j]["Pos"] == saveData[String(i + 1)])
							{
								UnChosenButtonArray[j]["Pos"] = ChosenButtonArray[i]["Pos"];
								break;
							}
						}
						ChosenButtonArray[i]["Pos"] = saveData[String(i + 1)];
					}
					
					if (numOpen >= GiftList[day - 1]["Gift"].length) //ChosenButtonArray.length)
					{
						isChoose = ChosenButtonArray[ChosenButtonArray.length - 1]["Pos"];
					}
				}
				else
				{
					swapGift(true);
					for (i = 0; i < ChosenButtonArray.length; i++)
					{
						saveData[String(i+1)] = ChosenButtonArray[i]["Pos"];
					}
					
					var myInfo:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
					var uId:String = String(myInfo.Id);
					
					sob.data[uId][String(day)] = saveData;
				}

			swapGift();
			}
		}
		
		private function initArrays(cfg:Object, day:int, lv:int):void
		{			
			// Add them thong tin vao cfg ItemId
			for (var c:int = 1; c <= 6; c++)
			{
				if (!("ItemId" in cfg[String(c)]) && (day == 5) && (cfg[String(c)]["ItemType"] != "Swat") && cfg[String(c)]["ItemType"] != "Ironman")
					cfg[String(c)]["ItemId"] = "";
			}

			var i:int; 			// chỉ để đếm
			numOpen = GiftList[day - 1]["Gift"].length - 1;
			
			for (i = 0; i < numOpen; i++)
			{
				var object:Object = new Object();
				object["Gift"] = GiftList[day - 1]["Gift"][i];
				ChosenButtonArray.push(object);
			}
			
			WilLChoseButtonArray.push(GiftList[day - 1]["Gift"][GiftList[day - 1]["Gift"].length - 1]);


			var chosenList: Array = [];
			var bodem:int = 0;
			
			for (i = 0; i < ChosenButtonArray.length; i++)
			{
				var pos:int = ChosenButtonArray[i]["Gift"]["BonusId"];
				ChosenButtonArray[i]["Pos"] = pos;
				chosenList.push(pos);
				if ((pos >=4) && (pos <=5))
				{
					ChosenButtonArray[i]["Type"] = 1;
				}
				else if (pos == 6)
				{
					ChosenButtonArray[i]["Type"] = 2;
				}
				else
				{
					ChosenButtonArray[i]["Type"] = 0;
				}
			}				
			
			for (i = 0; i < WilLChoseButtonArray.length; i++)
			{
				WilLChoseButtonArray[i]["Pos"] = WilLChoseButtonArray[i]["BonusId"];
				giftPos = WilLChoseButtonArray[i]["Pos"];
			}
			
			 //Kiểm tra 1 gift đã đc chọn hay chưa. Nếu chưa dc chọn thì cho nút đó vào mảng
			for (var k:int = 1; k <= 6; k ++)
			{
				var iChose:Boolean = false;
				var Pos:int;
				for (var m:int = 0; m < 6; m++)
				{
					if (k == chosenList[m])
					{
						iChose = true;
						Pos = m;
						break;
					}
				}
				if (iChose)	continue;
				var objectTemp:Object = new Object();
				//objectTemp["Gift"] = cfg[String(k)];
				
				 //Lấy vị trí quà sẽ mở ra trong mảng
				if (k == giftPos)
				{
					objectTemp["Gift"] = new Object();
					for (var str12:String in WilLChoseButtonArray[0])
					{
						//if ((str12 != "BonusId") && (str12 != "Pos") && (str12 != "Option") && (str12 != "OptionNum"))
						objectTemp["Gift"][str12] = WilLChoseButtonArray[0][str12];
					}
				}
				else
				{
					objectTemp["Gift"] = cfg[String(k)];
					objectTemp["Gift"]["BonusId"] = k;
				}
				
				var ind:int = UnChosenButtonArray.push(objectTemp);
				UnChosenButtonArray[ind - 1]["Pos"] = k;
				if (k == giftPos)
				{
					giftPos = ind - 1;
				}
				
				if ((k >= 4) && (k <= 5))
				{
					UnChosenButtonArray[ind - 1]["Type"] = 1;
				}
				else if (k == 6)
				{
					UnChosenButtonArray[ind - 1]["Type"] = 2;
				}
				else
				{
					UnChosenButtonArray[ind - 1]["Type"] = 0;
				}
				
				 //Lấy vị trí quà sẽ mở ra trong mảng
				//if (k == (giftPos+1))
				//{
					//giftPos = ind - 1;
				//}
			}
		}

		private function updateGiftPos(day:int):void
		{
			var i:int;
			for (i = 0; i < WilLChoseButtonArray.length; i++)
			{
				for (var index1:int = 0; index1 < UnChosenButtonArray.length; index1++)
				{
					if (WilLChoseButtonArray[i]["BonusId"] == UnChosenButtonArray[index1]["Gift"]["BonusId"])
					{
						giftPos = index1;
					}
				}
			}
		}
		
		public function refreshComponent():void
		{
			var i:int;
			//isChoose = -1;
			ClearComponent();
			var ButtonPos:Point = new Point();
			var ButtonGap:Point = new Point();
			
			ButtonPos.x = 257;
			ButtonPos.y = 132;
			ButtonGap.x = 117;
			ButtonGap.y = 112;
			
			// Add buttons:
			var SlotButton:ButtonEx;
			var Position:Point = new Point();
			var index:int;
			
			// Thông báo đã nhận quà nếu như đã nhận (of course!)
			if (!ChosenButtonArray[0] && !UnChosenButtonArray[0])
			{
				var imgDailyBonusDone:String = "GuiDailyBonus_ImgDailyBonusDone";
				AddImage("", imgDailyBonusDone, 230, 80, true, ALIGN_LEFT_TOP);
				AddImage("", "NPC_Mermaid_New", 370, 330, true, ALIGN_LEFT_TOP,false, function():void{this.SetScaleXY(0.85)}); 
			}
			// Mở rồi thì hiện gift shadow
			else
			{
				AddImage("", "GuiDailyBonus_ImgGiftShadow", 272, 199, true, ALIGN_LEFT_TOP);
			}
			
			// Tô vẽ các nút đã mở
  			for (i = 0; i < ChosenButtonArray.length; i++)
			{
				index = ChosenButtonArray[i]["Pos"] - 1;
				Position.x = ButtonPos.x + (int)(index % SLOT_PER_ROW) * ButtonGap.x;
				Position.y = ButtonPos.y + (int)(index / SLOT_PER_ROW) * ButtonGap.y;

				var imgBgName: String;
				switch (ChosenButtonArray[i]["Type"])
				{
					case 0:
						imgBgName = "GuiDailyBonus_ImgDailyBonusOpen";
						break;
					case 1:
						imgBgName = "GuiDailyBonus_ImgDailyBonusSpecial";
						break;
					case 2:
						imgBgName = "GuiDailyBonus_ImgDailyBonusSpecial1";
						break;
				}
				
				var ctn:Container = AddContainer("ChosenCtn" + i, imgBgName, Position.x, Position.y);
				DrawGift(ctn, ChosenButtonArray[i]["Gift"]);
				GlowingItem(ctn.img as MovieClip, true, true);
				ChosenButtonArray[i]["Button"] = ctn;
				if ((isChoose != -1) && (i == (ChosenButtonArray.length - 1)))
				{
					completeIcon = ctn.AddImage("", "IcComplete", 60, 50);
					completeIcon.SetScaleXY(1.3);
				}
				else
				{
					ctn.img.alpha = 0.5;
					ctn.AddImage("", "GuiDailyBonus_IcCancel", 50, 50);
				}
			}
			
			// Tô vẽ các nút chưa hề mở
			for (i = 0; i < UnChosenButtonArray.length; i++)
			{
				index = UnChosenButtonArray[i]["Pos"] - 1; 
				Position.x = ButtonPos.x + (int)(index % SLOT_PER_ROW) * ButtonGap.x;
				Position.y = ButtonPos.y + (int)(index / SLOT_PER_ROW) * ButtonGap.y;
				
				SlotButton = AddButtonEx("ButtonSlot_" + UnChosenButtonArray[i]["Pos"], "GuiDailyBonus_ImgDailyBonusClose", Position.x, Position.y);
				UnChosenButtonArray[i]["Button"] = SlotButton;
				UnChosenButtonArray[i]["Status"] = CLOSE;
				
				GlowingItem(SlotButton.img as MovieClip, false);
			}

			// Add các nút
			AddButton(BUTTON_CLOSE, "BtnThoat", 645, 20);								// Nút đóng
			AddButton(BUTTON_RECHOOSE, "GuiDailyBonus_BtnChonLai", 420, 415).SetDisable();			// Nút chọn lại
			AddButton(BUTTON_GET_GIFT, "GuiDailyBonus_BtnNhanThuong", 250, 415).SetDisable();		// Nút nhận quà
			
			if ((numOpen>0) && (numOpen < NumOpenMax))
			{
				costText = AddLabel(rechooseCost[String(numOpen)], 470, 422, 0xFFF100, 1, 0x603813);
				var tF:TextFormat = new TextFormat();
				tF.size = 16;
				costText.setTextFormat(tF);
			}
			
			// Đoạn code hiển thị các nút chọn ngày (5 ngày combo)
			var x0:int = 60;
			var y0:int = 90;
			var dy:int = 66;
			for (var k1:int = 1; k1 <= 5; k1++)
			{
				if (k1 == curDayView)
				AddImage("", "GuiDailyBonus_ImgFlare", x0 + 30, y0 + 30);
				y0 += dy;
			}
			y0 = 90;
			for (var k:int = 1; k <= 5; k++)
			{
				if (k <= (curDay.y - 1))
					AddImage("", "GuiDailyBonus_ImgDayComboArrow", 140, y0 + 27, true, ALIGN_LEFT_TOP);	

				AddImage("", "GuiDailyBonus_ImgDailyBonusDay_" + k + "c", x0, y0, true, ALIGN_LEFT_TOP);
				AddButton("Day_" + k, "GuiDailyBonus_BtnDailyBonusDay_" + k + "b", x0, y0);				// Nút ngày thứ i
				if (k == curDayView)
				{
					var imgTemp:Image = AddImage("", "GuiDailyBonus_ImgDailyBonusDay_" + k, x0, y0, true, ALIGN_LEFT_TOP);
					GlowingItem(imgTemp.img as MovieClip, true, true);
				}
				if (k > curDay.y)
				{
					ButtonArr[ButtonArr.length - 1].SetVisible(false);
				}
				y0 += dy;
			}
			
			// Nếu đã chọn quà rồi thì hiển thị hết quà ra
			if (isChoose != -1)
			{
				
				ShowAllAvailable();
				if (ChosenButtonArray[ChosenButtonArray.length - 1]["Type"] == 2)
				{
					processGetGift();
				}
				isChoose = -1;
			}
			// Nếu chưa chọn quà, hiển thị dòng chữ "Click để chọn quà!"
			else
			{
				if (UnChosenButtonArray.length != 0)
					AddImage("", "GuiDailyBonus_ImgClickDeChonThuong", 600, 230);
			}
		}
		
		/**
		 * Lật 1 món quà 
		 * @param	Position			: Vị trí món quà đó (0-5)
		 * @param	BackgroundType		: Hình nền
		 * @param	CallBack			: Hàm thực hiện sau khi lật
		 */
		private function ShowSlot(Position:int, BackgroundType:String, CallBack:Function = null):void
		{
			var i:int;		// count purpose
			
			if (!IsVisible)
			{
				return;
			}

			// Hide the current button
			var btn:ButtonEx = UnChosenButtonArray[Position]["Button"];
			var gift:Object = UnChosenButtonArray[Position]["Gift"];
			//trace(gift.Num);
			// Lật úp
			var Time:Number;
			Time = 0.4;
			btn.FlipX(0, Time, 40);
			btn.SetEnable(false);

			var array:Array = btn.ButtonID.split("_");
			var ctn:Container;
			ctn = GetContainer("ButtonSlot_" + array[1]);
			if (ctn != null)
			{
				for (i = 0; i < ContainerArr.length; i++)
				{
					if (ContainerArr[i].IdObject == ("ButtonSlot_" + array[1]))
					ContainerArr.splice(i, 1);
				}
			}

			switch (UnChosenButtonArray[Position]["Type"])
			{
				case 0:
					BackgroundType = "GuiDailyBonus_ImgDailyBonusOpen";
					break;
				case 1:
					BackgroundType = "GuiDailyBonus_ImgDailyBonusSpecial";
					break;
				case 2:
					BackgroundType = "GuiDailyBonus_ImgDailyBonusSpecial1";
					break;
			}
			ctn = AddContainer("ButtonSlot_" + array[1], BackgroundType, btn.img.x + btn.img.width / 4 - 4, btn.img.y);
			
			if (UnChosenButtonArray[Position]["Type"] == 2)
				DrawGift(ctn, gift, true);
			else
				DrawGift(ctn, gift);

			// Lật ngửa
			ctn.FlipX(1, Time, -18, Time, CallBack);
			
			// Nếu như là hành động mở quà 
			if (CallBack == ShowAllAvailable)
			{
				// Tỏa sáng như 1 ngôi sao :x
				GlowingItem(ctn.img as MovieClip, true, true);
				if (completeIcon != null)
					completeIcon.Destructor();
				completeIcon = ctn.AddImage("", "IcComplete", 60, 50);
				completeIcon.SetScaleXY(1.3);
				
				// đẩy đối tượng mới vào ChosenArray
				var object:Object = new Object();
				object["Gift"] = gift;
				object["Pos"] = Position;
				object["Button"] = ctn;
				object["Type"] = UnChosenButtonArray[Position]["Type"];
					
				ChosenButtonArray.push(object);
				
				UnChosenButtonArray.splice(isChoose, 1);
			}
			
			if (isChoose == -1)
			{
				UnChosenButtonArray[Position]["Status"] = OPEN;
			}
		}

		private function DrawGift(ctn:Container, gift:Object, isSpecial:Boolean = false):void
		{
			// Nếu là cá Swat thì cho nó cái hào quang 
			var setInfo:Function = function():void
			{
				//Vẽ aura bằng glowFilter
				var cl:int = 0xff0000;
				TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );		
			}
			
			var imag:Image;
			var tt:TooltipFormat = new TooltipFormat();
			switch (gift["ItemType"])
			{
				case "Money":
					imag = ctn.AddImage("", "GiftCoin100", ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
					imag.SetScaleXY(0.9);
					tt.text = "Tiền vàng";
					break;
				case "Material":
					imag = ctn.AddImage("", "Material" + gift["ItemId"], ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
					imag.SetScaleXY(1.3);
					tt.text = Localization.getInstance().getString("Material" + gift["ItemId"]);
					break;
				case "EnergyItem":
					imag = ctn.AddImage("", "EnergyItem" + gift["ItemId"], ctn.img.width / 2 - 7, ctn.img.height / 2 - 4, true, ALIGN_CENTER_CENTER);
					imag.SetScaleXY(1.3);
					tt.text = Localization.getInstance().getString("EnergyItem" + gift["ItemId"]);
					break;
				case "Exp":
					imag = ctn.AddImage("", "IcExp", ctn.img.width / 2 - 10, ctn.img.height / 2 - 10, true, ALIGN_CENTER_CENTER);
					imag.SetScaleXY(1.6);
					tt.text = "Kinh nghiệm";
					break;
				case "BabyFish":
					if (!gift["ItemId"] || gift["ItemId"] == "")
					{
						// Lấy ID cá theo level hiện tại
						gift["ItemId"] = ConfigJSON.getInstance().GetLevelFish(GiftList["3"]["Level"]);
					}					
					//imag = ctn.AddImage("", "Fish" + gift["ItemId"] + "_Old_Idle", ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
					var str:int = getLevelFish50(gift["ItemId"]);
					imag = ctn.AddImage("", "Fish" + getLevelFish50(gift["ItemId"]) + "_Old_Idle", ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
					if (gift["Option"])
					{
						TweenMax.to(imag.img, 1, {glowFilter:{color:getAuraColor(gift["Option"]), alpha:1, blurX:25, blurY:25, strength:1.5}});
					}
					var type:String;
					switch (gift["FishType"])
					{
						case 0:
							type = " thường";
							break;
						case 1:
							type = " đặc biệt";
							break;
						case 2:
							type = " quý";
							break;
					}
					tt.text = Localization.getInstance().getString("Fish" + gift["ItemId"]) + type;
					break;
				case "Bracelet":
					imag = ctn.AddImage("", "Bracelet" + gift["ItemId"] + "_Shop", ctn.img.width / 2 - 7, ctn.img.height / 2 - 4, true, ALIGN_CENTER_CENTER);
					imag.SetScaleXY(1.3);
					tt.text = Localization.getInstance().getString("Bracelet" + gift["ItemId"]);
					switch (gift.Color)
					{
						case FishEquipment.FISH_EQUIP_COLOR_GREEN:
							FishSoldier.EquipmentEffect(imag.img, gift.Color);
							tt.text += " - Đặc biệt";
							break;
						case FishEquipment.FISH_EQUIP_COLOR_GOLD:
							FishSoldier.EquipmentEffect(imag.img, gift.Color);
							tt.text += " - Quý hiếm";
							break;
						case FishEquipment.FISH_EQUIP_COLOR_PINK:
							FishSoldier.EquipmentEffect(imag.img, gift.Color);
							tt.text += " - Thần";
							break;
						case FishEquipment.FISH_EQUIP_COLOR_VIP:
							FishSoldier.EquipmentEffect(imag.img, gift.Color);
							tt.text += " - VIP";
							break;
					}
					break;
				case "Samurai":
					imag = ctn.AddImage("", gift["ItemType"] + gift["ItemId"], ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_CENTER_CENTER);
					imag.SetScaleXY(0.9);
					tt.text = Localization.getInstance().getString(gift["ItemType"] + gift["ItemId"]);
					tt.text = tt.text.replace("@Value@", ConfigJSON.getInstance().GetItemList("BuffItem")[gift.ItemType][gift.ItemId].Num + "");
					break;
				case "Resistance":
					imag = ctn.AddImage("", gift["ItemType"] + gift["ItemId"], ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_CENTER_CENTER);
					//imag.SetScaleXY(1.2);
					tt.text = Localization.getInstance().getString(gift["ItemType"] + gift["ItemId"]);
					break;
				case "RecoverHealthSoldier":
					imag = ctn.AddImage("", gift["ItemType"] + gift["ItemId"], ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_CENTER_CENTER);
					//imag.SetScaleXY(1.2);
					tt.text = Localization.getInstance().getString(gift["ItemType"] + gift["ItemId"]);
					var cfg:Object = ConfigJSON.getInstance().GetItemList("RecoverHealthSoldier")[gift.ItemId];
					tt.text = tt.text.replace("@Value@", cfg.Num + "");
					break;
				case "Swat":
					imag = ctn.AddImage("", gift["ItemType"], ctn.img.width / 2 + 10, ctn.img.height / 2, true, ALIGN_LEFT_TOP, false, setInfo);
					tt.text = GuiMgr.getInstance().GuiStore.GetNameFishSpecial(gift["ItemType"]);
					break;
				case "Ironman":
					imag = ctn.AddImage("", gift["ItemType"], ctn.img.width / 2 - 20, ctn.img.height / 2, true, ALIGN_LEFT_TOP, false, setInfo);
					tt.text = GuiMgr.getInstance().GuiStore.GetNameFishSpecial(gift["ItemType"]);
					break
				case "Diamond":
					if(gift.BonusId == 6)
					{
						imag = ctn.AddImage("", "Ic" + gift["ItemType"] + "Bonous", ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_CENTER_CENTER, false);
					}
					else
					{
						imag = ctn.AddImage("", "Ic" + gift["ItemType"], ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_CENTER_CENTER, false);
					}
					tt.text = Localization.getInstance().getString(gift["ItemType"]);
					break
				case "RankPointBottle":
					imag = ctn.AddImage("", gift["ItemType"] +  + gift["ItemId"], ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_CENTER_CENTER, false);
					tt.text = Localization.getInstance().getString(gift["ItemType"] +  + gift["ItemId"]);
					break
			}
			ctn.setTooltip(tt);
			
			if (gift["ItemType"] != "Swat" && gift["ItemType"] != "Ironman" && gift["ItemType"] != "BabyFish")
			{
				var text:TextField = ctn.AddLabel("x" + Ultility.StandardNumber(gift["Num"]), 0, 80, 0x000000, 1, 0x26709C);
				
				var TxtFormat:TextFormat = new TextFormat();
				TxtFormat.color = 0xffffff;
				if (isSpecial)
				{
					TxtFormat.color = 0xff0000;
				}
				TxtFormat.size =  16;
				
				text.setTextFormat(TxtFormat);
			}
		}
		
		/**
		 * Tráo giải thưởng của các ô
		 */
		private function swapGift(isOpen:Boolean = false):void
		{
			var Temp:Object;
			var rnd:int;
			var arrSwap:Array;
			if (!isOpen)
				arrSwap = UnChosenButtonArray;
			else
				arrSwap = ChosenButtonArray;

			for (var i:int = 0; i < arrSwap.length; i++)
			{
				rnd = Ultility.RandomNumber(0, arrSwap.length - 1);
				
				Temp = arrSwap[i]["Gift"];
				arrSwap[i]["Gift"] = arrSwap[rnd]["Gift"];
				arrSwap[rnd]["Gift"] = Temp;
				
				Temp = arrSwap[i]["Type"];
				arrSwap[i]["Type"] = arrSwap[rnd]["Type"];
				arrSwap[rnd]["Type"] = Temp;
				
				if (isOpen)		return;
				if (giftPos == i)
				{
					giftPos = rnd;
				}
				else if (giftPos == rnd)	
				{
					giftPos = i;
				}
			}
		}

		public function processGetGift():void
		{
			// Gửi gói tin nhận quà lên sơ vơ
			var cmd1:SendGetDailyBonus = new SendGetDailyBonus(curDayView);
			Exchange.GetInstance().Send(cmd1);
			
			// Làm rỗng object quà vừa nhận
			var obj:Object = new Object();
			GiftList[curDayView - 1] = obj;

			// Lấy thông tin quà ra
			var Gift:Object = ChosenButtonArray[ChosenButtonArray.length - 1]["Gift"];
			
			// Nếu là quà xịn thì hiện GUI chúc mừng 
			if (ChosenButtonArray[ChosenButtonArray.length - 1]["Type"] != 0)
			{
				GuiMgr.getInstance().GuiDailyBonusCongrat.Init(Gift);
				Hide();
			}
			else
			{
				Init(0, curDayView);	// Hiển thị lại GUI đã nhận quà
				switch (Gift["ItemType"])
				{
					case "Diamond":
						EffectMgr.setEffBounceDown("Nhận quà thành công", "IcDiamond", 330, 280);
						break;
					case "Money":
						EffectMgr.setEffBounceDown("Nhận quà thành công", "GiftCoin100", 330, 280);
						break;
					case "Exp":
						EffectMgr.setEffBounceDown("Nhận quà thành công", "IcExp", 330, 280);
						break;
					//case "Material":
					//case "EnergyItem":
						//EffectMgr.setEffBounceDown("Nhận quà thành công", Gift["ItemType"] + Gift["ItemId"] , 330, 280);	
						//break;
					case "Bracelet":
						EffectMgr.setEffBounceDown("Nhận quà thành công", Gift["ItemType"] + Gift["ItemId"] + "_Shop", 330, 280);	
						break;
					case "BabyFish":
						EffectMgr.setEffBounceDown("Nhận quà thành công", "Fish" + getLevelFish50(Gift["ItemId"]) + "_" + Fish.OLD + "_" + Fish.HAPPY, 330, 280);	
						break;
					default:
						EffectMgr.setEffBounceDown("Nhận quà thành công", Gift["ItemType"] + Gift["ItemId"] , 330, 280);	
						break;
				}
				GetButton(BUTTON_GET_GIFT).SetDisable();
				GetButton(BUTTON_RECHOOSE).SetDisable();
			}
			
			switch (Gift["ItemType"])
			{
				case "Money":
					GameLogic.getInstance().user.UpdateUserMoney(Gift["Num"]);
					break;
				case "Exp":
					var exp:int = GameLogic.getInstance().user.GetExp() + Gift["Num"];
					GameLogic.getInstance().user.SetUserExp(exp);
					break;
				//case "Material":
				//case "EnergyItem":
				//case "BabyFish":
					//GuiMgr.getInstance().GuiStore.UpdateStore(Gift["ItemType"], Gift["ItemId"], Gift["Num"]);					
					//if (Gift["ItemType"] == "BabyFish")
						//GameLogic.getInstance().user.GenerateNextID();
					break;
				case "Diamond":
					GameLogic.getInstance().user.updateDiamond(Gift["Num"]);
					break;
				case "Bracelet":
				case "Swat":
				case "Ironman":
				case "BabyFish":
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					GameLogic.getInstance().user.GenerateNextID();
					break;
				default:
					GuiMgr.getInstance().GuiStore.UpdateStore(Gift["ItemType"], Gift["ItemId"], Gift["Num"]);
					break;
			}	
		}
		
		/**
		 * Chuyển quà đã chọn nhưng ko nhận vào mảng quà đã chọn
		 * @param	id
		 */
		public function processRechoose(bonus:Object, day:int):void
		{
			if (img == null) return;
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			GiftList[day - 1]["Gift"].push(bonus);
			SetAllGiftDisable();
			isChoose = -1;
			RollBack(day);
		}
		
		/**
		 * Úp các phần quà để chọn lại, các phần quà đã chọn thì ko dc úp lại nữa
		 */
		private function RollBack(day:int):void
		{
			var Time:Number;
			Time = 0.4;
			var enable:Function = function():void
			{
				GetButton(BUTTON_CLOSE).SetEnable();
			}
			
			// Lật úp các phần quà chưa chọn
			for (var j:int = 0; j < UnChosenButtonArray.length; j++)
			{
				var container: Container = GetContainer("ButtonSlot_" + UnChosenButtonArray[j]["Pos"]);
 				container.FlipX(0, Time, 40);
				UnChosenButtonArray[j]["Button"].FlipX(1, Time, -39, Time);
				UnChosenButtonArray[j]["Button"].SetEnable(true);
				if (j == UnChosenButtonArray.length - 1)
				{
					UnChosenButtonArray[j]["Button"].FlipX(1, Time, -39, Time, enable);
					UnChosenButtonArray[j]["Button"].SetEnable(true);
				}
				else
				{
					UnChosenButtonArray[j]["Button"].FlipX(1, Time, -39, Time);
					UnChosenButtonArray[j]["Button"].SetEnable(true);
				}
			}	
			
			updateGiftPos(day);
			swapGift();
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_BUTTON_SLOT_1:
				case GUI_BUTTON_SLOT_2:
				case GUI_BUTTON_SLOT_3:
				case GUI_BUTTON_SLOT_4:
				case GUI_BUTTON_SLOT_5:
				case GUI_BUTTON_SLOT_6:
					if (isChoose != -1)
					return;
					isCanChangeDay = false;
					GetButton(BUTTON_CLOSE).SetDisable();
					for (var i:int = 0; i < UnChosenButtonArray.length; i++)
					{
						var ar:Array = buttonID.split("_");
						if (UnChosenButtonArray[i]["Pos"] == ar[1])
						{
							// Tráo quà tặng đã được cơ cấu lên vị trí vừa chọn >"<
							var Temp:Object = UnChosenButtonArray[giftPos]["Gift"];
							UnChosenButtonArray[giftPos]["Gift"] = UnChosenButtonArray[i]["Gift"];
							UnChosenButtonArray[i]["Gift"] = Temp;
							
							Temp = UnChosenButtonArray[giftPos]["Type"];
							UnChosenButtonArray[giftPos]["Type"] = UnChosenButtonArray[i]["Type"];
							UnChosenButtonArray[i]["Type"] = Temp;
							
							isChoose = i;
							numOpen++;
							
							if (UnChosenButtonArray[i]["Type"] == 2)
							{
								isVeryRareGift = true;
							}
							ShowSlot(i, "GuiDailyBonus_ImgDailyBonusOpen", ShowAllAvailable);
							saveData[String(ChosenButtonArray.length)] = int(ar[1]);
							sob.flush();
							break;
						}
					}
					break;
					
				case GUI_BUTTON_DAY_1:
				case GUI_BUTTON_DAY_2:
				case GUI_BUTTON_DAY_3:
				case GUI_BUTTON_DAY_4:
				case GUI_BUTTON_DAY_5:
					if (isCanChangeDay)
					{
						var array:Array = buttonID.split("_");
						Init(0, array[1]);
					}
					break;
					
				case BUTTON_CLOSE:
					this.Hide();		
					break;		
					
				case BUTTON_GET_GIFT:
					if (numOpen < NumOpenMax)
					{
						var numLeft:int = NumOpenMax - numOpen;
						GuiMgr.getInstance().GuiMessageBox.ShowConfirmGetDailyBonus("Bạn vẫn còn " + numLeft + " lượt chọn lại nữa đấy! Bạn có chắc muốn nhận phần quà này không?");
					}
					else
					{
						processGetGift();
					}
					
					var task:TaskInfo = QuestMgr.getInstance().QuestPowerTinh[QuestMgr.QUEST_PT_DAILY_GIFT].TaskList[0] as TaskInfo;
					if (!task.Status)
					{
						task.Num += 1;
					}
					
					QuestMgr.getInstance().UpdatePointReceive();
					break;
					
				case BUTTON_RECHOOSE:
					GetButton(BUTTON_RECHOOSE).SetDisable();
					GetButton(BUTTON_GET_GIFT).SetDisable();
					GetButton(BUTTON_CLOSE).SetDisable();
					var xu:int = GameLogic.getInstance().user.GetZMoney();
					var xuRequire:int = rechooseCost[String(numOpen)];
					// Nếu đủ xu thì cho chọn lại
					if (xu >= xuRequire)
					{
						var cmdRechoose:SendReChooseDailyBonus = new SendReChooseDailyBonus(curDayView);
						if(!isSendReChoose)
						{
							isSendReChoose = true;
							Exchange.GetInstance().Send(cmdRechoose);
						}
						var xuAfter:int = xu - xuRequire;
						GameLogic.getInstance().user.UpdateUserZMoney( -xuRequire);

						//Add ảnh chờ load dữ liệu
						img.addChild(WaitData);
						WaitData.x = img.width / 2 + 90;
						WaitData.y = img.height / 2 - 37;	
					}
					// Không đủ thì bắt nạp xu
					else
					{
						GuiMgr.getInstance().GuiNapG.Init();
						GetButton(BUTTON_RECHOOSE).SetEnable();
						GetButton(BUTTON_GET_GIFT).SetEnable();
						GetButton(BUTTON_CLOSE).SetEnable();
					}
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{	
			switch (buttonID)
			{
				case GUI_BUTTON_SLOT_1:
				case GUI_BUTTON_SLOT_2:
				case GUI_BUTTON_SLOT_3:
				case GUI_BUTTON_SLOT_4:
				case GUI_BUTTON_SLOT_5:
				case GUI_BUTTON_SLOT_6:
					var btnE:ButtonEx = GetButtonEx(buttonID);
					GlowingItem(btnE.img as MovieClip, false, true);
					btnE.img.scaleX = 1.03;
					btnE.img.scaleY = 1.03;
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_BUTTON_SLOT_1:
				case GUI_BUTTON_SLOT_2:
				case GUI_BUTTON_SLOT_3:
				case GUI_BUTTON_SLOT_4:
				case GUI_BUTTON_SLOT_5:
				case GUI_BUTTON_SLOT_6:
					var btnE:ButtonEx = GetButtonEx(buttonID);
					GlowingItem(btnE.img as MovieClip, false, false);
					btnE.img.scaleX = 1;
					btnE.img.scaleY = 1;
					break;
			}
		}

		/**
		 * Hàm hiển thị toàn bộ tất cả các phần quà còn lại (chưa hoặc ko dc nhận)
		 */
		private function ShowAllAvailable():void
		{
			isCanChangeDay = false;
			if (!IsVisible)
			{
				return;
			}
			for (var i:int = 0; i < UnChosenButtonArray.length; i++)
			{
				if (UnChosenButtonArray[i]["Status"] == CLOSE)
				{
					if (i == UnChosenButtonArray.length -1 )
					{
						ShowSlot(i, "GuiDailyBonus_ImgDailyBonusOpen", EnableButtons)
					}
					else
					{
						ShowSlot(i, "GuiDailyBonus_ImgDailyBonusOpen");
					}
				}
				
			}					
		}
		
		/**
		 * Hiển thị các button sau khi motion kết thúc
		 * Kết hợp cả 1 số logic vào hàm này (nếu là quà khủng thì nhận luôn)
		 * @param	e
		 */
		//private function EnableButtons(e:TimerEvent):void
		private function EnableButtons():void
		{
			if (!IsVisible)
			{
				return;
			}
			//if (isChoose != -1)
			//{
				//GetButton(BUTTON_GET_GIFT).SetEnable(true);	
					//GetButton(BUTTON_CLOSE).SetEnable(true);
				GetButton(BUTTON_CLOSE).SetEnable(true);
				if ((numOpen == NumOpenMax) || (isVeryRareGift))
				{
					processGetGift();
				}	
				else if ((numOpen < NumOpenMax) && (numOpen > 0))
				{
					GetButton(BUTTON_RECHOOSE).SetEnable(true);	
					GetButton(BUTTON_GET_GIFT).SetEnable(true);	
					if (costText != null)
						costText.visible = false;
					//else
					//{
						costText = AddLabel(rechooseCost[String(numOpen)], 470, 422, 0xFFF100, 1, 0x603813);
					//}
					var tF:TextFormat = new TextFormat();
					tF.size = 16;
					costText.setTextFormat(tF);
				}
				
				
				//GetButton(BUTTON_CLOSE).SetEnable(true);
			//}
			isCanChangeDay = true;
		}
		
		private function GlowingItem(mv:MovieClip, picked:Boolean, highlight:Boolean = false):void
		{
			glow = new GlowFilter();
			glow.blurX = 15;
			glow.blurY = 15;
			if (picked)
			{
				glow.color = 0xFFCC00;
			}
			else
			{
				glow.color = 0x32FFCC;				
			}
			if (highlight)
			{
				glow.alpha = 1;
				glow.blurX = 25;
				glow.blurY = 25;
			}
			else
			{
				glow.alpha = 0.5;
				glow.blurX = 15;
				glow.blurY = 15;
			}
			mv.filters = [glow];
		}
		
		private function SetAllGiftDisable():void
		{
			for (var j:int = 0; j < ChosenButtonArray.length; j++)
			{
				GlowingItem(ChosenButtonArray[j]["Button"].img as MovieClip, true, false);
				ChosenButtonArray[j]["Button"].img.alpha = 0.5;
				ChosenButtonArray[j]["Button"].AddImage("", "IcCancel", 50, 50);
			}
			completeIcon.img.visible = false;
		}
		
		public function getAuraColor(RateOption:Object):int
		{
			var t:int = 0;
			for (var i:String in RateOption) 
			{
				if (i.match(OPTION_MONEY))
				{
					t = AURA_COLOR_GOLD;
				}
				else if (i.match(OPTION_EXP))
				{
					t = AURA_COLOR_EXP;
				}
				else if (i.match(OPTION_MIX_RARE))
				{
					t = AURA_COLOR_MIX;
				}
				else if (i.match(OPTION_TIME))
				{
					t = AURA_COLOR_OTHER;
				}					
			}
			return t;
		}
		
		private function getLevelFish50(id:int):int
		{
			var bonLv:int = 44;				// Id fish plus
			var step:int = 6;
			var maxId:int = 79;		// Level cao nhất của cá hiện tại
			if (id < bonLv) return id;
			else 
			{
				if (id > maxId)
				{
					id = maxId;
				}
				var trueId:int = bonLv + int((id - bonLv) / step) * 6;
				return trueId;
			}
		}
		
		//public override function OnLoadResComplete():void
		//{
			//IsVisible = true;
			//if (GuiMgr.getInstance().GuiWaitingContent.IsVisible)
			//{
				//GuiMgr.getInstance().GuiWaitingContent.Hide();
			//}
			//
			//var vt:int = -1; 
			//if (img.parent)
			//{
				//vt = img.parent.getChildIndex(img);
			//}
			//if (vt >= 0 && this.Fog)
			//{
				//img.parent.removeChild(img);
				//Fog.addChild(img);
			//}
		//}
	}
}