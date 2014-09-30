package Logic 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class TaskInfo
	{
		// du lieu can thiet	
		public var Decription:String;
		public var Icon:String;
		public var Param:Object = new Object;		
		public var MaxNum:int;	
		
		// thong tin lay tu database ve
		public var Action:String;
		public var Id:int;
		public var Level:int;
		public var Num:int;
		public var Status:Boolean = false;
		public var BonusId:int;
		public var Result:Object = null;
		
		// du lieu de luu lai kiem tra
		//public var nDone:int = 0;
		
		public function TaskInfo() 
		{
			
		}
		
		public function SetInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{
					if (itm == "Param")
					{
						for (var i:String in data[itm]) 
						{
							this[itm][i] = data[itm][i];
						}
					}
					else
					{
						this[itm] = data[itm];
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