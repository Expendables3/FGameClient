package Logic 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author tuan
	 */
	public class LayerMgr
	{
		private var LayerArr:Array = [];
		private static var instance:LayerMgr = new LayerMgr;		
		
		
		/**Phương thức khởi tạo*/
		public function LayerMgr() 
		{
			
		}
		
		/**
		 * Lấy một thể hiện chung của lớp LayerMgr
		 * <br>Thể hiện này mang tính chất gần như 1 biến toàn cục </br>
		 */
		public static function getInstance():LayerMgr
		{
			if(instance == null)
			{
				instance = new LayerMgr;
			}
				
			return instance;
		}
		
		
		/**
		 * Thêm 1 layer vào trong game
		 * @param mainStage là stage chính của game
		 */
		public function AddLayer(mainStage:Stage):Layer
		{
			var layer:Layer = new Layer(LayerArr.length);
			layer.x = 0;
			layer.y = 0;
			mainStage.addChild(layer);
			LayerArr.push(layer);			
			return (LayerArr[LayerArr.length - 1] as Layer);
		}
		
		
		/**
		 * Thêm 1 số layer vào trong game
		 * @param mainStage là stage chính của game
		 * @param numLayer số lượng layer cần add thêm
		 */
		public function AddLayers(root:Sprite, numLayer:int):void
		{
			var layer:Layer;
			for (var i:int = 0 ; i < numLayer; i++ )
			{
				layer = new Layer(LayerArr.length);
				root.addChild(layer);
				LayerArr.push(layer);
			}
			
		}
		
		
		/**
		 * Lấy 1 layer trong game theo chỉ số của layer
		 * @param iLayer chỉ số của layer cần lấy
		 */
		public function GetLayer(iLayer:int):Layer
		{
			if ( iLayer < 0 || iLayer >= LayerArr.length)
			{
				return null;
			}
			else
			{
				return (LayerArr[iLayer] as Layer);
			}
			
		}
		
		public function GetLayerIndex(obj:Object):int
		{
			var i:int;
			for (i = 0; i < LayerArr.length; i++)
			{
				if (LayerArr[i] == obj)
				{
					return i;
				}
			}
			return -1;
		}
		
		
		/**
		 * Lấy tổng số lượng layer trong game
		 */
		public function GetLayerNumber():int
		{
			return LayerArr.length;
		}
	}

}