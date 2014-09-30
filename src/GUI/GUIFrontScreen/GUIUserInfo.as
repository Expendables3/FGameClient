package GUI.GUIFrontScreen 
{
	import Data.ConfigJSON;
	import Data.Localization;
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
	 * @author dongtq
	 */
	public class GUIUserInfo extends BaseGUI 
	{
		static public const BTN_QUICK_PAY:String = "btnQuickPay";
		static public const BTN_BUY_DIAMOND:String = "btnBuyDiamond";
		private var prgExp:ProgressBar;
		public var txtMoney:TextField;
		public var txtExp:TextField;
		public var txtZMoney:TextField;
		public var txtDiamond:TextField;
		private var txtLevel:TextField;
		private var _exp:int;
		private var _money:Number;
		private var _zMoney:int;
		private var _diamond:int;
		private var _level:int;
		private var ctnGold:Container;
		private var ctnZMoney:Container;
		private var ctnDiamond:Container;
		private var imgTopBar:Image;
		private var ctnEnergy:Container;
		private var prgEnergy:ProgressBar;
		public var txtEnergy:TextField;
		private var _energy:Number;
		private var txtRecoverEnergy:TextField;
		
		public function GUIUserInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(0, 0);
				imgTopBar = AddImage("", "GuiTopBar", 0, 0, true, ALIGN_LEFT_TOP);
				var txtFormat:TextFormat = new TextFormat("arial", 14, 0xffffff, true);
				txtFormat.align = "center";
				var tooltipFormat:TooltipFormat;
				//Exp
				AddImage("", "Exp_Bg", 1, -6, true, ALIGN_LEFT_TOP);
				prgExp = AddProgress("", "PrgEXP", 42, 5, this, true);
				prgExp.setStatus(0);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Kinh nghiệm";
				prgExp.setTooltip(tooltipFormat);
				txtLevel = AddLabel("0", 8 - 36, 6, 0xffff00, 1, 0x26709C);
				txtLevel.defaultTextFormat = txtFormat;
				txtExp = AddLabel("0", 26, 3, 0xFFFFFF, 1, 0x26709C);
				txtExp.defaultTextFormat = txtFormat;
				
				// Gold			
				ctnGold = AddContainer("", "Money_Bg", 133, 2);
				//tooltipFormat = new TooltipFormat();
				//tooltipFormat.text = "Tiền vàng";
				ctnGold.setTooltipText("Tiền vàng");
				txtMoney = AddLabel("0", 140,  3, 0xFFFFFF, 1, 0x26709C);
				txtMoney.defaultTextFormat = txtFormat;
				
				//ZMoney
				ctnZMoney = AddContainer("", "ZMoney_Bg", 242, 2);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Tiền G";
				ctnZMoney.setTooltip(tooltipFormat);
				txtZMoney = AddLabel("0", 245, 3, 0xFFFFFF, 1, 0x26709C);
				txtZMoney.defaultTextFormat = txtFormat;
				AddButton(BTN_QUICK_PAY, "BtnAddZMoney", 375 - 56, -3);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Nạp tiền nhanh";
				GetButton(BTN_QUICK_PAY).setTooltip(tooltipFormat);
				
				//Diamond
				ctnDiamond = AddContainer("", "Diamond_Bg", 365, 2);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Kim Cương";
				ctnDiamond.setTooltip(tooltipFormat);
				AddButton(BTN_BUY_DIAMOND, "BtnAddDiamond", 445, -3);
				txtFormat = new TextFormat("arial", 14, 0xffffff, true);
				txtDiamond = AddLabel("0", 420 - 52, 2, 0xffffff, 1);
				txtDiamond.defaultTextFormat = txtFormat;
				
				//Energy
				ctnEnergy = AddContainer("", "Energy_Bg", 487, 0);
				ctnEnergy.setTooltipText("Năng lượng");
				prgEnergy = AddProgress("", "EnergyBar", 483 + 26, 7, this);
				prgEnergy.setTooltipText("Năng lượng");
				txtEnergy = AddLabel("", 483 + 23, 5, 0xffffff, 1, 0x26709C);
				txtEnergy.defaultTextFormat = txtFormat;
				txtRecoverEnergy = AddLabel("", 483 + 23, 23, 0xffffff, 1, 0x26709C);
				txtFormat.size = 13;
				txtRecoverEnergy.defaultTextFormat = txtFormat;
			}
			
			LoadRes("");
		}
		
		public function updateUserData():void
		{
			exp = GameLogic.getInstance().user.GetExp();
			level = GameLogic.getInstance().user.GetLevel();
			money = GameLogic.getInstance().user.GetMoney();
			zMoney = GameLogic.getInstance().user.GetZMoney();
			diamond = GameLogic.getInstance().user.getDiamond();
			energy = GameLogic.getInstance().user.GetEnergy();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_BUY_DIAMOND:
					GuiMgr.getInstance().guiBuyDiamond.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_QUICK_PAY:
					GuiMgr.getInstance().guiAddZMoney.Show(Constant.GUI_MIN_LAYER, 3);
					break;
			}
		}
		
		public function set exp(value:int):void 
		{
			_exp = value;
			txtExp.text = Ultility.StandardNumber(value);
			var expRequire:int = ConfigJSON.getInstance().getUserLevelExp(GameLogic.getInstance().user.GetLevel(true) + 1);			
			prgExp.setStatus(Number(value) / expRequire);
			prgExp.setTooltipText("Còn thiếu " + Ultility.StandardNumber(expRequire -value) + "\nđiểm kinh nghiệm để lên cấp");
		}
		
		public function set money(value:Number):void 
		{
			_money = value;
			txtMoney.text = Ultility.StandardNumber(value);
		}
		
		public function set zMoney(value:int):void 
		{
			_zMoney = value;
			txtZMoney.text = Ultility.StandardNumber(value);
		}
		
		public function set diamond(value:int):void 
		{
			_diamond = value;
			txtDiamond.text = Ultility.StandardNumber(value);
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			txtLevel.text = Ultility.StandardNumber(value);
		}
		
		public function get energy():Number 
		{
			return _energy;
		}
		
		public function set energy(value:Number):void 
		{
			_energy = value;
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel(true));
			txtEnergy.text = Ultility.StandardNumber(value);
			prgEnergy.setStatus(value / maxEnergy);
			
			var ToolTip1:TooltipFormat = new TooltipFormat();
			var str:String;
			var szEnergy:String = Ultility.StandardNumber(value);
			var szMaxEnergy:String = Ultility.StandardNumber(maxEnergy);
			var strReplace:String = szEnergy + "/" + szMaxEnergy;
			str = Localization.getInstance().getString("Tooltip21");
			str = str.replace("@energy", strReplace);
			ToolTip1.text = str;
			var iEnterPos:int = str.search("\n");
			var format:TextFormat = new TextFormat();
			format.align = "center";
			format.color = 0x000000;
			format.bold = false;
			format.size = 12;
			ToolTip1.autoSize = "center";
			ToolTip1.setTextFormat(format);
			format.bold = true;
			format.color = 0xFF0000;
			ToolTip1.setTextFormat(format, 0, iEnterPos);
			prgEnergy.setTooltip(ToolTip1);
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
			// update energy
			if (energy < ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel(true)))		// đồng hồ đếm ngược
			{
				var tmp:Number = GameLogic.getInstance().CurServerTime - GameLogic.getInstance().user.GetMyInfo().LastEnergyTime;					
				var regentime:int = ConfigJSON.getInstance().getConstantInfo("pa_13");
				var cl:Number = regentime - tmp;
				var min:int = cl / 60;
				var sec:int = cl - min * 60;
				var minSt:String = min.toString();
				var secSt:String = sec.toString();
				if (min < 10)
				{
					minSt = "0" + min.toString();
				}
				if (sec < 10)
				{
					secSt = "0" + sec.toString();
				}
				var cooldown:String = "Hồi phục " + minSt + ":" + secSt;
				
				txtRecoverEnergy.text = cooldown;
			}
			else
			{
				txtRecoverEnergy.text = ""
			}
		}
	}

}