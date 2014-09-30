package GUI.ChampionLeague.LogicLeague 
{
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuideXML 
	{
		static private var _instance:GuideXML = null;
		private var _data:XML;	//dữ liệu về hướng dẫn
		private var _language:String;
		public function GuideXML() 
		{
			if(_instance != null)
			{
				throw new Error("Single cases of class instantiation error-GuideXML");
			}
			_language = "vn";
		}
		static public function getInstance():GuideXML
		{
			if (_instance == null)
			{
				_instance = new GuideXML();
			}
			return _instance;
		}
		
		public function get Data():XML 
		{
			return _data;
		}
		
		public function set Data(value:XML):void 
		{
			_data = value;
		}
		
		public function get language():String 
		{
			return _language;
		}
		
		public function set language(value:String):void 
		{
			_language = value;
		}
		
		/**
		 * Lấy về hướng dẫn
		 * @param	Type : Loại nhiệm vụ
		 * @param	level : level của dòng text
		 * @return tên nhiệm vụ
		 */
		public function getSpeech(id:String):String
		{
			var st:String;
			st = _data["language"].(@name == _language)["String"].(@id == id);
			st = st.split("\\n").join("\n");
			return st;
		}
	}

}













