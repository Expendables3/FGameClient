package NetworkSocket.packet 
{
	/**
	 * ...
	 * @author ducnh
	 */
	import flash.external.ExternalInterface;

	public class HTTPCookies
	{
		public static function getCookie(key:String):*
		{
			return ExternalInterface.call("getCookie", key);
		}

		public static function setCookie(key:String, val:*):void
		{
			ExternalInterface.call("setCookie", key, val);
		}
	}


}