package GUI.FishWar 
{
	import Data.ConfigJSON;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendExpiredTimeEquipment;
	/**
	 * Mặt nạ cá - dùng để thay đổi hình dạng của cá khi sử dụng
	 * @author longpt
	 */
	public class FishEquipmentMask extends FishEquipment 
	{
		public static const MASK_DRAGON:int = 1;
		public static const MASK_SHEN:int = 2;
		public static const MASK_SPARTA:int = 3;
		public static const MASK_TUARUA:int = 4;
		public static const MASK_CHAMPION:int = 5;
		
		public var TransformName:String = "";
		public var TimeUse:Number;
		public function FishEquipmentMask() 
		{
			
		}
		
		public function UpdateTime():void
		{
			var cfg:Object = ConfigJSON.getInstance().GetEquipmentInfo(Type, Rank + "$" + Color);
			//trace(StartTime + "_" + cfg.TimeUse + "_" + GameLogic.getInstance().CurServerTime);
			TimeLeft = cfg.TimeUse + StartTime - GameLogic.getInstance().CurServerTime + 5;
			//trace("TimeLeft " + TimeLeft);
			if (TimeLeft < 0)
			{
				var cmd:SendExpiredTimeEquipment;
				if (FishOwn != null)
				{
					if (FishOwn.isActor == FishSoldier.ACTOR_MINE || !GameLogic.getInstance().user.IsViewer())
					{
						cmd = new SendExpiredTimeEquipment(String(GameLogic.getInstance().user.GetMyInfo().Id), Type, Id, FishOwn.LakeId, FishOwn.Id);
						Exchange.GetInstance().Send(cmd);
						//trace("Gửi gói tin hết hạn mặt nạ với ID của mình là " + GameLogic.getInstance().user.GetMyInfo().Id);
					}
					else
					{
						// Fix gấp
						var isTheirFish:Boolean = false;
						for (var i:int = 0; i < GameLogic.getInstance().user.FishSoldierAllArr.length; i++)
						{
							if (FishOwn.Id == GameLogic.getInstance().user.FishSoldierAllArr[i].Id)
							{
								if (FishOwn.Element == GameLogic.getInstance().user.FishSoldierAllArr[i].Element)
								{
									isTheirFish = true;
								}
							}
						}
						
						if (isTheirFish)
						{
							cmd = new SendExpiredTimeEquipment(String(GameLogic.getInstance().user.Id), Type, Id, FishOwn.LakeId, FishOwn.Id);
						}
						else
						{
							cmd = new SendExpiredTimeEquipment(String(GameLogic.getInstance().user.GetMyInfo().Id), Type, Id, FishOwn.LakeId, FishOwn.Id);
						}
						Exchange.GetInstance().Send(cmd);
						//trace("Gửi gói tin hết hạn mặt nạ với ID của bạn là " + GameLogic.getInstance().user.Id);
						//trace("isACtor cua FishOwn là " + FishOwn.isActor);
					}
					
					FishOwn.EquipmentList.Mask.splice(FishOwn.EquipmentList.Mask.indexOf(this), 1);
					FishOwn.RefreshImg();
				}
				else
				{
					cmd = new SendExpiredTimeEquipment(String(GameLogic.getInstance().user.GetMyInfo().Id), Type, Id);
					Exchange.GetInstance().Send(cmd);
					
					GameLogic.getInstance().user.UpdateEquipmentToStore(this, false);
				}
			}
		}
		
		public override function SetFishOwn(fs:FishSoldier):void
		{
			FishOwn = fs;
			if (FishOwn != null)
			{
				if (Rank == MASK_DRAGON)
				{
					TransformName = GetFishByMaskId(Rank) + "_" + FishOwn.Element;
				}
				else
				{
					TransformName = GetFishByMaskId(Rank);
				}
			}
			else
			{
				TransformName = "";
			}
		}
		
		public function DoTransform():void
		{
			if (Rank == MASK_DRAGON)
			{
				TransformName = GetFishByMaskId(Rank) + "_" + FishOwn.Element;
			}
			else
			{
				TransformName = GetFishByMaskId(Rank);
			}
			FishOwn.RefreshImg();
		}
		
		/**
		 * Hàm lấy tên content mặt nạ
		 * @param	id
		 * @return
		 */
		public function GetFishByMaskId(id:int):String
		{
			switch (id)
			{
				case MASK_DRAGON:
					return "Dragon";
				case MASK_SHEN:
					return "Shen";
				case MASK_SPARTA:
					return "SpartaWar";
				case MASK_TUARUA:
					return "TuaRuaBaoTu";
					break;
				case MASK_CHAMPION:
					return "Champion";
					break;
			}
			return "";
		}
	}

}