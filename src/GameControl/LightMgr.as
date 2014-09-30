package GameControl 
{
	import Logic.BaseObject;
	import Logic.Layer;
	/**
	 * ...
	 * @author ducnh
	 */
	public class LightMgr
	{
		private static var instance:LightMgr = new LightMgr;
		public static function getInstance():LightMgr
		{
			if(instance == null)
			{
				instance = new LightMgr();
			}
				
			return instance;
		}
		
		public var Lights:Array = [];
		
		public function LightMgr() 
		{
			
		}
		
		public function AddLight(layer:Layer, x:int, y:int, width:int, height:int):void
		{
			var light:Light = new Light(layer, x, y, width, height);
			//var light:Image = new Image(layer, "Light", x, y);
			Lights.push(light);
		}
		
		public function UpdateLight():void
		{
			
			for (var i:int = 0; i < Lights.length; i++)
			{
				var light:Light = Lights[i] as Light;
				light.UpdateObject();
				light.UpdateLightSize();
			}
			
			
		}
		
	}

}