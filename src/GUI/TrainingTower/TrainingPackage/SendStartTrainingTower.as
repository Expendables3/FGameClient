package GUI.TrainingTower.TrainingPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendStartTrainingTower extends BasePacket 
	{
		public var RoomId:int;
		public var SoldierId:int;
		public var LakeId:int;
		public var TimeType:int;
		public var IntensityType:int;
		public var PriceType_Time:String;
		public var PriceType_Intensity:String;
		public function SendStartTrainingTower(roomId:int, 
												soldierId:int, 
												lakeId:int, 
												timeType:int, 
												intensityType:int,
												priceType_time:String,
												priceType_intensity:String
												) 
		{
			URL = "SoldierService.startTraining";
			ID = Constant.CMD_START_TRAININGTOWER;
			RoomId = roomId;
			SoldierId = soldierId;
			LakeId = lakeId;
			TimeType = timeType;
			IntensityType = intensityType;
			PriceType_Time = priceType_time;
			PriceType_Intensity = priceType_intensity;
			IsQueue = false;
		}
		
	}

}