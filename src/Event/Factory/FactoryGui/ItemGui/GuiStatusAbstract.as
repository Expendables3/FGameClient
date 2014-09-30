package Event.Factory.FactoryGui.ItemGui 
{
	import Event.EventNoel.NoelGui.FishNoel.GuiFishBlood;
	import flash.display.Sprite;
	import GUI.component.Container;
	import Logic.Layer;
	import Logic.LayerMgr;
	
	/**
	 * Cái gui sẽ hiển thị cùng với ImgObject
	 * @author HiepNM2
	 */
	public class GuiStatusAbstract extends Container 
	{
		public var IsVisible:Boolean;
		public var hasUpdate:Boolean;
		public function GuiStatusAbstract(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "GuiStatusAbstract";
		}
		public static function createGuiStatus(type:String, parent:Object, imgName:String, 
												x:int = 0, y:int = 0, 
												isLinkAge:Boolean = true, 
												imgAlign:String = ALIGN_LEFT_TOP,
												toBitmap:Boolean = false):GuiStatusAbstract
		{
			switch(type)
			{
				case "FishCommon":
				case "FishFast":
				case "FishBoss":
					return new GuiFishBlood(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			}
			return new GuiStatusAbstract(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
		}
		public virtual function Show(iLayer:int = Constant.GUI_MIN_LAYER):void
		{
			Clear();
			if (Parent == null)
			{
				var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
				Parent = layer as Sprite;
			}
			initGui();
			IsVisible = true;
		}
		protected virtual function initGui():void { }
		public virtual function updateDataGui(data:Object):void { }
		protected virtual function onHideGui():void { }
		public virtual function initData(data:Object):void { }
		public virtual function Hide():void
		{
			Clear();
			onHideGui();
			IsVisible = false;
		}
		
	}

}




























