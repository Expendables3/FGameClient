package GUI.CreateEquipment 
{
	import Effect.EffectMgr;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIChooseEquipment;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemSeparate extends Container 
	{
		static public const SEPARATING:String = "separating";
		private var listIngradient:ListBox;
		private var isEffComplete:Boolean = false;
		private var isGetData:Boolean = false;
		static public const EMPTY:String = "empty";
		static public const HAS_EQUIPMENT:String = "hasEquipment";
		static public const SEPARATED:String = "separated";
		public var equipment:FishEquipment;
		public var itemState:String;
		public var result:Object;
		
		public function ItemSeparate(parent:Object, imgName:String = "GuiSeparateEquipment_Separated_Bg", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			itemState = EMPTY;
		}
		
		public function setEquipment(_equipment:FishEquipment):void
		{
			ClearComponent();
			//isEmpty = false;
			itemState = HAS_EQUIPMENT;
			equipment = _equipment;
			
			AddImage("", FishEquipment.GetBackgroundName(equipment.Color), 42, 43);

			var imageEquipment:Image = AddImage("", equipment.imageName + "_Shop", 0, 0);
			imageEquipment.FitRect(70, 70, new Point(7, 7));
		}
		
		public function removeEquipment():void
		{
			if (itemState == HAS_EQUIPMENT)
			{
				itemState = EMPTY;
				ClearComponent();
				var guiChooseEquipment:GUIChooseEquipment = GuiMgr.getInstance().GuiChooseEquipment;
				guiChooseEquipment.ItemList.push(equipment);
				guiChooseEquipment.ShowTab(guiChooseEquipment.curTab);
			}
		}
		
		/**
		 * show kết quả tách đồ
		 * @param	result
		 */
		public function separateEquip(result:Object):void
		{
			isGetData = true;
			this.result = result;
			
			if (isEffComplete)
			{
				showResult();
			}
		}
		
		public function showEffSeparate():void
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GUISeparate_Eff_Separate", null, CurPos.x + 110, CurPos.y + 217, false, false, null, effComplete);
		}
		
		private function effComplete():void
		{
			isEffComplete = true;
			
			if(isGetData)
			{
				showResult();
			}
		}
		
		private function showResult():void
		{
			if (result != null)
			{
				ClearComponent();
				itemState = SEPARATED;
				
				listIngradient = AddListBox(ListBox.LIST_X, 2, 2, 5, 5);
				listIngradient.setPos(0, 0);
				
				var itemIngradient:ItemInGradient;
				for(var s:String in result)
				{
					if (s != "SoulRock")
					{
						if (result[s] != 0)
						{
							itemIngradient = new ItemInGradient(listIngradient.img);
							itemIngradient.initIngradient(result[s], s, 0, 19);
							itemIngradient.SetScaleXY(0.6);
							listIngradient.addItem(s, itemIngradient);
						}
					}
					else
					{
						for (var m:String in result[s])
						{
							if (result[s][m] != 0)
							{
								itemIngradient = new ItemInGradient(listIngradient.img);
								itemIngradient.initIngradient(result[s][m], s, int(m), 19);
								itemIngradient.SetScaleXY(0.6);
								listIngradient.addItem(s +"_" + m, itemIngradient);
							}
						}
					}
				}
				
				var num:int = 4 - listIngradient.numItem; 
				for (var i:int = 0; i < num ; i++)
				{
					itemIngradient = new ItemInGradient(listIngradient.img);
					itemIngradient.SetScaleXY(0.6);
					listIngradient.addItem(i.toString(), itemIngradient);
				}
				
				var guiSeparate:GUISeparateEquipment = GuiMgr.getInstance().GuiChooseEquipment.guiSeparateEquipment;
				guiSeparate.GetButton(GUISeparateEquipment.BTN_CLOSE).SetEnable(true);
				guiSeparate.GetButton(GUISeparateEquipment.BTN_GET).SetVisible(true);
				var guiChooseEquipment:GUIChooseEquipment = GuiMgr.getInstance().GuiChooseEquipment;
				guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_CLOSE).SetEnable(true);
				//guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_ENCHANT).SetEnable(true);
				//guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_CREATE).SetEnable(true);
				guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_EXTEND).SetEnable(true);
			}
			isGetData = false;
			isEffComplete = false;
		}
		
	}

}