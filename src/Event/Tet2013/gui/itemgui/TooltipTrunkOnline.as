package Event.Tet2013.gui.itemgui 
{
	import Data.ConfigJSON;
	import GUI.component.GUIToolTip;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class TooltipTrunkOnline extends GUIToolTip 
	{
		private var _idTrunk:int;
		private var _listGift:Array = [];
		public function TooltipTrunkOnline(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "TooltipTrunkOnline";
		}
		override public function InitGUI():void 
		{
			LoadRes("GuiOnlineGift_TooltipTrunkOnlineTheme");
			//this.setImgInfo = function():void
			//{
				_listGift.splice(0, _listGift.length);
				var data:Object = ConfigJSON.getInstance().getItemInfo("KeepLogin_Gift")[_idTrunk]["Gift"];
				var itGift:AbstractItemGift;
				var gift:AbstractGift;
				var info:Object;
				var x:int = 24;
				var y:int = 47;
				for (var i:int = 1; i <= 6; i++)
				{
					info = data[i];
					gift = AbstractGift.createGift(info["ItemType"]);
					if (info["ItemType"] == "VipTag")
					{
						info["ItemId"] = 1;
					}
					gift.setInfo(info);
					itGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "GuiOnlineGift_TooltipTrunkOnlineSlot", x, y, true);
					itGift.initData(gift);
					itGift.hasTooltipImg = false;
					itGift.hasTooltipText = false;
					itGift.drawGift();
					_listGift.push(itGift);
					x += 93;
					if (i == 3)
					{
						x = 24;
						y += 84;
					}
				}
			//}
			var row:int = _idTrunk % 6 + 1;
			var col:int = Math.ceil(_idTrunk / 6);
			switch(_idTrunk)
			{
				case 1:
					SetPos(150, 0);
					break;
				case 2:
					SetPos(310, 0);
					break;
				case 3:
					SetPos(450, 0);
					break;
				case 4:
					SetPos(200,0);
					break;
				case 5:
					SetPos(350, 0);
					break;
				case 6:
					SetPos(150, 100);
					break;
				case 7:
					SetPos(310, 100);
			}
		}
		override public function ClearComponent():void 
		{
			if (_listGift)
			{
				for (var i:int = 0; i < _listGift.length; i++)
				{
					var itGift:AbstractItemGift = _listGift[i];
					itGift.Destructor();
				}
				_listGift.splice(0, _listGift.length);
			}
			super.ClearComponent();
		}

		public function set IdTrunk(value:int):void 
		{
			_idTrunk = value;
		}
		
	}

}
































