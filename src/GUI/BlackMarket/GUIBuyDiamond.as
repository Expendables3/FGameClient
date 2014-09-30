package GUI.BlackMarket 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.BlackMarket.SendBuyDiamond;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIBuyDiamond extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_BUY:String = "btnBuy";
		private var labelDiamond:TextField;
		private var _numDiamond:int;
		private var arrConfig:Array;
		
		public function GUIBuyDiamond(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function():void
			{
				SetPos(190, 55);
				AddButton(BTN_CLOSE, "BtnThoat", 413, 19, this);
				labelDiamond = AddLabel("So kim cuong", 168, 79, 0xff00ff, 1, 0x000000);
				var txtFormat:TextFormat = new TextFormat("arial", 18, 0xff00ff, true);
				labelDiamond.defaultTextFormat = txtFormat;
				numDiamond = GameLogic.getInstance().user.getDiamond();
				
				var config:Object = ConfigJSON.getInstance().GetItemList("DiamondExchange");
				arrConfig = [];
				for (var s:String in config)
				{
					var obj:Object = config[s];
					obj["id"] = s;
					arrConfig.push(obj);
				}
				arrConfig.sortOn(["id"], Array.NUMERIC);
				
				for (var i:int = 0; i < arrConfig.length; i++)
				{
					var text:String = Ultility.StandardNumber(arrConfig[i]["Diamond"]) + "\nKim cương";
					var percentSaleOff:Number = Number(arrConfig[i]["Diamond"] - arrConfig[i]["ZMoney"])/int(arrConfig[i]["Diamond"]);
					percentSaleOff = int(percentSaleOff * 100);
					if (percentSaleOff != 0)
					{
						text += "\n\n\n\n\n\n\n\(Giảm " + percentSaleOff + "%)";
					}
					var labelDiamond:TextField = AddLabel(text, i * 135 + 42, 200 - 95, 0xffffff, 1, 0x000000);
					txtFormat = new TextFormat("arial", 14, 0xffffff, true);
					txtFormat.align = "center";
					labelDiamond.setTextFormat(txtFormat);
					
					var btnG:Button = AddButton(BTN_BUY + "_" + i.toString(), "GuiBuyDiamond_BtnG", i * 135 + 58, 264);
					//if (arrConfig[i]["ZMoney"] > GameLogic.getInstance().user.GetZMoney())
					//{
						//btnG.SetEnable(false);
					//}
					//else
					//{
						//btnG.SetEnable(true);
					//}
					AddLabel(Ultility.StandardNumber(arrConfig[i]["ZMoney"]), i * 135 + 35, 264);
				}
			}
			LoadRes("GuiBuyDiamond");
		}
		
		private function updateButtonG():void
		{
			for (var i:int = 0; i < arrConfig.length; i++)
			{
				var btnG:Button = GetButton(BTN_BUY + "_" + i.toString());
				if (arrConfig[i]["ZMoney"] > GameLogic.getInstance().user.GetZMoney())
				{
					btnG.SetEnable(false);
				}
				else
				{
					btnG.SetEnable(true);
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_CLOSE)
			{
				Hide();
			}
			else
			if (buttonID.search(BTN_BUY) >= 0)
			{
				var i:int = buttonID.split("_")[1];
				if (GameLogic.getInstance().user.GetZMoney() >= arrConfig[i]["ZMoney"])
				{
					GameLogic.getInstance().user.UpdateUserZMoney( -arrConfig[i]["ZMoney"]);
					GameLogic.getInstance().user.updateDiamond(arrConfig[i]["Diamond"]);
					numDiamond += arrConfig[i]["Diamond"];
					
					//updateButtonG();
					
					EffectMgr.getInstance().textFly( "+" + arrConfig[i]["Diamond"], new Point(452, 170), new TextFormat("arial", 15, 0xff00ff, true));
					Exchange.GetInstance().Send(new SendBuyDiamond(arrConfig[i]["id"]));
				}
				else
				{
					GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
				}
			}
		}
		
		override public function OnHideGUI():void 
		{
			var guiMarket:GUIMarket  = GuiMgr.getInstance().guiMarket;
			if (guiMarket.IsVisible)
			{
				guiMarket.numDiamond = numDiamond;
			}
			
			var guiShopMarket:GUIShopMarket = GuiMgr.getInstance().guiShopMarket;
			if(guiShopMarket.IsVisible)
			{
				guiShopMarket.numDiamond = numDiamond;
			}
		}
		
		public function get numDiamond():int 
		{
			return _numDiamond;
		}
		
		public function set numDiamond(value:int):void 
		{
			_numDiamond = value;
			labelDiamond.text = Ultility.StandardNumber(value);
		}
		
	}

}