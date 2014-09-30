package GUI.TrungLinhThach 
{
	import com.adobe.images.BitString;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import Logic.LayerMgr;
	import particleSys.myFish.CometEmit;
	
	import Sound.SoundMgr;
	import com.adobe.serialization.json.JSON;
	
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIHuongDan extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		private var ListItemTrung:Array = [];
		
		public var IsInitFinish:Boolean = false;
		
		static public const BTN_BACK:String = "btnBack";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_KNOWN:String = "btnKnown";
		static public const BTN_CLOSE:String = "btnClose";
		
		private var bgHelp_1:Image;
		private var bgHelp_2:Image;
		private var bgHelp_3:Image;
		private var bgHelp_4:Image;
		
		public var buttonBack:Button;
		public var buttonNext:Button;
		public var buttonKnown:Button;
		private var buttonClose:Button;
		private var indexBg:int = 1;
		
		public function GUIHuongDan(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIHuongDan";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				IsInitFinish = false;
				SetPos(0, 0);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
			}
			LoadRes("");
		}
		
		public function showGUI():void
		{
			isDataReady = false;
			
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function EndingRoomOut():void 
		{
			IsInitFinish = true;
			isDataReady = true;
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
			isDataReady = dataAvailable;
			//trace("refreshComponent()== " + isDataReady);
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			addContent();
		}
		
		/*Add thong tin content cho Gui*/
		private function addContent():void
		{
			indexBg = 1;
			bgHelp_4 = AddImage("", "GUIHuongDan_Bg_4", 414, 310);
			
			bgHelp_3 = AddImage("", "GUIHuongDan_Bg_3", 414, 310);
			
			bgHelp_2 = AddImage("", "GUIHuongDan_Bg_2", 414, 310);
			
			bgHelp_1 = AddImage("", "GUIHuongDan_Bg_1", 414, 310);
			
			buttonKnown = AddButton(BTN_KNOWN, "GUIHuongDan_BtnKnown", 500, 543);
			buttonNext = AddButton(BTN_NEXT, "GUIHuongDan_BtnTiepTheo", 300, 543);
			buttonBack = AddButton(BTN_BACK, "GUIHuongDan_BtnQuayLai", 500, 543);
			buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 751, 42);
			buttonClose.setTooltipText("Thoát hướng dẫn");
			
			checkInvisibleBg();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_KNOWN:
					Hide();
					break;
				case BTN_NEXT:
					indexBg++;
					checkInvisibleBg();
					break;
				case BTN_BACK:
					indexBg--;
					checkInvisibleBg();
					break;
				case BTN_CLOSE:
					Hide();
					break;
			}
		}
		
		private function checkInvisibleBg():void
		{
			if (indexBg == 1)
			{
				bgHelp_4.img.visible = false;
				bgHelp_3.img.visible = false;
				bgHelp_2.img.visible = false;
				bgHelp_1.img.visible = true;
				
				buttonNext.img.visible = true;
				buttonNext.SetPos(380, 543);
				buttonBack.img.visible = false;
				buttonKnown.img.visible = false;
			}
			else if (indexBg == 2)
			{
				bgHelp_4.img.visible = false;
				bgHelp_3.img.visible = false;
				bgHelp_2.img.visible = true;
				bgHelp_1.img.visible = false;
				
				buttonNext.img.visible = true;
				buttonNext.SetPos(450, 543);
				buttonBack.img.visible = true;
				buttonBack.SetPos(290, 543);
				buttonKnown.img.visible = false;
			}
			else if (indexBg == 3)
			{
				bgHelp_4.img.visible = false;
				bgHelp_3.img.visible = true;
				bgHelp_2.img.visible = false;
				bgHelp_1.img.visible = false;
				
				buttonNext.img.visible = true;
				buttonNext.SetPos(450, 543);
				buttonBack.img.visible = true;
				buttonBack.SetPos(290, 543);
				buttonKnown.img.visible = false;
			}
			else if (indexBg == 4)
			{
				bgHelp_4.img.visible = true;
				bgHelp_3.img.visible = false;
				bgHelp_2.img.visible = false;
				bgHelp_1.img.visible = false;
				
				buttonNext.img.visible = false;
				buttonBack.img.visible = true;
				buttonBack.SetPos(290, 543);
				buttonKnown.img.visible = true;
				buttonKnown.SetPos(450, 543);
			}
		}
		
		override public function OnHideGUI():void 
		{
			
		}
		
	}
}