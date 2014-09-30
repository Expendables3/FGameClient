package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.BitmapMovie;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import GUI.GUIFishStatus;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.WaveEmit;
	/**
	 * ...
	 * @author ...
	 */
	public class FishWorldController 
	{
		private static var Round:int = 1;
		private static var NumSolider:int;
		private static var SeaId:int;
		//Wave và effWave dành cho biển Băng
		private static var Wave:Object = null;
		private static var effWorldIce:SwfEffect;
		//Bitmap
		private static var bmpList:Object = new Object();
		
		//Sóng Băng
		public static var waveEmit:WaveEmit = null;
		
		public static function SetSeaId(seaId:int):void 
		{
			SeaId = seaId;
		}
		/**
		 * Hàm thực hiện thiết lập thông tin cần bổ sung của biển khi nhận được thông tin từ server về
		 * @param	Data
		 */
		public static function SetInfoForRound1(Data1:Object):void 
		{
			switch (SeaId) 
			{
				case Constant.OCEAN_ICE:
					Wave = Data1.Sea.Wave;
				break;
			}
		}
		/**
		 * Hàm thực hiện thiết lập thông tin cần bổ sung khi có xảy ra lỗi và thông tin trước khi xảy ra lõi được clone lại
		 * @param	ObjDataClone
		 */
		public static function SetInfoForRound2(ObjDataSeaClone:Object):void 
		{
			switch (SeaId) 
			{
				case Constant.OCEAN_ICE:
					Wave = ObjDataSeaClone.Wave;
				break;
			}
		}
		/**
		 * hàm thực hiện show eff của môi trường trong thế giới nào đó
		 */
		private static function PlayEffEnvironment():void 
		{
			switch (SeaId) 
			{
				case Constant.OCEAN_ICE:
					//if(effWorldIce == null)
					//{
						//effWorldIce = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMapOcean_EffMapOcean", null, 405, 312, false, true, null);// , UpdateDataLogic);
						//effWorldIce = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffTornado", null, 405, 312, false, true);
					//}
					if (waveEmit)
					{
						waveEmit.destroy();
						waveEmit = null;						
					}
					waveEmit = new WaveEmit(LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER));
					
					for (var i:int = 0; i < GameLogic.getInstance().user.FishSoldierActorMine.length; i++) 
					{
						var mFish:FishSoldier = GameLogic.getInstance().user.FishSoldierActorMine[i];
						mFish.GuiFishStatus.ShowStatus(mFish, GUIFishStatus.WAR_INFO);
					}
					
					for (var j:int = 0; j < GameLogic.getInstance().user.FishSoldierArr.length; j++) 
					{
						var tFish:FishSoldier = GameLogic.getInstance().user.FishSoldierArr[j];
						tFish.GuiFishStatus.ShowStatus(tFish, GUIFishStatus.WAR_INFO);
					}
				break;
			}
		}
		
		private static function UpdateDataLogic():void 
		{
			Wave[Round.toString()].EffectNum = Wave[Round.toString()].EffectNum - 1;
		}
		
		public static function ConvertToBitMap(kq:MovieClip, name:String):Object
		{
			if (name in bmpList)
			{
				return bmpList[name].duplicate();
			}
			else
			{
				bmpList[name] = new BitmapMovie(kq as MovieClip);
				return bmpList[name].duplicate();
			}
		}
		
		public static function GetBmpArray(name:String):Vector.<BitmapData>
		{
			return bmpList[name].bmpList;
		}
		
		public static function GetBmpPos(name:String):Vector.<Rectangle>
		{
			return bmpList[name].bmpPos;
		}
		
		/**
		 * Hàm thực hiện kiểm tra, và show eff của môi trường nếu có
		 */
		public static function CheckHaveEnvironment():Boolean
		{
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			switch (SeaId) 
			{
				case Constant.OCEAN_ICE:
					var objSeaIce:Object = objAllSea[SeaId.toString()][Round.toString()];
					var numMonsterIceCurRound:int = 0;
					var numMonsterIceCurRoundHave:int = 0;
					for (var iStrIce:String in objSeaIce) 
					{
						if (numMonsterIceCurRound < int(iStrIce))
						{
							numMonsterIceCurRound = int(iStrIce);
						}
					}
					
					var objMonsterHaveIce:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[GetSeaId() - 1].Monster[GetRound().toString()]
					for (var iStrIceHave:String in objMonsterHaveIce) 
					{
						numMonsterIceCurRoundHave++;
					}
					
					var numMonsterDie:int = numMonsterIceCurRound - numMonsterIceCurRoundHave;
					if (Round < 4 && !(Wave[Round.toString()] is Array) && (numMonsterDie + 1 >= int(Wave[Round.toString()].Times)))
					{
						var numShow:int = Wave[Round.toString()].EffectNum;
						if (numShow > 0)
						{
							return true;
						}
					}
				break;
			}
			return false;
		}
		/**
		 * Hàm thực hiện kiểm tra, và show eff của môi trường nếu có
		 * @param	fishArr	: Mảng cá bị ảnh hưởng bởi môi trường
		 */
		public static function CheckShowEffEnvironment():void 
		{
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			switch (SeaId) 
			{
				case Constant.OCEAN_ICE:
					if (Wave[Round.toString()] is Array)
					{
						return;
					}
					else
					{
						var objSeaIce:Object = objAllSea[SeaId.toString()][Round.toString()];
						var numMonsterIceCurRound:int = 0;
						var numMonsterIceCurRoundHave:int = 0;
						for (var iStrIce:String in objSeaIce) 
						{
							if (numMonsterIceCurRound < int(iStrIce))
							{
								numMonsterIceCurRound = int(iStrIce);
							}
						}
						
						var objMonsterHaveIce:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[GetSeaId() - 1].Monster[GetRound().toString()]
						for (var iStrIceHave:String in objMonsterHaveIce) 
						{
							numMonsterIceCurRoundHave++;
						}
						
						var numMonsterDie:int = numMonsterIceCurRound - numMonsterIceCurRoundHave;
						if (Round < 4 && !(Wave[Round.toString()] is Array) && (numMonsterDie + 1 >= int(Wave[Round.toString()].Times)))
						{
							var numShow:int = Wave[Round.toString()].EffectNum;
							if (numShow > 0 && waveEmit == null)
							{
								PlayEffEnvironment();
								//Wave[Round.toString()].EffectNum = Wave[Round.toString()].EffectNum - 1;
							}
						}
					}
				break;
			}
		}
		
		public static function GetValueOfEnviroment(fishSoldier:FishSoldier):int
		{
			fishSoldier.UpdateCombatSkill();
			fishSoldier.UpdateBonusEquipment();
			var value:int = 0;
			if (GameController.getInstance().typeFishWorld == Constant.TYPE_MYFISH)
			{
				return value;
			}
			if (Round > 3)	return value;
			var obj: Object;
			var delta:int;
			var numShow:int;
			switch (SeaId)
			{
				case Constant.OCEAN_ICE:
					obj = ConfigJSON.getInstance().GetItemList("IceWave");
					delta = obj[Round.toString()][fishSoldier.Element.toString()];
					numShow = Wave[Round.toString()].EffectNum;
					if(CheckHaveEnvironment())
					{
						value = Math.round((fishSoldier.Damage + fishSoldier.bonusEquipment.Damage) * delta / 100);
					}
				break;
			}
			return value;
		}
		
		public static function ShowEffForFishArrInIceWorld(fishSoldier:FishSoldier):void 
		{
			//var fishSoldier:FishSoldier;
			var obj: Object = ConfigJSON.getInstance().GetItemList("IceWave");
			//fishSoldier = fishArr[i] as FishSoldier;
			var str:String;
			var delta:int = obj[Round.toString()][fishSoldier.Element.toString()];
			var value:int;
			if(delta > 0)
			{
				str = Localization.getInstance().getString("FishWorldMsg9");
			}
			else
			{
				str = Localization.getInstance().getString("FishWorldMsg8");
			}
			value = GetValueOfEnviroment(fishSoldier); //int(fishSoldier.Damage * delta / 100);
			str = str.replace("@Value", (Math.abs(value)).toString());
			
			fishSoldier.GuiFishStatus.AddLabel(str, fishSoldier.GuiFishStatus.prgHealth.x - 50, fishSoldier.GuiFishStatus.prgHealth.y 
					+ 7 + fishSoldier.img.height + 40, 0x990000, 0, 0xffffff);
		}
		
		/**
		 * Hàm thực hiện kiểm tra, và show eff của môi trường nếu có
		 */
		public static function CheckStopEffEnvironment():void 
		{
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			switch (SeaId) 
			{
				case Constant.OCEAN_ICE:
					var objSeaIce:Object = objAllSea[SeaId.toString()][Round.toString()];
					var numMonsterIceCurRound:int = 0;
					var numMonsterIceCurRoundHave:int = 0;
					for (var iStrIce:String in objSeaIce) 
					{
						if (numMonsterIceCurRound < int(iStrIce))
						{
							numMonsterIceCurRound = int(iStrIce);
						}
					}
					
					var objMonsterHaveIce:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[GetSeaId() - 1].Monster[GetRound().toString()]
					for (var iStrIceHave:String in objMonsterHaveIce) 
					{
						numMonsterIceCurRoundHave++;
					}
					
					var numMonsterDie:int = numMonsterIceCurRound - numMonsterIceCurRoundHave;
					if (Round < 4 && !(Wave[Round.toString()] is Array) &&(numMonsterDie + 1 >= int(Wave[Round.toString()].Times)))
					{
						var numShow:int = Wave[Round.toString()].EffectNum; 
						if (numShow == 0 && waveEmit != null)
						{
							StopEffEnvironment();
						}
						else 
						{
							Wave[Round.toString()].EffectNum = Wave[Round.toString()].EffectNum - 1;
						}
					}
				break;
			}
		}
		
		/**
		 * hàm thực hiện dừng eff của môi trường trong thế giới nào đó
		 */
		public static function StopEffEnvironment():void 
		{
			switch (SeaId) 
			{
				case Constant.OCEAN_ICE:
					if (waveEmit)	
					{
						waveEmit.destroy();
						waveEmit = null;
					}
				break;
			}
		}
		
		public static function SetRound(round:int):void 
		{
			Round = round;
			switch (Round) 
			{
				case 1:
					NumSolider = 5;
				break;
				case 2:
					NumSolider = 3;
				break;
				case 3:
					NumSolider = 2;
				break;
				case 4:
					NumSolider = 1;
				break;
			}
		}
		public static function GetRound():int
		{
			return Round;
		}
		public static function GetNumSolider():int
		{
			return NumSolider;
		}
		public static function GetSeaId():int
		{
			return SeaId;
		}
		public static function GetNameBoss():String
		{
			switch (SeaId) 
			{
				case Constant.OCEAN_NEUTRALITY:
					return "Boss Tua Rua";
				break;
				case Constant.OCEAN_METAL:
					return "Boss Hoàng Kim";
				break;
				case Constant.OCEAN_ICE:
					return "Boss Pipi";
				break;
				case Constant.OCEAN_FOREST:
					return "ở biển Mộc";
				break;
			}
			return "";
		}
		
		public function FishWorldController() 
		{
			
		}
		
	}

}