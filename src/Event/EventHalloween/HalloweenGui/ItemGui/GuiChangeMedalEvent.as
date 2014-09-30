package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.TreasureIsland.SendChangeMedalVip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
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
	public class GuiChangeMedalEvent extends BaseGUI 
	{
		public var medalNum:int;
		public const BTN_CHANGE:String = "BtnChange";
		static public const BTN_CLOSE:String = "btnClose";
		public var _listItemGift:Array = [];
		private var btnReceive1:Button;
		private var btnReceive2:Button;
		private var btnReceive3:Button;
		public function GuiChangeMedalEvent(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiChangeMedalEvent";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				medalNum = GameLogic.getInstance().numMedalHalloween;
				var tfNum:TextField = AddLabel("", 280, 105, 0xF9F900, 1, 0x000000);
				var fm:TextFormat = new TextFormat("Arial", 16); fm.color = 0xF9F900;
				tfNum.defaultTextFormat = fm;
				tfNum.text = Ultility.StandardNumber(medalNum);
				AddButton(BTN_CLOSE, "BtnThoat", 540, 20);
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("Hal2012_GiftMedal");
				var itGift:AbstractItemGift;
				var oGift:AbstractGift;
				var temp:Object;
				var kind:int;
				var x:int = 83, y:int = 188;
				var numRequired:int; var tfNumRequired:TextField;
				var btnReceive:Button;
				var tip:Array = [
									Localization.getInstance().getString("EventHalloween_TipEquipmentChest4"), 
									"Ngư thạch cấp 12", 
									"Vũ khí VIP cấp 4"
								];
				var hasTipSpecial:Boolean = false;
				for (var i:int = 1; i <= 3; i++)
				{
					if (i == 3)
					{
						var imgCtnVip:ButtonEx = AddButtonEx("", "CtnEquipmentVip", x - 10, y);
						imgCtnVip.img.buttonMode = false;
						imgCtnVip.SetScaleXY(1.2);
						var imgVip:ButtonEx = AddButtonEx("", "GuiHalloweenMedal_ImgVipWeapon", x - 13, y - 5);
						imgVip.SetScaleXY(0.8);
						imgVip.img.buttonMode = false;
						imgVip.setTooltipText("Vũ khí VIP cấp 4\nĐược chọn hệ");
					}
					else
					{
						hasTipSpecial = false;
						temp = cfg[i]["Gift"]["1"];
						kind = Ultility.categoriesGift(temp["ItemType"]);
						if (kind == 0)
						{
							oGift = new GiftNormal();
							itGift = new ItemNormalGift(this.img, "KhungFriend", x, y);
						}
						else if(kind==1)
						{
							hasTipSpecial = true;
							oGift = new GiftSpecial();
							itGift = new ItemSpecialGift(this.img, "KhungFriend", x + 10, y + 10);
							itGift.hasTooltipImg = false;
							(oGift as GiftSpecial).Source = 6;
						}
						oGift.setInfo(temp);
						itGift.initData(oGift, "", 75, 78, false);
						itGift.drawGift();
						if (hasTipSpecial)
						{
							itGift.setTooltipText(tip[i - 1]);
						}
						_listItemGift.push(itGift);
					}
					
					//nút nhận
					this["btnReceive" + i] = AddButton(BTN_CHANGE + "_" + i, "GuiHalloweenMedal_BtnChange", x + 8, y + 155);
					
					//số lượng yêu cầu
					numRequired = cfg[i]["MedalRequire"];
					this["btnReceive" + i].SetEnable(medalNum >= numRequired);
					tfNumRequired = AddLabel("", x - 10, y + 124, 0xF9F900, 1, 0x000000);
					tfNumRequired.defaultTextFormat = fm;
					tfNumRequired.text = Ultility.StandardNumber(numRequired);
					x += 160;
				}
			}
			LoadRes("GuiHalloweenMedal_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var id:int = (int)(data[1]);
			switch(cmd)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_CHANGE:
					var config:Object = ConfigJSON.getInstance().getItemInfo("Hal2012_GiftMedal");
					if (id == 1 || id == 2)
					{
						var pk:SendChangeMedalVip = new SendChangeMedalVip(id);
						Exchange.GetInstance().Send(pk);
						medalNum -= config[id]["MedalRequire"];
						GameLogic.getInstance().numMedalHalloween -= int(config[id]["MedalRequire"]);
					}
					else if (id == 3)
					{
						GuiMgr.getInstance().guiChooseElementHalloween.numMedalRequire = config[id]["MedalRequire"];
						GuiMgr.getInstance().guiChooseElementHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					}
					break;
			}
		}
		
		public function processChangeMedal(data1:Object):void 
		{
			var medalGift:Array = [];
			var s:String;
			if (data1["Normal"] as Object)
			{
				for (s in data1["Normal"])
				{
					medalGift.push(data1["Normal"][s]);
				}
			}
			if (data1["Equipment"] as Object)
			{
				for (s in data1["Equipment"])
				{
					medalGift.push(data1["Equipment"][s]);
				}
			}
			GuiMgr.getInstance().guiReceiveGiftChangeMedal.showGui(medalGift);
			Hide();
		}
		
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < _listItemGift.length; i++)
			{
				var itGift:AbstractItemGift = _listItemGift[i];
				itGift.Destructor();
			}
			_listItemGift.splice(0, _listItemGift.length);
			super.ClearComponent();
		}
	}

}




















