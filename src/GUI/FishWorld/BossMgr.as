package GUI.FishWorld 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BossMgr 
	{
		private static var instance:BossMgr = new BossMgr;
		public var BossArr:Array = [];
		
		public function BossMgr() 
		{
			
		}
		
		public static function getInstance():BossMgr
		{
			if(instance == null)
			{
				instance = new BossMgr();
			}
				
			return instance;
		}
		
		public function UpdateBoss():void 
		{
			var boss:Boss;
			for (var i:int = 0; i < BossArr.length; i++) 
			{
				boss = BossArr[i];
				boss.UpdateBoss();
			}
		}
	}

}