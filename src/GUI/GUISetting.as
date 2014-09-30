package GUI 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import Data.Localization;
	import Data.ResMgr;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import Sound.SoundMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class GUISetting extends BaseGUI 
	{
		private const GUI_SETTING_MUSIC:String = "ButtonMusic";
		private const GUI_SETTING_SOUND:String = "ButtonSound";
		private const GUI_SETTING_ZOOM:String = "ButtonZoom";
		private const GUI_SETTING_CAMERA:String = "ButtonCamera";
		private const GUI_SETTING_SETTING:String = "ButtonSetting";
		
		public var IsMute:Boolean = false;
		public var IsNoMusic:Boolean = false;
		private var imgSOff:Image = null;
		private var imgMOff:Image = null;
		
		private var hidePos:Point = new Point(-13, -148);
		private var showPos:Point = new Point( -13, -45);
		private var isInHidePos:Boolean = true;
		private var isMoving:Boolean = false;
		private var ctn:Container;
		
		
		private var MaskClip:MovieClip;
		public var isShow:Boolean = false;
		
		public function GUISetting(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISetting";
		}
		
		public override function InitGUI(): void
		{
			LoadRes("ImgFrameFriend");
			ctn = AddContainer("GuiBG", "GuiSetting", hidePos.x, hidePos.y, true, this);
			var tip:TooltipFormat;
			var btnSound:ButtonEx = ctn.AddButtonEx(GUI_SETTING_SOUND, "BtnExSound", 14, 98, this);
			var btnMusic:ButtonEx = ctn.AddButtonEx(GUI_SETTING_MUSIC, "BtnExMusic", 14, 72, this);
			var btnCamera:ButtonEx = ctn.AddButtonEx(GUI_SETTING_CAMERA, "BtnExCamera", 14, 47, this);
			var btnFull:ButtonEx = ctn.AddButtonEx(GUI_SETTING_ZOOM, "BtnExZoom", 15, 22, this);
			
			MaskClip = new MovieClip();
			MaskClip.graphics.beginFill(0xFF0000,1);
			MaskClip.graphics.drawRect(-13, -47 , 30, 150);
			MaskClip.graphics.endFill();
			this.img.addChild(MaskClip);
			GetContainer("GuiBG").img.mask = MaskClip;

			//var btnSetting:Button = AddButton("Setting", "BtnSetting", img.stage.width - 45, 5, this);
			var btnSetting:Button = AddButton(GUI_SETTING_SETTING, "BtnSetting", -14, -67, this);
			//btnCamera.SetEnable(false);
			
			tip = new TooltipFormat();
			tip.text = Localization.getInstance().getString("Tooltip31");
			btnFull.setTooltip(tip);
			tip = new TooltipFormat();
			tip.text = Localization.getInstance().getString("Tooltip32");
			btnCamera.setTooltip(tip);
			tip = new TooltipFormat();
			tip.text = Localization.getInstance().getString("Tooltip33");
			btnMusic.setTooltip(tip);
			tip = new TooltipFormat();
			tip.text = Localization.getInstance().getString("Tooltip34");
			btnSound.setTooltip(tip);			
			
			var arr:Array = SoundMgr.getInstance().GetSoundSetting();
			if (arr["music"] == "off")
			{
				imgMOff = ctn.AddImage("", "ImgOff", 24, 79);
				imgMOff.img.mouseEnabled = false;
				imgMOff.img.mouseChildren = false;
				IsNoMusic = true;
			}
			else
			{
				ctn.RemoveImage(imgMOff);
				IsNoMusic = false;
			}
			
			if (arr["sound"] == "off")
			{
				imgSOff = ctn.AddImage("", "ImgOff", 23, 105);
				imgSOff.img.mouseEnabled = false;
				imgSOff.img.mouseChildren = false;
				IsMute = true;
			}
			else
			{
				ctn.RemoveImage(imgSOff);
				IsMute = false;
			}
			SetPos(Constant.STAGE_WIDTH - 27 - 52, 76);
			LastX = img.x;
			LastY = img.y;
		}
		
		public function ShowGui():void
		{
			isMoving = !isMoving;
			TweenLite.to(ctn.img, 1, { x:showPos.x, y:showPos.y , ease:Sine.easeOut  } );
			isInHidePos = !isInHidePos;
		}
		
		public function HideGui():void
		{
			isMoving = !isMoving;
			TweenLite.to(ctn.img, 0.6, { x:hidePos.x, y:hidePos.y , ease:Sine.easeOut } );
			isInHidePos = !isInHidePos;
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_SETTING_SETTING:
				case "GuiBG":
					if (isMoving)	
					break;
					else if (isInHidePos)
						ShowGui();
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_SETTING_SETTING:
				case "GuiBG":
					if (!isInHidePos)
						HideGui();
					break;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_SETTING_SOUND:
					IsMute = SoundMgr.getInstance().IsMute;
					IsMute = !IsMute;
					SoundMgr.getInstance().MuteSound(IsMute);
					if (IsMute)
					{
						RemoveImage(imgSOff);
						imgSOff = ctn.AddImage("", "ImgOff", 23, 105);
						imgSOff.img.mouseEnabled = false;
						imgSOff.img.mouseChildren = false;
					}
					else
					{
						ctn.RemoveImage(imgSOff);
					}
					break;
					
				case GUI_SETTING_MUSIC:
					IsNoMusic = !IsNoMusic;
					if (IsNoMusic)
					{		
						RemoveImage(imgMOff);
						imgMOff = ctn.AddImage("", "ImgOff", 24, 79);
						imgMOff.img.mouseEnabled = false;
						imgMOff.img.mouseChildren = false;
						SoundMgr.getInstance().stopBgMusic();
					}
					else
					{						
						ctn.RemoveImage(imgMOff);
						if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
						{
							SoundMgr.getInstance().playBgMusic();
						}
						else
						{
							SoundMgr.getInstance().playBgMusic(SoundMgr.MUSIC_WAR);
						}
					}
					break;
				case GUI_SETTING_ZOOM:
					if (Ultility.IsInMyFish() && GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR && !GameController.getInstance().isSmallBackGround)
					{
						SetScreen();
					}
					if (GameController.getInstance().isSmallBackGround)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message39"));
					}
					break;
				case GUI_SETTING_CAMERA:
					if (!Ultility.IsInMyFish())		break;
					if (GameLogic.getInstance().user.IsViewer())	break;
					ActiveTooltip.getInstance().clearToolTip();
					if (img.stage.displayState == StageDisplayState.FULL_SCREEN)
						SetScreen();
					GuiMgr.getInstance().GuiSnapshot.Init();
					break;				
			}
		}
		
		private function Snapshot():void 
		{
			var bgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			//trace("bgLayer.width, bgLayer.height", bgLayer.width, bgLayer.height)
			
			var guiLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			guiLayer.visible = false;
			var root:Sprite = Main.imgRoot;	
			root.scrollRect = new Rectangle(0, 0, bgLayer.width, bgLayer.width);
			var bmData:BitmapData = new BitmapData(bgLayer.width, bgLayer.height);
			bmData.draw(root);
			guiLayer.visible = true;
			//root.scrollRect = new Rectangle(0, 0, bgLayer.width, bgLayer.width);
			var bm:Bitmap = new Bitmap(bmData);
			this.img.parent.addChild(bm);
			bm.x = 100;
			bm.y = 100;
			bm.scaleX = bm.scaleY = 0.5;
		}
		
		private function SetScreen():void 
		{
			if (Main.imgRoot.stage.displayState != StageDisplayState.FULL_SCREEN)
			{	
				img.stage.scaleMode = StageScaleMode.NO_SCALE;
				img.stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{				
				img.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public override function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void
		{			
			//super.Fullscreen(IsFull, dx, dy);
			if (!IsFull)
			{
				img.x = LastX;
				img.y = LastY
			}
			else
			{
				LastX = img.x;
				LastY = img.y;
				var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				img.x += dx;
				img.y = BgLayer.y + 70;
			}
		}
	}
}