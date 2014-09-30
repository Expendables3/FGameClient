package GUI.FishWorld 
{
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMixFormulaInfo extends BaseGUI 
	{
		public var Fish_1:Object;
		public var Fish_2:Object;		// object chứa fishType và FishTypeId của cá cần
		public var FishTypeId:int;		// FishTypeId của cá
		public var Rank:int;				// Lon của con cá được lai ra
		public var SuccessPercent:int	// Tỷ lệ lai thành công 20%
		public var Elements:int;
		public var Id:int;
		public var type:String;
		public var Name:String;
		public var ArrRank:Array = ["Nhập môn", "Đệ tử", "Đại đệ tử", "Sư huynh", "Đại sư huynh", 
									"Phó Đường chủ", "Đường chủ", "Trưởng lão", "Đại trưởng lão",
									"Trưởng môn", "Võ lâm minh chủ"]
		
		public const FISH_1:String = "Fish1";
		public const FISH_2:String = "Fish2";
		public const FISH_SOLDIER:String = "FishSoldier";
		public const ELEMENT_FISH_SOLDIER:String = "FishSoldier";
		
		public function GUIMixFormulaInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMixFormulaInfo";
		}
		
		public override function InitGUI(): void
		{
			LoadRes("ImgBgGUIMixFormula");
			Fish_1 = new Object();
			Fish_2 = new Object();
		}
		
		public function InitAll(obj:Object, x:Number, y:Number):void 
		{
			if(!this.IsVisible)
				Show();
			
			var delta:int = 10;
			
			// Vị trí container
			var posX:int = x;
			var posY:int = y;
			// Kích thước GUI
			var sizeX:int = 348;
			var sizeY:int = 287;
			
			var posCenter:Point;
			var posCenterX:int;
			var posCenterY:int;
			
			var posGui:Point = new Point();
			
			if (GuiMgr.IsFullScreen)
			{
				posCenterX = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenWidth / 2;
				posCenterY = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenHeight / 2
				posCenter = new Point(posCenterX, posCenterY);
			}
			else 
			{
				posCenterX = Constant.STAGE_WIDTH / 2;
				posCenterY = Constant.STAGE_HEIGHT / 2;
				posCenter = new Point(posCenterX, posCenterY);
			}
			
			if (posX <= posCenterX) 
			{
				if (posY <= posCenterY) 
				{
					//trace(" x<, y<");
					posGui.x = x + 10;
					posGui.y = y + 10;
				}
				else 
				{
					//trace(" x<, y>");
					posGui.x = x + 10;
					posGui.y = y - sizeY - 10;
				}
			}
			else 
			{
				if (posY <= posCenterY)  
				{
					//trace(" x>, y<");
					posGui.x = x - sizeX - 10;
					posGui.y = y + 10;
				}
				else 
				{
					//trace(" x>, y>");
					posGui.x = x - sizeX - 10;
					posGui.y = y - sizeY - 10;
				}
			}
			
			//Clear();
			
			//trace(img.width, img.height);
			SetPos(posGui.x, posGui.y);
			SetInfo(obj);
			ShowInfo();
		}
		 
		public function SetInfo(obj:Object):void
		{
			for (var itm:String in obj)
			{
				try
				{
					this[itm] = obj[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
		
		public function ShowInfo():void 
		{
			var deltaPosXComponent:int = 0;
			if (int(ImgName.split("ImgBgGUIMixFormula")[1] > 2))	deltaPosXComponent = 25;
			
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
			var conFish1:Container = AddContainer(FISH_1, "CtnFish", 26 + deltaPosXComponent, 70);
			var imgFish1:Image = conFish1.AddImage(FISH_1, strNameFish, 56, 100);
			imgFish1.FitRect(sizeConFish, sizeConFish, new Point(0, 0));
			obj = ConfigJSON.getInstance().getItemInfo("Fish", Fish_1["FishTypeId"]);
			txtLevelFish1 = conFish1.AddLabel(obj["LevelRequire"], 0, -22);
			txtLevelFish1.setTextFormat(format);
			var fishType1:String;
			switch(Fish_1["FishType"])
			{
				case 0:
					fishType1 = "Cá thường";
					break;
				case 1:
					fishType1 = "Cá đặc biệt";
					var effSpecial1:Sprite = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
					conFish1.AddImageBySprite(effSpecial1, imgFish1.img.width / 2 -20, imgFish1.img.height / 2 + 8);
					break;
				case 2:
					fishType1 = "Cá quí";
					TweenMax.to(imgFish1.img, 1, { glowFilter: { color:0xff00ff, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
					break;
			}
			var txtFishType1:TextField = AddLabel(fishType1, 35, 34, 0xffff00, 0);
			txtFishType1.setTextFormat(format);
			
			
			// Con cá thứ 2
			strNameFish = "Fish" + Fish_2["FishTypeId"] + "_" + Fish.OLD + "_" + Fish.IDLE;
			var conFish2:Container = AddContainer(FISH_2, "CtnFish", 135 + deltaPosXComponent, 70);
			var imgFish2:Image = conFish2.AddImage(FISH_2, strNameFish, conFish2.img.width / 2, conFish2.img.height / 2);
			//var imgFish2:Image = AddImage(FISH_2, strNameFish, 165, 69);
			imgFish2.FitRect(sizeConFish, sizeConFish, new Point(0, 0));
			obj = ConfigJSON.getInstance().getItemInfo("Fish", Fish_2["FishTypeId"]);
			txtLevelFish2 = conFish2.AddLabel(obj["LevelRequire"], 0, -22);
			txtLevelFish2.setTextFormat(format);
			var fishType2:String;
			switch(Fish_2["FishType"])
			{
				case 0:
					fishType2 = "Cá thường";
					break;
				case 1:
					fishType2 = "Cá đặc biệt";
					var effSpecial2:Sprite = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
					conFish1.AddImageBySprite(effSpecial2, imgFish1.img.width / 2 +90, imgFish1.img.height / 2 + 8);
					break;
				case 2:
					fishType2 = "Cá quí";
					TweenMax.to(imgFish2.img, 1, { glowFilter: { color:0xff00ff, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
					break;
			}
			var txtFishType2:TextField = AddLabel(fishType2, 141, 34, 0xffff00, 0);
			//format.color = 0x1c6883;
			txtFishType2.setTextFormat(format);
			
			// Con cá kết quả
			strNameFish = "Fish" + FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
			var conFish3:Container = AddContainer(FISH_2, "CtnFishSoldier", 242 + deltaPosXComponent, 63);
			var imgFish3:Image = conFish3.AddImage(FISH_SOLDIER, strNameFish, 0, 0);
			imgFish3.FitRect(sizeConFish, sizeConFish, new Point(0, 0));
			
			// Hệ của con cá
			strNameFish = "Element" + Elements;
			var conFishResult:Container = AddContainer(FISH_SOLDIER, "CtnElementSoldier", 240, 150);
			var imgFishResult:Image = conFishResult.AddImage(ELEMENT_FISH_SOLDIER, strNameFish, conFish2.img.width / 2, conFish2.img.height / 2);
			imgFishResult.FitRect(sizeConFish * 2 / 3, sizeConFish * 2 / 3, new Point(10, 10));
			//AddImage(ELEMENT_FISH_SOLDIER, strNameFish, 230, 125);
			
			//Cấp cá
			format.bold = true;
			var txtRateSuccess:TextField = AddLabel(SuccessPercent + "%", 160 + deltaPosXComponent, 147, 0x000000, 0);
			var txtRank:TextField = AddLabel(Rank.toString() + " - " + ArrRank[Rank - 1], 160 + deltaPosXComponent, 165, 0x000000, 0);
			
			var configRankRate:Object = ConfigJSON.getInstance().getItemInfo("RankPoint", Rank);
			var config:Object = ConfigJSON.getInstance().getItemInfo("Damage", -1);
			config = config[type][Id.toString()];
			//Chỉ số lực chiến
			var damage:Object = config["Damage"];//ConfigJSON.getInstance().GetItemDamageFishSoldier(type, Id);
			var st:String = Math.ceil(damage["Min"]*Math.pow((1+configRankRate["RateDamage"]), Rank -1)) + " - " + Math.ceil(damage["Max"]*Math.pow((1+configRankRate["RateDamage"]), Rank -1));
			var txtDamage:TextField = AddLabel(st, 160 + deltaPosXComponent, 183, 0x000000, 0);
			txtDamage.setTextFormat(format);
			txtRank.setTextFormat(format);
			txtRateSuccess.setTextFormat(format);
			//Chỉ số phòng thủ
			var defence:Object = config["Defence"];
			st = Math.ceil(defence["Min"]*Math.pow((1+configRankRate["RateDefence"]), Rank -1)) + " - " + Math.ceil(defence["Max"]*Math.pow((1+configRankRate["RateDefence"]), Rank -1));
			var txtDefence:TextField = AddLabel(st, 160 + deltaPosXComponent, 183 + 17, 0x000000, 0);
			txtDefence.setTextFormat(format);
			//Chỉ số chí mạng
			var critical:Object = config["Critical"];
			st = Math.ceil(critical["Min"]*Math.pow((1+configRankRate["RateCritical"]), Rank -1)) + "-" + Math.ceil(critical["Max"]*Math.pow((1+configRankRate["RateCritical"]), Rank -1));
			var txtCritical:TextField = AddLabel(st, 160 + deltaPosXComponent, 183 + 34, 0x000000, 0);
			txtCritical.setTextFormat(format);
			//Chỉ số máu
			var vitality:Object = config["Vitality"];
			st = Math.ceil(vitality["Min"]*Math.pow((1+configRankRate["RateVitality"]), Rank -1)) + " - " + Math.ceil(vitality["Max"]*Math.pow((1+configRankRate["RateVitality"]), Rank -1));
			var txtVitality:TextField = AddLabel(st, 160 + deltaPosXComponent, 183 + 51, 0x000000, 0);
			txtVitality.setTextFormat(format);
			
			//Tên công thức lai
			//var labelName:TextField = AddLabel("Bí kíp lai: " + ArrRank[Rank - 1] + " - Hệ " + getElementsName(Elements), 130, 11, 0xffff00, 1);
			var labelName:TextField = AddLabel(Name, 130, 11, 0xffff00, 1);
			format.size = 18;
			format.color = 0x054a55;
			labelName.setTextFormat(format);
			
			// Số sao	
			var dxx:int = 17;
			var numStar:int = 0;
			switch(type)
			{
				case "Draft":
					numStar = 1;
					break;
				case "Paper":
					numStar = 2;
					break;
				case "GoatSkin":
					numStar = 3;
					break;
				case "Blessing":
					numStar = 4;
					break;
			}
			for (var i:int = 0; i < numStar; i++)
			{
				AddImage("", "RedStar", 277 + 17 * i - (numStar*8.5), 48, true, ALIGN_LEFT_TOP).SetScaleXY(0.3);
			}
		}
		
		public static function getElementsName(element:int):String
		{
			switch (element) 
			{
				case 1:
					return "Kim";
				break;
				case 2:
					return "Mộc";
				break;
				case 3:
					return "Thổ";
				break;
				case 4:
					return "Thủy";
				break;
				case 5:
					return "Hỏa";
				break;
				default:
					return "";
				break;
			}
		}
	}

}