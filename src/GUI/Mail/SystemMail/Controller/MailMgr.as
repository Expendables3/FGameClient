package GUI.Mail.SystemMail.Controller 
{
	import GUI.GuiMgr;
	import GUI.Mail.SystemMail.MailPackage.SendDelSystemMailFast;
	import GUI.Mail.SystemMail.MailPackage.SendReadSystemMail;
	import GUI.Mail.SystemMail.Model.MailInfo;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class MailMgr 
	{
		private static var _instance:MailMgr;
		private var _lstSystemMail:Array = [];
		private var _lstFriendMail:Array = [];
		
		public function checkHasNewMail():Boolean
		{
			var isNewMail:Boolean = false;
			for (var i:int = 0; i < _lstSystemMail.length; i++)
			{
				var mail:MailInfo = _lstSystemMail[i] as MailInfo;
				if (!mail.IsRead)
				{
					isNewMail = true;
					break;
				}
			}
			return isNewMail;
		}
		
		
		public function get ListSystemMail():Array
		{
			return _lstSystemMail;
		}
		public function getMailByIndex(index:int):MailInfo
		{
			return _lstSystemMail[index] as MailInfo;
		}
		public function MailMgr() 
		{
			
		}
		
		public static function getInstance():MailMgr
		{
			if (_instance == null)
			{
				_instance = new MailMgr();
			}
			return _instance;
		}
		
		public function initSystemMail(SystemMail:Object):void
		{
			_lstSystemMail.splice(0, _lstSystemMail.length);
			var i:int;
			if (SystemMail)
			{
				if (SystemMail["ListMailOwner"] && SystemMail["ListMailOwner"] is Array)
				{
					var listSysMail:Array = SystemMail["ListMailOwner"] as Array;
					var leng:int = listSysMail.length;
					if (leng > 0)
					{
						var curTime:Number = GameLogic.getInstance().CurServerTime;
						var mail:MailInfo;
						for (i = 0; i < leng; i++)
						{
							mail = new MailInfo();
							mail.setInfo(listSysMail[i]);
							mail.AutoId = i;
							var remainTime:Number = curTime-mail.FromTime;
							if (remainTime < 14 * 86400)
							{
								_lstSystemMail.push(mail);
							}
						}
					}
					else
					{
						trace("không có thư hệ thống");
					}
				}
				else
				{
					trace("haven't SystemMail[\"ListMailOwner\"]");
				}
			}
			else
			{
				trace("SystemMail = null" );
			}
		}
		
		public function initSystemMail1(SystemMail:Object):void
		{
			_lstSystemMail.splice(0, _lstSystemMail.length);
			var i:int;
			if (SystemMail)
			{
				if (SystemMail["ListMailOwner"])
				{
					var mail:MailInfo;
					var curTime:Number = GameLogic.getInstance().CurServerTime;
					for (var str:String in SystemMail["ListMailOwner"])
					{
						var id:int = (int)(str);
						mail = new MailInfo();
						mail.setInfo(SystemMail["ListMailOwner"][str]);
						mail.AutoId = id;
						var remainTime:Number = curTime-mail.FromTime;
						if (remainTime < 14 * 86400)
						{
							_lstSystemMail.push(mail);
						}
					}
					
				}
				else
				{
					trace("haven't SystemMail[\"ListMailOwner\"]");
				}
			}
			else
			{
				trace("SystemMail = null" );
			}
		}
		public function deleteMail(id:int):void
		{
			trace("xóa thư hệ thống có chỉ số = " + id);
			//send dữ liệu lên server
			var pk:SendDelSystemMailFast = new SendDelSystemMailFast(id);
			Exchange.GetInstance().Send(pk);
			// xóa 1 phần tử trong _lstSystemMail
			var index:int = getMailIndexById(id);
			_lstSystemMail.splice(index, 1);
			
			GuiMgr.getInstance().GuiSystemMail.refreshComponent();
		}
		
		//public function delAllMail():void
		//{
			//trace("xóa tất cả thư hệ thống");
		//}
		private function getMailIndexById(id:int):int
		{
			var index:int = -1;
			for (var i:int = 0; i < _lstSystemMail.length; i++)
			{
				var mail:MailInfo = _lstSystemMail[i] as MailInfo;
				if (mail.AutoId == id)
				{
					index = i;
				}
			}
			return index;
		}
		
		public function getMailById(id:int):MailInfo
		{
			for (var i:int = 0; i < _lstSystemMail.length; i++)
			{
				var mail:MailInfo = _lstSystemMail[i] as MailInfo;
				if (mail.AutoId == id)
				{
					return mail;
				}
			}
			return null;
		}
		
		public function isShowButtonMail():Boolean
		{
			var isShow:Boolean;
			if (_lstSystemMail.length == 0)
			{
				isShow = false;
			}
			else
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				isShow = false;
				for (var i:int = 0; i < _lstSystemMail.length; i++)
				{
					var mail:MailInfo = _lstSystemMail[i] as MailInfo;
					var remainTime:Number = curTime-mail.FromTime;
					if (remainTime < 14 * 86400)
					{
						isShow = true;
						break;
					}
				}
			}
			return isShow;
		}
		
		public function readSystemMail(id:int):void
		{
			var pk:SendReadSystemMail = new SendReadSystemMail(id);
			Exchange.GetInstance().Send(pk);
		}
	}

}
























