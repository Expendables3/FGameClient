package Data 
{
	/**
	 * ...
	 * @author minht
	 */
	public class Localization
	{
		private static var instance:Localization;
		private var _data:XML;
		private var _language:String;
		
		public function Localization(xml:XML)
		{
			if(instance != null)
			{
				throw new Error("Single cases of class instantiation error-Localization");
			}
			setLanguage("vn");
			data = xml;
		}
		public static function getInstance(xml:Object = null):Localization
		{
			var _x:XML = XML(xml);
			if(instance == null)
			{
				instance = new Localization(_x);
			}				
			return instance;
		}		
		
		public function set data(value:XML):void
		{
			_data = value;
		}
		public function get data():XML
		{
			return _data;
		}		
		
		public function setLanguage(lang:String):void
		{
			_language = lang;
		}
		
		public function getLanguage():String
		{
			return _language;
		}
		
		public function getVersion():int
		{
			var returnValue:int;
			if(data != null)
				returnValue = int(data.version.@xmlVer);
			
			if(!returnValue)
			{
				throw new Error("Request address error");
			}
			return returnValue;
		}
		
		/**
		 * 
		 * @param	id: id trong file xml
		 * @return	string
		 */
		public function getString(id:String):String
		{
			var st:String;
			st = data.language.(@name == _language).String.(@id == id);
			st = st.split("\\n").join("\n");
			return st;
		}
	}
}