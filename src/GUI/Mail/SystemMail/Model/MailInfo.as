package GUI.Mail.SystemMail.Model 
{
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class MailInfo 
	{
		private var _content:String;
		private var _fromId:int;
		private var _isRead:Boolean;
		private var _fromTime:Number;
		private var _autoId:int;
		
		public function get AutoId():int
		{
			return _autoId;
		}
		public function set AutoId(value:int):void
		{
			_autoId = value;
		}
		public function set Content(content:String):void
		{
			_content = content;
		}
		public function get Content():String
		{
			return _content;
		}
		public function set FromId(fromId:int):void
		{
			_fromId = fromId;
		}
		
		public function get IsFromSystem():Boolean
		{
			return (_fromId == -111);
		}
		public function set IsRead(isRead:Boolean):void
		{
			_isRead = isRead;
		}
		public function get IsRead():Boolean
		{
			return _isRead;
		}
		public function set FromTime(fromTime:Number):void
		{
			_fromTime = fromTime;
		}
		public function get FromTime():Number
		{
			return _fromTime;
		}
		public function MailInfo(content:String = "", fromId:int = -1, isRead:Boolean = false, fromTime:Number = 0) 
		{
			_content = content;
			_fromId = fromId;
			_isRead = isRead;
			_fromTime = fromTime;
		}
		public function setInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
		}
		public function clone():MailInfo
		{
			return new MailInfo(_content, _fromId, _isRead, _fromTime);
		}
	}

}