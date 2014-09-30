package GUI.TrungLinhThach 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import Event.EventMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.TooltipFormat;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.CometEmit;
	
	import Sound.SoundMgr;
	import com.adobe.serialization.json.JSON;
	
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIBuyHammerSaleOff extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		private var ListItemTrung:Array = [];
		static public const BTN_CLOSE_SALE_OFF:String = "btnCloseSaleOff";
		static public const BTN_BUY_ZMONEY:String = "btnBuyMoney";
		
		public var IsInitFinish:Boolean = false;
		private var buttonCloseSaleOff:Button;
		
		static public const HAMMER_GREEN_30:String = "btnHammerGreen30";
		static public const HAMMER_YELLOW_30:String = "btnHammerYellow30";
		static public const HAMMER_PURPLE_30:String = "btnHammerPurple30";
		static public const HAMMER_GREEN_100:String = "btnHammerGreen100";
		static public const HAMMER_YELLOW_100:String = "btnHammerYellow100";
		static public const HAMMER_PURPLE_100:String = "btnHammerPurple100";
		
		static public const HAMMER_PURPLE_THUONG:String = "btnHammerPurpleThuong";
		static public const HAMMER_PURPLE_KM01:String = "btnHammerPurpleKM01";
		static public const HAMMER_PURPLE_KM02:String = "btnHammerPurpleKM02";
		static public const HAMMER_PURPLE_KM03:String = "btnHammerPurpleKM03";
		static public const HAMMER_PURPLE_KM04:String = "btnHammerPurpleKM04";
		
		public var ctn30HammerGreen:Container;
		public var ctn30HammerYellow:Container;
		public var ctn30HammerPurple:Container;
		public var ctn100HammerGreen:Container;
		public var ctn100HammerYellow:Container;
		public var ctn100HammerPurple:Container;
		
		private var zmoneyUser:Image;
		private var buyZmoney:Button;
		public var txtZMoneyUser:TextField;
		private var txtFormatZMomey:TextFormat;
		
		public function GUIBuyHammerSaleOff(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiBuyHammerSaleOff";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
			}
			LoadRes("GuiBuyHammerSaleOff_Purple"); 
		}
		
		public function showGUI():void
		{
			isDataReady = false;
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function EndingRoomOut():void 
		{
			IsInitFinish = true;
			isDataReady = true;
			//trace("EndingRoomOut()== " + isDataReady);
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
			var fm:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
			var tfTip:TextField = AddLabel("", img.width / 2 - 80, 542, 0xffffff, 1, 0x000000);
			tfTip.defaultTextFormat = fm;
			var curEvent:String = EventMgr.NAME_EVENT;
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			var date:Date = new Date(event[curEvent]["BeginTime"] * 1000);
			var startDate:String = date.getDate() + "/" + (date.getMonth() + 1);
			date = new Date(event[curEvent]["ExpireTime"] * 1000);
			var endDate:String = date.getDate() + "/" + (date.getMonth() + 1);
			var str:String = "Giảm giá từ ngày @BeginDay@ đến ngày @EndDay@";
			str = str.replace("@BeginDay@", startDate);
			str = str.replace("@EndDay@", endDate);
			tfTip.text = str;
			isDataReady = dataAvailable;
			//trace("refreshComponent()== " + isDataReady);
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			addContent();
		}
		
		private function addContent():void
		{
			buttonCloseSaleOff = AddButton(BTN_CLOSE_SALE_OFF, "BtnThoat", 760, 20);
			buttonCloseSaleOff.setTooltipText("Đóng lại");
			
			var tooltipFormat:TooltipFormat;
			
			/*ctn30HammerGreen = AddContainer("30HammerGreen", "GuiBuyHammerSaleOff_30Green", 60, 130);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "30 Búa Đặc Biệt";
			ctn30HammerGreen.setTooltip(tooltipFormat);
			AddButton(HAMMER_GREEN_30, "GuiBuyHammerSaleOff_MuaBua", 82, 233);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua 30 búa Đặc Biệt";
			GetButton(HAMMER_GREEN_30).setTooltip(tooltipFormat);
			var num30Green:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Discount")[1].ZMoney;
			AddLabel(Ultility.StandardNumber(num30Green), 85, 234, 0xFFFFFF, 1); 
			
			ctn30HammerYellow = AddContainer("30HammerYellow", "GuiBuyHammerSaleOff_30Yellow", 223, 130);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "30 Búa Quý";
			ctn30HammerYellow.setTooltip(tooltipFormat);
			AddButton(HAMMER_YELLOW_30, "GuiBuyHammerSaleOff_MuaBua", 245, 233);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua 30 búa Quý";
			GetButton(HAMMER_YELLOW_30).setTooltip(tooltipFormat);
			var num30Yellow:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Discount")[2].ZMoney;
			AddLabel(Ultility.StandardNumber(num30Yellow), 248, 234, 0xFFFFFF, 1); 
			
			ctn30HammerPurple = AddContainer("30HammerPurple", "GuiBuyHammerSaleOff_30Purple", 386, 130);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "30 Búa Thần";
			ctn30HammerPurple.setTooltip(tooltipFormat);
			AddButton(HAMMER_PURPLE_30, "GuiBuyHammerSaleOff_MuaBua", 410, 233);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua 30 búa Thần";
			GetButton(HAMMER_PURPLE_30).setTooltip(tooltipFormat);
			var num30Purple:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Discount")[3].ZMoney;
			AddLabel(Ultility.StandardNumber(num30Purple), 413, 234, 0xFFFFFF, 1); 
			
			ctn100HammerGreen = AddContainer("100HammerGreen", "GuiBuyHammerSaleOff_100Green", 60, 280);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "50 Búa Đặc Biệt";
			ctn100HammerGreen.setTooltip(tooltipFormat);
			AddButton(HAMMER_GREEN_100, "GuiBuyHammerSaleOff_MuaBua", 82, 380);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua 50 búa Đặc Biệt";
			GetButton(HAMMER_GREEN_100).setTooltip(tooltipFormat);
			var num100Green:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Discount")[4].ZMoney;
			AddLabel(Ultility.StandardNumber(num100Green), 85, 381, 0xFFFFFF, 1); 
			
			ctn100HammerYellow = AddContainer("100HammerYellow", "GuiBuyHammerSaleOff_100Yellow", 223, 280);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "50 Búa Quý";
			ctn100HammerYellow.setTooltip(tooltipFormat);
			AddButton(HAMMER_YELLOW_100, "GuiBuyHammerSaleOff_MuaBua", 245, 380);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua 50 búa Quý";
			GetButton(HAMMER_YELLOW_100).setTooltip(tooltipFormat);
			var num100Yellow:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Discount")[5].ZMoney;
			AddLabel(Ultility.StandardNumber(num100Yellow), 248, 381, 0xFFFFFF, 1); 
			
			ctn100HammerPurple = AddContainer("100HammerPurple", "GuiBuyHammerSaleOff_100Purple", 386, 280);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "50 Búa Thần";
			ctn100HammerPurple.setTooltip(tooltipFormat);
			AddButton(HAMMER_PURPLE_100, "GuiBuyHammerSaleOff_MuaBua", 410, 380);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua 50 búa Thần";
			GetButton(HAMMER_PURPLE_100).setTooltip(tooltipFormat);
			var num100Purple:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Discount")[6].ZMoney;
			AddLabel(Ultility.StandardNumber(num100Purple), 413, 381, 0xFFFFFF, 1); 
			
			txtFormatZMomey = new TextFormat("arial", 18, 0xFFFFFF, true);
			zmoneyUser = AddImage("", "GuiBuyHammerSaleOff_ZmoneyUser", 230, 95);
			var numZMoney:int = GameLogic.getInstance().user.GetZMoney();
			txtZMoneyUser = AddLabel(Ultility.StandardNumber(numZMoney), 175, 86, 0xFFFFFF, 1);
			txtZMoneyUser.defaultTextFormat = txtFormatZMomey;
			buyZmoney = AddButton(BTN_BUY_ZMONEY, "GuiBuyHammerSaleOff_BtnMua1G", 330, 85);*/
			
			AddButton(HAMMER_PURPLE_THUONG, "GuiBuyHammerSaleOff_MuaPurple", 644, 99);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua Gói Thường";
			GetButton(HAMMER_PURPLE_THUONG).setTooltip(tooltipFormat);
			
			AddButton(HAMMER_PURPLE_KM01, "GuiBuyHammerSaleOff_MuaPurple", 644, 192);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua Gói Khuyến Mại";
			GetButton(HAMMER_PURPLE_KM01).setTooltip(tooltipFormat);
			
			AddButton(HAMMER_PURPLE_KM02, "GuiBuyHammerSaleOff_MuaPurple", 644, 283);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua Gói Khuyến Mại";
			GetButton(HAMMER_PURPLE_KM02).setTooltip(tooltipFormat);
			
			AddButton(HAMMER_PURPLE_KM03, "GuiBuyHammerSaleOff_MuaPurple", 644, 374);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua Gói Khuyến Mại";
			GetButton(HAMMER_PURPLE_KM03).setTooltip(tooltipFormat);
			
			AddButton(HAMMER_PURPLE_KM04, "GuiBuyHammerSaleOff_MuaPurple", 644, 465);
			tooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Mua Gói Khuyến Mại";
			GetButton(HAMMER_PURPLE_KM04).setTooltip(tooltipFormat);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE_SALE_OFF:
					this.Hide();
					break;
				/*case HAMMER_GREEN_30:
					showBuyHammer(1, 2);
					break;
				case HAMMER_YELLOW_30:
					showBuyHammer(2, 3);
					break;
				case HAMMER_PURPLE_30:
					showBuyHammer(3, 4);
					break;
				case HAMMER_GREEN_100:
					showBuyHammer(4, 2);
					break;
				case HAMMER_YELLOW_100:
					showBuyHammer(5, 3);
					break;
				case HAMMER_PURPLE_100:
					showBuyHammer(6, 4);
					break;*/
				case HAMMER_PURPLE_THUONG:
					showBuyHammer(1, 4);
					break;
				case HAMMER_PURPLE_KM01:
					showBuyHammer(2, 4);
					break;
				case HAMMER_PURPLE_KM02:
					showBuyHammer(3, 4);
					break;
				case HAMMER_PURPLE_KM03:
					showBuyHammer(4, 4);
					break;
				case HAMMER_PURPLE_KM04:
					showBuyHammer(5, 4);
					break;
				case BTN_BUY_ZMONEY:
					GuiMgr.getInstance().guiAddZMoney.Show(Constant.GUI_MIN_LAYER, 3);
					break;
			}
		}
		
		private function showBuyHammer(index:int, indexHammer:int):void
		{
			var config:Object = ConfigJSON.getInstance().getItemInfo("SmashEgg_Discount")[index];
			if (GameLogic.getInstance().user.GetZMoney() >= config.ZMoney)
			{
				var cmdBuyDiscountHammer:SendBuyDiscountHammer = new SendBuyDiscountHammer();
				cmdBuyDiscountHammer.Index = index;
				cmdBuyDiscountHammer.HammerType = config.ItemType;
				if (config.Bonus)
				{
					cmdBuyDiscountHammer.Num = config.Number + config.Bonus;
					//trace(config.Number + "_____" + config.Bonus);
				}
				else
				{
					cmdBuyDiscountHammer.Num = config.Number;
				}
				Exchange.GetInstance().Send(cmdBuyDiscountHammer);
				// update vào kho
				GameLogic.getInstance().user.UpdateUserZMoney(-config.ZMoney);
				EffectMgr.setEffBounceDown("Mua thành công", "GuiTrungLinhThach_Hammer_" + indexHammer, 335, 300, null, cmdBuyDiscountHammer.Num);
			}
			else
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
		}
		
		override public function OnHideGUI():void 
		{
			//trace("OnHideGUI");
		}
		
	}
}