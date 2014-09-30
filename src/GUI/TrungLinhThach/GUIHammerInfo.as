package GUI.TrungLinhThach 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIHammerInfo extends BaseGUI 
	{
		static public const BTN_HAMMER_WHITE:String = "btnHammerWhite";
		static public const BTN_HAMMER_GREEN:String = "btnHammerGreen";
		static public const BTN_HAMMER_GOLD:String = "btnHammerGold";
		static public const BTN_HAMMER_PURPLE:String = "btnHammerPurple";
		
		public var txtHammerWhite:TextField;
		public var txtHammerGreen:TextField;
		public var txtHammerGold:TextField;
		public var txtHammerPurple:TextField;
		
		private var _eggsWhite:int;
		private var _eggsGreem:int;
		private var _eggsGold:int;
		private var _eggsPurple:int;
		
		public var ctnHammerWhite:Container;
		public var ctnHammerGreen:Container;
		public var ctnHammerGold:Container;
		public var ctnHammerPurple:Container;
		
		private var imgTopBar:Image;
		
		private const nameType:Object = 
		{
			"HammerGreen":"Thần Xanh", "HammerYellow":"Thần Vàng", "HammerPurple":"Thần Tím"
		}
		
		public function GUIHammerInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(0, 2);
				imgTopBar = AddImage("", "GuiTrungLinhThach_GuiTopBar", 90, 40, true, ALIGN_LEFT_TOP);
				var txtFormat:TextFormat = new TextFormat("arial", 14, 0xFFFFFF, true);
				txtFormat.align = "center";
				var tooltipFormat:TooltipFormat;
				
				//HammerWhite
				ctnHammerWhite = AddContainer("", "GuiTrungLinhThach_HammerWhite", 105, 57);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Búa Thường";
				ctnHammerWhite.setTooltip(tooltipFormat);
				txtHammerWhite = AddLabel("0", 132, 67, 0x000000, 1);
				txtHammerWhite.defaultTextFormat = txtFormat;
				AddButton(BTN_HAMMER_WHITE, "GuiTrungLinhThach_MuaXu", 145, 93);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Mua búa Thường";
				GetButton(BTN_HAMMER_WHITE).setTooltip(tooltipFormat);
				var numWhite:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Hammer")["HammerWhite"][1].ZMoney;
				AddLabel(Ultility.StandardNumber(numWhite), 140, 98, 0xFFFFFF, 1); 
				
				//HammerGreen
				ctnHammerGreen = AddContainer("", "GuiTrungLinhThach_HammerGreen", 260, 57);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Búa Đặc Biệt";
				ctnHammerGreen.setTooltip(tooltipFormat);
				txtHammerGreen = AddLabel("0", 290, 67, 0x000000, 1);
				txtHammerGreen.defaultTextFormat = txtFormat;
				AddButton(BTN_HAMMER_GREEN, "GuiTrungLinhThach_MuaXu", 300, 93);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Mua búa Đặc Biệt";
				GetButton(BTN_HAMMER_GREEN).setTooltip(tooltipFormat);
				var numGreen:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Hammer")["HammerGreen"][1].ZMoney;
				AddLabel(Ultility.StandardNumber(numGreen), 295, 98, 0xFFFFFF, 1);
				
				//HammerGold
				ctnHammerGold = AddContainer("", "GuiTrungLinhThach_HammerGold", 415, 57);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Búa Quý";
				ctnHammerGold.setTooltip(tooltipFormat);
				txtHammerGold = AddLabel("0", 444, 67, 0x000000, 1);
				txtHammerGold.defaultTextFormat = txtFormat;
				AddButton(BTN_HAMMER_GOLD, "GuiTrungLinhThach_MuaXu", 455, 93);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Mua búa Quý";
				GetButton(BTN_HAMMER_GOLD).setTooltip(tooltipFormat);
				var numYellow:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Hammer")["HammerYellow"][1].ZMoney;
				AddLabel(Ultility.StandardNumber(numYellow), 450, 98, 0xFFFFFF, 1);
				
				
				//HammerPurple
				ctnHammerPurple = AddContainer("", "GuiTrungLinhThach_HammerPurple", 575, 57);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Búa Thần";
				ctnHammerPurple.setTooltip(tooltipFormat);
				txtFormat = new TextFormat("arial", 14, 0xFFFFFF, true);
				txtHammerPurple = AddLabel("0", 598, 67, 0x000000, 1);
				txtHammerPurple.defaultTextFormat = txtFormat;
				AddButton(BTN_HAMMER_PURPLE, "GuiTrungLinhThach_MuaXu", 610, 93);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Mua búa Thần";
				GetButton(BTN_HAMMER_PURPLE).setTooltip(tooltipFormat);
				var numPurple:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Hammer")["HammerPurple"][1].ZMoney;
				AddLabel(Ultility.StandardNumber(numPurple), 605, 98, 0xFFFFFF, 1);
			}
			
			LoadRes("");
		}
		
		public function updateUserData(data:Object):void
		{
			if (data["HammerWhite"])
			{
				eggsWhite = data["HammerWhite"][1];
			}
			else
			{
				eggsWhite = 0;
			}
			
			if (data["HammerGreen"])
			{
				eggsGreen = data["HammerGreen"][1];
			}
			else
			{
				eggsGreen = 0;
			}
			//trace("data== " + data["HammerGreen"] + " |HammerGreen == " + data["HammerGreen"][1]);
			if (data["HammerYellow"])
			{
				eggsYellow = data["HammerYellow"][1];
			}
			else
			{
				eggsYellow = 0;
			}
			//trace("HammerYellow== " + data["HammerYellow"]);
			if (data["HammerPurple"])
			{
				eggsPurple = data["HammerPurple"][1];
			}
			else
			{
				eggsPurple = 0;
			}
			//trace("HammerPurple== " + data["HammerPurple"]);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//trace("OnButtonClick== " + buttonID);
			switch(buttonID)
			{
				case BTN_HAMMER_WHITE:
					showBuyHammer("HammerWhite", 1);
					break;
				case BTN_HAMMER_GREEN:
					showBuyHammer("HammerGreen", 2);
					break;
				case BTN_HAMMER_GOLD:
					showBuyHammer("HammerYellow", 3);
					break;
				case BTN_HAMMER_PURPLE:
					showBuyHammer("HammerPurple", 4);
					break;
			}
		}
		
		private function showBuyHammer(typeHammer:String, index:int):void
		{
			/*var config:Object = ConfigJSON.getInstance().getItemInfo("SmashEgg_Hammer")[typeHammer][1];
			var myMoney:int = GameLogic.getInstance().user.GetZMoney();
			var price:int = config.ZMoney;
			var priceType:String = "ZMoney";
			GuiMgr.getInstance().guiAddHammer.priceType = priceType;
			GuiMgr.getInstance().guiAddHammer.costPerPack = price;
			GuiMgr.getInstance().guiAddHammer.showGUI(int(myMoney / price), nameType[typeHammer], "GuiTrungLinhThachHammer_" + typeHammer, function f(numPack:int):void
			{
				if (numPack > 0)
				{
					if (Ultility.payMoney(priceType, price * numPack))
					{
						var cmdBuyHammer:SendBuyHammer = new SendBuyHammer();
						cmdBuyHammer.HammerType = typeHammer;
						cmdBuyHammer.HammerId = 1
						cmdBuyHammer.Num = numPack;
						Exchange.GetInstance().Send(cmdBuyHammer);
					}
				}
			}, true);*/
			
			var config:Object = ConfigJSON.getInstance().getItemInfo("SmashEgg_Hammer")[typeHammer][1];
			if (GameLogic.getInstance().user.GetZMoney() >= config.ZMoney)
			{
				var cmdBuyHammer:SendBuyHammer = new SendBuyHammer();
				cmdBuyHammer.HammerType = typeHammer;
				cmdBuyHammer.HammerId = 1
				cmdBuyHammer.Num = 1;
				Exchange.GetInstance().Send(cmdBuyHammer);
				// update vào kho
				//GuiMgr.getInstance().GuiStore.UpdateStore("Viagra", 1, 1);
				GameLogic.getInstance().user.UpdateUserZMoney(-config.ZMoney);
				EffectMgr.setEffBounceDown("Mua thành công", "GuiTrungLinhThach_Hammer_" + index, 335, 300);
			}
			else
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
		}
		
		public function buyComplete(OldData:Object, Data:Object):void
		{
			if (OldData.HammerType == "HammerWhite")
			{
				eggsWhite = _eggsWhite + OldData.Num;
			}
			
			if (OldData.HammerType == "HammerGreen")
			{
				eggsGreen = _eggsGreem + OldData.Num;
			}
			
			if (OldData.HammerType == "HammerYellow")
			{
				eggsYellow = _eggsGold + OldData.Num;
			}
			
			if (OldData.HammerType == "HammerPurple")
			{
				eggsPurple = _eggsPurple + OldData.Num;
			}
			//trace("buyComplete() Num= " + OldData.Num + " |Type= " + OldData.HammerType + " |Data= " + Data["ZMoney"]);
		}
		
		public function set eggsWhite(value:int):void 
		{
			_eggsWhite = value;
			txtHammerWhite.text = Ultility.StandardNumber(value);
		}
		
		public function set eggsGreen(value:int):void 
		{
			_eggsGreem = value;
			txtHammerGreen.text = Ultility.StandardNumber(value);
		}
		
		public function set eggsYellow(value:int):void 
		{
			_eggsGold = value;
			txtHammerGold.text = Ultility.StandardNumber(value);
		}
		
		public function set eggsPurple(value:int):void 
		{
			_eggsPurple = value;
			txtHammerPurple.text =  Ultility.StandardNumber(value);
		}
		
		public function getNumberHammer(type:String):Number
		{
			var num:Number = 0;
			//trace("type== " + type);
			if (type == "HammerWhite")
			{
				num = _eggsWhite;
			}
			
			if (type == "HammerGreen")
			{
				num = _eggsGreem;
			}
			
			if (type == "HammerYellow")
			{
				num = _eggsGold;
			}
			
			if (type == "HammerPurple")
			{
				num = _eggsPurple;
			}
			
			return num;
		}
		
		public function updateNumberHammer(type:String, num:int):void
		{
			if (type == "HammerWhite")
			{
				eggsWhite = _eggsWhite - num;
			}
			
			if (type == "HammerGreen")
			{
				eggsGreen = _eggsGreem - num;
			}
			
			if (type == "HammerYellow")
			{
				eggsYellow = _eggsGold - num;
			}
			
			if (type == "HammerPurple")
			{
				eggsPurple = _eggsPurple - num;
			}
			//trace("buyComplete() Num= " + OldData.Num + " |Type= " + OldData.HammerType + " |Data= " + Data["ZMoney"]);
		}
		
		override public function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void 
		{
			super.Fullscreen(IsFull, dx, dy, scaleX, scaleY);
			if (IsFull)
			{
				imgTopBar.SetScaleX(scaleX);
				var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				img.y = BgLayer.y;
			}
			else
			{
				imgTopBar.SetScaleX(1);
			}
		}
		
		override public function UpdateObject():void 
		{
			
		}
	}

}