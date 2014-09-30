package GUI.Expedition.ExpeditionLogic 
{
	/**
	 * Lớp điều khiển mọi hành động của viễn chinh
	 * @author HiepNM2
	 */
	public class ExpeditionXML 
	{
		static private var _instance:ExpeditionXML = null;
		private var _nameData:XML;	//dữ liệu về tên quest
		private var _language:String;
		
		public function ExpeditionXML(xml:XML = null ) 
		{
			if(_instance != null)
			{
				throw new Error("Single cases of class instantiation error-ExpeditionMgr");
			}
			_language = "vn";
		}
		
		static public function getInstance():ExpeditionXML
		{
			if (_instance == null)
			{
				_instance = new ExpeditionXML();
			}
			return _instance;
		}
		
		public function get Data():XML 
		{
			return _nameData;
		}
		
		public function set Data(value:XML):void 
		{
			_nameData = value;
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
		 * Lấy về nhiệm vụ viễn chinh
		 * @param	Type : Loại nhiệm vụ
		 * @param	id : id của nhiệm vụ
		 * @return tên nhiệm vụ
		 */
		public function getQuestName(Type:String, id:int):String
		{
			var str:String = Type + id;
			var st:String;
			st = _nameData.language.(@name == _language).Task.(@id == str);
			st = st.split("\\n").join("\n");
			return st;
		}
		
		/**
		 * 
		 * @param	id: id trong file xml
		 * @return	string
		 */
		public function getString(id:String):String
		{
			var st:String;
			st = _nameData.language.(@name == _language).String.(@id == id);
			st = st.split("\\n").join("\n");
			return st;
		}
	}

}
























