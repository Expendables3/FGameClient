package GUI.CreateEquipment 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.CreateEquipment.SendBuySpirit;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIBuySpirit extends BaseGUI 
	{
		private var _numSpirit:int;
		private var labelNumSpirit:TextField;
		private var _numBuyGold:int;
		private var labelNumBuyGold:TextField;
		private var config:Object;
		private var labelG:TextField;
		private var labelGold:TextField;
		//private var _numBuyZMoney:int;
		//private var labelNumBuyZMoney:TextField;
		static public const BTN_GOLD:String = "btnGold";
		static public const BTN_ZMONEY:String = "btnZmoney";
		static public const BTN_CLOSE:String = "btnClose";
		
		public function GUIBuySpirit(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 418, 19, this);
				AddButton(BTN_ZMONEY, "GuiBuySpirit_Btn_G", 260, 219);
				AddButton(BTN_GOLD, "GuiBuySpirit_Btn_Gold", 113, 219);
				
				config = ConfigJSON.getInstance().getItemInfo("Param", -1);
				config = config["CraftingBuyPower"];
				
				labelGold = AddLabel(Ultility.StandardNumber(config["Money"]), 100, 219, 0xffffff);
				labelG = AddLabel(Ultility.StandardNumber(config["ZMoney"]), 235, 219, 0xffffff);
				
				labelNumBuyGold = AddLabel("", 104, 100); 
				//labelNumBuyZMoney = AddLabel("", 250, 100);
				var txtFormat:TextFormat = new TextFormat("arial", 13, 0x01385c, true);
				//labelNumBuyGold.defaultTextFormat = txtFormat;
				//labelNumBuyZMoney.defaultTextFormat = txtFormat;
				numBuyGold = GameLogic.getInstance().user.restGoldBuyPower;
				//numBuyZMoney = GameLogic.getInstance().user.restGBuyPower;
				
				//Điểm tinh lực
				var ingradient:Object = GameLogic.getInstance().user.ingradient;
				labelNumSpirit = AddLabel("", 208, 73);
				txtFormat.size = 18;
				labelNumSpirit.defaultTextFormat = txtFormat;
				if (ingradient != null && ingradient["PowerTinh"] != null)
				{
					numSpirit = ingradient["PowerTinh"];
				}
				
				for (var i:int = 0; i < 2; i++)
				{
					AddImage("", "PowerTinh", i * 140 + 155, 144);
					txtFormat.color = 0x000000;
					AddLabel(Ultility.StandardNumber(config["Num"]), i * 140 + 100, 172).setTextFormat(txtFormat);
				}
				
				SetPos(190, 55);
			}
			LoadRes("GuiBuySpirit_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var p:Point = new Point(137 + 320, 157);
			var ingradient:Object = GameLogic.getInstance().user.ingradient;
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_GOLD:
					var numGold:int = config["Money"];
					GameLogic.getInstance().user.UpdateUserMoney(- numGold);
					GameLogic.getInstance().user.restGoldBuyPower--;
					numBuyGold --;
					Exchange.GetInstance().Send(new SendBuySpirit("Money"));
					
					numSpirit += config["Num"];
					Ultility.ShowEffText("+" + config["Num"], img, p, new Point(p.x, p.y - 20), new TextFormat("arial", 18, 0xffff00, true), 1, 0x000000);
					if (ingradient == null)
					{
						ingradient = new Object();
					}
					ingradient["PowerTinh"] = numSpirit;
					break;
				case BTN_ZMONEY:
					//if (numBuyZMoney > 0 && GameLogic.getInstance().user.GetZMoney() >= config["ZMoney"])
					if (GameLogic.getInstance().user.GetZMoney() >= config["ZMoney"])
					{
						var numZMoney:int = config["ZMoney"];
						GameLogic.getInstance().user.UpdateUserZMoney(-numZMoney);
						//GameLogic.getInstance().user.restGBuyPower--;
						//numBuyZMoney --;
						Exchange.GetInstance().Send(new SendBuySpirit("ZMoney"));
						
						numSpirit += config["Num"];
						Ultility.ShowEffText("+" + config["Num"], img, p, new Point(p.x, p.y - 20), new TextFormat("arial", 18, 0xffff00, true), 1, 0x000000);
						if (ingradient == null)
						{
							ingradient = new Object();
						}
						ingradient["PowerTinh"] = numSpirit;
					}
					else
					{
						//if (GameLogic.getInstance().user.GetZMoney() < config["ZMoney"])	
						//{
							GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
						//}
						//if (numBuyZMoney <= 0)
						//{
							//GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã mua đủ số lần trong ngày");
						//}
					}
					break;
			}
			
			if (GuiMgr.getInstance().guiCreateEquipment.IsVisible)
			{
				GuiMgr.getInstance().guiCreateEquipment.updateNumSpirit();
			}
			if (GuiMgr.getInstance().guiSpecialSmithy.IsVisible)
			{
				GuiMgr.getInstance().guiSpecialSmithy.updatePowerTinh();
			}
		}
		
		public function get numSpirit():int 
		{
			return _numSpirit;
		}
		
		public function set numSpirit(value:int):void 
		{
			_numSpirit = value;
			labelNumSpirit.text = Ultility.StandardNumber(value);
		}
		
		public function get numBuyGold():int 
		{
			return _numBuyGold;
		}
		
		public function set numBuyGold(value:int):void 
		{
			_numBuyGold = value;
			labelNumBuyGold.htmlText = "Còn <font size = '18' color='#cc6699'>" + Ultility.StandardNumber(value) + "</font> lần mua/ngày";
			if (numBuyGold > 0 && GameLogic.getInstance().user.GetMoney() >= config["Money"])
			{
				GetButton(BTN_GOLD).SetEnable(true);
			}
			else
			{
				GetButton(BTN_GOLD).SetEnable(false);
			}
		}
		
		/*public function get numBuyZMoney():int 
		{
			return _numBuyZMoney;
		}
		
		public function set numBuyZMoney(value:int):void 
		{
			_numBuyZMoney = value;
			labelNumBuyZMoney.htmlText = "Còn <font size = '18' color='#cc6699'>" + Ultility.StandardNumber(value) + "</font> lần mua/ngày";
			//if (numBuyZMoney > 0 && GameLogic.getInstance().user.GetZMoney() >= config["ZMoney"])
			//{
				//GetButton(BTN_ZMONEY).SetEnable(true);
			//}
			//else
			//{
				//GetButton(BTN_ZMONEY).SetEnable(false);
			//}
		}*/
		
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().GuiEnchantEquipment.IsVisible)
			{
				if (GuiMgr.getInstance().GuiEnchantEquipment.iTab == 1)
				{
					GuiMgr.getInstance().GuiEnchantEquipment.updatePowertinh();
				}
			}
		}
		
	}

}