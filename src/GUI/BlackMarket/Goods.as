package GUI.BlackMarket 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.TrungLinhThach.GUILinhThachToolTip;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.Ultility;
	
	/**
	 * Lớp hàng trong kho
	 * @author dongtq
	 */
	public class Goods extends Container 
	{
		private var labelNum:TextField;
		public var data:Object;
		public var imageGoods:Image;
		private var _num:int;
		public var tabType:String;
		
		public function Goods(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function initGoods(_tabType:String, objData:Object):void
		{
			//trace("------------------------initGoods()");
			tabType = _tabType;
			var imageName:String;
			var numItem:int = 0;
			var level:int = 0;
			switch(tabType)
			{
				
				case GUISell.BTN_TAB_EQUIP:
				case GUISell.BTN_TAB_JEWEL:
					toBmp = true;
					if (int(objData["Color"]) == FishEquipment.FISH_EQUIP_COLOR_WHITE)
					{
						LoadRes("ItemMarket_Bg");
					}
					else
					{
						LoadRes(FishEquipment.GetBackgroundName(int(objData["Color"])));
					}
					imageName = FishEquipment.GetEquipmentName(objData["Type"], objData["Rank"], objData["Color"])  + "_Shop";
					level = objData.EnchantLevel;
					break;
				case GUISell.BTN_TAB_OTHER:
					LoadRes("ItemMarket_Bg");
					
					switch(objData["Type"])
					{
						case "Material":
							imageName = Ultility.GetNameMatFromType(objData["ItemId"]);
							labelNum = AddLabel("xNum", - 35, 55, 0xffffff, 2, 0x000000); 
							var txtFormat:TextFormat = new TextFormat("arial", 17, 0xffffff, true);
							labelNum.defaultTextFormat = txtFormat;
							numItem = int(objData["Num"]);
						break;
						case "QWhite":
						case "QGreen":
						case "QYellow":
						case "QPurple":
						case "QVIP":
							imageName = objData["Type"] + objData["ItemId"];
							level = objData["Level"];
							break;
					}
					//trace("GUISell.BTN_TAB_OTHER imageName== " + imageName);
					break;
				case GUISell.BTN_TAB_FISH:
					LoadRes("ItemMarket_Bg");
					
					var st:String;
					var name:String;
					var money:String;
					var exp:String;
					var tooltip:TooltipFormat = new TooltipFormat();
					var fmt:TextFormat = new TextFormat("arial", 14, 0x000000, true);
					fmt.align = TextFormatAlign.CENTER;
					fmt.size = 14;
					fmt.bold = true;
					if(objData["FishType"] == Fish.FISHTYPE_SOLDIER)
					{
						imageName = "Fish" + objData["FishTypeId"] + "_Old_Idle";
						
						name = Localization.getInstance().getString("Fish" + objData["FishTypeId"]);	
						money = "Lực chiến: " + objData["Damage"];
						exp = "Danh hiệu: " + Localization.getInstance().getString("FishSoldierRank" + objData["Rank"]);
						exp += "\nSố sao: " + Ultility.getStarByReceiptType(objData["RecipeType"]["ItemType"]);
						st = name + "\n" + money + "\n" + exp;
					}
					else
					{
						imageName = objData["Type"];
						
						var obj:Object = ConfigJSON.getInstance().GetItemList("SuperFish");
						var objFishSpecial:Object = obj[objData["Type"]];
						name = Localization.getInstance().getString(objData["Type"]);					
						money = "Tiền: " + objFishSpecial["Active"]["Money"];
						exp = "EXP: " + objFishSpecial["Active"]["Exp"];
						st = name + "\n" + money + "\n" + exp;
						var s: String;
						
						for (s in objData["Option"])
						{
							st += "\n" + OptionTooltip(s) + objData["Option"][s] + "%";
						}
					}
					fmt.color = "0xff33ff";
					tooltip.text = st;
					tooltip.setTextFormat(fmt, 0, name.length);
					fmt.size = 12;
					fmt.bold = false;
					fmt.color = "0x000000";
					tooltip.setTextFormat(fmt, name.length, tooltip.text.length);					
					setTooltip(tooltip);
					break;
					
			}
			imageGoods = AddImage("", imageName, 0, 0, true, Image.ALIGN_CENTER_CENTER, false, function f():void
			{
				if (objData["Color"] != null)
				{
					FishSoldier.EquipmentEffect(this.img, objData["Color"]);
					if (objData["Color"] == 6)
					{
						AddImage("", "IcMax", 83 - 6, 43 - 14).SetScaleXY(0.7);
					}
				}
			});
			imageGoods.FitRect(70, 70, new Point(0, 0));
			img.buttonMode = true;
			data = objData;
			if (numItem != 0)
			{
				num = numItem;
			}
			if (level > 0)
			{
				var txt:TextField = AddLabel("+" + level, 2, 2, 0xFFF100, 0, 0x603813);
				txt.setTextFormat(new TextFormat("arial", 18, 0xffff00, true));
			}
			
			var rect:Sprite = new Sprite();
			rect.graphics.beginFill(0xffffff, 0);
			rect.graphics.drawRect(0, 0, 70, 70);
			rect.graphics.endFill();
			rect.x = 0;
			rect.y = 0;
			img.addChild(rect);
			rect.doubleClickEnabled = true;
			rect.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickButton);
		}
		
		private function onDoubleClickButton(e:MouseEvent):void 
		{
			GUISell(EventHandler).onDoubleClick(e, IdObject);
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			if (labelNum)
			{
				labelNum.text = "x" + Ultility.StandardNumber(value);
				img.setChildIndex(labelNum, img.numChildren -1);
			}
		}
		
		private function OptionTooltip(option: String): String
		{
			switch(option)
			{
				case "Time":
					return "Giảm thời gian: ";
				case "Money":
					return "Tăng tiền: ";
				case "Exp":
					return "Tăng exp: ";
				case "MixFish":
					return "Tăng lai ra cá quý: ";					
				case "MixSpecial":
					return "Tăng lai ra cá đặc biệt: "
				default:
					return option;
			}
		}
	}

}