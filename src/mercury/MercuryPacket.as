package mercury 
{
	import adobe.utils.CustomActions;
	import com.adobe.serialization.json.JSON;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mercury.bean.FieldInfo;
	import org.as3commons.reflect.ReflectionUtils;
	/**
	 * ...
	 * @author hungnm3
	 */
	public class MercuryPacket 
	{
		public var header:int;
		public var length:int = 0;
		public var data:ByteArray;
		public function MercuryPacket() 
		{
			data = new ByteArray();
		}
		/*
		public static function packData(packet:MercuryPacket):ByteArray {
			var buffer:ByteArray = new ByteArray();
			var fields:XMLList = describeType(packet)..variable;
			for (var i:int = 0; i < fields.length(); i++) {
				var fname:String = fields[i].@name;
				if (fname == "header"){
					buffer.writeShort(packet[fname]);
					packet.length += 2;
					continue;
				}
				if (fname == "length"){
					buffer.position += 2;
					packet.length += 2;
					continue;
				}
				var code:int = findClassCode(packet[fname]);
				switch(code) {
					case MercuryConst.CODE_SHORT_TYPE:
						buffer.writeShort(packet[fname]);
						packet.length += 2;
						break;
					case MercuryConst.CODE_FLOAT_TYPE:
						buffer.writeFloat(packet[fname]);
						packet.length += 4;
						break;
					case MercuryConst.CODE_INT_TYPE:
						buffer.writeInt(packet[fname]);
						packet.length += 4;
						break;
					case MercuryConst.CODE_INT_ARR_TYPE:
						var temp:Vector.<int> = Vector.<int>(packet[fname]);
						for each(var i:int in temp) {
							buffer.writeInt(i);
						}
						packet.length += 4 * temp.length;
						break;
				
				}
			}
			buffer.position = 2;
			buffer.writeShort(packet.length);
			buffer.position = 0;
			return buffer;
			trace("fields",fields);
		}
		*/
		
		public static function packData(p:MercuryPacket):ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.writeByte(p.header);
			ba.writeShort(p.length);
			ba.writeBytes(p.data, 0, p.data.length);
			return ba;
		}
		/*
		public static function unpackData(buffer:ByteArray, packet:MercuryPacket):void {
			var fields:XMLList = describeType(packet)..variable;
			for (var i:int = 0; i < fields.length(); i++) {
				var fname:String = fields[i].@name;				
				var code:int = findClassCode(packet[fname]);
				switch(code) {
					case MercuryConst.CODE_INT_TYPE:
						if (fname == "header" || fname == "length") {
							packet[fname] = buffer.readShort();							
						}						
				}				
			}
		}
		*/
		public static function findClassCode(o:*):int {
			// primitive type
			if (o  is int)
				return MercuryConst.CODE_INT_TYPE;
			
			if ( o is Boolean)
				return MercuryConst.CODE_BOOLEAN_TYPE;
			
			if ( o is Number)
				return MercuryConst.CODE_FLOAT_TYPE;
			
			if (o is String)
				return MercuryConst.CODE_STRING_TYPE;
			
			// array type
			if ( o is Vector.<int>)
				return MercuryConst.CODE_INT_ARR_TYPE;
			
			if ( o is Vector.<Number>)
				return MercuryConst.CODE_FLOAT_ARR_TYPE;
				
			if ( o is Vector.<Boolean>)
				return MercuryConst.CODE_BOOLEAN_ARR_TYPE;
				
			if (o is Vector.<String>)
				return MercuryConst.CODE_STRING_ARR_TYPE;
			
			if ( o is Vector.<*>)
				return MercuryConst.CODE_OBJECT_ARR_TYPE;
					
			if ( o is Object )
				return MercuryConst.CODE_OBJECT_TYPE;
			return -1;
		}
		
		public static function getFieldListSpec(o:*):Array {			
			var xml: XML = ReflectionUtils.getTypeDescription(getClass(o));
			var fieldsXML:XMLList = xml.factory.variable;
			var fields:Array = new Array();
			for (var i:int = 0 ; i < fieldsXML.length(); i++ ) {
				var obj:FieldInfo = new FieldInfo();
				obj.fname = fieldsXML[i].@name; 
				if (obj.fname == "cmdId") continue;	
				obj.id = fieldsXML[i].metadata.arg.@value;
				fields.push(obj);				
			}
			fields.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);
			var fi:FieldInfo = new FieldInfo();
			fi.fname = "cmdId";
			fi.id = 0;
			fields.unshift( fi );
			return fields;
		}
		
		public static function getFieldList(o:*):Array {
			var xml: XML = ReflectionUtils.getTypeDescription(getClass(o));
			var fieldsXML:XMLList = xml.factory.variable;
			var fields:Array = new Array();
			for (var i:int = 0 ; i < fieldsXML.length(); i++ ) {
				var obj:FieldInfo = new FieldInfo();
				obj.fname = fieldsXML[i].@name;
				obj.id = fieldsXML[i].metadata.arg.@value;
				fields.push(obj);				
			}
			fields.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);
			return fields;
		}
		
		public static function getClass(obj:*):Class 
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		public static function getBytes(bytes:ByteArray):String {
			bytes.position = 0;
			var s:String = "";
			while (bytes.position != bytes.length) {
				s += bytes.readByte() + " ";
			}
			bytes.position = 0;
			return s;
		}
		
		public static function toByte(obj:*):ByteArray {
			var i:int;
			var j:int;
			var fields:Array = MercuryPacket.getFieldList(obj);
			var buffer:ByteArray = new ByteArray();
			var tempBuff:ByteArray;
			for ( i = 0; i < fields.length; i++) {
				var code:int = MercuryPacket.findClassCode(obj[fields[i].fname]);	
				buffer.writeByte(code);				
				switch(code) {
					case MercuryConst.CODE_INT_TYPE:						
							buffer.writeInt(obj[fields[i].fname]);
							break;
							
					case MercuryConst.CODE_INT_ARR_TYPE:
							var tempInt:Vector.<int> = Vector.<int>(obj[fields[i].fname]);
							buffer.writeShort(tempInt.length);
							for ( j = 0; j < tempInt.length; j++ )
								buffer.writeInt(tempInt[j]);
							break;
							
					case MercuryConst.CODE_FLOAT_TYPE:
							buffer.writeFloat(obj[fields[i].fname]);
							break;
							
					case MercuryConst.CODE_FLOAT_ARR_TYPE:
							var tempFloat:Vector.<Number>  = Vector.<Number>(obj[fields[i].fname]);
							buffer.writeShort(tempFloat.length);
							for ( j = 0; j < tempFloat.length; j++ )
								buffer.writeFloat(tempFloat[j]);
							break;
					
					case MercuryConst.CODE_BOOLEAN_TYPE:
							buffer.writeBoolean(obj[fields[i].fname]);
							break;
							
					case MercuryConst.CODE_BOOLEAN_ARR_TYPE:
							var tempBool:Vector.<Boolean> = Vector.<Boolean>(obj[fields[i].fname]);
							buffer.writeShort(tempBool.length);
							for ( j= 0; i < tempBool.length; j++ )
								buffer.writeBoolean(tempBool[j]);
							break;	
					case MercuryConst.CODE_STRING_TYPE:
							var str:String = String(obj[fields[i].fname]);								
							tempBuff = new ByteArray();
							tempBuff.writeMultiByte(str, MercuryConst.CHARSET_ENCODE);	
							buffer.writeShort(tempBuff.length);
							buffer.writeBytes(tempBuff, 0, tempBuff.length);
								
							break;
					case MercuryConst.CODE_STRING_ARR_TYPE:
							var arrString:Vector.<String> = Vector.<String>(obj[fields[i].fname]);
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
				}				
			}	
			buffer.position = 0;
			return buffer;	
		}
		
		public static function toObject(buffer:ByteArray, o:*,classInfo:*):void 
		{
			var i:int;
			var j:int;
			buffer.position = 0;
			if (classInfo == null) {
				throw new Error("Khong lay duoc thong tin cua class de tao thanh goi tin");
			}
			var fields:Array = MercuryPacket.getFieldList(classInfo);						
			for ( i = 0; i < fields.length; i++) 
			{
				
				var code:int = buffer.readByte();
				var length:int;
				switch(code) 
				{
					case MercuryConst.CODE_INT_TYPE:						
							o[fields[i].fname] = buffer.readInt();	
							break;
							
					case MercuryConst.CODE_INT_ARR_TYPE:
							length = buffer.readShort();
							var tempInt:Vector.<int> = new Vector.<int>(length);
							for ( j = 0; j < tempInt.length; j++ )
							{								
								tempInt[j] = buffer.readInt();
							}
							o[fields[i].fname] = tempInt;
							break;
							
					case MercuryConst.CODE_FLOAT_TYPE:
							o[fields[i].fname] = buffer.readFloat();
							break;
							
					case MercuryConst.CODE_FLOAT_ARR_TYPE:
							length = buffer.readShort();
							var tempFloat:Vector.<Number>  = new Vector.<Number>(length);
							for ( j = 0; j < tempFloat.length; j++ )
								tempFloat[j] = buffer.readFloat();
							o[fields[i].fname] = tempFloat;
							break;
					
					case MercuryConst.CODE_BOOLEAN_TYPE:
							o[fields[i].fname] = buffer.readBoolean();
							break;
							
					case MercuryConst.CODE_BOOLEAN_ARR_TYPE:
							length = buffer.readShort();
							var tempBool:Vector.<Boolean> = new Vector.<Boolean>(length);
							for ( j= 0; i < tempBool.length; j++ )
								tempBool[j] = buffer.readBoolean();								
							o[fields[i].fname] = tempBool;
							break;	
					case MercuryConst.CODE_SHORT_TYPE:
							o[fields[i].fname] = buffer.readShort();
							break;
					case MercuryConst.CODE_SHORT_ARR_TYPE:
							length = buffer.readShort();
							var tempShort:Vector.<int> = new Vector.<int>(length);
							for ( j= 0; i < tempBool.length; j++ )
								tempShort[j] = buffer.readShort();	
							o[fields[i].fname] = tempShort;
							break;
					
					case MercuryConst.CODE_STRING_TYPE:
							var bytes:ByteArray = new ByteArray();
							length = buffer.readShort();
							if(length > 0)
								buffer.readBytes(bytes, 0, length);
							bytes.position = 0;	
							//trace(MercuryPacket.getBytes(bytes));
							o[fields[i].fname] = bytes.toString();
							break;
					case MercuryConst.CODE_STRING_ARR_TYPE:
							var bs:ByteArray = new ByteArray();
							length = buffer.readShort();
							var arrString:Vector.<String> =  new Vector.<String>(length);
							for (j = 0; j < arrString.length; j++ ) {
								length = buffer.readShort();
								if (length > 0) {
									buffer.readBytes(bs, 0, length);
									bs.position = 0;
									arrString[j] = bs.toString();
									bs.clear();
								}else {
									arrString[j] = "";
								}
								
							}
							o[fields[i].fname] = arrString;
							break;
				}				
			}	
			
		}
		
	}

}