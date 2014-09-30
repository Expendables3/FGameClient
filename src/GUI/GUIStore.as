package GUI 
{
	import adobe.utils.CustomActions;
	import com.adobe.errors.IllegalStateError;
	import com.adobe.images.BitString;
	import com.greensock.loading.data.ImageLoaderVars;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.ResMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import Logic.BaseObject;
	import Logic.Decorate;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.StockThings;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendUseItem;
	/**
	 * ...
	 * @author ...
	 */
	public class GUIStore extends BaseGUI 
	{
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		private const GUI_STORE_BTN_FISH:String = "Fish";
		private const GUI_STORE_BTN_DECO:String = "Decorate";
		private const GUI_STORE_BTN_SPECIAL:String = "Special";
		private const GUI_STORE_BTN_MATERIAL:String = "Material";
		private const GUI_STORE_BTN_BABY_FISH:String = "BabyFish";
		private const GUI_STORE_BTN_SOLDIER:String = "Soldier";
		private const GUI_STORE_BTN_NEXT:String = "BtnNext";
		private const GUI_STORE_BTN_BACK:String = "BtnBack";
		private const GUI_STORE_BTN_SUPPORT:String = "Support";
		private const GUI_STORE_BTN_GEM:String = "Gem";
		private const BTN_EXTEND_DECO:String = "BtnExtendDeco";
		
		private const GUI_STORE_BTN_CLOSE:String = "Close";
		private const GUI_STORE_BTN_SAVE:String = "Save";
		
		// cac con tro toi button
		private var btnDeco:Button;
		private var btnSpecial:Button;
		//private var btnFish:Button ;
		//public var btnMaterial:Button;
		public var btnBabyFish:Button;
		//public var btnSoldier:Button;
		public var btnSaveDeco:Button;
		public var btnClose:Button ;
		public var btnExtendDeco:Button;
		public var btnSupport:Button;
		public var btnGem:Button;
		
		private var imgDeco:Image;
		private var imgSpecial:Image;
		//private var imgFish:Image ;
		//public var imgMaterial:Image;
		public var imgBabyFish:Image;
		//public var imgSoldier:Image;
		public var imgSaveDeco:Image;
		public var imgSupport:Image;
		public var imgGem:Image;
		
		
		// bien kiem tra xem gui da load xogn du lieu chua
		public var IsLoading:Boolean = true;
		public var isMultiClick:Boolean;
		public var isInitSoreOK:Boolean;		
		
		// cac tham so mac dinh
		//private static const LowY:int = -9;
		private static const LowY:int = -29;
		//private static const HighY:int = -9;
		private static const HighY:int = -29;
		private static const MaxSlot:int = 8;
		//private static const SlotX0:int = 48;
		private static const SlotX0:int = 58;
		//private static const SlotY0:int = 14;
		private static const SlotY0:int = 11;
		private static const SlotScale:Number = 1;
		private static const SlotDx:int = 17;
		
		public var CurrentPage:int = 0;
		public var CurrentStore:String = "Decorate";
		private var MaxPage:int = 1;
		
		public var curRecoverHealthItem:int;
		
		public var idGiftMagicBag:int = 0;
		
		public var curId:int = 0;
		//public var isProcessedMagicBag:Boolean = true;
		public var beginPosParticle:Point;
		
		private var arrDeco:Array;
		private var arrDataDeco:Array;
		public var curItemId:int;
		public var curRankPointBottleId:int;
		
		public function GUIStore(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{			
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIStore"
			LastX = 4;
			LastY = Constant.STAGE_HEIGHT - 105;
		}
		
		public override function InitGUI(): void
		{
			LoadRes("ImgBgGUIStore");
			img.addChild(WaitData);
			WaitData.x = 400;
			WaitData.y = 40;
			
			isMultiClick = false;
			
			GuiMgr.getInstance().GuiMain.HideAllToolButton(true);
			IsLoading = true;
			var icon:Sprite = ResMgr.getInstance().GetRes( "ImgBgGUIStore") as Sprite;
			var w:int = icon.width ;
			var h:int = icon.height;
			btnClose = AddButton(GUI_STORE_BTN_CLOSE, "BtnCloseStore", w - 85, -32, this);
			UpdateAllPos();
			
			isHavePrg = false;
			curprgProcessing = null;
			curimgPrgProcessing = null;
			btnID = "MagicBag";
			isInitSoreOK = false;
		}
		
		public override function OnHideGUI():void
		{
			GameController.getInstance().blackHole.img.visible = false;
			if (GuiMgr.getInstance().GuiMain.IsVisible)
			{
				GuiMgr.getInstance().GuiMain.img.visible = true;
				GuiMgr.getInstance().GuiMain.imgBgLake.img.visible = true;
			}
			if (!GameLogic.getInstance().user.IsViewer())
			{
				GameLogic.getInstance().BackToIdleGameState();
			}
			GameController.getInstance().UseTool("Default");
			
			//khong hien info cua ca trong ho
			if (!GameLogic.getInstance().user.IsViewer())
			{
				GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
			}
			GuiMgr.getInstance().GuiMain.ShowLakes();
			
			GuiMgr.getInstance().GuiMain.HideAllToolButton(GameLogic.getInstance().user.IsViewer());
			GuiMgr.getInstance().GuiMain.UpdateAllPos(GameLogic.getInstance().user.IsViewer());
			//Hủy particle khi mở túi
			while (GameLogic.getInstance().emitStar[0])
			{
				GameLogic.getInstance().emitStar[0].destroy();
				GameLogic.getInstance().emitStar.splice(0, 1);
			}		
		}
		
		public function UpdateInfo():void
		{
			
		}
		
		private function InitStoreButton():void
		{	
			var icon:Sprite = ResMgr.getInstance().GetRes( "ImgBgGUIStore") as Sprite;
			var w:int = icon.width ;
			var h:int = icon.height;
				
			// cac tab
			btnDeco = AddButton(GUI_STORE_BTN_DECO, "BtnTabTrangTri", 170 - 120, LowY, this);
			btnSpecial = AddButton(GUI_STORE_BTN_SPECIAL, "BtnTabDacbiet", 280 - 120, LowY, this, "InventorySpecial");
			btnBabyFish = AddButton(GUI_STORE_BTN_BABY_FISH, "BtnTabBabyFish", 390 - 120, LowY, this, "BabyFishSoldier");
			btnSupport = AddButton(GUI_STORE_BTN_SUPPORT, "BtnTabSupport", 500 - 120, LowY, this, "SupportTab");
			btnGem = AddButton(GUI_STORE_BTN_GEM, "BtnTabGem", 610 - 120, LowY, this, "GemTab");
			
			//Button gia han do trang tri
			btnExtendDeco = AddButton(BTN_EXTEND_DECO, "Btn_Extend_Deco", 610 + 49 - 50, LowY - 5);
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = "Gia hạn đồ trang trí";
			btnExtendDeco.setTooltip(tooltip);
			if (CurrentStore != "Decorate")
			{
				btnExtendDeco.SetVisible(false);
			}
			else
			{
				btnExtendDeco.SetVisible(true);
			}
			
			imgDeco = AddImage(GUI_STORE_BTN_DECO, "ImgTabTrangTri", 170 + 49 - 120, LowY + 15);
			imgSpecial = AddImage(GUI_STORE_BTN_SPECIAL, "ImgTabDacbiet", 280 + 49 - 120, LowY + 15);
			imgBabyFish = AddImage(GUI_STORE_BTN_BABY_FISH, "ImgTabBabyFish", 390 + 49 - 120, LowY + 15);
			imgSupport = AddImage(GUI_STORE_BTN_SUPPORT, "ImgTabSupport", 500 + 49 - 120, LowY + 15);
			imgGem = AddImage(GUI_STORE_BTN_GEM, "ImgTabGem", 610 + 49 - 120, LowY + 15);
			
			imgDeco.img.visible = false;
			imgSpecial.img.visible = false;
			imgBabyFish.img.visible = false;
			imgSupport.img.visible = false;
			imgGem.img.visible = false;
			
			// them button close
			var HasCloseBtn:Boolean = false;
			if ((btnClose != null) && (btnClose.img != null) && (btnClose.img.parent != null))
			{
				HasCloseBtn = true;
			}
			if (!HasCloseBtn)
			{
				btnClose = AddButton(GUI_STORE_BTN_CLOSE, "BtnCloseStore", w - 85, -32, this);
			}

			btnSaveDeco = AddButton(GUI_STORE_BTN_SAVE, "BtnSaveDeco", w - 90, 0, this);
			btnSaveDeco.TooltipText = Localization.getInstance().getString("Tooltip8");
			btnSaveDeco.SetVisible(false);
			UpdateCurrentTab(CurrentStore);
			
			var btnNext:Button = AddButton(GUI_STORE_BTN_NEXT, "BtnNext", 765, 45, this);
			var btnBack:Button = AddButton(GUI_STORE_BTN_BACK, "BtnPrev", 8, 45, this);
			
			if (MaxPage > 1)
			{
				if (CurrentPage == 0)
				{
					btnBack.SetDisable();
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetDisable();
				}
			}
			else
			{
				btnBack.SetDisable();
				btnNext.SetDisable();
			}
			
			if (GameLogic.getInstance().user.IsViewer())
			{
				btnDeco.SetEnable(false);
				btnSpecial.SetEnable(false);
				btnBabyFish.SetEnable(false);
				btnExtendDeco.SetEnable(false);
			}
		}
		
		public function InitStoreSlot(nSlot:int):void
		{
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotStore") as Sprite;
			var w:int = icon.width * SlotScale;
			var h:int = icon.height * SlotScale;
			
			var i:int;
			var container:Container;
			for (i = 0; i < nSlot; i++)
			{
				if (i >= MaxSlot)
				{
					break;
				}
				container = AddContainer("", "CtnSlotStore", SlotX0 + i * w + i * SlotDx, SlotY0, true, this);
				container.SetScaleX(SlotScale);
				container.SetScaleY(SlotScale);
			}
		}
		
		public function RefreshComponent():void
		{
			ClearComponent();
			updateStateForMagicBag();
			if(GameLogic.getInstance().user.IsViewer())
			{
				CurrentStore = "Support";
			}
			InitStore(CurrentStore, CurrentPage);
		}
		
		public function InitStore(Type:String, page:int):void
		{
			var i:int;
			
			// xoa hinh loading
			if (WaitData.parent == img)
			{
				img.removeChild(WaitData);
			}
			
			CurrentStore = Type;
			
			// lay danh sach cac slot
			var ItemList:Array = GameLogic.getInstance().user.GetStore(Type);
			
			// Nếu là kho Gem thì lược bớt Phế và Tán không show ra
			if (Type == "Gem")
			{
				for (i = ItemList.length - 1; i >= 0; i--)
				{
					var GemType:int = int(ItemList[i].ItemType.split("$")[2]);
					if (ItemList[i].Id <= 0 || GemType == 0)
					{
						ItemList.splice(i, 1);
					}
				}
			}
			
			if(Type == GUI_STORE_BTN_MATERIAL) 		ItemList.sortOn("Id", Array.NUMERIC);
			if (ItemList.length <= 0)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 30, 0x707070);
				var txt:TextField = AddLabel(Localization.getInstance().getString("GUILabel1") , 360, 30);
				txt.setTextFormat(txtFormat);
			}
			
			// so page toi da
			MaxPage = Math.ceil(ItemList.length / MaxSlot);
			CurrentPage = page;
			InitStoreButton();
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}
			
			// them cac thanh phan GUI
			var vt:int = CurrentPage * MaxSlot;//Tổng số slot của n-1 trang trước
			var nItem:int = MaxSlot;//Số slot lẻ ra ở trang hiện tại
			if (vt + nItem >= ItemList.length)
			{
				nItem = ItemList.length - vt;
			}
			InitStoreSlot(nItem);
			
			var nonSpartaNum:int = ItemList.length - GameLogic.getInstance().user.StockThingsArr.numSparta; // Số cá không phải là sparta
			// them cac hinh anh vao
			
			var obj:Object;
			arrDeco = [];
			arrDataDeco = [];
			var numNormalFish:int = 0;
			for (i = vt; i < vt + nItem; i++)
			{			
				var container:Container = ContainerArr[i - vt] as Container;	
				if (Type == "BabyFish" && ItemList[i].FishType != Fish.FISHTYPE_SOLDIER)
				{
					numNormalFish++;
					if (i < nonSpartaNum)
					{
						container.IdObject = "Use_Fish_" + ItemList[i][ConfigJSON.KEY_ID];
						DrawBabyFish(container, ItemList[i], ItemList[i]["Num"]);
					}
					else 
					{
						container.IdObject = "Use_Fish_" + ItemList[i][ConfigJSON.KEY_ID] + "_" + ItemList[i]["Name"];
						DrawBabyFishSparta(container, ItemList[i], ItemList[i]["Num"]);
					}
				}
				else if (ItemList[i]["FishType"] == Fish.FISHTYPE_SOLDIER)
				{
					container.IdObject = "Use_FishSoldier_" + ItemList[i][ConfigJSON.KEY_ID];
					DrawBabyFish(container, ItemList[i], ItemList[i]["Num"]);
				}
				else
				{					
					if (Type != "Decorate")
					{
						var st:StockThings = new StockThings();
						st.SetInfo(ItemList[i]);
						obj = ConfigJSON.getInstance().getItemInfo(st.ItemType, st.Id);
						container.IdObject = "Use_" + obj["type"] + "_"  + obj[ConfigJSON.KEY_ID];
						DrawItem(container, obj, st.Num);
					}
					//Vẽ đồ trang trí với hạn
					else
					{
						container.IdObject = "Use_" + ItemList[i]["ItemType"] + "_"  + ItemList[i]["ItemId"] + "_" + ItemList[i]["Id"];
						drawDecoItem(container, ItemList[i]);
					}
				}				
			}
			
			if (GameLogic.getInstance().CanSaveDecorate())
			{
				btnSaveDeco.SetVisible(true);
			}
			else
			{
				btnSaveDeco.SetVisible(false);
			}
			
			IsLoading = false;
			isInitSoreOK = true;
		}
		
		private function drawDecoItem(container:Container, data:Object):void 
		{
			//fix du lieu
			var fmt:TextFormat;
			var config:Object = ConfigJSON.getInstance().getItemInfo(data["ItemType"], data["ItemId"]);
			var imgName:String = data["ItemType"] + data["ItemId"];
			var image:Image = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
			switch(data["ItemType"])
			{
				case "OceanAnimal":
					image.GoToAndStop(2);
					break;
				case "BackGround":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					var btn:Button = container.AddButton("Use_" + data["ItemType"] + "_" + data["ItemId"] + "_" + data[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
					btn.img.width = 48;
					btn.img.height = 24;
					container.AddLabel("Dùng", -17, 65).setTextFormat(fmt);
					break;
			}
			
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotStore") as Sprite;
			var w:int = icon.width * SlotScale - 10;
			var h:int = icon.height * SlotScale - 10;
			image.FitRect(w, h, new Point(5, 5));
			
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var tooltip:TooltipFormat = new TooltipFormat();
			fmt = new TextFormat();			
			fmt.color = 0x000000;		
			var nDay:int = Math.max(0, Math.ceil((data["ExpiredTime"] - curTime) / (24 * 3600)));	
			
			//tooltip
			if (data.ItemType == "PearFlower")
			{
				var name:String = Localization.getInstance().getString(data.ItemType + data.ItemId);
				var expiredTime:String = "Thời hạn còn " + nDay + " ngày";
				expiredTime = name + "\n" + expiredTime;
				var st:String = expiredTime;
				
				if (data.Option && (data.Option.Exp > 0 || data.Option.Money > 0 || data.Option.Time > 0))
				{
					if (data.Option.Money && data.Option.Money > 0)
					{
						var bufMoney:String = "Tiền vàng: " + data.Option.Money + "%";
						st = st + "\n" + bufMoney;
					}
					if (data.Option.Exp && data.Option.Exp > 0)
					{
						var bufExp:String = "Kinh nghiệm: " + data.Option.Exp + "%";
						st = st + "\n" + bufExp;
					}
					if (data.Option.Time && data.Option.Time > 0)
					{
						var bufTime:String = "Thời gian: " + data.Option.Time + "%";
						st = st + "\n" + bufTime;
					}
				}
				
				fmt.align = TextFormatAlign.CENTER;
				fmt.size = 14;
				fmt.bold = true;
				fmt.color = "0xff33ff";
				tooltip.text = st;
				tooltip.setTextFormat(fmt, 0, name.length);
				fmt.size = 12;
				fmt.bold = false;
				fmt.color = "0x3333ff";
				tooltip.setTextFormat(fmt, name.length, expiredTime.length);					
				container.setTooltip(tooltip);		
				fmt.size = 12;
				fmt.bold = false;
				fmt.color = "0x000000";
				tooltip.setTextFormat(fmt, expiredTime.length, tooltip.text.length);					
				container.setTooltip(tooltip);		
			}	
			else
			{

				if (nDay < 365 * 4)
				{
					tooltip.text = config["Name"] + "\nThời hạn còn " + nDay + " ngày";
				}
				else //Tren 4 năm thì coi như vô hàn
				{
					tooltip.text = config["Name"] + "\nThời hạn: vô hạn";
				}
				container.setTooltip(tooltip);
			}
			
			if (curTime > data["ExpiredTime"])
			{
				container.AddImage("", "IconExpired", 60, 10);
				data["isExpired"] = true;
			}
			else
			{
				data["isExpired"] = false;
			}
			
			arrDeco.push(container);
			arrDataDeco.push(data);
		}
		
		private function DrawItem(container:Container, obj:Object, num:int):void
		{
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotStore") as Sprite;
			var w:int = icon.width * SlotScale - 10;
			var h:int = icon.height * SlotScale - 10;
			var img1:Image;
			var st:String ;
			var tooltip:TooltipFormat;
			var fmt:TextFormat;
			var str:String ;
			var _format:TextFormat ;
			_format = new TextFormat();
			_format.color = 0xFF0000;
			_format.size = 14;
			_format.bold = true;
			var iEnd:int;
			switch (obj["type"])
			{
				case "FishGift":
				case "Fish":
					img1 = DrawFish(container, obj, num);
					img1.FitRect(w, h - 10, new Point(5, 5));
					break;
				case "EnergyItem":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					if (obj[ConfigJSON.KEY_ID] != 6)
					{
						st = Localization.getInstance().getString("Tooltip12");
						st = st.replace("@Energy", obj["Num"]);
					}
					else
					{
						st=Localization.getInstance().getString("Tooltip61");
					}
					st = obj[ConfigJSON.KEY_NAME] + st;
					tooltip = new TooltipFormat();
					tooltip.text = st;
					var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
					var len:int = st.length;
					
					if (GameLogic.getInstance().user.GetEnergy() >= maxEnergy)
					{		
						var txtFormatMat:TextFormat = new TextFormat();				
						txtFormatMat.bold = true;
						txtFormatMat.color = 0xff0000;
						st += "\n" + Localization.getInstance().getString("Tooltip28");
						tooltip.text = st;
						tooltip.setTextFormat(txtFormatMat, len, st.length);
					}
					container.setTooltip(tooltip);
					break;
				}
				case "Arrow":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
				break;
				case "License":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					st = obj[ConfigJSON.KEY_NAME] + "\nĐể mở rộng hoặc mua hồ";
					tooltip.text = st;
					container.setTooltip(tooltip);
					break;
				}
				case "GiftTicket":
				case "Event_8_3_Flower":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					st = obj[ConfigJSON.KEY_NAME];
					tooltip.text = st;
					tooltip.setTextFormat(_format);
					container.setTooltip(tooltip);
					break;
				}
				case "Draft":
				case "GoatSkin":
				case "Blessing":
				case "Paper":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					break;
				}
				case "Medicine":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					st = obj[ConfigJSON.KEY_NAME] + "\nGiảm thời gian phát triển của cá\n(Chưa dùng)";
					tooltip.text = st;
					fmt = new TextFormat()
					fmt.color = 0xff0000;
					tooltip.setTextFormat(fmt, st.indexOf("("), st.indexOf(")") + 1);
					container.setTooltip(tooltip);
					break;
				}
				case "Material":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					st = Localization.getInstance().getString("Tooltip11");
					if (obj["Id"] %100 <= 10)
					{
						st += "\n" + Localization.getInstance().getString("Tooltip30");
						if (obj.Id % 100 >= 6)
						{
							st += "\n" + "hoặc dùng trực tiếp cho cá";
						}
					}
					st = st.replace("@Level", obj["Id"]);
					tooltip = new TooltipFormat();
					tooltip.text = st;
					container.setTooltip(tooltip);
					break;
				}
				//hiepnm2
				case "Petrol":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					str = "Hãy đổ xăng vào máy gia tăng giới hạn năng lượng";
					st = obj[ConfigJSON.KEY_NAME] + "\n" + str;
					tooltip.text = st;
					fmt = new TextFormat();
					fmt.color = 0xff0000;
					tooltip.setTextFormat(fmt, st.indexOf(str), st.indexOf(str) + str.length);
					container.setTooltip(tooltip);
					break;
				};
				case "RankPointBottle":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					var info:Object = ConfigJSON.getInstance().getItemInfo("RankPointBottle", obj[ConfigJSON.KEY_ID]);
					var numRank:int = info["Num"];
					var day:int = (int)((info["TimeUse"]) / 86400);
					str = "Tăng " + numRank.toString() + " điểm chiến công cho ngư thủ";
					st = obj[ConfigJSON.KEY_NAME] + "\n" + str;
					tooltip.text = st;
					iEnd = tooltip.text.search("\r");
					tooltip.setTextFormat(_format, 0, iEnd);
					container.setTooltip(tooltip);
					break;
				};
				
				case "Viagra":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					str = "Giúp cá đã lai có thể lai thêm lần nữa\nMỗi cá chỉ sử dụng được 1 lọ / ngày";
					st = obj[ConfigJSON.KEY_NAME] + "\n" + str;
					tooltip.text = st;
					fmt = new TextFormat();
					fmt.color = 0xff0000;
					tooltip.setTextFormat(fmt, st.indexOf(str), st.indexOf(str) + str.length);
					container.setTooltip(tooltip);
					break;
				}
				case "Ginseng":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString(obj["type"] + obj["Id"]);
					tooltip.text = tooltip.text.replace("@Value@", int(obj.Expired / (3600 * 24)) + "");
					container.setTooltip(tooltip);
					break;
					break;
				case "RecoverHealthSoldier":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString(obj["type"] + obj["Id"]);
					tooltip.text = tooltip.text.replace("@Value@", obj.Num + "");
					container.setTooltip(tooltip);
					break;
				case "Samurai":
				case "BuffExp":
				case "BuffMoney":
				case "BuffRank":
				case "StoreRank":
				case "Resistance":
				case "Dice":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString(obj["type"] + obj["Id"]);
					tooltip.text = tooltip.text.replace("@Value@", obj.Num + "");
					container.setTooltip(tooltip);
					break;
				case "RebornMedicine":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					st = Localization.getInstance().getString("Tooltip54");
					var sReplace:String = ConfigJSON.getInstance().GetTimeReborn2(obj["Id"]);
					st = st.replace("@Time", sReplace);
					st = st.replace("@Time", sReplace);
					tooltip.text = st;
					iEnd = tooltip.text.search("\r");
					tooltip.setTextFormat(_format, 0, iEnd);
					container.setTooltip(tooltip);
					break;
				}
				case "MagicBag":
				{
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					st = GUIFishMachine.GetTooltipMagicBag(obj["Id"], 1);
					tooltip = new TooltipFormat();
					tooltip.text = st;
					iEnd = tooltip.text.search("\r");
					tooltip.setTextFormat(_format, 0, iEnd);
					container.setTooltip(tooltip);
					break;
				}
				case "MazeKey":
					
				break;
				case "Firework":
					img1 = DrawFish(container, obj, num);
					img1.FitRect(w, h - 10, new Point(5, 5));
					break;
				case "IconChristmas":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString(obj["type"] + obj["ItemId"]);
					container.setTooltip(tooltip);
					break;
				case "Sock":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					tooltip.text = "Tất Noel";
					container.setTooltip(tooltip);
					break;
				case "ItemCollection":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString("ItemCollection" + obj["Id"]);
					container.setTooltip(tooltip);
					break;
				case "HerbPotion":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString("HerbPotion" + obj["Id"]) + "\n(Sử dụng cho Ngư Thủ)";
					container.setTooltip(tooltip);
					break;
				case "BirthDayItem":
				{
					if (obj[ConfigJSON.KEY_ID] != 14)
					{
						img1 = DrawOther(container, obj);
						img1.FitRect(w, h, new Point(5, 5));
						tooltip = new TooltipFormat();
						tooltip.text = obj[ConfigJSON.KEY_NAME];
						container.setTooltip(tooltip);
					}
				}
				break;
				default:
					if (obj["type"].search("Gem") != -1)
					{
						img1 = DrawOther(container, obj);
						img1.FitRect(w - 5, h - 5, new Point(10, 5));
						tooltip = new TooltipFormat();
						var aa:Array = obj["type"].split("$");
						str = Localization.getInstance().getString(aa[0] + aa[1]);
						str = str.replace("@Type@", Localization.getInstance().getString("GemType" + aa[2]));
						str = str.replace("@Rank@", "cấp " + aa[2]);
						var config:Object = ConfigJSON.getInstance().GetItemList("Gem");
						var value:int = config[aa[2]][aa[1]];
						str = str.replace("@value@", String(value));
						str = str.replace("@day@", obj["Id"]);
						tooltip.text = str;
						container.setTooltip(tooltip);
						break;
					}
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(5, 5));
					// tooltip
					tooltip = new TooltipFormat();
					tooltip.text = obj[ConfigJSON.KEY_NAME];
					container.setTooltip(tooltip);
					break;
				}
			
			var txtFormat:TextFormat = new TextFormat("Arial", 16);
			var txt:TextField = container.AddLabel(num.toString(), 3, 2, 0xFFFFFF, 0, 0x26709C);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat(txtFormat);
		}
		
		private function DrawOther(container:Container, obj:Object):Image
		{
			var img1:Image;
			var imgName:String;
			var fmt:TextFormat = new TextFormat();
			imgName = getImgName(obj);
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
			
			var btn:Button;
			switch (obj["type"])
			{
				case "OceanAnimal":
					img1.GoToAndStop(2);
					break;
				case "MixLake":
					break;
				case "EnergyItem":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this, "Use_Energy");
					btn.img.width = 48;
					btn.img.height = 24;
					container.AddLabel("Dùng", -17, 65).setTextFormat(fmt);
					break;
				case "Material":
					if (int(obj[ConfigJSON.KEY_ID]) % 100 > 5)
					{
						fmt = new TextFormat();
						fmt.bold = true;
						fmt.color = 0x000000;
						if (obj.Id == "8")
						{
							btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this, "Use_Material");
						}
						else 
						{
							btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
						}
						btn.img.width = 48;
						btn.img.height = 24;
						container.AddLabel("Dùng", -17, 65).setTextFormat(fmt);
					}
					break;
				case "Medicine":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
					btn.img.width = 48;
					btn.img.height = 24;
					container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
					btn.SetDisable();
					break;
				//hiepnm2
				//case "Lixi":
				case "Petrol":
				case "RankPointBottle":
				case "RebornMedicine":
				case "Viagra":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
					btn.img.width = 48;
					btn.img.height = 24;
					//if (obj["type"] == "Lixi")
						//container.AddLabel("Mở", -15, 63).setTextFormat(fmt);
					//else
						container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
					
					break;
				case "MagicBag":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
					btn.img.width = 48;
					btn.img.height = 24;
					container.AddLabel("Mở", -15, 63).setTextFormat(fmt);
					var imgPrgProcessing:Image;
					var prgProcessing:ProgressBar;
					imgPrgProcessing = container.AddImage("img_"+obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "ImgTimePgr", -30, -20, true, ALIGN_LEFT_TOP);
					prgProcessing = container.AddProgress("prg_"+obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "PrgFood", imgPrgProcessing.img.x + 34,  imgPrgProcessing.img.y + 8, this);
					prgProcessing.setStatus(0);	
					imgPrgProcessing.img.visible = false;
					prgProcessing.img.visible = false;
					break;
				case "RecoverHealthSoldier":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this, "Use_RecoverHealthSoldier");
					btn.img.width = 48;
					btn.img.height = 24;
					container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
					break;
				case "HerbPotion":
				case "Samurai":
				case "Resistance":
				case "StoreRank":
				case "Ginseng":
					fmt = new TextFormat();
					fmt.bold = true;
					fmt.color = 0x000000;
					btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
					btn.img.width = 48;
					btn.img.height = 24;
					container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
					break;
				case "BuffRank":
				case "BuffExp":
				case "BuffMoney":				
				case "Dice":
					break;
				default:
					var a:Array = obj["type"].split("$");
					if (a[0] == "Gem" && int(a[2]) != 0 && obj["Id"] != 0)
					{
						fmt = new TextFormat();
						fmt.bold = true;
						fmt.color = 0x000000;
						btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this, "Use_Gem");
						btn.img.width = 48;
						btn.img.height = 24;
						container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
						break;
					}
					break;
			}
			return img1;
		}
		
		private function getImgName(obj:Object): String
		{
			var image_Name_return:String = obj["type"] + obj[ConfigJSON.KEY_ID];
			switch (obj["type"])
			{
				// Dùng cho các loại công thức lai
				case "Draft":
				case "GoatSkin":
				case "Blessing":
				case "Paper":
					return obj["type"] + "_" + obj["Elements"];
				default:
					if (obj["type"] == GUI_STORE_BTN_MATERIAL) 
					{
						var typeMat:int = obj[ConfigJSON.KEY_ID];
						if (typeMat > 100)
						{
							image_Name_return = obj["type"] + (typeMat%100).toString() + "S";
						}
					}
					else if (obj["type"].search("Gem") != -1)
					{
						var a:Array = obj["type"].split("$");
						image_Name_return = "Gem_" + a[1] + "_" + a[2];
					}					
					return image_Name_return;
			}
		}
		
		private function DrawFishSparta(container:Container, obj:Object, num:int):Image
		{
			var img1:Image;
			var imgName:String;
			imgName = obj["type"] + obj[ConfigJSON.KEY_ID] + "_Old_Idle";
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
			img1.GoToAndStop(0);
			
			// nut ban
			var st:String;
			var tooltip:TooltipFormat = new TooltipFormat();
			var fmt:TextFormat = new TextFormat();			
			fmt.color = 0x000000;
			container.IdObject = "Sell_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID];
			var btn:Button = container.AddButton("Sell_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "BtnRed", 10, 85, this);
			btn.img.scaleX = btn.img.scaleY = 0.5;
			container.AddLabel("Bán", -15, 66).setTextFormat(fmt);
			
			//tooltip
			var nMoney:int = obj["Money"] * num;		
			var name:String = obj[ConfigJSON.KEY_NAME];
			var giaban:String = Localization.getInstance().getString("Tooltip10") + nMoney;
			st = name + "\n" + giaban;
			tooltip.text = st;
			fmt.align = TextFormatAlign.CENTER;
			fmt.size = 14;
			fmt.bold = true;
			tooltip.setTextFormat(fmt, 0, name.length);
			fmt.size = 12;
			fmt.bold = false;					
			tooltip.setTextFormat(fmt, name.length, st.length);
			container.setTooltip(tooltip);

			return img1;
		}
		
		private function DrawFish(container:Container, obj:Object, num:int):Image
		{
			var img1:Image;
			var imgAttack:Image;
			var imgName:String;
			var imgNameAttack:String;
			var domain:int = -1;
			if(obj[ConfigJSON.KEY_ID] < Constant.FISH_TYPE_START_DOMAIN)
			{
				imgName = obj["type"] + obj[ConfigJSON.KEY_ID] + "_" + Fish.OLD + "_" + Fish.IDLE;
			}
			else 
			{
				if(obj[ConfigJSON.KEY_ID] < Constant.FISH_TYPE_START_SOLDIER)
				{
					domain = (obj[ConfigJSON.KEY_ID] - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
					imgName = obj["type"] + (obj[ConfigJSON.KEY_ID] - domain) + "_" + Fish.OLD + "_" + Fish.IDLE;
					imgNameAttack = Fish.DOMAIN + domain;
				}
				else 
				{
					imgName = obj["type"] + obj[ConfigJSON.KEY_ID] + "_" + Fish.OLD + "_" + Fish.IDLE;
				}
			}
			
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
			img1.GoToAndStop(0);
			
			if (domain > 0)
			{
				imgAttack = container.AddImage("", imgNameAttack, 30, 0, true, ALIGN_LEFT_TOP);
				imgAttack.FitRect(20, 20);
			}
			// nut ban
			var st:String;
			var tooltip:TooltipFormat = new TooltipFormat();
			var fmt:TextFormat = new TextFormat();			
			fmt.color = 0x000000;
			container.IdObject = "Sell_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID];
			var btn:Button = container.AddButton("Sell_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "BtnRed", 10, 85, this);
			btn.img.scaleX = btn.img.scaleY = 0.5;
			container.AddLabel("Bán", -15, 66).setTextFormat(fmt);
			
			//tooltip
			var nMoney:int = obj["Money"] * num;		
			//var nMoney:int = obj["gold"] * num;
			var name:String = obj[ConfigJSON.KEY_NAME];
			var giaban:String = Localization.getInstance().getString("Tooltip10") + nMoney;
			st = name + "\n" + giaban;
			tooltip.text = st;
			fmt.align = TextFormatAlign.CENTER;
			fmt.size = 14;
			fmt.bold = true;
			tooltip.setTextFormat(fmt, 0, name.length);
			fmt.size = 12;
			fmt.bold = false;					
			tooltip.setTextFormat(fmt, name.length, st.length);
			container.setTooltip(tooltip);

			return img1;
		}
		
		public function OptionTooltip(option: String): String
		{
			switch(option)
			{
				case "Time":
					return "Giảm thời gian: ";
				case "Money":
					return "Tăng tiền: ";
				case "Exp":
					return "Tăng exp: ";
				case "MixFish":
					return "Tăng lai ra cá quý: ";					
				case "MixSpecial":
					return "Tăng lai ra cá đặc biệt: "
				default:
					return option;
			}
		}
		
		private function DrawBabyFish(container:Container, obj:Object, num: int):Image
		{
			var img1:Image;
			var imgAttack:Image;
			var imgName:String;
			var imgNameAttack:String;
			var domain:int = -1;
			if(obj["FishTypeId"] < Constant.FISH_TYPE_START_DOMAIN)
			{
				imgName = "Fish" + obj["FishTypeId"] + "_Baby_Idle";
			}
			else 
			{
				if(obj["FishTypeId"] < Constant.FISH_TYPE_START_SOLDIER)
				{
					domain = (obj["FishTypeId"] - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
					imgName = "Fish" + (obj["FishTypeId"] - domain) + "_Baby_Idle";
					imgNameAttack = Fish.DOMAIN + domain;
				}
				else 
				{
					imgName = "Fish" + obj["FishTypeId"] + "_Old_Idle";
				}
			}
			
			//nut dùng
			var st:String;
			var tooltip:TooltipFormat = new TooltipFormat();
			var fmt:TextFormat;
			fmt = new TextFormat();			
			fmt.color = 0x000000;			
			var btn:Button;
			
			var name:String;	
			var money:String;
			var exp:String;
			var havestTime:String;
				
			if (obj["FishTypeId"] < Constant.FISH_TYPE_START_SOLDIER)
			{
				var info:Object = ConfigJSON.getInstance().getItemInfo("Fish", obj["FishTypeId"]);
				name = info[ConfigJSON.KEY_NAME];	
				money = Localization.getInstance().getString("GUILabel3") + Math.round(info["MaxValue"]);
				exp = Localization.getInstance().getString("GUILabel4") + info["Exp"];
				havestTime = Localization.getInstance().getString("GUILabel2") + info["Growing"][5] / 3600 + "h";
				st = name + "\n" + havestTime + "\n" + money + "\n" + exp;
			}
			else
			{
				name = "Ngư thủ";	
				money = "Lực chiến: " + obj["Damage"];
				exp = "Danh hiệu: " + Localization.getInstance().getString("FishSoldierRank" + obj["Rank"]);
				exp += "\nSố sao: " + Ultility.getStarByReceiptType(obj["RecipeType"]["ItemType"]);
				havestTime = "";
				st = name + "\n" + money + "\n" + exp;
			}
			
			fmt.align = TextFormatAlign.CENTER;
			fmt.size = 14;
			fmt.bold = true;
			
			var s: String;
			switch (obj["FishType"])
			{
				case Fish.FISHTYPE_SPECIAL:
					fmt.color = "0x3333ff";
					for (s in obj["RateOption"])
					{
						st += "\n" + OptionTooltip(s) + obj["RateOption"][s]  + "%";
					}
				break;
				case Fish.FISHTYPE_RARE:
					fmt.color = "0xff33ff";
					for (s in obj["RateOption"])
					{
						st += "\n" + OptionTooltip(s) + obj["RateOption"][s] + "%";
					}
				break;
			}
			tooltip.text = st;
			tooltip.setTextFormat(fmt, 0, name.length);
			fmt.size = 12;
			fmt.bold = false;
			fmt.color = "0x000000";
			tooltip.setTextFormat(fmt, name.length, tooltip.text.length);					
			container.setTooltip(tooltip);			
			
			//Số lượng cá
			var txtFormat:TextFormat = new TextFormat("Arial", 16);
			var txt:TextField = container.AddLabel(num.toString(), 3, 2, 0xFFFFFF, 0, 0x26709C);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat(txtFormat);
			
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);		
			if (domain > 0)
			{
				imgAttack = container.AddImage("", imgNameAttack, 30, 0, true, ALIGN_LEFT_TOP);
				imgAttack.FitRect(20, 20);
			}
			//Căn chỉnh lại vị trí
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotStore") as Sprite;
			var w:int = icon.width * SlotScale - 10;
			var h:int = icon.height * SlotScale - 10;
			img1.FitRect(w, h - 10, new Point(5, 5));		
			
			//SetHighLight cho cá đặc biệt và cá quý
			if ( obj["FishType"] == Fish.FISHTYPE_SPECIAL)
			{
				container.SetHighLight(0x3333ff, false);
			}
			else if ( obj["FishType"] == Fish.FISHTYPE_RARE)
			{
				container.SetHighLight(0xff33ff, false);
			}
			
			if (obj["FishType"] != Fish.FISHTYPE_SOLDIER)
			{
				btn = container.AddButton("Use_Fish_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
			}
			else
			{
				btn = container.AddButton("Use_FishSoldier_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this, "Use_FishSoldier");
			}
			btn.img.width = 48;
			btn.img.height = 24;
			fmt = new TextFormat();			
			fmt.color = 0x000000;		
			container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
			
			return img1;
		}
		
		private function DrawBabyFishSparta(container:Container, obj:Object, num: int):Image
		{
			var img1:Image;
			var imgName:String;
			imgName = container.IdObject.split("_")[3];
			
			//nut dùng
			var st:String;
			var tooltip:TooltipFormat = new TooltipFormat();
			var fmt:TextFormat = new TextFormat();			
			fmt.color = 0x000000;			
			var btn:Button = container.AddButton(container.IdObject, "Btngreen", 10, 85, this);
			btn.img.width = 48;
			btn.img.height = 24;
			container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
			
			var obj:Object = ConfigJSON.getInstance().GetItemList("SuperFish");
			var objFishSpecial:Object = obj[imgName];
			var name:String = GetNameFishSpecial(imgName);					
			var money:String = "Tiền: " + objFishSpecial["Active"]["Money"];
			var exp:String = "EXP: " + objFishSpecial["Active"]["Exp"];
			st = name + "\n" + money + "\n" + exp;
			fmt.align = TextFormatAlign.CENTER;
			fmt.size = 14;
			fmt.bold = true;
			
			var s: String;
			
			fmt.color = "0xff33ff";
			for (s in obj["RateOption"])
			{
				st += "\n" + OptionTooltip(s) + obj["RateOption"][s] + "%";
			}
			tooltip.text = st;
			tooltip.setTextFormat(fmt, 0, name.length);
			fmt.size = 12;
			fmt.bold = false;
			fmt.color = "0x000000";
			tooltip.setTextFormat(fmt, name.length, tooltip.text.length);					
			container.setTooltip(tooltip);
			
			//Số lượng cá
			var txtFormat:TextFormat = new TextFormat("Arial", 16);
			var txt:TextField = container.AddLabel(num.toString(), 3, 2, 0xFFFFFF, 0, 0x26709C);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat(txtFormat);
			
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);		

			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotStore") as Sprite;
			//Căn chỉnh lại vị trí
			var w:int = icon.width * SlotScale - 10;
			var h:int = icon.height * SlotScale - 10;
			img1.FitRect(w, h - 10, new Point(5, 5));		
			
			return img1;
		}
		
		private function drawFireworkFish(container:Container, obj:Object, num: int):Image
		{
			var img1:Image;
			var imgName:String;
			imgName = "Fish20_Old_Idle";
			
			//nut dùng
			var st:String;
			var tooltip:TooltipFormat = new TooltipFormat();
			var fmt:TextFormat = new TextFormat();			
			fmt.color = 0x000000;			
			var btn:Button = container.AddButton(container.IdObject, "Btngreen", 10, 85, this);
			btn.img.width = 48;
			btn.img.height = 24;
			container.AddLabel("Dùng", -15, 63).setTextFormat(fmt);
			
			var obj:Object = ConfigJSON.getInstance().GetItemList("Param");
			var objFishSpecial:Object = obj[imgName + "Info"];
			var name:String = "Fish20_Old_Idle";			
			var money:String = "Tiền: 20";
			var exp:String = "EXP: 20";
			st = name + "\n" + money + "\n" + exp;
			fmt.align = TextFormatAlign.CENTER;
			fmt.size = 14;
			fmt.bold = true;
			//Số lượng cá
			var txtFormat:TextFormat = new TextFormat("Arial", 16);
			var txt:TextField = container.AddLabel(num.toString(), 3, 2, 0xFFFFFF, 0, 0x26709C);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat(txtFormat);
			
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);		
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotStore") as Sprite;
			//Căn chỉnh lại vị trí
			var w:int = icon.width * SlotScale - 10;
			var h:int = icon.height * SlotScale - 10;
			img1.FitRect(w, h - 10, new Point(5, 5));		
			
			return img1;
		}
		
		public function GetNameFishSpecial(imageName:String):String 
		{
			switch (imageName) 
			{
				case "Sparta":
					return "Cá chiến binh";
				case "Swat":
					return "Cá đặc nhiệm";
				case "Batman":
					return "Cá Batman";
				case "Spiderman":
					return "Cá Spiderman";
				case "Superman":
					return "Cá Superman";
				case "Firework":
					return "Cá pháo hoa";
				case "Santa":
					return "Cá Noel";
				case "Ironman":
					return "Cá Ironman";
			}
			return "";
		}
		public function UpdateStore(Type:String, Id:int, num:int = 1):void
		{
			if (IsVisible)
			{
				// sai do ham nay khong update duoc voi cac con ca baby, do no can id và fishtypeId
				if (Type != "BabyFish" )
				{
					GameLogic.getInstance().user.UpdateStockThing(Type, Id, num);
				}
				ClearComponent();
				updateStateForMagicBag();
				InitStore(CurrentStore, CurrentPage);
				// Cập nhật cho kho trong thế giới cá
				if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
				{
					GuiMgr.getInstance().GuiMainFishWorld.UpdateStore();
				}
				if (Type == "Other" || Type == "OceanAnimal" || Type == "OceanTree" || Type == "PearFlower")
				{
					if (btnSaveDeco != null)
					{
						btnSaveDeco.SetVisible(true);
					}
				}
			}
			else
			{
				GameLogic.getInstance().user.UpdateStockThing(Type, Id, num);
			}
		}
		
		public function HideSaveDeco():void
		{
			if (btnSaveDeco != null)
			{
				btnSaveDeco.SetVisible(false);
			}
		}
		
		public function ShowSaveDeco():void
		{
			if (btnSaveDeco != null)
			{
				btnSaveDeco.SetVisible(true);
			}
		}
		
		private function SellStoreItem(Type:String, Id:int):void
		{
			switch (Type)
			{
				case "FishGift":
				case "Fish":
					SellFish(Type, Id);
					break;
			}
		}
		
		private function SellFish(Type:String, Id:int):void
		{
			//Đang khóa hoặc xin phá khóa
			var pwState:String = GameLogic.getInstance().user.passwordState;
			if (pwState == Constant.PW_STATE_IS_LOCK || pwState == Constant.PW_STATE_IS_CRACKING || pwState == Constant.PW_STATE_IS_BLOCKED)
			{
				GuiMgr.getInstance().guiPassword.showGUI();
				return;
			}
			
			// lay danh sach cac slot
			var num:int = 0;
			var ItemList:Array = GameLogic.getInstance().user.GetStore("Fish");
			var i:int;
			for (i = 0; i < ItemList.length; i++)
			{
				var tg:StockThings = new StockThings();
				tg.SetInfo(ItemList[i]);
				if ((tg.Id == Id) && (tg.ItemType == Type))
				{
					num = tg.Num;
					break;
				}
			}
			
			if (num > 0)
			{
				var st:StockThings = new StockThings();
				st.Id = Id;
				st.ItemType = Type;
				st.Num = num;
				GameLogic.getInstance().SellStockFish(st);
				UpdateStore(Type, Id, -num);
				Tooltip.getInstance().ClearTooltip();
			}
		}
		
		private function UseStoreItem(Type:String, Id:int):void
		{
			if (CurrentStore == GUI_STORE_BTN_FISH) return;
			switch (Type)
			{
				case "Fish":
					//Đang khóa hoặc xin phá khóa
					var pwState:String = GameLogic.getInstance().user.passwordState;
					if (pwState == Constant.PW_STATE_IS_LOCK || pwState == Constant.PW_STATE_IS_CRACKING || pwState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					GameLogic.getInstance().UseFish(Id);
					Tooltip.getInstance().ClearTooltip();
					break;
				case "FishSoldier":
					//Đang khóa hoặc xin phá khóa
					var passwordState:String = GameLogic.getInstance().user.passwordState;
					if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					GameLogic.getInstance().UseFishSoldier(Id);
					Tooltip.getInstance().ClearTooltip();
					break;
				case "EnergyItem":					
					var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
					var ctn:Container = GetContainer("Use_EnergyItem_" + Id.toString());
					var MaxEnergyUse:Object = GameLogic.getInstance().user.GetMyInfo().MaxEnergyUse;
					var maxBonusMachine:int = ConfigJSON.getInstance().GetItemList("Param")["MaxBonusMachine"];
			
					if (GameLogic.getInstance().user.GetEnergy() < maxEnergy + maxBonusMachine)
					{
						if (MaxEnergyUse && MaxEnergyUse[Id] != null)
						{
							if (MaxEnergyUse[Id.toString()] <= 0)
							{
								if(!isMultiClick)
								{
									var txtFormatMat:TextFormat = new TextFormat();
									txtFormatMat.bold = true;
									txtFormatMat.color = 0xff0000;
									var tip:TooltipFormat = new TooltipFormat();
									tip.text = "Bạn đã dùng quá số bình\nloại " + Id + " của ngày hôm nay";
									tip.setTextFormat(txtFormatMat);
									ActiveTooltip.getInstance().showNewToolTip(tip, ctn.img);
									isMultiClick = true;
								}
								break;
							}
							else
							{
								MaxEnergyUse[Id.toString()]--;
							}
						}
						
						GameLogic.getInstance().UseEnergy(Id);
					}
					break;
				case "Viagra":
					useResetMateFishMedicine();
					break;
				//hiepnm2
				case "RankPointBottle":
				{
					useRankPointBottle(Id);
				};
				break;
				case "Material":
					
					useMaterialForFish(Id);
					break;
				//hiepnm2
				case "Petrol":
					if (GameLogic.getInstance().user.GetMyInfo().hasMachine)
						GameLogic.getInstance().UsePetrol(Id);
					break;
				case "RebornMedicine":
				{					
					useRebornXFish(Id);
					break;
				}
				case "MagicBag":
					this.removeAllEvent();
					GetButton(GUI_STORE_BTN_CLOSE).SetDisable();
					curId = Id;
					btnDeco.SetDisable();
					btnBabyFish.SetDisable();
					btnSpecial.SetDisable();
					
					var ctnId:String = "Use_" + Type + "_" + Id;
					var ctn1:Container = GetContainer(ctnId);
					var logicPos:Point = new Point(ctn1.img.x + ctn1.img.width / 2, ctn1.img.y + ctn1.img.height / 2);
					
					beginPosParticle = new Point(this.img.x + logicPos.x, this.img.y + logicPos.y);
					useMagicBag(Id);
					break;
				break;
				case "RecoverHealthSoldier":
					useToolRecoverHealthSoldier(Id);
					break;
				case "Ginseng":
					useToolGinseng(Id);
					break;
				case "Samurai":
					useToolSamurai(Id);
					break;
				case "StoreRank":
					useToolStoreRank(Id);
					break;
				case "Resistance":
					useToolResistance(Id);
					break;
				case "BuffMoney":
				case "BuffExp":
				case "BuffRank":
					break;
				case "HerbPotion":
					useToolHerbPotion(Id);
					break;
				default:
					if (Type.search("Gem") != -1)
					{
						useGem(Type, Id);
					}
					break;
			}
			
		}		
		
		private function GetFreeDeco(ItemID:int, ItemType:String):Decorate
		{
			var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			var i:int;
			var deco:Decorate = null;
			var IsFound:Boolean = false;
			for (i = 0; i < decoArr.length; i++)
			{
				deco = decoArr[i] as Decorate;
				if ((deco.img && !deco.img.visible) && (deco.ItemId == ItemID) && (deco.ItemType == ItemType))
				{
					deco.ChangeLayer(Constant.ACTIVE_LAYER);
					deco.img.visible = true;
					deco.IsNewObj = false;
					IsFound = true;
					break;
				}
			}
			
			var pt:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			if (!IsFound)
			{
				deco = new Decorate(LayerMgr.getInstance().GetLayer(Constant.ACTIVE_LAYER), ItemType + ItemID, pt.x, pt.y, ItemType, ItemID);
				deco.Id = -1;
			}
			pt.y += deco.img.height / 2;
			
			deco.SetHighLight();
			deco.SetPos(pt.x, pt.y);
			return deco;
		}
		
		private function UseDecorate(ItemType:String, ItemId:int, Id:int):void
		{
			var expiredTime:Number;
			var arr:Array = GameLogic.getInstance().user.StockThingsArr[ItemType];
			for each(var obj:Object in arr)
			{
				if (obj["Id"] == Id)
				{
					expiredTime = obj["ExpiredTime"];
				}
			}
			//Khong cho trang tri do het han
			if (expiredTime < GameLogic.getInstance().CurServerTime)
			{
				GuiMgr.getInstance().guiExtendDeco.showGUI(Id);
				return;
			}
			
			var deco:Decorate = GetFreeDeco(ItemId, ItemType);
			deco.ObjectState = BaseObject.OBJ_STATE_USE;
			deco.Id = Id;
			deco.official = false;
			deco.expiredTime = expiredTime;
			if (ItemType == "OceanAnimal")
			{
				deco.GoToAndStop(2);
			}
			
			GameController.getInstance().SetActiveObject(deco);	
		}
		
		private function useMaterialForFish(Id:int):void 
		{
			//return;
			if (Id % 100 < 6 || Id % 100 > 10)	return;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH);
			GameLogic.getInstance().MouseTransform(Ultility.GetNameMatFromType(Id),  1, -45, 10, 0);	
			GUIFishStatus.USE_MATERIAL_FOR_FISH = GUIFishStatus.USE_MATERIAL_FOR_FISH_CONST + Id
			GameLogic.getInstance().ShowGuiFishStatus(GUIFishStatus.USE_MATERIAL_FOR_FISH, true);
		}
		

		private function UseBackGround(ItemId:int, Id:int):void
		{
			var expiredTime:Number;
			var arr:Array = GameLogic.getInstance().user.StockThingsArr["BackGround"];
			for each(var obj:Object in arr)
			{
				if (obj["Id"] == Id)
				{
					expiredTime = obj["ExpiredTime"];
					break;
				}
			}
			//Khong cho trang tri do het han
			if (expiredTime < GameLogic.getInstance().CurServerTime)
			{
				GuiMgr.getInstance().guiExtendDeco.showGUI(Id);
				return;
			}
			
			UpdateStore("BackGround", Id, -1);
			var us:User = GameLogic.getInstance().user;
			var dec:Decorate = new Decorate(LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER), "BackGround" + us.backGround.ItemId, 0, 0, "BackGround", us.backGround.ItemId);
			dec.Id = us.backGround.Id;
			dec.expiredTime = us.backGround.expiredTime;
			dec.extendTime = us.backGround.extendTime;
			GameLogic.getInstance().StoreDecorate(dec);
			
			GameLogic.getInstance().user.initBackGround(obj, true);
			
			var cmd:SendUseItem = new SendUseItem(GameLogic.getInstance().user.CurLake.Id);
			cmd.AddNew(Id, ItemId, "BackGround", 0, 0, 0);
			Exchange.GetInstance().Send(cmd);
		}
		
		/**
		 * Hàm xử lý sử dụng đan trong kho
		 * @author	longpt
		 * @param	Type
		 * @param	Id
		 */
		public function useGem(Type:String, Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = Type;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_OTHER_BUFF_SOLDIER);
			
			var a:Array = Type.split("$");
			var imageName:String = "Gem_" + a[1] + "_" + a[2];
			GameLogic.getInstance().MouseTransform(imageName, 1, 0, 10, 0);
			
			//if (parseInt(a[1]) == FishSoldier.ELEMENT_WATER)
			//{
				// Show bar hp lên
				//GameLogic.getInstance().ShowGuiFishSoldierStatus(GUIFishStatus.RECOVER_HEALTH, true);
			//}
		}
		
		/**
		 * Sử dụng thuốc thảo dược
		 * @param	Id
		 */
		public function useToolHerbPotion(Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "HerbPotion_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_USE_HERB_POTION);
			GameLogic.getInstance().MouseTransform("HerbPotion" + Id, 1, 0, 10, 0);
		}
		
		/**
		 * Hàm xử lý sử dụng miễn kháng trong kho
		 * @author	longpt
		 * @param	Id
		 */
		public function useToolResistance(Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "Resistance_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_OTHER_BUFF_SOLDIER);
			GameLogic.getInstance().MouseTransform("Resistance" + Id, 1, 0, 10, 0);
		}
		
		public function useToolStoreRank(Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "StoreRank_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_OTHER_BUFF_SOLDIER);
			GameLogic.getInstance().MouseTransform("StoreRank" + Id, 1, 0, 10, 0);
		}
		
		/**
		 * Hàm xử lý sử dụng tăng lực trong kho
		 * @author	longpt
		 * @param	Id
		 */
		public function useToolSamurai(Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "Samurai_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_OTHER_BUFF_SOLDIER);
			GameLogic.getInstance().MouseTransform("Samurai$" + Id, 1, 0, 10, 0);
		}
		
		public function useToolGinseng(Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "Ginseng_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_REVIVE_SOLDIER);
			GameLogic.getInstance().MouseTransform("Ginseng$" + Id, 1, 0, 10, 0);
		}
		
		/**
		 * Hàm xử lý sử dụng hồi máu cho cá
		 * @author	longpt
		 * @param	Id
		 */
		public function useToolRecoverHealthSoldier(Id:int): void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "RecoverHealthSoldier_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER);
			GameLogic.getInstance().MouseTransform("RecoverHealthSoldier$" + Id, 1, -45, 10, 0);
			GameLogic.getInstance().ShowGuiFishSoldierStatus(GUIFishStatus.RECOVER_HEALTH, true);
		}
		
		private function useResetMateFishMedicine():void
		{
			GameLogic.getInstance().SetState(GameState.GAMESTATE_RESET_MATE_FISH);
			GameLogic.getInstance().MouseTransform("Viagra1",  1, -45, 10, 0);			
			GameLogic.getInstance().ShowGuiFishStatus(GUIFishStatus.RESET_MATE_FISH, true);
		}
		private function useRankPointBottle(id:int):void
		{
			curRankPointBottleId = id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_INCREASE_RANK_POINT);
			GameLogic.getInstance().MouseTransform("RankPointBottle" + id.toString(),  1, -45, 10, 0);		
			GameLogic.getInstance().ShowGuiFishSoldierStatus(GUIFishStatus.INCREASE_RANK_POINT, true);
		}
		private function useRebornXFish(id:int):void
		{
			GameLogic.getInstance().SetState(GameState.GAMESTATE_REBORN_XFISH);
			GameLogic.getInstance().MouseTransform("RebornMedicine" + id.toString(), 1, -45, 10, 0);
			curId = id;
		};
		//private function useLixi(id:int, src:Point, des:Point):void
		//{
			//GuiMgr.getInstance().GuiForEffect.useLixi("Lixi", id, src, des);
		//};
		//private function useMagicBag(id:int,beginPos:Point):void
		private function useMagicBag(id:int):void
		{
			//GameLogic.getInstance().SetState(GameState.GAMESTATE_OPEN_MAGIC_BAG);
			//curId = id;
			GuiMgr.getInstance().GuiForEffect.Show(Constant.GUI_MIN_LAYER, 1);
			var ctn:Container = GetContainer("Use_" + "MagicBag_" + id.toString());
			var imag:Image = ctn.GetImage("img_" + "MagicBag_" + id.toString());
			imag.img.visible = true;
			var prg1:ProgressBar = ctn.GetProgress("prg_" + "MagicBag_" + id.toString());
			prg1.img.visible = true;
			//isProcessedMagicBag = false;
			//GameLogic.getInstance().OpenMagicBag(id,beginPos);
			GameLogic.getInstance().OpenMagicBag(id);
		}
		//
		public var isProgressFull:Boolean = false;
		public var curprgProcessing:ProgressBar;
		public var curimgPrgProcessing:Image;
		public var isHavePrg:Boolean = false;
		public var btnID:String;
		
		public function UpdateForPgrMagicBag(id:int):void
		{
			if (!isInitSoreOK) 
			{
				return;
			}
			var ctn:Container = null;
			//trace(isHavePrg);
			//trace(btnID);
			//trace(isHavePrg);
			//trace(btnID);
			if(!isHavePrg)
			{
				ctn = GetContainer("Use_" + "MagicBag_" + id.toString());
				if (ctn == null)
					return;
				
				curprgProcessing  = ctn.GetProgress("prg_" + "MagicBag_" + id.toString());
				curimgPrgProcessing = ctn.GetImage("img_" + "MagicBag_" + id.toString());
				
				if (curimgPrgProcessing == null)
					return;
				
				if (curprgProcessing == null) 
					return;
					
				isHavePrg = true;
			}	
			else 
			{
				if (curprgProcessing && curprgProcessing.img && curprgProcessing.img.visible)
				{
					curprgProcessing.setStatus(curprgProcessing.percent + 0.015);
					if (curprgProcessing.percent >= 1)
					{
						isProgressFull = true;
					}
				}
				else 
				{
					isHavePrg = false;
				}
			}
		}
		//
		public function getDataMagicBagFromServer(data:Object):void
		{
			GuiMgr.getInstance().GuiForEffect.isReceiveData = true;
			idGiftMagicBag = data.IdGift;
		}
		private function UpdateCurrentTab(buttonID:String):void
		{
			btnDeco.img.y = HighY;
			btnDeco.SetFocus(false);
			btnSpecial.img.y = HighY;
			btnSpecial.SetFocus(false);
			//btnFish.img.y = HighY;
			//btnMaterial.img.y = HighY;
			//btnMaterial.SetFocus(false);
			btnBabyFish.img.y = HighY;
			btnBabyFish.SetFocus(false);
			//btnSoldier.img.y = HighY;
			//btnSoldier.SetFocus(false);
			btnSupport.img.y = HighY;
			btnSupport.SetFocus(false);
			btnGem.img.y = HighY;
			btnGem.SetFocus(false);
			
			btnDeco.SetVisible(true);
			btnSpecial.SetVisible(true);
			//btnFish.SetVisible(true);
			//btnMaterial.SetVisible(true);
			btnBabyFish.SetVisible(true);
			
			//imgMaterial.img.visible = false;
			imgDeco.img.visible = false;
			imgSpecial.img.visible = false;
			//imgFish.img.visible = false;
			imgBabyFish.img.visible = false;
			imgSupport.img.visible = false;
			
			switch (buttonID)
			{
				case GUI_STORE_BTN_DECO:
					//btnDeco.img.y = LowY;
					//btnDeco.SetFocus(true, false);
					btnDeco.SetVisible(false);
					imgDeco.img.visible = true;
					break;
				case GUI_STORE_BTN_SPECIAL:
					//btnSpecial.img.y = LowY;
					//btnSpecial.SetFocus(true, false);
					btnSpecial.SetVisible(false);
					imgSpecial.img.visible = true;
					break;
				case GUI_STORE_BTN_FISH:
					//btnFish.img.y = LowY;
					//btnFish.SetFocus(true, false);
					//btnFish.SetVisible(false);
					//imgFish.img.visible = true;
					break;
				case GUI_STORE_BTN_MATERIAL:
					//btnMaterial.img.y = LowY;
					//btnMaterial.SetFocus(true, false);
					//btnMaterial.SetVisible(false);
					//imgMaterial.img.visible = true;
					break;
				case GUI_STORE_BTN_BABY_FISH:
					//btnBabyFish.img.y = LowY;
					//btnBabyFish.SetFocus(true, false);
					btnBabyFish.SetVisible(false);
					imgBabyFish.img.visible = true;
					break;
				case GUI_STORE_BTN_SOLDIER:
					//btnSoldier.SetVisible(false);
					//imgSoldier.img.visible = true;
					break;
				case GUI_STORE_BTN_SUPPORT:
					btnSupport.SetVisible(false);
					imgSupport.img.visible = true;
					break;
				case GUI_STORE_BTN_GEM:
					btnGem.SetVisible(false);
					imgGem.img.visible = true;
					break;
			}
		}
		
		private function ChangeTab(buttonID:String):void
		{
			var OldStore:String = CurrentStore;
			if (buttonID == CurrentStore)
			{
				return;
			}
			//if(GameController.getInstance().isSmallBackGround)
			//{
				GameController.getInstance().blackHole.img.visible = false;
			//}
						
			switch (buttonID)
			{
				case GUI_STORE_BTN_DECO:
					if (CurrentStore != buttonID)
					{
						GameController.getInstance().UseTool("EditDecorate");
					}
					break;
				case GUI_STORE_BTN_SPECIAL:
					if (CurrentStore != buttonID)
					{
						updateStateForMagicBag();
						ClearComponent();
						InitStore(buttonID, 0);
					}
					break;
				//case GUI_STORE_BTN_FISH:
					//if (CurrentStore != buttonID)
					//{
						//updateStateForMagicBag();
						//ClearComponent();
						//InitStore(buttonID, 0);
					//}
					//break;
				//case GUI_STORE_BTN_MATERIAL:
					//if (CurrentStore != buttonID)
					//{
						//updateStateForMagicBag();
						//ClearComponent();
						//InitStore(buttonID, 0);
					//}
					//break;
				case GUI_STORE_BTN_BABY_FISH:
					if (CurrentStore != buttonID)
					{
						//if(GameController.getInstance().isSmallBackGround)
						//{
							GameController.getInstance().blackHole.SetPos(485, 135);
							GameController.getInstance().blackHole.img.visible = true;
						//}
						updateStateForMagicBag();
						ClearComponent();
						InitStore(buttonID, 0);
					}
					break;
				//case GUI_STORE_BTN_SOLDIER:
					//if (CurrentStore != buttonID)
					//{
						//updateStateForMagicBag();
						//ClearComponent();
						//InitStore(buttonID, 0);
					//}
					//break;
				case GUI_STORE_BTN_SUPPORT:
					if (CurrentStore != buttonID)
					{
						updateStateForMagicBag();
						ClearComponent();
						InitStore(buttonID, 0);
					}
					break;
				case GUI_STORE_BTN_GEM:
				case GUI_STORE_BTN_BABY_FISH:
					if (CurrentStore != buttonID)
					{
						updateStateForMagicBag();
						ClearComponent();
						InitStore(buttonID, 0);
					}
					break;
			}
			
			// hoi xem co luu trang tri ko
			if (OldStore == GUI_STORE_BTN_DECO)
			{
				GameLogic.getInstance().BackToIdleGameState();
			}
		}
		
		private function updateStateForMagicBag():void 
		{
			isInitSoreOK = false;
			curimgPrgProcessing = null;
			curprgProcessing = null;
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_STORE_BTN_NEXT:
					if (CurrentPage < MaxPage - 1)
					{
						updateStateForMagicBag();
						ClearComponent();
						InitStore(CurrentStore, CurrentPage + 1);
						
					}
					
					break;
				case GUI_STORE_BTN_BACK:
					if (CurrentPage > 0)
					{
						updateStateForMagicBag();
						ClearComponent();
						InitStore(CurrentStore, CurrentPage - 1);
					}
					break;
					
				case GUI_STORE_BTN_DECO:
					ChangeTab(buttonID);
					//btnExtendDeco.SetVisible(true);
					break;
				case GUI_STORE_BTN_SPECIAL:
				case GUI_STORE_BTN_FISH:
				case GUI_STORE_BTN_MATERIAL:
				case GUI_STORE_BTN_BABY_FISH:
				case GUI_STORE_BTN_SOLDIER:
				case GUI_STORE_BTN_SUPPORT:
				case GUI_STORE_BTN_GEM:
					ChangeTab(buttonID);
					break;
					
				case GUI_STORE_BTN_CLOSE:
					//thuc hien khong dung thuoc viagra
					//chuyen con chuot ve trang thai binh thuong
					Hide();
					break;
					
				case GUI_STORE_BTN_SAVE:
					GameLogic.getInstance().SaveEditDecorate();
					break;
					
				case BTN_EXTEND_DECO:
					GuiMgr.getInstance().guiExtendDeco.showGUI();
					break;
					
				default:
					var arr:Array = buttonID.split("_");
					var act:String = arr[0];
					var Type:String = arr[1];
					var Id:int;
					Id = arr[2];
					btnID = buttonID;
					if (act == "Sell")
					{
						SellStoreItem(Type, Id);
					}
					if (act == "Use")
					{
						if (!arr[3])
						{
							UseStoreItem(Type, Id);
						}
						else 
						{
							if (arr[3] && arr[1] == "Fish")
							{
								if(arr[3] != "Firework" && arr[3] != "Santa")
								{
									GameLogic.getInstance().UseFishSpartan(Id);
								}
								else
								{
									GameLogic.getInstance().useFireworkFish(Id);
								}
								Tooltip.getInstance().ClearTooltip();
							}
							else
							//Sử dụng đồ trang trí
							if (arr[1] == "Other" || arr[1] == "OceanAnimal" || arr[1] == "OceanTree" || arr[1] == "PearFlower" )
							{
								UseDecorate(Type, arr[2], arr[3]);
							}
						}
					}
					break;
			}
		}
		
		public override function OnButtonDown(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_STORE_BTN_NEXT:
				case GUI_STORE_BTN_BACK:
				case GUI_STORE_BTN_DECO:
				case GUI_STORE_BTN_SPECIAL:
				case GUI_STORE_BTN_FISH:
				case GUI_STORE_BTN_MATERIAL:
				case GUI_STORE_BTN_BABY_FISH:
				case GUI_STORE_BTN_SOLDIER:
				case GUI_STORE_BTN_SUPPORT:
				case GUI_STORE_BTN_GEM:
				case GUI_STORE_BTN_CLOSE:
				case GUI_STORE_BTN_SAVE:
					break;
				default:
					var arr:Array = buttonID.split("_");
					var act:String = arr[0];
					var Type:String = arr[1];
					var Id:int = arr[2];
					 
					if (act == "Use" && !arr[3])
					{
						btnID = buttonID;
						UseStoreItem(Type, Id);
					}
					if (act == "Use")
					{
						switch(Type)
						{
							case "Other":
							case "OceanAnimal":
							case "OceanTree":
							case "PearFlower":
								btnID = buttonID;
								UseDecorate(Type, arr[2], arr[3]);
								break;
							case "BackGround":
								UseBackGround(arr[2], arr[3]);
								break;
						}					
						
					}
					break;
			}
		}
		
		private function UpdateContainerHighLight(index:String, isMoveOut:Boolean = false):void
		{
			//if (CurrentStore == "Fish") return;
			var i:int;
			for (i = 0; i < ContainerArr.length; i++)
			{
				var container:Container = ContainerArr[i] as Container;
				if (container.IdObject == index)
				{
					if(!isMoveOut)
					{
						container.SetHighLight(0x00ff00, true);
					}
					else 
					{
						container.SetHighLight(-1, true);
					}
					break;
				}
				//else
				//{
					//container.SetHighLight(-1, true);
				//}
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_STORE_BTN_NEXT:
				case GUI_STORE_BTN_BACK:
				case GUI_STORE_BTN_DECO:
				case GUI_STORE_BTN_SPECIAL:
				case GUI_STORE_BTN_FISH:
				case GUI_STORE_BTN_MATERIAL:
				case GUI_STORE_BTN_BABY_FISH:
				case GUI_STORE_BTN_SOLDIER:
				case GUI_STORE_BTN_SUPPORT:
				case GUI_STORE_BTN_GEM:
				case GUI_STORE_BTN_CLOSE:
				case GUI_STORE_BTN_SAVE:
					break;
				default:
					UpdateContainerHighLight(buttonID, false);
					if (buttonID.search("Draft") >= 0 || buttonID.search("Blessing") >= 0 || buttonID.search("GoatSkin") >= 0 || buttonID.search("Paper") >= 0)
					{
						var arr:Array = buttonID.split("_");
						var config:Object = ConfigJSON.getInstance().getItemInfo(arr[1], arr[2]);
						GuiMgr.getInstance().GuiMixFormulaInfo.InitAll(config, event.stageX, event.stageY);
					}
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			isMultiClick = false;
			switch (buttonID)
			{
				case GUI_STORE_BTN_NEXT:
				case GUI_STORE_BTN_BACK:
				case GUI_STORE_BTN_DECO:
				case GUI_STORE_BTN_SPECIAL:
				case GUI_STORE_BTN_FISH:
				case GUI_STORE_BTN_MATERIAL:
				case GUI_STORE_BTN_BABY_FISH:
				case GUI_STORE_BTN_SOLDIER:
				case GUI_STORE_BTN_SUPPORT:
				case GUI_STORE_BTN_GEM:
				case GUI_STORE_BTN_CLOSE:
				case GUI_STORE_BTN_SAVE:
					break;
				default:
					UpdateContainerHighLight(buttonID, true);
					if (buttonID.search("Draft") >= 0 || buttonID.search("Blessing") >= 0 || buttonID.search("GoatSkin") >= 0 || buttonID.search("Paper") >= 0)
					{
						GuiMgr.getInstance().GuiMixFormulaInfo.Hide();
					}
					break;
			}
		}
		
		public override function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void
		{
			UpdateAllPos();
		}
		
		public function UpdateAllPos():void
		{			
			if (IsVisible)
			{
				if (Main.imgRoot.stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
					img.y = BgLayer.y + BgLayer.height - 105 - 3;
				}
				else
				{
					img.x = LastX;
					img.y = LastY;
				}
			}
		}	
		
		public function getTabPosByType(type:String):Point
		{
			switch(type)
			{
				case "Other":
				case "OceanAnimal":
				case "OceanTree":
					return new Point(btnDeco.img.x, btnDeco.img.y);
				case "EnergyItem":
				case "MixLake":
				case "License":
				case "Medicine":
					if (!btnSpecial || !btnSpecial.img)
					{
						return new Point(imgSpecial.img.x, imgSpecial.img.y);
					}
					else
					{
						return new Point(btnSpecial.img.x, btnSpecial.img.y);
					}
				case "FishGift":
				case "Fish":
					//return new Point(btnFish.img.x, btnFish.img.y);
				case "Material":
					//return new Point(btnMaterial.img.x, btnMaterial.img.y);
				case "BabyFish":
					return new Point(btnBabyFish.img.x, btnBabyFish.img.y);
			}	
			return new Point(0, 0);
		}
		
		public function ProcessReceiveGiftMagicBag(prgProcessing:ProgressBar,imgPrgProcessing:Image):void
		{
			if (GuiMgr.getInstance().GuiForEffect.isReceiveData == true)
			{
				GuiMgr.getInstance().GuiForEffect.isReceiveData = false;
				//isProgressFull = false;
				if (prgProcessing && prgProcessing.img) 
				{
					prgProcessing.setStatus(0);
					prgProcessing.img.visible = false;
				}
				if (imgPrgProcessing && imgPrgProcessing.img) 
					imgPrgProcessing.img.visible = false;
				//UpdateStore("MagicBag", curId, -1);
				GetButton(GUI_STORE_BTN_CLOSE).SetDisable();
				if (idGiftMagicBag != 0)
				{
					//GameLogic.getInstance().ReceiveFromMagicBag(idGiftMagicBag);
					//GameLogic.getInstance().StartParFromMagicBag(idGiftMagicBag,beginPosParticle);
					GuiMgr.getInstance().GuiForEffect.SetForMagicBag(idGiftMagicBag, beginPosParticle);
					GuiMgr.getInstance().GuiForEffect.AddEffect();
				}
			}
		}
		
		override public function UpdateObject():void 
		{
			if (arrDataDeco != null)
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				for (var i:int = 0; i < arrDataDeco.length; i++)
				{
					if (arrDataDeco[i]["ExpiredTime"] < curTime && !arrDataDeco[i]["isExpired"])
					{
						arrDeco[i].AddImage("", "IconExpired", 60, 10);
						
						var config:Object = ConfigJSON.getInstance().getItemInfo(arrDataDeco[i]["ItemType"], arrDataDeco[i]["ItemId"]);
						var tooltip:TooltipFormat = new TooltipFormat();
						tooltip.text = config["Name"] + "\nthời hạn còn " + Math.max(0, Math.ceil((arrDataDeco[i]["ExpiredTime"] - curTime) / (24 * 3600))) + " ngày";
						arrDeco[i].setTooltip(tooltip);
						arrDataDeco[i]["isExpired"] = true;
					}
					else if(!arrDataDeco[i]["isExpired"])
					{
						//trace(arrDataDeco[i]["ExpiredTime"] - curTime);
					}
				}
			}
		}
	}

}