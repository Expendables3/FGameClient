package Logic 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import GameControl.GameController;
	
	/**
	 * Trong game, các đối tượng sẽ được đặt ở các lớp(layer) khác nhau.
	 * Lớp(layer) trên đè lên lớp(layer) dưới, các đối tượng nằm ở lớp(layer)
	 * dưới sẽ bị che khuất bởi các đối tượng nằm ở lớp(layer) trên.
	 * @author tuan
	 */
	public class Layer extends Sprite
	{
		private var Fog:Sprite = null;
		
		/**Chỉ số lớp(layer)*/
		public var IdLayer:int;
		
		/**
		 * Phương thức khởi tạo của layer
		 * @param chỉ số của layer, chỉ số càng thấp thì layer càng nằm dưới. Thấp nhất là layer 0.
		 */
		public function Layer(idLayer:int) 
		{
			IdLayer = idLayer;
		}
		
		public function get fog():Sprite
		{
			return Fog;
		}
		
		/**
		* Thiết lập vị trí của layer
		* @param x vị trí theo phương x
		* @param y vị trí theo phương y
		**/ 
		public function SetPos(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		
		/**
		* Cho phép disable các layer nằm dưới đi
		* @param độ phủ của layer lên các layer nằm dưới. Nằm trong khoảng từ 0 -> 1.
		* Càng lớn thì các layer nằm dưới càng bị mờ.
		**/ 
		public function ShowDisableScreen(alpha:Number):void
		{
			var ScreenWidth:int = stage.stageWidth;
			var ScreenHeight:int = stage.stageHeight;
			var w:int = stage.fullScreenWidth;
			var h:int = stage.fullScreenHeight;
			
			if (Fog != null)
				removeChild(Fog);
				
			Fog = new Sprite();
			Fog.graphics.beginFill(0x000000, alpha);
			Fog.graphics.drawRect(0, 0, Constant.MAX_WIDTH, Constant.MAX_HEIGHT);
			Fog.graphics.endFill();
			addChildAt(Fog, 0);
		}
		
		
		/**
		* Bỏ trạng thái disable của các layer nằm dưới đi
		**/ 
		public function HideDisableScreen():void
		{
			if (Fog != null)
			{
				removeChildAt(0);
				Fog = null;
			}
		}
		
		public function PanX(dis:int):void
		{
			this.x += dis;
		}	
		
		public function PanY(dis:int):void
		{
			this.y += dis;
		}	
		
		
		public function Empty():void
		{
			var i:int;
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			Fog = null;
		}
		
		public function ShowTutorialScreen(x:int, y:int, radius:int):void
		{
			var ScreenWidth:int = stage.stageWidth;
			var ScreenHeight:int = stage.stageHeight;
			
			if (Fog != null)
				removeChild(Fog);
				
			Fog = new Sprite();
			addChild(Fog);
			Fog.graphics.clear();
			Fog.graphics.beginFill(0x000000, 0.5);
			Fog.graphics.drawRect(0, 0, ScreenWidth, ScreenHeight);	
			Fog.graphics.drawCircle(x, y, radius);
			Fog.graphics.endFill();
			
			Fog.mouseEnabled  = false;
			Fog.mouseChildren = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;

		}
	}

}