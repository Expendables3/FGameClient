package Logic 
{
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import NetworkPacket.PacketSend.SendCollectMoney;
	import NetworkPacket.PacketSend.SendStealMoney;
	/**
	 * ...
	 * @author ...
	 */
	public class Pocket extends BaseObject 
	{
		public static const FALL:String = "falling";
		public static const STAY:String = "staying";
		
		//public static const STEALED:String = "stealed";
		//public static const LIMITED:String = "limited";
		//public static const CAN_TAKE:String = "cantake";
		
		//public static const NORMAL:int = 1;
		//public static const SPECIAL:int = 2;
		
		//public static var EACH_TIME_RATE:Number;
		//public static var LIMIT_RATE:Number;
		//public static var TOTAL_RATE:Number;
		//public static var SPECIAL_LIMIT_RATE:Number;
		//public static var SPECIAL_TOTAL_RATE:Number;
		//public static var SPECIAL_EACH_TIME_RATE:Number;
		
		public var fish:Fish;
		private var TotalValue:Number;
		private var CurrentValue:Number;
		private var LimitValue:Number;		
		private var ThiefList:Array;
		
		public var Status:String;
		public var TargetPosX:int;
		public var TargetPosY:int;
		public var eff:SwfEffect;
		
		public var IsClicked:Boolean = false;
		public function Pocket(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "Pocket";
			
			TotalValue = 0;
			CurrentValue = 0;
			ThiefList = [];
			Status = FALL;
			img.cacheAsBitmap = true;
		}
		
		public function SetData(money:int, pos:Point, fish:Fish):void
		{
			TargetPosX = pos.x;
			TargetPosY = pos.y;
			ThiefList = fish.ThiefList;
			CurrentValue = money;
			this.fish = fish;
		}
		
		public function GetCurrent():int
		{
			return CurrentValue;
		}
		
		public function UpdateCurrent(money:int):void
		{
			CurrentValue += money;
		}
		
		public function GetTotal():int
		{
			return TotalValue;
		}
		
		public function AddStealer(id:int):void
		{
			ThiefList.push(id);
		}
		
		public function IsStoledByUser(UserId:int):Boolean
		{
			var i:int;
			for (i = 0; i < ThiefList.length; i++)
			{
				if (UserId == ThiefList[i])
				{
					return true;
				}
			}
			return false;
		}
		
		public function Steal():void
		{
			var money:int = Check();
			if (money == 0)
			{
				return;
			}			
			var LakeId:int = GameLogic.getInstance().user.CurLake.Id;
			var FriendId:int = GameLogic.getInstance().user.Id;
			var stealCmd:SendStealMoney = new SendStealMoney(this);				
			stealCmd.AddNew(fish.Id, LakeId, FriendId);
			Exchange.GetInstance().Send(stealCmd);			
			
			//Effect
			var child1:Sprite;
			var arr:Array = [];
			child1 = Ultility.EffExpMoneyEnergy("money", money);					
			arr.push(child1);
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, this.CurPos.x, this.CurPos.y);
		}
		
		public function Collect():void
		{
			var LakeId:int = GameLogic.getInstance().user.CurLake.Id;
			var FriendId:int = GameLogic.getInstance().user.Id;
			//var collectCmd:SendCollectMoney = new SendCollectMoney(this);				
			//collectCmd.AddNew(fish.Id, LakeId);
			//Exchange.GetInstance().Send(collectCmd);
			
			// Cong tien
			GameLogic.getInstance().user.UpdateUserMoney(CurrentValue);
			this.fish.MoneyPocket = 0;
			
			//Effect
			var child1:Sprite;
			var arr:Array = [];
			child1 = Ultility.EffExpMoneyEnergy("money", CurrentValue);					
			arr.push(child1);
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, this.CurPos.x, this.CurPos.y);
		}
		
		public function OnMouseClickPocket():void
		{			
			if (IsClicked)
			{
				return;
			}
			// Ăn trộm			
			if (GameLogic.getInstance().user.IsViewer())
			{
				Steal();
			}
			// Thu hoạch
			else
			{
				Collect();
			}
			IsClicked = true;			
			var pockerArr:Array = GameLogic.getInstance().user.PocketArr
			this.SetHighLight( -1);
			pockerArr.splice(pockerArr.indexOf(this), 1);
			this.ClearImage();			
		}
		
		public override function OnMouseOver(event:MouseEvent):void
		{
			var pos:Point = Ultility.PosLakeToScreen(this.CurPos.x, this.CurPos.y);
			//var TooltipText:String = CurrentValue.toString() + " " + Localization.getInstance().getString("Money");
			//Tooltip.getInstance().ShowNewToolTip(TooltipText, pos.x, pos.y - 30);
			//Tooltip.getInstance().SetTimeOut(1000);
			GameLogic.getInstance().MouseTransform("imgHand");
			this.SetHighLight(0xFF00FF);
		}
		
		public function Check():int
		{
			var pos:Point = Ultility.PosLakeToScreen(this.CurPos.x, this.CurPos.y);
			var TooltipText:String;
			var result:int;
			// Ăn trộm			
			if (GameLogic.getInstance().user.IsViewer())
			{
				var i:int;
				// Đã ăn trộm
				for (i = 0; i < ThiefList.length; i++)
				{
					if (GameLogic.getInstance().user.GetMyInfo().Id == ThiefList[i])
					{
						return 0;
					}
				}
				
				var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
				var price:int = obj["StealOnce"];
				if(CurrentValue < price)
				{
					return 0;
				}
				else
				{
					result = price;
				}
			}
			// Thu hoạch
			else
			{
				result = CurrentValue;
			}			
			return result;
		}
		
		public function UpdatePos():void
		{
			if (Status == FALL)
			{
				CurPos.y += 5;
				if (CurPos.y >= TargetPosY)
				{
					CurPos.y = TargetPosY;
					Status = STAY;
				}
				img.x = CurPos.x;
				img.y = CurPos.y;
				if (eff == null || eff.IsFinish)
				{
					eff = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffNhapNhay", null, img.x - 20, img.y);
					eff.img.scaleX = eff.img.scaleY = 0.8;
				}
			}
		}
	}

}