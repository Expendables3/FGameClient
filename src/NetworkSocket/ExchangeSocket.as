package NetworkSocket
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import mercury.bean.MsgSend;
	import mercury.MercuryClient;
	import mercury.MercuryConst;
	import mercury.MercuryEvent;
	import mercury.MercuryPacket;
	import NetworkSocket.packet.NetworkEvent;

		
	/**
	 * dùng để gửi và nhận gói tin
	 * @author Tien Ga
	 * 24.08.2010
	 */
	public class ExchangeSocket extends EventDispatcher
	{		
		public static const TIMER_RECONNECT:int = 10000;
		public static var SERVER_IP:String = "";
		public static var SERVER_PORT:int = 0;
		private static var instance:ExchangeSocket;
		public var client:MercuryClient = null;
		private var timer:Timer;
		public static var fSendCalback:Function = null;		
		public var loginErr:int;
		
		public function ExchangeSocket() 
		{
			client = new MercuryClient(MercuryClient.VER_2);
			client.addEventListener(MercuryEvent.CONNECTION, onConnection);
			client.addEventListener(MercuryEvent.CONNECTION_LOST, onConnectionLost);
			client.addEventListener(MercuryEvent.EXTENSION_RESPONSE, onServerResp);
			client.addEventListener(MercuryEvent.LOGIN, onLogin);
			
			this.addEventListener(ClientEvent.ON_CONNECT_SUCCESS, onConnectSuccess);
			this.addEventListener(ClientEvent.ON_CONNECT_ERROR, onConnectError);
			this.addEventListener(ClientEvent.ON_DISCONNECT, onDisconnect);
			this.addEventListener(ClientEvent.ON_GAME_MESSAGE, HandleGameMsg);			
			this.addEventListener(ClientEvent.ON_LOGIN_FAIL, onLoginFail);
			this.timer = new Timer(TIMER_RECONNECT, 0);
			this.timer.addEventListener(TimerEvent.TIMER, reconnect);
		}
		
		private function reconnect(e:Event):void 
		{
			connect(SERVER_IP, SERVER_PORT);
		}
		
		private function onLoginFail(e:Event):void 
		{
			
		}
		
		private function HandleGameMsg(e:Event):void 
		{
			
		}
		
		private function onDisconnect(e:Event):void 
		{
			trace("disconnected với server");
			timer.start();
		}
		
		private function onConnectError(e:Event):void 
		{
			trace("lỗi, ko thể kết nối");
		}
		
		private function onConnectSuccess(e:Event):void 
		{
			trace("đã connect tới server", e.currentTarget.client);
			timer.stop();
		}
		
		public static function getInstance():ExchangeSocket
		{
			if(instance == null)
			{
				instance = new ExchangeSocket();
			}
				
			return instance;
		}
		
		public function connect(gameServer:String, port:int):void
		{
			SERVER_IP = gameServer;
			SERVER_PORT = port;
			try
			{
				client.connect(gameServer, port);
			}
			catch (e:Error)
			{
				trace("ko connect dc");
			}
		}
		
		public function disconnect():void
		{
			if (client.isConnected())
			{
				client.close();
			}
			client = new MercuryClient(MercuryClient.VER_2);
			client.addEventListener(MercuryEvent.CONNECTION, onConnection);
			client.addEventListener(MercuryEvent.CONNECTION_LOST, onConnectionLost);
			client.addEventListener(MercuryEvent.EXTENSION_RESPONSE, onServerResp);
			client.addEventListener(MercuryEvent.LOGIN, onLogin);
			
			trace("disconnect khỏi server");
		}
		
		public function Send(SendObject:MsgSend):void
		{
			if (!client.isConnected())
			{
				return;
			}
			// ban su kien gui goi tin
			var e:NetworkEvent = new NetworkEvent(ClientEvent.ON_SEND_GAME_MESSAGE);
			e.cmdID = SendObject.getCmdId();
			e.cmdSend = SendObject;
			if (ExchangeSocket.fSendCalback != null)
			{
				ExchangeSocket.fSendCalback(e);
			}			
			
			try
			{
				client.sendMsg(SendObject,MercuryConst.HIGHTEST_PRIORITY);
			}
			catch (e:Error)
			{
				var event:NetworkEvent = new NetworkEvent(ClientEvent.ON_GAME_MESSAGE_ERROR);
				dispatchEvent(event);
			}
		}
		
		private function onLogin(e:MercuryEvent):void 
		{
			var event:Event
			if ("loginOK" in e.params)
			{				
				event = new Event(ClientEvent.ON_LOGIN);
			}
			else
			{
				event = new Event(ClientEvent.ON_LOGIN_FAIL);
			}
			dispatchEvent(event);
		}
		
		private function onServerResp(e:MercuryEvent):void 
		{
			var sizeOfInt:int = 4;
			var event:NetworkEvent = new NetworkEvent(ClientEvent.ON_GAME_MESSAGE);
			var p:MercuryPacket = e.params as MercuryPacket;
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(p.data,1,sizeOfInt);
			bytes.position = 0;
			var cmdId:int = bytes.readInt();
			event.cmdID = cmdId
			event.cmdReceive = p.data;
			dispatchEvent(event);
			
			// Các gói tin server trả về đã có Logic tournament bắt sự kiện ClientEvent.ON_GAME_MESSAGE
		}	
		
		private function onConnectionLost(e:MercuryEvent):void 
		{
			var event:Event = new Event(ClientEvent.ON_DISCONNECT);
			dispatchEvent(event);
		}
		
		private function onConnection(e:MercuryEvent):void 
		{
			if (e.currentTarget == client)
			{
				var event:Event;
				if (client.isConnected())
				{
					event = new Event(ClientEvent.ON_CONNECT_SUCCESS);
					dispatchEvent(event);
				}
				else
				{
					event = new Event(ClientEvent.ON_CONNECT_ERROR);
					dispatchEvent(event);
				}
			}
			
		}
	}
}