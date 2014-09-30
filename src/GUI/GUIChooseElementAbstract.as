package GUI 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * GUI này dùng để chọn hệ cho đồ sắp nhận
	 * Code vào hàm receiveGift(element): để nhận quà về, trong đó element là hệ đã chọn
	 * kế thừa và thêm thuộc tính để set thêm data
	 * @author HiepNM2
	 */
	public class GUIChooseElementAbstract extends BaseGUI 
	{
		public var IdMaterial:int;
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const CMD_CHOOSE_ELEMENT:String = "cmdChooseElement";
		private const KIM:int = 1;
		private const MOC:int = 2;
		private const THO:int = 3;
		private const THUY:int = 4;
		private const HOA:int = 5;
		
		protected const MONEY:int = 2;
		protected const EXP:int = 3;
		protected const MATERIAL:int = 1;
		
		private var _type:String;// = "Element"   || = "Material"
		
		protected var isClick:Boolean = false;
		public function GUIChooseElementAbstract(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIChooseElementAbstract";
			_type = "Element";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void 
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				switch(_type) 
				{
					case "Element":
						addBgrElement();
					break;
					case "Material":
						addBgrMaterial();
					break;
					default:
						addBgrElement();
				}
				addNumGift();
				
			}
			if (_type == "Element") 
			{
				LoadRes("GuiChooseElement_5_Theme");
			}
			else if (_type == "Material")
			{
				LoadRes("GuiChooseElement_3_Theme");
			}
		}
		protected virtual function addNumGift():void {
			
		}
		private function addBgrMaterial():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 405, -22);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + MONEY, "GuiChooseElement_BtnChooseMoney", 20, 5);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + EXP, "GuiChooseElement_BtnChooseExp", 140, 5);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + MATERIAL, "GuiChooseElement_BtnChooseMaterial" + IdMaterial, 260, 5);
		}
		
		private function addBgrElement():void
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 618, -22);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + KIM, "GuiChooseElement_BtnChooseSteel", 10, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + MOC, "GuiChooseElement_BtnChooseWood", 130, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + THO, "GuiChooseElement_BtnChooseEarth", 490, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + THUY, "GuiChooseElement_BtnChooseWater", 250, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + HOA, "GuiChooseElement_BtnChooseFire", 370, 18);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var element:int;
			switch(cmd)
			{
				case ID_BTN_CLOSE:
					onClose();
				break;
				case CMD_CHOOSE_ELEMENT:
					element = int(data[1]);
					if (!isClick)
					{
						receiveGift(element);
						isClick = !isClick;
					}
				break;
			}
		}
		public virtual function receiveGift(element:int):void
		{
			
		}
		
		public function get Type():String 
		{
			return _type;
		}
		
		public function set Type(value:String):void 
		{
			_type = value;
		}
		protected virtual function onClose():void
		{
			Hide();
		}
	}

}






































