package GUI.EventBirthDay.EventLogic 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.EventBirthDay.EventGUI.GUIChangeBirthdayGift;
	import GUI.EventBirthDay.EventGUI.ItemBirthDay;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.Ultility;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class BirthDayItemMgr 
	{
		private var _objBirthDay:Object;
		static private var _instance:BirthDayItemMgr = null;
		
		public function BirthDayItemMgr() 
		{
			
		}
		
		static public function getInstance():BirthDayItemMgr
		{
			if (_instance == null)
			{
				_instance = new BirthDayItemMgr();
			}
			return _instance;
		}
		
		public function get ObjBirthDay():Object
		{
			return _objBirthDay;
		}
		
		/**
		 * khởi tạo cho _objBirthDay khi lấy dữ liệu từ server về
		 * @param	data
		 */
		public function initData1(Data1:Object):void
		{
			if (Data1["Store"] == null)
			{
				initData(null);
				return;
			}
			if (Data1["Store"]["StoreList"]["EventItem"]["BirthDay"])
			{
				initData(Data1["Store"]["StoreList"]["EventItem"]["BirthDay"]["BirthDayItem"]);
			}
			else
			{
				initData(null);
			}
		}
		
		public function initData(data:Object):void 
		{
			_objBirthDay = new Object();
			var config:Object = ConfigJSON.getInstance().getItemInfo("BirthDayItem");
			for (var id:String in config)
			{
				var birthDayItem:BirthdayItem = new BirthdayItem();
				birthDayItem.ItemId = int(id);
				birthDayItem.setInfo(config[id]);
				if (data)
				{
					birthDayItem.Num = data[id];
				}
				else
				{
					birthDayItem.Num = 0;
				}
				
				
				_objBirthDay[id] = birthDayItem;
			}
		}
		/**
		 * cập nhật số lượng cho 1 đồ
		 * @param	ItemId: id
		 * @param	Num	: số lượng
		 */
		public function setNum(itemId:int = 1, num:int = 1, isUpdateGui:Boolean = false):void
		{
			var id:String = itemId.toString();
			_objBirthDay[id]["Num"] += num;
			//thực hiện vẽ lại cả itemBirthDay mà nó reference
			if (isUpdateGui)
			{
				var itemReference:ItemBirthDay;
				var guiChangeGift:GUIChangeBirthdayGift = GuiMgr.getInstance().GuiChangeBirthDayGift;
				for (var i:int = 1; i <= 3; i++)
				{
					var col:int = (itemId - 9 < 0)?5:(itemId - 9);
					itemReference = guiChangeGift.getItemBirthDay(i, col);
					itemReference.updateNum();
				}
			}
			if (itemId == 14) {
				MagicLampMgr.getInstance().WishingPoint += num;
			}
			var isShowStore:Boolean = false;
			if (GuiMgr.getInstance().GuiStore)
			{
				if (GuiMgr.getInstance().GuiStore.img)
				{
					isShowStore = GuiMgr.getInstance().GuiStore.img.visible;
				}
			}
			if (isShowStore && itemId != 14)
			{
				GuiMgr.getInstance().GuiStore.UpdateStore("BirthDayItem", itemId, num);
			}
		}
		
		public function changeGift(idRow:int):void 
		{
			
			for (var idCol:int = 1; idCol <= 5; idCol++)
			{
				var id:int = (idCol + 9 > 13)?idRow:(idCol + 9);
				var temp:Object = ConfigJSON.getInstance().getItemInfo("BirthDayGiftBox", idRow);
				var maxNum:int = temp["Input"][idCol]["Num"];
				setNum(id, 0 - maxNum, true);
				
			}
		}
		
		public function getNum(itemId:int = 14):int
		{
			if (_objBirthDay == null)
				return 0;
			return _objBirthDay[itemId.toString()]["Num"];
		}
		
		public function setWishingPoint(num:int):void 
		{
			_objBirthDay["14"]["Num"] += num;
			MagicLampMgr.getInstance().WishingPoint += num;
			
			/*effect + điểm ước muốn*/
			var st:String = "+" + Ultility.StandardNumber(num);
			var txtFormat :TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
			txtFormat.color = 0xC9455C;
			txtFormat.font = "SansationBold";
			txtFormat.align = "left"
			var tmp1:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
			
			//var guiTop:GUITopInfo = GuiMgr.getInstance().GuiTopInfo;
			//var pos:Point = new Point(guiTop.prgWishingPoint.x , guiTop.prgWishingPoint.y);
			//pos = guiTop.img.localToGlobal(pos);
			var pos:Point = new Point(0, 0);
			var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1) as ImgEffectFly;
			eff1.SetInfo(pos.x, pos.y + 30, pos.x - 10, pos.y + 30, 7);
		}
	}

}































