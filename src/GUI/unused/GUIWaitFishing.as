package GUI.unused 
{
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIWaitFishing extends BaseGUI
	{
		
		private const BUTTON_GUI_FISHING_CANNOT_CLOSE:String = "ButtonClose";
		public var eff:SwfEffect;
		//private const timeount:Number = 10;
		private var timeStart:Number = Number.MAX_VALUE;
		private var show:Boolean = false;
		private var x:int;
		private var y:int;
		
		public function GUIWaitFishing(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIWaitFishing";
		}
		
		public function setPos(image:Sprite):void 
		{
			var dx:int = 0;
			var dy:int = 0;
			if (GameLogic.getInstance().user.AvatarType == 1)
			{
				dx = -76;
				dy = 61;
			}
			if (GameLogic.getInstance().user.AvatarType == 0)
			{
				dx = -58;
				dy = 70;
			}
			x = image.x + dx;
			y = image.y + dy;
			
			//if (GameLogic.getInstance().user.BoatType == GUICharacter.SHIP_TYPE_NOMARL)
			//{
				//y -= 52;
			//}
			
		}
		
		/**
		 * Khởi tạo GUI
		 */
		public override function InitGUI():void 
		{
			LoadRes("");
			show = true;
			//var guiLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			//var objLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			//var pos:Point = objLayer.globalToLocal(objLayer.localToGlobal(new Point(506, 270)));
			
			eff = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffWaitFishing", null, x, y, false, true);
			timeStart = GameLogic.getInstance().CurServerTime;
		}
		
		/**
		 * Hàm thực hiện kiểm tra nếu quá thời hạn thì tự xóa GUI
		 * @param	timeount
		 */
		public function UpdateTimeout(timeount:int = 100):void 
		{
			var timeNow:Number = GameLogic.getInstance().CurServerTime;
			if (timeNow - timeStart > timeount && show)	GUIHide();
		}
		
		/**
		 * Hàm thực hiện ẩn GUI đi và cập nhật các thông tin cần thiết khi câu cá xong
		 */
		public function GUIHide():void 
		{
			eff.FinishEffect();
			GameLogic.getInstance().finishFishing = false;
			GameLogic.getInstance().FishingDataReceive = false;
			GuiMgr.getInstance().GuiMain.btnHook.SetEnable(true);
			Hide();
		}
	}

}