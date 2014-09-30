package mercury.bean 
{
	import flash.utils.ByteArray;
	import mercury.MercuryConst;
	import mercury.MercuryPacket;
	/**
	 * ...
	 * @author hungnm3
	 */
	public class MsgRecieve 
	{
		public var cmdId:int;
		public function MsgRecieve() 
		{
			
		}
		
		public function setData(buffer:ByteArray):void 
		{	
			var i:int;
			var j:int;
			var fields:Array = MercuryPacket.getFieldListSpec(this);	
			var tempBuffer:ByteArray = new ByteArray();
			for ( i = 0; i < fields.length; i++) {
				
				var code:int = buffer.readByte();
				var length:int;
				switch(code) {
					case MercuryConst.CODE_INT_TYPE:						
							this[fields[i].fname] = buffer.readInt();	
							break;
							
					case MercuryConst.CODE_INT_ARR_TYPE:
							length = buffer.readShort();
							var tempInt:Vector.<int> = new Vector.<int>(length);
							for ( j = 0; j < tempInt.length; j++ )
							{								
								tempInt[j] = buffer.readInt();
							}
							this[fields[i].fname] = tempInt;
							break;
							
					case MercuryConst.CODE_FLOAT_TYPE:
							this[fields[i].fname] = buffer.readFloat();
							break;
							
					case MercuryConst.CODE_FLOAT_ARR_TYPE:
							length = buffer.readShort();
							var tempFloat:Vector.<Number>  = new Vector.<Number>(length);
							for ( j = 0; j < tempFloat.length; j++ )
								tempFloat[j] = buffer.readFloat();
							this[fields[i].fname] = tempFloat;
							break;
					
					case MercuryConst.CODE_BOOLEAN_TYPE:
							this[fields[i].fname] = buffer.readBoolean();
							break;
							
					case MercuryConst.CODE_BOOLEAN_ARR_TYPE:
							length = buffer.readShort();
							var tempBool:Vector.<Boolean> = new Vector.<Boolean>(length);
							for ( j= 0; i < tempBool.length; j++ )
								tempBool[j] = buffer.readBoolean();								
							this[fields[i].fname] = tempBool;
							break;	
					case MercuryConst.CODE_SHORT_TYPE:
							this[fields[i].fname] = buffer.readShort();
							break;
					case MercuryConst.CODE_SHORT_ARR_TYPE:
							length = buffer.readShort();
							var tempShort:Vector.<int> = new Vector.<int>(length);
							for ( j= 0; i < tempBool.length; j++ )
								tempShort[j] = buffer.readShort();	
							this[fields[i].fname] = tempShort;
							break;
					
					case MercuryConst.CODE_STRING_TYPE:
							tempBuffer.clear();
							length = buffer.readShort();
							buffer.readBytes(tempBuffer, 0, length);
							tempBuffer.position = 0;	
							//trace(MercuryPacket.getBytes(bytes));
							this[fields[i].fname] = tempBuffer.toString();
							break;
					case MercuryConst.CODE_STRING_ARR_TYPE:
							tempBuffer.clear();
							length = buffer.readShort();
							var arrString:Vector.<String> =  new Vector.<String>(length);
							for (j = 0; j < arrString.length; j++ ) {
								length = buffer.readShort();
								if (length > 0) {
									buffer.readBytes(tempBuffer, 0, length);
									tempBuffer.position = 0;
									arrString[j] = tempBuffer.toString();
									tempBuffer.clear();
								}else {
									arrString[j] = "";
								}
								
							}
							this[fields[i].fname] = arrString;
							break;
							
					case MercuryConst.CODE_OBJECT_TYPE:
						tempBuffer.clear();
						length = buffer.readShort();
						buffer.readBytes(tempBuffer, 0, length);
						MercuryPacket.toObject(tempBuffer, this[fields[i].fname],this[fields[i].fname]);
						break;
						
					case MercuryConst.CODE_OBJECT_ARR_TYPE:
						tempBuffer.clear();
						length = buffer.readShort();						
						var infoClass:Object = this[fields[i].fname][0];
						var c:Class = MercuryPacket.getClass(infoClass);
						var arrObject:Vector.<*> =  new Vector.<*>(length);
						for (j = 0; j < arrObject.length; j++ ) 
						{
							length = buffer.readShort();								
							buffer.readBytes(tempBuffer, 0, length);
							tempBuffer.position = 0;							
							arrObject[j] = new c();
							MercuryPacket.toObject(tempBuffer, arrObject[j],infoClass);
							tempBuffer.clear();							
								
						}
						this[fields[i].fname] = arrObject;
						break;
				}				
			}	
			buffer.position = 0;
		}
		
	}

}