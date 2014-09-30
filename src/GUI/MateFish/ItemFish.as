package GUI.MateFish 
{
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.SpriteExt;
	import GUI.component.TooltipFormat;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemFish extends Container 
	{
		// Các kết quả kiểm tra cá trước khi lai
		public static const PASS:int = 7;				// đủ điều kiện
		public static const PASS_VIAGRA:int = 6;		// cá chưa lai và đã dùng thuốc
		public static const ALREADY:int = 5;			// đã lai trong ngày rồi
		public static const ALREADY_VIAGRA:int = 4;		// cá lai rồi và đã dùng thuốc
		public static const HUNGRY:int = 3;				// đói
		public static const BABY:int = 2;				// đang còn bé
		public static const NOT_EXIST:int = 1;			// cá ko tồn tại
		
		
		
		private var _statusMate:int;
		public var fishType:int;
		public var fishTypeId:int;
		public var id:int;
		public var sex:int;// == 0 là cá cái, ==1 là cá đực
		public var isResultMate:Boolean;
		
		public function ItemFish(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "GuiMateFish_CtnFish1", x, y, isLinkAge, imgAlign);
		}
		
		public function initItemFish(fish:Fish, isResultMate:Boolean = false):void
		{
			this.ClearComponent();
			this.isResultMate = isResultMate;
			fishType = fish.FishType;
			fishTypeId = fish.FishTypeId;
			id = fish.Id;
			statusMate = Check(fish);
			sex = fish.Sex;
			if (isResultMate)
			{
				statusMate = BABY;
			}
			
			var ctnSize:Point = new Point(img.width, img.height);			
			var aboveContent:Sprite;			
			var imgFish:Sprite = Ultility.loadFish(fish, this);// , img.width / 2, img.height / 2);
			
			var domain:int = -1;
			var imgDomain:Image;
			if (fish.FishTypeId >= Constant.FISH_TYPE_DISTANCE_DOMAIN && fish.FishTypeId < Constant.FISH_TYPE_START_SOLDIER)
			{
				domain = (fish.FishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
			}
			if(fish.FishType == Fish.FISHTYPE_SPECIAL)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				if (aboveContent.width > ctnSize.x || aboveContent.height > ctnSize.y)
				{
					aboveContent.width = ctnSize.x - 10;
					aboveContent.height = ctnSize.y - 10;
				}
				AddImageBySprite(aboveContent, img.width / 2 - 10, img.height / 2 + 8);
			}
			else if(fish.FishType == Fish.FISHTYPE_RARE)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				if (aboveContent.width > ctnSize.x || aboveContent.height > ctnSize.y)
				{
					aboveContent.width = ctnSize.x - 10;
					aboveContent.height = ctnSize.y - 10;
				}
				AddImageBySprite(aboveContent, img.width / 2 - 10, img.height / 2 + 8);
				var cl:int = fish.getAuraColor();
				TweenMax.to(imgFish, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
			}
			if (domain > 0)
			{
				aboveContent = ResMgr.getInstance().GetRes(Fish.DOMAIN + domain) as Sprite;
				if (aboveContent.width > ctnSize.x || aboveContent.height > ctnSize.y)
				{
					aboveContent.width = ctnSize.x - 10;
					aboveContent.height = ctnSize.y - 10;
				}
				imgDomain = AddImageBySprite(aboveContent, img.width / 2, 5);
				imgDomain.FitRect(30, 30, new Point(img.width / 2 + 15, -5));
			}
			
			if(!isResultMate)
			{
				img.buttonMode = true;
			}
		}
		
		/**
		 * Kiểm tra logic xem cá có đủ điều kiện lai hay ko
		 * các điều kiện gồm: cá tồn tại, cá trưởng thành, cá ko bị đói, trong ngày cá chưa xxx
		 * @param	f: con cá cần kiểm tra
		 * @return	kết quả kiểm tra. List các kết quả đã đc define trong list các hằng số của gui
		 */
		public static function Check(f:Fish):int
		{
			if (!f)
			{
				return ItemFish.NOT_EXIST;
			}
			
			// Check tuổi
			// Lỗi khi con cá giảm thời gian không ở hồ hiện tại
			//f.UpdateHavestTime();
			
			Ultility.updateHarvestTime(f);
			if (f.Growth() < 1)
			{
				return ItemFish.BABY;
			}
			
			// check độ no
			if (f.Full() <= 0)
			{
				return ItemFish.HUNGRY;
			}
			
			// check time, 1 ngày sinh sản 1 lần
			var lastTime:Date = new Date(f.LastBirthTime * 1000);
			var curTime:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var lastTimeViagra:Date = new Date(f.LastTimeViagra * 1000);
			var isCanResetViagra:Boolean;
			if (curTime.getFullYear() == lastTimeViagra.getFullYear() &&
								curTime.getMonth() == lastTimeViagra.getMonth() &&
								curTime.getDate() == lastTimeViagra.getDate())
			{
				isCanResetViagra = false;
			}
			else 
			{
				isCanResetViagra = true;
			}
			//curTime.get
			if (curTime.getFullYear() == lastTime.getFullYear())
			{
				if (curTime.getMonth() == lastTime.getMonth())
				{
					if (curTime.getDate() == lastTime.getDate())
					{
						if (!isCanResetViagra)
						{
							return ItemFish.ALREADY_VIAGRA;	// Đã lai và đã dùng Viagra
						}
						else 
						{
							return ItemFish.ALREADY;			// Đã lai và chưa dùng Viagra
						}
					}
					else
					{
						if(isCanResetViagra)
						{
							return ItemFish.PASS;			// Chưa lai và chưa dùng Viagra
						}
						else 
						{
							return ItemFish.PASS_VIAGRA;		// Lai được, đã lai và đã dùng Viagra
						}
					}
				}
				else
				{
					if(isCanResetViagra)
					{
						return ItemFish.PASS;				// Chưa lai và chưa dùng Viagra
					}
					else 
					{
						return ItemFish.PASS_VIAGRA;			// Lai được, đã lai và đã dùng Viagra
					}
				}
			}
			else
			{
				if(isCanResetViagra)
				{
					return ItemFish.PASS;					// Chưa lai và chưa dùng Viagra
				}
				else 
				{
					return ItemFish.PASS_VIAGRA;				// Lai được, đã lai và đã dùng Viagra
				}
			}
		}
		
		public function get statusMate():int 
		{
			return _statusMate;
		}
		
		public function set statusMate(value:int):void 
		{
			_statusMate = value;
			
			var tip:TooltipFormat = new TooltipFormat();
			//Cá thường
			if (fishTypeId < Constant.FISH_TYPE_START_SOLDIER)
			{
				switch(value)
				{
					case BABY:
						tip.text = "Cá còn bé";
						setTooltip(tip);
						if(!isResultMate)
						{
							img.alpha = 0.5;
						}
						else
						{
							img.alpha = 1;	
						}
						break;
					case HUNGRY:
						tip.text = "Cá đang đói";
						setTooltip(tip);
						img.alpha = 0.5;
						break;
					case ALREADY:
						tip.text = "Cá đã lai xong";
						setTooltip(tip);
						img.alpha = 0.5;
						break;
					case ALREADY_VIAGRA:
						tip.text = "Cá đã dùng thuốc \nvui vẻ và đã lai";
						setTooltip(tip);
						img.alpha = 0.5;
						break;
					case PASS_VIAGRA:
						tip.text = "Cá đã dùng thuốc vui vẻ";
						setTooltip(tip);
						img.alpha = 1;
						break;
					case PASS:
						tip.text = "Cá chưa lai";
						setTooltip(tip);
						img.alpha = 1;
						break;				
				}
			}
			//Cá lính
			else
			{
				tip.text = "Cá lính";
				setTooltip(tip);
				img.alpha = 1;	
			}
		}
		
		public function canMate():Boolean
		{
			if (statusMate == PASS || statusMate == PASS_VIAGRA)
			{
				return true;
			}
			return false;
		}
	}

}