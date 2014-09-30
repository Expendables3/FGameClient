package GUI.Mail.SystemMail.View 
{
	import Data.Localization;
	import Data.ResMgr;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiMgr;
	import GUI.Mail.SystemMail.Controller.MailMgr;
	import GUI.Mail.SystemMail.Model.MailInfo;
	import Logic.GameLogic;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUISystemMail extends BaseGUI 
	{
		// const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		//private const ID_BTN_DELETE_ALL:String = "idBtnDeleteAll";
		private const CMD_DEL_FAST:String = "cmdDelFast";
		private const CMD_READ:String = "cmdRead";
		private const HEIGHT_LETTER:int = 66;
		
		// logic
		
		// gui
		private var listSystemMail:Array = [];
		//private var btnDelAll:Button;
		private var _scroll:ScrollPane = new ScrollPane();
		private var _content:Sprite = new Sprite();
		private var guiReadSysMail:GUIReadSystemMail = new GUIReadSystemMail(null, "");
		
		public function GUISystemMail(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUISystemMail";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				GameLogic.getInstance().BackToIdleGameState();
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				OpenRoomOut();
				//GuiMgr.getInstance().GuiTopInfo.btnSystemMail.SetBlink(false);
				GuiMgr.getInstance().guiFrontScreen.btnMail.SetBlink(false);
			}
			LoadRes("GuiNewMail_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			refreshComponent();
		}
		
		public function refreshComponent():void
		{
			removeAllItemMail();
			addBgr();
			if (MailMgr.getInstance().ListSystemMail.length == 0)
			{
				//btnDelAll.SetEnable(false);
				addEmptyMsg();
			}
			else
			{
				//btnDelAll.SetEnable(true);
				initScroll();
				addAllItemMail();
			}
		}
		
		private function addBgr():void
		{
			var width:int = this.img.width;
			var height:int = this.img.height;
			
			AddImage("", "GuiNewMail_LblHomThu", width / 2, 32);
			AddButton(ID_BTN_CLOSE, "BtnThoat", 411, 19);
			//btnDelAll = AddButton(ID_BTN_DELETE_ALL, "GuiNewMail_BtnDeleteAll", 50, height - 50);
		}
		
		private function addEmptyMsg():void
		{
			_scroll.visible = false;
			
			var formatter:TextFormat = new TextFormat( );					
			formatter.size = 18;
			formatter.font = "Arial";
			
			var txt: String = Localization.getInstance().getString("GUILabel11");
			AddLabel(txt, 175, 150, 0x604220).setTextFormat(formatter);				
		}
		
		private function addAllItemMail():void
		{
			var iLength:int = MailMgr.getInstance().ListSystemMail.length;
			var i:int;
			var y:int = 10, dy:int = 28;
			for (i = 0; i < iLength; i++)
			{
				var mail:MailInfo = MailMgr.getInstance().getMailByIndex(i);
				addItemMail(mail, y);
				y += (HEIGHT_LETTER + dy);
			}
			_scroll.source = _content;
		}
		
		private function addItemMail(mail:MailInfo,y:int):void
		{
			var itmMail:ItemMail = new ItemMail(_content, "KhungFriend", 93, y);
			itmMail.initData(mail);
			itmMail.drawItemMail(this);
			listSystemMail.push(itmMail);
		}
		
		private function initScroll():void
		{//tạm thời để đó, chưa chỉnh vội
			_scroll.visible = true;
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 200, 200);
			bg.graphics.endFill();
			_scroll.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiNewMail_ImgUpArrowNone") as Sprite;
			var over: Sprite = ResMgr.getInstance().GetRes("GuiNewMail_ImgUpArrowOver") as Sprite;
			_scroll.setStyle("upArrowUpSkin", up);
			_scroll.setStyle("upArrowDownSkin", up);
			_scroll.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiNewMail_ImgDownArrowNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiNewMail_ImgDownArrowOver") as Sprite;
			_scroll.setStyle("downArrowUpSkin", up);
			_scroll.setStyle("downArrowDownSkin", up);
			_scroll.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiNewMail_ImgTrackBarNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiNewMail_ImgTrackBarOver") as Sprite;
			_scroll.setStyle("thumbUpSkin", up);
			_scroll.setStyle("thumbDownSkin", up);
			_scroll.setStyle("thumbOverSkin", over);
			_scroll.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiNewMail_BtnKhungKeo") as Sprite;
			_scroll.setStyle("trackUpSkin", up);
			_scroll.setStyle("trackDownSkin", up);
			_scroll.setStyle("trackOverSkin", up);
			
			_scroll.setSize(450, (HEIGHT_LETTER+28) * 3 + 6);
			_scroll.verticalScrollBar.setScrollPosition(0);
			_scroll.horizontalScrollBar.visible = false;
			
			img.addChild(_scroll);
			_scroll.x = -35;
			_scroll.y = 68;//100;
			_scroll.horizontalScrollBar.visible = false;
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				//case ID_BTN_DELETE_ALL:
					//deleteAllMail();
				break;
				case CMD_DEL_FAST:
					delFastMail((int)(data[1]));
				break;
				case CMD_READ:
					readMail((int)(data[1]));
				break;
			}
		}
		
		//public function deleteAllMail():void
		//{
			//MailMgr.getInstance().delAllMail();
		//}
		
		public function delFastMail(id:int):void
		{
			//MailMgr.getInstance().deleteMail(id);
			GuiMgr.getInstance().GuiMessageBox.ShowDeleteSystemMail("Bạn có muốn xóa thư hệ thống này không?", id);
			//refreshComponent();
		}
		public function readMail(id:int):void
		{
			//trace("đọc chi tiết thư có id = " + id);
			MailMgr.getInstance().readSystemMail(id);
			var mail:MailInfo = MailMgr.getInstance().getMailById(id);
			mail.IsRead = true;
			guiReadSysMail.initData(mail.clone());
			guiReadSysMail.Show(Constant.GUI_MIN_LAYER, 5);
		}
		private function removeAllItemMail():void
		{
			for (var i:int = 0; i < listSystemMail.length; i++)
			{
				var itemMail:ItemMail = listSystemMail[i] as ItemMail;
				itemMail.Destructor();
			}
			listSystemMail.splice(0, listSystemMail.length);
		}
		
		private function removeItemMail(id:String):void
		{
			for (var i:int = 0; i < listSystemMail.length; i++)
			{
				var itemMail:ItemMail = listSystemMail[i] as ItemMail;
				if (itemMail.IdObject == id)
				{
					itemMail.Destructor();
					listSystemMail.splice(i, 1);
					break;
				}
			}
		}
	}

}


























