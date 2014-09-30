package Event.TreasureIsland 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUICollectionTreasure extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_CHANGE:String = "BtnChange";
		public const BTN_GIFT:String = "BtnGift";
		private var collectionList:Array;
		public function GUICollectionTreasure(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUICollectionTreasure";
		}
		
		override public function InitGUI():void 
		{
			SetPos(30, 10);
			LoadRes("GUICollectionTreasure");
			addCollection();
		}
		private var config:Object;
		private var arrNumTxt:Array;
		private function addCollection():void 
		{
			ClearComponent();
			AddButton(BTN_CLOSE, "BtnThoat", 705, 20, this);
			config = ConfigJSON.getInstance().getItemInfo("IsLand_Collection");
			var tooltip:TooltipFormat;
			var itemId:int;
			var itemImg:ButtonEx;
			var numTxt:TextField;
			arrNumTxt = [];
			var n1:int;
			var n2:int;
			for (var i:int = 1; i <= 3; i++ )
			{
				for (var j:int = 1; j <= 5; j++ )
				{
					if (config[i]["Input"].hasOwnProperty(j.toString()))
					{
						tooltip = new TooltipFormat();
						itemId = config[i]["Input"][j]["ItemId"];
						itemImg = AddButtonEx("", "IslandItem" + itemId, 30 + 83 * j, 170 * i);
						tooltip.text = Localization.getInstance().getString("Island_Item" + config[i]["Input"][j]["ItemId"]);
						itemImg.setTooltip(tooltip);
						itemImg.SetScaleXY(1.5);
						n1 = collectionList[itemId];
						n2 = config[i]["Input"][j]["Num"];
						numTxt = AddLabel((String)(n1 + "/" + n2), -25 + 85 * j, 30 + 166 * i);
						if (n1 < n2)	numTxt.setTextFormat(new TextFormat("arial", 13, 0xFF0000));
						else	numTxt.setTextFormat(new TextFormat("arial", 13, 0x00FF00));
					}
					arrNumTxt.push(numTxt);
				}
				var ctn:Container = new Container(img, "LandBg", 600, -10 + 170 * i);
				var obj:Object = config[i]["Gift"]["1"];
				var item:Image;
				switch (obj["ItemType"])
				{
					case "Material":
						item = ctn.AddImage("", obj["ItemType"] + obj["ItemId"], 10, 20);
						item.SetScaleXY(1.5);
						tooltip = new TooltipFormat();
						tooltip.text = "Ngư thạch cấp " + obj["ItemId"];
						ctn.AddLabel("x" + Ultility.StandardNumber(obj["Num"]), -30, 25, 0xFFFF00, 1, 0x717100);
						break;
					case "RankPointBottle":
						item = ctn.AddImage("", obj["ItemType"] + obj["ItemId"], -10, 0);
						tooltip = new TooltipFormat();
						tooltip.text = Localization.getInstance().getString(obj["ItemType"] + obj["ItemId"]);
						ctn.AddLabel("x" + Ultility.StandardNumber(obj["Num"]), -30, 25, 0xFFFF00, 1, 0x717100);
						break;
					case "Weapon":
						item = ctn.AddImage("", "GuiCollection_" + obj["ItemType"] + "_Trunk_" + obj["Color"], -10, 0);
						ctn.AddImage("", "ImgLaMa" + obj["Rank"], -40, 40);
						tooltip = new TooltipFormat();
						tooltip.text = "Thần Bảo Rương\nNgẫu nhiên nhận được vũ khí Phượng Hoàng Thần";
						ctn.AddLabel("x" + Ultility.StandardNumber(obj["Num"]), -30, 25, 0xFFFF00, 1, 0x717100);
						break;
				}
				ctn.setTooltip(tooltip);
				AddButton(BTN_CHANGE + "_" + i, "BtnChange", 565, 40 + 170 * i);
			}
			setBtnChange();
		}
		
		private function setBtnChange():void
		{
			var i:int;
			var isEnable:Boolean;
			for (i = 1; i <= 3; i++)
			{
				isEnable = true;
				for (var j:int = 1; j <= 5; j++ )
				{
					if (config[i]["Input"].hasOwnProperty(j))
					{
						var itemId:int = config[i]["Input"][j]["ItemId"];
						isEnable = isEnable && (collectionList[itemId] >= config[i]["Input"][j]["Num"]);
					}
				}
				GetButton(BTN_CHANGE + "_" + i).SetEnable(isEnable);
			}
		}
		
		public function ShowGUI(cList:Array):void
		{
			collectionList = cList;
			super.Show(Constant.GUI_MIN_LAYER, 3);
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
					changeCollection(id);
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch (command) 
			{
				case BTN_GIFT:
					//Show gui Gift
					GuiMgr.getInstance().guiCollectionGiftToolTip.showGUI(id);
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
					GuiMgr.getInstance().guiCollectionGiftToolTip.Hide();
					break;
			}
		}
		
		private function changeCollection(id:int):void 
		{
			var pk:SendChangeCollection = new SendChangeCollection(id);
			Exchange.GetInstance().Send(pk);
			for (var i:int = 1; i <= 5; i++ )
			{
				if (!config[id]["Input"].hasOwnProperty(i.toString())) break;
				var itemId:int = config[id]["Input"][i]["ItemId"];
				collectionList[itemId] -= config[id]["Input"][i]["Num"];
			}
			drawNumTxt();
			setBtnChange();
		}
		
		private function drawNumTxt():void 
		{
			var n1:int;
			var n2:int;
			for (var i:int = 0; i < arrNumTxt.length; i++)
			{
				if (arrNumTxt[i] == null)	continue;
				var r:int = i / 5 + 1;
				var c:int = i % 5 + 1;
				if (config[r]["Input"].hasOwnProperty(c))
				{
					var itemId:int = config[r]["Input"][c]["ItemId"];
					n1 = collectionList[itemId];
					n2 = config[r]["Input"][c]["Num"];
					(arrNumTxt[i] as TextField).text = n1 + "/" + n2;
					if (n1 < n2)	(arrNumTxt[i] as TextField).setTextFormat(new TextFormat("arial", 13, 0xff0000));
					else	(arrNumTxt[i] as TextField).setTextFormat(new TextFormat("arial", 13, 0x00ff00));
				}
			}
		}
	}

}