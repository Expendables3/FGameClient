package GUI.EventMidle8 
{
	import com.greensock.TweenMax;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGiftFastGameMid8 extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_NEXT:String = "BtnNext";
		public const BTN_PRE:String = "BtnBack";
		public const BTN_FEED:String = "BtnFeed";
		
		public const IMG_GIFT:String = "ImgGift";
		public const ELEMENT_GIFT:String = "ElementGift_";
		
		public const MAX_FISHTYPE:int = 79;
		
		public var ListGift:ListBox;
		
		public var nameGift:String;
		public var domainNameGift:String;
		public var numGift:int;
		public var isRare:Boolean = false;
		
		public var isGiftMore:Boolean = false;
		
		public var arrNumGift:Array = [];
		public var arrNameGift:Array = [];
		public var arrObjGift:Array = [];
		public var arrBonus:Array = [];
		
		public function GUIGiftFastGameMid8(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGiftFastGameMid8";
		}
		
		public function InitGui(ArrNameGift:Array, ArrNumGift:Array, ArrObjGift:Array):void 
		{
			// Gift từ game
			arrNameGift = ArrNameGift;
			arrNumGift = ArrNumGift;
			arrObjGift = ArrObjGift;
			arrBonus = [];
			isGiftMore = false;
			Show(Constant.GUI_MIN_LAYER, 1);
		}
		
		override public function InitGUI():void 
		{
			var setInfo:Function = function():void
			{
				//Vẽ aura bằng glowFilter
				var cl:int = 0xff0000;
				TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
			}
			super.InitGUI();
			LoadRes("GUIGiftFinalGameMidle8_ImgBgGUIGiftFinalGameMidle81");
			SetPos((Constant.STAGE_WIDTH - img.width) / 2, (Constant.STAGE_HEIGHT - img.height) / 2);
			
			AddAllButton();
			
			ListGift = AddListBox(ListBox.LIST_X, 2, 5, 20, 20, true);
			ListGift.setPos(47, 200);
			InitListGift();
			
			OpenRoomOut();
		}
		
		public function AddAllButton(isHaveNextBack:Boolean = true):void 
		{
			//AddButton(BTN_CLOSE, "BtnThoat", img.width - 25, 25, this);
			if(!isGiftMore)
			{
				AddButton(BTN_FEED, "GUIGameEventMidle8_BtnNhanThuong", img.width / 2 - 40, img.height - 50, this);
			}
			else 
			{
				AddButton(BTN_FEED, "BtnFeed", img.width / 2 - 50, img.height - 50, this);
			}
			AddButton(BTN_PRE, "GUIGameEventMidle8_Btn_Next_TuLuyenNgoc", 30, 270, this).SetVisible(isHaveNextBack);
			AddButton(BTN_NEXT, "GUIGameEventMidle8_Btn_Pre_TuLuyenNgoc", 520, 270, this).SetVisible(isHaveNextBack);
		}
		
		public function InitListGift():void 
		{
			var setInfo:Function = function():void
			{
				//Vẽ aura bằng glowFilter
				var cl:int = 0xff0000;
				TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
			}
			for (var i:int = 0; i < arrNameGift.length; i++) 
			{
				var container:Container = new Container(ListGift, "GUIGameEventMidle8_CtnSlotGiftGame8");
				
				var strName:String = arrNameGift[i];
				var domain:int = 0;
				var isFishRare:Boolean = false;
				var imageContent:Image;
				if (isFishRare)
				{
					imageContent = container.AddImage("ImgContent", strName, 0, 0, true, ALIGN_CENTER_CENTER, false, setInfo);
				}
				else
				{
					imageContent = container.AddImage("ImgContent", strName, 0, 0);
				}
				imageContent.FitRect(50, 50, new Point(10, 0));
				if (domain > 0)
				{
					container.AddImage("ImgDomain", Fish.DOMAIN + domain.toString(), 0, 0).FitRect(20,20, new Point(25,0));
				}
				var tip:TooltipFormat = new TooltipFormat();
				tip.text = setTipText(arrObjGift[i]);
				if (tip.text != "")	container.setTooltip(tip);
				var txtFormat:TextFormat = new TextFormat();
				txtFormat.bold = true;
				txtFormat.color = 0xFFFF00;
				txtFormat.size = 16;
				
				var n1:int = arrNumGift[i] / 1000000;
				var s:String;
				if (n1 > 0)
				{
					s = Ultility.StandardNumber(n1) + " triệu";
				}
				else
				{
					s = Ultility.StandardNumber(arrNumGift[i]);
				}
				
				var txtBox:TextField = container.AddLabel("x" + s, -15, 54, 0xFFFF00, 1, 0x26709C);
				txtBox.setTextFormat(txtFormat);
				
				ListGift.addItem(ELEMENT_GIFT + i.toString(), container, this)
			}
		} 
		
		private function setTipText(obj:Object):String 
		{
			if (obj.hasOwnProperty("ItemType"))
			{
				switch (obj.ItemType)
				{
					case "Money":
						return "Tiền vàng";
					case "Exp":
						return "Kinh nghiệm";
					case "Material":
						if (obj["ItemId"] >= 100)	return "Ngư thạch cấp " + int(obj["ItemId"]%100) + " đặc biệt";
						else	return "Ngư thạch cấp " + obj["ItemId"];
					case "VipMedal":
						return "Huy chương tài phú";
					case "VipTag":
						return "Bùa mở bảo rương VIP";
					case "HammerWhite":
						return "Búa thường";
					case "HammerGreen":
						return "Búa đặc biệt";
					case "HammerYellow":
						return "Búa quý";
					case "HammerPurple":
						return "Búa thần";
					default:
						return Localization.getInstance().getString(obj["ItemType"] + obj["ItemId"]);
				}
			}
			return "";
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			var ctn:Container;
			if (buttonID.search(ELEMENT_GIFT) >= 0)
			{
				ctn = ListGift.getItemById(buttonID);
				var IdGIftInData:int = buttonID.split("_")[1];
				var objData:Object = arrObjGift[IdGIftInData];
				if (arrNameGift[IdGIftInData].search("_Shop") >= 0) 
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(objData);
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				}
			}
			switch (buttonID) 
			{
				case IMG_GIFT:
					var objDataBonus:Object = arrBonus[0];
					var equipBonus:FishEquipment = new FishEquipment();
					equipBonus.SetInfo(objDataBonus);
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equipBonus, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonOut(event, buttonID);
			var ctn:Container;
			if (buttonID.search(ELEMENT_GIFT) >= 0)
			{
				ctn = ListGift.getItemById(buttonID);
				var IdGIftInData:int = buttonID.split("_")[1];
				var objData:Object = arrObjGift[IdGIftInData];
				if (arrNameGift[IdGIftInData].search("_Shop")) 
				{
					if(GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					}
				}
			}
			switch (buttonID) 
			{
				case IMG_GIFT:
					if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					}
				break;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_NEXT:
					ListGift.showNextPage();
				break;
				case BTN_PRE:
					ListGift.showPrePage();
				break;
				case BTN_FEED:
						Feed();
				break;
			}
		}
		public function Feed():void 
		{
			GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_HOA_MUA_XUAN);
			Hide();
		}
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			var type:String;
			var id:int;
			var i:int = 0;
			var j:int = 0;
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			for (i = 0; i < arrBonus.length;i++)
			{
				switch (arrBonus[i].ItemType) 
				{
					case "Exp":
						GameLogic.getInstance().user.SetUserExp(arrBonus[i].Num + GameLogic.getInstance().user.GetExp());
					break;
					case "Money":
						GameLogic.getInstance().user.UpdateUserMoney(arrBonus[i].Num);
					break;
					default:
						GameLogic.getInstance().user.GenerateNextID();
					break;
				}
			}
			
			for (i = 0; i < arrNameGift.length; i++) 
			{
				var str:String = arrNameGift[i];	
				if (str == "Exp")
				{
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + arrNumGift[i]);
				}
				if (str == "IcGold")
				{
					GameLogic.getInstance().user.UpdateUserMoney(arrNumGift[i]);
				}
				if (str.search("Material") >= 0)
				{
					str = str.replace("Material", "");
					type = "Material";
					if (str.search("S") >= 0)
					{
						str = str.replace("S","");
						id = parseInt(str);
						id += 100;
					}
					else 
					{
						id = parseInt(str);
					}
					
					GuiMgr.getInstance().GuiStore.UpdateStore(type, id, arrNumGift[i]);
				}
				if (str.search("EnergyItem") >= 0)
				{
					str = str.replace("EnergyItem", "");
					type = "EnergyItem";
					id = parseInt(str);
					GuiMgr.getInstance().GuiStore.UpdateStore(type, id, arrNumGift[i]);
				}
				
				if (str.search("VipMedal") >= 0)
				{
					type = "VipMedal";
					id = 1;
					GuiMgr.getInstance().GuiStore.UpdateStore(type, id, arrNumGift[i]);
				}
				
				if (GuiMgr.getInstance().GuiStore.IsVisible)
				{
					GuiMgr.getInstance().GuiStore.Hide();
				}
			}
			
			if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
			{
				GuiMgr.getInstance().GuiGameTrungThu.Hide();
			}
			if (GuiMgr.getInstance().GuiAutomaticGame.IsVisible)
			{
				GuiMgr.getInstance().GuiAutomaticGame.Hide();
			}
		}
	}

}