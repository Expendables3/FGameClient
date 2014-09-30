package GUI.MateFish 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemSlot extends Container 
	{
		private var _id:int;// =0 là slot trống, =-1 là bị khóa, > 0 là chứa material
		public var materialImage:Image;
		private var _index:int;//Số thứ tự slot trong danh sách
		private var levelRequire:int;//Level của user yêu cầu để nâng cấp
		
		public function ItemSlot(parent:Object, imgName:String= "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "GuiMateFish_Slot_Material_Bg", x, y, isLinkAge, imgAlign);
			//materialImage = new Image(this.img, "");
			id = 0;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
			switch(value)
			{
				case -1:
					materialImage.LoadRes("IcLock");
					var tmpTip:TooltipFormat = new TooltipFormat();					
					tmpTip.text = Localization.getInstance().getString("GUILabe20");
					tmpTip.text = tmpTip.text.replace("@level", levelRequire);
					var format:TextFormat = new TextFormat();
					format.size = 14;
					format.color = 0x854F3D;
					format.bold = true;
					tmpTip.setTextFormat(format);
					setTooltip(tmpTip);
					img.buttonMode = true;
					break;
				case 0:
					if(materialImage != null && materialImage.img != null)
					{
						img.removeChild(materialImage.img);
					}
					materialImage = new Image(this.img, "");
					setTooltip(null);
					img.buttonMode = false;
					break;
				default:
					materialImage.LoadRes(Ultility.GetNameMatFromType(_id));
					setTooltip(null);
					img.buttonMode = true;
			}
			materialImage.FitRect(73, 38, new Point(-12, 3));
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
			
			var obj:Object = ConfigJSON.getInstance().getItemInfo("LevelUnlockSlot", value);
			levelRequire = obj.LevelRequire;
		}
		
		public function canUnlock():Boolean
		{
			if (GameLogic.getInstance().user.GetLevel() >= levelRequire && index == GameLogic.getInstance().user.GetMyInfo().SlotUnlock+1)
			{
				return true;
			}
			return false;
		}
	}

}