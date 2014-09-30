package Data 
{
	/**
	 * ...
	 * @author dongtq
	 */
	public class Tips 
	{
		private static var instance:Tips;
		private var xml:XML;
		private var _language:String;
		
		public function Tips(_xml:XML) 
		{
			this.xml = _xml;
			language = "vn";
			instance = this;
		}
		
		public static function getInstance(xml:Object = null):Tips
		{
			var _x:XML = XML(xml);
			if(instance == null)
			{
				instance = new Tips(_x);
			}				
			return instance;
		}
		
		public function getTip(id:String):String
		{
			var st:String;
			st = xml.language.(@name == language).String.(@id == id);
			st = st.split("\\n").join("\n");
			return st;
		}
		
		public function getWrongText():String
		{
			return xml.wrongText;
		}
		
		public function get language():String 
		{
			return _language;
		}
		
		public function set language(value:String):void 
		{
			_language = value;
		}
	}

}