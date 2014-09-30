package GUI.FishWorld 
{
	import Data.ConfigJSON;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import GUI.FishWorld.GUIMixFormulaInfo;
	import Logic.Fish;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUITooltipMainWorld extends GUIToolTip 
	{
		public var Fish_1:Object;
		public var Fish_2:Object;		// object chứa fishType và FishTypeId của cá cần
		public var FishTypeId:int;		// FishTypeId của cá
		public var Rank:int;				// Lon của con cá được lai ra
		public var SuccessPercent:int	// Tỷ lệ lai thành công 20%
		public var Elements:int;
		public var Id:int;
		public var type:String;
		public var ArrRank:Array = ["Binh nhì", "Binh nhất", "Hạ sĩ", "Trung sĩ", "Thượng sĩ", 
									"Thiếu úy", "Trung úy", "Thượng úy", "Đại úy",
									"Thiếu tá", "Trung tá", "Thượng tá", "Đại tá",
									"Thiếu tướng", "Trung tướng", "Thượng tướng", "Đại tướng"]
		
		public const FISH_1:String = "Fish1";
		public const FISH_2:String = "Fish2";
		public const FISH_SOLDIER:String = "FishSoldier";
		public const ELEMENT_FISH_SOLDIER:String = "FishSoldier";
		
		public function GUITooltipMainWorld(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			this.ClassName = "GUITooltipMainWorld";
		}
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes(imgNameBg);
			var strNameFish:String;
			var sizeConFish:int = 60;
			var obj:Object;
			var txtLevelFish1:TextField;
			var txtLevelFish2:TextField;
			
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.align = "left";
			format.color = 0xFFFFFF;
			
			// Con cá thứ nhất
			strNameFish = "Fish" + Fish_1["FishTypeId"] + "_" + Fish.OLD + "_" + Fish.IDLE;
			var conFish1:Container = AddContainer(FISH_1, "CtnFish", 51 - deltaX, 40 - deltaY);
			var imgFish1:Image = conFish1.AddImage(FISH_1, strNameFish, 56, 69);
			imgFish1.FitRect(sizeConFish, sizeConFish, new Point(0, 0));
			obj = ConfigJSON.getInstance().getItemInfo("Fish", Fish_1["FishTypeId"]);
			txtLevelFish1 = conFish1.AddLabel(obj["LevelRequire"].toString(), 0, -20);
			txtLevelFish1.setTextFormat(format);
			
			// Con cá thứ 2
			strNameFish = "Fish" + Fish_2["FishTypeId"] + "_" + Fish.OLD + "_" + Fish.IDLE;
			var conFish2:Container = AddContainer(FISH_2, "CtnFish", 160 - deltaX, 40 - deltaY);
			var imgFish2:Image = conFish2.AddImage(FISH_2, strNameFish, conFish2.img.width / 2, conFish2.img.height / 2);
			//var imgFish2:Image = AddImage(FISH_2, strNameFish, 165, 69);
			imgFish2.FitRect(sizeConFish, sizeConFish, new Point(0, 0));
			obj = ConfigJSON.getInstance().getItemInfo("Fish", Fish_2["FishTypeId"]);
			txtLevelFish2 = conFish2.AddLabel(obj["LevelRequire"].toString(), 0, -20);
			txtLevelFish2.setTextFormat(format);
			
			// Con cá kết quả
			strNameFish = "Fish" + FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
			var conFish3:Container = AddContainer(FISH_2, "CtnFishSoldier", 270 - deltaX, 40 - deltaY);
			var imgFish3:Image = conFish3.AddImage(FISH_SOLDIER, strNameFish, 0, 0);
			imgFish3.FitRect(sizeConFish, sizeConFish, new Point(0, 0));
			
			// Hệ của con cá
			strNameFish = "Element" + GUIMixFormulaInfo.getElementsName(Elements);
			var conFishResult:Container = AddContainer(FISH_SOLDIER, "CtnElementSoldier", 265, 120);
			var imgFishResult:Image = conFishResult.AddImage(ELEMENT_FISH_SOLDIER, strNameFish, conFish2.img.width / 2, conFish2.img.height / 2);
			imgFishResult.FitRect(sizeConFish * 2 / 3, sizeConFish * 2 / 3, new Point(10, 10));
			//AddImage(ELEMENT_FISH_SOLDIER, strNameFish, 230, 125);
			
			format.bold = true;
			var txtRateSuccess:TextField = AddLabel(SuccessPercent + "%", 185 - deltaX, 117 - deltaY, 0x000000, 0);
			var txtRank:TextField = AddLabel(ArrRank[Rank - 1], 185 - deltaX, 135 - deltaY, 0x000000, 0);
			
			/*var damage:Array = ConfigJSON.getInstance().GetItemDamageFishSoldier(type, Id + 1);
			var minDamage:int = int.MAX_VALUE;
			var maxDamage:int = int.MIN_VALUE;
			for (var i:int = 0; i < damage.length; i++) 
			{
				var item:int = damage[i];
				if (item < minDamage) 
				{
					minDamage = item;
				}
				if (item > maxDamage) 
				{
					maxDamage = item;
				}
			}*/
			var damage:Object = ConfigJSON.getInstance().GetItemDamageFishSoldier(type, Id + 1);
			var text:String = damage["Min"] + " - " + damage["Max"];
			
			var txtDamage:TextField = AddLabel(text, 185 - deltaX, 153 - deltaY, 0x000000, 0);
			txtDamage.setTextFormat(format);
			txtRank.setTextFormat(format);
			txtRateSuccess.setTextFormat(format);
		}
		public function SetInfo(obj:Object, Type:String):void 
		{
			type = Type;
			for (var s:String in obj) 
			{
				try 
				{
					this[s] = obj[s];
				}
				catch (err:Error)
				{
					trace(s);
				}
			}
		}
	}

}