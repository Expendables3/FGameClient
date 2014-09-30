package  
{
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;

	
	/**
	 * ...
	 * @author toantn
	 */
	

	public class RemotingService extends NetConnection
	{
		
		public function RemotingService(url:String) 
		{
			objectEncoding = ObjectEncoding.AMF3;
			connect(url);		
			
			// toantn add for security network
			
			var my_header:Object = new Object();
			my_header["sign_user"] = Main.uId ;
			my_header["session_id"] = Main.sessionId ;
			addHeader("GSN_USER", false, my_header);
		}
		
	}

}