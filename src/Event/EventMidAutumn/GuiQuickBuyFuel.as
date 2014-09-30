package Event.EventMidAutumn 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventMidAutumn.EventPackage.SendBuyItemEventMidMoon;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiQuickBuyFuel extends BaseGUI 
	{
		private const ID_BTN_BUY:String = "idBtnBuy";
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const objType:Object = {"1":"PaperBurn","2":"GasCan","3":"SpaceCraft","4":"Propeller"};
		private const objId:Object = { "1":"1", "2":"1", "3":"1", "4":"1" };
		static public const TIME_TO_DELAY:int = 2;
		private var timeBuy:Number;
		private var isUpdateForBuy:Boolean;
		private var _listItemBuy:Object;
		private var _listTextNum:Object;
		public function GuiQuickBuyFuel(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiQuickBuyFuel";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(ID_BTN_CLOSE, "BtnThoat", 571, 20);
				var x:int = 40, y:int = 80;
				var sType:String;
				var sId:String;
				var priceDiamond:int;
				var priceZMoney:int;
				var btnZMoney:Button;
				var btnDiamond:Button;
				var tfPriceDiamond:TextField;
				var tfPriceZMoney:TextField;
				var imgGift:ButtonEx;
				var sTip:String;
				var numGift:int;
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("MidMoon_Lookup")["Material"];
				var guiData:GuiFrontScreenEvent = GuiMgr.getInstance().guiFrontEvent;
				_listTextNum = new Object();
				for (var i:int = 1; i <= 4; i++)
				{
					sType = objType[i.toString()];
					sId = objId[i.toString()];
					priceDiamond = cfg[sType]["Diamond"];
					priceZMoney = cfg[sType]["ZMoney"];
					//slot
					AddImage("", "GuiQuickBuyFuel_CtnFuel", x, y, true, ALIGN_LEFT_TOP);
					//gift
					imgGift = AddButtonEx("", "EventMidAutumn_Shop" + sType + sId, x + 35, y + 33);
					sTip = Localization.getInstance().getString("EventMidAutumn_Name" + sType + sId);
					imgGift.setTooltipText(sTip);
					//num Gift
					numGift = guiData.getNumItemEvent(sType);
					_listTextNum[sType] = AddLabel("x" + Ultility.StandardNumber(numGift), x + 16, y + 100, 0xffffff, 1, 0x000000);
					//button ZMoney
					btnZMoney = AddButton(ID_BTN_BUY + "_" + sType + "_" + sId + "_" + priceZMoney + "_ZMoney", 
								"GuiQuickBuyFuel_BtnBuyZMoney", x + 16, y + 130);
					tfPriceZMoney = AddLabel(Ultility.StandardNumber(priceZMoney), x + 23, y + 137, 0xffffff, 1, 0x000000);
					tfPriceZMoney.mouseEnabled = false;
					btnZMoney.SetEnable(priceZMoney > 0);
					//button Diamond
					btnDiamond = AddButton(ID_BTN_BUY + "_" + sType + "_" + sId + "_" + priceDiamond + "_Diamond", 
								"GuiQuickBuyFuel_BtnBuyDiamond", x + 16, y + 170);
					tfPriceDiamond = AddLabel(Ultility.StandardNumber(priceDiamond), x + 23, y + 177, 0xffffff, 1, 0x000000);
					tfPriceDiamond.mouseEnabled = false;
					btnDiamond.SetEnable(priceDiamond > 0);
					x += 135;
				}
			}
			LoadRes("GuiQuickBuyFuel_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case ID_BTN_CLOSE:
					Hide();
					break;
				case ID_BTN_BUY:
					var type:String = data[1];
					var id:int = data[2];
					var price:int = int(data[3]);
					var priceType:String = data[4];
					buyItem(type, id, priceType, price);
					break;
			}
		}
		
		
		private function buyItem(type:String, id:int, priceType:String, price:int):void 
		{
			var user:User = GameLogic.getInstance().user;
			var myMoney:int;
			if (priceType == "Diamond")
			{
				myMoney = user.getDiamond();
				if (myMoney < price)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ kim cương", 310, 200, 1);
					return;
				}
				else
				{
					user.updateDiamond( -price);
				}
			}
			else if (priceType == "ZMoney")
			{
				myMoney = user.GetZMoney();
				if (myMoney < price)
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
				else
				{
					user.UpdateUserZMoney( -price);
				}
			}
			var guiData:GuiFrontScreenEvent = GuiMgr.getInstance().guiFrontEvent;
			mergeBuyPacket(type, id, 1, priceType);
			guiData.updateNumItemEvent(type);
			var tf:TextField = _listTextNum[type];
			tf.text = "x" + Ultility.StandardNumber(guiData.getNumItemEvent(type));
			EffectMgr.setEffBounceDown("Mua thành công", "EventMidAutumn_" + type + id, 330, 280);
		}
		
		private function sendBuyAction():void
		{
			if (_listItemBuy == null)
			{
				return;
			}
			isUpdateForBuy = false;
			var type:String, id:String, priceType:String, num:int, pk:BasePacket;
			for (type in _listItemBuy)
			{
				for (id in _listItemBuy[type])
				{
					for (priceType in _listItemBuy[type][id])
					{
						num = _listItemBuy[type][id][priceType];
						pk = new SendBuyItemEventMidMoon(type, int(id), num, priceType);
						Exchange.GetInstance().Send(pk);
					}
					_listItemBuy[type][id] = null;
				}
				_listItemBuy[type] = null;
			}
			_listItemBuy = null;
		}
		
		private function mergeBuyPacket(itemType:String, itemId:int, num:int = 1, priceType:String = "ZMoney"):void
		{
			if (_listItemBuy == null)
			{
				_listItemBuy = new Object();
			}
			if (_listItemBuy[itemType] == null)
			{
				_listItemBuy[itemType] = new Object();
				if (_listItemBuy[itemType][itemId] == null)
				{
					_listItemBuy[itemType][itemId] = new Object();
				}
			}
			if (_listItemBuy[itemType][itemId][priceType] == null)
			{
				_listItemBuy[itemType][itemId][priceType] = 0;
			}
			_listItemBuy[itemType][itemId][priceType] += num;
			
			isUpdateForBuy = true;
			timeBuy = GameLogic.getInstance().CurServerTime;
		}
		
		override public function OnHideGUI():void 
		{
			sendBuyAction();
		}
		
		public function updateGUI(curTime:Number):void 
		{
			if (isUpdateForBuy)
			{
				if (curTime - timeBuy > TIME_TO_DELAY)
				{
					sendBuyAction();
				}
			}
		}
		
	}

}























