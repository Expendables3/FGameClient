package GUI.FishWar 
{
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getQualifiedClassName;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.CreateEquipment.ItemInGradient;
	import GUI.GuiMgr;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * GUI thông tin của trang bị (kiểu như tooltip)
	 * @author longpt
	 */
	public class GUIEquipmentInfo extends BaseGUI 
	{
		public static const INFO_TYPE_STORE:int = 1;
		public static const INFO_TYPE_SPECIFIC:int = 2;
		public static const INFO_TYPE_ENCHANT:int = 3;
		
		public var curEquipment:FishEquipment = null;
		public var compareEquipment:FishEquipment = null;
		
		public static const BASIC_STAT:Array = ["Damage", "Defence", "Critical", "Vitality"];
		
		public function GUIEquipmentInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIEquipmentInfo";
		}
		
		public override function InitGUI():void
		{
			//LoadRes("GuiEquipmentInfo");
			LoadRes("ImgFrameFriend");
		}
		
		/**
		 * Hiển thị GUI thông số của trang bị
		 * @param	con				Cái container mà move vào hiện ra GUI này
		 * @param	obj				Thông tin trang bị để show
		 * @param	type			Kiểu GUI (thông tin trong shop hay thông tin đồ đã có)
		 * @param	curEquip		Trang bị đang mặc (so sánh)
		 */
		public function InitAll(x:Number, y:Number, obj:Object, type:int = 1, curEquip:FishEquipment = null, activeRow:int = 0, totalPercent:int = 0):void 
		{
			curEquipment = obj as FishEquipment;
			compareEquipment = curEquip;
			
			if(!this.IsVisible)
				Show();
			ClearComponent();
			
			var ctn:Container = AddContainer("", "ImgFrameFriend", 0, 0);
			ctn.AddImage("BG", "GuiEquipmentInfo", 0, 0, true, ALIGN_LEFT_TOP);
			
			switch (type)
			{
				case INFO_TYPE_ENCHANT:
					ShowInfoSpecific(obj as FishEquipment, ctn);
					break;
				case INFO_TYPE_SPECIFIC:
					if(compareEquipment == null)
					{
						ShowInfoSpecific(obj as FishEquipment, ctn, false, activeRow, totalPercent);
					}
					else
					{
						ShowInfoSpecific(obj as FishEquipment, ctn, false);
					}
					break;
				case INFO_TYPE_STORE:
					ShowInfoAbstract(obj, ctn);
					
					//So dong
					if (GuiMgr.getInstance().guiCreateEquipment.IsVisible
					|| GuiMgr.getInstance().guiSpecialSmithy.IsVisible)
					{
						var height:Number;
						var txtF:TextField;
						var tF:TextFormat;
						var color:int = int(String(obj["subtype"]).split("$")[1]);
						var configRate:Object = ConfigJSON.getInstance().GetItemList("EquipmentRate");
						configRate = configRate[obj["type"]]["Color"][color];
						var min:int = 100; 
						var max:int = 0;
						for (var s:String in configRate)
						{
							if (int(s) > max)
							{
								max = int(s);
							}
							if (int(s) < min)
							{
								min = int(s);
							}
						}
						min += 1;
						if (max != 0)
						{
							height = ctn.GetImage("BG").img.height;
							ctn.AddImage("", "LineCtnEquipmentInfo", 20, height, true, ALIGN_LEFT_TOP);
							txtF = ctn.AddLabel("", 70, height + 10, 0xffffff, 0, 0x000000);
							if(min != max)
							{
								txtF.htmlText = "<font color='#ffff00'>" + min + " - " + max + "</font>" + " Thuộc tính ngẫu nhiên";
							}
							else
							{
								txtF.htmlText = "<font color='#ffff00'>" + max + "</font>" + " Thuộc tính ngẫu nhiên";
							}
							tF = new TextFormat("arial", 12);
							tF.bold = true;
							txtF.setTextFormat(tF);
							
							ctn.GetImage("BG").img.height += 40;
						}
						
						//Show them thuoc tinh author
						var name:String = "";
						name = GameLogic.getInstance().user.GetMyInfo().Name;
						height = ctn.GetImage("BG").img.height;
						ctn.AddImage("", "LineCtnEquipmentInfo", 20, height, true, ALIGN_LEFT_TOP);
						txtF = ctn.AddLabel("", 70, height + 10, 0xffffff, 0, 0x000000);
						txtF.htmlText = "Thợ rèn:  <font color='#ffff00'>" + Ultility.StandardString(name, 15) + "</font>";
						tF = new TextFormat("arial", 12);
						tF.bold = true;
						txtF.setTextFormat(tF);
						ctn.GetImage("BG").img.height += 40;
					}
					break;
			}
			
			var delta:int = 10;
			
			// Vị trí container
			var posX:int = x;
			var posY:int = y;
			// Kích thước GUI
			var sizeX:int = img.width;
			var sizeY:int = img.height;
			
			var posCenterX:int;
			var posCenterY:int;
			
			var posGui:Point = new Point();
			
			if (GuiMgr.IsFullScreen)
			{
				posCenterX = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenWidth / 2;
				posCenterY = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenHeight / 2
			}
			else 
			{
				posCenterX = Constant.STAGE_WIDTH / 2;
				posCenterY = Constant.STAGE_HEIGHT / 2;
			}
			
			if (posX <= posCenterX) 
			{
				if (posY <= posCenterY) 
				{
					posGui.x = x + 40;
					posGui.y = y - img.height/2;
				}
				else 
				{
					posGui.x = x + 10;
					posGui.y = y - img.height;
				}
			}
			else 
			{
				if (posY <= posCenterY)  
				{
					posGui.x = x - sizeX - 40;
					posGui.y = y - img.height/2;;
				}
				else 
				{
					posGui.x = x - sizeX - 10;
					posGui.y = y - img.height;;
				}
			}
			SetPos(posGui.x, posGui.y);
			if (curEquip && !GuiMgr.getInstance().GuiChooseEquipment.stateSeparate)
			{
				if (this.img.x + 2 * this.img.width + 10 < Constant.STAGE_WIDTH || GuiMgr.IsFullScreen)
				{
					ctn.SetPos(this.img.width, 0);
					ctn = AddContainer("", "ImgFrameFriend", 0, 0);
					ctn.AddImage("BG", "GuiEquipmentInfo", 0, 0, true, ALIGN_LEFT_TOP);
				}
				else
				{
					ctn = AddContainer("", "ImgFrameFriend", -this.img.width, 0);
					ctn.AddImage("BG", "GuiEquipmentInfo", 0, 0, true, ALIGN_LEFT_TOP);
				}
				
				ShowInfoSpecific(curEquip, ctn, true, activeRow);
			}
			
			this.img.mouseChildren = false;
			this.img.mouseEnabled = false;
			
			if (img.y < 0)
			{
				img.y = 0;
			}
			if (img.y + img.height > Constant.STAGE_HEIGHT)
			{
				img.y = Constant.STAGE_HEIGHT - img.height ;
			}
		}
		
		private function showExtraInfo(obj:Object, ctn:Container):void 
		{
			//Show khi ở chế độ tách đồ
			var height:Number;
			var txtF:TextField;
			var tF:TextFormat;
			if (GuiMgr.getInstance().GuiChooseEquipment.stateSeparate)
			{
				var config:Object = ConfigJSON.getInstance().GetItemList("IngredientsRefining");
				var level:int = int(obj["Rank"] % 100);
				if(config[obj["Type"]][level] != null)
				{
					config = config[obj["Type"]][level][obj["Color"]];
				}
				else
				{
					config = null;
				}
				var arrItem:Array = [];
				var itemIngradient:ItemInGradient;
				for (var s:String in config)
				{
					if (s != "PowerTinh" && s != "SixColorTinh" && s != "SoulRock")
					{
						if(config[s] != 0)
						{
							itemIngradient = new ItemInGradient(ctn.img);
							itemIngradient.initIngradient(config[s], s, 0, 17);
							itemIngradient.SetScaleXY(0.7);
							arrItem.push(itemIngradient);
						}
					}
					else if (s == "SoulRock")
					{
						if(config[s][level] != 0)
						{
							itemIngradient = new ItemInGradient(ctn.img);
							itemIngradient.initIngradient(config[s][level], s, level, 17);
							itemIngradient.SetScaleXY(0.7);
							arrItem.push(itemIngradient);
						}
					}
				}
				
				if (arrItem.length > 0)
				{
					height = ctn.GetImage("BG").img.height;
					ctn.AddImage("", "LineCtnEquipmentInfo", 20, height, true, ALIGN_LEFT_TOP);
					txtF = ctn.AddLabel("Có thể tách thành:", 70, height + 10, 0xffffff, 0, 0x000000);
					tF = new TextFormat("arial", 12, 0xffffff, true);
					txtF.setTextFormat(tF);
					
					for (var i:int = 0; i < arrItem.length; i++)
					{
						itemIngradient = arrItem[i] as ItemInGradient;
						itemIngradient.SetPos(140 + (i - arrItem.length / 2) * 80, height + 30);
					}
					
					ctn.GetImage("BG").img.height += 90;
				}
			}
			//Show them thuoc tinh author
			var name:String = "";
			if (GuiMgr.getInstance().guiCreateEquipment.IsVisible)
			{
				name = GameLogic.getInstance().user.GetMyInfo().Name;
			}
			else if (obj["Author"] != null)
			{
				name = obj["Author"]["Name"];
			}
			if (name != "")
			{
				height = ctn.GetImage("BG").img.height;
				var cf:Object = ConfigJSON.getInstance().GetItemList("Param")["LimitChangeOption"];
				var num:int = cf[curEquipment["Color"]];
				var numChanged:int;
				if (curEquipment.hasOwnProperty("NumChangeOption"))	numChanged = curEquipment["NumChangeOption"];
				
				ctn.AddImage("", "LineCtnEquipmentInfo", 20, height, true, ALIGN_LEFT_TOP);
				txtF = ctn.AddLabel("", 50, height + 5, 0xffffff, 0, 0x000000);
				txtF.htmlText = "Thợ rèn:  <font color='#ffff00'>" + Ultility.StandardString(name, 15) + 
								"</font>\nCòn <font color='#ffff00'>" + String(num - numChanged)+ "</font> lần tùy biến";
				tF = new TextFormat("arial", 12);
				tF.bold = true;
				tF.align = "center";
				txtF.setTextFormat(tF);
				ctn.GetImage("BG").img.height += 40;
			}
			
			//Show người bán
			if (obj["seller"] != null)
			{
				height = ctn.GetImage("BG").img.height;
				ctn.AddImage("", "LineCtnEquipmentInfo", 20, height, true, ALIGN_LEFT_TOP);
				txtF = ctn.AddLabel("", 70, height + 10, 0xffffff, 0, 0x000000);
				txtF.htmlText = "Người bán:  <font color='#ffff00'>" + Ultility.StandardString(obj["seller"]["userName"], 15) + "</font>";
				tF = new TextFormat("arial", 12);
				tF.bold = true;
				txtF.setTextFormat(tF);
				
				ctn.GetImage("BG").img.height += 40;
			}
			
			//Show đồ bị khóa hay không
			if (!GuiMgr.getInstance().guiMarket.IsVisible)
			{
				height = ctn.GetImage("BG").img.height;
				ctn.AddImage("", "LineCtnEquipmentInfo", 20, height, true, ALIGN_LEFT_TOP);
				txtF = ctn.AddLabel("", 70, height + 10, 0xffffff, 1, 0x000000);
				tF = new TextFormat("arial", 12);
				tF.bold = true;
				txtF.setTextFormat(tF);
				ctn.GetImage("BG").img.height += 40;
				if(!Ultility.checkSource(obj["Source"]) || obj["IsUsed"])
				{
					txtF.htmlText = " <font color='#ff0000'>Đồ không thể giao dịch</font>";
					ctn.AddImage("", "Lock", 47, height + 21);
				}
				else
				{
					txtF.htmlText = " <font color='#00ff00'>Đồ có thể giao dịch</font>";
				}
			}
		}
		
		/**
		 * Show thông tin chi tiết của 1 cái mặt nạ
		 * @param	obj
		 * @param	ctn
		 * @param	isWare
		 */
		public function ShowInfoSpecificMask(obj:FishEquipmentMask, ctn:Container, isWare:Boolean = false):void
		{
			var tF:TextFormat;
			var txtF:TextField;	
			var i:int;
			var s:String;
			var color:Object = GetColorByEquipColor(obj.Color);
			// Nếu là đồ đặc biệt, quý thì cho cái nền khác			
			if (obj.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				imag = ctn.AddImage("", FishEquipment.GetBackgroundName(obj.Color), 12, 15, true, ALIGN_LEFT_TOP);
			}
			else
			{
				imag = ctn.AddImage("", "CtnEquipmentInfo", 12, 15, true, ALIGN_LEFT_TOP);
			}
			
			// Ảnh đồ
			var name:String = obj.imageName + "_Shop";
			var imag:Image = ctn.AddImage("", name, 0, 0);
			imag.FitRect(55, 55, new Point(19, 23));
			FishSoldier.EquipmentEffect(imag.img, obj.Color);
			
			// Tên, loại đồ (thường, quý...)
			txtF = ctn.AddLabel(Localization.getInstance().getString(obj.Type + obj.Rank) + " - " + Localization.getInstance().getString("EquipmentColor" + obj.Color), 85, 15, 0x000000, 0, 0x000000);
			txtF.wordWrap = true;
			txtF.width = 170;
			tF = new TextFormat();
			tF.size = 17;
			tF.color = color;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Loại trang bị (vũ khí, áo...)
			txtF = ctn.AddLabel("[" + Localization.getInstance().getString("Equipment" + obj.Type) + "]", 85, 60, 0x000000, 0);
			tF = new TextFormat();
			tF.size = 15;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			if (isWare)
			{
				txtF = ctn.AddLabel("[Đang mặc]",  158, 60, 0x000000, 1, 0x000000);
				tF = new TextFormat();
				tF.size = 15;
				tF.color = 0xF7F700;
				tF.bold = true;
				txtF.setTextFormat(tF);
			}
			
			// Add cái container thông tin cơ bản
			ctn.AddImage("", "CtnInfoEquipmentBase", 15, 110, true, ALIGN_LEFT_TOP).SetScaleY(0.7);
			
			var x0:int = 140;
			var y0:int = 110;
			var dx:int = 0;
			var dy:int = 26;
			var index:int = 0;
			
			// Tăng tất cả các chỉ số
			txtF = ctn.AddLabel("Tăng tất cả chỉ số:", x0 - 100, y0 + dy * index + 4, 0xFFF100, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			txtF = ctn.AddLabel(obj.Damage + "", x0 + dx * index + 15, y0 + dy * index, 0xFFF100, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 18;
			tF.color = color;
			if (obj.TimeUse <= 0)
			{
				tF.color = 0xff0000;
			}
			tF.bold = true;
			txtF.setTextFormat(tF);
			index++;
			
			var cfg:Object = ConfigJSON.getInstance().GetEquipmentInfo(obj.Type, obj.Rank + "$" + obj.Color);
			var timeStr:String = "";
			var timeLeft:Number = cfg.TimeUse + obj.StartTime - GameLogic.getInstance().CurServerTime;
			var dayLeft:int = Math.floor(timeLeft / 86400);
			var hourLeft:int = Math.floor((timeLeft % 86400) / 3600);
			var minLeft:int = Math.floor(((timeLeft  % 86400) % 3600) / 60);
			var secLeft:int = timeLeft - dayLeft * 86400 - hourLeft * 3600 - minLeft * 60;
			
			if (dayLeft > 0)
			{
				timeStr += (dayLeft + 1) + " ngày";
			}
			else if (hourLeft > 0)
			{
				timeStr += hourLeft + " giờ";
			}
			else if (minLeft > 0)
			{
				timeStr += minLeft + " phút";
			}
			else if (secLeft > 0)
			{
				timeStr += secLeft + " giây";
			}
			
			// Hạn sử dụng
			txtF = ctn.AddLabel("Hạn sử dụng còn:", x0 - 100, y0 + dy * index + 4, 0xFFF100, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			txtF = ctn.AddLabel(timeStr, x0 + dx * index + 15, y0 + dy * index, 0xFFF100, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 18;
			tF.color = 0xffffff;
			if (obj.TimeUse <= 0)
			{
				tF.color = 0xff0000;
			}
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add cái chữ "Dùng cho"
			txtF = ctn.AddLabel("Dùng cho:", 52, 175, 0xffffff, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add tên hệ (Kim mộc...)
			if (obj.Element != FishSoldier.ELEMENT_NONE)
			{
				txtF = ctn.AddLabel("Hệ " + Localization.getInstance().getString("Element" + obj.Element), 130, 170, 0x000000, 0, 0x000000);
			}
			else
			{
				txtF = ctn.AddLabel("Tất cả", 130, 170, 0x000000, 0, 0x000000);
			}
			tF = new TextFormat();
			tF.size = 18;
			tF.color = GetColorByElement(obj.Element);
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Đường kẻ
			if (index > 0)
			{
				ctn.AddImage("", "LineCtnEquipmentInfo", 20, 200, true, ALIGN_LEFT_TOP);
			}
			
			txtF = ctn.AddLabel("Khi sử dụng sẽ biến thành", 80, 210, 0xffffff, 1, 0x000000);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = GetColorByEquipColor(obj.Color);
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			txtF = ctn.AddLabel(Localization.getInstance().getString(obj.Type + obj.Rank), 80, 225, 0xffffff, 1, 0x000000);
			tF = new TextFormat();
			tF.size = 18;
			tF.color = GetColorByEquipColor(obj.Color);
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add khung
			ctn.AddImage("", "CtnInfoEquipmentBase", 15, 250, true, ALIGN_LEFT_TOP).SetScaleY(1.4);
			
			// Add cái ảnh minh họa con cá
			if (obj.Rank == FishEquipmentMask.MASK_DRAGON)
			{
				if (GuiMgr.getInstance().GuiChooseEquipment.curSoldier && !GameLogic.getInstance().user.IsViewer())
				{
					ctn.AddImage("", "Dragon_" + GuiMgr.getInstance().GuiChooseEquipment.curSoldier.Element, 0, 0).FitRect(120, 120, new Point(60, 250));
				}
				else if (GuiMgr.getInstance().guiSoliderInfo.curSoldier && GameLogic.getInstance().user.IsViewer())
				{
					ctn.AddImage("", "Dragon_" + GuiMgr.getInstance().guiSoliderInfo.curSoldier.Element, 0, 0).FitRect(120, 120, new Point(60, 250));
				}
				else
				{
					ctn.AddImage("", "Dragon_4", 0, 0).FitRect(120, 120, new Point(60, 250));
				}
			}
			else
			{
				ctn.AddImage("", obj.GetFishByMaskId(obj.Rank), 0, 0).FitRect(120, 120, new Point(60, 250));
			}
			
			ctn.GetImage("BG").SetScaleY(1.6);
		}
		
		/**
		 * Show thông tin chi tiết của 1 món đồ đã mua
		 * @param	obj
		 */
		private function ShowInfoSpecific(obj:FishEquipment, ctn:Container, isWare:Boolean = false, activeRow:int = 0, totalPercent:int = 0):void
		{
			if (obj.Type == "Mask")
			{
				ShowInfoSpecificMask(obj as FishEquipmentMask, ctn, isWare);
				return;
			}
			var tF:TextFormat;
			var txtF:TextField;	
			var i:int;
			var s:String;
			var color:Object = GetColorByEquipColor(obj.Color);
			// Nếu là đồ đặc biệt, quý thì cho cái nền khác
			if (obj.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				imag = ctn.AddImage("", FishEquipment.GetBackgroundName(obj.Color), 12, 15, true, ALIGN_LEFT_TOP);
			}
			else
			{
				imag = ctn.AddImage("", "CtnEquipmentInfo", 12, 15, true, ALIGN_LEFT_TOP);
			}
			
			// Ảnh đồ
			var name:String = FishEquipment.GetEquipmentName(obj.Type, obj.Rank, obj.Color) + "_Shop";
			
			var imag:Image = ctn.AddImage("", name, 0, 0);
			imag.FitRect(55, 55, new Point(19, 23));
			FishSoldier.EquipmentEffect(imag.img, obj.Color);
			
			// Tên, loại đồ (thường, quý...)
			var namee:String = FishEquipment.GetEquipmentLocalizeName(obj.Type, obj.Rank, obj.Color);
			txtF = ctn.AddLabel(namee + " - " + Localization.getInstance().getString("EquipmentColor" + obj.Color) + " - Cấp " + int(obj.Rank % 100), 85, 15, 0x000000, 0, 0x000000);
			txtF.wordWrap = true;
			txtF.width = 170;
			tF = new TextFormat();
			tF.size = 15;
			tF.color = color;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Loại trang bị (vũ khí, áo...)
			txtF = ctn.AddLabel("[" + Localization.getInstance().getString("Equipment" + obj.Type) + "]", 85, 60, 0x000000, 0);
			tF = new TextFormat();
			tF.size = 15;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			if (isWare)
			{
				txtF = ctn.AddLabel("[Đang mặc]",  158, 60, 0x000000, 1, 0x000000);
				tF = new TextFormat();
				tF.size = 15;
				tF.color = 0xF7F700;
				tF.bold = true;
				txtF.setTextFormat(tF);
			}
			
			// Chỉ số enchant
			if (obj.EnchantLevel > 0)
			{
				var enX0:int = 60;
				var enY0:int = 113;
				var enDx:int = 22;
				var enDy:int = 0;
				
				for (i = 0; i < obj.EnchantLevel; i++)
				{
					ctn.AddImage("", "LuckyStar", enX0 + i * enDx, enY0 + i * enDy).SetScaleXY(0.35);
				}
			}
			
			
			if (obj.Type == "Seal")
			{
				showSealInfo(obj, ctn, activeRow);
				return;
			}
			
			// Add cái container thông tin cơ bản
			ctn.AddImage("", "CtnInfoEquipmentBase", 15, 110, true, ALIGN_LEFT_TOP);
			
			var compareValue:FishEquipment;
			if (isWare)
			{
				compareValue = curEquipment;
			}
			else
			{
				compareValue = compareEquipment;
			}
			
			var diff:int;
			
			var x0:int = 140;
			var y0:int = 110;
			var dx:int = 0;
			var dy:int = 26;
			var index:int = 0;
			var value:String;
			for (i = 0; i < BASIC_STAT.length; i++)
			{
				if (obj[BASIC_STAT[i]] > 0)
				{
					txtF = ctn.AddLabel(Localization.getInstance().getString(BASIC_STAT[i]) + ":", x0 - 90, y0 + dy * index + 4, 0xFFF100, 0, 0x000000);
					tF = new TextFormat();
					tF.size = 12;
					tF.color = 0xffffff;
					tF.bold = true;
					txtF.setTextFormat(tF);
					if (obj.Color == 6)
					{
						ctn.AddImage("", "IcMax", 53, y0 + dy * index + 26).SetScaleXY(0.7);
					}
					if (totalPercent == 0)
					{
						value = Ultility.StandardNumber(obj[BASIC_STAT[i]]);
					}
					else
					{
						value = Ultility.StandardNumber(int(obj[BASIC_STAT[i]] * (1 + totalPercent / 100))) + " (+20%)";
					}
					txtF = ctn.AddLabel(value, x0 + dx * index, y0 + dy * index, 0xFFF100, 0, 0x000000);
					tF = new TextFormat();
					tF.size = 18;
					tF.color = color;
					tF.bold = true;
					txtF.setTextFormat(tF);
					
					if (!isWare)
					if (compareValue)
					{
						diff = obj[BASIC_STAT[i]] - compareValue[BASIC_STAT[i]];
						if (diff > 0)
						{
							ctn.AddImage("", "IcUpStat", x0 + dx * index + 50, y0 + dy * index + 7, true, ALIGN_LEFT_TOP);
							txtF = ctn.AddLabel(Math.abs(diff) + "", x0 + dx * index + 60, y0 + dy * index + 2, 0xFFF100, 0, 0x000000);
							tF = new TextFormat();
							tF.size = 13;
							tF.color = 0x00ff00;
							tF.bold = true;
							txtF.setTextFormat(tF);
						}
						else if (diff < 0)
						{
							ctn.AddImage("", "IcDownStat", x0 + dx * index + 50, y0 + dy * index + 7, true, ALIGN_LEFT_TOP);
							txtF = ctn.AddLabel(Math.abs(diff) + "", x0 + dx * index + 60, y0 + dy * index + 2, 0xFFF100, 0, 0x000000);
							tF = new TextFormat();
							tF.size = 13;
							tF.color = 0xff0000;
							tF.bold = true;
							txtF.setTextFormat(tF);
						}
					}
					index++;
				}
			}
			
			// Độ bền
			txtF = ctn.AddLabel("Độ bền:", x0 - 90, y0 + dy * index + 4, 0xFFF100, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			var cfg:Object = ConfigJSON.getInstance().GetEquipmentInfo(obj.Type, obj.Rank + "$" + obj.Color);
			txtF = ctn.AddLabel(Math.ceil(obj.Durability) + " / " + cfg.Durability, x0 + dx * index, y0 + dy * index, 0xFFF100, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 18;
			tF.color = color;
			if (obj.Durability <= 0)
			{
				tF.color = 0xff0000;
			}
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add cái chữ "Dùng cho"
			txtF = ctn.AddLabel("Dùng cho:", 52, 200, 0xffffff, 0, 0x000000);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add tên hệ (Kim mộc...)
			if (obj.Element != FishSoldier.ELEMENT_NONE)
			{
				txtF = ctn.AddLabel("Hệ " + Localization.getInstance().getString("Element" + obj.Element), 130, 195, 0x000000, 0, 0x000000);
			}
			else
			{
				txtF = ctn.AddLabel("Tất cả", 130, 195, 0x000000, 0, 0x000000);
			}
			tF = new TextFormat();
			tF.size = 18;
			tF.color = GetColorByElement(obj.Element);
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			index = 0;
			// Nếu đồ có option
			if (obj.bonus && obj.bonus[0])
			{
				// Các thuộc tính cộng thêm
				x0 = 50;
				y0 = 240;
				
				for (i = 0 ; i < obj.bonus.length; i++)
				{					
					for (s in obj.bonus[i])
					{
						if (obj.bonus[i][s] <= 0)	continue;
						txtF = ctn.AddLabel("Tăng " + Localization.getInstance().getString(s) + ":", x0 + dx * index, y0 + dy * index + 4, 0xFFF100, 0, 0x000000);
						tF = new TextFormat();
						tF.size = 12;
						tF.color = color;
						tF.bold = true;
						txtF.setTextFormat(tF);
						
						if (totalPercent == 0)
						{
							value = Ultility.StandardNumber(obj.bonus[i][s]);
						}
						else
						{
							value = Ultility.StandardNumber(int(obj.bonus[i][s] * (1 + totalPercent / 100))) + " (+20%)";
						}
					
						txtF = ctn.AddLabel(value, x0 + dx * index + 100, y0 + dy * index, 0xFFF100, 0, 0x000000);
						tF = new TextFormat();
						tF.size = 18;
						tF.color = color;
						tF.bold = true;
						txtF.setTextFormat(tF);
						index++;
						
						if (obj.Color == 6)
						{
							ctn.AddImage("", "IcMax", 45, y0 + dy * index + 1).SetScaleXY(0.7);
							if (ctn.GetImage("IcMax") == null)
							{
								ctn.AddImage("IcMax", "IcMax", 87, 45).SetScaleXY(0.7);
							}
						}
					}
				}
			}
			// Đường kẻ
			if (index > 0)
			{
				ctn.AddImage("", "LineCtnEquipmentInfo", 20, 232, true, ALIGN_LEFT_TOP);
			}
			ctn.GetImage("BG").img.height += index *30;
			showExtraInfo(obj, ctn);
		}
		
		private function showSealInfo(obj:FishEquipment, ctn:Container, activeRow:int = 0):void 
		{
			var config:Object = ConfigJSON.getInstance().GetItemList("Wars_Seal");
			config = config[obj["Rank"]][obj["Color"]];
			var colorName:String;
			
			// Add cái container thông tin cơ bản
			var i:int = 0;
			var txtFormat:TextFormat = new TextFormat("arial", 12, GetColorByEquipColor(obj.Color), true);
			for (var s:String in config)
			{
				var requireColor:int = obj["Color"];
				if (config[s]["Require"]["Color"] != null)
				{
					requireColor = config[s]["Require"]["Color"];
				}
				switch(requireColor)
				{
					case 3:
						colorName = "Quí Hiếm trở lên";
						break;
					case 4:
						colorName = "Thần trở lên";
						break;
					case 5:
					case 6:
						colorName = "VIP MAX";
						break;
				}
				var ctnObj:Container = ctn.AddContainer("", "CtnInfoEquipmentBaseSmall", 15, 110 + i * 60);
				var label:String = "Trang bị " + int(config[s]["Require"]["NumEquip"]) + " đồ " + colorName /*+ " cấp " + obj["Rank"] + " trở lên" */+ " + " + int(config[s]["Require"]["EnchantLevel"]);
				var txtGuide:TextField = ctnObj.AddLabel(label, 5, 0, 0xffffff, 0, 0x000000);				
				txtFormat.align = "center";
				txtGuide.setTextFormat(txtFormat);
				
				var x0:int = 10;
				var y0:int = 12;
				var dx:int = 110;
				var dy:int = 18;
				var index:int = 0;
				var txtLabel:TextField;
				var tF:TextFormat;
				var txtValue:TextField
				if (config[s]["TotalPercent"] == null)
				{
					for (var j:int = 0; j < BASIC_STAT.length; j++)
					{
						if (config[s][BASIC_STAT[j]] > 0)
						{
							txtLabel = ctnObj.AddLabel(Localization.getInstance().getString(BASIC_STAT[j]) + ":", x0, y0 + dy * index + 4, 0xFFF100, 0, 0x000000);
							tF = new TextFormat("arial", 11, 0xffffff, true);
							txtLabel.setTextFormat(tF);
							
							txtValue = ctnObj.AddLabel("+" + config[s][BASIC_STAT[j]], x0 + 50, y0 + dy * index, 0xFFF100, 0, 0x000000);
							tF = new TextFormat("arial", 14, GetColorByEquipColor(obj.Color), true);
							txtValue.setTextFormat(tF);
							
							txtLabel.x = x0 + Math.floor(index/2)*dx;
							txtLabel.y = y0 + 4 + dy * (index%2);
							txtValue.x = x0 + 60 + Math.floor(index/2)*dx;
							txtValue.y = y0 + dy * (index%2);
							
							index++;
						}
					}
				}
				else
				{
					txtLabel = ctnObj.AddLabel("Tất cả chỉ số trang bị đang mặc: ", x0, y0 + dy * index + 8, 0xFFF100, 0, 0x000000);
					tF = new TextFormat("arial", 11, 0xffffff, true);
					txtLabel.setTextFormat(tF);
					txtValue = ctnObj.AddLabel("+" + config[s]["TotalPercent"] + "%", x0 + 50 + 130, y0 + dy * index + 6, 0xFFF100, 0, 0x000000);
					tF = new TextFormat("arial", 14, GetColorByEquipColor(obj.Color), true);
					txtValue.setTextFormat(tF);
				}
				if( i < activeRow)
				{
					ctnObj.enable = true;
					TweenMax.to(ctnObj.img, 1, { glowFilter: { color:0x12D1FF, alpha:1, blurX:20, blurY:20, strength:1.5 }} );				
				}
				else
				{
					ctnObj.enable = false;
				}
				i++;
			}
			ctn.GetImage("BG").img.height += (i - 1) * 60 - 26;
			
			txtGuide = ctn.AddLabel("", 30,  174 + 60*(i-1), 0xffffff, 0, 0x000000);
			txtGuide.defaultTextFormat = txtFormat;
			txtGuide.htmlText = "<font size='12'>Dùng cho: </font><font size = '18'>       Tất cả</font>";
		}
		
		/**
		 * Show thông tin tổng quát lấy từ config (show trong shop)
		 * @param	obj
		 */
		public function ShowInfoAbstract(obj:Object, ctn:Container):void
		{
			var a:Array = obj.subtype.split("$");		// 0: Type, 1:Color
			
			var tF:TextFormat;
			var txtF:TextField;	
			
			var i:int;
			var s:String;
			
			var color:Object = GetColorByEquipColor(int(a[1]));
			
			// Nếu là đồ đặc biệt, quý thì cho cái nền khác			
			if (int(a[1]) != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				imag = AddImage("", FishEquipment.GetBackgroundName(int(a[1])), 12, 15, true, ALIGN_LEFT_TOP);
			}
			else
			{
				imag = AddImage("", "CtnEquipmentInfo", 12, 15, true, ALIGN_LEFT_TOP);
			}
			// Ảnh đồ
			var name:String = obj["type"] + a[0] + "_Shop";
			var imag:Image = AddImage("", name, 0, 0);
			imag.FitRect(55, 55, new Point(19, 23));
			FishSoldier.EquipmentEffect(imag.img, int(a[1]));
			
			// Tên, loại đồ (thường, quý...)
			txtF = AddLabel(Localization.getInstance().getString(obj.type + a[0]) + " - " + Localization.getInstance().getString("EquipmentColor" + a[1]) + " - Cấp " + int(int(a[0]) % 100), 85, 15, 0x000000, 0, 0x000000);
			txtF.wordWrap = true;
			txtF.width = 170;
			tF = new TextFormat();
			tF.size = 17;
			tF.color = color;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Loại trang bị (vũ khí, áo...)
			txtF = AddLabel("[" + Localization.getInstance().getString("Equipment" + obj.type) + "]", 85, 62, 0x000000, 0);
			tF = new TextFormat();
			tF.size = 15;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add cái container thông tin cơ bản
			AddImage("", "CtnInfoEquipmentBase", 15, 110, true, ALIGN_LEFT_TOP);
			
			var x0:int = 140;
			var y0:int = 110;
			var dx:int = 0;
			var dy:int = 26;
			var index:int = 0;
			for (i = 0; i < BASIC_STAT.length; i++)
			{
				if (obj[BASIC_STAT[i]] > 0 || obj[BASIC_STAT[i]] is Object)
				{
					txtF = AddLabel(Localization.getInstance().getString(BASIC_STAT[i]) + ":", x0 - 90, y0 + dy * index + 4, 0xFFF100, 0);
					tF = new TextFormat();
					tF.size = 12;
					tF.color = 0xffffff;
					tF.bold = true;
					txtF.setTextFormat(tF);
					if (obj["subtype"].split("$")[1] == 6)
					{
						AddImage("", "IcMax", 45 + 8, y0 + dy * index + 26).SetScaleXY(0.7);
					}
					if (getQualifiedClassName(obj[BASIC_STAT[i]]) == "Object")
					{
						if(obj[BASIC_STAT[i]].Min != obj[BASIC_STAT[i]].Max)
						{
							txtF = AddLabel(obj[BASIC_STAT[i]].Min + " - " + obj[BASIC_STAT[i]].Max, x0 + dx * index, y0 + dy * index, 0xFFF100, 0);
						}
						else
						{
							txtF = AddLabel(obj[BASIC_STAT[i]].Max, x0 + dx * index, y0 + dy * index, 0xFFF100, 0);
						}
					}
					else
					{
						txtF = AddLabel(obj[BASIC_STAT[i]], x0 + dx * index, y0 + dy * index, 0xFFF100, 0);
					}
					tF = new TextFormat();
					tF.size = 18;
					tF.color = color;
					tF.bold = true;
					txtF.setTextFormat(tF);
					
					index++;
				}
			}
			
			// Độ bền
			txtF = AddLabel("Độ bền:", x0 - 90, y0 + dy * index + 4, 0xFFF100, 0);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			txtF = AddLabel(obj.Durability + " / " + obj.Durability, x0 + dx * index, y0 + dy * index, 0xFFF100, 0);
			tF = new TextFormat();
			tF.size = 18;
			tF.color = color;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add cái chữ "Dùng cho"
			txtF = AddLabel("Dùng cho:", 52, 200, 0xffffff, 0);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add tên hệ (Kim mộc...)
			if (obj.Element != FishSoldier.ELEMENT_NONE)
			{
				txtF = AddLabel("Hệ " + Localization.getInstance().getString("Element" + obj.Element), 120, 195, 0x000000, 0);
			}
			else
			{
				txtF = AddLabel("Tất cả", 120, 195, 0x000000, 0);
			}
			tF = new TextFormat();
			tF.size = 18;
			tF.color = GetColorByElement(parseInt(obj.Element));
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			index = 0;
			// Các thuộc tính cộng thêm
			x0 = 50;
			y0 = ctn.img.height;
			
			var type:String = obj["type"];
			var colorEquip:int = obj["subtype"].split("$")[1];
			var rank:int = int(obj["subtype"].split("$")[0]) % 10;
			var increase:String;
			if (type=='Weapon' && colorEquip>=5)
                increase = 'Damage';
            else if ((type=='Armor'|| type=='Helmet' || type=='Belt' ) && colorEquip >=5)
                increase = 'Vitality';
            else if ((type=='Necklace'|| type=='Bracelet' ) && colorEquip >=5)
                increase = 'Defence';
            else if (type == 'Ring' && colorEquip == 6 && rank == 1)//Nhan long phung
                increase = 'Vitality';
            else if (type=='Ring' && colorEquip >=5)
                increase = 'Damage';         
				
			for ( i = 0; i < 5; i++)
			{					
				if(obj["Increase" + increase] != null)
				{
					txtF = ctn.AddLabel("Tăng " + Localization.getInstance().getString(increase) + ":" , x0 + dx * index, y0 + dy * index + 4, 0xffffff, 0, 0x000000);
					tF = new TextFormat();
					tF.size = 12;
					tF.color = color;
					tF.bold = true;
					txtF.setTextFormat(tF);
					
					if(colorEquip <= 5)
					{
						txtF = ctn.AddLabel(obj["Increase" + increase]["Min"] + " - " + obj["Increase" + increase]["Max"], x0 + dx * index + 100, y0 + dy * index, 0xFFF100, 0, 0x000000);
					}
					else
					{
						txtF = ctn.AddLabel(obj["Increase" + increase]["Max"], x0 + dx * index + 100, y0 + dy * index, 0xFFF100, 0, 0x000000);
						ctn.AddImage("", "IcMax", 45, y0 + dy * index + 26).SetScaleXY(0.7);
						if (i == 0)
						{
							this.AddImage("", "IcMax", 83, 43).SetScaleXY(0.7);
						}
					}
					tF = new TextFormat();
					tF.size = 18;
					tF.color = color;
					tF.bold = true;
					txtF.setTextFormat(tF);
					index++;
				}
			}
			ctn.GetImage("BG").img.height += index *30;
		}
		
		/**
		 * Đồ đạc có 4 màu: trắng, xanh, vàng, tím
		 * @param	color
		 * @return
		 */
		private function GetColorByEquipColor(color:int):Object
		{
			switch (color)
			{
				case FishEquipment.FISH_EQUIP_COLOR_WHITE:
					return 0xFFFFFF;
					break;
				case FishEquipment.FISH_EQUIP_COLOR_GREEN:
					return 0x00FF00;
					break;
				case FishEquipment.FISH_EQUIP_COLOR_GOLD:
					return 0xFFFF00;
					break;
				case FishEquipment.FISH_EQUIP_COLOR_PINK:
					return 0xff00cc;
					break;
				case FishEquipment.FISH_EQUIP_COLOR_VIP:
				case FishEquipment.FISH_EQUIP_COLOR_6:
					return 0xff9900;
					break;
				
			}
			return 0xFFFFFF;
		}
		
		private function GetColorByElement(element:int):Object
		{
			switch (element)
			{
				case FishSoldier.ELEMENT_METAL:
					return 0xFFFF00;
					break;
				case FishSoldier.ELEMENT_WOOD:
					return 0x82FF00;
					break;
				case FishSoldier.ELEMENT_EARTH:
					return 0xAA5614;
					break;
				case FishSoldier.ELEMENT_WATER:
					return 0x00FFE9;
					break;
				case FishSoldier.ELEMENT_FIRE:
					return 0xFF0000;
					break;
			}
			return 0xFFFFFF;
		}
	}

}