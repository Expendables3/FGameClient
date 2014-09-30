package Event.TreasureIsland 
{
	import Data.Config;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.Event8March.GUIChooseElementEvent;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIChangeMedalVIP extends BaseGUI 
	{
		public const BTN_CHANGE:String = "BtnChange";
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_GIFT:String = "BtnGift";
		public var medalNum:int;
		public function GUIChangeMedalVIP(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChangeMedalVIP";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("GUITreasureIslandChangeMedal");
			SetPos(130, 90);
			var txt:TextField = AddLabel(medalNum.toString(), 280, 105, 0xF9F900, 1, 0x000000);
			var format:TextFormat = new TextFormat("arial", 16);
			txt.setTextFormat(format);
			AddButton(BTN_CLOSE, "BtnThoat", 540, 20, this);
			var config:Object = ConfigJSON.getInstance().getItemInfo("Island_GiftMedal");
			for (var i:int = 1; i <= 3; i++ )
			{
				var ctnGift:Container = AddContainer(BTN_GIFT + "_" + i, config[i]["Gift"]["1"]["ItemType"] + config[i]["Gift"]["1"]["Rank"] + "_Shop", 100 + 150 * (i - 1), 180, true, this);
				ctnGift.SetScaleXY(1.5);
				var numRequire:TextField = AddLabel(config[i]["MedalRequire"], 60 + 160 * (i - 1), 300, 0xF9F900, 1, 0x000000);
				numRequire.setTextFormat(format);
				var btn:Button = AddButton(BTN_CHANGE + "_" + i, "BtnReceiveGiftChangeMedal", 95 + 160 * (i - 1), 340, this);
				if (config[i]["MedalRequire"] > medalNum) btn.SetDisable();
			}
			/*setImgInfo = function f():void
			{
				SetPos(130, 90);
				medalNum = GameLogic.getInstance().numMedalHalloween;
				var txt:TextField = AddLabel(Ultility.StandardNumber(medalNum), 280, 105, 0xF9F900, 1, 0x000000);
				var format:TextFormat = new TextFormat("arial", 16);
				txt.setTextFormat(format);
				AddButton(BTN_CLOSE, "BtnThoat", 540, 20, this);
				var config:Object = ConfigJSON.getInstance().getItemInfo("Hal2012_GiftMedal");
				var tooltip:String = "";
				var itGift:AbstractItemGift;
				var oGift:AbstractGift;
				for (var i:int = 1; i <= 3; i++ )
				{
					var obj:Object = config[i]["Gift"]["1"];
					
					var giftName:String;
					switch(i)
					{
						case 1:
							giftName = "GuiCollection_" + "Weapon" + "_Trunk_" + obj["Color"];//"AllChest" + obj["Color"] + "_AllChest";
							tooltip = "Vũ Khí Thần cấp " + obj["Rank"];
							break;
						case 2:
							giftName = Ultility.GetNameMatFromType(obj["ItemId"]);
							tooltip = Localization.getInstance().getString(obj["ItemType"] + obj["ItemId"]);
							break;
						case 3:
							giftName = "Weapon504_Shop";
							tooltip = "Vũ Khí VIP cấp 4";
							break;
					}
					
					var ctnGift:Container = AddContainer(BTN_GIFT + "_" + i, giftName, 100 + 150 * (i - 1), 180, true, this);
					ctnGift.SetScaleXY(1.5);
					ctnGift.FitRect(110, 110, new Point(75 + 150 * (i - 1), 180));
					//if (i != 3)
					//{
						ctnGift.setTooltipText(tooltip);
					//}
					if(i == 1)
					{
						ctnGift.AddImage("", "ImgLaMa" + obj["Rank"], 10, 83);
					}
					var numRequire:TextField = AddLabel(config[i]["MedalRequire"], 80 + 160 * (i - 1), 313, 0xF9F900, 1, 0x000000);
					numRequire.setTextFormat(format);
					var btn:Button = AddButton(BTN_CHANGE + "_" + i, "GuiHalloweenMedal_BtnChange", 95 + 160 * (i - 1), 340, this);
					if (config[i]["MedalRequire"] > medalNum) btn.SetDisable();
				}
			}
			LoadRes("GuiHalloweenMedal_Theme");*/
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch (command) 
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_CHANGE:
					var cmd:SendChangeMedalVip = new SendChangeMedalVip(id);
					Exchange.GetInstance().Send(cmd);
					var config:Object = ConfigJSON.getInstance().getItemInfo("Hal2012_GiftMedal");
					medalNum -= config[id]["MedalRequire"];
					GameLogic.getInstance().numMedalHalloween -= int(config[id]["MedalRequire"]);
					GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", 14, -config[id]["MedalRequire"]);
					break;
			}
		}
		private var seal:FishEquipment;
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch (command) 
			{
				case BTN_GIFT:
					//Show gui Gift
					if(GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					//var config:Object = ConfigJSON.getInstance().getItemInfo("Hal2012_GiftMedal");
					var config:Object = ConfigJSON.getInstance().getItemInfo("Island_GiftMedal");
					var seal:FishEquipment = new FishEquipment();
					seal.Color = config[id]["Gift"]["1"]["Color"];
					seal.Type = config[id]["Gift"]["1"]["ItemType"];
					if (config[id]["Gift"]["1"].hasOwnProperty("Rank"))
						seal.Rank = config[id]["Gift"]["1"]["Rank"];
					else
						seal.Rank = config[id]["Gift"]["1"]["ItemId"];
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, seal, GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null);
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch (command) 
			{
				case BTN_GIFT:
					//Hide gui Gift
					if(GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
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
	}

}