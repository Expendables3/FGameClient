package Event.EventHalloween.HalloweenGui 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventHalloween.HalloweenPackage.SendExchangeAccumulationPoint;
	import Event.EventNoel.NoelGui.ItemGui.GuiTooltipGiftBox;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.GUIToolTip;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiSavePoint extends GUIGetStatusAbstract 
	{
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const CMD_PAY:String = "cmdPay";
		static public const CMD_RECEIVE:String = "cmdReceive";
		private var _listGift:Array = [];
		private var _objPoint:Object;
		public var tfPoint:TextField;
		public var inExchange:Boolean = false;		//đang trong quá trình đổi equipment
		public function GuiSavePoint(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiSavePoint";
			_urlService = "AccumulationPointService.getAccumulationPoint";
			_idPacket = Constant.CMD_GET_SAVE_POINT_STATUS;
			_imgThemeName = "GuiSavePoint_Theme";
		}
		
		override protected function onInitGuiBeforeServer():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 608 - 59, 35 - 18);
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("Accumulation_Point");
			var obj:Object;
			var gift:AbstractGift;
			var itGift:AbstractItemGift;
			var i:int;
			var x:int = 97, y:int = 167;
			_objPoint = new Object();
			var tfPoint:TextField;
			for (i = 1; i <= 6; i++)
			{
				obj = cfg[i];
				_objPoint[i] = obj["Point"];
				gift = AbstractGift.createGift(obj["ItemType"]);
				gift.setInfo(obj);
				itGift = AbstractItemGift.createItemGift(obj["ItemType"], this.img, "GuiSavePoint_ImgSlot", x, y);
				itGift.yNum = 55;
				itGift.initData(gift, "", 66, 66, true);
				if (obj["ItemType"] == "GiftBox")
				{
					itGift.hasTooltipText = false;
				}
				itGift.drawGift();
				if (obj["ItemType"] == "GiftBox")
				{
					//thêm guitooltip vào cho nó
					if (itGift.guiTooltip == null)
					{
						var guiTooltip:GuiTooltipGiftBox = new GuiTooltipGiftBox(null, "");
						guiTooltip.Id = gift.ItemId;
						guiTooltip.X = itGift.img.x + img.x + 100;
						itGift.setGUITooltip(guiTooltip);
					}
				}
				x += 164;
				if (i == 3)
				{
					x = 97;
					y += 143;
				}
			}
		}
		
		override protected function onInitData(data1:Object):void 
		{
			HalloweenMgr.getInstance().nPoint = data1["AccumulationPoint"]["Point"];
		}
		
		override protected function onInitGuiAfterServer():void 
		{
			tfPoint = AddLabel("", 245, 88, 0xffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 14);
			tfPoint.defaultTextFormat = fm;
			var p:int = HalloweenMgr.getInstance().nPoint;
			tfPoint.text = Ultility.StandardNumber(p);
			
			AddButton(CMD_PAY, "GuiSavePoint_BtnPay", 372 + 14, 87);
			var x:int = 90, y:int = 260 - 15;
			var btnRecevie:Button;
			var tfPointRequire:TextField;
			for (var i:int = 1; i <= 6; i++)
			{
				btnRecevie = AddButton(CMD_RECEIVE + "_" + i, "GuiSavePoint_BtnReceive", x, y);
				btnRecevie.SetEnable(HalloweenMgr.getInstance().nPoint >= _objPoint[i]);
				tfPointRequire = AddLabel(Ultility.StandardNumber(_objPoint[i]), x - 5, y + 3, 0xffffff, 1, 0x000000);
				tfPointRequire.mouseEnabled = false;
				x += 164;
				if (i == 3)
				{
					x = 90;
					y += 143;
				}
			}
			var startTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["StartTime"];
			var endTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["EndTime"];
			var date:Date = new Date(startTime * 1000);
			var startDate:String = date.getDate() + "/" + (date.getMonth() + 1);
			date = new Date(endTime * 1000);
			var endDate:String = date.getDate() + "/" + (date.getMonth() + 1);
			var strTip:String = "Từ ngày " + startDate + " đến ngày " + endDate;
			var tfTip:TextField = AddLabel("", 70, 104, 0xff0000);
			fm = new TextFormat("Arial", 12); fm.color = 0xff0000;
			tfTip.defaultTextFormat = fm;
			tfTip.text = strTip;
		}
		
		public function refreshListBtnReceive():void
		{
			var btnRecevie:Button;
			for (var i:int = 1; i <= 6; i++)
			{
				btnRecevie = GetButton(CMD_RECEIVE + "_" + i);
				btnRecevie.SetEnable(HalloweenMgr.getInstance().nPoint >= _objPoint[i]);
			}
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
				case CMD_PAY:
					if (checkTimeExpired())
					{
						Hide();
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian đổi quà từ điểm tích lũy", 310, 200, 1);
						break;
					}
					GuiMgr.getInstance().GuiNapG.Init();
					Hide();
					break;
				case CMD_RECEIVE:
					if (checkTimeExpired())
					{
						Hide();
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian đổi quà từ điểm tích lũy", 310, 200, 1);
						return;
					}
					var id:int = int(data[1]);
					if (HalloweenMgr.getInstance().nPoint < _objPoint[id])
					{
						break;
					}
					/*nếu là quà thường thì cho rơi luôn*/
					var cfg:Object = ConfigJSON.getInstance().getItemInfo("Accumulation_Point");
					var temp:Object = cfg[id];
					var gift:AbstractGift;
					if (Ultility.categoriesGift(temp["ItemType"]) == 1 || temp["ItemType"] == "GiftBox")
					{
						if (inExchange)//nếu đang đổi đồ mà ấn tiếp vào đổi đồ
						{
							return;
						}
						inExchange = true;
						if (temp["ItemType"] == "GiftBox")
						{
							GuiMgr.getInstance().guiChooseElementSavePoint.giftId = id;
							GuiMgr.getInstance().guiChooseElementSavePoint.Show(Constant.GUI_MIN_LAYER, 5);
							return;
						}
					}
					else
					{
						gift = new GiftNormal();
						gift.setInfo(temp);
						EffectMgr.setEffBounceDown("Nhận thành công", gift.getImageName(), 330, 280, null, temp["Num"]);
						EventSvc.getInstance().processGetGift(gift, temp["Num"]);
					}
					var pk:SendExchangeAccumulationPoint = new SendExchangeAccumulationPoint(id);
					Exchange.GetInstance().Send(pk);
					HalloweenMgr.getInstance().nPoint -= _objPoint[id];
					/*Effect trừ ngọc lục bảo*/
					var posStart:Point = new Point(tfPoint.x + 15, tfPoint.y + 35);
					posStart  = img.localToGlobal(posStart);
					var posEnd:Point = new Point(tfPoint.x + 15, tfPoint.y + 10);
					posEnd = img.localToGlobal(posEnd);
					var fm:TextFormat = new TextFormat("Arial", 16, 0xFF0000);
					fm.align = "center";
					fm.bold = true;
					var strSub:String = "-" + Ultility.StandardNumber(_objPoint[id]);
					Ultility.ShowEffText(strSub, null, posStart, posEnd, fm);
					var nPoint:int = HalloweenMgr.getInstance().nPoint;
					tfPoint.text = Ultility.StandardNumber(HalloweenMgr.getInstance().nPoint);
					refreshListBtnReceive();
					break;
			}
		}
		
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < _listGift.length; i++)
			{
				var itGift:AbstractItemGift = _listGift[i];
				itGift.Destructor();
			}
			_listGift.splice(0, _listGift.length);
			super.ClearComponent();
		}
		
		public function processGetGift(odlData:Object, data:Object):void 
		{
			var oldPacket:SendExchangeAccumulationPoint = odlData as SendExchangeAccumulationPoint;
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("Accumulation_Point");
			var temp:Object = cfg[oldPacket.Id];
			var kind:int = Ultility.categoriesGift(temp["ItemType"]);
			
			if (kind == 1 || temp["ItemType"] == "GiftBox")
			{
				if (inExchange)
				{
					inExchange = false;
				}
				EventSvc.getInstance().initGiftSavePoint(data);
				var listGiftServer:Array = EventSvc.getInstance().getGiftServer();
				var num:int = listGiftServer.length;
				var typeFeed:String;
				var isFeed:Boolean = false;
				switch(oldPacket.Id)
				{
					case 6:
						isFeed = true;
						typeFeed = "EventNoelSeal6";
						break;
				}
				GuiMgr.getInstance().guiGiftEventNoel.isFeed = isFeed;
				GuiMgr.getInstance().guiGiftEventNoel.typeFeed = typeFeed;
				GuiMgr.getInstance().guiGiftEventNoel.setNumSlot(num);
				GuiMgr.getInstance().guiGiftEventNoel.Show(Constant.GUI_MIN_LAYER, 5);
			}
			else if (kind == 0)
			{
				return;
			}
		}
		
		public function checkTimeExpired():Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var startTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["StartTime"];
			var endTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["EndTime"];
			if (curTime >= startTime && curTime <= endTime)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		override public function OnHideGUI():void 
		{
			if (checkTimeExpired())
			{
				GuiMgr.getInstance().guiFrontScreen.RemoveButtonEx(GUIFrontScreen.ID_BTN_NAP_THE);
			}
		}
		
		public function refreshPoint():void
		{
			tfPoint.text = Ultility.StandardNumber(HalloweenMgr.getInstance().nPoint);
		}
	}

}






















