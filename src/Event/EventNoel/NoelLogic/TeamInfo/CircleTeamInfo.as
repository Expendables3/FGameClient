package Event.EventNoel.NoelLogic.TeamInfo 
{
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class CircleTeamInfo extends RoundBossTeamsInfo 
	{
		private var _idCircle:int;
		public function CircleTeamInfo(type:int) 
		{
			super(type);
		}
		override public function getIdCircle():int 
		{
			return _idCircle;
		}
		override public function setIdCircle(idCircle:int):void 
		{
			_idCircle = idCircle;
		}
		/**
		 * lấy số lượng cá dựa vào vòng trong hay vòng ngoài
		 * @param	idCircle
		 */
		static public function getNumFish(idCircle:int):int 
		{
			const oRadius:Object = { "1":120, "2":200 };
			const lengthFish:Number = 100;					//chiều dài cá
			var radius:Number = oRadius[idCircle];			//bán kính
			var c:Number = Math.PI * 2 * radius;			//chu vi
			var numFish:int = int(c / lengthFish);			//số cá
			return numFish;
		}
		
	}

}



























