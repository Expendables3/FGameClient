package GUI.BossServer 
{
	import com.greensock.TweenMax;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.ResMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import GUI.component.Image;
	import GUI.component.SpriteExt;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class Soldier extends BaseObject 
	{
		//Cac thuoc tinh co ban
		public var Id:int;
		public var Rank:int;
		public var RankPoint:int;
		public var LifeTime:int;
		public var Damage:Number;
		public var Defence:Number;
		public var Vitality:Number;
		public var Critical:Number;
		public var Health:Number;
		public var LastHealthTime:Number;
		public var Bonus:Array;
		public var Diary:Array;
		private var numBonusMoney:int;
		public var RecipeType:Object;
		public var Status:int;
		public var BuffItem:Array;
		public var GemList:Object;
		public var UserBuff:Array;
		public var NumDefendFail:int;
		public var nameSoldier:String;
		public var lastTimeChangeName:Number;
		public var Element:int;
		
		//Thuoc tinh them
		public var Equipments:Array;//Mang vu khi
		public var isMine:Boolean = true;
		public var behindSprite:Sprite;
		public var frontSprite:Sprite;
		public var guiFront:GuiFrontSoldier = new GuiFrontSoldier(null, "");//Gui nằm trước con cá
		private var guiBehind:GUIBehindSoldier = new GUIBehindSoldier(null, "");//Gui nằm sau con cá
		private var destination:Point;
		private var imageSoldier:Image;
		private var onReachDes:Function;
		//Bonus từ vũ khí
		public var equipVitality:int;
		public var equipDamage:int;
		public var equipCritical:int;
		public var equipDefence:int;
		//Bonus từ ngư mạch
		public var meridianVitality:int;
		public var meridianDamage:int;
		public var meridianCritical:int;
		public var meridianDefence:int;
		//Bonus từ đan tán, trợ lực
		public var drugVitality:int;
		public var drugDamage:int;
		public var drugCritical:int;
		public var drugDefence:int;
		static public const IC_SELECTED:String = "icSelected";
		public var isSelected:Boolean = false;
		
		public function Soldier(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			if (imgName != "")
			{
				LoadRes("");
				behindSprite = new Sprite();
				img.addChild(behindSprite);
				imageSoldier = new Image(img, imgName, 0, 0, true, ALIGN_LEFT_TOP, false);
				frontSprite = new Sprite();
				img.addChild(frontSprite);
			}
		}
		
		public function initSoldier(soldierData:Object, x:Number, y:Number):void
		{
			LoadRes("");
			behindSprite = new Sprite();
			img.addChild(behindSprite);
			SetInfo(soldierData);
			updateDrugBonus();
			var imgSoldierName:String = "Fish" + (310 + Element*10) + "_Old_Idle";// "Soldier_" + Element;
			imageSoldier = new Image(img, imgSoldierName, 0, 0, true, ALIGN_LEFT_TOP, false, onLoadSoldierImgComplete);
			frontSprite = new Sprite();
			img.addChild(frontSprite);
			SetPos(x, y);
		}
		
		private function onLoadSoldierImgComplete():void 
		{
			if (imageSoldier != null)
			{
				imageSoldier.SetPos(0, 0);
				imageSoldier.img.cacheAsBitmap = true;
			}
			updateImgEquipment();
		}
		
		private function updateDrugBonus():void
		{
			drugVitality = 0;
			drugCritical = 0;
			drugDamage = 0;
			drugDefence = 0;
			
			var obj:Object;
			var config:Object;
			var i:int;
			//Trợ lực
			for (i = 0; BuffItem != null && i < BuffItem.length; i++)
			{
				obj = BuffItem[i];
				config = ConfigJSON.getInstance().GetBuffItemList();
				switch (obj.ItemType)
				{
					case "Samurai":
						for (var j:int = 0; j < config.length; j++)
						{
							if (config[j]["Type"] == obj["ItemType"] && config[j]["Id"] == obj["ItemId"])
							break;
						}
						drugDamage += obj["Num"] * config[j]["Num"];
						break;
				}
			}
			
			//Đan
			for (var s:String in GemList)
			{
				config = ConfigJSON.getInstance().GetItemList("Gem");
				for (i = 0; i < GemList[s].length; i++)
				{
					var value:Number = config[GemList[s][i]["GemId"]][s];
					switch (int(s))
					{
						case 1:
							if (Element == 1)
							{
								drugCritical += 2 * value;
							}
							else
							{
								drugCritical += value;
							}
							break;
						case 2:
							if (Element == 3)
							{
								drugDamage += 2 * value;
							}
							else
							{
								drugDamage += value;
							}
							break;
						case 3:
							// Tỷ lệ def gem
							if (Element == 3)
							{
								drugDefence += 2 * value;
							}
							else
							{
								drugDefence += value;
							}
							break;
						case 4:
							// Hồi phục máu cho cá
							if (Element == 4)
							{
								drugVitality += 2 * value;
							}
							else
							{
								drugVitality += value;
							}
							break;
						case 5:
							if (Element == 5)
							{
								drugDamage += 2 * value;
							}
							else
							{
								drugDamage += value;
							}
							break;
					}
				}
			}
			
			if (drugDamage <0 && Math.abs(drugDamage) >  Math.ceil(Damage / 2))
			{
				drugDamage = -Math.ceil(Damage / 2);
			}
		}
		
		public function setEquipment(_equipment:Object, _index:Object):void
		{
			Equipments = new Array();
			equipCritical = _index["Critical"];
			equipDamage = _index["Damage"];
			equipDefence = _index["Defence"];
			equipVitality = _index["Vitality"];
			for (var s:String in _equipment)
			{
				for (var t:String in _equipment[s])
				{
					var soldierEquip:SoldierEquipment = new SoldierEquipment(_equipment[s][t]);
					Equipments.push(soldierEquip);
				}
			}
			
			updateImgEquipment();
		}
		
		public function setMeridian(meridian:Object):void
		{
			meridianCritical = meridian["Critical"];
			meridianDamage = meridian["Damage"];
			meridianDefence = meridian["Defence"];
			meridianVitality = meridian["Vitality"];
		}
		
		public function setScale(scale:Number):void
		{
			if(imageSoldier != null)
			{
				imageSoldier.SetScaleX(scale);
				imageSoldier.SetScaleY(Math.abs(scale));
			}
			behindSprite.scaleX = scale;
			behindSprite.scaleY = Math.abs(scale);
		}
		
		public function swimTo(_destination:Point, speed:Number= 10, _onReachDes:Function = null):void
		{
			onReachDes = _onReachDes;
			destination = _destination;
			//Quay mặt con cá
			if (CurPos.x > destination.x)
			{
				if(imageSoldier != null)
				{
					imageSoldier.SetScaleX( -1);
				}
				if (behindSprite != null)
				{
					behindSprite.scaleX = -1;
				}
			}
			else
			{
				if (imageSoldier != null)
				{
					imageSoldier.SetScaleX(1);
				}
				if (behindSprite != null)
				{
					behindSprite.scaleX = 1;
				}
			}
			
			//Xoay con ca dung goc
			var s:Point = destination.subtract(CurPos);
			var dir:Number = Math.atan2(s.y, s.x) * 180 / Math.PI;
			if (dir < 0)
			{
				dir += 360;
			}
			if (dir > 90 && dir < 270)
			{
				dir = (dir + 180) % 360;
			}
			var delta:int = 20;
			if (dir < 360 - delta && dir >= 270)
			{
				dir = 360 - delta;
			}
			if (dir > delta && dir <= 90)
			{
				dir = delta;
			}
			if(imageSoldier != null)
			{
				imageSoldier.img.rotation = dir;
			}
			if (behindSprite != null)
			{
				behindSprite.rotation = dir;
			}
			MoveTo(destination.x, destination.y, speed);
		}
		
		private function updateImgEquipment():void
		{
			if (Equipments != null)
			{
				for (var i:int = 0; i < Equipments.length; i++)
				{
					var soldierEquip:SoldierEquipment = SoldierEquipment(Equipments[i]);
					if (soldierEquip.Type != "QVIP" && soldierEquip.Type != "QGreen" && soldierEquip.Type != "QWhite"&& soldierEquip.Type != "QYellow" && soldierEquip.Type != "QPurple"  && imageSoldier != null && imageSoldier.img != null && imageSoldier.img.getChildByName(soldierEquip.Type) != null)
					{
						var equip:MovieClip = MovieClip(imageSoldier.img.getChildByName(soldierEquip.Type));
						var index:int = imageSoldier.img.getChildIndex(equip);
						//trace(soldierEquip.Type, index);
						imageSoldier.img.removeChild(equip);
						var newEquip:Image = new Image(imageSoldier.img, soldierEquip.getImgName(), 0, 0, true, ALIGN_LEFT_TOP, true, 
						function f():void
						{
							switch(soldierEquip.Color)
							{
								case 2:
									TweenMax.to(this.img, 0, { glowFilter: { color:0x00ff00, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
									break;
								case 3:
									TweenMax.to(this.img, 0, { glowFilter: { color:0xffff00, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
									break;
								case 4:
									TweenMax.to(this.img, 0, { glowFilter: { color:0x9900ff, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
									break;
								case 5:
								case 6:
									//TweenMax.to(this.img, 0, { glowFilter: { color:0xffffff, alpha:1, blurX:10, blurY:10, strength:2 }} );
									var c:ColorTransform = new ColorTransform(0.9, 0.9, 0.9, 1, 255, 99, 0, 0);
									this.img.transform.colorTransform = c;
									
									var filter:Array = [];
									var glow:GlowFilter = new GlowFilter(0xff9900, 1, 5, 5, 1.7, BitmapFilterQuality.HIGH);
									filter.push(glow);
									this.img.filters = filter;
									break;
							}
						});
						imageSoldier.img.setChildIndex(newEquip.img, index);
						newEquip.img.mouseEnabled = true;
						imageSoldier.img.mouseChildren = true;
					}
					else
					if (soldierEquip.Type == "Mask")
					{
						var maskName:String = "";
						switch (soldierEquip.Rank)
						{
							case 1:
								maskName = "Dragon_" + Element;
								break;
							case 2:
								maskName = "Shen";
								break;
							case 3:
								maskName = "SpartaWar";
								break;
							case 4:
								maskName = "TuaRuaBaoTu";
								break;
							case 5:
								maskName = "Champion";
								break;
						}
						//imageSoldier.LoadRes("Material1");
						try
						{
							img.removeChild(imageSoldier.img);
						}
						catch (e:*)
						{
							
						}
						imageSoldier = new Image(img, maskName, 0, 0, true, ALIGN_LEFT_TOP, false);
						switch(soldierEquip.Color)
						{
							case 2:
								TweenMax.to(imageSoldier.img, 0.1, { glowFilter: { color:0x00ff00, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
								break;
							case 3:
								TweenMax.to(imageSoldier.img, 0.1, { glowFilter: { color:0xffff00, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
								break;
							case 4:
								TweenMax.to(imageSoldier.img, 0.1, { glowFilter: { color:0x9900ff, alpha:1, blurX:10, blurY:10, strength:1.5 }} );
								break;
						}
					}
				}
			}
			guiBehind.showGUI(this);
		}
		
		
		override public function UpdateObject():void 
		{
			if (ReachDes)
			{
				if(imageSoldier != null && imageSoldier.img != null)
				{
					imageSoldier.img.rotation = 0;
					if(behindSprite != null)
					{
						behindSprite.rotation = 0;
					}
					//Cá dập dềnh
					if (CurPos.y <= DesPos.y + 7 && SpeedVec.y > 0)
					{
						SpeedVec.y = Math.random() * 0.3 + 0.2;
						
					}
					else if (CurPos.y >= DesPos.y - 7)
					{
						SpeedVec.y = -(Math.random() * 0.3 + 0.2);
					}
					else
					{
						SpeedVec.y = -SpeedVec.y;
					}
					CurPos.y += SpeedVec.y;
					SetPos(CurPos.x, CurPos.y);
				}
				return;
			}
			
			if (CurPos != null && DesPos != null && img != null)
			{
				var temp:Point = CurPos.subtract(DesPos);
				if ( temp.length <= SpeedVec.length)
				{
					ReachDes = true;
					if (onReachDes != null)
					{
						onReachDes();
					}
					return;
				}
					
				CurPos = CurPos.add(SpeedVec);
				this.img.x = CurPos.x;
				this.img.y = CurPos.y;	
			}
		}
		
		override public function Destructor():void 
		{
			super.Destructor();
			imageSoldier = null;
			guiFront.Hide();
			guiBehind.Hide();
			Equipments = null;
		}
		
		public function getTotalDamage():int
		{
			var reputation:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			var config:Object = ConfigJSON.getInstance().GetItemList("ReputationBuff");
			var reputationDamage:Number = 0;
			if(config[reputation] != null)
			{
				reputationDamage = config[reputation]["Damage"];
			}
			return Damage + drugDamage + equipDamage + meridianDamage + reputationDamage;
		}
		
		public function getTotalCritical():int
		{
			var reputation:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			var config:Object = ConfigJSON.getInstance().GetItemList("ReputationBuff");
			var reputationCritical:Number = 0;
			if(config[reputation] != null)
			{
				reputationCritical = config[reputation]["Critical"];
			}
			return Critical + drugCritical + equipCritical + meridianCritical + reputationCritical;
		}
		
		public function getTotalDefence():int
		{
			var reputation:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			var config:Object = ConfigJSON.getInstance().GetItemList("ReputationBuff");
			var reputationDefence:Number = 0;
			if(config[reputation] != null)
			{
				reputationDefence = config[reputation]["Defence"];
			}
			return Defence + equipDefence + drugDefence + meridianDefence + reputationDefence;
		}
		
		public function getTotalVitality():int
		{
			var reputation:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			var config:Object = ConfigJSON.getInstance().GetItemList("ReputationBuff");
			var reputationVitality:Number = 0;
			if(config[reputation] != null)
			{
				reputationVitality = config[reputation]["Vitality"];
			}
			return (Vitality + equipVitality + drugVitality + meridianVitality + reputationVitality);
		}
		
		/**
		 * Ngư thủ ăn item hỗ trợ và gem
		 * @param	itemType
		 * @param	itemId
		 */
		public function eatItem(itemType:String, itemId:int):Boolean
		{
			if (itemType.search("Gem") >= 0)
			{
				var a:Array = itemType.split("$");
				//Kiểm tra có đc dùng hay ko
				var forbidenElement:int = Element + 1;
				if (Element == 5)
				{
					forbidenElement = 1;
				}
				if ((int(a[1]) == forbidenElement || (int(a[1]) == 2 && (isMine || Element == 2))) && GemList[a[1]] != null)
				{
					return false;
				}
				var cfg:Object = ConfigJSON.getInstance().GetItemList("Gem");
				var object:Object = new Object();
				object["GemId"] = int(a[2]);
				object["Turn"] = cfg[a[2]]["Turn"];
				if (GemList[a[1]] == null)
				{
					GemList[a[1]] = new Array();
				}
				GemList[a[1]].push(object);
				guiFront.showGUI(this);
				updateDrugBonus();
				return true;
			}
			return false;
		}
	}

}