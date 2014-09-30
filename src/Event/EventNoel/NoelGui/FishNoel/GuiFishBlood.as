package Event.EventNoel.NoelGui.FishNoel 
{
	import Event.Factory.FactoryGui.ItemGui.GuiStatusAbstract;
	import flash.display.Sprite;
	import GUI.component.ProgressBar;
	
	/**
	 * Gui để hiển thị thanh máu cho con cá
	 * @author HiepNM2
	 */
	public class GuiFishBlood extends GuiStatusAbstract 
	{
		private const ID_PRG_BLOOD:String = "idPrgBlood";
		private var prgBlood:ProgressBar;
		private var _blood:Number;
		private var _maxBlood:Number;
		private var xFish:Number;
		private var yFish:Number;
		private var wFish:Number;
		private var hFish:Number;
		public function GuiFishBlood(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "GuiFishBlood";
		}
		//khởi tạo về số liệu máu
		override public function initData(data:Object):void 
		{
			_blood = data["Blood"];
			_maxBlood = data["MaxBlood"];
			xFish = data["xFish"];
			yFish = data["yFish"];
			wFish =  data["wFish"];
			hFish = data["hFish"];
		}
		override protected function initGui():void 
		{
			img = new Sprite();
			(Parent as Sprite).addChild(img);
			SetAlign(ALIGN_LEFT_TOP);
			removeAllEvent();
			prgBlood = AddProgress(ID_PRG_BLOOD, "GuiHuntFish_PrgBlood", (wFish - 55) / 2 - wFish / 2, - hFish / 2 - 10);
			prgBlood.setStatus(_blood / _maxBlood);
			img.hitArea = null;
		}
		override public function updateDataGui(data:Object):void 
		{
			_blood = data["Blood"];
			var percent:Number = _blood / _maxBlood;
			prgBlood.setStatus(_blood / _maxBlood);
		}
	}

}





















