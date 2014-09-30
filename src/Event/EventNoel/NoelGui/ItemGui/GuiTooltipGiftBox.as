package Event.EventNoel.NoelGui.ItemGui 
{
	import Data.ConfigJSON;
	import flash.text.TextField;
	import GUI.component.GUIToolTip;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * Tooltip khi di qua cái GiftBox trong GuiSavePoint
	 * @author HiepNM2
	 */
	public class GuiTooltipGiftBox extends GUIToolTip 
	{
		private var _idGiftBox:int;
		private var _x:int;
		public function set X(val:int):void
		{
			_x = val;
		}
		public function set Id(val:int):void { _idGiftBox = val;}
		public function GuiTooltipGiftBox(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "GuiTooltipGiftBox";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(_x - 260, 0);
				var w:int = int(img.width);
				var h:int = int(img.height);
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("Accumulation_Gift")[_idGiftBox];
				//draw Seal
				var itGift:AbstractItemGift, info:AbstractGift, temp:Object;
				temp = cfg["1"];
				info = AbstractGift.createGift(temp["ItemType"]);
				info.setInfo(temp);
				itGift = AbstractItemGift.createItemGift(info.ItemType, this.img, "KhungFriend", w / 2 - 37, 17);
				itGift.initData(info);
				itGift.hasTooltipImg = false;
				itGift.drawGift();
				var x:int = 10, y:int = 107;
				//draw Other Equipment
				for (var i:int = 2; i <= 10; i++)
				{
					temp = cfg[i];
					temp["Element"] = 1;
					temp["EnchantLevel"] = cfg[i]["Enchant"];
					info = AbstractGift.createGift(temp["ItemType"]);
					info.setInfo(temp);
					itGift = AbstractItemGift.createItemGift(info.ItemType, this.img, "KhungFriend", x, y);
					itGift.initData(info);
					itGift.hasTooltipImg = false;
					itGift.drawGift();
					x += 80;
					if ((i - 1) % 3 == 0)
					{
						x = 10;
						y += 90;
					}
				}
				var tfTip:TextField = AddLabel("", 80, 367, 0xffffff, 1,0x000000);
				tfTip.text = "Có thể chọn hệ khi nhận";
			}
			LoadRes("GuiTooltipGiftBox_Theme");
		}
	}

}





































