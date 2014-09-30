package NetworkPacket.PacketReceive 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import Logic.*;
	/**
	 * ...
	 * @author ducnh
	 */
	public class BaseReceivePacket
	{
		
		public function BaseReceivePacket(data:Object) 
		{
			for (var itm:String in data)
			{				
				try
				{
					//trace(getQualifiedClassName(this[itm]));
					if ("SetInfo" in this[itm])
					{
						this[itm].SetInfo(data[itm]);
					}
					else
					{
						if (getQualifiedClassName(this[itm]) == "Array")
						{
							for (var i:String in data[itm])
							{
								this[itm].push(data[itm][i]);
							}
						}
						else
						{
							this[itm] = data[itm];
						}
					}
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
		
	}

}