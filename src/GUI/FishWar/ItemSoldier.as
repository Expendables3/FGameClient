package GUI.FishWar 
{
	import Data.Localization;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.Ultility;
	
	/**
	 * thực hiện vẽ con cá trên 1 gui bất kỳ
	 * @author HiepNM2
	 */
	public class ItemSoldier 
	{
		// const
		private const MAX_CHAR_NAME:int = 30;
		// gui
		private var _parent:BaseGUI;
		private var _imageSoldier:Image;
		
		
		private var tfDamage:TextField;				//vẽ ra chỉ số công,thủ...
		private var tfDefence:TextField;
		private var tfCritical:TextField;
		private var tfVitality:TextField;
		
		private var tfPercent:TextField;			// tỉ lệ rankPoint/maxrankPoint
		private var tfRankName:TextField;			//tên cấp độ
		private var prgRank:ProgressBar;			// thanh rankpoint
		private var icRank:Image;
		
		public var X:int;
		public var Y:int;
		//logic
		private var _hasName:Boolean = false;			//có vẽ ra tên hay không
		private var _hasProperties:Boolean = false;		//có vẽ ra các thuộc tính
		private var _hasRankProperties:Boolean = false;
		private var _hasIconRank:Boolean = false;
		private var _soldier:FishSoldier;			//con cá logic
		
		private var _damage:int;
		private var _defence:int;
		private var _critical:int;
		private var _vitality:int;
		private var wings:FishWings;
		
		public function ItemSoldier(parent:BaseGUI, soldier:FishSoldier=null, x:int=0, y:int=0,hasName:Boolean=false)
		{
			_parent = parent;
			_soldier = soldier;
			X = x;
			Y = y;
			_hasName = hasName;
		}
		
		/**
		 * vẽ ra con cá _soldier ra
		 */
		private function showSoldier():void 
		{
			if (_imageSoldier != null) {
				_parent.RemoveImage(_imageSoldier);
			}
			_imageSoldier = _parent.AddImage("", 
									Fish.ItemType + _soldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 
									0, 0);
			
			_imageSoldier.FitRect(150, 150, new Point(X, Y));
			UpdateFishContent(_soldier, _imageSoldier);
		}
		
		private function UpdateFishContent(curSoldier:FishSoldier, curSoldierImg:Image):void
		{
			var s:String;
			var i:int;
			
			for (s in curSoldier.EquipmentList)
			{
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(curSoldierImg, eq);
				}
			}
			
			if (_hasName) 
			{
				var fm:TextFormat = new TextFormat("arial", 16, 0xffff00, true);
				fm.align = "center";
				
				var txtField:TextField = new TextField();
				var strName:String = "";
				
				if (curSoldier.nameSoldier == null || curSoldier.nameSoldier.length <= 0) {
					strName = getNameDefault(curSoldier.Element);
				}
				else {
					strName = curSoldier.nameSoldier;
				}
				
				txtField.text = strName;
				txtField.setTextFormat(fm);
				txtField.width = 110;
				txtField.y = -62;
				txtField.x = -35;
				curSoldierImg.img.addChild(txtField);
			}
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		private function ChangeEquipment(curSoldierImg:Image, equip:FishEquipment):void
		{
			var Type:String = equip.Type;
			var resName:String = equip.imageName;
			var color:int = equip.Color;
			
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(curSoldierImg.img, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.loadComp = function f():void
				{
					try
					{
						var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
						dob.name = Type;
						child.parent.removeChild(child);
						FishSoldier.EquipmentEffect(dob, color);
					}
					catch (e:*)
					{
						
					}
				}
				eq.loadRes(resName);
			}
			/*Thêm vào cái cánh nếu có ấn*/
			if (equip.Type == "Seal")
			{
				if (wings != null && curSoldierImg.img.contains(wings.img))
				{
					curSoldierImg.img.removeChild(wings.img);
				}
				
				var activeRowSeal:int = Ultility.getActiveRowSeal(equip, _soldier);
				if (activeRowSeal > 0)
				{
					//wings = ResMgr.getInstance().GetRes("Wings" + eq.Rank + activeRowSeal) as Sprite;
					wings = new FishWings(curSoldierImg.img, "Wings" + equip.Rank + activeRowSeal);
					curSoldierImg.img.setChildIndex(wings.img, 0);
					switch(_soldier.Element)
					{
						case 4:
						case 2:
						case 1:
							wings.img.y = -30;
							wings.img.x = 16;
							break;
						case 3:
							wings.img.y = -40;
							wings.img.x = -16;
							break;
						case 5:
							wings.img.y = -25;
							wings.img.x = 20;
							break;
					}
				}
			}
		}
		
		public function get soldier():FishSoldier 
		{
			return _soldier;
		}
		
		public function set soldier(value:FishSoldier):void 
		{
			if (value == null) {
				_soldier = null;
				return;
			}
			_soldier = value;
			showSoldier();
			if (_hasProperties) {
				updateProperties(value);
			}
			if (_hasIconRank) {
				updateRankIcon(value);
			}
			if (_hasRankProperties) {
				updateRankProperties(value);
			}
		}
		
		public function get damage():int 
		{
			return _damage;
			
		}
		
		public function set damage(value:int):void 
		{
			_damage = value;
			tfDamage.text = Ultility.StandardNumber(value);
		}
		
		public function get defence():int 
		{
			return _defence;
		}
		
		public function set defence(value:int):void 
		{
			_defence = value;
			tfDefence.text = Ultility.StandardNumber(value);
		}
		
		public function get critical():int 
		{
			return _critical;
		}
		
		public function set critical(value:int):void 
		{
			_critical = value;
			tfCritical.text = Ultility.StandardNumber(value);
		}
		
		public function get vitality():int 
		{
			return _vitality;
		}
		
		public function set vitality(value:int):void 
		{
			_vitality = value;
			tfVitality.text = Ultility.StandardNumber(value);
		}
		
		
		/**
		 * Vẽ các thuộc tính của cá
		 * @param	xDam , yDam 		: tọa độ text Công 
		 * @param	xDef , yDef			: tọa độ text Thủ 
		 * @param	xCrit , yCrit		: tọa độ text Chí Mạng 
		 * @param	xVita , yVita		: tọa độ text Máu
		 * @param	format				: format chung của các text
		 */
		public function addProperties(xDam:int, yDam:int, 
										xDef:int, yDef:int, 
										xCrit:int, yCrit:int, 
										xVita:int, yVita:int,
										format:TextFormat):void
		{
			_hasProperties = true;
			tfDamage 	= 	_parent.AddLabel("", xDam, yDam);
			tfDefence 	= 	_parent.AddLabel("", xDef, yDef);
			tfCritical 	= 	_parent.AddLabel("", xCrit, yCrit);
			tfVitality 	= 	_parent.AddLabel("", xVita, yVita);
			tfDamage.defaultTextFormat 		= 	tfDefence.defaultTextFormat 	=
			tfCritical.defaultTextFormat 	= 	tfVitality.defaultTextFormat 	= 	format;
		}
		/**
		 * cập nhật thuộc tính cho cá mới
		 * @param	soldier : con cá mới
		 */
		private function updateProperties(soldier:FishSoldier):void 
		{
			damage 		= soldier.getTotalDamage();// soldier.Damage + soldier.bonusEquipment["Damage"] + soldier.meridianDamage;
			defence 	= soldier.getTotalDefence();// soldier.Defence + soldier.bonusEquipment["Defence"] + soldier.meridianDefence;
			critical 	= soldier.getTotalCritical();// soldier.Critical + soldier.bonusEquipment["Critical"] + soldier.meridianCritical;
			vitality 	= soldier.getTotalVitality();// soldier.Vitality + soldier.bonusEquipment["Vitality"] + soldier.meridianVitality;
		}
		/**
		 * vẽ các thuộc tính về Rank
		 * @param	imagePrgName 			: tên ảnh cái progress bar
		 * @param	xPrg , yPrg				: tọa độ progress bar rank 
		 * @param	xIconRank , yIconRank	: tọa độ biểu tượng rank
		 * @param	xRankName , yRankName	: tọa độ tên cấp độ ,vd "Đại đệ tử"
		 * @param	xPercent , yPercent		: tọa độ của text tỉ lệ , vd " 17/50 "
		 * @param	format					: format cho 2 text o tren
		 */
		public function addRankProperties(imagePrgName:String,
											xPrg:int, yPrg:int,
											xRankName:int, yRankName:int,
											xPercent:int, yPercent:int,
											format:TextFormat):void
		{
			_hasRankProperties = true;
			prgRank = _parent.AddProgress("idPrgRank", imagePrgName, xPrg, yPrg, null, true);
			tfRankName = _parent.AddLabel("", xRankName, yRankName,0xffffff,1,0x000000);
			tfPercent = _parent.AddLabel("", xPercent, yPercent,0xffffff,1,0x000000);
			tfRankName.defaultTextFormat = tfPercent.defaultTextFormat = format;
		}
		/**
		 * cập nhật Rank
		 * @param	soldier
		 */
		private function updateRankProperties(soldier:FishSoldier):void 
		{
			var percent:Number = soldier.RankPoint / soldier.MaxRankPoint;
			prgRank.setStatus(percent);
			tfRankName.text = "Cấp " + soldier.Rank + " - " + 
						Localization.getInstance().getString("FishSoldierRank" + soldier.Rank);
			tfPercent.text = Ultility.StandardNumber(soldier.RankPoint) + " / " + 
						Ultility.StandardNumber(soldier.MaxRankPoint);
		}
		
		/**
		 * thêm vào cái biểu tượng cấp
		 * @param	xIconRank , yIconRank : tọa độ của cái biểu tượng cấp
		 */
		public function addRankIcon(xIconRank:int, yIconRank:int):void
		{
			_hasIconRank = true;
			icRank = _parent.AddImage("", "", xIconRank, yIconRank);
		}
		
		/**
		 * cập nhật cái biểu tượng cấp
		 * @param	soldier
		 */
		private function updateRankIcon(soldier:FishSoldier):void 
		{
			var imgName:String;
			if (soldier.Rank > 13) {
				imgName = "Rank13";
			}
			else {
				imgName = "Rank" + _soldier.Rank;
			}
			icRank.LoadRes(imgName);
		}
		/**
		 * lấy tên mặc định của cá
		 * @param	element : hệ của cá
		 * @return
		 */
		private function getNameDefault(element:int):String
		{
			var sElement:String = "";
			switch(element) {
				case 1:
					sElement = "Kim";
				break;
				case 2:
					sElement = "Mộc";
				break;
				case 3:
					sElement = "Thổ";
				break;
				case 4:
					sElement = "Thủy";
				break;
				case 5:
					sElement = "Hỏa";
				break;
			}
			return "Tiểu " + sElement + " Ngư";
		}
	}
}

















