package GUI.FishWar 
{
	import GUI.component.BaseGUI;
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
	import GUI.GUIFishStatus;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.Decorate;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.GameMode;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.StockThings;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * Kho item cá lính
	 * @author longpt
	 */
	public class GUIStoreSoldier extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public const GUI_STORE_SOLDIER_BTN_SUPPORT:String = "Support";
		private const GUI_STORE_SOLDIER_BTN_STEEL:String = "Element_1";
		private const GUI_STORE_SOLDIER_BTN_WOOD:String = "Element_2";
		private const GUI_STORE_SOLDIER_BTN_EARTH:String = "Element_3";
		private const GUI_STORE_SOLDIER_BTN_WATER:String = "Element_4";
		private const GUI_STORE_SOLDIER_BTN_FIRE:String = "Element_5";
		private const GUI_STORE_SOLDIER_BTN_NEXT:String = "BtnNext";
		private const GUI_STORE_SOLDIER_BTN_BACK:String = "BtnBack";
		
		private const GUI_STORE_SOLDIER_BTN_CLOSE:String = "Close";
		
		// Danh sách con trỏ
		public var btnSupport:Button;
		public var btnSteel:Button;
		public var btnWood:Button;
		public var btnEarth:Button;
		public var btnWater:Button;
		public var btnFire:Button;
		public var btnClose:Button;
		
		public var imgSupport:Image;
		public var imgSteel:Image;
		public var imgWood:Image;
		public var imgEarth:Image;
		public var imgWater:Image;
		public var imgFire:Image;
		
		// Kiểm tra GUI đã load dữ liệu xong chưa
		public var IsLoading:Boolean = true;
		public var isMultiClick:Boolean;
		public var isInitSoreOK:Boolean;	
		
		// Các tham số mặc định
		private static const LowY:int = -29;
		private static const HighY:int = -29;
		private static const MaxSlot:int = 8;
		private static const SlotX0:int = 58;
		private static const SlotY0:int = 11;
		private static const SlotScale:Number = 1;
		private static const SlotDx:int = 17;
		
		public var CurrentPage:int = 0;
		public var CurrentStore:String = "Support";
		private var MaxPage:int = 1;
		
		public var curItemId:int;
	
		public function GUIStoreSoldier(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIStoreSoldier"
			LastX = 4;
			LastY = Constant.STAGE_HEIGHT - 105;
		}
		
		public override function InitGUI(): void
		{
			LoadRes("ImgBgGUIStore1");
			img.addChild(WaitData);
			WaitData.x = 400;
			WaitData.y = 40;
			
			isMultiClick = false;
			
			GuiMgr.getInstance().GuiMain.HideAllToolButton(true);
			IsLoading = true;
			
			var icon:Sprite = ResMgr.getInstance().GetRes( "ImgBgGUIStore1") as Sprite;
			var w:int = icon.width ;
			var h:int = icon.height;
			btnClose = AddButton(GUI_STORE_SOLDIER_BTN_CLOSE, "BtnCloseStore", w - 85, -32, this);
			UpdateAllPos();
			
			isInitSoreOK = false;
		}
		
		public override function OnHideGUI():void
		{
			
			if (GameLogic.getInstance().user.IsViewer())
			{
				if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
				{
					GuiMgr.getInstance().GuiMain.btnHook.SetVisible(true);
					GuiMgr.getInstance().GuiMain.btnFeed.SetVisible(true);
					GuiMgr.getInstance().GuiMain.btnMouseDefault.SetVisible(true);
					GuiMgr.getInstance().GuiMain.txtFoodCount.visible = true;
				}
				
				//GuiMgr.getInstance().GuiMain.btnInventorySoldier.SetVisible(true);
				for (var i:int = 0; i < GuiMgr.getInstance().GuiMain.btnLakeArr.length; i++)
				{
					var container:Container = GuiMgr.getInstance().GuiMain.btnLakeArr[i] as Container;
					container.SetVisible(true);
				}
				GuiMgr.getInstance().GuiMain.btnExpand.SetVisible(true);
			}
			else
			{
				GuiMgr.getInstance().GuiMain.HideAllToolButton(false);
			}
		}
		
		private function InitStoreButton():void
		{	
			var icon:Sprite = ResMgr.getInstance().GetRes( "ImgBgGUIStore1") as Sprite;
			var w:int = icon.width ;
			var h:int = icon.height;
				
			// cac tab
			btnSupport = AddButton(GUI_STORE_SOLDIER_BTN_SUPPORT, "BtnTabSupport", 170 - 120, LowY, this);
			btnSteel = AddButton(GUI_STORE_SOLDIER_BTN_STEEL, "BtnTabSteel", 280 - 120, LowY, this);
			btnWood = AddButton(GUI_STORE_SOLDIER_BTN_WOOD, "BtnTabWood", 390 - 120, LowY, this);
			btnEarth = AddButton(GUI_STORE_SOLDIER_BTN_EARTH, "BtnTabEarth", 500 - 120, LowY, this);
			btnWater = AddButton(GUI_STORE_SOLDIER_BTN_WATER, "BtnTabWater", 610 - 120, LowY, this);
			btnFire = AddButton(GUI_STORE_SOLDIER_BTN_FIRE, "BtnTabFire", 720 - 120, LowY, this);
			
			imgSupport = AddImage(GUI_STORE_SOLDIER_BTN_SUPPORT, "ImgTabSupport", 170 + 49 - 120, LowY + 15);
			imgSteel = AddImage(GUI_STORE_SOLDIER_BTN_STEEL, "ImgTabSteel", 280 + 49 - 120, LowY + 15);
			imgWood = AddImage(GUI_STORE_SOLDIER_BTN_WOOD, "ImgTabWood", 390 + 49 - 120, LowY + 15);
			imgEarth = AddImage(GUI_STORE_SOLDIER_BTN_EARTH, "ImgTabEarth", 500 + 49 - 120, LowY + 15);
			imgWater = AddImage(GUI_STORE_SOLDIER_BTN_WATER, "ImgTabWater", 610 + 49 - 120, LowY + 15);
			imgFire = AddImage(GUI_STORE_SOLDIER_BTN_FIRE, "ImgTabFire", 720 + 49 - 120, LowY + 15);
			
			imgEarth.img.visible = false;
			imgSupport.img.visible = false;
			imgSteel.img.visible = false;
			imgWood.img.visible = false;
			imgWater.img.visible = false;
			imgFire.img.visible = false;
			
			// Thêm button Close
			var HasCloseBtn:Boolean = false;
			if ((btnClose != null) && (btnClose.img != null) && (btnClose.img.parent != null))
			{
				HasCloseBtn = true;
			}
			if (!HasCloseBtn)
			{
				btnClose = AddButton(GUI_STORE_SOLDIER_BTN_CLOSE, "BtnCloseStore", w - 85, -32, this);
			}

			UpdateCurrentTab(CurrentStore);
			
			var btnNext:Button = AddButton(GUI_STORE_SOLDIER_BTN_NEXT, "BtnNext", 765, 45, this);
			var btnBack:Button = AddButton(GUI_STORE_SOLDIER_BTN_BACK, "BtnPrev", 8, 45, this);
			
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
			InitStore(CurrentStore, CurrentPage);
		}
		
		public function InitStore(Type:String, page:int):void
		{
			// Xóa loading
			if (WaitData.parent == img)
			{
				img.removeChild(WaitData);
			}
			
			CurrentStore = Type;
			
			// Lấy danh sách các slot
			var ItemList:Array = GameLogic.getInstance().user.GetStore(Type);
			
			if (ItemList.length <= 0)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 30, 0x707070);
				var txt:TextField = AddLabel(Localization.getInstance().getString("GUILabel1") , 360, 30);
				txt.setTextFormat(txtFormat);
			}
			
			// Tính số pages tối đa
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
			
			// Thêm các thành phần GUI
			var vt:int = CurrentPage * MaxSlot;		//Tổng số slot của n-1 trang trước
			var nItem:int = MaxSlot;				//Số slot lẻ ra ở trang hiện tại
			if (vt + nItem >= ItemList.length)
			{
				nItem = ItemList.length - vt;
			}
			InitStoreSlot(nItem);
			
			// Thêm các hình ảnh
			var i:int;
			var obj:Object;
			for (i = vt; i < vt + nItem; i++)
			{	
				var st:StockThings = new StockThings();
				st.SetInfo(ItemList[i]);
				obj = ConfigJSON.getInstance().getItemInfo(st.ItemType, st.Id);
				//if (obj["Id"] == 0) continue;
				var container:Container = ContainerArr[i - vt] as Container;
				container.IdObject = "Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID];
				if (st.ItemType == "RecoverHealthSoldier")
				{
					container.setHelper("Use_" + obj["type"] + "_0");
				}
				
				DrawItem(container, obj, st.Num);
			}
			
			IsLoading = false;
			isInitSoreOK = true;
		}
		
		private function DrawItem(container:Container, obj:Object, num:int):void
		{
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnSlotStore") as Sprite;
			var w:int = icon.width * SlotScale - 15;
			var h:int = icon.height * SlotScale - 15;
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
				case "Samurai":
				case "BuffExp":
				case "BuffMoney":
				case "BuffRank":
				case "StoreRank":
				case "Resistance":
					img1 = DrawOther(container, obj);
					img1.FitRect(w, h, new Point(8, 8));
					tooltip = new TooltipFormat();
					tooltip.text = Localization.getInstance().getString(obj["type"] + obj["Id"]);
					container.setTooltip(tooltip);
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
						
						//if (parseInt(aa[2]) != 0)
						//{
							str = str.replace("@Rank@", "cấp " + aa[2]);
						//}
						//else
						//{
							//str = str.replace("@Rank@", "");
						//}
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
			imgName = getImgName(obj);		//obj["type"] + obj[ConfigJSON.KEY_ID];
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
			
			var btn:Button;
			switch (obj["type"])
			{
				case "RecoverHealthSoldier":
				case "Samurai":
				case "Resistance":
				case" StoreRank":
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
					break;
				default:
					var a:Array = obj["type"].split("$");
					if (a[0] == "Gem" && int(a[2]) != 0 && obj["Id"] != 0)
					{
						fmt = new TextFormat();
						fmt.bold = true;
						fmt.color = 0x000000;
						btn = container.AddButton("Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "Btngreen", 10, 85, this);
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
			var image_Name_return:String;
			if (obj["type"].search("Gem") != -1)
			{
				var a:Array = obj["type"].split("$");
				//var distance:int = (parseInt(a[2]) - Constant.GEM_START_DOMAIN) % Constant.GEM_DISTANCE_DOMAIN;
				//image_Name_return = "Gem_" + a[1] + "_" + String(int(a[2]) - distance);
				image_Name_return = "Gem_" + a[1] + "_" + a[2];
			}
			else
			{
				image_Name_return = obj["type"] + obj[ConfigJSON.KEY_ID];
			}
			return image_Name_return;
		}
		
		public function UpdateStore(Type:String, Id:int, num:int = 1):void
		{
			if (IsVisible)
			{
				GameLogic.getInstance().user.UpdateStockThing(Type, Id, num);
				ClearComponent();
				InitStore(CurrentStore, CurrentPage);
			}
			else
			{
				GameLogic.getInstance().user.UpdateStockThing(Type, Id, num);
			}
		}
		
		private function UseStoreItem(Type:String, Id:int):void
		{
			switch (Type)
			{
				case "RecoverHealthSoldier":
					useToolRecoverHealthSoldier(Id);
					break;
				case "Samurai":
					useToolSamurai(Id);
					break;
				case "StoreRank":
					break;
				case "Resistance":
					useToolResistance(Id);
					break;
				case "BuffMoney":
				case "BuffExp":
				case "BuffRank":
					break;
				default:
					if (Type.search("Gem") != -1 && Id != 0)
					{
						useGem(Type, Id);
					}
					break;
			}
			
		}		
		
		private function useGem(Type:String, Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = Type;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_OTHER_BUFF_SOLDIER);
			
			var a:Array = Type.split("$");
			var imageName:String = "Gem_" + a[1] + "_" + a[2];
			GameLogic.getInstance().MouseTransform(imageName, 1, 0, 10, 0);
			
			if (parseInt(a[1]) == FishSoldier.ELEMENT_WATER)
			{
				// Show bar hp lên
				GameLogic.getInstance().ShowGuiFishSoldierStatus(GUIFishStatus.RECOVER_HEALTH, true);
			}
		}
		
		private function useToolResistance(Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "Resistance_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_OTHER_BUFF_SOLDIER);
			GameLogic.getInstance().MouseTransform("Resistance" + Id, 1, 0, 10, 0);
		}
		
		private function useToolSamurai(Id:int):void
		{
			curItemId = Id;
			GameLogic.getInstance().curItemUsed = "Samurai_" + Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_OTHER_BUFF_SOLDIER);
			GameLogic.getInstance().MouseTransform("Samurai$" + Id, 1, 0, 10, 0);
		}
		
		private function useToolRecoverHealthSoldier(Id:int): void
		{
			curItemId = Id;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER);
			GameLogic.getInstance().MouseTransform("RecoverHealthSoldier$" + Id, 1, -45, 10, 0);
			GameLogic.getInstance().ShowGuiFishSoldierStatus(GUIFishStatus.RECOVER_HEALTH, true);
		}
		
		private function UpdateCurrentTab(buttonID:String):void
		{
			btnSupport.img.y = HighY;
			btnSupport.SetFocus(false);
			btnSteel.img.y = HighY;
			btnSteel.SetFocus(false);
			btnWood.img.y = HighY;
			btnEarth.img.y = HighY;
			btnEarth.SetFocus(false);
			btnWater.img.y = HighY;
			btnWater.SetFocus(false);
			btnFire.img.y = HighY;
			btnFire.SetFocus(false);
			
			btnSupport.SetVisible(true);
			btnSteel.SetVisible(true);
			btnWood.SetVisible(true);
			btnEarth.SetVisible(true);
			btnWater.SetVisible(true);
			btnFire.SetVisible(true);
			
			imgEarth.img.visible = false;
			imgSupport.img.visible = false;
			imgSteel.img.visible = false;
			imgWood.img.visible = false;
			imgWater.img.visible = false;
			imgFire.img.visible = false;
			
			switch (buttonID)
			{
				case GUI_STORE_SOLDIER_BTN_SUPPORT:
					btnSupport.SetVisible(false);
					imgSupport.img.visible = true;
					break;
				case GUI_STORE_SOLDIER_BTN_STEEL:
					btnSteel.SetVisible(false);
					imgSteel.img.visible = true;
					break;
				case GUI_STORE_SOLDIER_BTN_WOOD:
					btnWood.SetVisible(false);
					imgWood.img.visible = true;
					break;
				case GUI_STORE_SOLDIER_BTN_EARTH:
					btnEarth.SetVisible(false);
					imgEarth.img.visible = true;
					break;
				case GUI_STORE_SOLDIER_BTN_WATER:
					btnWater.SetVisible(false);
					imgWater.img.visible = true;
					break;
				case GUI_STORE_SOLDIER_BTN_FIRE:
					btnFire.SetVisible(false);
					imgFire.img.visible = true;
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
			
			ClearComponent();
			InitStore(buttonID, 0);
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_STORE_SOLDIER_BTN_NEXT:
					if (CurrentPage < MaxPage - 1)
					{
						ClearComponent();
						InitStore(CurrentStore, CurrentPage + 1);
					}
					
					break;
				case GUI_STORE_SOLDIER_BTN_BACK:
					if (CurrentPage > 0)
					{
						ClearComponent();
						InitStore(CurrentStore, CurrentPage - 1);
					}
					break;
					
				case GUI_STORE_SOLDIER_BTN_STEEL:
				case GUI_STORE_SOLDIER_BTN_WOOD:
				case GUI_STORE_SOLDIER_BTN_SUPPORT:
				case GUI_STORE_SOLDIER_BTN_EARTH:
				case GUI_STORE_SOLDIER_BTN_WATER:
				case GUI_STORE_SOLDIER_BTN_FIRE:
					ChangeTab(buttonID);
					break;
					
				case GUI_STORE_SOLDIER_BTN_CLOSE:
					// Chuyển chuột về trạng thái bình thường
					if (GuiMgr.getInstance().GuiMain.IsVisible)
					{
						GuiMgr.getInstance().GuiMain.img.visible = true;
						GuiMgr.getInstance().GuiMain.imgBgLake.img.visible = true;
					}
					if (GuiMgr.getInstance().GuiFriends.IsVisible)
					{
						GuiMgr.getInstance().GuiFriends.ShowFriend(GuiMgr.getInstance().GuiFriends.page);
					}
					if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
					{
						GameLogic.getInstance().BackToIdleGameState();
					}
					GameController.getInstance().UseTool("Default");
					GameLogic.getInstance().MouseTransform("");
					
					// Không hiện info của cá trong hồ
					GuiMgr.getInstance().GuiMain.ShowLakes();
					Hide();
					break;
				default:
					break;
			}
		}
		
		public override function OnButtonDown(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_STORE_SOLDIER_BTN_NEXT:
				case GUI_STORE_SOLDIER_BTN_BACK:
				case GUI_STORE_SOLDIER_BTN_STEEL:
				case GUI_STORE_SOLDIER_BTN_WOOD:
				case GUI_STORE_SOLDIER_BTN_SUPPORT:
				case GUI_STORE_SOLDIER_BTN_EARTH:
				case GUI_STORE_SOLDIER_BTN_WATER:
				case GUI_STORE_SOLDIER_BTN_FIRE:
				case GUI_STORE_SOLDIER_BTN_CLOSE:
					break;
				default:
					var arr:Array = buttonID.split("_");
					var act:String = arr[0];
					var Type:String = arr[1];
					var Id:int = arr[2];
					var subType:Array = Type.split("$"); 
					
					if (act == "Use" && !arr[3] && subType[2] != 0)
					{
						UseStoreItem(Type, Id);
					}
					break;
			}
		}
		
		private function UpdateContainerHighLight(index:String):void
		{
			var i:int;
			for (i = 0; i < ContainerArr.length; i++)
			{
				var container:Container = ContainerArr[i] as Container;
				if (container.IdObject == index)
				{
					container.SetHighLight(0x00ff00, true);
				}
				else
				{
					container.SetHighLight(-1, true);
				}
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_STORE_SOLDIER_BTN_NEXT:
				case GUI_STORE_SOLDIER_BTN_BACK:
				case GUI_STORE_SOLDIER_BTN_STEEL:
				case GUI_STORE_SOLDIER_BTN_WOOD:
				case GUI_STORE_SOLDIER_BTN_SUPPORT:
				case GUI_STORE_SOLDIER_BTN_EARTH:
				case GUI_STORE_SOLDIER_BTN_WATER:
				case GUI_STORE_SOLDIER_BTN_FIRE:
				case GUI_STORE_SOLDIER_BTN_CLOSE:
					break;
				default:
					UpdateContainerHighLight(buttonID);
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			isMultiClick = false;
			switch (buttonID)
			{
				case GUI_STORE_SOLDIER_BTN_NEXT:
				case GUI_STORE_SOLDIER_BTN_BACK:
				case GUI_STORE_SOLDIER_BTN_STEEL:
				case GUI_STORE_SOLDIER_BTN_WOOD:
				case GUI_STORE_SOLDIER_BTN_SUPPORT:
				case GUI_STORE_SOLDIER_BTN_EARTH:
				case GUI_STORE_SOLDIER_BTN_WATER:
				case GUI_STORE_SOLDIER_BTN_FIRE:
				case GUI_STORE_SOLDIER_BTN_CLOSE:
					break;
				default:
					UpdateContainerHighLight("aaa");
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
				case "Ginseng":
				case "BuffMoney":
				case "BuffExp":
				case "BuffRank":
				case "Resistance":
				case "Samurai":
				case "StoreRank":
					return new Point(btnSupport.img.x, btnSupport.img.y);
				default:
					if (type.search("Gem") != -1)
					{
						var a:Array = type.split("$");
						switch (a[1])
						{
							case "1":
								return new Point(btnSteel.img.x, btnSteel.img.y);
							case "2":
								return new Point(btnWood.img.x, btnWood.img.y);
							case "3":
								return new Point(btnEarth.img.x, btnEarth.img.y);
							case "4":
								return new Point(btnWater.img.x, btnWater.img.y);
							case "5":
								return new Point(btnFire.img.x, btnFire.img.y);
						}
					}
					
			}	
			return new Point(0, 0);
		}
		
		public function HideGUI():void 
		{
			
			if (GuiMgr.getInstance().GuiMain.IsVisible)
			{
				GuiMgr.getInstance().GuiMain.img.visible = true;
				GuiMgr.getInstance().GuiMain.imgBgLake.img.visible = true;
			}
			if (GuiMgr.getInstance().GuiFriends.IsVisible)
			{
				GuiMgr.getInstance().GuiFriends.ShowFriend(GuiMgr.getInstance().GuiFriends.page);
			}
			Hide();
		}
	}
}