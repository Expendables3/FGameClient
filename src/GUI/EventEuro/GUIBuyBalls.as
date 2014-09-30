package GUI.EventEuro 
{
	import Data.ConfigJSON;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIBuyBalls extends BaseGUI 
	{
		private var typeBall:String;
		private var textBox:TextBox;
		private var _num:int;
		private var okFunction:Function;
		private var labelName:TextField;
		private var labelNumG:TextField;
		private var labelUserG:TextField;
		private var _numUserG:int;
		private var labelUserDiamond:TextField;
		private var _numUserDiamond:int;
		private var labelUserMoney:TextField;
		private var _numUserMoney:int;
		private var labelNumMoney:TextField;
		private var labelNumDiamond:TextField;
		private var numBuyGoldOrd:int;
		private var numBuyZMoneyVip:int;
		private var numBuyDiamondVip:int;
		private var numBuyZMoneyOrd:int;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_BUY_G:String = "btnBuyG";
		static public const BTN_BUY_DIAMOND:String = "btnBuyDiamond";
		static public const BTN_BUY_GOLD:String = "bntBuyGold";
		
		public function GUIBuyBalls(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			var tooltip:TooltipFormat;
			var config:int;
			setImgInfo = function f():void
			{
				SetPos(212, 204);
				AddButton(BTN_CLOSE, "BtnThoat", 419, 15);
				AddImage("", "Ic_" + typeBall + "Ball", 50 + 277, 159).FitRect(30, 30, new Point(327 - 45, 169 - 45));
				var message:String;
				if (typeBall == "ORD")
				{
					message = "Nhập số lượng bóng thường muốn mua:";
				}
				else
				{
					message = "Nhập số lượng bóng vàng muốn mua:";
				}
				var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffffff, true);
				labelName = AddLabel(message , 128 - 75, 99, 0xffffff, 0, 0x000000);
				labelName.setTextFormat(txtFormat);
				labelName.defaultTextFormat = txtFormat;
				
				txtFormat.color = 0xffffff;
				textBox = AddTextBox("", "0", 151 + 72, 220 - 96, 50, 41, this);
				textBox.textField.autoSize = "right";
				textBox.SetTextFormat(txtFormat);
				textBox.SetDefaultFormat(txtFormat);
				textBox.textField.selectable = true;
				textBox.textField.stage.focus = textBox.textField;
				textBox.textField.setSelection(0, textBox.textField.length);
				
				numBuyGoldOrd = GuiMgr.getInstance().guiEventEuro.numBuyGoldOrd;
				numBuyZMoneyOrd = GuiMgr.getInstance().guiEventEuro.numBuyZMoneyOrd;
				numBuyZMoneyVip = GuiMgr.getInstance().guiEventEuro.numBuyZMoneyVip;
				numBuyDiamondVip = GuiMgr.getInstance().guiEventEuro.numBuyDiamondVip;
				
				if (typeBall == "VIP")
				{
					AddImage("", "IcZingXu", 66, 69).SetScaleXY(1.2);
					AddImage("", "IcDiamond", 263, 74);
					AddImage("", "IcZingXu", 68 + 32, 184).SetScaleXY(1.2);
					AddImage("", "IcDiamond", 256 + 20, 187);
					
					labelUserG = AddLabel(Ultility.StandardNumber(GameLogic.getInstance().user.GetZMoney()), 88, 61, 0xffffff, 0, 0x000000);
					labelUserG.setTextFormat(txtFormat);
					labelUserDiamond = AddLabel(Ultility.StandardNumber(GameLogic.getInstance().user.getDiamond()), 286, 61, 0xffffff, 0, 0x000000);
					labelUserDiamond.setTextFormat(txtFormat);
					
					labelNumG = AddLabel("0", 86 + 32, 178, 0, 0x000000);
					labelNumG.setTextFormat(txtFormat);
					labelNumG.defaultTextFormat = txtFormat;
					labelNumDiamond = AddLabel("0", 280 + 20, 178, 0, 0x000000);
					labelNumDiamond.defaultTextFormat = txtFormat;
					
					AddButton(BTN_BUY_G, "GuiBuyBalls_BtnBuyG", 65 + 32, 400 - 183);
					AddButton(BTN_BUY_DIAMOND, "GuiBuyBalls_BtnBuyDiamond", 245 + 45, 400 - 183);
					if (numBuyZMoneyVip <= 0)
					{
						GetButton(BTN_BUY_G).SetEnable(false);
						tooltip = new TooltipFormat();
						config = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MaxZMoneyBuyBallVip"];
						tooltip.text = "Bạn đã mua tối đa số bóng vàng bằng xu trong ngày\n(" + Ultility.StandardNumber(int(config)) + " bóng trên ngày)";
						GetButton(BTN_BUY_G).setTooltip(tooltip);
					}
					if (numBuyDiamondVip <= 0)
					{
						GetButton(BTN_BUY_DIAMOND).SetEnable(false);
						tooltip = new TooltipFormat();
						config = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MaxDiamondBuyBallVip"];
						tooltip.text = "Bạn đã mua tối đa số bóng vàng bằng kim cương trong ngày\n(" + Ultility.StandardNumber(int(config)) + " bóng trên ngày)";
						GetButton(BTN_BUY_DIAMOND).setTooltip(tooltip);
					}
				}
				else
				{
					AddImage("", "IcZingXu", 64, 69).SetScaleXY(1.2);
					AddImage("", "IcGold", 261, 70).SetScaleXY(1.2);
					AddImage("", "IcZingXu", 68 + 32, 184).SetScaleXY(1.2);
					AddImage("", "IcGold", 256 + 20, 187).SetScaleXY(1.2);
					
					labelUserG = AddLabel(Ultility.StandardNumber(GameLogic.getInstance().user.GetZMoney()), 88, 61, 0xffffff, 0, 0x000000);
					labelUserG.setTextFormat(txtFormat);
					labelUserMoney = AddLabel(Ultility.StandardNumber(GameLogic.getInstance().user.GetMoney()), 280, 61, 0xffffff, 0, 0x000000);
					labelUserMoney.setTextFormat(txtFormat);
					
					labelNumG = AddLabel("0", 86 + 32, 178, 0, 0x000000);
					labelNumG.setTextFormat(txtFormat);
					labelNumG.defaultTextFormat = txtFormat;
					labelNumMoney = AddLabel("0", 280 + 20, 178, 0, 0x000000);
					labelNumMoney.defaultTextFormat = txtFormat;
					
					AddButton(BTN_BUY_G, "GuiBuyBalls_BtnBuyG", 65 + 32, 400 - 183);
					AddButton(BTN_BUY_GOLD, "GuiBuyBalls_BtnBuyGold", 245 + 45, 400 - 183);
					if (numBuyGoldOrd <= 0)
					{
						GetButton(BTN_BUY_GOLD).SetEnable(false);
						tooltip = new TooltipFormat();
						config = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MaxMoneyBuyBallOrd"];
						tooltip.text = "Bạn đã mua tối đa số bóng thường bằng vàng trong ngày\n(" + Ultility.StandardNumber(int(config)) + " bóng trên ngày)";
						GetButton(BTN_BUY_GOLD).setTooltip(tooltip);
					}
					if (numBuyZMoneyOrd <= 0)
					{
						GetButton(BTN_BUY_G).SetEnable(false);
						tooltip = new TooltipFormat();
						config = ConfigJSON.getInstance().GetItemList("Param")["EventEuro"]["MaxZMoneyBuyBallOrd"];
						tooltip.text = "Bạn đã mua tối đa số bóng thường bằng xu trong ngày\n(" + Ultility.StandardNumber(int(config)) + " bóng trên ngày)";
						GetButton(BTN_BUY_G).setTooltip(tooltip);
					}
				}
				num = 10;
			}
			LoadRes("GuiBuyBalls_Theme");
		}
		
		public function showGUI(_typeBall:String, _okFunction:Function):void 
		{
			okFunction = _okFunction;
			typeBall = _typeBall;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_BUY_G:
					if (num == 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn hãy nhập số bóng để mua!");
					}
					else
					{
						if (typeBall == "ORD")
						{
							if (numBuyZMoneyOrd < num)
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Số bóng thường bạn có thể mua bằng xu trong ngày còn " + Ultility.StandardNumber(numBuyZMoneyOrd) + " bóng");
								num = numBuyZMoneyOrd;
							}
							else
							{
								okFunction(num, "ZMoney");
								Hide();
							}
						}
						else
						{
							if (numBuyZMoneyVip < num)
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Số bóng vàng bạn có thể mua bằng xu trong ngày còn " + Ultility.StandardNumber(numBuyZMoneyVip) + " bóng");
								num = numBuyZMoneyVip;
							}
							else
							{
								okFunction(num, "ZMoney");
								Hide();
							}
						}
					}
					break;
				case BTN_BUY_DIAMOND:
					if (num == 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn hãy nhập số bóng để mua!");
					}
					else
					{
						if (numBuyDiamondVip < num)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Số bóng vàng bạn có thể mua bằng kim cương trong ngày còn " + Ultility.StandardNumber(numBuyDiamondVip) + " bóng");
							num = numBuyDiamondVip;
						}
						else
						{
							okFunction(num, "Diamond");
							Hide();
						}
					}
					break;
				case BTN_BUY_GOLD:
					if (num == 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn hãy nhập số bóng để mua!");
					}
					else
					{
						if (numBuyGoldOrd < num)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Số bóng thường bạn có thể mua trong ngày còn " + Ultility.StandardNumber(numBuyGoldOrd) + " bóng");
							num = numBuyGoldOrd;
						}
						else
						{
							okFunction(num, "Money");
							Hide();
						}
					}
					break;
			}
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			var text:String = textBox.GetText();
			text = text.split(",").join("");
			num = int(text);
			if (num < 0)
			{
				num = 0;
			}
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			if (value > 100000000)
			{
				value = 100000000;
			}
			_num = value;
			textBox.SetText(Ultility.StandardNumber(value));
			
			var config:Object = ConfigJSON.getInstance().GetItemList("Param");
			config = config["EventEuro"]["BuyBall"][typeBall];
			if(labelNumG != null)
			{
				labelNumG.text = Ultility.StandardNumber(value * Number(config["ZMoney"]));
			}
			if (labelNumDiamond != null)
			{
				labelNumDiamond.text = Ultility.StandardNumber(value * Number(config["Diamond"]));
			}
			if (labelNumMoney != null)
			{
				labelNumMoney.text = Ultility.StandardNumber(value * Number(config["Money"]));
			}
		}		
	}

}