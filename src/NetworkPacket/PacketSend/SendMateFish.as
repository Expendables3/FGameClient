package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author 
	 */
	public class SendMateFish extends BasePacket 
	{
		public var FishList:Array = [];
		public var MaterialList:Array = [];
		public var Skill:String;
		public var MixFormula:Object;
		
		public function SendMateFish() 
		{
			ID = Constant.CMD_MATE_FISH;
			URL = "FishService.mate";
			IsQueue = false;
		}
		
		public function AddNew(fishList:Array, materList:Array = null, skill:String = ""):void
		{
			var i:int;
			for (i = 0; i < fishList.length; i++)
			{
				FishList.push(fishList[i]);
			}
			
			if (materList != null)
			{
				for (i = 0; i < materList.length; i++)
				{
					MaterialList.push(materList[i]);
				}
			}
			this.Skill = skill;
		}
		
		public function setMixFormula(type:String, id:int):void
		{
			MixFormula = new Object();
			MixFormula["Type"] = type;
			MixFormula["Id"] = id;
		}
	}

}