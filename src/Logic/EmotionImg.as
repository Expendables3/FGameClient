package Logic 
{
	/**
	 * ...
	 * @author tuan
	 */
	public class EmotionImg extends BaseObject
	{
		public var MyFish:Fish = null;
		public var MyFishOceanHappy:FishOceanHappy = null;
		//public var MySoldier:Fish = null;
		//public var MyFishSpartan:FishSpartan = null;
		
		public function EmotionImg(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "Emotion";
		}

		public function SetMyFish(fish:Fish):void
		{
			MyFish = fish;
		}
		public function SetMyFishOceanHappy(fish:FishOceanHappy):void
		{
			MyFishOceanHappy = fish;
		}
				//public function SetMySoldier(fish:FishSoldier):void
		//{
			//MySoldier = fish;
		//}
		// Spartan
		//public function SetMyFishSpartan(fishSpartan:FishSpartan):void
		//{
			//MyFishSpartan = fishSpartan;
		//}
	}

}