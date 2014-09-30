package GUI.TrungLinhThach 
{
	import com.adobe.images.BitString;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.Ultility;
	
	/**
	 * @author ThanhNT2
	 */
	public class GuiTrungLinhThachToolTip extends GUIToolTip 
	{
		private const IMG_GIFT:String = "ImgGift_";
		private const STATE_LOCK:int = 0;
		private const STATE_UNLOCK:int = 1;
		
		private var posParent:Point = new Point();
		private var sizePX:Number;
		private var sizePY:Number;
		private var sizeX:Number;
		private var sizeY:Number;
		
		private var arrImageGift:Array = [];
		private var arrItemGift:Array = [];
		private var arrStateLockGift:Array = [];
		private var IdSea:int = -1;
		
		private var objData:Object = null;
		
		public function GuiTrungLinhThachToolTip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			this.ClassName = "GuiTrungLinhThachToolTip";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			if (objData.id < 4)
			{
				LoadRes("GuiTrungLinhThach_ImgBgGUIMap_0");
			}
			else 
			{
				LoadRes("GuiTrungLinhThach_ImgBgGUIMap_1");
			}
			
			//var eggs:Container = AddContainer("", "GuiTrungLinhThach_TrungType" + objData.id, 55, 45, true, this);
			//eggs.SetScaleXY(0.6);
			
			//loadContentBonus();
			
			getPosGui(getTypeBg());
			SetPos(posToolTipX, posToolTipY);
		}
		
		/**
		 * 
		 * @param	Data		:	Dữ liệu đã nhập vào như gui trước, có chứa danh sách các item
		 * @param	pos			:	vị trí của cha
		 * @param	sizeParentX	:	kích thước chiều rộng của cha
		 * @param	sizeParentY	:	Kích thước chiều đài của cha
		 */
		public function Init(Data:Object):void 
		{
			objData = new Object();
			objData = Data;
		}
		
		private function loadContentBonus():void
		{
			var rateBonus1:int = 95;
			var index1:int = objData.id;
			if (index1 == 4)
			{
				rateBonus1 = 100;
			}
			var bonus1:Container = AddContainer("", "GuiTrungLinhThach_TrungType" + index1, 40, 170, true, this);
			bonus1.SetScaleXY(0.25);
			var textBonus1:TextField;
			textBonus1 = AddLabel("", 50, 170, 0x000000, 1);
			var fmName:TextFormat = new TextFormat("arial", 16, 0xcc6600);
			textBonus1.defaultTextFormat = fmName;
			textBonus1.text = Ultility.StandardNumber(rateBonus1) + ' %';
			
			var index2:int;
			if (index1 < 4)
			{
				index2 = index1 + 1;
				var bonus2:Container = AddContainer("", "GuiTrungLinhThach_TrungType" + index2, 40, 210, true, this);
				bonus2.SetScaleXY(0.25);
				var rateBonus2:int = 5;
				var textBonus2:TextField;
				textBonus2 = AddLabel("", 50, 210, 0x000000, 1);
				textBonus2.defaultTextFormat = fmName;
				textBonus2.text = Ultility.StandardNumber(rateBonus2) + ' %';
			}
		}
	}

}