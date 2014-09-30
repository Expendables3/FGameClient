package Event.EventHalloween.HalloweenGui.ItemGui
{
	import Data.ConfigJSON;
	import Event.EventHalloween.HalloweenLogic.ItemHalloweenInfo;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.GuiBuyAbstract.BuyItemSvc;
	import GUI.GuiBuyAbstract.SendBuyAbstract;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiBuyContinue extends BaseGUI
	{
		static public const CMD_CLOSE:String = "cmdClose";
		static public const CMD_BUY:String = "cmdBuy";
		static public const CMD_RECEIVE:String = "cmdReceive";
		
		[Embed(source='../../../../../content/dataloading.swf',symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		private var _listItemInfo:Array = [];
		private var IsDataReady:Boolean = false;
		public var numPack:int;
		
		public function GuiBuyContinue(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiBuyContinue";
			BuyItemSvc.getInstance().UrlBuyAPI = "EventService.hal_buyItem";
			BuyItemSvc.getInstance().IdBuyAPI = Constant.CMD_BUY_PACK_HALLOWEEN;
		}
		
		private function initData(data:Object):void
		{
			if (data["Pack"] != null)
			{
				_listItemInfo = data["Pack"];
			}
		}
		
		override public function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				IsDataReady = false;
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(CMD_CLOSE, "BtnThoat", 690, 41);
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 10;
				WaitData.y = img.height / 2 - 10;
				var pk:SendBuyAbstract = new SendBuyAbstract("EventService.hal_buyItem", Constant.CMD_BUY_PACK_HALLOWEEN, "BuyPack", 1, numPack, "ZMoney");
				Exchange.GetInstance().Send(pk);
				OpenRoomOut();
			}
			LoadRes("GuiBuyContinue_Theme");
		}
		
		private function initItemRock():void
		{
			if (_listItemInfo != null)
			{
				var x:int = 95, y:int = 140;
				var id:int;
				var obj:Object;
				var tfNum:TextField;
				var num:int;
				for (var i:int = 0; i < _listItemInfo.length; i++)
				{
					obj = _listItemInfo[i];
					AddImage("", "GuiBuyContinue_ImgSlot", x, y, true, ALIGN_LEFT_TOP);
					id = obj["ItemId"];
					AddImage("", "GuiHalloween_HalItem" + id, x + 42, y + 45);
					tfNum = AddLabel("", x - 10, y + 65, 0xffffff, 1, 0x000000);
					num = obj["Num"];
					tfNum.text = "x" + Ultility.StandardNumber(num);
					x += 93;
					if (i == 5)
					{
						x = 95;
						y += 107;
					}
				}
			}
		}
		
		override public function OnHideGUI():void
		{
			var info:ItemHalloweenInfo;
			for (var i:int = 0; i < _listItemInfo.length; i++)
			{
				_listItemInfo[i] = null;
			}
			_listItemInfo.splice(0, _listItemInfo.length);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch (cmd)
			{
				case CMD_CLOSE: 
				case CMD_RECEIVE:
					GuiMgr.getInstance().guiHalloween.inBuyPack = false;
					Hide();
					break;
				case CMD_BUY: 
					var type:String = data[1];
					var id:int = data[2];
					var price:int = int(data[3]);
					var priceType:String = data[4];
					if (Ultility.payMoney(priceType, price)) //có thể mua
					{
						Hide();
						Show(Constant.GUI_MIN_LAYER, 5);
						GuiMgr.getInstance().guiHalloween.inBuyPack = true;
					}
					break;
				
			}
		}
		
		public function processData(data1:Object):void
		{
			initData(data1);
			IsDataReady = true;
			if (IsFinishRoomOut)
			{
				initGui();
			}
		}
		
		override public function EndingRoomOut():void
		{
			if (IsDataReady)
			{
				initGui();
			}
		}
		
		private function initGui():void
		{
			if (img == null) //nếu đã hide gui
			{
				return;
			}
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			AddButton(CMD_RECEIVE, "BtnNhanThuong", 300, 380);
			//var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["BuyKey"]["ZMoney"];
			//AddButton(CMD_BUY + "_BuyPack_1_" + price + "_ZMoney", "GuiBuyContinue_BtnBuyZMoney", 300, 380);
			//AddLabel(Ultility.StandardNumber(price), 330, 387, 0xffffff, 1, 0x000000);
			initItemRock();
		}
	}

}

