package Event.EventHalloween.HalloweenGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.EventHalloween.HalloweenPackage.SendFinishAuto;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiFinishAuto extends BaseGUI 
	{
		static public const CMD_CLOSE:String = "cmdClose";
		static public const CMD_COMPLETE:String = "cmdComplete";
		
		private var _listGift:Array;
		
		public function GuiFinishAuto(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiFinishAuto";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(CMD_CLOSE, "BtnThoat", 705 , 20);
				var fm:TextFormat = new TextFormat("Arial", 16);
				AddButton(CMD_COMPLETE + "_ZMoney_2", "GuiFinishAuto_BtnComplete", 143, 518);
				
				var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["AutoUnlock"][2]["ZMoney"];
				var tfPrice:TextField = AddLabel("", 145, 523, 0xffffff, 1, 0x000000);
				tfPrice.defaultTextFormat = fm;
				tfPrice.text = Ultility.StandardNumber(price);
				AddButton(CMD_COMPLETE + "_ZMoney_1", "GuiFinishAuto_BtnComplete", 488, 518);
				price = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["AutoUnlock"][1]["ZMoney"];
				tfPrice = AddLabel("", 490, 523, 0xffffff, 1, 0x000000);
				tfPrice.defaultTextFormat = fm;
				tfPrice.text = Ultility.StandardNumber(price);
				freeListGift();
				var x:int = 47, y:int = 220;
				for (var i:int = 2; i >= 1; i--)
				{
					initGift(i, x, y);
					x += 346;
				}
			}
			LoadRes("GuiFinishAuto_Theme");
		}
		
		private function initGift(kind:int, x:int, y:int):void 
		{
			var line:Array = [];
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("Hal2012_AutoMap")[kind.toString()];
			var obj:Object;
			var gift:AbstractGift;
			var itGift:AbstractItemGift;
			var count:int = 0;
			var x0:int = x;
			var tfMin:TextField;
			for (var s:String in cfg)
			{
				for (var i:String in cfg[s])
				{
					count++;
					obj = cfg[s][i];
					if (obj["Num"] is Array)
					{
						obj["Min"] = obj["Num"][0];
						obj["Max"] = obj["Num"][obj["Num"].length - 1];
					}
					else
					{
						obj["Min"] = obj["Num"];
					}
					if (obj["ItemType"] == "EquipmentChest" || obj["ItemType"] == "AllChest" || obj["ItemType"] == "Ring")
					{
						gift = new GiftSpecial();
						gift.setInfo(obj);
						gift["ItemType"] = obj["ItemType"];
						(gift as GiftSpecial).Source = 6;
						itGift = new ItemSpecialGift(this.img, "KhungFriend", x, y);
						itGift.initData(gift, "", 75, 78, false);
						itGift.hasTooltipImg = false;
						itGift.drawGift();
						itGift.SetScaleX(65 / 75);
						itGift.SetScaleY(68 / 78);
						itGift.img.x += 9;
						itGift.img.y += 13;
						itGift.setTooltipText(Localization.getInstance().getString("EventHalloween_Tip" + obj["ItemType"] + obj["Rank"]));
						tfMin = itGift.AddLabel(Ultility.StandardNumber(obj["Min"]), -15, 60, 0xffffff, 1, 0x000000);
					}
					else
					{
						gift = new GiftNormal();
						gift.setInfo(obj);
						itGift = new ItemNormalGift(this.img, "KhungFriend", x, y);
						itGift["yNum"] = 60;
						itGift.initData(gift, "", 75, 78, false);
						itGift["hasNum"] = false;
						itGift.drawGift();
						tfMin = itGift.AddLabel(Ultility.StandardNumber(obj["Min"]), -25, 60, 0xffffff, 1, 0x000000);
						if (obj["Num"] is Array)
						{
							if (tfMin.width > 40)
							{
								var str:String = tfMin.text + " ~ ";
								tfMin.text = str;
								tfMin.x = 4; tfMin.y = 50;
								itGift.AddLabel(Ultility.StandardNumber(obj["Max"]), -15, 47 + tfMin.height, 0xffffff, 1, 0x000000);
							}
							else
							{
								itGift.AddLabel(" ~ " + Ultility.StandardNumber(obj["Max"]), -25+tfMin.width+3, 60, 0xffffff, 1, 0x000000);
							}
						}
						else
						{
							tfMin.x += 10;
						}
					}
					line.push(itGift);
					x += 75;
					if (count % 4 == 0)
					{
						x = x0;
						y += 88;
					}
				}
			}
			_listGift.push(line);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			
			switch(cmd)
			{
				case CMD_CLOSE:
					Hide();
					break;
				case CMD_COMPLETE:
					var priceType:String = data[1];
					var kind:int = int(data[2]);
					var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["AutoUnlock"][kind.toString()]["ZMoney"];
					if (Ultility.payMoney(priceType, price))
					{
						var pk:SendFinishAuto = new SendFinishAuto(priceType, kind);
						Exchange.GetInstance().Send(pk);
					}
					break;
			}
		}
		
		private function freeListGift():void 
		{
			if (_listGift == null)
			{
				_listGift = [];
				return;
			}
			if (_listGift.length == 0)
			{
				return;
			}
			var itGift:AbstractItemGift;
			for (var s:String in _listGift)
			{
				for (var i:String in _listGift[s])
				{
					itGift = _listGift[s][i];
					itGift.Destructor();
				}
				_listGift[s].splice(0, _listGift[s].length);
				_listGift[s] = null;
			}
			_listGift.splice(0, _listGift.length);
		}
		
		override public function ClearComponent():void 
		{
			freeListGift();
			super.ClearComponent();
		}
	}

}
















