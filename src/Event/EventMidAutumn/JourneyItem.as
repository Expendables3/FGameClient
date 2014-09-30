package Event.EventMidAutumn 
{
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.EventEuro.ItemGiftEuro;
	import GUI.GuiMgr;
	import Logic.FallingObject;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class JourneyItem extends Container 
	{
		public var xPosition:int;//Vị trí làn
		public var yPosition:int;//Vi trí quà
		public var data:Object;
		public var isVIP:Boolean;
		
		public function JourneyItem(parent:Object, imgName:String = "", x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
		}
		
		public function initItem(_data:Object, _isVIP:Boolean = false):void
		{
			isVIP = _isVIP;
			data = _data;
			LoadRes("");
			var itemImage:Image = AddImage("", getImageName(data["ItemType"], data["ItemId"]), 0, 0, true, ALIGN_LEFT_TOP);
			if (data["ItemType"] == "AllChest")
			{
				AddImage("", "ImgLaMa" + data["Rank"], 17, 59).SetScaleXY(0.7);
			}
			if(data["ItemType"] != "DropOfWater" && data["ItemType"] != "Cyclone" && data["ItemType"] != "Disaster")
			{
				var labelNum:TextField = AddLabel("x" + Ultility.StandardNumber(int(data["Num"])), -15, 50, 0xffffff, 1, 0x000000);
				labelNum.autoSize = "center";
				
				itemImage.FitRect(65, 65, new Point(4, 2));
				if(!_isVIP)
				{
					AddImage("", "GuiBackground_Bladder", 0, 0, true, ALIGN_LEFT_TOP);
				}
				else
				{
					AddImage("", "GuiBackground_VipBladder", 0, 0, true, ALIGN_LEFT_TOP);
				}
			}
			else
			{
				itemImage.FitRect(100, 100, new Point( -15, 0));
				if (data["ItemType"] == "DropOfWater")
				{
					if (data["ItemId"] == 1)
					{
						itemImage.SetScaleXY(0.7);
					}
				}
				if (data["ItemType"] == "Disaster")
				{
					itemImage.SetScaleX( -1);
				}
			}
			setTooltipText(getName());
		}
		
		private function getName():String
		{
			switch(data["ItemType"])
			{
				case "AllChest":
					return Localization.getInstance().getString("EventMidAutumn_" + data["ItemType"] + data["Rank"]);
				case "Collection":
					return "Bộ sưu tập trung thu";
				case "Exp":
				case "Money":
					return Localization.getInstance().getString("EventMidAutumn_" + data["ItemType"]);
				case "Speeduper":
				case "Protector":
				case "Magnetic":
				case "Health":
				case "AllChest":
				case "Medal":
				case "Disaster":
				case "DropOfWater":
				case "Cyclone":
					return Localization.getInstance().getString("EventMidAutumn_" + data["ItemType"] + data["ItemId"]);
				default:
					return Localization.getInstance().getString(data["ItemType"] + data["ItemId"]);
			}
			return "";
		}
		
		public function dropGift():void
		{
			SetVisible(false);
			EffectMgr.getInstance().runSwfEff(DisplayObject(Parent), "GuiBackground_BladderBreak", img.x, img.y, null);
			var itemType:String = data["ItemType"];
			var itemId:int = data["ItemId"];
			var num:int = data["Num"];
			var name:String = getImageName(itemType, itemId);
			if (itemType == "Collection")
			{
				name = "EventMidAutumn_Collection" + itemId;
			}
			else
			if (itemType == "Health" || itemType == "Protector" || itemType == "Magnetic" || itemType == "Speeduper")
			{
				return;
			}
			
			var p:Point = new Point(img.x, img.y);
			p = Parent.localToGlobal(p);
			p = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).globalToLocal(p);
			
			var mat:FallingObject;
			var waitTime:Number = 0;
			var fallArr:Array = GameLogic.getInstance().user.fallingObjArr;
			for (var i:int = 0; i < num; i++) 
			{
				//if (itemType == "AllChest")
				//{
					//trace("num", num);
					//trace("id", GameLogic.getInstance().user.GetMyInfo().AutoId);
					//GameLogic.getInstance().user.GenerateNextID();
				//}
				mat = new  FallingObject(LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER), name, p.x, p.y);
				mat.stayInLake = false;
				waitTime = 1;
				mat.setWaitingTime(waitTime);
				mat.ItemType = itemType;
				mat.ItemId = itemId;
				mat.getDesToFly = function():Point
				{
					var pos:Point = GuiMgr.getInstance().guiBackGround.GetButton(GUIBackGround.BTN_STORE).GetPos();
					pos = GuiMgr.getInstance().guiBackGround.img.localToGlobal(pos);
					pos = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).globalToLocal(pos);
					return pos;
				}
				fallArr.push(mat);
				if (itemType == "Exp" || itemType == "Money" || itemType == "RankPointBottle")
				{
					mat.completeFly = function f():void
					{
						if(mat.img != null)
						{
							EffectMgr.getInstance().textFly("+ " + Ultility.StandardNumber(num), new Point(mat.img.x-5, mat.img.y-10), new TextFormat("arial", 18, 0xffff00, true));
						}
					}
					break;
				}
			}	
		}
		
		private function getImageName(itemType:String, itemId:int):String
		{
			switch(itemType)
			{
				case "Speeduper":
					return "GuiBackground_Speeduper";
				case "Protector":
					return "GuiBackground_Protector";
				case "Magnetic":
					return "GuiBackground_Magnetic";
				case "Health":
					return "GuiBackground_Health";
				case "AllChest":
					return "AllChest4_AllChest";
				case "Collection":
					return "GuiBackground_Collection";
				case "Medal":
					return "GuiBackground_Medal";
				case "Disaster":
					return "GuiBackground_Cow";
				case "DropOfWater":
					return "GuiBackground_DarkCloud";
				case "Cyclone":
					return "GuiBackground_Weight" + itemId;
				case "Material":
					return Ultility.GetNameMatFromType(itemId);
				case "Exp":
					return "IcExp";
				case "Money":
					return "IcGold";
				case "PowerTinh":
					return itemType;
				case "EquipmentChest":
					return "TrunkEquipment" + data["Color"];
				case "JewelChest":
					return "TrunkJewel" + data["Color"];
				case "Seal":
					return "Seal2_Shop";
				case "SetEquipment":
				case "FullSet":
					return "TrunkEquipment" + data["Color"];
				default:
					return itemType + itemId;
			}
			return "";
		}
	}

}