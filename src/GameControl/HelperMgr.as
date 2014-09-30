package GameControl 
{
	import GUI.GuiMgr;
	/**
	 * ...
	 * @author ducnh
	 */
	public class HelperMgr
	{
		private static var instance:HelperMgr = new HelperMgr;
		
		private var CurrentHelper:HelperObject = null;
		private var HelperArr:Array = [];
		
		/**
		 * Lấy một thể hiện chung của lớp GameLogic
		 * <br>Thể hiện này mang tính chất gần như 1 biến toàn cục </br>
		 */
		public static function getInstance():HelperMgr
		{
			if(instance == null)
			{
				instance = new HelperMgr();
			}
				
			return instance;
		}
		
		public function HelperMgr() 
		{
			
		}
		
		public function ClearHelper(name:String):void
		{
			var tg:HelperObject = FindHelper(name);
			if (tg != null)
			{
				tg.HideHelper();
				var vt:int = HelperArr.indexOf(tg);
				if (vt >= 0)
				{
					HelperArr.splice(vt, 1);
				}
				
			}
		}
		
		public function SetHelperData(name:String, img:Object):void
		{
			var tg:HelperObject = FindHelper(name);			
			if (tg == null)
			{
				tg = AddHelper(name);
				tg.SetMyObject(img);
			}
		}
		
		private function AddHelper(name:String):HelperObject
		{
			var kq:HelperObject = new HelperObject();
			kq.HelperName = name;
			HelperArr.push(kq);
			return kq;
		}
		
		public function FindHelper(name:String):HelperObject
		{
			var i:int;
			var tg:HelperObject;
			
			for (i = 0; i < HelperArr.length; i++)
			{
				tg = HelperArr[i] as HelperObject;
				if (tg.HelperName == name)
				{
					return tg;
				}
			}
			
			return null;
		}
		
		public function HideHelper():void
		{
			if (CurrentHelper != null)
			{
				CurrentHelper.HideHelper();
				CurrentHelper = null;
			}
		}
		
		public function ShowHelper(st:String):void
		{
			if (st == "")
			{
				return;
			}
			var param:Array = st.split("/");
			var i:int;
			var tg:HelperObject;
			var CanShow:Boolean = false;
			
			for (i = param.length - 1; i >= 0; i--)
			{
				tg = FindHelper(param[i]);
				if (tg != null)
				{
					if (tg.CanShowHelper())
					{
						if ((CurrentHelper != tg) && (CurrentHelper != null))
						{
							CurrentHelper.HideHelper();
						}
						tg.ShowHelper();
						CurrentHelper = tg;
						CanShow = true;
						break;
					}
				}
			}
			
			if (!CanShow)
			{
				if (CurrentHelper != null)
				{
					CurrentHelper.HideHelper();
					CurrentHelper = null;
				}
			}
		}

	}

}