package Event.Tet2013.gui 
{
	import Data.ConfigJSON;
	import Event.EventMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Tet2013.gui.itemgui.TooltipTrunkOnline;
	import Event.Tet2013.TetPacket.SendReceiveOnlineGift;
	import Event.Tet2013.TetPacket.SendRevertDay;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * Feature online nhận quà
	 * @author HiepNM2
	 */
	public class GuiGiftOnline extends GUIGetStatusAbstract 
	{
		/*const*/
		private const DAY_CONFIG:int = 15;
		//private const DAY_CONFIG:int = 7;
		private const CMD_CLOSE:String = "cmdClose";
		private const CMD_RECEIVE:String = "cmdReceive";
		private const CMD_REVERT:String = "cmdRevert";
		private const listGiftPos:Object = 
		{ 
			"1": { "x":74, "y":181 }, "2": { "x":217, "y":181 }, "3": { "x":361, "y":181 }, "4": { "x":505, "y":181 }, 
			"5": { "x":649, "y":181 }, "6": { "x":74, "y":310 }, "7": { "x":217, "y":310 }, "8": { "x":361, "y":310 }, 
			"9": { "x":505, "y":310 }, "10": { "x":649, "y":310 }, "11": { "x":74, "y":439 }, "12": { "x":217, "y":439 }, 
			"13": { "x":361, "y":439 }, "14": { "x":505, "y":439 }, "15": { "x":649, "y":439 }
		};
		/*GUI properties*/
		private var onlineGift1:AbstractItemGift, onlineGift2:AbstractItemGift, onlineGift3:AbstractItemGift, onlineGift4:AbstractItemGift, onlineGift5:AbstractItemGift, onlineGift6:AbstractItemGift, onlineGift7:AbstractItemGift, onlineGift8:AbstractItemGift, onlineGift9:AbstractItemGift, onlineGift10:AbstractItemGift, onlineGift11:AbstractItemGift, onlineGift12:AbstractItemGift, onlineGift13:AbstractItemGift, onlineGift14:AbstractItemGift, onlineGift15:AbstractItemGift;
		private var imgGift1:Image, imgGift2:Image, imgGift3:Image, imgGift4:Image, imgGift5:Image, imgGift6:Image, imgGift7:Image, imgGift8:Image, imgGift9:Image, imgGift10:Image, imgGift11:Image, imgGift12:Image, imgGift13:Image, imgGift14:Image, imgGift15:Image;
		private var imgReceived1:Image, imgReceived2:Image, imgReceived3:Image, imgReceived4:Image, imgReceived5:Image, imgReceived6:Image, imgReceived7:Image, imgReceived8:Image, imgReceived9:Image, imgReceived10:Image, imgReceived11:Image, imgReceived12:Image, imgReceived13:Image, imgReceived14:Image, imgReceived15:Image;
		private var btnReceive1:Button, btnReceive2:Button, btnReceive3:Button, btnReceive4:Button, btnReceive5:Button, btnReceive6:Button, btnReceive7:Button, btnReceive8:Button, btnReceive9:Button, btnReceive10:Button, btnReceive11:Button, btnReceive12:Button, btnReceive13:Button, btnReceive14:Button, btnReceive15:Button;
		private var btnRevert1:Button, btnRevert2:Button, btnRevert3:Button, btnRevert4:Button, btnRevert5:Button, btnRevert6:Button, btnRevert7:Button, btnRevert8:Button, btnRevert9:Button, btnRevert10:Button, btnRevert11:Button, btnRevert12:Button, btnRevert13:Button, btnRevert14:Button, btnRevert15:Button;
		private var tfRevertPrice1:TextField, tfRevertPrice2:TextField, tfRevertPrice3:TextField, tfRevertPrice4:TextField, tfRevertPrice5:TextField, tfRevertPrice6:TextField, tfRevertPrice7:TextField, tfRevertPrice8:TextField, tfRevertPrice9:TextField, tfRevertPrice10:TextField, tfRevertPrice11:TextField, tfRevertPrice12:TextField, tfRevertPrice13:TextField, tfRevertPrice14:TextField, tfRevertPrice15:TextField;
		private var imgTick1:Image, imgTick2:Image, imgTick3:Image, imgTick4:Image, imgTick5:Image, imgTick6:Image, imgTick7:Image, imgTick8:Image, imgTick9:Image, imgTick10:Image, imgTick11:Image, imgTick12:Image, imgTick13:Image, imgTick14:Image, imgTick15:Image;
		//private var imgMiss1:Image, imgMiss2:Image, imgMiss3:Image, imgMiss4:Image, imgMiss5:Image, imgMiss6:Image, imgMiss7:Image, imgMiss8:Image, imgMiss9:Image, imgMiss10:Image, imgMiss11:Image, imgMiss12:Image, imgMiss13:Image, imgMiss14:Image, imgMiss15:Image;
		private var _listOnlineGift:Array;
		private var prgDay:ProgressBar;
		private var tfDay:TextField;
		/*logic properties*/
		private var _dayOnline:int;				//số ngày online
		private var _dayEvent:int;				//số ngày event đã diễn ra
		private var oStatus:Object = 
		{
			"1":0, "2":0, "3":0, "4":0, "5":0, "6":0, "7":0, "8":0, "9":0, "10":0, "11":0, "12":0, "13":0, "14":0, "15":0
		};
		private var inReceive:Boolean;			//đang trong lúc nhận quà
		private var inRevert:Boolean;
		public function GuiGiftOnline(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftOnline";
			_imgThemeName = "GuiOnlineGift_Theme";
			_urlService = "KeepLoginService.getKeepLogin";
			_idPacket = Constant.CMD_GET_KEEP_LOGIN;
		}
		override protected function onInitGuiBeforeServer():void 
		{
			AddButton(CMD_CLOSE, "BtnThoat", 760, 20);
			/*vẽ phần progress bar của số ngày online*/
			AddImage("", "GuiOnlineGift_ImgPrgBarBg", 204, 114, true, ALIGN_LEFT_TOP);
			prgDay = AddProgress("", "GuiOnlineGift_PrgDayOnline", 223, 121);
			AddImage("", "GuiOnlineGift_ImgDock", 205, 113, true, ALIGN_LEFT_TOP);
			tfDay = AddLabel("", 214 - 43, 118, 0xffffff, 1, 0x000000);
			AddLabel("Số ngày đã online:", 90, 118, 0x096791, 0);
			drawOnlineGifts(DAY_CONFIG);
			/*vẽ điều kiện thời gian nhận quà*/
			var event:Object = ConfigJSON.getInstance().getItemInfo("Event")["KeepLogin"];
			var date:Date = new Date(event["BeginTime"] * 1000);
			var begin:String = date.getDate() + "/" + (date.getMonth() + 1);
			date = new Date(event["ExpireTime"] * 1000);
			var end:String = date.getDate() + "/" + (date.getMonth() + 1);
			var str:String = "từ ngày " + begin + " đến ngày " + end;
			var tf:TextField = AddLabel("", 320, 18, 0xffff00, 0, 0x000000);
			var fm:TextFormat = new TextFormat("Courier New", 23, 0xffff00,true);
			tf.defaultTextFormat = fm;
			tf.text = str;
		}
		
		override protected function onInitData(data1:Object):void 
		{
			_dayOnline = data1["KeepLogin"]["NumCurrentLogin"];
			_dayEvent = data1["KeepLogin"]["NumCanLogin"];
			updateStatus(data1["KeepLogin"]["Status"]);
		}
		
		private function updateStatus(data:Object):void
		{
			for (var i:int = 1; i <= DAY_CONFIG; i++)
			{
				oStatus[i] = data[i];
			}
		}
		
		override protected function onInitGuiAfterServer():void 
		{
			updateOnlineGifts(_dayEvent);
			updateDayOnline();
			var str:String = "Sự kiện đã diễn ra được: " + _dayEvent + " ngày";
			var tfEvet:TextField = AddLabel("", 240, this.img.height - 50, 0x096791, 0);
			var fm:TextFormat = new TextFormat("Arial", 18, 0x096791, true);
			tfEvet.defaultTextFormat = fm;
			tfEvet.text = str;
		}
		private function updateDayOnline():void
		{
			prgDay.setStatus(Number(_dayOnline) / Number(DAY_CONFIG));
			tfDay.text = Ultility.StandardNumber(_dayOnline);
		}
		private function drawOnlineGifts(day:int):void 
		{
			var onlineGift:AbstractItemGift,
				imgGift:Image, imgReceived:Image, imgTick:Image,
				btnReceive:Button, btnRevert:Button,
				tfRevertPrice:TextField;
			var x:int, y:int, obj:Object;
			var info:AbstractGift;
			_listOnlineGift = [];
			var cf:Object = ConfigJSON.getInstance().getItemInfo("KeepLogin_Gift");
			for (var i:int = 1; i <= day; i++)
			{
				if (cf[i] == null)	break;
				x = listGiftPos[i]["x"];
				y = listGiftPos[i]["y"];
				obj = ConfigJSON.getInstance().getItemInfo("KeepLogin_Gift")[i]["Gift"]["1"];
				info = AbstractGift.createGift(obj["ItemType"]);
				info.setInfo(obj);
				onlineGift = this["onlineGift" + i] = AbstractItemGift.createItemGift(info.ItemType, this.img, "GuiOnlineGift_ImgSlot", x, y, true);
				onlineGift.initData(info,"",67,67);
				onlineGift.hasTooltipImg = false;
				onlineGift.hasTooltipText = true;
				onlineGift.setHasBackGroundColor(false);
				onlineGift.yNum = 55;
				onlineGift.drawGift();
				_listOnlineGift.push(onlineGift);
				imgGift = this["imgGift" + i] = AddImage("", "GuiOnlineGift_ImgGift", x - 10, y, true, ALIGN_LEFT_TOP);
				imgReceived = this["imgReceived" + i] = AddImage("", "GuiOnlineGift_ImgReceived", x - 25, y + 52, true, ALIGN_LEFT_TOP);
				imgTick = this["imgTick" + i] = AddImage("", "GuiOnlineGift_ImgTick", x + 50, y - 26, true, ALIGN_LEFT_TOP);
				btnReceive = this["btnReceive" + i] = AddButton(CMD_RECEIVE + "_" + i, "GuiOnlineGift_BtnReceive", x, y + 80);
				btnRevert = this["btnRevert" + i] = AddButton(CMD_REVERT + "_" + i, "GuiOnlineGift_BtnRevert", x - 10, y + 80);
				tfRevertPrice = this["tfRevertPrice" + i] = AddLabel("", x + 20, y + 82, 0xffffff, 1, 0x000000);
				tfRevertPrice.text = Ultility.StandardNumber(ConfigJSON.getInstance().getItemInfo("KeepLogin_Gift")[i]["Price"]["ZMoney"]);
				imgGift.img.visible = imgReceived.img.visible = imgTick.img.visible = btnReceive.img.visible = btnRevert.img.visible = tfRevertPrice.visible = false;
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (inRevert || inReceive) return;
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var day:int;
			switch(cmd)
			{
				case CMD_CLOSE:
					Hide();
					break;
				case CMD_RECEIVE:
					day = int(data[1]);
					receiveGift(day);
					break;
				case CMD_REVERT:
					day = int(data[1]);
					var price:int = ConfigJSON.getInstance().getItemInfo("KeepLogin_Gift")[day]["Price"]["ZMoney"];
					if (Ultility.payMoney("ZMoney", price))
					{
						revertDay(day);
					}
			}
		}
		
		private function receiveGift(day:int):void 
		{
			inReceive = true;
			var pk:SendReceiveOnlineGift = new SendReceiveOnlineGift(day);
			Exchange.GetInstance().Send(pk);
		}
		
		public function processReceiveGift(data:Object, oldData:Object):void
		{
			var pk:SendReceiveOnlineGift = oldData as SendReceiveOnlineGift;
			var day:int = pk.DayIndex;
			
			EventSvc.getInstance().initGiftServer2(data, "RetBonus");
			var num:int = EventSvc.getInstance().getGiftServer().length;
			GuiMgr.getInstance().guiGiftEventTeacher.setNumSlot(num);
			GuiMgr.getInstance().guiGiftEventTeacher.Show(Constant.GUI_MIN_LAYER, 5);
			
			oStatus[day] = 2;
			
			var onlineGift:AbstractItemGift = this["onlineGift" + day];
			var imgGift:Image = this["imgGift" + day];
			var imgReceived:Image = this["imgReceived" + day];
			var btnReceive:Button = this["btnReceive" + day];
			imgGift.img.visible = imgReceived.img.visible = true;
			onlineGift.img.visible = btnReceive.img.visible = false;
			inReceive = false;
		}
		private function revertDay(day:int):void 
		{
			inRevert = true;
			var pk:SendRevertDay = new SendRevertDay(day);
			Exchange.GetInstance().Send(pk);
		}
		
		public function processRevertDay(data:Object, oldData:Object):void
		{
			var pk:SendRevertDay = oldData as SendRevertDay;
			_dayOnline = pk.DayIndex;
			updateStatus(data["KeepLogin"]["Status"]);
			updateOnlineGifts(_dayEvent);
			updateDayOnline();
			inRevert = false;
		}
		/**
		 * 
		 * @param	day ngày online
		 */
		private function updateOnlineGifts(day:int):void
		{
			var onlineGift:AbstractItemGift,
				imgGift:Image, imgReceived:Image, imgTick:Image, /*imgMiss:Image,*/
				btnReceive:Button, btnRevert:Button,
				tfRevertPrice:TextField;
			
			for (var i:int = 1; i <= day; i++)
			{
				onlineGift = this["onlineGift" + i];
				imgGift = this["imgGift" + i];
				imgReceived = this["imgReceived" + i];
				imgTick = this["imgTick" + i];							//dau tich the hien so ngay da online
				//imgMiss = this["imgMiss" + i];							//dau x the hien so ngay da miss
				btnReceive = this["btnReceive" + i];
				btnRevert = this["btnRevert" + i];
				tfRevertPrice = this["tfRevertPrice" + i];
				
				onlineGift.img.visible = oStatus[i] != 2;
				imgGift.img.visible = imgReceived.img.visible = oStatus[i] == 2;
				imgTick.img.visible = oStatus[i] >= 1;
				btnReceive.img.visible = oStatus[i] == 1;
				/*imgMiss.img.visible =*/ btnRevert.img.visible = tfRevertPrice.visible = i > _dayOnline;
				if (btnRevert.img.visible)
				{
					btnRevert.SetEnable(i == (_dayOnline + 1));
				}
			}
		}
		override public function ClearComponent():void 
		{
			if (_listOnlineGift != null)
			{
				for (var i:int = 0; i < _listOnlineGift.length; i++)
				{
					var onlineGift:AbstractItemGift = _listOnlineGift[i];
					onlineGift.Destructor();
				}
				_listOnlineGift.splice(0, _listOnlineGift.length);
			}
			super.ClearComponent();
		}
		
	}

}
























