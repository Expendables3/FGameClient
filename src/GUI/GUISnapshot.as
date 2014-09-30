package GUI 
{
	import com.adobe.images.JPGEncoder;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.geom.Point;
	import flash.text.TextField;
	import GameControl.GameController;
	import GUI.component.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendPostPicture;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUISnapshot extends BaseGUI
	{
		private static const BUTTON_CLOSE:String = "ButtonClose";
		private static const BUTTON_FULL_SCREEN:String = "ButtonFullScreen";
		private static const BUTTON_CURRENT_SCREEN:String = "ButtonCurrentScreen";
		private static const BUTTON_POST:String = "ButtonPost";
		
		private const PERCENT:int = 1;
		private var DELTA_Y:int = 0;
		private var DELTA_Y_TEXT:int = 0;
		private var DELTA_X_TEXT:int = 0;
		private const NUM_STAR:int = 20;
		private static const TEXTBOX:String = "TextBox";
		
		// Ảnh chụp
		private var bmpDataFullScreen:BitmapData;
		private var bmpDataScreen:BitmapData;
		private var imgPreview:Image;
		private var bmData:BitmapData;
		private var bmDataCur:BitmapData;
		private var bmDataFull:BitmapData;
		private var textBox:TextBox;
		
		// Dữ liệu
		private var encoder:JPGEncoder;
		public var pict:ByteArray;
		private var curBmpData:BitmapData;
		private var bm:Bitmap;
		private var playEff:int = NO_EFF;
		public var ExpNeed:int = -1;
		private var isReceive:Boolean = false;
		private const PLAYING_EFF:int = 1;
		private const NO_EFF:int = 0;
		private const END_EFF:int = 2;
		private var TokenObj:Object;
		private var AppId:int;
		private var Username:String;
		private var text:String;
		
		private var isFul:Boolean;
		
		public function GUISnapshot(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			x = 240;
			y = 800;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISnapshot";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(130, 50);
				if(!GameController.getInstance().isSmallBackGround)
				{
					RefreshComponent(isFul);
				}
				else
				{
					RefreshComponent(false);
				}
			}
			
			LoadRes("GuiSnapshot" + GetTypeBg() + "_Theme");
		}
	
		public function GetTypeBg():String
		{
			var st:String = "";
			var user:User = GameLogic.getInstance().user;
			var maxSnap:int = ConfigJSON.getInstance().GetItemList("Param")["MaxTimesTakePicture"];
			if (!Ultility.CheckDate(user.GetMyInfo().LastPictureTime))
			{
				user.GetMyInfo().NumTakePictureTime = 0;
			}
			if(user.GetMyInfo().NumTakePictureTime < maxSnap)
			{
				DELTA_Y = 15;
				DELTA_X_TEXT = -110;
				DELTA_Y_TEXT = 40;
				st = "_HaveGift";	
			}
			else 
			{
				DELTA_X_TEXT = 0;
				DELTA_Y_TEXT = 0;
				DELTA_Y = 0;
			}
			
			return st;
		}
		
		public function Init(isFull:Boolean = true):void
		{
			isFul = isFull;
			Show(Constant.GUI_MIN_LAYER, 3);
		}

		public function Snapshot(isFull:Boolean):void
		{
			var guiLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			guiLayer.visible = false;
			var root:Sprite = Main.imgRoot;
			bmDataCur = new BitmapData(root.scrollRect.width, root.scrollRect.height - 20);
			bmDataCur.draw(root);
			
			if (isFull)
			{
				var bgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				//thay scrollrect để chụp toàn màn hình
				var oldRect:Rectangle = root.scrollRect;
				root.scrollRect = new Rectangle(bgLayer.x, bgLayer.y, bgLayer.width - bgLayer.x, bgLayer.width - bgLayer.y - 20);
				bmData = new BitmapData(bgLayer.width, bgLayer.height - 20);
				bmData.draw(root);
				root.scrollRect = new Rectangle(oldRect.x, oldRect.y, oldRect.width, oldRect.height);
				bmDataFull = bmData;
			}
			else
			{
				bmData = new BitmapData(root.scrollRect.width, root.scrollRect.height - 20);
				bmData.draw(root);
			}
			
			guiLayer.visible = true;
			bm = new Bitmap(bmData);			
			//this.img.parent.addChild(bm);
			this.img.addChild(bm);
			
			var width:int;
			if (isFull)
			{
				bm.x = 192 - 130;
				bm.y = 165 + DELTA_Y - 50;
				width = 302;			
			}
			else
			{
				bm.x = 198 - 130;
				bm.y = 138 + DELTA_Y - 50;
				width = 290;
			}
			
			var scale:Number = width / bm.width;
			bm.scaleX = bm.scaleY = scale;
		}
		
		public function RefreshComponent(isFull:Boolean):void
		{
			if (bm)	this.img.removeChild(bm);
			ClearComponent();
			Snapshot(isFull);
			AddButtons(isFull);
			
			textBox = AddTextBox(TEXTBOX, "myFish của tôi ^x^\nhttp://me.zing.vn/apps/fish", 175 + DELTA_X_TEXT, 323 + DELTA_Y + DELTA_Y_TEXT, 270, 60);
			textBox.textField.wordWrap = true;
			textBox.textField.maxChars = 150;
			textBox.textField.textColor = 0x000000;
			
			var tF:TextFormat = new TextFormat("Arial", 15, 0x000000, true);
			textBox.textField.setTextFormat(tF);
			if (!Ultility.CheckDate(GameLogic.getInstance().user.GetMyInfo().LastPictureTime))
			{
				GameLogic.getInstance().user.GetMyInfo().NumTakePictureTime = 0;
			}
		}
		
		private function AddButtons(isFull:Boolean):void
		{
			AddButton(BUTTON_CLOSE, "BtnThoat", 540, 21, this);
			if (GetTypeBg() != "")
			{
				AddButton(BUTTON_POST, "GuiSnapshot_BtnSnapshot", 230, 460, this);
				var imgBgGift:Image = AddImage("ImgBgGift", "GuiSnapshot_CtnGiftUpgrade", 440, 400);
				var imgGift:Image = AddImage("Gift", "GuiSnapshot_IcExp", 440, 385);
				imgGift.FitRect(imgBgGift.img.width, imgBgGift.img.height, new Point(imgBgGift.CurPos.x - 35, imgBgGift.CurPos.y - 35));
				ExpNeed = Math.ceil(ConfigJSON.getInstance().getUserLevelExp(GameLogic.getInstance().user.GetLevel()) * PERCENT / 100);
				if (GameLogic.getInstance().isMonday())
				{
					ExpNeed *= ConfigJSON.getInstance().getItemInfo("HappyWeekDay",1)["takePhotoExpRate"];
				}
				
				var lbExp:TextField = AddLabel("x" + ExpNeed, 400, 440, 0xFFFF00, 1, 0x26709C);
				var txtFormat:TextFormat = new TextFormat("Arial", 16, 0x42DFFF);
				txtFormat.bold = true;
				txtFormat.color = 0x42DFFF;
				txtFormat.size = 18;
				lbExp.setTextFormat(txtFormat);
			}
			else 
			{
				AddButton(BUTTON_POST, "GuiSnapshot_BtnSnapshot", 230, 395, this);
			}
			if (isFull)
			{
				//btnFullScreen.SetDisable();
				AddImage("", "GuiSnapshot_ImgPointerFull", 430, 245 + DELTA_Y);
			}
			else
			{
				//btnCurScreen.SetDisable();
				AddImage("", "GuiSnapshot_ImgPointerNormal", 430, 150 + DELTA_Y);
			}
			//var btnCurScreen:Button = AddButton(BUTTON_CURRENT_SCREEN, "BtnNormalScreen", 410, 123 + DELTA_Y, this);
			//var btnFullScreen:Button = AddButton(BUTTON_FULL_SCREEN, "BtnFullScreen", 410, 218 + DELTA_Y, this);
			var ctnCurScreen:Container = AddContainer(BUTTON_CURRENT_SCREEN, "GuiSnapshot_ImgFrameFriend", 408, 124 + DELTA_Y, true, this);
			var newBmCur:Bitmap = new Bitmap(bmDataCur);
			var scaleCur:Number = 72 / newBmCur.width;
			ctnCurScreen.img.addChild(newBmCur);
			newBmCur.scaleX = newBmCur.scaleY = scaleCur;
			//ctnCurScreen.AddImage("", "ImgPointerFull", 0, 0);
			
			if (!GameController.getInstance().isSmallBackGround)
			{
				var ctnFullScreen:Container = AddContainer(BUTTON_FULL_SCREEN, "GuiSnapshot_ImgFrameFriend", 410, 218 + DELTA_Y, true, this);
				var newBmFull:Bitmap = new Bitmap(bmDataFull);
				var scaleFull:Number = 68 / newBmFull.width;
				ctnFullScreen.img.addChild(newBmFull);
				newBmFull.y = 10;
				newBmFull.scaleX = newBmFull.scaleY = scaleFull;
			}
			//ctnFullScreen.AddImage("", "ImgPointerFull", 0, 0);
			
			
		}

		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BUTTON_CLOSE:
					Hide();
					break;
				case BUTTON_CURRENT_SCREEN:
					RefreshComponent(false);
					break;
				case BUTTON_FULL_SCREEN:
					RefreshComponent(true);
					break;
				case BUTTON_POST:
					//var bmp:BitmapData = new BitmapData(200, 200, false);
					//bmp.draw(img);
					//pict = encoder.encode(bmp);
					
					var isCanPost:Boolean = canCapture();
					if (isCanPost)
					{
						GetButton(BUTTON_POST).SetDisable();
						var cmd:SendPostPicture = new SendPostPicture();
						Exchange.GetInstance().Send(cmd);
						playEff = PLAYING_EFF;
						isReceive = false;
						//EffectMgr.getInstance().AddSwfEffect(Constant.ACTIVE_LAYER, "EffSnapshot", null, 515, 330, false, false, null, HideGUI);
						EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiSnapshot_EffSnapshot", null, 260, 170, false, false, null, HideGUI);
					}
					else
					{
						var str:String = "Sau @time mới được đăng tiếp!";
						var time:int = GameLogic.getInstance().CurServerTime - GameLogic.getInstance().user.GetMyInfo().LastPictureTime;
						var min:int = 30 - Math.floor(time / 60);
						if (min > 0)
						{
							str = str.replace("@time", min + " phút");
						}
						else
						{
							str = str.replace("@time", "1 phút");
						}
						GuiMgr.getInstance().GuiMessageBox.ShowOK(str);
						
					}
					break;
			}
		}
		private function HideGUI():void 
		{
			playEff = END_EFF;
			//uploadPicture(TokenObj, AppId, Username);
		}
		private function canCapture():Boolean
		{
			var user:User = GameLogic.getInstance().user;
			if (user.GetMyInfo().LastPictureTime == 0)
			{
				return true;
			}
			var lastTime:Number = user.GetMyInfo().LastPictureTime;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var period:Number = 30 * 60;
			var curPeriod:Number = curTime - lastTime;
			if (curPeriod > period)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function update():void 
		{
			if (playEff == END_EFF && isReceive)
			{
				playEff = NO_EFF;
				isReceive = false;
				Hide();
				//hien messagebox gui thanh cong
				//GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã đăng ảnh thành công");
				//EffectMgr.getInstance().fallFlyXP(Constant.MAX_WIDTH / 2 + Constant.STAGE_WIDTH / 2 * ( 2 * Math.random() - 1), GameController.getInstance().GetLakeBottom() - 50 * Math.random(), ExpNeed, true);
				EffectMgr.getInstance().fallFlyEXPToNumStar(ExpNeed, NUM_STAR);
				uploadPicture(TokenObj, AppId, Username);
				GameLogic.getInstance().user.GetMyInfo().NumTakePictureTime++;
				if(GetTypeBg() == "")
				{
					//GuiMgr.getInstance().GuiTopInfo.imgSnapshot.img.visible = false;
					GuiMgr.getInstance().guiFrontScreen.imgSnapshot.img.visible = false;
				}
				else 
				{
					//GuiMgr.getInstance().GuiTopInfo.imgSnapshot.img.visible = true;
					GuiMgr.getInstance().guiFrontScreen.imgSnapshot.img.visible = true;
				}
			}
		}
		
		public function updateData(tokenObj:Object, appId:int, username:String):void
		{
			TokenObj = tokenObj;
			AppId = appId;
			Username = username;
			text = textBox.GetText();
			isReceive = true;
		}
		
		public override function OnHideGUI():void
		{
			bm = null;
		}
		
		public function uploadPicture(tokenObj:Object, appId:int, username:String):void
		{
			encoder = new JPGEncoder();
			var user:User = GameLogic.getInstance().user;
			var pict:ByteArray = encoder.encode(bmData);
			var AddVariable:URLVariables = new URLVariables();
			//EffectMgr.getInstance().AddSwfEffect(Constant.ACTIVE_LAYER, "EffSnapshot", null, 515, 330, false, false, null, HideGUI);
			AddVariable.userid = user.Id;
			//AddVariable.username = user.GetMyInfo().Username;
			AddVariable.username = username;
			AddVariable.token = String(tokenObj);
			AddVariable.app_id = appId;
			AddVariable.description = text;
			
			//trace(username);
			
			var url:String = "http://upload-photo.apps.zing.vn/api/uploadGame/";
			url += username + "?" + AddVariable.toString();
			
			var aURLRequest:URLRequest = new URLRequest(url);
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			aURLRequest.requestHeaders.push(header);
			aURLRequest.method = URLRequestMethod.POST;
			aURLRequest.data = pict;
			
			var aURLLoader:URLLoader = new URLLoader();
			aURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			aURLLoader.addEventListener(IOErrorEvent.IO_ERROR, sieuduce);
			
			aURLLoader.addEventListener(Event.COMPLETE, sieuduc);
			aURLLoader.load(aURLRequest);
			
			function sieuduc(e:Event):void 
			{
				trace(e.currentTarget.data);
			}
			
			function sieuduce(e:Event):void 
			{
				trace(e.currentTarget.data);
			}	
			
			//Cập nhật thời gian chụp ảnh
			user.GetMyInfo().LastPictureTime = GameLogic.getInstance().CurServerTime;
			//TokenObj = new Object();
			//AppId = 0;
			//Username = "";
			//this.Hide();
			//var myInfo:UserInfo = ModuleMgr.getInstance().doFunction(ModuleMgr.MAIN_GET_USER_INFO, true);
			//myInfo.userProfile.lastTakePicture =  ModuleMgr.getInstance().doFunction(ModuleMgr.CURRENT_TIME);;
		}

	}

}