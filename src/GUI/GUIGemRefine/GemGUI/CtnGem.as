package GUI.GUIGemRefine.GemGUI 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.geom.Point;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GUIGemRefine.GemLogic.Gem;
	import Logic.Ultility;
	
	/**
	 * Container chứa 1 viên đan ở khu đan
	 * @author HiepNM2
	 */
	public class CtnGem extends Container 
	{
		private const X0:int = 75;
		private const Y0:int = 5;
		private var _gem:Gem;
		public function get gem():Gem
		{
			return _gem;
		}
		private var _index:int;
		public function get X():int
		{
			return X0 + (_index % 5) * 55;
		}
		public function get Y():int
		{
			return Y0 + ((int)(_index / 5)) * 55;
		}
		public function set Index(index:int):void
		{
			_index = index;
			if (_gem)
			{
				IdObject = "idCell_" + _gem.Element + "_" + _gem.Level + "_" + _gem.Num + "_" + _gem.DayLife + "_" + _index;
			}
			SetPos(this.X, this.Y);
		}
		private var _objStatic:Object;
		public var hasGem:Boolean = false;
		public function CtnGem(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "CtnGem";
		}
		public function initData(gem:Gem, objStatic:Object = null,index:int = -1):void
		{
			_gem = gem;
			_objStatic = objStatic;
			_index = index;
		}
		public function drawGem(eventHandler:GUIGemRefine = null):void
		{
			SetPos(this.X, this.Y);
			if (_gem == null)
			{
				return;
			}
			if (hasGem)
			{
				ClearComponent();
			}
			hasGem = true;
			IdObject = "idCell_" + gem.Element + "_" + gem.Level + "_" + gem.Num + "_" + gem.DayLife + "_" + _index;
			EventHandler = eventHandler;
			img.buttonMode = true;
			//add ảnh gem + ảnh phế
			var imName:String = Ultility.GetNameImgPearl(gem.Element, gem.Level);
			var imgGem:Image = AddImage("", imName, 0, 0);
			if (gem.Level <= 10)
			{
				imgGem.FitRect(45, 45, new Point(0, 0));
			}
			else if(gem.Level>=11&&gem.Level<=20)
			{
				imgGem.FitRect(53, 53, new Point(0, -5));
			}
			if (gem.IsExpired)
			{
				var imgExpired:Image = AddImage("", "GuiPearlRefine_Icon_Phe_TuLuyenNgoc", 0, 0);
				imgExpired.FitRect(40, 40, new Point(0, 0));
			}
			//thêm số lượng

			AddLabel(Ultility.StandardNumber(gem.Num), -28, 40);
			
			
			setTooltipGem();
		}
		private function setTooltipGem():void
		{
			var strTip:String = Localization.getInstance().getString("Gem" + _gem.Element);
			var type:String;
			var value:int;
			var NUM_GEM_DAY:int = ConfigJSON.getInstance().getItemInfo("Param")["NumGemDay"];
			var day:int = _gem.DayLife;
			if (_gem.Level == 0)
			{
				type = "Tán";
				strTip = strTip.replace("@Rank@", "");
			}
			else
			{
				type = "Đan";
				strTip = strTip.replace("@Rank@", "cấp " + _gem.Level);
			}
			if (_gem.IsExpired)
			{
				strTip = strTip.replace("Thời hạn còn", "Tự hủy");
				day += NUM_GEM_DAY;
			}
			strTip = strTip.replace("@Type@", type);
			value = _objStatic[_gem.Element.toString()];
			strTip = strTip.replace("@value@", value);
			strTip = strTip.replace("@day@", day);
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = strTip;
			this.setTooltip(tip);
		}
	}

}

























