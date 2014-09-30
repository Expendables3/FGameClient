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
	public class GuiQuickBuyOneFuel extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_BUY:String = "idBtnBuy";
		static public const TIME_TO_DELAY:int = 2;
		
		private var tfNum:TextField;
		
		private var _type:String;
		private var _id:int;
		private var timeBuy:Number;
		private var isUpdateForBuy:Boolean;
		private var _listItemBuy:Object;
		
		
		public function GuiQuickBuyOneFuel(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiQuickBuyOneFue";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(ID_BTN_CLOSE, "BtnThoat", 353, 16);
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("MidMoon_Lookup")["Material"];
				
				AddImage("", "GuiQuickBuyFuel_CtnFuel", 130, 75, true, ALIGN_LEFT_TOP);
				
				var imgGift:ButtonEx = AddButtonEx("", "EventMidAutumn_Shop" + _type + _id, 165, 110);
				imgGift.setTooltipText(Localization.getInstance().getString("EventMidAutumn_Name" + _type + _id));
				tfNum = AddLabel("x" + Ultility.StandardNumber(GuiMgr.getInstance().guiFrontEvent.getNumItemEvent(_type, _id)), 140, 178, 0xffffff, 1, 0x000000);
				
				var zmoney:int = cfg[_type]["ZMoney"];
				var btnZMoney:Button = AddButton(ID_BTN_BUY + "_" + _type + "_" + _id + "_" + zmoney + "_ZMoney",
													"GuiQuickBuyOneFuel_BtnBuyZMoney",
													80, 215);
				var tfZMoney:TextField = AddLabel(Ultility.StandardNumber(zmoney), 85, 223, 0xffffff, 1, 0x000000);
				tfZMoney.mouseEnabled = false;
				btnZMoney.SetEnable(zmoney > 0);
				var diamond:int = cfg[_type]["Diamond"];
				var btnDiamond:Button = AddButton(ID_BTN_BUY + "_" + _type + "_" + _id + "_" + diamond + "_Diamond",
													"GuiQuickBuyOneFuel_BtnBuyDiamond",
													210, 217);
				var tfDiamond:TextField = AddLabel(Ultility.StandardNumber(diamond), 215, 224, 0xffffff, 1, 0x000000);
				tfDiamond.mouseEnabled = false;
				btnDiamond.SetEnable(diamond > 0);
			}
			LoadRes("GuiQuickBuyOneFuel_Theme");
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
			tfNum.text = "x" + Ultility.StandardNumber(guiData.getNumItemEvent(type));
			EffectMgr.setEffBounceDown("Mua thành công", "EventMidAutumn_Shop" + type + id, 330, 280);
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
		
		public function setData(type:String, id:int = 1):void
		{
			_type = type;
			_id = id;
		}
	}

}



























