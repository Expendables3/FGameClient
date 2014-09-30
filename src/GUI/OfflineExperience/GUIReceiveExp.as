package GUI.OfflineExperience 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.OfflineExp.SendGetOfflineExp;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIReceiveExp extends BaseGUI 
	{
		private const BTN_FREE:String = "BtnFree";
		private const BTN_CLOSE:String = "BtnClose";
		private const BTN_GOLD:String = "BtnGold";
		private var _accumulateTime:Number;
		private var accumulateTextField:TextField;
		private var tipTextField:TextField;
		private var maxTimeTextField:TextField;
		private var expTextField:TextField;
		private var x2ExpTextField:TextField;
		private var goldTextField:TextField;
		private var _gold:int;
		private var _exp:int;
		private var _maxTime:int;
		private var buttonFree:Button;
		private var buttonGold:Button;
		//private var waitingImage:Image;
		
		
		
		[Embed(source = '../../../content/dataloading.swf', symbol = 'DataLoading')]
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public function GUIReceiveExp(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 305 + 273, 20);	
				buttonFree = AddButton(BTN_FREE, "GuiReceiveExp_Btn_Free", 440, 290);
				buttonGold = AddButton(BTN_GOLD, "GuiReceiveExp_Btn_Gold", 430, 345);
				buttonFree.SetEnable(false);
				buttonGold.SetEnable(false);
				accumulateTextField = AddLabel("", 150 + 212, 200 - 19, 0xFFF100, 1, 0xffffff);
				tipTextField = AddLabel("", 150 + 227 - 75, 230 + 153, 0xFFF100, 0);
				
				maxTimeTextField = AddLabel("", 150 + 247, 207,0xFFF100, 1, 0xffffff);
				expTextField = AddLabel("", 150 + 102, 220 + 74,0xFFF100, 1, 0x603813);
				x2ExpTextField = AddLabel("", 150 + 102, 230 + 116,0xFFF100, 1, 0x603813);
				goldTextField = AddLabel("", 150 + 290 - 25, 240 + 105, 0xffffff, 1, 0x603813);
				
				var txtFormat:TextFormat = new TextFormat("arial", 20, 0xcd0101, true);
				accumulateTextField.defaultTextFormat = txtFormat;
				txtFormat.size = 13;
				txtFormat.color = 0x074661;
				tipTextField.defaultTextFormat = txtFormat;
				txtFormat.size = 18;
				txtFormat.color = 0xFFF100;
				expTextField.defaultTextFormat = txtFormat;
				x2ExpTextField.defaultTextFormat = txtFormat;
				txtFormat.size = 11;
				txtFormat.color = 0xcd0101;
				maxTimeTextField.defaultTextFormat = txtFormat;
				
				img.addChild(WaitData);
				WaitData.x = 280;
				WaitData.y = 197;
				WaitData.visible = true;
				SetPos(100, 70);
				
				var numTip:int = int(Localization.getInstance().getString("NumTip"));
				var i:int = Math.random() * (numTip-1) + 1;
				var tip:String = Localization.getInstance().getString("Tip" + i);
				tipTextField.text = tip;
			}
			LoadRes("GuiReceiveExp_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_FREE:
					Exchange.GetInstance().Send(new SendGetOfflineExp(false));
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + exp);
					break;
				case BTN_GOLD:
					Exchange.GetInstance().Send(new SendGetOfflineExp(true));
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + exp*2);
					GameLogic.getInstance().user.UpdateUserMoney( -gold);
					break;
			}
			Hide();
		}
		
		public function showGUI(totalTime:Number):void
		{
			Show(Constant.GUI_MIN_LAYER, 10);
			updateAccumulateTime(totalTime);
		}
		
		public function updateAccumulateTime(time:Number):void
		{
			WaitData.visible = false;
			var config:Object = ConfigJSON.getInstance().getItemInfo("Param", -1)["OfflineExp"];
			var minTime:Number = config["MinTimePopup"];
			
			maxTime = config["MaxTimeExp"];
			accumulateTime = Math.min(maxTime, time);
			
			var level:int = GameLogic.getInstance().user.Level;
			config = ConfigJSON.getInstance().getItemInfo("OfflineExp", -1);
			for (var s:String in config)
			{
				if (config[s]["Level"][0] <= level && config[s]["Level"][1] >= level)
				{
					config = config[s];
					break;
				}
			}
			
			exp = Math.round(config["Exp"] * accumulateTime * config["Rate"]);
			gold = config["MoneyRate"] * exp;
			
			
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.htmlText = "Thời gian rời mạng tối thiểu <font color = '#cd0101'> " + getDate(minTime) + " </font>\nmới được nhận kinh nghiệm"; 
			if (time < minTime)
			{
				buttonFree.SetEnable(false);
				buttonFree.setTooltip(tooltip);
			}
			else
			{
				buttonFree.SetEnable(true);
				buttonFree.setTooltip(null);
			}
			
			if (GameLogic.getInstance().user.GetMoney() < gold || time < minTime)
			{
				buttonGold.SetEnable(false);
				
				if (GameLogic.getInstance().user.GetMoney() < gold)
				{
					tooltip.text = "Bạn không đủ vàng";
				}
				buttonGold.setTooltip(tooltip);
			}
			else
			{
				buttonGold.SetEnable(true);
				buttonGold.setTooltip(null);
			}
		}
		
		public function get accumulateTime():Number 
		{
			return _accumulateTime;
		}
		
		public function set accumulateTime(value:Number):void 
		{
			_accumulateTime = value;
			accumulateTextField.text = getDate(value);
		}
		
		public function get gold():int 
		{
			return _gold;
		}
		
		public function set gold(value:int):void 
		{
			_gold = value;
			goldTextField.text = value.toString();
		}
		
		public function get exp():int 
		{
			return _exp;
		}
		
		public function set exp(value:int):void 
		{
			_exp = value;
			expTextField.text = value.toString() + " kinh nghiệm";
			x2ExpTextField.text = (2 * value).toString() + " kinh nghiệm";
		}
		
		public function get maxTime():int 
		{
			return _maxTime;
		}
		
		public function set maxTime(value:int):void 
		{
			_maxTime = value;
			maxTimeTextField.text = int(value / 3600).toString();
		}
		
		private function getDate(remainSecond:Number):String
		{
			var day:int = Math.floor(remainSecond / (24 * 3600));
			var hour:int = Math.floor((remainSecond - day * 24 * 3600) / (3600));
			var minute:int = Math.floor((remainSecond - day * 24 * 3600 - hour * 3600) / (60));
			var result:String = "";
			if (day != 0)
			{
				result += day + " ngày ";
			}
			if(hour!= 0)
			{
				result += hour + " giờ ";
			}
			if (minute != 0)
			{
				result += minute + " phút";
			}
			if (day + hour + minute == 0)
			{
				result = "0 giờ";
			}
			return result;
		}
	}

}