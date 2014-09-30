package GUI.TrainingTower.TrainingGUI 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	import GUI.TrainingTower.TrainingLogic.TrainingMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemFishSolider extends Container 
	{
		private var _fishSoldier:FishSoldier;
		private var imageSoldier:Image;
		private var drawComp:Function;
		static public var isFirstLoad:Boolean = true;
		public function ItemFishSolider(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			this.ClassName = "ItemFishSolider";
		}
		
		public function addFishSoldier(fs:FishSoldier,x:int = 0,y:int = 0,loadComp:Function=null):void 
		{
			_fishSoldier = fs;
			if (imageSoldier != null)
			{
				RemoveImage(imageSoldier);
			}
			drawComp = loadComp;
			function loadFishComp():void 
			{
				this.FitRect(150, 150, new Point(x, y));
				updateFishContent(this);
			}
			imageSoldier = AddImage("", Fish.ItemType + fs.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, x, y, true, ALIGN_CENTER_CENTER, false, loadFishComp);
			
			
			//imageSoldier.FitRect(150, 150, new Point(x, y));
			//updateFishContent();
			//_fishSoldier.UpdateFish();
			//_fishSoldier.ShowEmotion();
		}
		
		private function updateFishContent(fsImg:Image):void 
		{
			var s:String;
			var i:int;
			
			for (s in _fishSoldier.EquipmentList)
			{
				for (i = 0; i < _fishSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = _fishSoldier.EquipmentList[s][i];
					ChangeEquipment(fsImg, eq.Type, eq.imageName);
				}
			}
			
			var txtField:TextField = new TextField();
			//txtField.text = _fishSoldier.Name
			
			if (_fishSoldier.nameSoldier == null) {
				txtField.text = TrainingMgr.getInstance().getNameDefault(_fishSoldier.Element);
			}
			else {
				if (_fishSoldier.nameSoldier.length <= 0) {
					txtField.text = TrainingMgr.getInstance().getNameDefault(_fishSoldier.Element);
				}
				else {
					txtField.text = _fishSoldier.nameSoldier;
				}
			}
			
			var length:int = txtField.text.length;
			var txtFormat:TextFormat = new TextFormat("arial", 16, 0xffff00, true);
			txtField.setTextFormat(txtFormat);
			txtField.y = -60;
			txtField.x = -50;
			txtField.autoSize = TextFieldAutoSize.CENTER;
			fsImg.img.addChild(txtField);
			//imageSoldier.img.addChild(txtField);
			if (drawComp != null) {
				drawComp();
				drawComp = null;
			}
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		private function ChangeEquipment(curSoldierImg:Image, Type:String, resName:String = ""):void
		{
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
					var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
					dob.name = Type;
					child.parent.removeChild(child);
				}
				eq.loadRes(resName);
			}
		}
		
		public function removeFishSoldier():void
		{
			
		}
		
		public function get fishSoldier():FishSoldier 
		{
			return _fishSoldier;
		}
		
		public function set fishSoldier(value:FishSoldier):void 
		{
			_fishSoldier = value;
		}
		
		
		
	}

}














































