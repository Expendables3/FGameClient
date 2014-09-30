package mercury
{
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import mercury.bean.MsgSend;
	
	/**
	 * ...
	 * @author Hungnm3
	 */
	public class MercuryClient extends EventDispatcher
	{
		public static const VER_1:String = "1";
		public static const VER_2:String = "2";
		private var version:String;
		private var connected:Boolean = false;
		private var ip:String;
		private var port:int;
		private var socketConnection:Socket;
		private var readBuffer:ByteArray = new ByteArray();
		private var fProcessByte:Function;
		private var numRead:int = 0;
		
		public function MercuryClient(ver:String = MercuryClient.VER_1)
		{
			// khoi tao socket connection
			try
			{
				//Security.loadPolicyFile("http://10.198.36.214/crossdomain.xml");
				this.version = ver;
				socketConnection = new Socket()
				socketConnection.addEventListener(Event.CONNECT, handleSocketConnection)
				socketConnection.addEventListener(Event.CLOSE, handleSocketDisconnection)
				socketConnection.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData)
				socketConnection.addEventListener(IOErrorEvent.IO_ERROR, handleIOError)
				socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError)
				socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError)
				switch (version)
				{
					case VER_1: 
						fProcessByte = this.processByteVer1;
						break;
					case VER_2: 
						fProcessByte = this.processByteVer2;
						break;
					default: 
						break;
				}
				
			}
			catch (e:Error)
			{
				trace(e.getStackTrace);
			}
			//socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError)
		}
		
		private function handleSecurityError(e:SecurityErrorEvent):void
		{
			trace(e.text);
		}
		
		private function handleSocketDisconnection(e:Event):void
		{
			connected = false;
			dispatchEvent(new MercuryEvent(MercuryEvent.CONNECTION_LOST, null));
		}
		
		private function handleSocketData(e:Event):void
		{
			fProcessByte.call(this);
		}
		
		// xu ly byte theo phien ban ver 1
		private function processByteVer1():void
		{
			try
			{
				var bytes:int = socketConnection.bytesAvailable
				while (--bytes >= 0)
				{
					var b:int = socketConnection.readByte()
					
					if (b != 0)
					{
						readBuffer.writeByte(b)
					}
					else
					{
						handleMessage(readBuffer.toString());
						readBuffer = new ByteArray();
					}
				}
			}
			catch (e:Error)
			{
			}
		}
		
		// xu ly byte theo phien ban ver 2
		private var header:int = -1;
		private var nByteNeed:int = 0;
		
		private function processByteVer2():void
		{
			var bytes:int = socketConnection.bytesAvailable;
			var curOffset:int = 0;
			while (curOffset < bytes)
			{
				if (nByteNeed == 0)
				{
					readBuffer.writeByte(socketConnection.readByte());
					curOffset++;
					if (readBuffer.position >= 3)
					{
						readBuffer.position = 0;
						header = readBuffer.readByte();
						nByteNeed = readBuffer.readShort();
						readBuffer.clear();
					}
				}
				else
				{
					var curLength:int = bytes - curOffset;
					if (curLength >= nByteNeed)
					{
						socketConnection.readBytes(readBuffer, readBuffer.length, nByteNeed);
						curOffset += nByteNeed;
						offerPacket();
					}
					else
					{
						socketConnection.readBytes(readBuffer, readBuffer.length, curLength);						
						curOffset += curLength;
						nByteNeed -= curLength;
					}
				}
			}
		
		}
		
		private function offerPacket():void
		{
			var p:MercuryPacket = new MercuryPacket();
			readBuffer.position = 0;
			readBuffer.readBytes(p.data);
			p.header = header;
			p.length = nByteNeed;
			dispatchEvent(new MercuryEvent(MercuryEvent.EXTENSION_RESPONSE, p));
			nByteNeed = 0;
			readBuffer.clear();
		}
		
		private function handleMessage(s:String):void
		{
			try
			{
				var obj:Object = com.adobe.serialization.json.JSON.decode(s);
				if (obj.hasOwnProperty("handler"))
				{
					if (obj["handler"] == "login")
					{
						var params:Object = {};
						params.loginOK = obj.loginOK;
						dispatchEvent(new MercuryEvent(MercuryEvent.LOGIN, params));
					}
				}
				else
				{
					dispatchEvent(new MercuryEvent(MercuryEvent.EXTENSION_RESPONSE, obj));
				}
			}
			catch (err:Error)
			{
			}
		}
		
		private function handleIOError(e:Event):void
		{
			connected = false;
			var params:Object = {};
			params.connectionOK = false;
			dispatchEvent(new MercuryEvent(MercuryEvent.CONNECTION, params));
		}
		
		private function handleSocketConnection(e:Event):void
		{
			connected = true;
			var params:Object = new Object();
			;
			params.connectionOK = true;
			dispatchEvent(new MercuryEvent(MercuryEvent.CONNECTION, params));
		
		}
		
		/**
		 * ipAdr : ip cua host
		 * port : port cua host
		 * @param	ipAdr
		 * @param	port
		 */
		public function connect(ipAdr:String, port:int = 443):void
		{
			if (!connected)
			{
				this.ip = ipAdr
				this.port = port
				socketConnection.connect(ip, port);
			}
			else
				trace("*** ALREADY CONNECTED ***")
		}
		
		public function disconnect():void
		{
			try
			{
				socketConnection.close();
				removeAllEvent();
				dispatchEvent(new MercuryEvent(MercuryEvent.CONNECTION_LOST, null));
				connected = false;
			}
			catch (e:Error)
			{
				//dispatchEvent(new MercuryEvent(MercuryEvent.CONNECTION_LOST, null));
				trace(e.getStackTrace());
			}
		}
		
		/**
		 * close connection and don't dispatch event
		 */
		public function close():void
		{
			if (socketConnection != null)
			{				
				try
				{
					socketConnection.close();
				}
				catch (e:Error)
				{
					trace("*** CONNECTION ALREADY CLOSE ***");
				}
				removeAllEvent();
				connected = false;
			}
			else
			{
				throw new Error("NULL POINTER ERROR");
			}
		}
		
		private function removeAllEvent():void 
		{
			socketConnection.removeEventListener(Event.CONNECT, handleSocketConnection)
			socketConnection.removeEventListener(Event.CLOSE, handleSocketDisconnection)
			socketConnection.removeEventListener(ProgressEvent.SOCKET_DATA, handleSocketData)
			socketConnection.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError)
			socketConnection.removeEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError)
			socketConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		}
		
		public function isConnected():Boolean
		{
			return connected;
		}
		
		/**
		 * object gui di co dang
		 * cmd : lenh yeu cau
		 * params : tham so di kem neu co
		 * exName : ten extension xu ly logic
		 */
		public function sendXMessage(cmd:String, params:Object, exName:String = ""):void
		{
			var json:Object = new Object();
			json.ext = exName;
			json._cmd = cmd;
			json.params = params;
			//trace(JSON.encode(json))
			var byteBuff:ByteArray = new ByteArray();
			byteBuff.writeMultiByte(com.adobe.serialization.json.JSON.encode(json), "utf-8")
			sendRawBytes(byteBuff);
		
		}
		
		public function sendMsg(msgSend:MsgSend, priority:int):void
		{
			var p:MercuryPacket = new MercuryPacket();
			p.header = priority;
			p.data = msgSend.toByte();
			p.length = p.data.length;
			sendPacket(p);
		
		}
		
		public function login(username:String, password:String):void
		{
			var json:Object = new Object();
			json.handler = "login";
			json.username = username;
			json.password = password;
			var byteBuff:ByteArray = new ByteArray();
			byteBuff.writeMultiByte(com.adobe.serialization.json.JSON.encode(json), "utf-8")
			//socketConnection.writeBytes(byteBuff);
			//socketConnection.flush();
			sendRawBytes(byteBuff);
		}
		
		private function sendRawBytes(byteBuffer:ByteArray):void
		{
			var sizeByte:int = byteBuffer.length;
			if (sizeByte > 65535)
			{
				trace("Send failure. Packet is too big");
				return;
			}
			else
			{
				socketConnection.writeShort(sizeByte);
				socketConnection.writeBytes(byteBuffer);
				socketConnection.flush();
			}
		}
		
		private function sendPacket(p:MercuryPacket):void
		{
			var bytes:ByteArray = MercuryPacket.packData(p);
			//var halfLen:int = bytes.length / 2;
			//bytes.position = 0;
			//var b1:ByteArray = new ByteArray();
			//bytes.readBytes(b1, 0, halfLen);
			//socketConnection.writeBytes(b1);	
			//socketConnection.flush();	
			//b1.clear();
			//bytes.readBytes(b1);
			//socketConnection.writeBytes(b1);	
			//socketConnection.flush();	
			socketConnection.writeBytes(bytes);
			socketConnection.flush();
		
		}
	
	}

}