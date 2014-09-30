package GUI.TrungLinhThach 
{
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
	import GUI.component.TooltipFormat;
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
	public class GUIToolBar extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_WARE_ROOM:String = "btnWareRoom";
		static public const BTN_HELP:String = "btnHelp";
		
		public var buttonClose:Button;
		public var buttonWareRoom:Button;
		public var buttonHelp:Button;
		
		public function GUIToolBar(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes(""); 
			//setImgInfo = function f():void
			{
				SetPos(0, 0);
				
				buttonClose = AddButton(BTN_CLOSE, "GuiTrungLinhThach_BtnGoHome", 760, 0);
				buttonClose.setTooltipText("Trở về nhà");
				
				buttonHelp = AddButton(BTN_HELP, "GuiTrungLinhThach_BtnHelp", 720, 6);
				buttonHelp.setTooltipText("Hướng dẫn");
			
				buttonWareRoom = AddButton(BTN_WARE_ROOM, "GuiTrungLinhThach_BtnWareRoom", 650, 8);
				buttonWareRoom.setTooltipText("Kho huy hiệu");
			}
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					if (!Constant.SMASH_EGG_EFF)
					{
						Hide();
					}
					break;
				case BTN_HELP:
					if (!Constant.SMASH_EGG_EFF)
					{
						GuiMgr.getInstance().guiHuongDan.showGUI();
					}
					break;
				case BTN_WARE_ROOM:
					if (!Constant.SMASH_EGG_EFF)
					{
						GuiMgr.getInstance().guiWareRoomLinhThach.Show();
						GuiMgr.getInstance().guiTrungLinhThach.ClearItemBonus();
					}
					break;
			}
		}
		
		override public function OnHideGUI():void 
		{
			//trace("OnHideGUI");
			GuiMgr.getInstance().guiTrungLinhThach.Hide();
		}
		
	}
}