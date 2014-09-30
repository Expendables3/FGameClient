package GUI.EventBirthDay.EventLogic 
{
	import Data.Localization;
	import flash.geom.Point;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class MagicLampItemInfo 
	{
		public var Id:int;
		public var WishingPointNum:int;
		
		public var MaxWP:int;
		public var HitGift:AbstractGift;				//quà khủng nhất
		
		private var _giftObj:Object;						//mảng quà nhận được tại item này
		public function get GiftObj():Object {
			return _giftObj;
		}
		public function set GiftObj(value:Object):void {
			_giftObj = value;
		}
		
		private var _isReceived:Boolean;
		public function get IsReceived():Boolean {
			return _isReceived;
		}
		public function set IsReceived(value:Boolean):void {
			_isReceived = value;
		}
		
		private var _hasSpecial:Boolean;
		public function get HasSpecial():Boolean {
			return _hasSpecial;
		}
		public function set HasSpecial(value:Boolean):void {
			_hasSpecial = value;
		}
		
		public function get ImageName():String
		{
			if (HitGift.ClassName == "GiftNormal") {
				return (HitGift as GiftNormal).getImageName();
			}
			else
			{
				return (HitGift as GiftSpecial).getImageName();
			}
		}
		
		public function set Output(value:Object):void
		{
			var specialGift:GiftSpecial;
			var abstractGift:AbstractGift;
			var normalGift:GiftNormal;
			var type:String;
			var i:String;
			for (i in value)
			{
				if (value[i]["Color"]) {	/*có quà đặc biệt thì nó là quà Hit*/
					specialGift = new GiftSpecial();
					specialGift.setInfo(value[i]);
					type = specialGift.ItemType;
					abstractGift = specialGift;
					HitGift = specialGift;
					_hasSpecial = true;
				}
				else {
					normalGift = new GiftNormal();
					normalGift.setInfo(value[i]);
					type = normalGift.ItemType;
					abstractGift = normalGift;
				}
				_giftObj[type] = new Object();
				_giftObj[type] = abstractGift;
			}
			
			/*không có quà đặc biệt => tìm hit gift*/
			if (!_hasSpecial)
			{
				var rank:int = -2;
				var iHit:String = "";
				for (i in _giftObj)
				{
					normalGift = _giftObj[i] as GiftNormal;
					if (normalGift.RankBelongType > rank)
					{
						iHit = i;
						rank = normalGift.RankBelongType;
					}
				}
				if (iHit.length > 0) {
					HitGift = _giftObj[iHit] as GiftNormal;
				}
			}
		}
		
		public function get Position():Point
		{
			var pos:Point = new Point();
			switch(Id)
			{
				case 1:
					pos.x = 303;
					pos.y = 83;
				break;
				case 2:
					pos.x = 415;
					pos.y = 83;
				break;
				case 3:
					pos.x = 364;
					pos.y = 192;
				break;
				case 4:
					pos.x = 475;
					pos.y = 192;
				break;
				case 5:
					pos.x = 310;
					pos.y = 299;
				break;
				case 6:
					pos.x = 420;
					pos.y = 299;
				break;
				case 7:
					pos.x = 530;
					pos.y = 299;
				break;
				
				default:
					pos.x = pos.y = 0;
			}
			return pos;
		}
		
		public function MagicLampItemInfo() 
		{
			_hasSpecial = false;
			_giftObj = new Object();
		}
		
		public function setInfo(data:Object):void
		{
			for (var tmp:String in data)
			{
				try {
					this[tmp] = data[tmp];
				}
				catch (err:Error)
				{
					trace("Không có thuộc tính " + tmp + " trong class " + this);
				}
			}
		}
		
		public function get TooltipText():String
		{
			var strTooltip:String = "Bạn có thể nhận được:";
			var hitGiftTip:String;
			if (HitGift.ClassName == "GiftNormal")
			{
				for (var i:String in _giftObj)
				{
					var gift:GiftNormal = _giftObj[i] as GiftNormal;
					strTooltip += "\nHoặc " + Ultility.StandardNumber(gift.Num) + " " + getNameGift(gift);
				}
			}
			else
			{
				strTooltip = "Trang bị anh hùng thần\n Chọn hệ";
			}
			return strTooltip;
		}
		
		
		
		private function getNameGift(gift:GiftNormal):String 
		{
			var rs:String;
			switch(gift.ItemType)
			{
				case "Exp":
					rs = "Điểm kinh nghiệm";
				break;
				case "Money":
					rs = "Tiền vàng";
				break;
				default:
					rs = Localization.getInstance().getString(gift.ItemType + gift.ItemId);
			}
			return rs;
		}
		
	}

}































