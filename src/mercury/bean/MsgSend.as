package mercury.bean 
{
	import com.adobe.serialization.json.JSON;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mercury.bean.MsgSend;
	import mercury.MercuryConst;
	import mercury.MercuryPacket;
	import org.as3commons.reflect.ReflectionUtils;
	import org.as3commons.reflect.Type;
	/**
	 * ...
	 * @author hungnm3
	 */
	public class MsgSend 
	{
		protected var cmdId:int;
		public function MsgSend() 
		{
			
		}
		
		public function toByte():ByteArray {			
			var i:int;
			var j:int;
			var fields:Array = MercuryPacket.getFieldListSpec(this);			
			var buffer:ByteArray = new ByteArray();
			var tempBuff:ByteArray;
			for ( i = 0; i < fields.length; i++) {
				var code:int = MercuryPacket.findClassCode(this[fields[i].fname]);	
				buffer.writeByte(code);				
				switch(code) {
					case MercuryConst.CODE_INT_TYPE:						
							buffer.writeInt(this[fields[i].fname]);
							break;
							
					case MercuryConst.CODE_INT_ARR_TYPE:
							var tempInt:Vector.<int> = Vector.<int>(this[fields[i].fname]);
							buffer.writeShort(tempInt.length);
							for ( j = 0; j < tempInt.length; j++ )
								buffer.writeInt(tempInt[j]);
							break;
							
					case MercuryConst.CODE_FLOAT_TYPE:
							buffer.writeFloat(this[fields[i].fname]);
							break;
							
					case MercuryConst.CODE_FLOAT_ARR_TYPE:
							var tempFloat:Vector.<Number>  = Vector.<Number>(this[fields[i].fname]);
							buffer.writeShort(tempFloat.length);
							for ( j = 0; j < tempFloat.length; j++ )
								buffer.writeFloat(tempFloat[j]);
							break;
					
					case MercuryConst.CODE_BOOLEAN_TYPE:
							buffer.writeBoolean(this[fields[i].fname]);
							break;
							
					case MercuryConst.CODE_BOOLEAN_ARR_TYPE:
							var tempBool:Vector.<Boolean> = Vector.<Boolean>(this[fields[i].fname]);
							buffer.writeShort(tempBool.length);
							for ( j= 0; i < tempBool.length; j++ )
								buffer.writeBoolean(tempBool[j]);
							break;	
					case MercuryConst.CODE_STRING_TYPE:
							var str:String = String(this[fields[i].fname]);								
							tempBuff = new ByteArray();
							tempBuff.writeMultiByte(str, MercuryConst.CHARSET_ENCODE);	
							buffer.writeShort(tempBuff.length);
							buffer.writeBytes(tempBuff, 0, tempBuff.length);
								
							break;
					case MercuryConst.CODE_STRING_ARR_TYPE:
							var arrString:Vector.<String> = Vector.<String>(this[fields[i].fname]);
							buffer.writeShort(arrString.length);
							for (var k:int = 0; k < arrString.length; k++ ) {
								tempBuff = new ByteArray();
								tempBuff.writeMultiByte(arrString[k], MercuryConst.CHARSET_ENCODE);
								buffer.writeShort(tempBuff.length);
								if (tempBuff.length > 0) {
									buffer.writeBytes(tempBuff, 0, tempBuff.length);
								}								
							}
							break;
							
					case MercuryConst.CODE_OBJECT_ARR_TYPE:
						var arrObject:Vector.<*> = Vector.<*>(this[fields[i].fname]);							
						buffer.writeShort(arrObject.length);
						for (var n:int = 0; n < arrObject.length; n++ ) 
						{
							tempBuff = MercuryPacket.toByte(arrObject[n]);
							buffer.writeShort(tempBuff.length);
							buffer.writeBytes(tempBuff, 0, tempBuff.length);
						}
						break;
						
					case MercuryConst.CODE_OBJECT_TYPE:
						var object:* = this[fields[i].fname]				
						tempBuff = MercuryPacket.toByte(object);
						buffer.writeShort(tempBuff.length);
						buffer.writeBytes(tempBuff, 0, tempBuff.length);						
						break;
				}				
			}	
			buffer.position = 0;
			return buffer;		
		}
		
		public function getCmdId():int
		{
			return cmdId;
		}
	}

}