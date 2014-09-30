package Logic 
{
	import Data.INI;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class LogInfo
	{
		public static const ID_CARE_FISH:int 		= 1;
		public static const ID_FEED_FISH:int 		= 2;
		public static const ID_CURE_FISH:int 		= 3;
		public static const ID_CLEAN_LAKE:int 		= 4;
		public static const ID_FISHING:int 			= 5;
		public static const ID_STEAL_MONEY:int 		= 6;		
		public static const ID_ATTACK_WIN:int 		= 7;		
		public static const ID_ATTACK_LOOSE:int 		= 8;		
		
		public var UserId:int = 0;				//Id của user
		public var LastTimeAct:Number = 0;		//Thời gian của lần thực hiện action cuối cùng
		
		//Mảng lưu số lượng các action
		//Có 2 thuộc tính là: Id và Num
		public var ActNumArr:Array = [];			
		
		
		public function LogInfo() 
		{
			
		}
		
		
		public function AddAct(idAct:int, num:int = 1):void
		{
			if (!GameLogic.getInstance().user.IsViewer()) return;
				
			var obj:Object;
			for (var i:int = 0; i < ActNumArr.length; i++) 
			{
				obj = ActNumArr[i];
				if (obj[ConfigJSON.KEY_ID] == idAct)
				{
					obj["Num"] += num;
					LastTimeAct = GameLogic.getInstance().CurServerTime;
					return;
				}
			}
			obj = new Object();
			obj[ConfigJSON.KEY_ID] = idAct;
			obj["Num"] = num;
			ActNumArr.push(obj);
			LastTimeAct = GameLogic.getInstance().CurServerTime;
		}
		
		public function HasAct():Boolean
		{
			return (ActNumArr.length > 0 ? true:false);
		}
	}

}