package GUI.BossServer 
{
	import GUI.BossServer.Soldier;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.FishWar.FishWings;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIBehindSoldier extends BaseGUI 
	{
		private var soldier:Soldier;
		
		public function GUIBehindSoldier(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("");
			//Cánh của cá
			var seal:SoldierEquipment;
			for each(var equip:SoldierEquipment in soldier.Equipments)
			{
				if (equip.Type == "Seal")
				{
					seal = equip;
					break;
				}
			}
			var activeRowSeal:int = Ultility.getRowSeal(seal, soldier);
			if (activeRowSeal > 0)
			{
				var wingName:String =  "Wings" + seal.Rank + activeRowSeal;
				if (seal.Color >= 5)
				{
					wingName =  "Wings" + seal.Rank + 6;
				}
				var wings:FishWings = new FishWings(this.img, wingName);
				switch(soldier.Element)
				{
					case 1:
						wings.img.x = -4;
						wings.img.y = -26;
						break;
					case 2:
						wings.img.x = 0;
						wings.img.y = -21;
						break;
					case 3:
						wings.img.x = -12;
						wings.img.y = -30;
						break;
					case 4:
						wings.img.x = 6;
						wings.img.y = -16;
						break;
					case 5:
						wings.img.x = 11;
						wings.img.y = -31;
						break;
					
				}
			}
		}
		
		public function showGUI(_soldier:Soldier):void
		{
			if (IsVisible)
			{
				Hide();
			}
			soldier = _soldier;
			Parent = soldier.behindSprite;
			IsVisible = true;
			InitGUI();
		}
	}

}