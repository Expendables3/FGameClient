package GUI.TooltipText 
{
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class TooltipTextAbstract 
	{
		private var _name:String;
		private var _usage:String;
		private var _source:String;
		
		public function TooltipTextAbstract() 
		{
			
		}
		
		public function get Name():String 
		{
			return _name;
		}
		
		public function set Name(value:String):void 
		{
			_name = value;
		}
		
		public function get Usage():String 
		{
			return _usage;
		}
		
		public function set Usage(value:String):void 
		{
			_usage = value;
		}
		
		public function get Source():String 
		{
			return _source;
		}
		
		public function set Source(value:String):void 
		{
			_source = value;
		}
		
	}

}