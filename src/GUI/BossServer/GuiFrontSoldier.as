package GUI.BossServer 
{
	import Data.ConfigJSON;
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GuiFrontSoldier extends BaseGUI 
	{
		private var prgVitality:ProgressBar;
		private var soldier:Soldier;
		
		public function GuiFrontSoldier(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("");
			//Effect Gem
			for (var s:String in soldier.GemList)
			{
				if (!soldier.GemList[s][0])	continue;
				if (soldier.GemList[s][0]["Turn"] && soldier.GemList[s][0]["Turn"] > 0)
				{
					var gemEff:Image = AddImage("", "EffBuffGem",135, 124);
					gemEff.img.blendMode = BlendMode.LIGHTEN;
					gemEff.img.scaleX = gemEff.img.scaleY = 0.6;
					//gemEff.img.mouseEnabled = false;
					switch(int(s))
					{
						case 1:
							gemEff.img.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 255, 50, -200);
							break;
						case 2:
							gemEff.img.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 255, -200);
							break;
						case 3:
							gemEff.img.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 120, -200, -150);
							break;
						case 4:
							gemEff.img.transform.colorTransform = new ColorTransform();
							break;
						case 5:
							gemEff.img.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 255, -150, -150);
							break;
					}
				}
			}
			
			prgVitality = AddProgress("", "PrgHealth", 0, -50, null, true);
			prgVitality.scaleX = 0.5;
			prgVitality.scaleY = 0.5;
			AddImage("", "IcHeart", 0, 0).FitRect(20, 20, new Point(prgVitality.x - 20, prgVitality.y - 7));
			var nameSoldier:String;
			if (soldier.nameSoldier == null || soldier.nameSoldier == "")
			{
				nameSoldier = "Tiểu " + Ultility.GetNameElement(soldier.Element) + " Ngư";
			}
			else
			{
				nameSoldier = soldier.nameSoldier;
			}
			AddLabel(nameSoldier, -10, -70, 0xffffff, 0, 0x000000);
			//img.mouseChildren = false;
			//img.mouseEnabled = false;
			var fameLevel:int = GameLogic.getInstance().user.getReputationLevel();
			if(fameLevel > 1)
			{
				if(fameLevel <= 9)
				{
					AddImage("", "fameTitle" + fameLevel, 253 + 84 - 354, -45 - 21, true, ALIGN_LEFT_TOP, true).SetScaleXY(0.7);
				}
				else
				{
					AddImage("", "fameTitle" + fameLevel, 253 + 84 - 354, -45 - 21, true, ALIGN_LEFT_TOP, true);
				}
			}
			
			/*var i:int;
			var quartId:int;
			var quartType:String;
			var obj:Object = { "QWhite":1, "QGreen":2, "QYellow":3, "QPurple":4, "QVIP":5 };
			var maxId:int;
			for each(var equip:SoldierEquipment in soldier.Equipments)
			{
				if (obj[equip.Type] != null && obj[equip.Type] >= quartId)
				{
					quartId = obj[equip.Type];
					quartType = equip.Type;
					if (maxId < equip.ItemId || obj[equip.Type] > quartId)
					{
						maxId = equip.ItemId;
					}
				}
			}
			
			if (quartType != null && ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[quartType][maxId] != null)
			{
				var numStar:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[quartType][maxId]["Star"];
				for (i = 0; i < numStar; i++)
				{
					AddImage("", "Ic" + quartType.substring(1, quartType.length) + "Star", (i-numStar/2) * 17,-68);
				}
			}*/
		}
		
		public function showGUI(_soldier:Soldier):void
		{
			if (IsVisible)
			{
				Hide();
			}
			soldier = _soldier;
			Parent = soldier.frontSprite;
			IsVisible = true;
			InitGUI();
		}
		
		public function setVitality(curVitality:Number, maxVitality:Number):void
		{
			//trace("testttttttttt");
			//trace(curVitality, maxVitality);
			//trace(curVitality / maxVitality);
			prgVitality.setStatus(curVitality / maxVitality);
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			soldier.OnMouseClick(event);
		}
		
	}

}