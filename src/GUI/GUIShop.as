package GUI 
{
	import adobe.utils.CustomActions;
	import com.bit101.components.Label;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWorld.GUIMixFormulaInfo;
	import Logic.BaseObject;
	import Logic.Decorate;
	import Logic.Fish;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Lake;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendBuyDiscount;
	import NetworkPacket.PacketSend.SendBuyFish;
	import NetworkPacket.PacketSend.SendBuySoldierFish;
	import NetworkPacket.PacketSend.SendBuySpecialFish;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendUpdateG;
	import Sound.SoundMgr;
	/**
	 * ...
	 * @author tuannm3
	 */
	public class GUIShop extends BaseGUI
	{
		private const GUI_SHOP_BTN_NAP_G:String = "ButtonNapG";		
		private const GUI_SHOP_BTN_CLOSE:String = "ButtonClose";		
		private const GUI_SHOP_BTN_DECORATE:String = "Other";
		private const GUI_SHOP_BTN_NEW:String = "New";
		private const GUI_SHOP_BTN_EVENT:String = "Event";
		private const GUI_SHOP_BTN_FISH:String = "Fish";
		private const GUI_SHOP_BTN_BACK_GROUND:String = "BackGround";
		static public const GUI_SHOP_BTN_SALE_OFF:String = "guiShopBtnSaleOff";
		private const GUI_SHOP_BTN_SPECIAL:String = "Special";
		private const GUI_SHOP_BTN_TAB_FISH_0:String = "Fish0";
		private const GUI_SHOP_BTN_TAB_FISH_1:String = "Fish1";
		private const GUI_SHOP_BTN_TAB_FISH_2:String = "Fish2";
		private const GUI_SHOP_BTN_TAB_FISH_3:String = "Fish3";
		private const GUI_SHOP_BTN_TAB_FISH_4:String = "Fish4";
		private const GUI_SHOP_BTN_TAB_FISH_5:String = "Fish5";
		private const GUI_SHOP_BTN_TAB_FISH_6:String = "Fish6";
		private const GUI_SHOP_SPLIT_BTN_TAB_FISH:String = "Fish"
		
		private const GUI_SHOP_BTN_DECORATE2:String = "Deco";
		private const GUI_SHOP_BTN_TREE:String = "OceanTree";
		private const GUI_SHOP_BTN_ANIMAL:String = "OceanAnimal";
		
		// Tab cá lính và item cá lính
		private const GUI_SHOP_BTN_SOLDIER:String = "Soldier";	
		private const GUI_SHOP_BTN_TAB_FISH_SOLDIER:String = "HireFish";
		private const GUI_SHOP_BTN_TAB_FISH_FORMULA:String = "Formula";
		private const GUI_SHOP_BTN_TAB_FISH_SUPPORT:String = "Support";
		private const GUI_SHOP_BTN_TAB_HELMET:String = "Helmet";
		private const GUI_SHOP_BTN_TAB_BODY:String = "Armor";
		private const GUI_SHOP_BTN_TAB_WEAPON:String = "Weapon";
		private const GUI_SHOP_BTN_TAB_JEWELRY:String = "Jewelry";
		
		private const GUI_SHOP_BTN_NEXT:String = "BtnNext";
		private const GUI_SHOP_BTN_BACK:String = "BtnBack";
		
		public static const UNLOCK_TYPE_LEVEL:int = 1;
		public static const UNLOCK_TYPE_MIX:int = 2;
		public static const UNLOCK_TYPE_QUEST:int = 3;
		public static const UNLOCK_TYPE_ZMONEY:int = 4;		
		public static const UNLOCK_TYPE_NO_SELL:int = 5;
		public static const UNLOCK_TYPE_UNUSED:int = 6;
		
		
		// con tro den cac button
		//public var btnNew:Button;
		public var btnEvent:Button;
		private var btnDecorate:Button;
		private var btnFish:Button;
		private var btnBackGround:Button;
		private var btnSpecial:Button;
		private var imgTab:Image;
		private var btnDecorate2:Button;
		private var btnTree:Button;
		private var btnAnimal:Button;
		private var imgFocusBtnDeco:Image;
		private var imgFocusBtnTree:Image;
		private var imgFocusBtnAnimal:Image;
		
		// tab cá lính
		private var btnSoldier:Button;
		
		private var btnHireFish:Button;
		private var btnFormula:Button;
		private var btnSupport:Button;
		private var btnWeapon:Button;
		private var btnHelmet:Button;
		private var btnBody:Button;
		private var imgFocusBtnHireFish:Image;
		private var imgFocusBtnFormula:Image;
		private var imgFocusBtnSupport:Image;
		private var imgFocusBtnWeapon:Image;
		private var imgFocusBtnHelmet:Image;
		private var imgFocusBtnBody:Image;
		
		public var btnNext:Button; 
		public var btnBack:Button;
		public var itemPage:ListBox;
		private var tfThongBao:TextField;
		private var tfNotice:TextField;
		
		private var arrBtnTabFish:Array;
		private var arrImgTabFish:Array;
		private var numTabFish:int = 7;
		
		// so tien va xu
		public var txtXu:TextField = null;
		public var txtGold:TextField = null;
		
		public var BuyType:String = "Money";
		public var BuyObjID:int = 0;

		public var CurrentShop:String = "Fish";
		public var curPage:int = 0;
		private var maxUnlockedFishLevel:int = 0;
		
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var labelSaleOff:TextField;
		private var imgFocusBtnHireFishNew:Image;
		
		public function GUIShop(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIShop";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				GameLogic.getInstance().HideFish();		
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				maxUnlockedFishLevel = GameLogic.getInstance().user.getMaxUnlockedFishLevel();
				
				AddGuiComponent();
				
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
			}
			
			LoadRes("GuiShop_ImgBgGUIShop");
		}
		
		private function AddGuiComponent():void
		{
			//Thong bao
			tfThongBao = AddLabel("", 285, 280);
			var format:TextFormat = new TextFormat()
			format.size = 18;
			format.color = 0x604220;
			format.bold = true;
			tfThongBao.defaultTextFormat = format;
			
			//Lưu ý khi mua đồ trang trí có xp
			tfNotice = AddLabel("", 445, 102);
			format = new TextFormat()
			format.size = 12;
			format.color = 0xff0000;
			format.bold = true;
			format.italic = true;
			tfNotice.defaultTextFormat = format;
			
			// icon cua hang
			//AddImage("", "ShopIconCuaHang", 340, 80);			
			// image tab
			//imgTab = AddImage("", "ShopIconTab", 94, 100, true, ALIGN_LEFT_TOP);
			
			var image:Image;
			// gold
			var txtGFormat:TextFormat = new TextFormat("Arial", 14, 0xffffff, true);
			var gold:Number = GameLogic.getInstance().user.GetMoney();
			txtGold = AddLabel(Ultility.StandardNumber(gold), 260, 535, 0, 0 , 6);
			txtGold.setTextFormat(txtGFormat);
			txtGold.defaultTextFormat = txtGFormat;
			// icon gold
			image = AddImage("", "IcGold", 240, 545);
			//image.SetScaleX(0.8);
			//image.SetScaleY(0.8);
			
			// zing xu
			var txtXuFormat:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
			var xu:int = GameLogic.getInstance().user.GetZMoney();
			txtXu = AddLabel(Ultility.StandardNumber(xu), 375, 535, 0, 0, 6);
			txtXu.setTextFormat(txtXuFormat);
			txtXu.defaultTextFormat = txtGFormat;
			// icon xu
			image = AddImage("", "IcZingXu", 343, 545);
			//image.SetScaleX(0.8);
			//image.SetScaleY(0.8);			
			
			
			
			var btn:Button = AddButton(GUI_SHOP_BTN_CLOSE, "GuiShop_BtnThoat", 705, 18, this);
			//btn.img.scaleX = 0.8;
			//btn.img.scaleY = 0.8;		
			
			// nạp G
			AddButton(GUI_SHOP_BTN_NAP_G, "GuiShop_BtnNapG", 446, 535, this);
		}
		
		public override function  EndingRoomOut():void
		{
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			ClearComponent();
			AddGuiComponent();
			
			var posisitionX:Number = 57;
			
			//Ve tab saleoff
			var isEvent:int = EventMgr.CheckEvent("Event_83_Discount");
			if (isEvent == 0)
			{
				AddImage("", "GuiShop_Selected_SaleOff",  posisitionX, 68, true, ALIGN_LEFT_TOP);
				AddButton(GUI_SHOP_BTN_SALE_OFF, "GuiShop_Btn_SaleOff",  posisitionX, 68, this);
				AddImage("", "IcNew", posisitionX - 10, 64, true, ALIGN_LEFT_TOP);
				posisitionX += 105;
			}
			
			AddImage("", "GuiShop_BtnCaGiong2", posisitionX, 68, true, ALIGN_LEFT_TOP);
			btnFish = AddButton(GUI_SHOP_BTN_FISH, "GuiShop_BtnCaGiong", posisitionX, 68, this, INI.getInstance().getHelper("helper9"));
			
			AddImage("", "GuiShop_BtnCaLinh2", posisitionX + 105, 68, true, ALIGN_LEFT_TOP);
			btnSoldier = AddButton(GUI_SHOP_BTN_SOLDIER, "GuiShop_BtnCaLinh", posisitionX + 105, 68, this);
			
			AddImage("", "GuiShop_BtnTrangTri2", posisitionX + 2*105, 68, true, ALIGN_LEFT_TOP);
			btnDecorate = AddButton(GUI_SHOP_BTN_DECORATE, "GuiShop_BtnTrangTri", posisitionX + 2*105, 68, this, INI.getInstance().getHelper("helper2"));
			
			AddImage("", "GuiShop_BtnSpecial2", posisitionX + 3*105, 68, true, ALIGN_LEFT_TOP);
			btnSpecial = AddButton(GUI_SHOP_BTN_SPECIAL, "GuiShop_BtnSpecial", posisitionX + 3*105, 68, this);			
	
			AddImage("", "GuiShop_BtnHinhNen2", posisitionX + 4*105, 68, true, ALIGN_LEFT_TOP);
			btnBackGround = AddButton(GUI_SHOP_BTN_BACK_GROUND, "GuiShop_BtnHinhNen", posisitionX + 4*105, 68, this);
			
			imgFocusBtnDeco = AddImage("", "GuiShop_BtnDeco2", 70, 104, true, ALIGN_LEFT_TOP);
			btnDecorate2 = AddButton(GUI_SHOP_BTN_DECORATE2, "GuiShop_BtnDeco", 70, 104, this, INI.getInstance().getHelper("helper3"));
			
			imgFocusBtnAnimal = AddImage("", "GuiShop_BtnDongVat2", 170, 104, true, ALIGN_LEFT_TOP);
			btnAnimal = AddButton(GUI_SHOP_BTN_ANIMAL, "GuiShop_BtnDongVat", 170, 104, this);
			
			imgFocusBtnTree = AddImage("", "GuiShop_BtnThucVat2", 270, 104, true, ALIGN_LEFT_TOP);
			btnTree = AddButton(GUI_SHOP_BTN_TREE, "GuiShop_BtnThucVat", 270, 104, this, INI.getInstance().getHelper("helper11"));	
			
			
			// Tabs cá lính ------------------------------------------------------------------------------
			imgFocusBtnHireFish = AddImage("", "GuiShop_ImgTabCaLinh", 70, 104, true, ALIGN_LEFT_TOP);
			btnHireFish = AddButton(GUI_SHOP_BTN_TAB_FISH_SOLDIER, "GuiShop_BtnTabCaLinh", 70, 104, this);
			imgFocusBtnHireFishNew = AddImage("", "IcNew", 36, 104, true, ALIGN_LEFT_TOP);
			imgFocusBtnHireFishNew.img.visible = false;
			
			imgFocusBtnSupport = AddImage("", "GuiShop_ImgTabHoTro", imgFocusBtnHireFish.img.x + imgFocusBtnHireFish.img.width, 104, true, ALIGN_LEFT_TOP);
			btnSupport = AddButton(GUI_SHOP_BTN_TAB_FISH_SUPPORT, "GuiShop_BtnTabHoTro", imgFocusBtnSupport.img.x, imgFocusBtnSupport.img.y, this);
			
			imgFocusBtnFormula = AddImage("", "GuiShop_ImgTabCtLai", imgFocusBtnSupport.img.x + imgFocusBtnSupport.img.width + 6, 104, true, ALIGN_LEFT_TOP);
			btnFormula = AddButton(GUI_SHOP_BTN_TAB_FISH_FORMULA, "GuiShop_BtnTabCtLai", imgFocusBtnFormula.img.x, imgFocusBtnFormula.img.y, this);
			
			imgFocusBtnHelmet = AddImage("", "GuiShop_ImgTabMuGiap", imgFocusBtnFormula.img.x + imgFocusBtnFormula.img.width + 3, 104, true, ALIGN_LEFT_TOP);
			btnHelmet = AddButton(GUI_SHOP_BTN_TAB_HELMET, "GuiShop_BtnTabMuGiap", imgFocusBtnHelmet.img.x, imgFocusBtnHelmet.img.y, this);
			
			imgFocusBtnBody = AddImage("", "GuiShop_ImgTabAoGiap", imgFocusBtnHelmet.img.x + imgFocusBtnHelmet.img.width + 1, 104, true, ALIGN_LEFT_TOP);
			btnBody = AddButton(GUI_SHOP_BTN_TAB_BODY, "GuiShop_BtnTabAoGiap", imgFocusBtnBody.img.x, imgFocusBtnBody.img.y, this);
			
			imgFocusBtnWeapon = AddImage("", "GuiShop_ImgTabVuKhi", imgFocusBtnBody.img.x + imgFocusBtnBody.img.width + 2, 104, true, ALIGN_LEFT_TOP);
			btnWeapon = AddButton(GUI_SHOP_BTN_TAB_WEAPON, "GuiShop_BtnTabVuKhi", imgFocusBtnWeapon.img.x, imgFocusBtnWeapon.img.y, this);
			
			//btnFormula.SetDisable();
			//btnHelmet.SetDisable();
			//btnBody.SetDisable();
			//btnWeapon.SetDisable();
			
			// Hết tabs --------------------------------------------------------------------------------------
			
			btnNext = AddButton(GUI_SHOP_BTN_NEXT, "GuiShop_BtnNextShop", 667, 295, this);
			btnBack = AddButton(GUI_SHOP_BTN_BACK, "GuiShop_BtnPreShop", 42, 295, this);
			
			// để khi hết thức ăn, mua thức ăn. thì nút mua cá không có tác dụng
			if (GameLogic.getInstance().user.IsViewer())
			{
				//btnNew.SetEnable(false);
				btnFish.SetEnable(false);
				btnHireFish.SetEnable(false);
				btnDecorate.SetEnable(false);
				//btnSpecial.SetEnable(false);
				if(btnEvent)
					btnEvent.SetEnable(false);
			}			
			
			if (!Ultility.IsInMyFish())
			{
				//btnNew.SetEnable(false);
				btnFish.SetEnable(false);
				btnSpecial.SetEnable(false);
				btnHireFish.SetEnable(false);
				btnBackGround.SetEnable(false);
				btnFormula.SetEnable(false);
				btnDecorate.SetEnable(false);
			}
			
			ChangeTabPos(CurrentShop);
			showTab(CurrentShop);	

			//tab
			if (CurrentShop == "Other"  || CurrentShop == "OceanTree" || CurrentShop == "OceanAnimal")
			{
				showButtonDecoTab(CurrentShop);
			}
			else
			{
				hideButtonDecoTab();
			}
			var i:int = 0;
			arrBtnTabFish = [];
			arrImgTabFish = [];
			for (i = 0; i < numTabFish; i++) 
			{
				var imgTabFish:Image = AddImage("Fish" + i, "GuiShop_ImgTabFish" + i, 95 + 75 * i, 103, true, ALIGN_LEFT_TOP);
				arrImgTabFish.push(imgTabFish);
				var btnTabFish:Button = AddButton(GUI_SHOP_BTN_FISH + i, "GuiShop_BtnTabFish" + i, 95 + 75 * i, 103, this);
				arrBtnTabFish.push(btnTabFish);
			}
			
			if ((CurrentShop.search(GUI_SHOP_SPLIT_BTN_TAB_FISH) >= 0) && (CurrentShop != "HireFish"))
			{
				showButtonFishTab(CurrentShop);
			}
			else
			{
				hideButtonFishTab();
			}			
			
			if (CurrentShop == "Helmet" || CurrentShop == "Armor" || CurrentShop == "Weapon"
				|| CurrentShop == "HireFish" || CurrentShop == "Formula" || CurrentShop == "Support"
				|| CurrentShop == "Jewelry")
			{
				showButtonSoldierTab(CurrentShop);
			}
			else
			{
				hideButtonSoldierTab();
			}
		}
		
		/**
		 * Đổi focus vào tab đang mở
		 * @param	ShopType	Loại tab hiện ra: cá, đồ trang trí, hay thức ăn
		 */
		public function ChangeTabPos(ShopType:String):void
		{
			//btnNew.SetFocus(false);			
			btnFish.SetFocus(false);
			btnSoldier.SetFocus(false);
			btnBackGround.SetFocus(false);
			btnDecorate.SetFocus(false);
			btnSpecial.SetFocus(false);
			btnDecorate2.SetFocus(false);
			btnAnimal.SetFocus(false);
			btnTree.SetFocus(false);
			
			btnHelmet.SetFocus(false);
			btnBody.SetFocus(false);
			btnWeapon.SetFocus(false);
			btnHireFish.SetFocus(false);
			btnFormula.SetFocus(false);
			btnSupport.SetFocus(false);
			if(GetButton(GUI_SHOP_BTN_SALE_OFF) != null)
			{
				GetButton(GUI_SHOP_BTN_SALE_OFF).SetFocus(false);
			}
			
			if (btnEvent)
				btnEvent.SetFocus(false);
			switch (ShopType)
			{
				case GUI_SHOP_BTN_SALE_OFF:
					GetButton(GUI_SHOP_BTN_SALE_OFF).SetFocus(true);
					break;
				//case "New":
					//btnNew.SetFocus(true);
					//break;		
				case "Event":
					btnEvent.SetFocus(true);
					break;					
				case "Fish":
					btnFish.SetFocus(true);
					break;				
				case "BackGround":
					btnBackGround.SetFocus(true);
					break;				
				case "Other":
					btnDecorate.SetFocus(true);
					btnDecorate2.SetFocus(true);
					break;
				case "OceanAnimal":
					btnDecorate.SetFocus(true);
					btnAnimal.SetFocus(true);
					break;
				case "OceanTree":
					btnDecorate.SetFocus(true);
					btnTree.SetFocus(true);
					break;					
				case "Special":
					btnSpecial.SetFocus(true);
					break;
				case "Soldier":
					btnSoldier.SetFocus(true);
					//btnSupport.SetFocus(true);
					btnHireFish.SetFocus(true);
					break;		
				case "Support":
					btnSoldier.SetFocus(true);
					btnSupport.SetFocus(true);
					break;		
				case "HireFish":
					btnSoldier.SetFocus(true);
					btnHireFish.SetFocus(true);
					break;		
				case "Formula":
					btnSoldier.SetFocus(true);
					btnFormula.SetFocus(true);
					break;		
				case "Helmet":
					btnSoldier.SetFocus(true);
					btnHelmet.SetFocus(true);
					break;		
				case "Armor":
					btnSoldier.SetFocus(true);
					btnBody.SetFocus(true);
					break;		
				case "Weapon":
					btnSoldier.SetFocus(true);
					btnWeapon.SetFocus(true);
					break;
				//case "Jewelry":
					//btnSoldier.SetFocus(true);
					//btnJewelry.SetFocus(true);
			}
		}			
		
		
		public function showTab(type:String):void
		{
			if (CurrentShop != type)
			{
				CurrentShop = type;	
				curPage = 0;				
			}
			else if(itemPage != null)
			{
				itemPage.speed = -1;
				itemPage.showPage(curPage);	
				itemPage.speed = 1;
			}
			
			var row:int = 2;
			var col:int = 3;
			var obj:Object;
			var i:int = 0
			
			var ItemList:Array;
			if ((type.search(GUI_SHOP_SPLIT_BTN_TAB_FISH) >= 0) && (type != "HireFish"))
			{
				if (type == GUI_SHOP_BTN_TAB_FISH_6)
				{
					ItemList = ConfigJSON.getInstance().getItemList("SuperFish");
					ItemList.sortOn("Id");
				}
				else
				{
					ItemList = ConfigJSON.getInstance().getItemList(GUI_SHOP_SPLIT_BTN_TAB_FISH);
				}
				if(labelSaleOff != null)
				{
					labelSaleOff.visible = false;
				}
			}
			//Tab saleoff
			else if (type == GUI_SHOP_BTN_SALE_OFF)
			{
				ItemList = [];
				var config:Object = ConfigJSON.getInstance().getItemInfo("EventDiscount");
				for (var s:String in config)
				{
					config[s]["IdDiscount"] = int(s);
					ItemList.push(config[s]);
				}
				
				if (labelSaleOff == null)
				{
					var txtFormat:TextFormat = new TextFormat("arial", 18);
					var event:Object = ConfigJSON.getInstance().GetItemList("Event")["Event_83_Discount"];
					var date:Date = new Date(event["BeginTime"]*1000);
					var startDate:String = date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear();
					date = new Date(event["ExpireTime"]*1000);
					var endDate:String = date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear();
					labelSaleOff = AddLabel("Giảm giá từ " + startDate + " đến " + endDate, 110 + 120, 105, 0xff0000, 0, 0xffffff);
					labelSaleOff.setTextFormat(txtFormat);
				}
				labelSaleOff.visible = true;
			}
			else 
			{
				if(labelSaleOff != null)
				{
					labelSaleOff.visible = false;
				}
				ItemList = ConfigJSON.getInstance().getItemList(type);
				
				for (i = 0; i < ItemList.length; i++)
				{
					var idSt:String = ItemList[i]["Id"];
					if (idSt && idSt.search("Dice") >= 0)
					{
						ItemList.splice(i, 1);
						i--;
					}
				}
			}
			
			if (type != GUI_SHOP_BTN_SPECIAL && (type != GUI_SHOP_BTN_TAB_FISH_6) && (type != "HireFish"))
			{
				if (type == GUI_SHOP_BTN_SALE_OFF)
				{
					ItemList.sortOn("IdDiscount", Array.NUMERIC);
				}
				else
				if (type != "Support" && type != "Helmet" && type != "Weapon" && type != "Armor")
				{
					ItemList.sortOn("LevelRequire", Array.NUMERIC);
				}
				
				
				// Tach cac nhom Fish
				if (type.search(GUI_SHOP_SPLIT_BTN_TAB_FISH) >= 0)
				{
					var idTabFish:int = 0;
					if (type.split(GUI_SHOP_SPLIT_BTN_TAB_FISH))
					{
						idTabFish = type.split(GUI_SHOP_SPLIT_BTN_TAB_FISH)[1];
					}
					if (idTabFish < numTabFish -1)
					{
						for (i = 0; i < ItemList.length; i++) 
						{
							var item:Object = ItemList[i];
							if (item["LevelRequire"] <= idTabFish * 10)
							{
								ItemList.splice(i, 1);
								i--;
							}
							if(idTabFish < numTabFish - 2)
							{
								if (item["LevelRequire"] > (idTabFish + 1) * 10)
								{
									ItemList.splice(i, 1);
									i--;
								}
							}
						}
					}
				}
			}
			if(itemPage && itemPage.numItem > 0) itemPage.removeAllItem();  //Xóa hết các item đã add ở các tab trước
			itemPage = AddListBox(ListBox.LIST_X, row, col, 6, 5); 			
			//itemPage.setPos(46, 131);
			itemPage.setPos(76, 135);
			var container:Container;
			var count:int = 0;
			
			for (i = 0; i < ItemList.length; i++) 
			{
				if (type != GUI_SHOP_BTN_SALE_OFF)
				{
					obj = getItemInfo(i, ItemList);
				}
				//obj trong tab saleoff
				else
				{
					obj = new Object();
					var t:String;
					var configObj:Object = ConfigJSON.getInstance().getItemInfo(ItemList[i]["ItemType"], ItemList[i]["ItemId"]);
					for (t in configObj)
					{
						obj[t] = configObj[t];
					}
					for (t in ItemList[i])
					{
						obj[t] = ItemList[i][t];
					}
					obj["LevelRequire"] = 0;
				}
				if (canShow(obj))
				{
					if (obj["type"] == "Draft" || obj["type"] == "Paper" || obj["type"] == "GoatSkin" || obj["type"] == "Blessing") 
					{
						itemPage.addItem(obj["type"] + "_" + obj[ConfigJSON.KEY_ID], drawItemContainer(obj), this);
						if (obj[ConfigJSON.KEY_ID] == 5)
						{
							//itemPage.itemList.push(new Container(null, ""));
						}
					}
					else if (obj.type == "Helmet" || obj.type == "Armor" || obj.type == "Weapon"
								|| obj.type == "Bracelet" || obj.type == "Belt" 
								|| obj.type == "Ring" || obj.type == "Necklace")
					{
						itemPage.addItem("Ctn$" + obj.type + "_" + obj.subtype, drawItemContainer(obj), this);
					}
					else
					{
						itemPage.addItem("", drawItemContainer(obj));
					}
					count++;
				}
			}
			
			tfThongBao.text = "";
			//Nếu của hàng trống thì hiện 1 dòng thông báo
			if (count <= 0)
			{
				tfThongBao.text = "Gian hàng này đang cập nhật. Bạn quay lại sau nhé!!!";				
			}
			
			
			//Nếu số lượng item lớn hơn số lượng item 1 trang có thể chứa thì hiện nút next, back
			if (count > row * col)
			{
				btnNext.SetVisible(true);
				btnBack.SetVisible(true);
			}
			else
			{
				btnNext.SetVisible(false);
				btnBack.SetVisible(false);		
			}
			checkEnabelBtnNextBack();
			
			if (itemPage != null)
			{
				itemPage.speed = -1;
				itemPage.showPage(curPage);	
				itemPage.speed = 1;
			}
		}
		
		
		private function drawItemContainer(obj:Object):Container
		{
			var arr:Array;
			var lbl:TextField;
			var txtFormat:TextFormat;
			var imgItem:Image;
			var container:Container = new Container(itemPage, "GuiShop_CtnShopItem");
			var tip:TooltipFormat = new TooltipFormat();
			var tmpFm:TextFormat = new TextFormat();
			tmpFm.bold = true;
			tmpFm.color = 0x0000ff;			
			tip.defaultTextFormat = tmpFm;
			switch(obj["type"])
			{
				case "Fish":
				case "HireFish":
					drawFisContainer(container, obj);
					return container;			
				case "SuperFish":
					drawSuperFish(container, obj);
					return container;	
				case "Other": 
				case "OceanTree":
					addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					tip.text = "Thời hạn sử dụng: " + obj["TimeUse"]/86400 + " ngày";
					container.setTooltip(tip);
					break;
				
				case "Draft":
				case "Paper":
				case "GoatSkin":
				case "Blessing":
					container.IdObject = obj["type"] + "_" + obj[ConfigJSON.KEY_ID];
					/*container.AddImage("", "GuiShop_CtnDoTrangTriBg", container.img.width/ 2, 70);
					addContentToContainer(container, "KindFormula" + obj[ConfigJSON.KEY_ID], obj["type"] + "_" + GUIMixFormulaInfo.getElementsName(obj["Elements"]) + "_", 
											container.img.width/ 2, 70);*/
					addContentToContainer(container, container.IdObject, "GuiShop_CtnDoTrangTriBg", container.img.width/ 2, 70);
					break;
					
				case "GodCharm":
					addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					arr = Localization.getInstance().getString(obj["type"] + obj[ConfigJSON.KEY_ID]).split("\n");
					tip.text = arr[1] + "\n" + arr[2];
					container.setTooltip(tip);
					break;
					
				case "Ginseng":
					addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					var tttip:TooltipFormat = new TooltipFormat();
					var tt1:String = Localization.getInstance().getString(obj["type"] + obj[ConfigJSON.KEY_ID]);
					var ttt:String = tt1.split("\n")[1];
					if (tt1.split("\n")[2] != null)
					{
						ttt += "\n " + tt1.split("\n")[2];
					}
					ttt = ttt.replace("@Value@", int(obj.Expired / (3600 * 24)) + "");
					tttip.text = ttt;
					container.setTooltip(tttip);
					break;
				case "RecoverHealthSoldier":
					addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					var ttip:TooltipFormat = new TooltipFormat();
					var t:String = Localization.getInstance().getString(obj["type"] + obj[ConfigJSON.KEY_ID]);
					var tt:String = t.split("\n")[1];
					if (t.split("\n")[2] != null)
					{
						tt += "\n " + t.split("\n")[2];
					}
					tt = tt.replace("@Value@", obj.Num + "");
					ttip.text = tt;
					container.setTooltip(ttip);
					break;
				case "BuffItem":
					addContentToContainer(container, obj["subtype"] + obj["Id"], "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					var ttipp:TooltipFormat = new TooltipFormat();
					var t1:String = Localization.getInstance().getString(obj["subtype"] + obj["Id"]);
					var t2:String = t1.split("\n")[1];
					if (t1.split("\n")[2] != null)
					{
						t2 += " \n" + t1.split("\n")[2];
					}
					ttipp.text = t2.replace("@Value@", obj["Num"]);
					container.setTooltip(ttipp);
					break;
				case "Helmet":
				case "Armor":
				case "Weapon":
				case "Bracelet":
				case "Belt":
				case "Ring":
				case "Necklace":
					arr = obj["subtype"].split("$");		//arr[0] = id; arr[1] = color;
					var name:String = obj["type"] + arr[0] + "_Shop";
					var imag:Image;
					if (obj.LevelRequire <= GameLogic.getInstance().user.GetLevel())
					{
						imag = addContentToContainer(container, name, "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					}
					else
					{
						//vẽ ảnh item bị đen đi
						var f:Function = function():void //Hàm này truyền vào để đổi màu item
						{
							var c:ColorTransform = new ColorTransform(0, 0, 0, 2, 0, 0, 0, 0);
							this.img.transform.colorTransform = c;
						}	
						imag = addContentToContainer(container, name, "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70, f);
					}
					FishSoldier.EquipmentEffect(imag.img, int(arr[1]));
					break;
				case "OceanAnimal":
					imgItem = addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					imgItem.GoToAndStop(2);
					tip.text = "Thời hạn sử dụng: " + obj["TimeUse"]/86400 + " ngày";
					container.setTooltip(tip);
					break;
				case "MixLake":
					addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width/ 2, 70);			
					break;
				case "Food":
					addContentToContainer(container, "ImgFoodBox", "GuiShop_CtnDoTrangTriBg", container.img.width/ 2, 70);
					// SO LUONG
					//container.AddImage("", "BGSoLuong", 70, 76, true, ALIGN_LEFT_TOP);
					txtFormat = new TextFormat("Arial", 14, 0xffffff);
					txtFormat.align = TextFormatAlign.CENTER;
					var tg:int = obj["Num"] / 5;
					lbl = container.AddLabel(tg.toString(), 65, 80, 0, 1, 0x26709C);
					lbl.setTextFormat(txtFormat);
					break;
				// Comment
				case "LakeUpgrade"://Mở rộng hồ
					imgItem = addContentToContainer(container, "IconUpgradeLake", "GuiShop_CtnMuaCaBg", container.img.width/ 2, 55);
					//Vẽ thêm số
					lbl = container.AddLabel(obj[ConfigJSON.KEY_ID], imgItem.img.x - 79, imgItem.img.y - 60);
					txtFormat = new TextFormat("Arial", 16, 0xffffff, true);
					lbl.setTextFormat(txtFormat);
					Ultility.SetHightLight(lbl);			
					break;
				// Comment
				case "LakeUnlock"://Mua hồ mới
					imgItem = addContentToContainer(container, "IconUnlockLake", "GuiShop_CtnMuaCaBg", container.img.width/ 2, 55);
					//Vẽ thêm số
					lbl = container.AddLabel(obj[ConfigJSON.KEY_ID], imgItem.img.x - 81, imgItem.img.y - 34);
					txtFormat = new TextFormat("Arial", 16, 0xffffff, true);
					lbl.setTextFormat(txtFormat);
					Ultility.SetHightLight(lbl);
					break;
				case "LevelMixLake"://Bi kip lai
					imgItem = addContentToContainer(container, "IconLicense", "GuiShop_CtnMuaCaBg", container.img.width/ 2, 55);
					//Cấp của bí kíp
					lbl = container.AddLabel(obj[ConfigJSON.KEY_ID], imgItem.img.x - 1, imgItem.img.y - 10);
					txtFormat = new TextFormat("Arial", 14, 0xffffff, true);
					lbl.setTextFormat(txtFormat);
					lbl.autoSize = TextFieldAutoSize.CENTER;
					Ultility.SetHightLight(lbl);
					//Thông tin chi tiết: "Có thể lai cá đến cấp..."
					if (obj["levelRequire"] <= GameLogic.getInstance().user.GetLevel())
					{
						txtFormat = new TextFormat("Arial", 11, 0x000000, true);
						txtFormat.align = TextFormatAlign.CENTER;
						var st:String = Localization.getInstance().getString("GUILabel32");
						lbl = container.AddLabel(st + " " + obj["MaxFishLevel"], 45, 88);
						lbl.setTextFormat(txtFormat);
						lbl.multiline = true;
						lbl.wordWrap = true;						
					}
					break;
				case "License"://Giấy phép hồ
					imgItem = addContentToContainer(container, "License1", "GuiShop_CtnDoTrangTriBg", container.img.width/ 2, 70);
					break;
				//case "Petrol"://Bình xăng
					//imgItem = addContentToContainer(container, "Petrol", "GuiShop_CtnDoTrangTriBg", container.img.width/ 2, 70);
					//break;
				//case "ReviveMedicine":
					//addContentToContainer(container, "License1", "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
					//break;
				case "BackGround":
					drawBackGround(container, obj);
					break;
				default:				
					addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width/ 2, 70);
					break;					
			}
			if (obj["type"] == "EnergyMachine")
			{
				container.IdObject = "containerEnergyMachine";
			}
			drawExtraInfo(container, obj);
			return container;
		}
		
		
		private function drawBackGround(container:Container, obj:Object):void
		{
			addContentToContainer(container, obj["type"] + obj[ConfigJSON.KEY_ID], "GuiShop_CtnDoTrangTriBg", container.img.width / 2, 70);
			container.AddButton(obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_View", "GuiShop_BtnPreview", 55, 110, this);			
			
			var tip:TooltipFormat = new TooltipFormat();
			var tmpFm:TextFormat = new TextFormat();
			tmpFm.bold = true;
			tmpFm.color = 0x0000ff;			
			tip.defaultTextFormat = tmpFm;
			tip.text = "Thời hạn sử dụng: " + obj["TimeUse"]/86400 + " ngày";
			container.setTooltip(tip);
		}
		
	
		/**
		 * Thêm content vào container
		 * @param	container	container chứa content
		 * @param	objImgName	tên ảnh của đối tượng cần add
		 * @param	bgImgName	tên background nằm dưới ảnh của đối tượng
		 * @param	xBgImg		vị trí background theo phương x so với container
		 * @param	yBgImg		vị trí background theo phương y so với container
		 * @return
		 */
		private function addContentToContainer(container:Container, objImgName:String, bgImgName:String, xBgImg:int, yBgImg:int, setInfo:Function = null):Image
		{			
			var image:Image = container.AddImage("", bgImgName, xBgImg, yBgImg);
			var imgItem:Image = container.AddImage("", objImgName, 0, 0, true, ALIGN_CENTER_CENTER, false, setInfo);
			var rect:Rectangle = image.img.getBounds(container.img);
			imgItem.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
			
			//hard code cho tooltip
			//hiển thị tooltips
			var tip:TooltipFormat = new TooltipFormat();
			var tmpFm:TextFormat = new TextFormat();
			tmpFm.bold = true;
			tmpFm.color = 0x0000ff;
			var subStringId:String = objImgName.substring(objImgName.length - 1, objImgName.length);
			var idItem:int = (int) (subStringId);
			var sType:String;
			if (idItem != 0)
			{
				sType  = objImgName.substring(0, objImgName.length - 1);
			}
			else
			{
				sType = objImgName;
			}
			switch(sType)
			{
				case "Viagra":
				{
					tip.text = "Giúp cá đã lai có thể lai thêm lần nữa\nMỗi cá chỉ sử dụng được 1 lọ / ngày";
					tip.setTextFormat(tmpFm);
					container.setTooltip(tip);
					break;
				}
				case "EnergyMachine":
				{
					var strEnergyLimit:String = ConfigJSON.getInstance().getEnergyMachineLimit(idItem).toString();
					tip.text = "Giúp tăng giới hạn năng lượng thêm " + strEnergyLimit + " năng lượng";
					tip.setTextFormat(tmpFm);
					container.setTooltip(tip);
					break;
				}
				case "Petrol":
				{
					var iExpiredTime:int = (ConfigJSON.getInstance().getExpiredTimePetrol(idItem) / 86400);
					tip.text = "Sử dụng khi có máy năng lượng\n Giúp máy hoạt động trong " + iExpiredTime.toString() +" ngày";
					tip.setTextFormat(tmpFm);
					container.setTooltip(tip);
					break;
				}
			}
			
			
			return imgItem;
		}		
		
		
		private function drawFisContainer(container:Container, obj:Object):Image
		{
			var imgItem:Image;
			var name:String;
			//if (obj[ConfigJSON.KEY_ID] < Constant.FISH_TYPE_START_SOLDIER)
			if (!obj["FishTypeId"])
			{
				name = Localization.getInstance().getString(Fish.ItemType + obj[ConfigJSON.KEY_ID]);
			}
			else
			{
				name = Localization.getInstance().getString(Fish.ItemType + obj["FishTypeId"]);
			}
			
			
			//Add tên
			var txtFormat:TextFormat = new TextFormat("Arial", 14, 0x854F3D, true);
			var lbl:TextField = container.AddLabel(name, 45, 3);
			lbl.setTextFormat(txtFormat);	
			
			// kiem tra xem co mua dc ko
			var hint:String;
			switch(obj["UnlockType"])
			{
				case UNLOCK_TYPE_LEVEL:
					if (obj["LevelRequire"] > GameLogic.getInstance().user.GetLevel()) //Nếu level yêu cầu lớn hơn level người chơi
					{
						hint = Localization.getInstance().getString("GUILabe20").replace("@level", obj["LevelRequire"]);
						imgItem = drawSecretFish(container, obj, hint);						
					}
					else
					{
						imgItem = drawRevealFish(container, obj);
					}
					break;
				case UNLOCK_TYPE_MIX:
					var unlockType:int = GameLogic.getInstance().user.CheckFishUnlocked(obj[ConfigJSON.KEY_ID]);
					if (unlockType == 0)
					{
						hint = Localization.getInstance().getString("GUILabe21");
						if (obj["LevelRequire"] < maxUnlockedFishLevel)
						{
							imgItem = drawCanUnlockedFish(container, obj, hint);							
						}
						else
						{							
							imgItem = drawSecretFish(container, obj, hint);
						}
					}
					else
					{
						imgItem = drawRevealFish(container, obj);
					}
					break;
				case UNLOCK_TYPE_QUEST:
					unlockType = GameLogic.getInstance().user.CheckFishUnlocked(obj[ConfigJSON.KEY_ID]);
					if (unlockType == 0)
					{
						hint = Localization.getInstance().getString("GUILabe22");
						imgItem = drawSecretFish(container, obj, hint);								
						//Button chi tiết
						container.AddButton(obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_View", "Button_AceptGift", 55, 145, this);									
					}
					else
					{
						imgItem = drawRevealFish(container, obj);
					}
					break;
			}		
				
			//cá mới
			if (obj["IsNew"] == true)
			{
				container.AddImage("", "GuiShop_IcNewShop", 45, 50);
			}			
			return imgItem;
		}
		
		/**
		 * Vẽ con cá có thể được unlock bằng xu
		 * @param	container	container mà trên đó cá được vẽ lên
		 * @param	obj		đối tượng chứa thông tin con cá
		 * @return
		 */
		private function drawCanUnlockedFish(container:Container, obj:Object, hintUnlock:String):Image
		{
			//vẽ ảnh con cá bí ẩn bị mờ mờ đi
			var f:Function = function():void //Hàm này truyền vào để đổi màu cá
			{
				var c:ColorTransform = new ColorTransform(0.4, 0.4, 0.4, 0.8, 0, 0, 0, 0);
				this.img.transform.colorTransform = c;
			}		
			var imgItem:Image = addContentToContainer(container, "Fish" + obj[ConfigJSON.KEY_ID] + "_Old_Idle", "GuiShop_CtnMuaCaBg", container.img.width / 2, 55, f);	
			drawFishInfo(container, obj, 45, 88);
			
			//icon khóa
			container.AddImage("", "ImgShopItemLock", 85, 40, true, ALIGN_LEFT_TOP);
			
			drawHintUnlock(container, hintUnlock, 40, 128);	
			
			//var txtFormat:TextFormat;
			//var lbl:TextField;
			
			//txtFormat = new TextFormat("Arial", 11, 0xff0000);
			//txtFormat.align = TextFormatAlign.CENTER;
			//lbl = container.AddLabel(hintUnlock, 0, 0);
			//lbl.setTextFormat(txtFormat);
			//lbl.width = 60;
			//lbl.multiline = true;
			//lbl.wordWrap = true;
			//lbl.x = 25;
			//lbl.y = 137;
			
			addButtonUnlockZMoney(container, obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_ZMoneyUnlock", obj["ZMoneyUnlock"], 35, 173);
			
			//Vẽ level requrie
			if (obj["LevelRequire"] > 0)
			{
				var imgEXP:Image = container.AddImage("", "GuiShop_ImgLvRequire", 22, 12, true, ALIGN_LEFT_TOP);
				var format:TextFormat = new TextFormat();
				format.color = 0xFFFF00;
				format.align = "center";
				var txtLevel:TextField = container.AddLabel("0", imgEXP.img.x - 33, imgEXP.img.y + 6, 0, 1, 0x26709C);
				txtLevel.text = obj["LevelRequire"];
				txtLevel.setTextFormat(format);
			}
			return imgItem;
		}
		
		/**
		 * Vẽ con cá đã được unlock với đầy đủ thông tin
		 * @param	container	container mà trên đó cá được vẽ lên
		 * @param	obj		đối tượng chứa thông tin con cá
		 * @return
		 */
		private function drawRevealFish(container:Container, obj:Object):Image
		{			
			//Vẽ hình con cá
			var imgItem:Image;
			if (obj["FishTypeId"] >= Constant.FISH_TYPE_START_SOLDIER)
			{
				imgItem = addContentToContainer(container, "Fish" + obj["FishTypeId"] + "_Old_Idle", "GuiShop_CtnMuaCaBg", container.img.width / 2, 55);	
			}
			else
			{
				imgItem= addContentToContainer(container, "Fish" + obj[ConfigJSON.KEY_ID] + "_Old_Idle", "GuiShop_CtnMuaCaBg", container.img.width / 2, 55);	
			}
			
			//var imgItem:Image = addContentToContainer(container, "Fish" + obj[ConfigJSON.KEY_ID] + "_Old_Idle", "GuiShop_CtnMuaCaBg", container.img.width / 2, 55);			
			
			//thông tin chi tiết về: thời gian trưởng thành, kinh nghiệm thu được, tiền thu được
			drawFishInfo(container, obj, 45, 88);			
			
			//Add button mua
			addButtonBuyMoney(container, obj, 13, 152);
			addButtonBuyZMoney(container, obj, 113, 152);
			
			//Vẽ level requrie
			if (obj["LevelRequire"] > 0)
			{
				var imgEXP:Image = container.AddImage("", "GuiShop_ImgLvRequire", 22, 12, true, ALIGN_LEFT_TOP);
				var format:TextFormat = new TextFormat();
				format.color = 0xFFFF00;
				format.align = "center";
				var txtLevel:TextField = container.AddLabel("0", imgEXP.img.x - 33, imgEXP.img.y + 6, 0, 1, 0x26709C);
				txtLevel.text = obj["LevelRequire"];
				txtLevel.setTextFormat(format);
			}
			
			// Vẽ thuộc tính nếu là cá lính
			if (obj["Id"] >= Constant.FISH_TYPE_START_SOLDIER)
			{
				container.AddImage("", "GuiShop_ImgLvRequire", 135, 12, true, ALIGN_LEFT_TOP);
				var imgElement:Image = container.AddImage("", "Element" + obj["Element"], 142, 18, true, ALIGN_LEFT_TOP);
				imgElement.FitRect(20, 20);
			}
			return imgItem;
		}
		
		/**
		 * Vẽ con cá chưa được unlock - màu đen
		 * @param	container	container mà trên đó cá được vẽ lên
		 * @param	obj		đối tượng chứa thông tin con cá
		 * @return
		 */
		private function drawSecretFish(container:Container, obj:Object, hintUnlock:String):Image
		{			
			//vẽ ảnh con cá bí ẩn bị mờ mờ đi
			var f:Function = function():void //Hàm này truyền vào để đổi màu cá
			{
				var c:ColorTransform = new ColorTransform(0, 0, 0, 2, 0, 0, 0, 0);
				this.img.transform.colorTransform = c;
			}		
			var imgItem:Image;

			if (obj["FishTypeId"] >= Constant.FISH_TYPE_START_SOLDIER)
			{
				imgItem = addContentToContainer(container, "Fish" + obj["FishTypeId"] + "_Old_Idle", "GuiShop_CtnMuaCaBg", container.img.width / 2, 55, f);	
			}
			else
			{
				imgItem= addContentToContainer(container, "Fish" + obj[ConfigJSON.KEY_ID] + "_Old_Idle", "GuiShop_CtnMuaCaBg", container.img.width / 2, 55, f);	
			}
			
			//icon khóa
			container.AddImage("", "ImgShopItemLock", 40, 80, true, ALIGN_LEFT_TOP);							
			drawHintUnlock(container, hintUnlock, 40, 115);			
			
			//Vẽ level requrie
			if (obj["LevelRequire"] > 0)
			{
				var imgEXP:Image = container.AddImage("", "GuiShop_ImgLvRequire", 22, 22, true, ALIGN_LEFT_TOP);
				var format:TextFormat = new TextFormat();
				format.color = 0xFFFF00;
				format.align = "center";
				var txtLevel:TextField = container.AddLabel("0", imgEXP.img.x - 33, imgEXP.img.y + 6, 0, 1, 0x26709C);
				txtLevel.text = obj["LevelRequire"];
				txtLevel.setTextFormat(format);
			}
			return imgItem;
		}	
		
		
		/**
		 * Vẽ gợi ý unlock
		 * @param	container
		 * @param	hintUnlock
		 * @param	x
		 * @param	y
		 * @return
		 */
		private function drawHintUnlock(container:Container, hintUnlock:String, x:int, y:int):void
		{
			var txtFormat:TextFormat;
			var lbl:TextField;
			//Format chuỗi chỉ dẫn cách unlock
			txtFormat = new TextFormat("Arial", 11, 0xff0000);
			txtFormat.align = TextFormatAlign.CENTER;
			lbl = container.AddLabel(hintUnlock, 0, 0);
			lbl.setTextFormat(txtFormat);
			lbl.width = 105;
			lbl.multiline = true;
			lbl.wordWrap = true;
			lbl.x = x;
			lbl.y = y;	
		}
		
		
		// thong tin chi tiet cua ca
		private function drawFishInfo(container:Container, obj:Object, x:int, y:int ):void
		{			
			var txtFormat:TextFormat = new TextFormat("Arial", 11, 0x604220);
			txtFormat.bold = true;	
			var lbl:TextField;
			//if (obj["FishTypeId"] < Constant.FISH_TYPE_START_SOLDIER)
			if (!obj["FishTypeId"])
			{
				//Truong thanh
				lbl = container.AddLabel(Localization.getInstance().getString("GUILabel2") + " " + obj["Growing"][5] / 3600 + "h", x, y);
				lbl.setTextFormat(txtFormat);
				
				//Thu nhap
				lbl = container.AddLabel(Localization.getInstance().getString("GUILabel3") + " " + Math.round(obj["MaxValue"]), x, y + 14);
				lbl.setTextFormat(txtFormat);
				
				//Exp
				lbl = container.AddLabel(Localization.getInstance().getString("GUILabel4") + " " + obj["Exp"], x, y + 28);
				lbl.setTextFormat(txtFormat);				
			}
			else
			{
				// Hệ 
				//lbl = container.AddLabel(Localization.getInstance().getString("GUILabel40") + " " + Localization.getInstance().getString("Element" + obj["Elements"]), x, y);
				//lbl.setTextFormat(txtFormat);
				
				// Lực chiến
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("Damage", -1)[obj.subtype][obj.Id];
				lbl = container.AddLabel(Localization.getInstance().getString("GUILabel41") + " " + cfg["Damage"].Min + " - " + cfg["Damage"].Max, x, y);
				lbl.setTextFormat(txtFormat);
				lbl = container.AddLabel(Localization.getInstance().getString("GUILabel48") + " " + cfg["Defence"].Min + " - " + cfg["Defence"].Max, x, y + 14);
				lbl.setTextFormat(txtFormat);
				lbl = container.AddLabel(Localization.getInstance().getString("GUILabel49") + " " + cfg["Critical"].Min + " - " + cfg["Critical"].Max, x, y + 28);
				lbl.setTextFormat(txtFormat);
				lbl = container.AddLabel(Localization.getInstance().getString("GUILabel50") + " " + cfg["Vitality"].Min + " - " + cfg["Vitality"].Max, x, y + 42);
				lbl.setTextFormat(txtFormat);
				
				// Hạn sử dụng
				//var day:int = obj["LifeTime"] / (24 * 60 * 60);
				//lbl = container.AddLabel(Localization.getInstance().getString("GUILabel42") + " " + day + " ngày", x, y + 28);
				//lbl.setTextFormat(txtFormat);
				
				container.AddImage("", "Element" + obj.Elements, 100, 100).FitRect(30, 30, new Point(135, 70));
			}
		}
		
		/**
		 * Trong vòng 10 ngày tính từ lúc xuất xưởng thì đó là đồ mới
		 * @param	obj
		 * @return
		 */
		private function isNew(obj:Object):Boolean
		{
			if (obj["ReleaseTime"])
			{
				var strTime:String = obj["ReleaseTime"];
				var arr:Array = strTime.split("_");
				//var tiem:int = new ti
				var date:Date = new Date(arr[2], arr[1] - 1, arr[0]);				
				var dTime:Number = GameLogic.getInstance().CurServerTime - date.getTime() / 1000;
				if (dTime / (3600 * 24) < 10) return true; 
			}
			return false;
		}
		
		
		/**
		 * Vẽ các thông tin chi tiết của các item trong kho không phải là cá:
		 * Chữ "New" nếu là đồ vật mới
		 * Tên item
		 * Cấp độ yêu cầu nếu chưa đủ level
		 * Thông tin chi tiết như sức chứa, kinh nghiệm nếu item là "Mở rộng hồ", "Mua hồ mới"
		 * Nút mua bằng vàng, nút mua bằng xu
		 * @param	container
		 * @param	obj
		 */
		private function drawExtraInfo(container:Container, obj:Object):void
		{
			// do vat mo'i
			//if (obj["IsNew"] == true)
			
			if (obj["type"] == "Draft")
			{
				//trace("test");
			}
			if (isNew(obj))
			{
				container.AddImage("", "GuiShop_IcNewShop", 150, 50);
				//container.AddImage("", "IcGold", 120, 40, true, ALIGN_LEFT_TOP);
			}
			// ten cua item
			var st:String = obj[ConfigJSON.KEY_NAME];
			if (obj["type"] == "LevelMixLake")
			{
				st = Localization.getInstance().getString("LevelMixLake") + " " + obj[ConfigJSON.KEY_ID];
			}
			if (obj["type"] == "Ginseng" || obj["type"] == "RecoverHealthSoldier" || obj["type"] == "GodCharm")
			{
				st = Localization.getInstance().getString(obj["type"] + obj["Id"]);
				st = st.split("\n")[0];
			}
			else if (obj["type"] == "BuffItem")
			{
				st = Localization.getInstance().getString(obj["subtype"] + obj["Id"]);
				st = st.split("\n")[0];
			}
			else if (obj["type"] == "Helmet" 
				|| obj["type"] == "Armor" 
				|| obj["type"] == "Weapon"
				|| obj["type"] == "Bracelet"
				|| obj["type"] == "Necklace"
				|| obj["type"] == "Ring"
				|| obj["type"] == "Belt")
			{
				st = Localization.getInstance().getString(obj["type"] + obj.subtype.split("$")[0]);
			}
			//TODO: lay config name tu server
			if (st == null || st == "")
			{
				st = Localization.getInstance().getString(obj["type"] + obj["Id"]);
			}
			var txtFormat:TextFormat = new TextFormat("Arial", 14, 0x854F3D, true);
			var lbl:TextField = container.AddLabel(st, 45, 3);
			lbl.setTextFormat(txtFormat);
			// cap do yeu cau
			if (obj["LevelRequire"] > GameLogic.getInstance().user.GetLevel())
			{
				container.AddLabel("Cấp : " + obj["LevelRequire"], 45, 140, 0xff0000);				
				// khóa				
				container.AddImage("", "ImgShopItemLock", 40, 93, true, ALIGN_LEFT_TOP);				
			}
			else
			{
				// thong tin chi tiet
				switch (obj["type"])
				{				
					case "LakeUpgrade":
					case "LakeUnlock":
						// suc chua
						txtFormat = new TextFormat("Arial", 11, 0x374965, true);
						lbl = container.AddLabel("Sức chứa " + obj["TotalFish"], 45, 88);
						lbl.setTextFormat(txtFormat);
						// exp
						txtFormat = new TextFormat("Arial", 11, 0x374965, true);
						lbl = container.AddLabel(Localization.getInstance().getString("GUILabel4") + obj["Exp"], 45, 102);
						lbl.setTextFormat(txtFormat);
						break;
					case "Other": case "OceanTree":	case "OceanAnimal":
						txtFormat = new TextFormat("Arial", 11, 0x604220, true);
						lbl = container.AddLabel("Exp: " + obj["Exp"], 45, 113);
						lbl.setTextFormat(txtFormat);
						break;
				}
				
				//Add button mua
				addButtonBuyMoney(container, obj, 13, 152);
				addButtonBuyZMoney(container, obj, 113, 152);
			}		
			
			//Vẽ level requrie
			if (obj["type"] != "Food" &&  obj["type"] != "License" && obj["type"] != "BackGround" && obj["LevelRequire"] > 0)
			{
				var imgEXP:Image = container.AddImage("", "GuiShop_ImgLvRequire", 22, 22, true, ALIGN_LEFT_TOP);
				var format:TextFormat = new TextFormat();
				format.color = 0xFFFF00;
				format.align = "center";
				var txtLevel:TextField = container.AddLabel("0", imgEXP.img.x - 33, imgEXP.img.y + 6, 0, 1, 0x26709C);
				txtLevel.text = obj["LevelRequire"];
				txtLevel.setTextFormat(format);
			}
			
			// Nếu là trang bị cá lính có thông báo ko thể giao dịch
			if (obj["type"] == "Helmet" || obj["type"] == "Armor" || obj["type"] == "Weapon"
				|| obj["type"] == "Ring" || obj["type"] == "Necklace" || obj["type"] == "Belt" || obj["type"] == "Bracelet")
			{
				//var txtTrade:TextField = container.AddLabel("Trang bị không thể giao dịch được.", 20, 114);
				//var formatTrade:TextFormat = new TextFormat();
				//formatTrade.color = 0xFF0000;
				//formatTrade.align = "center";
				//formatTrade.italic = true;
				//txtTrade.wordWrap = true;
				//txtTrade.width = 150;
				//txtTrade.setTextFormat(formatTrade);
				
				container.AddImage("", "Element" + obj.Element, 100, 100).FitRect(30, 30, new Point(130, 100));
			}
			
			//Đồ giảm giá
			if (obj["IdDiscount"] != null)
			{
				var config:Object = ConfigJSON.getInstance().getItemInfo(obj["type"], obj["Id"]);
				var percent:Number = int(100 * (1 - Number( obj["ZMoney"] / config["ZMoney"])));
				container.AddImage("", "GuiShop_IcSaleOff", 68, 60).SetScaleXY(0.7);
				container.AddLabel(percent + "%", 12, 48, 0x0000ff);
				
				var numBuy:int = GameLogic.getInstance().user.GetMyInfo().NumBuyDiscount[obj["IdDiscount"]];
				var remainTimes:int = int(obj["MaxItem"]) - numBuy;
				container.AddLabel("Còn " + Ultility.StandardNumber(remainTimes) + " lần mua", 45, 126, 0x0000ff);
			}
		}
		
		
		// thong tin chi tiet cua ca super
		private function drawSuperFishInfo(container:Container, obj:Object, x:int, y:int ):void
		{			
			//Thời hạn
			if (obj["Expired"] == 30)
			{
				container.AddImage("", "GuiShop_ImgExpired30", 125, 46);
			}
			else
			{
				container.AddImage("", "GuiShop_ImgExpired7", 125, 46);
			}
			
			var txtFormat:TextFormat = new TextFormat("Arial", 11, 0x604220);
			txtFormat.bold = true;			
			
			//Truong thanh
			var lbl:TextField = container.AddLabel(Localization.getInstance().getString("GUILabel43") + " " + obj["Option"]["Exp"] + "%", x, y);
			lbl.setTextFormat(txtFormat);
			
			//Thu nhap
			lbl = container.AddLabel(Localization.getInstance().getString("GUILabel44") + " " + obj["Option"]["Money"] + "%", x, y + 14);
			lbl.setTextFormat(txtFormat);
			
			//Exp
			lbl = container.AddLabel(Localization.getInstance().getString("GUILabel45") + " " + obj["Option"]["Time"] + "%", x, y + 28);
			lbl.setTextFormat(txtFormat);				
		}
		
		
		/**
		 * Vẽ siêu cá
		 * @param	container	container mà trên đó cá được vẽ lên
		 * @param	obj		đối tượng chứa thông tin con cá
		 * @return
		 */
		private function drawSuperFish(container:Container, obj:Object):Image
		{			
			//Vẽ hình con cá
			var imgItem:Image = addContentToContainer(container, obj[ConfigJSON.KEY_ID], "GuiShop_CtnMuaCaBg", container.img.width / 2, 55);			
			
			var name:String = GuiMgr.getInstance().GuiStore.GetNameFishSpecial(obj[ConfigJSON.KEY_ID]);
			//Add tên
			var txtFormat:TextFormat = new TextFormat("Arial", 14, 0x854F3D, true);
			var lbl:TextField = container.AddLabel(name, 45, 3);
			lbl.setTextFormat(txtFormat);	
			
			//thông tin chi tiết về: thời gian trưởng thành, kinh nghiệm thu được, tiền thu được
			drawSuperFishInfo(container, obj, 45, 88);			
			
			//Add button mua
			addButtonBuyMoney(container, obj, 13, 152);
			addButtonBuyZMoney(container, obj, 113, 152);
			
			return imgItem;
		}
		
		
		
		
		/**
		 * Thêm nút mua bằng xu
		 * @param	container nơi mà nút mua được add lên
		 * @param	obj	 đối tượng chứa thông tin về giá tiền
		 * @param	x	vị trí x của nút mua bằng xu
		 * @param	y	vị trí y của nút mua bằng xu
		 */
		private function addButtonBuyZMoney(container:Container, obj:Object, x:int, y:int):void
		{
			var iconImg:Image;
			var lbl:TextField;
			var user:User = GameLogic.getInstance().user;
			var btnID:String;
			var id:String;
			if (CurrentShop == GUI_SHOP_BTN_SALE_OFF)
			{
				id = obj["Id"] + "_" + obj["IdDiscount"];
				//trace(id);
			}
			else
			{
				id = obj["Id"];
			}
			if (!obj["subtype"])
			{
				btnID = obj["type"] + "_" + id + "_ZMoney";
			}
			else
			{
				btnID = obj["type"] + "$" + obj["subtype"] + "_" + id + "_ZMoney";
			}
			var zMoney:int = obj["ZMoney"];
				
			//add so xu can mua
			if (zMoney <= 0 || obj["UnlockType"] == UNLOCK_TYPE_NO_SELL || obj["type"] == "Fish") zMoney = 0;				
			
			var HelperID:String = "";
			// nut mua xu
			HelperID = btnID;
			var btnXu:Button = container.AddButton(btnID, "GuiShop_BtnBuyXu", x, y, this, HelperID);
			if (zMoney > user.GetZMoney() || zMoney == 0 )
			{
				btnXu.SetDisable();
			}
			
			// so xu can mua
			//iconImg = container.AddImage("", "IcZingXu", x + 25, y - 10);
			//iconImg.SetScaleX(0.8);
			//iconImg.SetScaleY(0.8);
			if (zMoney > user.GetZMoney())
			{
				//Nếu không đủ tiền thì hiện màu đỏ
				lbl = container.AddLabel(Ultility.StandardNumber(zMoney), x - 20, y, 0xff0000, 1);
			}
			else
			{							
				lbl = container.AddLabel(Ultility.StandardNumber(zMoney), x - 20, y, 0x005500, 1);
			}
			
			//Đoạn này hardcode
			switch(obj["type"])
			{
				case "Fish": // Là cá thì không bán bằng xu
					btnXu.SetDisable();
					break;
				case "SuperFish":
					//Check xem có được mua nữa không
					var BuySuperFishTime:Object = GameLogic.getInstance().user.GetMyInfo().BuySuperFishTime;
					if (BuySuperFishTime[obj[ConfigJSON.KEY_ID]] <= 0)
					{
						btnXu.SetDisable();
						var tt:TooltipFormat = new TooltipFormat();
						tt.text = "Ngày mai quay lại nhé";
						btnXu.setTooltip(tt);
					}
					break;					
				case "OceanTree": // Là thực vật biển có giá = 1 xu thì không bán bằng xu
					if (zMoney == 1)
					{
						btnXu.SetDisable();
					}
					break;
				case "EnergyMachine": //Là máy năng lượng, nếu có rồi thì không bán nữa
					if (GameLogic.getInstance().user.GetMyInfo().hasMachine)
					{
						btnXu.SetDisable();
					}					
					break;					
			}
			
			if (CurrentShop == GUI_SHOP_BTN_SALE_OFF)
			{
				var numBuy:int = GameLogic.getInstance().user.GetMyInfo().NumBuyDiscount[obj["IdDiscount"]];
				var remainTimes:int = int(obj["MaxItem"]) - numBuy;
				if (remainTimes <= 0)
				{
					btnXu.SetDisable();
					var tool:TooltipFormat = new TooltipFormat();
					tool.text = "Hết số lượt mua";
					btnXu.setTooltip(tool);
				}
			}
			
			//Nếu là loại không bán thì disable
			if (obj["UnlockType"] == UNLOCK_TYPE_NO_SELL)
			{
				btnXu.SetDisable();
			}		
		}
		
		
		/**
		 * Thêm nút unlock bằng xu
		 * @param	container nơi mà nút mua được add lên
		 * @param	obj	 đối tượng chứa thông tin về giá tiền
		 * @param	x	vị trí x của nút mua bằng xu
		 * @param	y	vị trí y của nút mua bằng xu
		 */
		private function addButtonUnlockZMoney(container:Container, btnID:String, zMoney:int, x:int, y:int):void
		{
			var iconImg:Image;
			var lbl:TextField;
			var user:User = GameLogic.getInstance().user;	
			
			var HelperID:String = "";
			var btnXu:Button;
			// nut unlock =  xu
			HelperID = btnID;
			btnXu = container.AddButton(btnID, "Btngreen", x, y, this, HelperID);
			btnXu.img.width = 115;
			btnXu.img.height = 28;
			if (zMoney > user.GetZMoney() || zMoney == 0)
			{
				btnXu.SetDisable();
			}			
	
			//Tính toán dựa vào số tiền để add label của nút vào giữa cho đẹp
			var lbX:int = x + 13 - zMoney.toString().length * 3;
						
			//Add lable nút: "Mở ngay"
			lbl = container.AddLabel("Mở ngay:", lbX , y - 25, 0x604220, 0);			
				
			//add so xu can mua
			if (zMoney <= 0) zMoney = 0;
			// so xu can mua
			iconImg = container.AddImage("", "IcZingXu", lbX + 70, y - 25, true, ALIGN_CENTER_TOP);
			iconImg.SetScaleX(0.8);
			iconImg.SetScaleY(0.8);
			lbl = container.AddLabel(Ultility.StandardNumber(zMoney), lbX + 79, y - 25, 0x604220, 0);
		}
		
		/**
		 * Thêm nút mua bằng vàng
		 * @param	container nơi mà nút mua được add lên
		 * @param	obj	 đối tượng chứa thông tin về giá tiền
		 * @param	x	vị trí x của nút mua bằng vàng
		 * @param	y	vị trí y của nút mua bằng vàng
		 */
		private function addButtonBuyMoney(container:Container, obj:Object, x:int, y:int):void
		{
			var iconImg:Image;
			var lbl:TextField;
			var user:User = GameLogic.getInstance().user;
			
			if (!obj["Money"] || obj["Money"] <= 0 || obj["UnlockType"] == UNLOCK_TYPE_NO_SELL)	obj["Money"] = 0;
			
			var id:String;
			if (CurrentShop == GUI_SHOP_BTN_SALE_OFF)
			{
				if (obj["type"] == "GoatSkin")
				{
					id = obj["Elements"]  + "_" + obj["IdDiscount"];
				}
				else
				{
					id = obj["Id"] + "_" + obj["IdDiscount"];
				}
			}
			else
			{
				id = obj["Id"];
			}
			
			// nut mua gold
			var HelperID:String = "";			
			//if (obj["gold"] > 0)
			{
				HelperID = obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_Money";
				var btnGold:Button;
				if (!obj["subtype"])
				{
					btnGold = container.AddButton(obj["type"] + "_" + id + "_Money", "GuiShop_BtnBuyGold", x, y, this, HelperID);
				}
				else
				{
					btnGold = container.AddButton(obj["type"] + "$" + obj["subtype"] + "_" + id + "_Money", "GuiShop_BtnBuyGold", x, y, this, HelperID);
				}
				if (obj["Money"] > user.GetMoney() || obj["Money"] == 0)
				{
					btnGold.SetDisable();
				}
				
				if (CurrentShop == GUI_SHOP_BTN_SALE_OFF)
				{
					var numBuy:int = GameLogic.getInstance().user.GetMyInfo().NumBuyDiscount[obj["IdDiscount"]];
					var remainTimes:int = int(obj["MaxItem"]) - numBuy;
					if (remainTimes <= 0)
					{
						btnGold.SetDisable();
						var tool:TooltipFormat = new TooltipFormat();
						tool.text = "Hết số lượt mua trong ngày";
						btnGold.setTooltip(tool);
					}
				}
				
				//Nếu là động vật biển tạm thời disable đi
				if (obj["UnlockType"] == UNLOCK_TYPE_NO_SELL)
				{
					btnGold.SetDisable();
				}
			}
			
			//add so gold can mua			
			//iconImg = container.AddImage("", "IcGold", x + 22, y - 10);
			//iconImg.SetScaleX(0.8);
			//iconImg.SetScaleY(0.8);
			if (obj["Money"] > user.GetMoney())
			{
				//Nếu không đủ tiền thì hiện màu đỏ
				lbl = container.AddLabel(Ultility.StandardNumber(obj["Money"]), x - 15, y, 0xff0000, 1);
			}
			else
			{							
				lbl = container.AddLabel(Ultility.StandardNumber(obj["Money"]), x - 15, y, 0x663333, 1);
			}
		}		
		
		
		/**
		 * Lấy thông tin của các item trong file config
		 * @param	index	chỉ số trong mảng item lấy từ file config
		 * @param	list	mảng item lấy từ file config
		 * @return đối tượng có đầy đủ thông tin cần thiết
		 */
		private function getItemInfo(index:int, list:Array):Object
		{
			var obj:Object;
			var a:Array;
			switch (list[index]["type"])
			{
				case "Helmet":
				case "Armor":
				case "Weapon":
				case "Bracelet":
				case "Necklace":
				case "Ring":
				case "Belt":
					obj = ConfigJSON.getInstance().GetEquipmentInfo(list[index]["type"], list[index]["Id"]);
					break;
				case "LakeUnlock":
				case "LakeUpgrade":
					obj = list[index];
					break;
				case "LakeUpgrade":
					break;
				case "SuperFish":
					obj = ConfigJSON.getInstance().getSuperFishInfo(list[index][ConfigJSON.KEY_ID]);
					break;
				case "BuffItem":
					a = list[index]["Id"].split("_");
					obj = ConfigJSON.getInstance().GetBuffItemInfo(a[0], int(a[1]));
					break;
				case "HireFish":
					//obj = ConfigJSON.getInstance().GetItemInfo(list[index]["type"], list[index][ConfigJSON.KEY_ID], list[index]["subtype"]);
					obj = ConfigJSON.getInstance().getHireFish(list[index]["type"], list[index][ConfigJSON.KEY_ID], list[index]["subtype"]);
					break;
				default:
					//obj = INI.getInstance().getItemInfo(list[index][ConfigJSON.KEY_ID], list[index]["type"]);
					obj = ConfigJSON.getInstance().getItemInfo(list[index]["type"], list[index][ConfigJSON.KEY_ID]);
					break;
			}
			return obj;
		}
		
		
		/**
		 * Kiểm tra xem item đó có được hiện trong shop không.
		 * Ví dụ nếu là cá bí ẩn thì không được show lên hoặc chưa đến bí kíp lai tiếp theo thì không show lên
		 * @param	obj
		 * @return true nếu được show, false nếu ko được show
		 */
		private function canShow(obj:Object):Boolean
		{				
			//if (obj["type"] == "LevelMixLake")
			//{ro
				//var user:User = GameLogic.getInstance().user;
				//if (obj[ConfigJSON.KEY_ID] != (user.LevelMixLake+1))
					//return false;
			//}
			if ((obj["UnlockType"] == UNLOCK_TYPE_QUEST) || (obj["UnlockType"] == UNLOCK_TYPE_UNUSED))
				return false;
				
			if (obj["type"] == "LakeUnlock")
				return false;
			if (obj["type"] != "BackGround" &&(obj["Id"] > Constant.FISH_TYPE_START_DOMAIN) &&
				((obj["Id"] - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN != 0) &&
				(obj["Id"] < Constant.FISH_TYPE_START_SOLDIER))
			{
				return false;
			}
				
			return true;
		}
		
		
		/**
		 * Làm 1 số việc như mua hoặc xem chi tiết của item trong kho,
		 * được gọi khi click vào nút mua bằng vàng, mua bằng xu, xem chi tiết
		 * @param	ID:		id của button khi click vào nút mua bằng vàng, mua bằng xu, xem chi tiết
		 * Mua bằng vàng: id = type + "_" + id + "_Money"
		 * Mua bằng xu: id = type + "_" + id + "_ZMoney"
		 * Xem chi tiết: id = type + "_" + id + "_View"
		 * Hậu tố là "View", "Money", "ZMoney" có thể biết được action là gì
		 */
		private function doSomeThing(ID:String):void
		{
			var data:Array = ID.split("_");
			if (data.length < 2) return;
				
			var objType:String = data[0];
			var objID:int = data[1];			
			
			if (data[2] == "View")
			{
				viewSomeThing(objType, objID);
			}
			else
			{
				if (objType == "SuperFish")
				{
					GameLogic.getInstance().BuySpecialFish(data[1], data[2]);
					EndingRoomOut();
				}
				else if (data[2])
				{
					//Mua đồ giảm giá
					if (CurrentShop == GUI_SHOP_BTN_SALE_OFF)
					{
						BuyType = data[3];
						if(objType != "GoatSkin")
						{
							EffectMgr.setEffBounceDown("Mua thành công", objType + objID, 330, 280);
						}
						else
						{
							EffectMgr.setEffBounceDown("Mua thành công", objType + "_" + objID, 330, 280);
						}
						
						//Gui goi tin
						var isMoney:Boolean = false;
						if (BuyType != "ZMoney")
						{
							isMoney = true;
						}
						var idDiscount:int = data[2];
						//trace(idDiscount, isMoney);
						var sendBuyDiscount:SendBuyDiscount = new SendBuyDiscount(idDiscount, isMoney);
						Exchange.GetInstance().Send(sendBuyDiscount);
						
						//Cap nhat
						if(GameLogic.getInstance().user.GetMyInfo().NumBuyDiscount[idDiscount] != null)
						{
							GameLogic.getInstance().user.GetMyInfo().NumBuyDiscount[idDiscount]++;
						}
						else
						{
							GameLogic.getInstance().user.GetMyInfo().NumBuyDiscount[idDiscount] = 1;
						}
						var config:Object = ConfigJSON.getInstance().getItemInfo("EventDiscount", idDiscount);
						if (!isMoney)
						{
							GameLogic.getInstance().user.UpdateUserZMoney(- config["ZMoney"]);
						}
						GuiMgr.getInstance().GuiStore.UpdateStore(objType, objID);
						showTab(CurrentShop);
					}
					else
					{
						BuyType = data[2];
						BuyObjID = objID;
						BuySomeThing(objType, objID);
					}
				}
			}
		}
		
		/**
		 * Xem thông tin chi tiết của item trong cửa hàng khi click vào nút chi tiết
		 * @param	objType		Loại của item
		 * @param	objId		id của item
		 */
		private function viewSomeThing(objType:String, objId:int):void
		{
			//GuiMgr.getInstance().GuiSecretFishInfo.FishTypeId = objId;
			//GuiMgr.getInstance().GuiSecretFishInfo.Show(Constant.GUI_MIN_LAYER, 2);
			switch(objType)
			{
				case "BackGround":
					GameController.getInstance().changeBackGround(objId);
					Hide();
					GuiMgr.getInstance().GuiPreviewBgr.Show(Constant.GUI_MIN_LAYER + 1, 1);
					GameLogic.getInstance().SetState(GameState.GAMESTATE_PREVIEW_BACKGROUND);
					
					// Ẩn layer GUI - longpt
					//LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).visible = false;
					GuiMgr.getInstance().GuiMain.img.visible = false;
					GuiMgr.getInstance().GuiFriends.img.visible = false;
					break;
				default:
					break;
			}
		}
		
		/**
		 * Mua item trong kho
		 * @param	objType	Loại của item
		 * @param	objId	id của item
		 */
		private function BuySomeThing(objType:String, objID:int):void
		{				
			switch (objType)
			{
				case "Other":
				case "OceanTree":
				case "OceanAnimal":
				BuyDecorate(objID, objType);
					break;
					
				case "BackGround":
					if (GameLogic.getInstance().user.getNumBgr(objID) < Constant.LIMIT_BACKGROUND_NUM)
					{
						GameLogic.getInstance().buyBackGround(objID);
					}
					else
					{
						GameLogic.getInstance().SetState(GameState.GAMESTATE_BUY_BACKGROUND);
						GuiMgr.getInstance().GuiMessageBox.itemIdBgr = objID;
						GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(Localization.getInstance().getString("Message33") );
					}
					break;
				
				case "Fish":
					if (objID < Constant.FISH_TYPE_START_SOLDIER)
					{
						BuyFish(objID);
					}
					else
					{
						//BuySpecialFish(objID);
					}
					break;		
				case "HireFish":
					BuySpecialFish(objID, objType);
					break;
				case "Food":
					BuyFood(objID, objType);
					break;
				case "LakeUpgrade":
					ShowUpgradeLake(objID);
					
					//GameLogic.getInstance().DoUpgradeLake();
					//GameController.getInstance().UseTool("Shop");
					break;
					
				case "LakeUnlock":
					ShowUnlockLake(objID-1);
					//GameLogic.getInstance().DoUnlockLake(lake);
					//GameController.getInstance().UseTool("Shop");
					break;
				case "EnergyMachine":
					GameLogic.getInstance().user.GenerateNextID();
				case "EnergyItem":
				case "License":
				case "Material":
				case "Viagra":
				case "Petrol":
				case "Ginseng":
				case "RecoverHealthSoldier":
					GameLogic.getInstance().BuyItem(objID, objType, BuyType);
					EndingRoomOut();
					break;
				case "Icon":
					buyEventIcon(objID);
					break;
				case "MixFormula_Draft":
				case "Draft":
				case "Paper":
				case "GoatSkin":
				case "Blessing":
					GameLogic.getInstance().BuyItem(objID, objType, BuyType);
					EndingRoomOut();
					break;
				default:
					if (objType.search("BuffItem") != -1)
					{
						var buffType:String = objType.split("$")[1];
						GameLogic.getInstance().BuyItem(objID, buffType, BuyType);
					}
					else if (objType.search("Helmet") != -1 || objType.search("Armor") != -1 || objType.search("Weapon") != -1
							|| objType.search("Bracelet") != -1 || objType.search("Belt") != -1 
							|| objType.search("Ring") != -1 || objType.search("Necklace") != -1)
					{
						var equipType:Array = objType.split("$");
						GameLogic.getInstance().BuyEquipment(objType, BuyType);
					}
					else if (objType.search("HireFish") != -1)
					{
						BuySpecialFish(objID, objType);
					}
					else
					{
						GameLogic.getInstance().BuyItem(objID, objType, BuyType);
					}
					EndingRoomOut();
					break;
			}
		}
		
		private function ShowUpgradeLake(objID:int):void
		{
			var lake:Lake;
			var st:String;
			

			lake = GameLogic.getInstance().user.GetLake(objID);
			st = Localization.getInstance().getString("Message2");
			st = st.replace("@GiaTien", lake.GetUpgradeMoney());
			st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
			GameLogic.getInstance().SetState(GameState.GAMESTATE_UPGRADE_LAKE);
			GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
		}
		
		private function ShowUnlockLake(objID:int):void
		{
			var lake:Lake;
			var st:String;
			
			lake = GameLogic.getInstance().user.LakeArr[objID];
			GuiMgr.getInstance().GuiMain.SelectedLake = lake;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_UNLOCK_LAKE);
			st = Localization.getInstance().getString("Message1");
			st = st.replace("@GiaTien", lake.GetUnlockMoney());
			st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
			GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
		}
		
		//Mua icon trong event truy tim kho bau
		public function buyEventIcon(idIcon:int):void
		{
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Icon", idIcon);
			//GuiMgr.getInstance().GuiBuyItem.showBuyItem(obj);
			EndingRoomOut();
		}
		
		public function BuyFood(ItemId:int, ItemType:String):void
		{
			GameLogic.getInstance().BuyItem(ItemId, ItemType, BuyType, false);
			this.Hide();
		}
		
		public function FinishBuy():void
		{
			// hide cover layer
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.HideDisableScreen();
			}
		}
		public function BuySpecialFish(ID:int, type:String):void
		{
			GameLogic.getInstance().user.GenerateNextID();
			var type:String;
			var isMoney:Boolean;
			//if (type == "HireFish")
			{
				//type = "Rent";
				if (BuyType == "Money")
				{
					isMoney = true;
					var price:int = ConfigJSON.getInstance().getHireFish(type.split("$")[0], ID, type.split("$")[1])[BuyType];
					GameLogic.getInstance().user.UpdateUserMoney( -price);
				}
				else if (BuyType == "ZMoney")
				{
					isMoney = false;
					var priceX:int = ConfigJSON.getInstance().getItemInfo("HireFish", ID)[BuyType];
					GameLogic.getInstance().user.UpdateUserZMoney( -priceX);
				}
			}
			
			
			// Gửi gói tin mua cá đặc biệt
			var cmd:SendBuySoldierFish = new SendBuySoldierFish(type.split("$")[1], ID, isMoney);
			Exchange.GetInstance().Send(cmd);
			
			// Update vào kho
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
				GuiMgr.getInstance().GuiStore.UpdateStore("BabyFish", ID);
			}
			else
			{
				GameLogic.getInstance().user.UpdateStockThing("BabyFish", ID);
			}
			
			EffectMgr.setEffBounceDown("Mua thành công", Fish.ItemType + ConfigJSON.getInstance().GetItemList("MixFormula")[type.split("$")[1]][ID].FishTypeId + "_" + Fish.OLD + "_" + Fish.HAPPY, 330, 280);
			//[ID]GetItemInfo(type, ID)["FishTypeId"] + "_" + Fish.OLD + "_" +Fish.HAPPY, 330, 280);
			//Refresh lại gui shop
			GuiMgr.getInstance().GuiShop.EndingRoomOut();
		}
		
		public function BuyFish(ID:int):void
		{
			if (BuyType == "ZMoneyUnlock")
			{
				GameLogic.getInstance().user.AddFishUnlock(ID, UNLOCK_TYPE_ZMONEY);
				//Gửi gói tin unlock = xu
				var cmd:SendBuyFish = new SendBuyFish(GameLogic.getInstance().user.CurLake.Id);
				
				//Khởi tạo dữ liệu gửi lên
				var obj:Object = new Object();
				obj[ConfigJSON.KEY_ID] = GameLogic.getInstance().user.GenerateNextID();
				obj["FishType"] = ID;
				obj[ConfigJSON.KEY_NAME] = "";
				obj["Sex"] = 1;
				obj["PriceType"] = "ZMoney";
				cmd.FishList.push(obj);		
				
				Exchange.GetInstance().Send(cmd);
				
				var o:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, ID);
				GameLogic.getInstance().user.UpdateUserZMoney(-o["ZMoneyUnlock"]);
				
				//Refresh lại gui shop
				GuiMgr.getInstance().GuiShop.EndingRoomOut();
				return;
			}
			
			var pt:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			GameLogic.getInstance().gameState = GameState.GAMESTATE_BUY_FISH;
			
			var fish:Fish = new Fish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), Fish.ItemType + ID + "_Baby_Happy");
			fish.img.scaleX = fish.img.scaleY = 0.5;
			fish.FishTypeId = ID;
			fish.SetPos(pt.x, pt.y);			
			GameController.getInstance().SetActiveObject(fish);
			GuiMgr.getInstance().GuiBuyFish.fish = fish;
			
			
			this.Hide();
			GuiMgr.getInstance().GuiBuyFish.Show();
			
			//Tăng số lượng cá đã mua lên 1
			GuiMgr.getInstance().GuiBuyFish.nFish++;			
			
			// show cover layer
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.ShowDisableScreen(0);
			}
		}
		
		public function BuyDecorate(ItemID:int, ItemType:String):void
		{
			var pt:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			GameLogic.getInstance().gameState = GameState.GAMESTATE_BUY_DECORATE;
			
			var deco:Decorate = new Decorate(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), ItemType + ItemID, pt.x, pt.y, ItemType, ItemID);
			deco.SetHighLight();
			deco.ObjectState = BaseObject.OBJ_STATE_BUY;
			deco.UpdateDeep();
			if (!deco.CheckPosition())
			{
				deco.ShowDisable(true);
			}
			GameController.getInstance().SetActiveObject(deco);	
			//GameController.getInstance().UpdateActiveObjPos(pt.x, pt.y);
			this.Hide();
			
			// show buy decorate GUI
			//var obj:Object = INI.getInstance().getItemInfo(ItemID.toString(), ItemType);
			//GuiMgr.getInstance().GuiBuyDecorate.ShowBuyDeco(Constant.GUI_MIN_LAYER + 1, obj[ConfigJSON.KEY_NAME], obj["gold"]);
			
			// show cover layer
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.ShowDisableScreen(0.01);
			}
		}		
		
		public function showButtonDecoTab(focusTab:String):void
		{
			btnAnimal.SetVisible(true);
			btnDecorate2.SetVisible(true);
			btnTree.SetVisible(true);
			imgFocusBtnAnimal.img.visible = true;
			imgFocusBtnDeco.img.visible = true;
			imgFocusBtnTree.img.visible = true;
			switch(focusTab)
			{
				case "Other":
					btnDecorate2.SetVisible(false);
					break;
				case "OceanTree":
					btnTree.SetVisible(false);
					break;
				case "OceanAnimal":
					btnAnimal.SetVisible(false);
					break;
			}
			tfNotice.text = "Lưu ý: Nhận kinh nghiệm khi mua bằng G";
		}
		
		public function showButtonSoldierTab(focusTab:String):void
		{
			btnHireFish.SetVisible(true);
			btnFormula.SetVisible(true);
			btnSupport.SetVisible(true);
			btnWeapon.SetVisible(true);
			btnBody.SetVisible(true);
			btnHelmet.SetVisible(true);
			//btnJewelry.SetVisible(true);
			imgFocusBtnFormula.img.visible = true;
			imgFocusBtnHireFish.img.visible = true;
			imgFocusBtnHireFishNew.img.visible = false;
			imgFocusBtnWeapon.img.visible = true;
			imgFocusBtnHelmet.img.visible = true;
			imgFocusBtnBody.img.visible = true;
			imgFocusBtnSupport.img.visible = true;
			//imgFocusBtnJewelry.img.visible = true;
			
			switch (focusTab)
			{
				case "HireFish":
					btnHireFish.SetVisible(false);
					break;
				case "Formula":
					btnFormula.SetVisible(false);
					break;
				case "Support":
					btnSupport.SetVisible(false);
					break;
				case "Weapon":
					btnWeapon.SetVisible(false);
					break;
				case "Helmet":
					btnHelmet.SetVisible(false);
					break;
				case "Armor":
					btnBody.SetVisible(false);
					break;
				//case "Jewelry":
					//btnJewelry.SetVisible(false);
					//break;
			}
		}
		public function showButtonFishTab(focusTab:String):void
		{
			var i:int = 0;
			for (i = 0; i < arrImgTabFish.length; i++) 
			{
				var itemImg:Image = arrImgTabFish[i];
				itemImg.img.visible = true;
			}
			for (i = 0; i < arrBtnTabFish.length; i++) 
			{
				var itemBtn:Button = arrBtnTabFish[i];
				itemBtn.SetVisible(true);
			}
			var arr:Array = focusTab.split(GUI_SHOP_SPLIT_BTN_TAB_FISH);
			var idTab:int = -1;
			if (arr)
			{
				idTab = int(focusTab.split(GUI_SHOP_SPLIT_BTN_TAB_FISH)[1]);
			}
			var tabInvisible:Button = arrBtnTabFish[idTab];
			tabInvisible.SetVisible(false);
			
		}		
		public function hideButtonDecoTab():void
		{
			btnAnimal.SetVisible(false);
			btnDecorate2.SetVisible(false);
			btnTree.SetVisible(false);
			imgFocusBtnAnimal.img.visible = false;
			imgFocusBtnDeco.img.visible = false;
			imgFocusBtnTree.img.visible = false;
			tfNotice.text = "";
		}
		
		public function hideButtonSoldierTab():void
		{
			btnHireFish.SetVisible(false);
			btnFormula.SetVisible(false);
			btnSupport.SetVisible(false);
			btnHelmet.SetVisible(false);
			btnBody.SetVisible(false);
			btnWeapon.SetVisible(false);
			//btnJewelry.SetVisible(false);
			imgFocusBtnHireFish.img.visible = false;
			imgFocusBtnHireFishNew.img.visible = false;
			imgFocusBtnFormula.img.visible = false;
			imgFocusBtnSupport.img.visible = false;
			imgFocusBtnHelmet.img.visible = false;
			imgFocusBtnBody.img.visible = false;
			imgFocusBtnWeapon.img.visible = false;
			//imgFocusBtnJewelry.img.visible = false;
		}
		
		public function hideButtonFishTab():void
		{
			var i:int = 0;
			for (i = 0; i < arrBtnTabFish.length; i++) 
			{
				var itemBtn:Button = arrBtnTabFish[i];
				itemBtn.SetVisible(false);
			}
			for (i = 0; i < arrImgTabFish.length; i++) 
			{
				var itemImg:Image = arrImgTabFish[i];
				itemImg.img.visible = false;
			}
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_SHOP_BTN_SALE_OFF:
					ChangeTabPos(buttonID);
					showTab(buttonID);
					hideButtonDecoTab();
					hideButtonSoldierTab();
					hideButtonFishTab();
					break;
				case GUI_SHOP_BTN_FISH:
					showButtonFishTab(buttonID);
					ChangeTabPos(buttonID);
					showTab(buttonID);
					hideButtonDecoTab();
					hideButtonSoldierTab();
					break;
				case GUI_SHOP_BTN_SOLDIER:
					showButtonSoldierTab("HireFish");
					//showButtonSoldierTab("Support");
					ChangeTabPos(buttonID);
					showTab("HireFish");
					//showTab("Support");
					hideButtonDecoTab();
					hideButtonFishTab();
					break;
				case GUI_SHOP_BTN_NEW:
				case GUI_SHOP_BTN_EVENT:
				case GUI_SHOP_BTN_BACK_GROUND:
				case GUI_SHOP_BTN_SPECIAL:				
					ChangeTabPos(buttonID);
					showTab(buttonID);
					hideButtonDecoTab();
					hideButtonFishTab();
					hideButtonSoldierTab();
					break;
				case GUI_SHOP_BTN_DECORATE:
					showButtonDecoTab(buttonID);
					ChangeTabPos(buttonID);
					showTab(buttonID);	
					hideButtonFishTab();
					hideButtonSoldierTab();
					break;
					
				case GUI_SHOP_BTN_DECORATE2:
					ChangeTabPos("Other");
					showTab("Other");		
					hideButtonSoldierTab();
					break;
				case GUI_SHOP_BTN_ANIMAL:
				case GUI_SHOP_BTN_TREE:
					showTab(buttonID);	
					ChangeTabPos(buttonID);
					hideButtonSoldierTab();
					break;
				case GUI_SHOP_BTN_TAB_FISH_FORMULA:
				case GUI_SHOP_BTN_TAB_FISH_SOLDIER:
				case GUI_SHOP_BTN_TAB_HELMET:
				case GUI_SHOP_BTN_TAB_BODY:
				case GUI_SHOP_BTN_TAB_WEAPON:
				case GUI_SHOP_BTN_TAB_FISH_SUPPORT:
				case GUI_SHOP_BTN_TAB_JEWELRY:
					showButtonSoldierTab(buttonID);
					ChangeTabPos(buttonID);
					showTab(buttonID);
					hideButtonDecoTab();
					hideButtonFishTab();
					break;
				case GUI_SHOP_BTN_NEXT:
					itemPage.showNextPage();
					curPage = itemPage.curPage;
					checkEnabelBtnNextBack();
					break;
				case GUI_SHOP_BTN_BACK:
					itemPage.showPrePage();
					curPage = itemPage.curPage;
					checkEnabelBtnNextBack();
					break;				
				case GUI_SHOP_BTN_CLOSE:	
					GuiMgr.getInstance().GuiRawMaterials.StateBuyShop = 0;
					if (GuiMgr.getInstance().GuiRawMaterials.IsVisible)
					{
						//var guiRawMaterials:GUIRawMaterials = GuiMgr.getInstance().GuiRawMaterials;
						GuiMgr.getInstance().GuiRawMaterials.UpdateBtnGoalZXu(GuiMgr.getInstance().GuiRawMaterials.ResultMaxLevel,GuiMgr.getInstance().GuiRawMaterials.numMatInSlot);
						GuiMgr.getInstance().GuiRawMaterials.UpdateStateBtnNextPre(GuiMgr.getInstance().GuiRawMaterials.lisRawMaterial);
					}
					
					// Nếu GUI Chọn đồ còn mở thì sẽ cập nhật lại
					if (GuiMgr.getInstance().GuiChooseEquipment.IsVisible)
					{
						// Load lại kho để refresh trang bị
						var cmd:SendLoadInventory = new SendLoadInventory();
						Exchange.GetInstance().Send(cmd);
					}					
					Hide();				
					break;
				case GUI_SHOP_BTN_NAP_G:
					GuiMgr.getInstance().guiAddZMoney.Show(Constant.GUI_MIN_LAYER, 3);
					/*ExternalInterface.addCallback("updateG", function ():void {
						Exchange.GetInstance().Send(new SendUpdateG());
					});
					ExternalInterface.call("payment", GameLogic.getInstance().user.GetMyInfo().UserName);*/
					break;
				case GUI_SHOP_BTN_TAB_FISH_0:
				case GUI_SHOP_BTN_TAB_FISH_1:
				case GUI_SHOP_BTN_TAB_FISH_2:
				case GUI_SHOP_BTN_TAB_FISH_3:
				case GUI_SHOP_BTN_TAB_FISH_4:
				case GUI_SHOP_BTN_TAB_FISH_5:
				case GUI_SHOP_BTN_TAB_FISH_6:
					showButtonFishTab(buttonID);
					showTab(buttonID);
				break;
				default:
					doSomeThing(buttonID);		
					break;				
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if ((buttonID.search("Draft") >= 0 || buttonID.search("Paper") >= 0 || buttonID.search("GoatSkin") >= 0 || buttonID.search("Blessing") >= 0) && buttonID.split("_").length < 3)
			{
				var arr:Array = buttonID.split("_");
				var id:int = arr[1];
				var obj:Object = ConfigJSON.getInstance().getItemInfo(arr[0], arr[1]);
				var ctn:Container = itemPage.getItemById(buttonID);
				var p:Point = new Point(event.stageX, event.stageY);
				GuiMgr.getInstance().GuiMixFormulaInfo.InitAll(obj, p.x, p.y);
			}
			
			var a:Array = buttonID.split("_");
			if (a[0] == "Ctn$Helmet" || a[0] == "Ctn$Armor" || a[0] == "Ctn$Weapon"
				|| a[0] == "Ctn$Bracelet" || a[0] == "Ctn$Belt"
				|| a[0] == "Ctn$Necklace" || a[0] == "Ctn$Ring")
			{
				var o:Object = ConfigJSON.getInstance().GetEquipmentInfo(a[0].split("$")[1], a[1]);
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, o);
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (GuiMgr.getInstance().GuiMixFormulaInfo.IsVisible && buttonID.search("ZMoney") < 0 && buttonID.search("Money") < 0)
			{
				GuiMgr.getInstance().GuiMixFormulaInfo.Hide();
			}
			
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				if ((buttonID.search("Armor") >= 0
					|| buttonID.search("Weapon") >= 0
					|| buttonID.search("Helmet") >= 0
					|| buttonID.search("Weapon") >= 0
					) && buttonID.search("Ctn") < 0)	return;
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		
		public override function OnHideGUI():void
		{
			if(Ultility.IsInMyFish())
			{
				GameLogic.getInstance().ShowFish();
			}
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
			{
				GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
				GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, GuiMgr.getInstance().GuiMainFishWorld.CurrentPage);
			}
			if (GuiMgr.getInstance().GuiEnchantEquipment.IsVisible)
			{
				GuiMgr.getInstance().GuiEnchantEquipment.UpdateGUIEnchant();
			}
		}
		
		private function checkEnabelBtnNextBack():void
		{
			btnNext.SetEnable();
			btnBack.SetEnable();
			if(curPage >= itemPage.getNumPage()-1)
			{
				btnNext.SetDisable();
			}
			else if(curPage <= 0)
			{				
				btnBack.SetDisable();
			}			
		}

	}

}